--Script by LENNON (112, 152, 207) #7098CF

local sx, sy = guiGetScreenSize()
local panelW, panelH = 350, 60
local boxW, boxH = 50, 50
local imageW, imageH = 16, 16
local boxColor = tocolor(50,50,50,200)
local hpColor = tocolor(142, 77, 77 ,200)
local armorColor = tocolor(56,117,200,200)
local foodColor = tocolor(225,174,63,200)
local drinkColor = tocolor(63,164,225,200)
local font = exports.ml_core:getFont("eastFont",10)

function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end

function hud_draw()
	setPedArmor(localPlayer, 100) 
	if getElementData(localPlayer, "char > toghud") == false then return end


	local health = getElementHealth(localPlayer)
	local armor = getPlayerArmor(localPlayer)
	local food = getElementData(localPlayer, "char > food") or 100
	local drink = getElementData(localPlayer, "char > drink") or 100
	local stamina = getElementData(localPlayer, "char > stamina") or 100
	local mins = getElementData(localPlayer, "char > playedtime") or 0
	local pMoney = getElementData(localPlayer, "char > money")
	local hudPosX,hudPosY = getElementData(localPlayer,"hud.x"),getElementData(localPlayer,"hud.y");


	local time = getRealTime()
	local hours = time.hour
	local minutes = time.minute
	local seconds = time.second
	if (hours < 10) then
	 	hours = "0"..hours
	end
    if (minutes < 10) then
	    minutes = "0"..minutes
	end
	if (seconds < 10) then
		seconds = "0"..seconds
	end

	if isWidgetShowing("hud") then

	    dxDrawRectangle(hudPosX, hudPosY, panelW, panelH, tocolor(40,40,40,255)) --ALAP HÁTTÉR
	    dxDrawRectangle(hudPosX, hudPosY + 60, panelW, 2, tocolor(112, 152, 207,255)) --ALAP HÁTTÉR
	   

	    --stamina
	    if stamina > 20 then
	    	staminaColor = tocolor(65,65,65,250)
	    elseif stamina < 20 then	    	
	    	staminaColor = tocolor(181, 90, 90,200)
	    end
	    dxDrawRectangle(hudPosX, hudPosY + 65, panelW, 15, tocolor(40,40,40,255)) 
	    dxDrawRectangle(hudPosX, hudPosY + 65, panelW*stamina/100, 15 , staminaColor)
	    centerText("Stamina: "..math.round(stamina).."%", hudPosX, hudPosY + 65, panelW, 15, tocolor(125,125,125,255), 1, font)

        --HP
	    dxDrawRectangle(hudPosX + 10, hudPosY + 5, boxW, boxH, tocolor(65,65,65,150))
	    dxDrawRectangle(hudPosX + 10 + 3, hudPosY + 5 + 3, boxW*health/100 - 6, boxH - 6, hpColor) 
	    dxDrawImage(hudPosX + 26, hudPosY + 22, 16, 16, "hud/img/hp.png", 0, 0, 0, tocolor(255,255,255,95))

        --ARMOR
	    dxDrawRectangle(hudPosX + 10 + 55, hudPosY + 5, boxW, boxH, tocolor(65,65,65,150))
	    dxDrawRectangle(hudPosX + 10 + 55 + 3, hudPosY + 5 + 3, boxW*armor/100 - 6, boxH - 6, armorColor) 
	    dxDrawImage(hudPosX + 26 + 55, hudPosY + 22, 16, 16, "hud/img/kevlar.png", 0, 0, 0, tocolor(255,255,255,95))

	    --kaja
	    dxDrawRectangle(hudPosX + 10 + 55 * 2, hudPosY + 5, boxW, boxH, tocolor(65,65,65,150))
	    dxDrawRectangle(hudPosX + 10 + 55 * 2 + 3, hudPosY + 5 + 3, (boxW-6)*food/100 , boxH - 6, foodColor) 
	    dxDrawImage(hudPosX + 26 + 55 * 2, hudPosY + 22, 16, 16, "hud/img/food.png", 0, 0, 0, tocolor(255,255,255,95))

        --pia
	    dxDrawRectangle(hudPosX + 10 + 55 * 3, hudPosY + 5, boxW, boxH, tocolor(65,65,65,150))
	    dxDrawRectangle(hudPosX + 10 + 55 * 3 + 3, hudPosY + 5 + 3, (boxW - 6)*drink/100, boxH - 6, drinkColor) 
	    dxDrawImage(hudPosX + 26 + 55 * 3, hudPosY + 22, 16, 16, "hud/img/drink.png", 0, 0, 0, tocolor(255,255,255,95))

	    dxDrawText(""..hours ..":" .. minutes..":"..seconds.."", hudPosX + 230, hudPosY + 5, panelH, panelH, tocolor(255, 255, 255, 255), 1, font, "left", "top", false, false, false, true, false)
	    dxDrawText("#7098CF$#ffffff"..formatMoney(pMoney), hudPosX + 230, hudPosY + 23, panelH, panelH, tocolor(255, 255, 255, 255), 1, font, "left", "top", false, false, false, true, false)
	    dxDrawText("Percek: "..mins.."", hudPosX + 230, hudPosY + 40, panelH, panelH, tocolor(255, 255, 255, 255), 1, font, "left", "top", false, false, false, true, false)


	end
