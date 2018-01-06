-- Standard awesome library.
local gears = require("gears")
local awful = require("awful")
require("awful.autofocus")
-- Widget and layout library.
local wibox = require("wibox")
-- Theme handling library.
local beautiful = require("beautiful")
-- Notification library.
local naughty = require("naughty")
local menubar = require("menubar")
local hotkeys_popup = require("awful.hotkeys_popup").widget

-- {{{ Error handling
-- Check if awesome encountered an error during startup and fell back to
-- another config (This code will only ever execute for the fallback config).
if awesome.startup_errors then
	naughty.notify({
		preset = naughty.config.presets.critical,
		title = "Oops, there were errors during startup!",
		text = awesome.startup_errors,
	})
end

-- Handle runtime errors after startup.
do
	local in_error = false
	awesome.connect_signal("debug::error", function (err)
		-- Make sure we don't go into an endless error loop.
		if in_error then return end
		in_error = true

		naughty.notify({
			preset = naughty.config.presets.critical,
			title = "Oops, an error happened!",
			text = tostring(err),
		})

		in_error = false
	end)
end
-- }}}

-- Themes define colours, icons, font and wallpapers.
beautiful.init(gears.filesystem.get_configuration_dir() .. "theme.lua")

-- This is used later as the default terminal and editor to run.
terminal = "konsole"
editor = os.getenv("EDITOR") or "vi"
editor_cmd = terminal .. " -e " .. editor

-- Default modkey.
-- Usually, Mod4 is the key with a logo between Control and Alt.
-- If you do not like this or do not have such a key,
-- I suggest you to remap Mod4 to another key using xmodmap or other tools.
-- However, you can use another modifier like Mod1, but it may interact with others.
modkey = "Mod4"

-- Table of layouts to cover with awful.layout.inc, order matters.
awful.layout.layouts = {
    awful.layout.suit.floating,
    awful.layout.suit.tile,
    -- awful.layout.suit.tile.left,
    -- awful.layout.suit.tile.bottom,
    -- awful.layout.suit.tile.top,
    awful.layout.suit.fair,
    -- awful.layout.suit.fair.horizontal,
    -- awful.layout.suit.spiral,
    -- awful.layout.suit.spiral.dwindle,
    awful.layout.suit.max,
    -- awful.layout.suit.max.fullscreen,
    -- awful.layout.suit.magnifier,
    -- awful.layout.suit.corner.nw,
    -- awful.layout.suit.corner.ne,
    -- awful.layout.suit.corner.sw,
    -- awful.layout.suit.corner.se,
}
-- }}}

-- {{{ Helper functions
local function client_menu_toggle_fn()
    local instance = nil

    return function ()
        if instance and instance.wibox.visible then
            instance:hide()
            instance = nil
        else
            instance = awful.menu.clients({ theme = { width = 250 } })
        end
    end
end

local function trim(s)
	-- NOTE: Example `trim6` from `https://lua-users.org/wiki/StringTrim`.
	return s:find("^%s*$") and "" or s:match("^%s*(.*%S)")
end
-- }}}

-- {{{ Menu
-- Create a launcher widget and a main menu
awesomemenu = {
   { "hotkeys", function () return false, hotkeys_popup.show_help end},
   { "manual", terminal .. " -e man awesome" },
   { "edit config", editor_cmd .. " " .. awesome.conffile },
   { "restart", awesome.restart },
   { "quit", function () awesome.quit() end},
}

mainmenu = awful.menu({
	items = {
		{ "awesome", awesomemenu, beautiful.awesome_icon },
		{ "open terminal", terminal },
	},
})

launcher = awful.widget.launcher({
	image = beautiful.awesome_icon,
	menu = mainmenu,
})

-- Menubar configuration
menubar.utils.terminal = terminal -- Set the terminal for applications that require it
-- }}}

