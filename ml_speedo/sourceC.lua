--Script by LENNON  (112, 152, 207) #7098CF
local sX, sY = guiGetScreenSize()
local panelW, panelH = 250,250
local clearRotate = 0
local font = exports.ml_core:getFont("eastFont",13)



addEventHandler("onClientRender", getRootElement(), function()
    if not getElementData(localPlayer, "char > toghud") then return end
	if exports.ml_interface:isWidgetShowing("speedo") then
        local theVehicle = getPedOccupiedVehicle (localPlayer)
    	if theVehicle then 
    		local speedoX, speedoY = getElementData(localPlayer,"speedo.x"),getElementData(localPlayer,"speedo.y")
    		local veh = getPedOccupiedVehicle(localPlayer)
            local oilX, oilY = getElementData(localPlayer,"oil.x"),getElementData(localPlayer,"oil.y")
            local fuelX, fuelY = getElementData(localPlayer,"fuel.x"),getElementData(localPlayer,"fuel.y")

    	
    	    local speed = math.floor(getElementSpeed(getPedOccupiedVehicle(getLocalPlayer()), "mph"))
    		local rot = math.floor(((270/9800)* getVehicleRPM(getPedOccupiedVehicle(getLocalPlayer()))) + 0.5)
    		if (clearRotate < rot) then
    			clearRotate = clearRotate + 3
    		end
    		if (clearRotate > rot) then
    			clearRotate = clearRotate - 3
    		end
    		local oil = 82
    		local fuel = 80

    		if (getVehicleType(theVehicle) == "BMX") or (getVehicleType(theVehicle) == "Plane") then
    			return
    		end

            if exports.ml_interface:isWidgetShowing("fuel") then
                dxDrawRectangle(fuelX, fuelY, 20, 100, tocolor(20,20,20,255))
                dxDrawRectangle(fuelX, fuelY + 100, 20, -(100 * fuel/100), tocolor(112, 152, 207,150))
                dxDrawImage(fuelX + 3, fuelY + 80, 16,16, "files/fuel.png",0,0,0, tocolor(0,0,0,150))
            end
            if exports.ml_interface:isWidgetShowing("oil") then
                dxDrawRectangle(oilX, oilY , 20, 100, tocolor(20,20,20,255))
                dxDrawRectangle(oilX, oilY + 100, 20, -(100 * oil/100), tocolor(197, 216, 235,150))
                dxDrawImage(oilX + 2, oilY + 80, 16,16, "files/oil.png",0,0,0, tocolor(0,0,0,150)) --197, 216, 235
            end

    		dxDrawImage( speedoX, speedoY, panelW, panelH, "files/speedobg.png", 0,0,0, tocolor(255,255,255,255))
    		dxDrawImage( speedoX, speedoY, panelW, panelH, "files/needle.png", clearRotate - 10,0,0, tocolor(255,255,255,255))

    		if getElementData(theVehicle, "veh > handbrake") then
    			handbrakecolor = tocolor(187, 90, 90, 240)
    		else
                handbrakecolor = tocolor(0,0,0,150)
    		end

    		dxDrawImage(speedoX + 108, speedoY + 60, 32, 32, "files/handbrake.png", 0,0,0, handbrakecolor)
    		dxDrawImage(speedoX + 113, speedoY + 150, 32, 32, "files/belt.png", 0,0,0, tocolor(0,0,0,150))

            if getElementData(theVehicle, "index.left") then
                leftindexcolor = tocolor(125, 176, 144,255 * math.abs(getTickCount() / 850))
            else
                leftindexcolor = tocolor(0,0,0,150)
            end

            if getElementData(theVehicle, "index.right") then
                rightindexcolor = tocolor(125, 176, 144,255 *math.abs(getTickCount() % 1000) / 1100)
            else
                rightindexcolor = tocolor(0,0,0,150)
            end

    		dxDrawImage(speedoX + 80, speedoY + 108, 32, 32, "files/index_l.png", 0,0,0, leftindexcolor)
    		dxDrawImage(speedoX + 80 + 60, speedoY + 108, 32, 32, "files/index_r.png", 0,0,0, rightindexcolor)


    		centerText(getFormatSpeed(speed).." mp/h", speedoX, speedoY + 80, panelW, panelH, tocolor(255,255,255,255), 1, font)
    		centerText("⚙️"..getFormatGear(), speedoX, speedoY, panelW, panelH, tocolor(255,255,255,150), 1, font)
    	end
    end
end)

function getElementSpeed(element,unit)
    if (unit == nil) then unit = 0 end
    if (isElement(element)) then
        local x,y,z = getElementVelocity(element)
        if (unit=="mph" or unit==1 or unit =='1') then
            return math.floor((x^2 + y^2 + z^2) ^ 0.5 * 100)
        else
            return math.floor((x^2 + y^2 + z^2) ^ 0.5 * 100 * 1.609344)
        end
    else
        return false
    end
end

function getFormatSpeed(unit)
    if unit < 10 then
        unit = "#9ED0F800#ffffff" .. unit
    elseif unit < 100 then
        unit = "#9ED0F80#ffffff" .. unit
    elseif unit >= 1000 then
        unit = ""
    elseif unit > 99 then
        unit = tostring(unit)
    end
    return unit
end


function getVehicleRPM(vehicle)
local vehicleRPM = 0
    if (vehicle) then  
        if (getVehicleEngineState(vehicle) == true) then
            if getVehicleCurrentGear(vehicle) > 0 then             
                vehicleRPM = math.floor(((getElementSpeed(vehicle, "kmh")/getVehicleCurrentGear(vehicle))*180) + 0.5) 
                if (vehicleRPM < 650) then
                    vehicleRPM = math.random(650, 750)
                elseif (vehicleRPM >= 9800) then
                    vehicleRPM = math.random(9800, 9900)
                end
            else
                vehicleRPM = math.floor((getElementSpeed(vehicle, "kmh")*180) + 0.5)
                if (vehicleRPM < 650) then
                    vehicleRPM = math.random(650, 750)
                elseif (vehicleRPM >= 9800) then
                    vehicleRPM = math.random(9800, 9900)
                end
            end
        else
            vehicleRPM = 0
        end
        return tonumber(vehicleRPM)
    else
        return 0
    end
end


function getFormatGear()
    local gear = getVehicleCurrentGear(getPedOccupiedVehicle(getLocalPlayer()))
    local rear = "R"
	local neutral = "N"
    if (gear > 0) then 
        return gear
    else
        return rear
    end
end

function centerText(text, x, y, w, h, color, fontS, font)
    dxDrawText(text, x+w/2, y+h/2, x+w/2, y+h/2, color, fontS, font, "center", "center", false, false, false, true)
end 
