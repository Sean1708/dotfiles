-- TODO:
-- Ethernet.
-- EDITOR=cat netctl edit <profile>: To find out whether using wifi or eth.
-- Have a popup showing rfkill output and similar.
local awful = require('awful')
local beautiful = require('beautiful')
local cairo = require('lgi').cairo
local gears = require('gears')
local wibox = require('wibox')


local function wificon(bars, space, size, fg)
	local spaces = bars - 1
	local bar_width = (1 - space) / bars
	local space_width
	if spaces > 0 then
		space_width = space / spaces
	else
		space_width = 0
	end
	local width = bar_width + space_width

	local inner_angle = 2*math.asin(0.5)
	local outer_angle = (math.pi - inner_angle)/2
	local angle_start = math.pi + outer_angle
	local angle_end = angle_start + inner_angle

	local img = cairo.ImageSurface.create(cairo.Format.ARGB32, size, size)
	local ctx = cairo.Context(img)

	ctx:set_source(gears.color(fg))

	for i = 1,bars do
		ctx:move_to(0.5*size, size)

		ctx:rel_move_to(
			-(i-1) * width * math.cos(outer_angle) * size,
			-(i-1) * width * math.sin(outer_angle) * size)

		ctx:arc(0.5 * size, size, (i-1) * width * size, angle_start, angle_end)

		ctx:rel_line_to(
			bar_width * math.cos(outer_angle) * size,
			-bar_width * math.sin(outer_angle) * size)

		ctx:arc_negative(0.5 * size, size, ((i-1) * width + bar_width) * size, angle_end, angle_start)

		ctx:rel_line_to(
			bar_width * math.cos(outer_angle) * size,
			bar_width * math.sin(outer_angle) * size)

		ctx:fill()
	end

	return img
end

local network
do
	local connected = wificon(4, 0.2, beautiful.menu_height, beautiful.bg_focus)
	local disconnected = wificon(4, 0.2, beautiful.menu_height, beautiful.bg_minimize)
	local off = wificon(1, 0.0, beautiful.menu_height, beautiful.bg_focus)

	local bar = wibox.widget {
		image = off,
		resize = true,
		widget = wibox.widget.imagebox,
	}

	function bar:update(status)
		if status == 'connected' then
			self.image = connected
		elseif status == 'disconnected' then
			self.image = disconnected
		else
			self.image = off
		end
	end

	network = {
		status = nil,
		
		bar = bar,
	}

	function network:update()
		assert(awful.spawn.easy_async(
			gears.filesystem.get_configuration_dir() .. 'scripts/network-status.lua',
			function (out)
				local state = loadstring(out)()
				self.status = state.status
				self.bar:update(state.status)
			end))
		end
end


network:update()
gears.timer {
	timeout = 1,
	autostart = true,
	callback = function () network:update() end,
}


return network