-- {{{ Wibar
-- NOTE: Spaces around the string are far more visually pleasing.
-- TODO: Can the spaces be replaced by padding?
--	- Prob want to spacing between all widgets on right side.
textclock = wibox.widget.textclock(" %a %d %b, %H:%M ")
calendar = awful.widget.calendar_popup.month()
calendar:buttons(gears.table.join(
	awful.button({ }, 1, function () calendar:call_calendar(-1) end),
	awful.button({ }, 2, function () calendar.visible = false end),
	awful.button({ }, 3, function () calendar:call_calendar(1) end)))
calendar:attach(textclock, "tr")

-- TODO: Move into a seperate file.
-- TODO: Notification on low battery.
local battery
do
	local function info(supply, variable)
		local dir = string.format('/sys/class/power_supply/%s/', supply)
		return string.lower(trim(assert(io.open(dir .. variable)):read('a')))
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
	local percent = wibox.widget {
		widget = wibox.widget.textbox,

		text = nil,
		align = "center",
	}

	function percent:update(charge)
		self.text = string.format('%.1f', charge) .. '%'
	end

	local bar = wibox.widget {
		progress,
		percent,

		layout = wibox.layout.stack,
	}
	bar.progress = progress
	bar.percent = percent

	function bar:update(charge)
		self.progress:update(charge)
		self.percent:update(charge)
	end

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

			align = "center",
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

			text = "Calibrate...",
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

	local popup = wibox {
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

	battery = {
		batteries = batteries,
		capacity = total_capacity,
		mode = nil,
		charge = nil,

		-- TODO: When moving this to a new file just use captures, don't worry about putting everything in one table.
		bar = bar,
		popup = popup,
	}

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

		self.bar:update(self.charge)
		self.popup:update(self.batteries)
	end

	battery.bar:buttons(gears.table.join(
		awful.button({ }, 1, function () battery.popup:toggle() end)))


	gears.timer {
		timeout = 30,
		autostart = true,
		callback = function () battery:update() end,
	}
	battery:update()
end

local brightness
do
	local progress = wibox.widget {
		widget = wibox.widget.progressbar,

		min_value = 0,
		max_value = 100,
		value = nil,

		forced_width = 50,
		paddings = 1,
	}

	function progress:update(brightness)
		self.value = brightness
	end

	-- TODO: Make this an icon.
	local text = wibox.widget {
		widget = wibox.widget.textbox,

		text = "BRIGHT",

		align = "center",
	}

	local bar = wibox.widget {
		progress,
		text,

		layout = wibox.layout.stack,
	}
	bar.progress = progress
	bar.text = text

	function bar:update(brightness)
		self.progress:update(brightness)
	end

	brightness = {
		brightness = nil,

		bar = bar,
	}

	function brightness:update()
		assert(awful.spawn.easy_async(
			"xbacklight -get",
			function (out)
				local brightness = tonumber(out)
				self.brightness = brightness
				self.bar:update(brightness)
			end))
	end

	brightness:update()
	assert(awful.spawn.with_line_callback(
		"inotifywait -m -e modify /sys/class/backlight/intel_backlight/actual_brightness",
		{ stdout = function () brightness:update() end }))
end

-- TODO: Volume indicators (progress bar with a symbol overlaid, extra information in pop-up look up volnoti).
-- TODO: Music bar (with controls).
-- TODO: WiFi
-- TODO: Notification widget.


-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
	awful.button({ }, 1, function (t) t:view_only() end),
	awful.button(
		{ modkey },
		1,
		function (t)
			if client.focus then
				client.focus:move_to_tag(t)
			end
		end
	),
	awful.button({ }, 3, awful.tag.viewtoggle),
	awful.button(
		{ modkey },
		3,
		function (t)
			if client.focus then
				client.focus:toggle_tag(t)
			end
		end
	),
	awful.button({ }, 4, function (t) awful.tag.viewnext(t.screen) end),
	awful.button({ }, 5, function (t) awful.tag.viewprev(t.screen) end)
)

local tasklist_buttons = gears.table.join(
	awful.button(
		{ },
		1,
		function (c)
			if c == client.focus then
				c.minimized = true
			else
				-- Without this, the following
				-- :isvisible() makes no sense
				c.minimized = false
				if not c:isvisible() and c.first_tag then
					c.first_tag:view_only()
				end
				-- This will also un-minimize
				-- the client, if needed
				client.focus = c
				c:raise()
			end
		end
	),
	awful.button({ }, 3, client_menu_toggle_fn()),
	awful.button(
		{ },
		4,
		function ()
			awful.client.focus.byidx(1)
		end
	),
	awful.button(
		{ },
		5,
		function ()
			awful.client.focus.byidx(-1)
		end
	)
)

local function set_wallpaper(s)
	-- Wallpaper
	if beautiful.wallpaper then
		local wallpaper = beautiful.wallpaper
		-- If wallpaper is a function, call it with the screen
		if type(wallpaper) == "function" then
			wallpaper = wallpaper(s)
		end
		gears.wallpaper.maximized(wallpaper, s, true)
	end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function (s)
	-- Wallpaper
	set_wallpaper(s)

	-- Each screen has its own tag table.
	local names = { "main", "term - www", "code", "www(full)", "music" }
	local layouts = {
		awful.layout.suit.tile,
		awful.layout.suit.fair,
		awful.layout.suit.max.fullscreen,
		awful.layout.suit.max.fullscreen,
		awful.layout.suit.max.fullscreen,
	}
	awful.tag(names, s, layouts)

	-- Create a promptbox for each screen
	s.prompt = awful.widget.prompt()
	-- Create an imagebox widget which will contain an icon indicating which layout we're using.
	-- We need one layoutbox per screen.
	s.layoutbox = awful.widget.layoutbox(s)
	s.layoutbox:buttons(gears.table.join(
		awful.button({ }, 1, function () awful.layout.inc( 1) end),
		awful.button({ }, 3, function () awful.layout.inc(-1) end),
		awful.button({ }, 4, function () awful.layout.inc( 1) end),
		awful.button({ }, 5, function () awful.layout.inc(-1) end)))
	-- Create a taglist widget
	s.taglist = awful.widget.taglist(s, awful.widget.taglist.filter.all, taglist_buttons)

	-- Create a tasklist widget
	-- TODO: Need to visually distinguish tasklist from taglist.
	s.tasklist = awful.widget.tasklist(s, awful.widget.tasklist.filter.currenttags, tasklist_buttons)

	-- Create the wibox
	s.wibox = awful.wibar({ position = "top", screen = s })

	-- Add widgets to the wibox
	s.wibox:setup {
		{ -- Left widgets
			launcher,
			s.taglist,
			s.prompt,

			layout = wibox.layout.fixed.horizontal,
		},
		s.tasklist, -- Middle widget
		{ -- Right widgets
			brightness.bar,
			battery.bar,
			wibox.widget.systray(),
			textclock,
			s.layoutbox,

			layout = wibox.layout.fixed.horizontal,
		},

		layout = wibox.layout.align.horizontal,
	}
end)
-- }}}

