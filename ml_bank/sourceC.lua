--Script by LENNON  (112, 152, 207) #7098CF
local sX, sY = guiGetScreenSize()
local panelW, panelH = 350, 150
local panelX, panelY = sX/2 - panelW/2, sY/2 - panelH/2
local showATM = false
local tick
local atmText
local font = exports.ml_core:getFont("eastFont",10)
setBlurLevel(0)


--ATM kép felrajzolás

function nearbyAtm()
    local pPos = Vector3(getElementPosition(localPlayer));
    for k,v in pairs(getElementsByType("object",resourceRoot)) do 
        if getElementData(v,"isAtm")  then 
            local oPos = Vector3(getElementPosition(v))
            if getDistanceBetweenPoints3D(pPos.x,pPos.y,pPos.z, oPos.x, oPos.y, oPos.z) < 5 then 
                local x,y = getScreenFromWorldPosition(oPos.x,oPos.y,oPos.z+1)
                if x and y then
                	if v:getData('atmProgress') > 0 then                           
                   		dxDrawImage(x - 32,y - 50,64,64, "files/atm.png", 0, 0, 0, tocolor(20,20,20,200))
                   	end
                end
            end
        end
    end
end
addEventHandler("onClientRender",root,nearbyAtm)

addEventHandler("onClientRender", getRootElement(), function()
	for _,v in ipairs(getElementsByType("object")) do
		if getElementData(v, "isAtm") == true then
			setObjectBreakable(v, false)
		end
	end
end)

--ATM megnyitás

addEventHandler("onClientClick", getRootElement(), function(button, state, x, y, wx, wy, wz, element) 
	if button == "right" and state == "down" then
		if isElement(element) then
			if getElementType(element) == "object" then
				if getElementData(element,"isAtm") == true then
					pX,pY,pZ = getElementPosition(localPlayer)
					eX,eY,eZ = getElementPosition(element)
					if getDistanceBetweenPoints3D(pX,pY,pZ,eX,eY,eZ) <= 2 then
						if getElementData(localPlayer, "char > loggedin") then
							if isPedInVehicle(localPlayer) then return outputChatBox("[ATM]#ffffff Járműből nem nyithatod meg.",112, 152, 207,true) end
							if not showATM then
								showATM = true
								tick = getTickCount()
								clickedatm = element
							end
						end
					end
				end
			end
		end
	end
end)

--ATM Panel

addEventHandler("onClientRender", getRootElement(),function() 
	if showATM then	
		local pX,pY,pZ = getElementPosition(localPlayer)
		local eX,eY,eZ = getElementPosition(clickedatm)
		if getDistanceBetweenPoints3D(pX,pY,pZ,eX,eY,eZ) > 3 then
			showATM = false
			if isElement(atmText) then 
        		destroyElement(atmText)
   			end
			return
		end

		local animation = interpolateBetween(0, 0, 0, panelW, 0, 0, (getTickCount() - tick) / 500, 'Linear')
		
	    dxDrawRectangle(panelX, panelY, panelW, panelH, tocolor(20,20,20,255))

	    dxDrawRectangle(panelX, panelY - 3, panelW, 3, tocolor(60,60,60,255))
	    dxDrawRectangle(panelX, panelY - 3, animation, 3, tocolor(112, 152, 207,255))

	    if not isElement(atmText) then
	        atmText = guiCreateEdit(-1000,-1000,0,0,"",false)
	        guiSetText(atmText,"0")
	    end

	    dxDrawRectangle(panelX + 90, panelY + 60, panelW - 100, panelH - 125, tocolor(30,30,30,255)) --itt lesz a gui
	    centerText("$"..formatMoney(guiGetText(atmText)).."", panelX + 90, panelY + 60, panelW - 100, panelH - 125, tocolor(255,255,255,80), 1, font)

	    dxDrawImage(panelX + 10, panelY + 40, 64, 64, "files/atm.png", 0, 0, 0, tocolor(30,30,30,255))

	    local money = getElementData(localPlayer, "char > bankmoney")

	    centerText("#6a6a6aSzámla egyenleg: #7098CF$#6a6a6a"..formatMoney(money).."", panelX + 30, panelY - 30, panelW, panelH, tocolor(255,255,255,255), 1, font)

	    dxDrawRectangle(panelX + 90, panelY + 120, panelW - 230, panelH - 125, tocolor(112, 152, 207,255)) --kifizetés
	    centerText("Kifizetés", panelX + 90, panelY + 120, panelW - 230, panelH - 125, tocolor(255,255,255,100), 1, font)

	    dxDrawRectangle(panelX + 220, panelY + 120, panelW - 230, panelH - 125, tocolor(153, 77, 77 ,255)) --befizetés
	    centerText("Befizetés", panelX + 220, panelY + 120, panelW - 230, panelH - 125, tocolor(255,255,255,100), 1, font)
	end
end)

