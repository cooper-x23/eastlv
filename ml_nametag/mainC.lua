--Script by LENNON  (112, 152, 207) #7098CF

local sX, sY = guiGetScreenSize()
local togNames = true
local showOwnName = false
local maxDist = 13;
local timerClient = 0
local font = "default"
local core = exports.ml_core
local damageTimer = false
local damaged = {}
local pedCache = {}
local playerCache = {}
local font = exports.ml_core:getFont("eastFont",10)
local rel = sX/1920

for _, player in pairs(getElementsByType("player")) do
    setPlayerNametagShowing(player, false)
end

addEventHandler("onClientPlayerJoin", getRootElement(), 
    function()
        setPlayerNametagShowing(source, false)
    end
)

addEventHandler("onClientElementStreamIn",getRootElement(),function()
	if getElementType(source) == "player" then 
        if not playerCache[source] then  
            playerCache[source] = {
                id = getElementData(source,"char > id"),
                afk = getElementData(source,"afk"),
                afktime = getElementData(source,"afk.time"),
                typing = getElementData(source,"playerChat"),
                consoleUse = getElementData(source,"console"),
            };
        end
    end
    if getElementType(source) == "ped" then 
        if not pedCache[source] then 
            if not (getElementData(source,"ped >> noName") or false) then 
                pedCache[source] = {
                    name = getElementData(source,"ped > name") or "Névtelen",
                    type = getElementData(source,"ped > type") or "Típustalan",
                }
            end
        end
    end
end)

addEventHandler("onClientElementStreamOut",getRootElement(),function()
	if getElementType(source) == "player" then 
        if playerCache[source] then 
            playerCache[source] = nil;
        end
    end
    if getElementType(source) == "ped" then 
        if pedCache[source] then 
            pedCache[source] = nil
        end
    end
end)

addEventHandler("onClientPlayerQuit",getRootElement(),function()
    if getElementType(source) == "player" then 
        if playerCache[source] then 
            playerCache[source] = nil
        end
    end
end)


