#!/usr/bin/env lua

local int
for line in assert(io.popen('ip link show')):lines() do
	int = line:match('%w+: <.-BROADCAST,MULTICAST,.-UP>')
	if int then
		break
	end
end

local status
if not int then
	status = 'off'
else
	if int:match('NO%-CARRIER') then
		status = 'disconnected'
	else
		status = 'connected'
	end
end

print(string.format('return { status = %q }', status))