end
addEventHandler("onClientRender", root, hud_draw) 

setTimer(function()
	if getElementData(localPlayer, "char > loggedin") then
		local minutes = getElementData(localPlayer, "char > playedtime") or 0
		setElementData(localPlayer, "char > playedtime", minutes + 1)
	end
end, 60000, 0)

addCommandHandler("percek", function()
	local minutes = getElementData(localPlayer, "char > playedtime") or 0
	outputChatBox(minutes.." játszott perc")


end)

function formatMoney(amount)
	local formatted = tonumber(amount)
	if formatted then
		while true do  
			formatted, k = string.gsub(formatted, "^(-?%d+)(%d%d%d)", '%1,%2')
		if (k==0) then
			break
		end
	end
		return formatted
	else
		return amount
	end
end

function shadowedText(text,x,y,w,h,color,fontsize,font,aligX,alignY,a,b,c,d,rot)
	if not a then a = false end;
	if not b then b = false end;
	if not c then c = false end;
    if not d then d = true end;
    if not rot then rot = 0 end;
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x,y+1,w,h+1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, a,b,c,d,false,rot) 
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x,y-1,w,h-1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, a,b,c,d,false,rot)
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x-1,y,w-1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, a,b,c,d,false,rot) 
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x+1,y,w+1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, a,b,c,d,false,rot) 
    dxDrawText(text,x,y,w,h,color,fontsize,font,aligX,alignY, a,b,c,d,false,rot)
end

function isElementMoving ( theElement )
    if isElement ( theElement ) then                    
        local x, y, z = getElementVelocity( theElement ) 
        return x ~= 0 or y ~= 0 or z ~= 0      
    end
 
    return false
end

function getElementSpeed(theElement, unit)
    assert(isElement(theElement), "Bad argument 1 @ getElementSpeed (element expected, got " .. type(theElement) .. ")")
    assert(getElementType(theElement) == "player" or getElementType(theElement) == "ped" or getElementType(theElement) == "object" or getElementType(theElement) == "vehicle", "Invalid element type @ getElementSpeed (player/ped/object/vehicle expected, got " .. getElementType(theElement) .. ")")
    assert((unit == nil or type(unit) == "string" or type(unit) == "number") and (unit == nil or (tonumber(unit) and (tonumber(unit) == 0 or tonumber(unit) == 1 or tonumber(unit) == 2)) or unit == "m/s" or unit == "km/h" or unit == "mph"), "Bad argument 2 @ getElementSpeed (invalid speed unit)")
    unit = unit == nil and 0 or ((not tonumber(unit)) and unit or tonumber(unit))
    local mult = (unit == 0 or unit == "m/s") and 50 or ((unit == 1 or unit == "km/h") and 180 or 111.84681456)
    return (Vector3(getElementVelocity(theElement)) * mult).length
end