addEventHandler("onClientRender", root, 
    function()
        if togNames then
            if not getElementData(localPlayer, "char > loggedin") then return end
            local x1, y1, z1 = getElementPosition(localPlayer);
            local camX, camY, camZ = getCameraMatrix();
            for _, player in pairs(getElementsByType("player", _, true)) do
                if isElement(player) and isElementOnScreen(player) and getElementAlpha(player) ~= 0 then
                    if player ~= localPlayer or showOwnName then
                        local x2, y2, z2 = getElementPosition(player)
                        local headX, headY, headZ = getPedBonePosition(player, 6)
                        
                        local dist = getDistanceBetweenPoints3D(x1, y2, z1, x2, y2, z2)
                        
                        local clear = isLineOfSightClear(camX, camY, camZ, x2, y2, headZ, true, false, false, true, false, false, false)
                        
                        if dist < 15 and clear then
                            local x, y = getScreenFromWorldPosition(headX, y2, headZ+0.25)
                            
                            local ID =  "(" .. getElementData(player, "char > id") .. ")"
                            local name = (getElementData(player, "char > adminduty") and getElementData(player, "char > adminnick")) or getElementData(player, "char > name")
                            local admin = ""
                            if getElementData(player, "char > adminduty") then
                            	admin_level = ""
                            	admin_color = ""
                                if getElementData(player, "char > admin") == 3 then
                                    admin_level = "#7098CF (Admin 1)"
                                    admin_color = tocolor(41, 128, 185, 255)
                                elseif getElementData(player, "char > admin") == 4 then
                                    admin_level = "#7098CF (Admin 2)"
                                    admin_color = tocolor(41, 128, 185, 255)
                                elseif getElementData(player, "char > admin") == 5 then
                                    admin_level = "#7098CF (Admin 3)"
                                    admin_color = tocolor(41, 128, 185, 255)
                                elseif getElementData(player, "char > admin") == 6 then
                                    admin_level = "##7098CF (Admin 4)" 
                                    admin_color = tocolor(41, 128, 185, 255)
                                elseif getElementData(player, "char > admin") == 7 then
                                    admin_level = "#efad5f (FőAdmin)"
                                    admin_color = tocolor(239, 173, 95, 255)
                                elseif getElementData(player, "char > admin") == 8 then
                                    admin_level = "#BC14E0 (SzuperAdmin)" 
                                    admin_color = tocolor(118, 20, 224, 255)
                                elseif getElementData(player, "char > admin") == 9 then
                                    admin_level = "#E09A14 (Server-Manager)"  
                                    admin_color = tocolor(224, 154, 20, 255)
                                elseif getElementData(player, "char > admin") == 10 then
                                    admin_level = "#E6413D (Tulajdonos)"
                                    admin_color = tocolor(230, 65, 61, 255)
                                elseif getElementData(player, "char > admin") == 11 then
                                    admin_level = "#7098CF (<Fejlesztő/>)"
                                    admin_color = tocolor(0, 174, 239, 255)
                                end

                            	name = getElementData(player, "char > adminnick")
                            	admin = ""..admin_level..""


                                if not getElementData(player, "playerChat") and x and y and not getElementData (player,"afk") and not getElementData(player, "console") then
                                    --dxDrawImage(x - 50 - 2, y - 100, 100, 100, "logo.png", 0, 0, 0, tocolor(0, 0, 0, 255))
                            	    --dxDrawImage(x - 50, y - 100, 100, 100, "logo.png", 0, 0, 0, admin_color)
                                end
                                
                         

                            end

                            name = string.gsub(name, "_", " ")
                            local text = ID .. " " .. name ..""..admin 
                            
                            local textW = dxGetTextWidth(text, scale, font, true)
                            local scale = 1--interpolateBetween(1.7, 0, 0, 0.5, 0, 0, (dist/maxDist), "Linear")
                            
                            local textColor = ((damaged[player] or false) and tocolor(220, 75, 75, 255)) or tocolor(255, 255, 255, 255)
                            
                            if getElementHealth(player) == 0 then
                                textColor = tocolor(31, 31, 31, 255)
                            end
                            
                            if x and y and text then
                            	dxDrawText(text:gsub("#%x%x%x%x%x%x",""), x-textW/2 + 2, y + 2, x+textW/2, y+3, tocolor(0, 0, 0, 255), scale, font, "center", "center", false, false, false, true)
                                dxDrawText(text, x-textW/2, y, x+textW/2, y+3, textColor, scale, font, "center", "center", false, false, false, true);

                            end
                            if getElementData(player, "afk") and  x and y then
                                dxDrawImage(x - 30 , y - 100, 63, 63, "files/afk.png", 0, 0, 0, tocolor(0,0,0, 150))    
                                dxDrawText("Afk "..getElementData(player,"afk.time").. " másodperce.", x-textW/2 + 10, y - 50, x+textW/2, y+3, tocolor(0,0,0,150), scale, font, "center", "center", false, false, false, true);                 
                            end
                            if getElementData(player, "playerChat") and not getElementData (player,"afk") and x and y then
                            	dxDrawImage(x - 30 , y - 80, 63, 63, "files/chat.png", 0, 0, 0, tocolor(0,0,0, 150))   
                            end
                            local active = (isConsoleActive())
                            if not getElementData(player, "playerChat") and x and y and not getElementData (player,"afk") and getElementData(player, "console") then
                                dxDrawImage(x - 55 , y - 110, 120, 120, "files/console.png", 0, 0, 0, tocolor(0, 0, 0, 150)) 
                            end
	                
                        end
                    end
                    for v,k in pairs(pedCache) do 
                    	local x, y, z = getElementPosition(localPlayer);
			            if isElement(v) then 
			                if isElementOnScreen(v) then 
			                    local px,py,pz = getPedBonePosition(v,8);
			                    if not processLineOfSight(x, y, z, px, py, pz, true, false, false, true, false, true) then 
			                        local pdistance = getDistanceBetweenPoints3D(x,y,z,px,py,pz)
			                        if pdistance < 10 then 
			                            local sx,sy = getScreenFromWorldPosition(px, py, pz+0.3, 0.06);
			                            if sx and sy then 
			                                local name = k.name.."  #7098CF[NPC ("..k.type..")]"
			                                local name2 = k.name.."  #7098CF[NPC ("..k.type..")]"
			                                local progress = pdistance/30
			                                if getElementData(v, "ped > type") then
			                                    name = k.name.."  #7098CF[NPC ("..k.type..")]"
			                                    name2 = k.name.." [NPC ("..k.type..")]"
			                                else
			                                    name = k.name.." #7098CF[NPC]"
			                                    name2 = k.name.."  #7098CF[NPC]"
			                                end
			                                dxDrawImage(sx - 20,sy - 60, 43, 43, "files/npc.png", 0, 0, 0, tocolor(0,0,0, 150))
			                                dxDrawText(name:gsub("#%x%x%x%x%x%x",""),sx-100 + 2,sy,sx+100,sy,tocolor(0,0,0),1,font,"center","center",false,false,false,true)
			                                dxDrawText(name,sx-100,sy,sx+100,sy,tocolor(255,255,255),1,font,"center","center",false,false,false,true)
			                            end
			                        end
			                    end
			                end
			            else 
			                pedCache[v] = nil;
			            end
			        end
                end
            end
        end
    end
)

local console_cucc = setElementData(getLocalPlayer(), "console", false)

