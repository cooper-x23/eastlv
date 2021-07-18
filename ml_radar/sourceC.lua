--Script by LENNON (112, 152, 207) #7098CF
local sX, sY = guiGetScreenSize()
local width, height = 0,0
local posX,posY = 5, sY-height-15
local waterColor = tocolor(129, 166, 208)
local bSize = 30

local showBigMap = false;
local minimapTarget = dxCreateRenderTarget(300,250,false);
local arrowTexture = dxCreateTexture("files/arrow.png","dxt3",true)

local font = dxCreateFont( "files/font.ttf", 10 )

local texture = dxCreateTexture( "files/radar.png", "dxt5", true, "clamp")
dxSetTextureEdge(texture, 'border', waterColor)
local imageWidth, imageHeight = dxGetMaterialSize(texture)
local blipTextures = {}
local playerBlips = {}

local mapRatio = 6000 / imageWidth

local framesPerSecond = 0
local framesDeltaTime = 0
local lastRenderTick = false
local fpsCount = 60
local stat = dxGetStatus()
local bit = stat["setting32BitColor"] and 32 or 16

local playerX,playerY,playerZ = getElementPosition(localPlayer)
local mapUnit = imageWidth / 6000
local currentZoom = 1.5
local minZoom, maxZoom = 1.5, 5

local mapOffsetX, mapOffsetY = 0,0
local mapMoved = false
local changeTick = 0

addEventHandler("onClientPreRender", root, function ()
    local currentTick = getTickCount();
    lastRenderTick = lastRenderTick or currentTick
    framesDeltaTime = framesDeltaTime + (currentTick - lastRenderTick)
    lastRenderTick = currentTick
    framesPerSecond = framesPerSecond + 1    
    if (framesDeltaTime >= 1000) then
        fpsCount = framesPerSecond
        framesDeltaTime = framesDeltaTime - 1000
        framesPerSecond = 0
    end
end)

addEventHandler("onClientResourceStart",getRootElement(),function(res)
	for i=0,64 do 
		if fileExists("blips/"..i..".png") then 
			blipTextures[i] = dxCreateTexture("blips/"..i..".png","dxt3",true)
		end
	end
end)

function getPointFromDistanceRotation(x, y, dist, angle)
    local a = math.rad(90 - angle)
    local dx = math.cos(a) * dist
    local dy = math.sin(a) * dist
    return x+dx, y+dy
end

function findRotation(x1,y1,x2,y2)
	local t = -math.deg(math.atan2(x2-x1,y2-y1))
	if t < 0 then t = t + 360 end
	return t
end

function getMapFromWorldPosition(worldX, worldY)
	local centerX, centerY = (posX + (width / 2)), (posY + (height / 2))
	local mapLeftFrame = centerX - ((playerX - worldX) / currentZoom * mapUnit)
	local mapRightFrame = centerX + ((worldX - playerX) / currentZoom * mapUnit)
	local mapTopFrame = centerY - ((worldY - playerY) / currentZoom * mapUnit)
	local mapBottomFrame = centerY + ((playerY - worldY) / currentZoom * mapUnit)

	centerX = math.max(mapLeftFrame, math.min(mapRightFrame, centerX))
	centerY = math.max(mapTopFrame, math.min(mapBottomFrame, centerY))

	return centerX, centerY
end

function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end

function getWorldFromMapPosition(mapX, mapY)
	return playerX + ((mapX * ((width * currentZoom) * 2)) - (width * currentZoom)), playerY + ((mapY * ((height * currentZoom) * 2)) - (height * currentZoom)) * -1
end

