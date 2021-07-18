--Script by LENNON (112, 152, 207) #7098CF

local sX, sY = guiGetScreenSize()
local panelW, panelH = 300, 300
local showPanel = false

walkStyles = {
	{118, "Normális"},
	{55, "Izmos"},
	{121, "Bandás stílus #1"}, 
	{122, "Bandás stílus #2"},
	{123, "Öregember"},
	{124, "Kövér"},
	{129, "Női #1"},
	{131, "Női #2"},
	{132, "Női #3"},
	{133, "Női #4"},
}

local font = dxCreateFont( "files/font.ttf", 10 )

function drawWalkPanel()
	if showPanel then

		dxDrawRectangle(sX/2 - panelW/2, sY/2 - panelH/2, panelW, panelH, tocolor(65,65,65,255))
		dxDrawRectangle(sX/2 - panelW/2, sY/2 - panelH/2, panelW, 2, tocolor(112, 152, 207,255))
		dxDrawRectangle(sX/2 - panelW/2, sY/2 - panelH/2 + 300, panelW, 2, tocolor(112, 152, 207,255))
		shadowedText("Elérhető séta stílusok:", sX/2 - panelW/2 + 5, sY/2 - panelH/2 + 10 , panelW, panelH, tocolor(255,255,255,255), 1, font, "left", "top", false, false, false, true)

		for k,v in pairs(walkStyles) do
			dxDrawRectangle(sX/2 - panelW/2, sY/2 - panelH/2 + 12 + (k * 25), panelW, 20, tocolor(105,105,105,255))
			shadowedText("Név:#ffffff "..v[2], sX/2 - panelW/2 + 3, sY/2 - panelH/2 + 13 + k * 25, panelW, 20, tocolor(112, 152, 207), 1, font, "left", "top", false, false, false, true)
		end
	end
end
addEventHandler("onClientRender", getRootElement(), drawWalkPanel)

addEventHandler ("onClientClick", root, function ( button, state )
	if (showPanel) then
		if button =="left" and state =="down" then
			for k,v in pairs(walkStyles) do
				if exports.ml_core:isInSlot(sX/2 - panelW/2, sY/2 - panelH/2 + 12 + (k * 25), panelW, 20) then					
				    outputChatBox("[Walk Style] #ffffffSéta stílus beállítva. #7098CF("..v[2]..")", 112, 152, 207, true)
				    triggerServerEvent('setWalk', localPlayer, v[1])
				    setElementData(localPlayer,"char > walkingstyle", v[1])
				end
			end
		end
	end
end)

addCommandHandler("walk", function()
	if getElementData(localPlayer, "char > loggedin") then
	   showPanel = not showPanel
	end
end)

addCommandHandler("seta", function()
	if getElementData(localPlayer, "char > loggedin") then
	   showPanel = not showPanel
	end
end)



function onKey (button,press)
	if isCursorShowing () == false and isControlEnabled (button) == true then
		if press == "down" then
			local sprintKey = false
			for i,v in pairs(getBoundKeys ("sprint")) do
				if getKeyState (i) then
					sprintKey = true
					break
				end
			end
			if sprintKey == false then
				setControlState ("walk",true)
			end
		else
			local f = false
			local keys = {"forwards", "backwards", "left", "right"}
			for k,v in ipairs(keys) do
				local bound = getBoundKeys (v)
				for i,key in pairs(bound) do
					if getKeyState (i) then
						f = true
						break
					end
				end
			end
			if f == false then
				setControlState ("walk",false)
			end
		end
	end
end

addEventHandler ("onClientResourceStart",getResourceRootElement(),
function ()
	local keys = {"forwards", "backwards", "left", "right"}
	for k,v in ipairs(keys) do
		bindKey (v,"both",onKey)
	end
	
	bindKey ("walk","both",
	function ()
		setControlState ("walk", true)
	end)
	
	bindKey ("sprint","both",
	function (button,press)
		setControlState ("sprint", false)
		if isControlEnabled ("sprint") then
			setControlState ("walk", false)
		end

		if isControlEnabled ("sprint") then
			setControlState ("sprint", true)
		end

	end)
	
	bindKey ("sprint","up", function()
		sprintKey = false
		if not sprintKey then
			setControlState ("walk", true)
			setControlState ("sprint", false)
		end
	end)
end)

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