addEventHandler("onClientRender", getRootElement(),
function()
   local active = isConsoleActive()
   if active then

       setElementData(getLocalPlayer(), "console", true)

   else

       setElementData(getLocalPlayer(), "console", false)

   end
end)

addEventHandler("onClientPlayerDamage", getRootElement(), 
function()
    local player = source;
    damaged[player] = true;
    damageTimer =
    setTimer(
        function()
            damaged[player] = false;
            damageTimer = false;
        end
    , 3000, 1);
end)


addCommandHandler("tognames", 
function()
    togNames = not togNames
end)

addCommandHandler("showname", 
function()
    showOwnName = not showOwnName
end)

local chatting = 0
local chatters = { }

function checkForChat()
    local recon = getElementData(getLocalPlayer(), "reconx")
    
    if not (reconx) then
        if (isChatBoxInputActive() and chatting==0) then
            chatting = 1
            setElementData(getLocalPlayer(), "playerChat", true)
            triggerServerEvent("chat1", getLocalPlayer())
        elseif (not isChatBoxInputActive() and chatting==1) then
            chatting = 0
            triggerServerEvent("chat0", getLocalPlayer())
            setElementData(getLocalPlayer(), "playerChat", false)
        end
    end
end
setTimer(checkForChat, 100, 0)


function addChatter()
    for key, value in ipairs(chatters) do
        if ( value == source ) then
            return
        end
    end
    table.insert(chatters, source)
end
addEvent("addChatter", true)
addEventHandler("addChatter", getRootElement(), addChatter)

function delChatter()
    for key, value in ipairs(chatters) do
        if ( value == source ) then
            table.remove(chatters, key)
        end
    end
end
addEvent("delChatter", true)
addEventHandler("delChatter", getRootElement(), delChatter)
addEventHandler("onClientPlayerQuit", getRootElement(), delChatter)

local afkTimer = false;
local lastClick = 0

addEventHandler("onClientResourceStart",resourceRoot,function()
	setElementData(localPlayer,"afk.time",0)
	setElementData(localPlayer,"afk",false)
	if not isMTAWindowActive() then 
		setElementData(localPlayer,"afk",true)
		setElementData(localPlayer,"afk.time",0)
		if isTimer(afkTimer) then 
			killTimer(afkTimer)
		end
		afkTimer = setTimer(function()
			setElementData(localPlayer,"afk.time",getElementData(localPlayer,"afk.time")+1)
			--outputChatBox(getElementData(localPlayer,"afk.time"))
		end,1000,0);
	end
end)

addEventHandler("onClientRestore", getLocalPlayer(),
function()
	lastClick = getTickCount ()
	setElementData(localPlayer,"afk",false)
	setElementData(localPlayer,"afk.time",0)
	if isTimer(afkTimer) then 
		killTimer(afkTimer)
        setElementData(localPlayer,"afk.time",0)
	end
end)

addEventHandler("onClientKey", getRootElement(), 
function()
	lastClick = getTickCount ()
	if getElementData(localPlayer,"afk") then
		setElementData (localPlayer,"afk",false)
		setElementData(localPlayer,"afk.time",0)
		if isTimer(afkTimer) then 
			killTimer(afkTimer)
            setElementData(localPlayer,"afk.time",0)
		end
	end
end)

addEventHandler("onClientMinimize", getRootElement(),
function()
	setElementData(localPlayer,"afk",true)
	if isTimer(afkTimer) then 
		killTimer(afkTimer)
        setElementData(localPlayer,"afk.time",0)
	end
	afkTimer = setTimer(function()
		setElementData(localPlayer,"afk.time",getElementData(localPlayer,"afk.time")+1);
		--outputChatBox(getElementData(localPlayer,"afk.time"))
	end,1000,0);
end)

addEventHandler ("onClientRender",getRootElement(),
function()
	local cTick = getTickCount ()
	if cTick-lastClick >= 10000 then
		if not getElementData(localPlayer,"afk") then
			local hp = getElementHealth(localPlayer);
			if hp > 0 then
				setElementData (localPlayer,"afk",true)
				if isTimer(afkTimer) then 
					killTimer(afkTimer)
				end
				afkTimer = setTimer(function()
					setElementData(localPlayer,"afk.time",getElementData(localPlayer,"afk.time")+1);
					--outputChatBox(getElementData(localPlayer,"afk.time"))
                    -- triggerServerEvent('afkTimerServer', root, getElementData(localPlayer,"afk.time")+1)
				end,1000,0);
			end
		end
	end
end)

addEventHandler("onClientCursorMove", getRootElement(),
function(x,y)
	lastClick = getTickCount ()
	if getElementData(localPlayer,"afk") then
		setElementData (localPlayer,"afk",false)
		if isTimer(afkTimer) then 
			killTimer(afkTimer)
            setElementData(localPlayer,"afk.time",0)
		end
	end
end)