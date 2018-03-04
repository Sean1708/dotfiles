local awful = require('awful')
local wibox = require('wibox')

-- TODO: This should be a brightness icon with a progress bar pop-up.


local progress = wibox.widget {
	widget = wibox.widget.progressbar,

	min_value = 0,
	max_value = 100,
	value = nil,

	-- TODO: Shit like this should be dictated by the theme (i.e. the style for widgets).
	forced_width = 50,
	paddings = 1,
}

function progress:update(brightness)
	self.value = brightness
end


-- TODO: Make this an icon.
local text = wibox.widget {
	widget = wibox.widget.textbox,

	text = 'BRIGHT',

	align = 'center',
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


local brightness = {
	brightness = nil,

	bar = bar,
}

function brightness:update()
	assert(awful.spawn.easy_async(
		'xbacklight -get',
		function (out)
			local brightness = tonumber(out)
			self.brightness = brightness
			self.bar:update(brightness)
		end))
end


brightness:update()
assert(awful.spawn.with_line_callback(
	'inotifywait -m -e modify /sys/class/backlight/intel_backlight/actual_brightness',
	{ stdout = function () brightness:update() end }))

return brightness
