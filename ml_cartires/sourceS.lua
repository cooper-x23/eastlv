

function getRandomWheel()
	local randomWheel = math.random(1, 4)
	if randomWheel == 1 then
		return 1, 0, 0, 0, 'bal első'
	elseif randomWheel == 2 then
		return 0, 1, 0, 0, 'bal hátsó'
	elseif randomWheel == 3 then
		return 0, 0, 1, 0, 'jobb első'
	elseif randomWheel == 4 then
		return 0, 0, 0, 1, 'jobb hátsó'
	end
end

addEvent('setVehicleWheelStates > mlServer', true)
addEventHandler('setVehicleWheelStates > mlServer', root, function(player)
	local veh = getPedOccupiedVehicle(player)
	if veh then
		local fLeft, rLeft, fRright, rRight, name = getRandomWheel()
		local fLeft1, rLeft1, fRright1, rRight1	= getVehicleWheelStates(veh)
		exports.ml_notification:addNotification(player, 'Hibák keletkeztek a járműved kerekébe, részletek a chatboxban!', 'warning')
		outputChatBox('#7098CF[CARTIRES]:' .. '#FFFFFF' .. ' ' .. 'Áthajtottál pár törött üvegen és kilyukadt a ' .. '#7098CF' .. name .. '#FFFFFF' .. ' gumid!', player, 255, 255, 255, true)
		setTimer(function()
			setVehicleWheelStates(veh, fLeft1 + fLeft, rLeft1 + rLeft, fRright1 + fRright, rRight1 + rRight)
		end, 5000, 1)
	end
end)

addEvent("fixVehicleTires > mlServer", true)
addEventHandler('fixVehicleTires > mlServer', root, function(player)
	local veh = getPedOccupiedVehicle(player)
	if veh then
		setVehicleWheelStates(veh, 0,0,0,0)
	end
end)