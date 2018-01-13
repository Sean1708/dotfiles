local awful = require('awful')
local beautiful = require('beautiful')
local gears = require('gears')
local naughty = require('naughty')
local wibox = require('wibox')


local function trim(s)
	-- NOTE: Example `trim6` from `https://lua-users.org/wiki/StringTrim`.
	return s:find("^%s*$") and "" or s:match("^%s*(.*%S)")
end

local function info(supply, variable)
	local dir = string.format('/sys/class/power_supply/%s/', supply)
	local file = assert(io.open(dir .. variable))
	local ret = string.lower(trim(file:read('a')))
	file:close()
	return ret
end


local batteries = {}
local n = 0
local total_capacity = 0
for supply in assert(io.popen('ls /sys/class/power_supply')):lines() do
	if info(supply, 'type') == 'battery' then
		local capacity = tonumber(info(supply, 'energy_full'))
		batteries[supply] = {
			manufacturer = info(supply, 'manufacturer'),
			model = info(supply, 'model_name'),
			capacity = capacity,
		}
		total_capacity = total_capacity + capacity
		n = n + 1
	end
end
setmetatable(batteries, { __len = function () return n end })


local bar
do
	local progress = wibox.widget {
		widget = wibox.widget.progressbar,

		min_value = 0,
		max_value = 100,
		value = nil,

		forced_width = 50,
		paddings = 1,
	}

	function progress:update(charge)
		local colour
		if charge < 20 then
			colour = '#ff0000'  -- Red
		elseif charge < 50 then
			colour = '#ffff00'  -- Yellow
		else
			colour = '#00ff00'  -- Green
		end

		self.value = charge
		self.color = colour
	end

	-- TODO: Replace this with icons.
	local text = wibox.widget {
		widget = wibox.widget.textbox,

		text = nil,
		align = 'center',
	}

	function text:update(charge)
		self.text = string.format('%.1f', charge) .. '%'
	end

	bar = wibox.widget {
		progress,
		text,

		layout = wibox.layout.stack,
	}
	bar.progress = progress
	bar.text = text

	function bar:update(charge)
		self.progress:update(charge)
		self.text:update(charge)
	end
end


local popup
do
	local columns = {}
	for id, info in pairs(batteries) do
		local header = wibox.widget {
			widget = wibox.widget.textbox,

			text = string.format('%s: %s(%s)', id, string.upper(info.manufacturer), info.model),
		}


		local status = wibox.widget {
			widget = wibox.widget.textbox,

			text = nil,
		}

		function status:update(status)
			self.text = string.upper(status)
		end


		local progress = wibox.widget {
			widget = wibox.widget.progressbar,

			min_value = 0,
			max_value = 100,
			value = nil,

			-- NOTE: Changing the value of `forced_width` doesn't seem to have any effect, but omitting it makes things fucky.
			forced_width = 50,
			forced_height = 1.5 * beautiful.get_font_height(),
			paddings = 1,
		}

		function progress:update(charge)
			local colour
			if charge < 20 then
				colour = '#ff0000'  -- Red
			elseif charge < 50 then
				colour = '#ffff00'  -- Yellow
			else
				colour = '#00ff00'  -- Green
			end

			self.value = charge
			self.color = colour
		end


		local percent = wibox.widget {
			widget = wibox.widget.textbox,

			text = nil,

			align = 'center',
		}

		function percent:update(charge)
			self.text = string.format('%.1f', charge) .. '%'
		end


		local charge = wibox.widget {
			progress,
			percent,

			layout = wibox.layout.stack,
		}
		charge.progress = progress
		charge.percent = percent

		function charge:update(charge)
			self.progress:update(charge)
			self.percent:update(charge)
		end


		-- TODO: Make this an actual button that does stuff.
		local button = wibox.widget {
			widget = wibox.widget.textbox,

			text = 'Calibrate...',
		}


		local column = wibox.widget {
			header,
			status,
			charge,
			button,

			layout = wibox.layout.fixed.vertical,
			spacing = 5,
		}
		column.id = id
		column.header = header
		column.status = status
		column.charge = charge
		column.button = button

		function column:update(battery)
			self.charge:update(battery.charge)
			self.status:update(battery.status)
		end


		table.insert(columns, column)
	end

	table.sort(columns, function (l, r) return l.id < r.id end)

	function columns:update(batteries)
		for _, column in ipairs(self) do
			column:update(batteries[column.id])
		end
	end


	popup = wibox {
		ontop = true,
		border_width = 5,
		widget = wibox.widget(gears.table.join(columns, {
			layout = wibox.layout.fixed.horizontal,
			spacing = 10,
		})),
	}
	popup.columns = columns

	function popup:update(batteries)
		self.columns:update(batteries)
	end

	function popup:draw()
		local screen = awful.screen.focused()

		local width, height = wibox.widget.base.fit_widget(
			self.widget,
			{ screen = screen, dpi = beautiful.xresources.get_dpi(screen) },
			self.widget,
			screen.workarea.width,
			screen.workarea.height)

		-- NOTE: Subtracting 10 fixes clipping due to border.
		-- TODO: Fix it in a better way.
		local x = screen.workarea.x + screen.workarea.width - width - 10
		local y = screen.workarea.y

		self:geometry {
			height = height,
			width = width,
			x = x,
			y = y,
		}
	end

	function popup:toggle()
		self:draw()
		self.visible = not self.visible
	end

	popup:buttons(gears.table.join(
		awful.button({ }, 1, function (w) w.visible = false end)))
end

local battery = {
	batteries = batteries,
	capacity = total_capacity,
	mode = nil,
	charge = nil,

	bar = bar,
	popup = popup,
}

local notified = false
function battery:update()
	self.mode = 'mains'
	local charge = 0

	for id, status in pairs(self.batteries) do
		status.charge = tonumber(info(id, 'capacity'))
		status.level = info(id, 'capacity_level')
		status.status = info(id, 'status')

		if status.status == 'charging' then
			self.mode = 'charging'
		elseif status.status == 'discharging' then
			self.mode = 'battery'
		end

		charge = charge + status.capacity * status.charge
	end

	self.charge = charge / self.capacity
	if self.charge < 10 and not notified then
		notified = true
		naughty.notify({
			preset = naughty.config.presets.critical,
			title = 'Battery Level Low!',
			text = string.format('Battery is at %.1f%%!', self.charge),
		})
	end

	self.bar:update(self.charge)
	self.popup:update(self.batteries)
end

battery.bar:buttons(gears.table.join(
	awful.button({ }, 1, function () battery.popup:toggle() end)))


battery:update()
gears.timer {
	timeout = 1,
	autostart = true,
	callback = function () battery:update() end,
}


return battery