addEventHandler("onClientPreRender",root,function()		
	if not (getElementData(localPlayer, "char > loggedin")) or not (getElementData(localPlayer,"char > toghud")) then
		return
	end

	if exports.ml_interface:isWidgetShowing("radar") then
		if showBigMap then return end
		if getElementDimension(localPlayer) == 0 then
			width, height = getElementData(localPlayer,"radar.w") or 300, getElementData(localPlayer,"radar.h") or 200
			posX,posY = getElementData(localPlayer,"radar.x"),getElementData(localPlayer,"radar.y")
			local px,py, pz = getElementPosition(localPlayer)
			local _, _, camZ = getElementRotation(getCamera())	
			local mW, mH = dxGetMaterialSize(minimapTarget)
			if mW ~= width or mH ~= height then 
				destroyElement(minimapTarget)
				minimapTarget = dxCreateRenderTarget(width, height,false)
			end

			dxSetRenderTarget(minimapTarget, true)
			local mW, mH = dxGetMaterialSize(minimapTarget)
			local ex,ey = mW/2 -px/(6000/imageWidth), mH/2 + py/(6000/imageHeight)
			dxDrawRectangle(0,0,mW,mH, waterColor)
			dxDrawImage(ex - imageWidth/2, (ey - imageHeight/2), imageWidth, imageHeight, texture, camZ, (px/(6000/imageWidth)), -(py/(6000/imageHeight)), tocolor(255, 255, 255, 255))
			dxSetRenderTarget()


			dxDrawRectangle(posX, posY, width-1, height, tocolor(20,20,20,255),true)
			dxDrawImage(posX+4.2,posY+3,width-8.4,height-6,minimapTarget,0,0,0,tocolor(255,255,255),true)


	      
	        dxDrawRectangle(posX + 3, posY+height-27, width-7, 25, tocolor(20,20,20,250),true)
	        local zoneName = getZoneName(px, py, pz)
			dxDrawText("GPS: #ffffff"..zoneName, posX + 8, posY+height-27 + 5, posX + width,posY+height-27+28, tocolor(112, 152, 207, 255), 1, font, "left", "top", false, false, true, true)
		
		    for k, v in ipairs(getElementsByType("blip")) do
				local bx, by = getElementPosition(v)
				local actualDist = getDistanceBetweenPoints2D(px,py, bx, by)
				local bIcon = getBlipIcon(v)
				local bSize = getElementData(v,"blip > size") or 25
				if actualDist <= 300 or (getElementData(v, "blip > maxVisible")) then
					local dist = actualDist/(6000/((imageWidth+imageHeight)/2))
					local rot = findRotation(bx, by, px, py)-camZ
					local blipX, blipY = getPointFromDistanceRotation( (posX+width+posX)/2, (posY+posY+height)/2, math.min(dist, math.sqrt((posY+posY+height)/2-posY^2 + posX+width-(posX+width+posX)/2^2)), rot )
						
					local blipX = math.max(posX+17, math.min(posX+width-15, blipX))
					local blipY = math.max(posY+15, math.min(posY+height-40, blipY))

					local r,g,b = unpack(getElementData(v,"blip > color") or {255,255,255})
					dxDrawImage(blipX - bSize/2, blipY - bSize/2, bSize, bSize, blipTextures[bIcon] or "blips/0.png", 0, 0, 0, tocolor(r,g,b),true)
				end
			end
	        dxDrawImage(posX + width/2 - 15/2, posY + height/2 -15/2, 13, 13, arrowTexture, camZ-getPedRotation(localPlayer), 0, 0, tocolor(255,255,255, 255), true)
		end
    end
end)

function drawBigMap()
	if getElementDimension(localPlayer) ~= 0 or getElementInterior(localPlayer) ~= 0 then return end;
	posX, posY, width, height = 25, 25, sX - 50, sY - 50

	if(isCursorShowing()) and mapMoved then
		local cursorX, cursorY = getCursorPosition();
		local mapX, mapY = getWorldFromMapPosition(cursorX, cursorY);

		local absoluteX = cursorX * sX
		local absoluteY = cursorY * sY

		if getKeyState("mouse1") and exports.ml_core:isInSlot(posX, posY, width, height) then
			playerX = -(absoluteX * currentZoom - mapOffsetX)
			playerY = absoluteY * currentZoom - mapOffsetY
	
			playerX = math.max(-3000, math.min(3000, playerX))
			playerY = math.max(-3000, math.min(3000, playerY))
		end
	else 
		if (not mapMoved) then
			playerX, playerY, playerZ = getElementPosition(localPlayer)
		end
	end
	local _, _, playerRotation = getElementRotation(localPlayer);
	local mapX = (((3000 + playerX) * mapUnit) - (width / 2) * currentZoom)
	local mapY = (((3000 - playerY) * mapUnit) - (height / 2) * currentZoom)
	local mapWidth, mapHeight = width * currentZoom, height * currentZoom
	local localX, localY, localZ = getElementPosition(localPlayer)
	local koorX, koorY, koorZ = getElementPosition(localPlayer)

	dxDrawRectangle(posX - 5, posY - 5, width + 10, height + 10,tocolor(20,20,20,255))

	dxDrawImageSection(posY, posX, width, height, mapX, mapY, mapWidth, mapHeight, texture, 0, 0, 0, tocolor(255, 255, 255, 255), false)
	dxDrawRectangle(posX , posY , width , 100,tocolor(20,20,20,220))
	dxDrawText("East#ffffff MTA Las Venturas\n #7098CFFunkciók:#ffffff Mozgatás bal klikk, vissza állítás mozgatásból #7098CFSPACE#ffffff, nagyítás #7098CFegér görgő.\n #ffffff3D Blippek bekapcsolása #7098CF/3dblips\n  #ffffff➔ #7098CFKoordináták XYZ:#ffffff "..math.round(koorX)..", "..math.round(koorY)..", "..math.round(koorZ).."",posX - 5, posY + 20, width + 10, 100, tocolor(112, 152, 207,255), 1, font, "center", "center", false, false, false, true)
    dxDrawImage(posX , posY - 15, 140, 140, "files/small_logo.png", 0, 0, 0, tocolor(255,255,255,255))
	

	for _, blip in pairs(getElementsByType("blip")) do
		local blipX, blipY, blipZ = getElementPosition(blip)
		local icon = getBlipIcon(blip)
		local size = (getElementData(blip,"blip > size") or 25)
		local color = getElementData(blip,"blip > color") or {255,255,255}

		local blipDistance = getDistanceBetweenPoints2D(blipX, blipY, playerX, playerY)
		if (blipDistance <= (1000*(currentZoom*3))) then 
			local centerX, centerY = (posX + (width / 2)), (posY + (height / 2))
			local leftFrame = (centerX - width / 2) + (30/2)
			local rightFrame = (centerX + width / 2) - (30/2)
			local topFrame = (centerY - height / 2) + (30/2)
			local bottomFrame = (centerY + height / 2) - 40
			local blipX, blipY = getMapFromWorldPosition(blipX, blipY)
			centerX = math.max(leftFrame, math.min(rightFrame, blipX))
			centerY = math.max(topFrame, math.min(bottomFrame, blipY))

			dxDrawImage(centerX - (size / 2), centerY - (size / 2), size, size, blipTextures[icon], 0, 0, 0, tocolor(color[1], color[2], color[3], a))

			if exports.ml_core:isInSlot(centerX - (size / 2), centerY - (size / 2), size, size) then 
				local blipName = getElementData(blip, "blip > name") or blipNames[icon] or "Ismeretlen"
				local textWidth = dxGetTextWidth("Blip: "..blipName,1,font,true)
				local cursorX, cursorY = getCursorPosition()
				cursorX, cursorY = cursorX*sX + 10, cursorY*sY + 10
				dxDrawRectangle(cursorX,cursorY,textWidth + 10, 40,tocolor(65,65,65,255));
				dxDrawText("Blip: #ffffff"..blipName.."\n"..math.floor(blipDistance).."m",cursorX,cursorY + 20,cursorX + textWidth + 10,cursorY+20,tocolor(112, 152, 207),1,font,"center","center",false,false,false,true)
			end
		end
	end
	local blipX, blipY = getMapFromWorldPosition(localX, localY);
	if (blipX >= posX and blipX <= posX + width) then
		if (blipY >= posY and blipY <= posY + height) then
			dxDrawImage(blipX - 7, blipY - 7, 15, 15, arrowTexture, 360 - playerRotation, 0, 0, tocolor(255, 255, 255, a), false)
		end
	end
