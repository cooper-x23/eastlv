--script by theMark
setTime(12, 1)
local vehicleTable = {562}

-- TESZT MERT SZAR AZ ADMin (kurva vicci vagy)
local testTrailer = Vehicle(607, 2463.6345, 2235.3879, 10.6797)
testTrailer.collisons = true
testTrailer.rotation = Vector3(0, 0, 90)
-- 

addEventHandler('onResourceStart', resourceRoot, function()
	Timer(function()
		triggerClientEvent(root, 'acceptTrailerElement > ml', root, testTrailer)
	end, 500, 1)
	local notAlphaVeh = Vehicle(485, 0, 0, 0)
	notAlphaVeh.collisions = false
	notAlphaVeh.alpha = 0
	for key, value in pairs(Element.getAllByType('vehicle')) do
		for w = 1, #vehicleTable do
			if value.model == vehicleTable[w] then
				Timer(function()
					notAlphaVeh:attach(value, 0, -0.87, -0.1)
				end, 200, 1)
			end
		end
	end
end)

addEvent('attachPlayerVehicleHook > ml', true)
addEventHandler('attachPlayerVehicleHook > ml', root, function(player)
	local veh = player.vehicle
	if veh:getData('attachedHook > ml') then
		veh:detach(testTrailer)
		veh:setData('attachedHook > ml', false)
	else
		veh:attach(testTrailer, 0, -0.80, 0.55)
		veh:setData('attachedHook > ml', true)
	end
end)