addEventHandler('onClientRender', root, function()
	-- outputChatBox(localPlayer:getWeapon())
	if localPlayer:getWeapon() == 10 then
		for k, v in pairs(Element.getAllByType('object')) do
			if v:getData('isAtm') then
				local distance = getDistanceBetweenPoints3D(localPlayer.position, v.position)
				if distance > 5 then return end
				local x, y = getScreenFromWorldPosition(v.position)
				if x and y then
					dxDrawRectangle(x - 250 / 2, y - 20 / 2, 250, 20, tocolor(25, 25, 25))
					dxDrawRectangle(x - 250 / 2, y - 20 / 2, v:getData('atmProgress') / 100 * 250, 20, tocolor(112, 152, 207))
				end
			end
		end
	end
end)
addEventHandler('onClientKey', root, function(button, state)
	for k, v in pairs(Element.getAllByType('object')) do
		if v:getData('isAtm') and localPlayer:getWeapon() == 10 then
			local distance = getDistanceBetweenPoints3D(localPlayer.position, v.position)
			if distance > 5 then return end
			if button == 'mouse1' then
				if state then
					if v:getData('atmProgress') > 0 then
						local sparkEffect = Effect('prt_spark', v.position)
						sparkEffect:setData('atmEffect', true)
						v:setData('atmStart', true)
						v:setData('atmBy', localPlayer)
						localPlayer:setAnimation('sword', 'sword_idle')
						addEventHandler('onClientRender', root, function()
							if v:getData('atmStart') and v:getData('atmProgress') > 0 then
								v:setData('atmProgress', v:getData('atmProgress') - 20)
							end
							if v:getData('atmProgress') == 0 then
								-- createinfobox()
							end
						end)
					end
					-- triggerServerEvent('setPlayerBankAnimation > ml', localPlayer, localPlayer, 'sowrd', 'sword_idle')
				else
					localPlayer:setAnimation()
					v:setData('atmStart', false)
					for _, e in pairs(Element.getAllByType('effect')) do
						if e:getData('atmEffect') then
							e:destroy()
						end
					end
					-- triggerServerEvent('setPlayerBankAnimation > ml', localPlayer, localPlayer, '', '')
				end
			end
		end
	end
end)

local checkTimer = false

checkTimer = Timer(function()
	for k, v in pairs(Element.getAllByType('object')) do
		if v:getData('isAtm') and v:getData('atmProgress') == 0 and v:getData('atmBy') == localPlayer then
			createinfobox()
			triggerServerEvent('setBankModel > ml', root, v)
			if checkTimer.valid then
				checkTimer:destroy()
			end
		end
	end
end, 1000, 0)

function createinfobox()
	exports.ml_notification:addNotification('Sikeresen kivágtad az ATM-et, részletek a chatboxban!', 'info')
end

addEventHandler('onClientRender', root, function()
	for k, v in pairs(Element.getAllByType('object')) do
		if v:getData('isAtm') and v:getData('atmProgress') == 0 then
			local distance = getDistanceBetweenPoints3D(localPlayer.position, v.position)
			if distance < 5 then
				local x, y = getScreenFromWorldPosition(v.position)
				if x and y then
					dxDrawImage(x - 64 / 2, y - 450, 64, 64, 'files/robbed.png', 0, 0, 0, tocolor(255, 88, 88))
				end
			end
		end
	end 
end)

--ATM click és egyéb funkciók