end

addEventHandler("onClientKey",root,function(button,state)
	if button == "F11" and state then 
		cancelEvent()
		if not showBigMap then 
			removeEventHandler("onClientRender",root,drawBigMap)
			addEventHandler("onClientRender",root,drawBigMap)
			showBigMap = true
			mapMoved = false
			setElementData(localPlayer,"char > toghud",false)
			showChat(false)
		else 
			removeEventHandler("onClientRender",root,drawBigMap)
			showBigMap = false
			setElementData(localPlayer,"char > toghud",true)
			showChat(true)
		end
	end
	if showBigMap then 
		if button == "space" and state then 
			mapMoved = false
		end

		if button == "mouse_wheel_up" and state then 
			currentZoom = math.max(currentZoom - 0.05, minZoom)
		end

		if button == "mouse_wheel_down" and state then 
			currentZoom = math.min(currentZoom + 0.05, maxZoom)
		end
	end
end)

addEventHandler("onClientClick",root,function(button,state,x,y)
	if showBigMap then 
		if button == "left" then 
			if state == "down" then 
				if exports.ml_core:isInSlot(posX,posY,width,height-30) then 
					mapOffsetX = x * currentZoom + playerX
					mapOffsetY = y * currentZoom - playerY
					mapMoved = true
				end
			end
		end
	end
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

blipNames = { --Tipus szám, név
	[5] = "Városháza",
	[6] = "Rendőrség",
	[23] = "Szerelőtelep",
	[4] = "Határ",
	[7] = "Benzinkút",
	[19] = "Gumi javító műhely",

 }	

addEventHandler("onClientResourceStart", getResourceRootElement(), function()

	--Pozició X Y Z, Tipus szám
	createBlip(2359.9375, 2378.2182617188, 10.8203125,5) --Városháza
	createBlip(2237.1084, 2453.4351, 10.6832,6) -- Rendőrség
	createBlip(1067.9875, 1367.251, 10.8242,23) --Szerelő telep

	--Határok
	createBlip(-564.1422, 622.6813, 16.8171, 4)
	createBlip(-477.2693, 1053.6278, 11.0312, 4)
	createBlip(-1031.2638, 2708.1194, 45.8672, 4)
	createBlip(-708.3982, 2062.8582, 60.3828, 4)

	--Benzinkutak
	createBlip(2137.6025, 2748.5471, 10.8203,7)
	createBlip(2118.4297, 935.274, 10.8203, 7)

	--hankook
	createBlip(1648.262, 2189.3579, 10.8203, 19)

end)