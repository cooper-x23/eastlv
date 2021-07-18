--Script by LENNON (112, 152, 207) #7098CF
local sX, sY = guiGetScreenSize()
local panelW, panelH = 600, 300
local panelState = "open"
local tab = 0
local font = dxCreateFont( "files/font.ttf", 10 )
local tick

local playerCars = {}
local playerHouses = {}
local maxVehicles = 7
local maxHouses = 7

local hCount = 0;
local hScroll = 0;

local vCount = 0;
local vScroll = 0;

local images = {
    {"files/home.png"},
    {"files/dollar.png"},
    {"files/settings.png"},
    {"files/premium.png"},
}

local settingsMenu = {
    {"HD Textúrák", false},
    {"Jármű tükröződés", false},
    {"Kontraszt", false},
}

local premiumPacks = {
	{"★ Kis csomag ", "#7098CF 1000pp", "#ffffff Csomag ára: #7098CF800ft"},
	{"★ Közepes csomag ", "#7098CF 2000pp", "#ffffff Csomag ára: #7098CF1600ft"},
	{"★ Nagy csomag ", "#7098CF 6000pp", "#ffffff Csomag ára: #7098CF4000ft"},
}

function dashDraw()
	if panelState == "open" and getElementData(localPlayer, "char > loggedin") then 

		local p = ( getTickCount() - tick ) / 500
        local pANIM = interpolateBetween(0, 0, 0, 255, 255, 255, p, "Linear")

		dxDrawRectangle(sX/2 - panelW/2, sY/2 - panelH/2, panelW, panelH, tocolor(20,20,20,pANIM))
		dxDrawRectangle(sX/2 - panelW/2, sY/2 - panelH/2 - 2, panelW, 2, tocolor(112, 152, 207,255))

        for i=1, 4 do -- MENÜ DXEK
		    dxDrawRectangle(sX/2 - panelW/2 - 55, sY/2 - panelH/2 - 55 + (i*55), 50, 50, tocolor(20,20,20,255))
		    dxDrawRectangle(sX/2 - panelW/2 - 55, sY/2 - panelH/2 - 55 - 2 + (i*55), 50, 2, tocolor(45,45,45,255))
	    end

	    for k, v in pairs(images) do
	    	dxDrawImage(sX/2 - panelW/2 - 55 + 8, sY/2 - panelH/2 - 55 + 6 + (k*55), 34, 34, v[1], 0, 0, 0, tocolor(255,255,255,255))
	    end

	    local charStats = {
		{"Account ID: ", getElementData(localPlayer, "char > accountid")},
		{"Név: #7098CF", getElementData(localPlayer, "char > name"):gsub("_", " ") or "Hiba"},
		{"Admin szint: #7098CF", getElementData(localPlayer, "char > admin") or 0},
		{"Admin Név: #7098CF", getElementData(localPlayer, "char > adminnick") or "Nincs"},
		{"Séta stílus ID: #7098CF", getElementData(localPlayer, "char > walkingstyle") or 0},
		{"Skin: #7098CF", getElementData(localPlayer, "char > skin") or 0},
		{"Pénz: #7098CF$", getElementData(localPlayer, "char > money") or 0},
		{"Banki pénz: #7098CF$", getElementData(localPlayer, "char > bankmoney") or 0},
		{"Prémium pont(PP): #7098CF", getElementData(localPlayer, "char > premiumpoints") or 0},
		}

	    if tab == 1 then	
	    	dxDrawRectangle(sX/2 - panelW/2 + 10, sY/2 - panelH/2 + 10, panelW - 20, panelH - 20, tocolor(25,25,25,pANIM))
	    	centerText("Karakter adatok" ,sX/2 - panelW/2, sY/2 - panelH/2 - 125, panelW, panelH, tocolor(85,85,85,255), 1, font)
	    	for k, v in pairs(charStats) do
	    		if k % 2 == 0 then
                    dxDrawRectangle(sX/2 - panelW/2 + 15, sY/2 - panelH/2 + 15 + (k*25), panelW - 30, 20, tocolor(20,20,20,255))
                else
                    dxDrawRectangle(sX/2 - panelW/2 + 15, sY/2 - panelH/2 + 15 + (k*25), panelW - 30, 20, tocolor(30,30,30,255))
                end
                centerText(v[1]..v[2],sX/2 - panelW/2 + 10, sY/2 - panelH/2 + 15 + (k*25), panelW - 20, 20, tocolor(255,255,255,255), 1, font)
	    	end
	    elseif tab == 2 then
	    	dxDrawRectangle(sX/2 - panelW/2 + 10, sY/2 - panelH/2 + 10, panelW - 20, panelH - 20, tocolor(25,25,25,pANIM))
	    	dxDrawRectangle(sX/2 - panelW/2 + 20, sY/2 - panelH/2 + 220, 560, 50, tocolor(45,45,45,255)) 
	    	centerText("Járművek ("..#playerCars..") és Ingatlanok ("..#playerHouses..")" ,sX/2 - panelW/2, sY/2 - panelH/2 - 125, panelW, panelH, tocolor(85,85,85,255), 1, font)
	    	centerText("Leírás, tulajdonságok HAMAROSAN!\nSlot vásárlás a Prémium Shop-ban lehetséges!" ,sX/2 - panelW/2, sY/2 - panelH/2 + 95, panelW, panelH, tocolor(125,125,125,255), 1, font)
	    	for i=1, 7 do
	    		if i % 2 == 0 then --KOCSIK
	    		    dxDrawRectangle(sX/2 - panelW/2 + 20, sY/2 - panelH/2 + 15 + (i*25), 260, 20, tocolor(20,20,20,255)) --kocsi
	    		else
                    dxDrawRectangle(sX/2 - panelW/2 + 20, sY/2 - panelH/2 + 15 + (i*25), 260, 20, tocolor(30,30,30,255)) --kocsi
	    	    end	    	    

	    	    if i % 2 == 0 then --INTERIOROK
	    	    	dxDrawRectangle(sX/2 - panelW/2 + 320, sY/2 - panelH/2 + 15 + (i*25), 260, 20, tocolor(20,20,20,255))
	    	    else
                    dxDrawRectangle(sX/2 - panelW/2 + 320, sY/2 - panelH/2 + 15 + (i*25), 260, 20, tocolor(30,30,30,255))
	    	    end

                dxDrawRectangle(sX/2 - panelW/2 + 20, sY/2 - panelH/2 + 15, 260, 200, tocolor(255,255,255,0)) --kocsi(láthatatlan görgetéshez)
	    	    dxDrawRectangle(sX/2 - panelW/2 + 320, sY/2 - panelH/2 + 15, 260, 200, tocolor(255,255,255,0)) --inti(láthatatlan görgetéshez)

	    	    local count = 0
	    	    for k, v in pairs(playerCars) do
	    	    	if k > vScroll and count < maxVehicles then
	    	    		count = count + 1;
		    	    	dxDrawText(v[1]..v[2],sX/2 - panelW/2 + 22, sY/2 - panelH/2 + 16 + (count*25), 260, 20, tocolor(255,255,255,255), 1, "clear", "left", "top", false, false, false, true)
		    	    end
	    	    end
	    	    local count2 = 0
	    	    for k, v in pairs(playerHouses) do
	    	    	if k > hScroll and count2 < maxHouses then
	    	    		count2 = count2 + 1;
		    	    	dxDrawText(v[1]..v[2],sX/2 - panelW/2 + 323, sY/2 - panelH/2 + 16 + (count2*25), 260, 20, tocolor(255,255,255,255), 1, "clear", "left", "top", false, false, false, true)
		    	    end
	    	    end

	    	end
	    elseif tab == 3 then
	    	dxDrawRectangle(sX/2 - panelW/2 + 10, sY/2 - panelH/2 + 10, panelW - 20, panelH - 20, tocolor(20,20,20,pANIM))
	    	centerText("Beállítások" ,sX/2 - panelW/2, sY/2 - panelH/2 - 125, panelW, panelH, tocolor(85,85,85,255), 1, font)
	    	for k, v in pairs(settingsMenu) do
	    		local name,state = unpack(v)
	    		if k % 2 == 0 then
                    dxDrawRectangle(sX/2 - panelW/2 + 10, sY/2 - panelH/2 + 15 + (k*25), panelW - 20, 20, tocolor(25,25,25,255))
                else
                    dxDrawRectangle(sX/2 - panelW/2 + 10, sY/2 - panelH/2 + 15 + (k*25), panelW - 20, 20, tocolor(30,30,30,255))
                end
                if state then
        	    	dxDrawImage(sX/2 - panelW/2 + 20, sY/2 - panelH/2 + 13 + (k*25), 24,24, "files/switch.png", 0, 0, 0, tocolor(112, 152, 207,255))
            	elseif not state then
                    dxDrawImage(sX/2 - panelW/2 + 20, sY/2 - panelH/2 + 13 + (k*25), 24,24, "files/switch.png", 180, 0, 0, tocolor(45,45,45,255))
                end
                centerText(v[1],sX/2 - panelW/2 + 10, sY/2 - panelH/2 + 15 + (k*25), panelW - 20, 20, tocolor(255,255,255,255), 1, font)               
	    	end
	    	centerText("Ezek a beállítások súlyos befolyással lehetnek az FPS-edre!\nA lista idővel #7098CFbővülni fog!" ,sX/2 - panelW/2, sY/2 - panelH/2 + 50, panelW, panelH, tocolor(125,125,125,255), 1, font)
	    elseif tab == 4 then
	    	dxDrawRectangle(sX/2 - panelW/2 + 10, sY/2 - panelH/2 + 10, panelW - 20, panelH - 20, tocolor(20,20,20,pANIM))
	    	dxDrawRectangle(sX/2 - panelW/2 + 10, sY/2 - panelH/2 + 120, panelW - 20, 150, tocolor(0,0,0,50))
	    	centerText("Szerver támogatás (Prémium pont)" ,sX/2 - panelW/2, sY/2 - panelH/2 - 125, panelW, panelH, tocolor(85,85,85,255), 1, font)
	    	centerText("Ha támogatni szeretnéd a szevert, illetve a szerveren\ndolgozó #7098CFFejlesztőket#ffffff, keress fel egy\n#7098CFTulajdonos#ffffff a discord szerveren!\nDiscord meghívó: #7098CFhttps://discord.gg/PF58SKfqXZ\n#ffffffKattints ide a Discord meghívó #7098CFkimásolásához!" ,sX/2 - panelW/2, sY/2 - panelH/2 + 40 , panelW, panelH, tocolor(255,255,255,255), 1, font)
	    	for k, v in pairs(premiumPacks) do
	    		if k % 2 == 0 then
                    dxDrawRectangle(sX/2 - panelW/2 + 10, sY/2 - panelH/2 + 15 + (k*25), panelW - 20, 20, tocolor(25,25,25,255))
                else
                    dxDrawRectangle(sX/2 - panelW/2 + 10, sY/2 - panelH/2 + 15 + (k*25), panelW - 20, 20, tocolor(30,30,30,255))
                end
                centerText(v[1]..v[2]..v[3],sX/2 - panelW/2 + 10, sY/2 - panelH/2 + 15 + (k*25), panelW - 20, 20, tocolor(255,255,255,255), 1, font)
	    	end
	    end
    end
end

--MEGNYITÁS

addEventHandler("onClientKey",root,function(button,state)
	if getElementData(localPlayer,"char > loggedin") then 
	    if button == "home" and state then 
	    	cancelEvent()
	        if tab == 0 then 
	            panelState = "open"
	            tab = 1
	            vScroll = 0;
	            hScroll = 0;	            
	            removeEventHandler("onClientRender",root,dashDraw)
	            addEventHandler("onClientRender",root,dashDraw)
	            setElementData(localPlayer, "char > toghud", false)
	            showChat(false)
	            tick = getTickCount()
	            for k,v in pairs(getElementsByType("vehicle")) do 
			        if getElementData(v,"veh > id") then 
			            if getElementData(v,"veh > faction") == 0 then
			                if getElementData(v,"veh > owner") == getElementData(localPlayer,"char > accoutid") then 
			                    playerCars[#playerCars + 1] = v;
			                end
			            end
			        end
			    end
			    for k,v in pairs(getElementsByType("marker")) do 
			        if getElementData(v,"int > id") then 
			            if getElementData(v,"int > owner") == getElementData(localPlayer,"char > accoutid") then
			                playerHouses[#playerHouses + 1] = v;
			            end
			        end
			    end
			    for k,v in pairs(images) do
			        if tab == 1 then
			            k = tab 
                        drawAnimation(k, k)   
                    end                     
	            end
	        elseif tab > 0 then 
	            panelState = "close"
	            tab = 0
	            removeEventHandler("onClientRender",root,dashDraw)
	            setElementData(localPlayer, "char > toghud", true)
	            showChat(true)
	            tick = getTickCount()
	            destroyAnimation()
	        end
	    end
	end
end)

--kattintások, mentések, egyéb funkciók

addEventHandler("onClientKey",root,function(button,state)
	if button == "mouse1" and state and panelState == "open" then 
		if getElementData(localPlayer,"char > loggedin") then
	        if tab > 0 then 
	            for k,v in pairs(images) do 
	                if exports.ml_core:isInSlot(sX/2 - panelW/2 - 55, sY/2 - panelH/2 - 55 + (k*55), 50, 50) then --OLDAL VÁLTÁS
	                    if k ~= tab then 
	                        tab = k;
	                        drawAnimation(k, k)
	                        local sound = playSound("files/click.mp3")	                        
	                    end
	                end
	            end
	        end
	    end
		if button == "mouse1" and state and panelState == "open" then --DISCORD MEGHIVÓ
			if getElementData(localPlayer,"char > loggedin") and tab == 4 then
				if exports.ml_core:isInSlot(sX/2 - panelW/2 + 10, sY/2 - panelH/2 + 120, panelW - 20, 150) then
			        outputChatBox("[INFO] #ffffffDiscord meghívó kimásolva vágólapra. #7098CF(https://discord.gg/PF58SKfqXZ)", 112, 152, 207, true)
			        local copy = setClipboard("https://discord.gg/PF58SKfqXZ")
			        exports.ml_notification:addNotification("Discord meghívó vágólapra másolva!", "info")
			    end
			end
		end
		if button == "mouse1" and state and panelState == "open" then --Shader szarok
			if getElementData(localPlayer,"char > loggedin") and tab == 3 then
				for k,v in pairs(settingsMenu) do 
					local name,state = unpack(v);
	                if exports.ml_core:isInSlot(sX/2 - panelW/2 + 10, sY/2 - panelH/2 + 15 + (k*25), panelW - 20, 20) then --beállítások
	                    shaderSelect(k,not state)
	                end
	            end
			end
		end		
    end
end)

--vagyon görgetés

addEventHandler("onClientKey",root,function(button,state)
	if button == "mouse_wheel_up" and state then
        if exports.ml_core:isInSlot(sX/2 - panelW/2 + 20, sY/2 - panelH/2 + 15, 260, 200) and tab == 2 then
            if vScroll > 0 then
                vScroll = vScroll - 1;
               
            end
        end
        if exports.ml_core:isInSlot(sX/2 - panelW/2 + 320, sY/2 - panelH/2 + 15, 260, 200) and tab == 2 then
            if hScroll > 0 then
                hScroll = hScroll - 1;
            end
        end
    end
    if button == "mouse_wheel_down" and state then 
        if exports.ml_core:isInSlot(sX/2 - panelW/2 + 20, sY/2 - panelH/2 + 15, 260, 200) and tab == 2 then
            if vScroll < #playerCars - maxVehicles then
                vScroll = vScroll + 1;
            end
        end
        if exports.ml_core:isInSlot(sX/2 - panelW/2 + 320, sY/2 - panelH/2 + 15, 260, 200) and tab == 2 then 
            if hScroll < #playerHouses - maxHouses then 
                hScroll = hScroll + 1;
            end
        end
    end
    --[[if button == "mouse1" and state and panelState == "open" then --Shader szarok
		if getElementData(localPlayer,"char > loggedin") and tab == 2 then
			for k,v in pairs(playerCars) do 
				if exports.ml_core:isInSlot(sX/2 - panelW/2 + 22, sY/2 - panelH/2 + 16 + (k*25), 260, 20) then
					outputChatBox(v[1])
				end
			end
			for k,v in pairs(playerHouses) do 
				if exports.ml_core:isInSlot(sX/2 - panelW/2 + 323, sY/2 - panelH/2 + 16 + (k*25), 260, 20) then
					outputChatBox(v[1])
				end
			end
	    end
	end]]
end)

function saveShaders()
    if fileExists("east_shaders.xml") then 
        fileDelete("east_shaders.xml")
    end
    local file = xmlCreateFile("east_shaders.xml","eastmta")
    for k,v in pairs(settingsMenu) do 
        local name,state = unpack(v)
        if state then 
            state = 1
        else 
            state = 0
        end
        local child = xmlCreateChild(file,"ml_shader_"..tostring(k))
        xmlNodeSetValue(child,tostring(state))
    end
    xmlSaveFile(file)
    xmlUnloadFile(file)
    outputDebugString("Shaderek elmentve!",0,100,100,100)
end
addEventHandler("onClientResourceStop",resourceRoot,saveShaders)

addEventHandler("onClientResourceStart",resourceRoot,function()
    if fileExists("east_shaders.xml") then 
        local file = xmlLoadFile("east_shaders.xml")
        for k, v in pairs(settingsMenu) do 
            local name,state = unpack(v)
            local saveState = tonumber(xmlNodeGetValue(xmlFindChild(file,"ml_shader_"..tostring(k),0)))
            if saveState then 
                if saveState == 1 then 
                    saveState = true
                else 
                    saveState = false
                end
                settingsMenu[k] = {name,saveState}
                shaderSelect(k,saveState)
            end
        end
        xmlUnloadFile(file)
        outputDebugString("Shaderek betöltve!",0,100,100,100)
    end
end)

function shaderSelect(id, state)
	if id == 1 then
		if state then
			enableDetail()
		else
			disableDetail()
		end	
	elseif id == 2 then
		if state then
			startCarPaintReflect()
		else
			stopCarPaintReflect()
		end
    elseif id == 3 then
    	if state then
    		enableContrast()
    	else
            disableContrast()
    	end
	end
	settingsMenu[id][2] = state
end

function centerText(text, x, y, w, h, color, fontS, font)
    dxDrawText(text, x+w/2, y+h/2, x+w/2, y+h/2, color, fontS, font, "center", "center", false, false, false, true)
end 

function leftText(text, x, y, w, h, color, fontS, font)
    dxDrawText(text, x+w/2, y+h/2, x+w/2, y+h/2, color, fontS, font, "left", "center", false, false, false, true)
end 

function rightText(text, x, y, w, h, color, fontS, font)
    dxDrawText(text, x+w/2, y+h/2, x+w/2, y+h/2, color, fontS, font, "right", "center", false, false, false, true)
end 

local boxPadding = false
local tick = getTickCount()

function renderAnimation(i, clicked)
	if boxPadding then
		local animation = interpolateBetween(0, 0, 0, 50, 0, 0, (getTickCount() - tick) / 500, 'Linear')
		dxDrawRectangle(sX/2 - panelW/2 - 55, sY/2 - panelH/2 - 55 - 2 + (boxPadding*55), animation, 2, tocolor(112, 152, 207))
	end
end


function destroyAnimation()
	removeEventHandler('onClientRender', root, renderAnimation)
	tick = getTickCount()
end

function drawAnimation(i, clicked)
	if i == clicked then
		destroyAnimation()
		boxPadding = i
		removeEventHandler('onClientRender', root, renderAnimation)
		addEventHandler('onClientRender', root, renderAnimation)
	end
end
