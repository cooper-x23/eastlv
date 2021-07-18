--Script by LENNON (112, 152, 207) #7098CF
local font = exports.ml_core:getFont("eastFont",10)

bindKey("y", "down", "chatbox", "Rádió")
bindKey("b", "down", "chatbox", "LocalOOC")

local OOCCache = {}

function getRandomString()
    local message = ""
    for i=1,100 do
        message = message .. math.random(0,9)
    end
    return message
end

addCommandHandler("clearchat",
    function()
        for i=1, getChatboxLayout()["chat_lines"] do
            outputChatBox("")
        end
    end
)

local icChatTimers = {}
local meChatTimers = {}
local doChatTimers = {}
local icChatFadeTime = 150

-- chat dolgok

addEventHandler ( "onClientElementDataChange", getRootElement(),function ( dataName )
    if getElementData(source, "char > loggedin") == true then
        if getElementType ( source ) == "player" and dataName == "onClientSendICMessage" then
            local x,y,z = getElementPosition(localPlayer)
            local newMSG = getElementData(source, "onClientSendICMessage")
			local playerName = getElementData(source, "char > name"):gsub("_", " ")
            if newMSG then
            	--[[if (isPedInVehicle(source)) then
				local vehSource = getPedOccupiedVehicle(source)
				local maxSeat = getVehicleMaxPassengers(vehSource)
					for i = 0, maxSeat do
						local vehOccupantPlayers = getVehicleOccupant(vehSource, i)
						if (vehOccupantPlayers) then
							outputChatBox("" ..playerName .. " mondja #7098CF(Járműben)#ffffff: ".. newMSG:sub(1,1):upper()..newMSG:sub(2), 255,255,255,true)
						end
	                    if isTimer ( icChatTimers [ source ] ) then
	                        killTimer ( icChatTimers[source])
	                        icChatTimers[source] = nil
	                    end
	                    local source = source
	                    icChatTimers[source] = setTimer ( function() setElementData ( source, "onClientSendICMessage", nil, false ) end, newMSG:len()* icChatFadeTime, 1 )
	                    setElementData(source, "onClientSendICMessage", nil)
				    end]]
                if getDistanceBetweenPoints3D(x, y, z, getElementPosition(source)) <= 10 or source == localPlayer then
                    outputChatBox("" ..playerName .. " mondja: ".. newMSG:sub(1,1):upper()..newMSG:sub(2), 255,255,255,true)
                    if isTimer ( icChatTimers [ source ] ) then
                        killTimer ( icChatTimers[source])
                        icChatTimers[source] = nil
                    end
                    local source = source
                    icChatTimers[source] = setTimer ( function() setElementData ( source, "onClientSendICMessage", nil, false ) end, newMSG:len()* icChatFadeTime, 1 )
                    setElementData(source, "onClientSendICMessage", nil)
                end
            end
            
        elseif getElementType ( source ) == "player" and dataName == "onClientSendMeMessage" then
            local x,y,z = getElementPosition(localPlayer)
            local newMSG = getElementData(source, "onClientSendMeMessage")
            local playerName = getElementData(source, "char > name"):gsub("_", " ")
            if newMSG then
                if getDistanceBetweenPoints3D(x, y, z, getElementPosition(source)) <= 10 or source == localPlayer then
                    outputChatBox("#b1cae2* " .. playerName .. " ".. newMSG, 185, 162, 209,true)
                    setElementData(source, "onClientSendMeMessage", nil)
                    if isTimer ( meChatTimers [ source ] ) then
                        killTimer ( meChatTimers[source])
                        meChatTimers[source] = nil
                    end
                    local source = source
                    meChatTimers[source] = setTimer ( function() setElementData ( source, "onClientSendMeMessage", nil ) end, newMSG:len()* icChatFadeTime, 1 )
                end
            end
        elseif getElementType ( source ) == "player" and dataName == "onClientSendDoMessage" then
            local x,y,z = getElementPosition(localPlayer)
            local newMSG = getElementData(source, "onClientSendDoMessage")
            local playerName = getElementData(source, "char > name"):gsub("_", " ")
            if newMSG then
                if getDistanceBetweenPoints3D(x, y, z, getElementPosition(source)) <= 10 or source == localPlayer then
                    outputChatBox("#EE4242*** " .. newMSG:sub(1,1):upper()..newMSG:sub(2) .. " ((" .. playerName .. "))  ", 232, 35, 72,true)
                    setElementData(source, "onClientSendDoMessage", nil)
                    if isTimer ( doChatTimers [ source ] ) then
                        killTimer ( doChatTimers[source])
                        doChatTimers[source] = nil
                    end
                    local source = source
                    doChatTimers[source] = setTimer ( function() setElementData ( source, "onClientSendDoMessage", nil, false ) end, newMSG:len()* icChatFadeTime, 1 )
                end
            end
        elseif getElementType ( source ) == "player" and dataName == "onClientSendShoutMessage" then
            local x,y,z = getElementPosition(localPlayer)
            local newMSG = getElementData(source, "onClientSendShoutMessage")
            local playerName = getElementData(source, "char > name"):gsub("_", " ")
            if newMSG then
                if getDistanceBetweenPoints3D(x, y, z, getElementPosition(source)) <= 25 or source == localPlayer then
                    outputChatBox("" .. playerName .. " ordítja: " .. newMSG:sub(1,1):upper()..newMSG:sub(2), 255, 255, 255)
                    setElementData(source, "onClientSendShoutMessage", nil)
                    if isTimer ( doChatTimers [ source ] ) then
                        killTimer ( doChatTimers[source])
                        doChatTimers[source] = nil
                    end
                    local source = source
                    doChatTimers[source] = setTimer ( function() setElementData ( source, "onClientSendShoutMessage", nil, false ) end, newMSG:len()* icChatFadeTime, 1 )
                end
            end
        elseif getElementType ( source ) == "player" and dataName == "onCliendSendOOCMessage" then
            local x,y,z = getElementPosition(localPlayer)
            local newMSG = getElementData(source, "onCliendSendOOCMessage")
            local playerName = getElementData(source, "char > name"):gsub("_", " ")
            local aName = getElementData(source, "char > adminnick") or "Ismeretlen Admin"
            if newMSG then
                if getDistanceBetweenPoints3D(x, y, z, getElementPosition(source)) <= 10 or source == localPlayer then
                   -- outputChatBox("" ..playerName .. ": (( " .. newMSG:sub(1,1)..newMSG:sub(2) .. " ))", 190,190,190)
                    if not getElementData(source, "char > adminduty") then

                        insertOOC("(OOC): "..playerName..": ".. newMSG:sub(1,1)..newMSG:sub(2) .." ")
                        setElementData(source, "onCliendSendOOCMessage", nil)
                   
                    else
                        insertOOC("(OOC): #7098CF"..exports.ml_core:getAdminRank(localPlayer).."#ffffff "..aName..": ".. newMSG:sub(1,1)..newMSG:sub(2) .."")
                        setElementData(source, "onCliendSendOOCMessage", nil)
                    end
                    if isTimer ( doChatTimers [ source ] ) then
                        killTimer ( doChatTimers[source])
                        doChatTimers[source] = nil
                    end
                    local source = source
                    doChatTimers[source] = setTimer ( function() setElementData ( source, "onCliendSendOOCMessage", nil, false ) end, newMSG:len()* icChatFadeTime, 1 )
                end
            end
        end
    end
end)