-- {{{ Mouse bindings
root.buttons(gears.table.join(
	awful.button({ }, 3, function () mainmenu:toggle() end),
	awful.button({ }, 4, awful.tag.viewnext),
	awful.button({ }, 5, awful.tag.viewprev)
))
-- }}}

-- {{{ Key bindings
globalkeys = gears.table.join(
    awful.key({ modkey,           }, "s",      hotkeys_popup.show_help,
              {description="show help", group="awesome"}),
    awful.key({ modkey,           }, "Left",   awful.tag.viewprev,
              {description = "view previous", group = "tag"}),
    awful.key({ modkey,           }, "Right",  awful.tag.viewnext,
              {description = "view next", group = "tag"}),
    awful.key({ modkey,           }, "Escape", awful.tag.history.restore,
              {description = "go back", group = "tag"}),

    awful.key({ modkey,           }, "Down",
        function ()
            awful.client.focus.byidx( 1)
        end,
        {description = "focus next", group = "client"}
    ),
    awful.key({ modkey,           }, "Up",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {description = "focus previous", group = "client"}
    ),
	awful.key(
		{ modkey }, "h",
		function () awful.client.focus.bydirection("left") end,
		{ description = "focus left", group = "client" }),
	awful.key(
		{ modkey }, "j",
		function () awful.client.focus.bydirection("down") end,
		{ description = "focus down", group = "client" }),
	awful.key(
		{ modkey }, "k",
		function () awful.client.focus.bydirection("up") end,
		{ description = "focus up", group = "client" }),
	awful.key(
		{ modkey }, "l",
		function () awful.client.focus.bydirection("right") end,
		{ description = "focus right", group = "client" }),

    awful.key({ modkey,           }, "w", function () mainmenu:show() end,
              {description = "show main menu", group = "awesome"}),

    -- Layout manipulation
    awful.key({ modkey, "Shift"   }, "j", function () awful.client.swap.byidx(  1)    end,
              {description = "swap with next client by index", group = "client"}),
    awful.key({ modkey, "Shift"   }, "k", function () awful.client.swap.byidx( -1)    end,
              {description = "swap with previous client by index", group = "client"}),
    awful.key({ modkey, "Control" }, "j", function () awful.screen.focus_relative( 1) end,
              {description = "focus the next screen", group = "screen"}),
    awful.key({ modkey, "Control" }, "k", function () awful.screen.focus_relative(-1) end,
              {description = "focus the previous screen", group = "screen"}),
    awful.key({ modkey,           }, "u", awful.client.urgent.jumpto,
              {description = "jump to urgent client", group = "client"}),
    awful.key({ modkey,           }, "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {description = "go back", group = "client"}),

    -- Standard program
    awful.key({ modkey,           }, "Return", function () awful.spawn(terminal) end,
              {description = "open a terminal", group = "launcher"}),
    awful.key({ modkey, "Control" }, "r", awesome.restart,
              {description = "reload awesome", group = "awesome"}),
    awful.key({ modkey, "Shift"   }, "q", awesome.quit,
              {description = "quit awesome", group = "awesome"}),

    awful.key({ modkey, "Shift"   }, "h",     function () awful.tag.incnmaster( 1, nil, true) end,
              {description = "increase the number of master clients", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "l",     function () awful.tag.incnmaster(-1, nil, true) end,
              {description = "decrease the number of master clients", group = "layout"}),
    awful.key({ modkey, "Control" }, "h",     function () awful.tag.incncol( 1, nil, true)    end,
              {description = "increase the number of columns", group = "layout"}),
    awful.key({ modkey, "Control" }, "l",     function () awful.tag.incncol(-1, nil, true)    end,
              {description = "decrease the number of columns", group = "layout"}),
    awful.key({ modkey,           }, "space", function () awful.layout.inc( 1)                end,
              {description = "select next", group = "layout"}),
    awful.key({ modkey, "Shift"   }, "space", function () awful.layout.inc(-1)                end,
              {description = "select previous", group = "layout"}),

    awful.key({ modkey, "Control" }, "n",
              function ()
                  local c = awful.client.restore()
                  -- Focus restored client
                  if c then
                      client.focus = c
                      c:raise()
                  end
              end,
              {description = "restore minimized", group = "client"}),

    -- Prompt
    awful.key({ modkey },            "r",     function () awful.screen.focused().prompt:run() end,
              {description = "run prompt", group = "launcher"}),

    awful.key({ modkey }, "x",
              function ()
                  awful.prompt.run {
                    prompt       = "Run Lua code: ",
                    textbox      = awful.screen.focused().prompt.widget,
                    exe_callback = awful.util.eval,
                    history_path = awful.util.get_cache_dir() .. "/history_eval"
                  }
              end,
              {description = "lua execute prompt", group = "awesome"}),
    -- Menubar
    awful.key({ modkey }, "p", function() menubar.show() end,
              {description = "show the menubar", group = "launcher"})
)

clientkeys = gears.table.join(
    awful.key({ modkey,           }, "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {description = "toggle fullscreen", group = "client"}),
    awful.key({ modkey, "Shift"   }, "c",      function (c) c:kill()                         end,
              {description = "close", group = "client"}),
    awful.key({ modkey, "Control" }, "space",  awful.client.floating.toggle                     ,
              {description = "toggle floating", group = "client"}),
    awful.key({ modkey, "Control" }, "Return", function (c) c:swap(awful.client.getmaster()) end,
              {description = "move to master", group = "client"}),
    awful.key({ modkey,           }, "o",      function (c) c:move_to_screen()               end,
              {description = "move to screen", group = "client"}),
    awful.key({ modkey,           }, "t",      function (c) c.ontop = not c.ontop            end,
              {description = "toggle keep on top", group = "client"}),
    awful.key({ modkey,           }, "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end ,
        {description = "minimize", group = "client"}),
    awful.key({ modkey,           }, "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {description = "(un)maximize", group = "client"}),
    awful.key({ modkey, "Control" }, "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {description = "(un)maximize vertically", group = "client"}),
    awful.key({ modkey, "Shift"   }, "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {description = "(un)maximize horizontally", group = "client"})
)

-- Bind all key numbers to tags.
-- Be careful: we use keycodes to make it work on any keyboard layout.
-- This should map on the top row of your keyboard, usually 1 to 9.
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
        -- View tag only.
        awful.key({ modkey }, "#" .. i + 9,
                  function ()
                        local screen = awful.screen.focused()
                        local tag = screen.tags[i]
                        if tag then
                           tag:view_only()
                        end
                  end,
                  {description = "view tag #"..i, group = "tag"}),
        -- Toggle tag display.
        awful.key({ modkey, "Control" }, "#" .. i + 9,
                  function ()
                      local screen = awful.screen.focused()
                      local tag = screen.tags[i]
                      if tag then
                         awful.tag.viewtoggle(tag)
                      end
                  end,
                  {description = "toggle tag #" .. i, group = "tag"}),
        -- Move client to tag.
        awful.key({ modkey, "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:move_to_tag(tag)
                          end
                     end
                  end,
                  {description = "move focused client to tag #"..i, group = "tag"}),
        -- Toggle tag on focused client.
        awful.key({ modkey, "Control", "Shift" }, "#" .. i + 9,
                  function ()
                      if client.focus then
                          local tag = client.focus.screen.tags[i]
                          if tag then
                              client.focus:toggle_tag(tag)
                          end
                      end
                  end,
                  {description = "toggle focused client on tag #" .. i, group = "tag"})
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c) client.focus = c; c:raise() end),
    awful.button({ modkey }, 1, awful.mouse.client.move),
    awful.button({ modkey }, 3, awful.mouse.client.resize))

-- Set keys
root.keys(globalkeys)
-- }}}

-- {{{ Rules
-- Rules to apply to new clients (through the "manage" signal).
awful.rules.rules = {
	-- All clients will match this rule.
	{
		rule = { },
		properties = {
			border_width = beautiful.border_width,
			border_color = beautiful.border_normal,
			buttons = clientbuttons,
			focus = awful.client.focus.filter,
			keys = clientkeys,
			maximized_horizontal = false,
			maximized_vertical = false,
			placement = awful.placement.no_overlap+awful.placement.no_offscreen,
			raise = true,
			screen = awful.screen.preferred,
		},
	},

    -- Floating clients.
    { rule_any = {
        instance = {
          "DTA",  -- Firefox addon DownThemAll.
          "copyq",  -- Includes session name in class.
        },
        class = {
          "Arandr",
          "Gpick",
          "Kruler",
          "MessageWin",  -- kalarm.
          "Sxiv",
          "Wpa_gui",
          "pinentry",
          "veromix",
          "xtightvncviewer"},

        name = {
          "Event Tester",  -- xev.
        },
        role = {
          "AlarmWindow",  -- Thunderbird's calendar.
          "pop-up",       -- e.g. Google Chrome's (detached) Developer Tools.
        }
      }, properties = { floating = true }},

    -- Add titlebars to normal clients and dialogs
    { rule_any = {type = { "normal", "dialog" }
      }, properties = { titlebars_enabled = true }
    },

    -- Set Firefox to always map on the tag named "2" on screen 1.
    -- { rule = { class = "Firefox" },
    --   properties = { screen = 1, tag = "2" } },
}
-- }}}

-- {{{ Signals
-- Signal function to execute when a new client appears.
client.connect_signal("manage", function (c)
    -- Set the windows at the slave,
    -- i.e. put it at the end of others instead of setting it master.
    -- if not awesome.startup then awful.client.setslave(c) end

    if awesome.startup and
      not c.size_hints.user_position
      and not c.size_hints.program_position then
        -- Prevent clients from being unreachable after screen count changes.
        awful.placement.no_offscreen(c)
    end
end)

-- Add a titlebar if titlebars_enabled is set to true in the rules.
client.connect_signal("request::titlebars", function(c)
    -- buttons for the titlebar
    local buttons = gears.table.join(
        awful.button({ }, 1, function()
            client.focus = c
            c:raise()
            awful.mouse.client.move(c)
        end),
        awful.button({ }, 3, function()
            client.focus = c
            c:raise()
            awful.mouse.client.resize(c)
        end)
    )

    awful.titlebar(c) : setup {
        { -- Left
            awful.titlebar.widget.iconwidget(c),
            buttons = buttons,
            layout  = wibox.layout.fixed.horizontal
        },
        { -- Middle
            { -- Title
                align  = "center",
                widget = awful.titlebar.widget.titlewidget(c)
            },
            buttons = buttons,
            layout  = wibox.layout.flex.horizontal
        },
        { -- Right
            awful.titlebar.widget.floatingbutton (c),
            awful.titlebar.widget.maximizedbutton(c),
            awful.titlebar.widget.stickybutton   (c),
            awful.titlebar.widget.ontopbutton    (c),
            awful.titlebar.widget.closebutton    (c),
            layout = wibox.layout.fixed.horizontal()
        },
        layout = wibox.layout.align.horizontal
    }
end)

client.connect_signal("focus", function(c) c.border_color = beautiful.border_focus end)
client.connect_signal("unfocus", function(c) c.border_color = beautiful.border_normal end)
-- }}}
