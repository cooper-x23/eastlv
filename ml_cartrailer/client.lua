--script by theMark

-- LOAD
ID = 607

function TXDFile ()
	TXD = engineLoadTXD('models/1.txd' ) 
	engineImportTXD(TXD, ID)
end 
addEventHandler('onClientResourceStart', resourceRoot, TXDFile)


function DFFFile ()
	DFF = engineLoadDFF('models/1.dff', 0) 
	engineReplaceModel (DFF, ID)
end 
addEventHandler('onClientResourceStart', resourceRoot, DFFFile)
-- XD
local trailerElement = false
local hoveredButton = false
addEventHandler('onClientRender', root, function()
	hoveredButton = false
	if trailerElement then
		local distance = getDistanceBetweenPoints3D(localPlayer.position, trailerElement.position)
		if distance < 10 then
			local x, y = getScreenFromWorldPosition(trailerElement.position)
			if x and y then
				dxDrawRectangle(x, y, 60, 60, tocolor(20, 20, 20))
				dxDrawImage(x, y, 55, 55, 'img/crane-truck.png', 0, 0, 0, tocolor(255, 255, 255))
				if exports.ml_core:isInSlot(x, y, 60, 60) then
					hoveredButton = 'carHookButton'
				end
			end
		end
	end
end)

addEvent('acceptTrailerElement > ml', true)
addEventHandler('acceptTrailerElement > ml', root, function(element)
	trailerElement = element
end)

addEventHandler('onClientClick', root, function(button, state)
	if hoveredButton then
		local distance = getDistanceBetweenPoints3D(localPlayer.position, trailerElement.position)
		if distance < 10 then
			if button == 'left' and state == 'down' then
				if hoveredButton == 'carHookButton' then
					if localPlayer.vehicle then
						triggerServerEvent('attachPlayerVehicleHook > ml', localPlayer, localPlayer)
					else
						outputChatBox('#7098CF' .. '[CARHOOK]: ' .. '#FFFFFF' .. 'Nem vagy járműben!', 255, 255, 255, true)
					end
				end
			end
		end
	end
end)