-- kilépés szöveg cucc

reason2 = " "
addEventHandler ( "onClientPlayerQuit",getRootElement(),function (reason)
    if getElementData(source, "char > loggedin") == true then
        if getElementType ( source ) == "player" then
            local x,y,z = getElementPosition(localPlayer)
            local newMSG = getElementData(source, "onClientQuit")
            local name = getPlayerName(source):gsub("_", " ")
            if reason == "Quit" then
                 reason2 = "Kilépett"
            elseif reason == "Kicked" then
                 reason2 = "Kickelve"
            elseif reason == "Banned" then
                reason2 = "Kitiltva"
            elseif reason == "Timed Out" then
               reason2 = "Időtúllépés"
            elseif reason == "Bad Connection" then
               reason2 = "Rossz kapcsolat - Időtúllépés"
            end
            if newMSG then
                if getDistanceBetweenPoints3D(x, y, z, getElementPosition(source)) <= 25 or source == localPlayer then
                    outputChatBox("" ..name .. " lecsatlakozott a közeledben. (" .. reason2 .. ") ",109, 109, 109,true)
                end
            end
        end
    end
end)


addCommandHandler("do",
    function(_, ...)
        if ... then
            local message = table.concat({...}, " ")
            if message then
                setElementData(localPlayer, "onClientSendDoMessage", message)
            end
        else
            outputChatBox("[Használat]: /do [szöveg]",255, 255, 255,true)
        end
    end
)

