--Script by LENNON  (112, 152, 207) #7098CF
local cache = {};
local sX, sY = guiGetScreenSize()
local panelW, panelH = 300,300
local showPanel = false
local repairTriesMarker = createMarker(1657.4644, 2194.6353, 10.8203 - 1, "cylinder", 2, 20,20,20,200)
setElementData(repairTriesMarker, "repairTriesMarker", true)
local font = exports.ml_core:getFont("eastFont",10)
local tick

addEventHandler("onClientResourceStart",resourceRoot,function()
    for k, v in pairs(brokenBottles) do 
        local x,y,z = unpack(v);
        local obj = createObject(2673,x,y,z - 0.9)
        local col = createColSphere(x, y, z, 2.5)
        cache[obj] = true;
        setElementData(obj,"road.bottles",true)
        setElementData(col,"road.tiredefekt",true)
    end
end)

addEventHandler ("onClientColShapeHit", root, function(hitElement, dim)
	if hitElement == localPlayer and dim then
		local theVehicle = getPedOccupiedVehicle (localPlayer)
		local seat = getPedOccupiedVehicleSeat(localPlayer)
		if theVehicle and seat == 0 then
			local chance = math.random(0,100)
			if getElementData(source, "road.tiredefekt") then
				if chance > 60 then
				    playSound('files/tire.mp3')
				    triggerServerEvent('setVehicleWheelStates > mlServer', localPlayer, localPlayer)
				end
			end
	    end
	end
end)

function MarkerHit(hitElement, dim)
	if hitElement == localPlayer and dim then
		local seat = getPedOccupiedVehicleSeat(localPlayer)
		local theVehicle = getPedOccupiedVehicle (localPlayer)
		if theVehicle and seat == 0 then
			showPanel = true
			tick = getTickCount()
		end
    end
end
addEventHandler("onClientMarkerHit", repairTriesMarker, MarkerHit)

function MarkerHit(hitElement, dim)
	if hitElement == localPlayer and dim then
		local theVehicle = getPedOccupiedVehicle (localPlayer)
		if theVehicle then
			showPanel = false
			tick = getTickCount()
		end
    end
end
addEventHandler("onClientMarkerLeave", repairTriesMarker, MarkerHit)

local money = 1350

addEventHandler("onClientRender", getRootElement(), function()
	if showPanel then
		local veh = getPedOccupiedVehicle(localPlayer)
		if veh then
			local animation = interpolateBetween(0, 0, 0, panelW, 0, 0, (getTickCount() - tick) / 500, 'Linear')

			dxDrawRectangle(sX/2 - panelW/2, sY/2 - panelH/2, panelW, panelH, tocolor(20,20,20,255))
			dxDrawImage(sX/2 - 250/2, sY/2 - 250/2, 250, 250, "files/hankook.png", 0, 0, 0, tocolor(255,255,255,255))

			dxDrawRectangle(sX/2 - panelW/2, sY/2 - panelH/2 + 310, panelW, 35, tocolor(20,20,20,255))
			dxDrawRectangle(sX/2 - panelW/2, sY/2 - panelH/2 + 310, animation, 2, tocolor(112, 152, 207,255))
			centerText("Hibás gumik javittatása/ellenőrzése #7098CF($"..money..")", sX/2 - panelW/2, sY/2 - panelH/2 + 310, panelW, 35, tocolor(255,255,255,255), 1, font)

		end
	end
end)

addEventHandler("onClientClick", getRootElement(), function(button, state)
	 if button == "left" and state == "down" then
		if showPanel then
			if exports.ml_core:isInSlot(sX/2 - panelW/2, sY/2 - panelH/2 + 310, panelW, 35) then
				outputChatBox("#7098CF[CARTIRES]:#ffffff A járművedet megvizsgálják, és ha találnak hibákat a gumiknál, kijavítják őket. Ha #7098CFelhajtasz#ffffff ez a folyamat #7098CFmegszakad!", 255,255,255,true)
				exports.ml_notification:addNotification("A szakemberek hozzá láttak a munkához, várj türelemmel!", "info")
				showPanel = false
				fadeCamera(false, 1, 0,0,0)
				setTimer(function()
					outputChatBox("#7098CF[CARTIRES]:#ffffff A járművedet megvizsgálták és a hibákat kijavították! További szép napot!", 255,255,255,true)
					triggerServerEvent('fixVehicleTires > mlServer', localPlayer, localPlayer)
					fadeCamera(true, 1, 0,0,0)
			    end, 3000, 1)
			end

		end
	end
end)


function centerText(text, x, y, w, h, color, fontS, font)
    dxDrawText(text, x+w/2, y+h/2, x+w/2, y+h/2, color, fontS, font, "center", "center", false, false, false, true)
end 

