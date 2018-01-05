#!/usr/bin/env lua
local lgi = require('lgi')

local player = lgi.Playerctl.Player()
local loop = lgi.GLib.MainLoop()

player:on(
	'metadata',
	lgi.GObject.Closure(function (p)
		print(string.format(
			'return { title = %q, artist = %q, album = %q }',
			p:get_title(),
			p:get_artist(),
			p:get_album()
		))
	end)
)
loop:run()