addCommandHandler("me",
    function(_, ...)
        if ... then
            local message = table.concat({...}, " ")
            if message then
                setElementData(localPlayer, "onClientSendMeMessage", message)
            end
        else
            outputChatBox("[Használat]: /me [szöveg]",255, 255, 255,true)
        end
    end
)

addCommandHandler("s",
    function(_, ...)
        if ... then
            local message = table.concat({...}, " ")
            if message then
                setElementData(localPlayer, "onClientSendShoutMessage", message)
            end
        else
            outputChatBox("[Használat]: /s [szöveg]",255, 255, 255,true)
        end
    end
)

-- ooc

function insertOOC(text)
    if #OOCCache >= 10 then
        table.remove(OOCCache,10)
    end
    table.insert (OOCCache,1,text)
    outputConsole("[OOC] " .. text:gsub("#%x%x%x%x%x%x",""))
end

function OOC(_, ...)
    if ... then
        local message = table.concat({...}, " ")
        if message then
            setElementData(localPlayer, "onCliendSendOOCMessage", message)
        end
    else
        outputChatBox("[Használat]: /b [szöveg]",255, 255, 255,true)
    end
end
addCommandHandler("b", OOC)
addCommandHandler("LocalOOC", OOC)

function clearOOC(cmd)
    outputChatBox("OOC Chat sikeresen kiürítve!", 255,255,255,true)
    OOCCache = {}
end
addCommandHandler("clearooc", clearOOC,false,false)
addCommandHandler("co", clearOOC,false,false)

local showOOC = true;

function togOOC(cmd)
    showOOC = not showOOC;
    if showOOC then 
        outputChatBox("OOC Chat sikeresen bekapcsolva!", 255,255,255,true)
    else 
        outputChatBox("OOC Chat sikeresen kikapcsolva!", 255,255,255,true)
    end
end
addCommandHandler("togooc", togOOC,false,false);


local oocAlpha = 0
local togAlpha = false

addCommandHandler("oocbg", function()
    if togAlpha then
	    togAlpha = false
	else
		togAlpha = true
	end
end)

function drawnOOC()
    if showOOC and getElementData(localPlayer, "char > toghud") then 
    	if exports.ml_interface:isWidgetShowing("ooc") then
	        local oocfont = "default-bold";
	        local x,y = getElementData(localPlayer,"ooc.x"),getElementData(localPlayer,"ooc.y")
	        if togAlpha then
	            dxDrawRectangle(x -2, y - 23, 330, 180, tocolor(0,0,0,120)) 
	        else
                dxDrawRectangle(x - 2, y - 23, 330, 180, tocolor(50,50,50,0)) 
	        end
	        dxDrawText("Törléshez: /co Háttér eltüntetés, előhozás: /oocbg", x + 1, y - 8, x, y - 15, tocolor(0,0,0,255), 1, font, "left", "center",false,false,false,true)
	        dxDrawText("Törléshez: #7098CF/co#ffffff Háttér eltüntetés, előhozás: #7098CF/oocbg", x, y - 10, x, y - 15, tocolor(255,255,255,255), 1, font, "left", "center",false,false,false,true)

	        for k,v in ipairs(OOCCache) do
	            local ay = 165-(k*15)
	            dxDrawText(v:gsub("#%x%x%x%x%x%x",""), x + 1, y + ay - 18, x, y + ay, tocolor(0,0,0), 1, font, "left", "center",false,false,false,true)
	            dxDrawText(v, x, y + ay - 20, x, y + ay, tocolor(255,255,255), 1, font, "left", "center",false,false,false,true)
	        end
	    end
    end
end
addEventHandler("onClientRender", root, drawnOOC, true, "low-5")

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
