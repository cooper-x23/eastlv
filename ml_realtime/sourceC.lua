
function updateTime()
	local realtime = getRealTime()
	hour = realtime.hour 
	if hour >= 24 then
		hour = hour - 24
	elseif hour < 0 then
		hour = hour + 24
	end
	minute = realtime.minute
	setTime(hour, minute)

	nextupdate = (60-realtime.second) * 1000
	setMinuteDuration( nextupdate )
	setTimer( setMinuteDuration, nextupdate + 5, 1, 60000 )
	outputDebugString("Valós idő ---> Idő beállítva: "..hour..":"..minute,0,100,100,100);
end

function onStart()
	local realtime = getRealTime()
	hour = realtime.hour 
	if hour >= 24 then
		hour = hour - 24
	elseif hour < 0 then
		hour = hour + 24
	end
	minute = realtime.minute
	outputDebugString("Valós idő: "..hour..":"..minute,0,100,100,100);
end
addEventHandler("onClientResourceStart", resourceRoot, onStart)