addEventHandler("onClientClick", getRootElement(), function(button, state)
	if button == "left" and state == "down" then
        if showATM then
			if exports.ml_core:isInSlot(panelX + 90, panelY + 60, panelW - 100, panelH - 125) then 
				if isElement(atmText) then
					if guiEditSetCaratIndex(atmText, string.len(guiGetText(atmText))) and tonumber(guiGetText(atmText)) then
						guiSetText(atmText,"0")
						guiBringToFront(atmText)
						guiEditSetMaxLength(atmText, 14)
					end
				end
        	elseif exports.ml_core:isInSlot(panelX + 90, panelY + 120, panelW - 230, panelH - 125) then --kifizetés 
	        	if tonumber(guiGetText(atmText)) and tonumber(guiGetText(atmText)) > 0 then     		
	        		if getElementData(localPlayer, "char > bankmoney") >= tonumber(guiGetText(atmText)) then
	        			local amount = math.floor(tonumber(guiGetText(atmText)))
	                    exports.ml_notification:addNotification("Sikeres pénz kivétel! ($"..formatMoney(guiGetText(atmText))..")", "info")
	                    outputChatBox("[ATM] #ffffffSikeresen kivetted a kiválasztott összeget! #7098CF($"..formatMoney(guiGetText(atmText))..")",112, 152, 207, true)
	                    outputChatBox("[ATM] #ffffffAdó: #7098CFNincs.",112, 152, 207, true)
	                    triggerServerEvent("bankMoneyChange > ml", localPlayer, localPlayer, "payOut", amount)
					    closeATM()
					else
	                    exports.ml_notification:addNotification("Nincs ennyi pénz a számládon! ($"..formatMoney(guiGetText(atmText))..")", "warning")
					end
				else
					outputChatBox("[ATM] #ffffffHibás összeg! Betűk, nulla és idegen karakterek #A84E4Etilosak!",112, 152, 207, true)
					guiSetText(atmText,"0")
				end
				local sound = playSound("files/click.mp3")
        	elseif exports.ml_core:isInSlot(panelX + 220, panelY + 120, panelW - 230, panelH - 125) then --befizetés
        		if tonumber(guiGetText(atmText)) and tonumber(guiGetText(atmText)) > 0  then
        			if getElementData(localPlayer, "char > money") >= tonumber(guiGetText(atmText)) then
        				local amount = math.floor(tonumber(guiGetText(atmText)))
                        exports.ml_notification:addNotification("Sikeres pénz befizetés! ($"..formatMoney(guiGetText(atmText))..")", "info")
                		outputChatBox("[ATM] #ffffffSikeresen befizetted a kiválasztott összeget! #7098CF($"..formatMoney(guiGetText(atmText))..")",112, 152, 207, true)
                		outputChatBox("[ATM] #ffffffAdó: #7098CFNincs.",112, 152, 207, true)
                		triggerServerEvent("bankMoneyChange > ml", localPlayer, localPlayer, "payIn", amount)
                		closeATM()   
                		local sound = playSound("files/click.mp3")           		
                	else
                		exports.ml_notification:addNotification("Nincs ennyi pénz nálad! ($"..formatMoney(guiGetText(atmText))..")", "warning")
                	end
                else
                	outputChatBox("[ATM] #ffffffHibás összeg! Betűk, nulla és idegen karakterek #A84E4Etilosak!",112, 152, 207, true)
                	guiSetText(atmText,"0")
                end
                local sound = playSound("files/click.mp3")
        	end
        end
	end
end)

function closeATM()
    showATM = false 
    tick = getTickCount()
    if isElement(atmText) then 
        destroyElement(atmText)
    end
end

function formatMoney(amount)
	local formated = tonumber(amount)
	if formated then
		while true do  
			formated, k = string.gsub(formated, "^(-?%d+)(%d%d%d)", '%1,%2')
		if (k==0) then
			break
		end
	end
		return formated
	else
		return amount
	end
end

function centerText(text, x, y, w, h, color, fontS, font)
    dxDrawText(text, x+w/2, y+h/2, x+w/2, y+h/2, color, fontS, font, "center", "center", false, false, false, true)
end 

bindKey("backspace", "down",function()
	if showATM then
        showATM = false 
        tick = getTickCount()
        if isElement(atmText) then 
            destroyElement(atmText)
        end
	end
end)
