--script by theMark
-- DOBOZ ID-K : 3796, 3576, 3577
local boxObj = {1685, 3576, 3577, 1348, 2669}

addEventHandler('onResourceStart', resourceRoot, function()
	ped = createPed(107, 2864.8496, 1287.9321, 10.8203)
	ped:setData('ped > name', 'Vonatos Jóska')
	-- ELLENŐRZŐ PISTA
	local ped2 = createPed(106, 2800.8523, 1608.3527, 10.4052)
	ped2:setData('ped > name', 'Ellenörző Pista')
	-- lathatatlan kispista
	-- 
	-- 
	train = Vehicle(538, 2826.8511, 1645.3301, 10.8203)
	flat = Vehicle(569, -778.3623, 1111.1135, 33.8498)
	flat2 = Vehicle(569, -778.3623, 1111.1135, 33.8498)
	outputDebugString('A vonat elindult!', 0, 100, 100, 100)
	-- BOX ATTACH
	local box1 = Object(boxObj[1], 0, 0, 0)
	box1:attach(flat, 0, 0, -0.95)
	-- box1.scale = 0.5
	-- 
	local box2 = Object(boxObj[2], 0, 0, 0)
	box2:attach(flat, 0, 5.5, 0.15, 0, 0, 90)
	-- 
	local box3 = Object(boxObj[3], 0, 0, 0)
	box3:attach(flat, 0, -5.5, -0.5, 0, 0, 90)
	-- 
	local box4 = Object(boxObj[4], 0, 0, 0)
	box4:attach(flat2, 0, 0, -0.5, 0, 0, 90)
	-- 
	local box5 = Object(boxObj[5], 0, 0, 0)
	box5:attach(flat2, 0, -4, 0.25, 0, 0, 0)
	-- 
	Timer(function()
		train:attachTrailer(flat)
		flat:attachTrailer(flat2)
		ped.vehicle = train
		triggerClientEvent(root, 'getTrainElement > ml', root, train, ped)
	end, 200, 1)
end)


addEvent('restartJoskaResource > ml', true)
addEventHandler('restartJoskaResource > ml', root, function()
	restartResource(getThisResource())
	outputDebugString('A vonat beleért a colba!', 0, 100, 100, 100)
end)