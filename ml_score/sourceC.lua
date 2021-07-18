--Script by LENNON  (112, 152, 207) #7098CF
local screenX, screenY = guiGetScreenSize()
local serverSlots = 10
local sizes = {
	["Scoreboard"] = {400, 455},
	["Logo"] = {50, 50},
}

local font = dxCreateFont( "files/font.ttf", 12 )
local tick, toggle
local selectedTable = 1
local maxShow = 12
local scrolling_score = 0
local activePlayers = {} 
local showScoreBoard = false

function scoreboard_draw()
    if showScoreBoard == true then
    	for i,v in ipairs(getElementsByType("player")) do
		    activePlayers[i] = v
	    end
       
		table.sort(activePlayers, function(a, b)
		    if a ~= localPlayer and b ~= localPlayer and getElementData(a, "char > id") and getElementData(b, "char > id" ) then
		    	return tonumber(getElementData(a, "char > id") or 0) < tonumber(getElementData(b, "char > id") or 0)
		    end
		end)

		now = getTickCount()
		local yANIM, alpha = interpolateBetween(-5, 0, 0, 20, 255, 0, now / 7000, "CosineCurve")
        local p = ( getTickCount() - tick ) / 300
        local pANIM = interpolateBetween(0, 0, 0, 240, 255, 255, p, "Linear")

		dxDrawRectangle(screenX/2-sizes["Scoreboard"][1]/2, screenY/2-sizes["Scoreboard"][2]/2+25, sizes["Scoreboard"][1], sizes["Scoreboard"][2], tocolor(20,20,20,pANIM))
		centerText("#7098CFEast#ffffffMTA#ffffff - #ffffffLas Venturas #6a6a6a("..getOnlinePlayers().."/"..serverSlots..")", screenX/2-sizes["Scoreboard"][1]/2+3, screenY/2-sizes["Scoreboard"][2]/2+3 + 26, sizes["Scoreboard"][1]-6, sizes["Scoreboard"][2]-427, tocolor(200,200,200,255), 0.8, font)
       -- dxDrawImage(screenX/2-sizes["Logo"][1]/2 -180, screenY/2-sizes["Logo"][2]/2-182, sizes["Logo"][1], sizes["Logo"][2], "files/logo.png", 0,0,0, tocolor(255,255,255,pANIM))
       
        for i=1,maxShow do
            if i % 2 == 0 then
                dxDrawRectangle(screenX/2-sizes["Scoreboard"][1]/2+3, screenY/2-sizes["Scoreboard"][2]/2+3+28+(i*32), sizes["Scoreboard"][1]-6, sizes["Scoreboard"][2]-427, tocolor(0, 0, 0,60))
            else
                dxDrawRectangle(screenX/2-sizes["Scoreboard"][1]/2+3, screenY/2-sizes["Scoreboard"][2]/2+3+28+(i*32), sizes["Scoreboard"][1]-6, sizes["Scoreboard"][2]-427, tocolor(0, 0, 0,300))
            end
        end
        dxDrawRectangle(screenX/2-sizes["Scoreboard"][1]/2 + 3, screenY/2-sizes["Scoreboard"][2]/2+25 + 3 + 420, sizes["Scoreboard"][1]-6, sizes["Scoreboard"][2]-427, tocolor(0,0,0,125))
        centerText("Szerver verziószám: 0.001", screenX/2-sizes["Scoreboard"][1]/2+3, screenY/2-sizes["Scoreboard"][2]/2+3+445, sizes["Scoreboard"][1]-6, sizes["Scoreboard"][2]-427, tocolor(65,65,65,255), 0.8, font)

        local count = 0
        for k,v in ipairs(activePlayers) do	
 	        if (k > scrolling_score and count < maxShow) then
			    count = count + 1
			    if getElementData(v, "char > loggedin") then
			    	if getElementData(v, "char > adminduty") then
			    		local aLevel = exports.ml_core:getAdminRank(v)
			            name = "#7098CF"..getElementData(v, "char > adminnick"):gsub("_", " ").." ("..aLevel..")"
			        else
                        name = getElementData(v, "char > name"):gsub("_", " ")
			        end
			    else
			    	name = "#6a6a6aBejelentkezés alatt ("..getPlayerName(v):gsub("#%x%x%x%x%x%x","")..")"
			    end
			    local id = getElementData(v, "char > id") or 0
			    local ping = "#ffffff" ..getPlayerPing(v).." ms" or 0
			    leftText(name,screenX/2-sizes["Scoreboard"][1]/2-160, screenY/2-sizes["Scoreboard"][2]/2+3+28+(count*32), sizes["Scoreboard"][1]-6, sizes["Scoreboard"][2]-427, tocolor(200,200,200,255), 0.7, font)
			    leftText(""..id.."",screenX/2-sizes["Scoreboard"][1]/2-186, screenY/2-sizes["Scoreboard"][2]/2+3+28+(count*32), sizes["Scoreboard"][1]-6, sizes["Scoreboard"][2]-427, tocolor(112, 152, 207,255), 0.7, font)
			    rightText(ping, screenX/2-sizes["Scoreboard"][1]/2+190, screenY/2-sizes["Scoreboard"][2]/2+3+28+(count*32), sizes["Scoreboard"][1]-6, sizes["Scoreboard"][2]-427, tocolor(200,200,200,255), 0.7, font)
			end
	    end
	end
end
addEventHandler("onClientRender", root, scoreboard_draw)

bindKey("tab", "down", 
	function() 
		if getElementData(localPlayer, "char > loggedin") then
			showScoreBoard = true
			showChat(false)
			tick = getTickCount()
			scrolling_score = 0
			activePlayers = {}
			toggle = true
		end
	end
)

bindKey("tab", "up", 
	function() 
		if getElementData(localPlayer, "char > loggedin") then	
			showScoreBoard = false
			showChat(true)
			toggle = true
			activePlayers = {}
		end
	end		
)

addEventHandler("onClientKey", getRootElement(), function(button, press)
    if press and showScoreBoard then
        if button == "mouse_wheel_up" then
            if scrolling_score > 0 then
                scrolling_score = scrolling_score - 1       
            end
        elseif button == "mouse_wheel_down" then
            if scrolling_score < #activePlayers - maxShow then
                scrolling_score = scrolling_score + 1       
            end
        end
    end
end)

function centerText(text, x, y, w, h, color, fontS, font)
    dxDrawText(text, x+w/2, y+h/2, x+w/2, y+h/2, color, fontS, font, "center", "center", false, false, false, true)
end 

function leftText(text, x, y, w, h, color, fontS, font)
    dxDrawText(text, x+w/2, y+h/2, x+w/2, y+h/2, color, fontS, font, "left", "center", false, false, false, true)
end 

function rightText(text, x, y, w, h, color, fontS, font)
    dxDrawText(text, x+w/2, y+h/2, x+w/2, y+h/2, color, fontS, font, "right", "center", false, false, false, true)
end 

addEventHandler("onClientPlayerQuit", root, function() 
	if source then
		activePlayers = {}
	end
end)

function getOnlinePlayers()
	return #getElementsByType("player")
end


