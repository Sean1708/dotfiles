local awful = require('awful')
local wibox = require('wibox')

-- TODO: This should be a volume icon with a progress bar pop-up.


local volume
do
	local progress = wibox.widget {
		widget = wibox.widget.progressbar,

		min_value = 0,
		max_value = 100,
		value = nil,

		-- TODO: Shit like this should be dictated by the theme (i.e. the style for widgets).
		forced_width = 50,
		paddings = 1,
	}

	function progress:update(volume)
		self.value = volume
	end


	-- TODO: Make this an icon.
	local text = wibox.widget {
		widget = wibox.widget.textbox,

		text = 'VOL',

		align = 'center',
	}


	local bar = wibox.widget {
		progress,
		text,

		layout = wibox.layout.stack,
	}
	bar.progress = progress
	bar.text = text

	function bar:update(volume)
		self.progress:update(volume)
	end


	volume = {
		mute = nil,
		volume = nil,

		bar = bar,
	}

	function volume:update()
		assert(awful.spawn.with_line_callback(
			'amixer get Master',
			{
				stdout = function (out)
					local volume, mute = out:match(
						'%w+: Playback %d+ %[(%d+)%%%] %[.-%] %[(%w+)%]')

					if volume and mute then
						mute = mute == 'off'
						self.mute = mute

						volume = tonumber(volume)
						self.volume = volume

						self.bar:update(mute and 0 or volume)
					end
				end,
			}))
	end
end


volume:update()
assert(awful.spawn.with_line_callback(
	'inotifywait -m -e close_write /dev/snd/',
	{ stdout = function () volume:update() end }))


return volume