function checkMoving()
   if isElementMoving(localPlayer) and getElementSpeed(localPlayer) > 5.1 then
   	if getElementData(localPlayer, "char > adminduty") then
   		return
   	end
   	   if not getPedOccupiedVehicle(localPlayer) then
          local staminalevel = tonumber(getElementData(localPlayer, "char > stamina") or 100)
          if staminalevel >= 0.2 then
              setElementData(localPlayer, "char > stamina", staminalevel - 0.05)
              if getElementData(localPlayer, "stamina->animRequested") then
			     toggleAllControls(true, true, true)
          	     setElementData(localPlayer, "stamina->animRequested", false)
				 setPedAnimation(localPlayer, "", "")
              end
          else
          	  if not getElementData(localPlayer, "stamina->animRequested") then
				 toggleAllControls(false, true, false)
          	     setPedAnimation(localPlayer, "FAT", "idle_tired", 8000, true, false, true, false)
				 setElementData(localPlayer, "stamina->animRequested", true)
              end
          end
   	   end
   else
       if tonumber(getElementData(localPlayer, "char > stamina") or 100) < 15 then
       	   local staminalevel = tonumber(getElementData(localPlayer, "char > stamina") or 100)
		   if not getElementData(localPlayer, "stamina->animRequested") then
		      toggleAllControls(false, true, false)
		      setPedAnimation(localPlayer, "FAT", "idle_tired", 8000, true, false, true, false)
              setElementData(localPlayer, "stamina->animRequested", true)
		   end
           setElementData(localPlayer, "char > stamina", staminalevel + 0.10)
       else
       	   local staminalevel = tonumber(getElementData(localPlayer, "char > stamina") or 100)
       	   if staminalevel < 100 then
               setElementData(localPlayer, "char > stamina", staminalevel + 0.10)
               if getElementData(localPlayer, "stamina->animRequested") then
          	      setElementData(localPlayer, "stamina->animRequested", false)
				  toggleAllControls(true, true, true)
          	      setPedAnimation(localPlayer, "", "")
               end
           end
       end
   end
end
addEventHandler("onClientRender", root, checkMoving, true, "low")

local minuteTimer = (1000*60)*10
setTimer(function()
    if getElementData(getLocalPlayer(),"char > loggedin") then
		if getElementData(localPlayer,"admin > duty") then return end;
		if tonumber(getElementData(getLocalPlayer(),"char > food") or 100) > 0 then
			local randomLose = math.random(1,10)
			local main = getElementData(getLocalPlayer(),"char > food") or 100
			local newValue = main-randomLose
			if main > 100 then
				randomLose = math.random(1,10)
			else
				setElementData(getLocalPlayer(), "char > food", newValue)
			end
		else
			outputChatBox("[Karakter] #ffffffÉhes vagy! Egyél valamit, különben rosszul leszel!",112, 152, 207,true)
			exports.ml_notification:addNotification("A karaktered éhes! Egyél valamit.","warning")
			local randomHpLose = math.random(5,10)
			local health = getElementHealth (getLocalPlayer())
			local newHpValue = health-randomHpLose
			--setElementHealth (getLocalPlayer(), newHpValue)
		end
		if getElementData(getLocalPlayer(),"char > food") <= 0 then
			setElementData(getLocalPlayer(), "char > food", 0)
		end
		if getElementData(getLocalPlayer(),"char > food") > 100 then
			setElementData(getLocalPlayer(), "char > food", 100)
		end
	end
    if getElementData(getLocalPlayer(),"char > loggedin") then
		if getElementData(localPlayer,"admin > duty") then return end;
		if tonumber(getElementData(getLocalPlayer(),"char > drink") or 100) > 0 then
			local randomLose = math.random(1,10)
			local main = tonumber(getElementData(getLocalPlayer(),"char > drink")) or 100
			local newValue = main-randomLose
			if main > 100 then
				randomLose = math.random(1,10)
			else
				setElementData(getLocalPlayer(), "char > drink", newValue)
			end
		else
			outputChatBox("[Karakter] #ffffffSzomjas vagy! Igyál valamit, különben rosszul leszel!",112, 152, 207,true)
			exports.ml_notification:addNotification("A karaktered szomjas! Igyál valamit.","warning")
			local randomHpLose = math.random(5,10)
			local health = getElementHealth (getLocalPlayer())
			local newHpValue = health-randomHpLose
			--setElementHealth (getLocalPlayer(), newHpValue)
		end
		if tonumber(getElementData(getLocalPlayer(),"char > drink")) < 0 then
			setElementData(getLocalPlayer(), "char > drink", 0)
		end
		if tonumber(getElementData(getLocalPlayer(),"char > drink")) > 100 then
			setElementData(getLocalPlayer(), "char > drink", 100)
		end
	end
end,minuteTimer,0)

function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end

function centerText(text, x, y, w, h, color, fontS, font)
    dxDrawText(text, x+w/2, y+h/2, x+w/2, y+h/2, color, fontS, font, "center", "center", false, false, false, true)
end 





