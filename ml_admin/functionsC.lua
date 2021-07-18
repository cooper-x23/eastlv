


-- /fly
local flyingState = false
local keys = {}
keys.up = "up"
keys.down = "up"
keys.f = "up"
keys.b = "up"
keys.l = "up"
keys.r = "up"
keys.a = "up"
keys.s = "up"

function togFly()
	flyingState = not flyingState
	
	if flyingState then
		addEventHandler("onClientRender",getRootElement(),flyingRender)
		bindKey("lshift","both",keyH)
		bindKey("rshift","both",keyH)
		bindKey("lctrl","both",keyH)
		bindKey("rctrl","both",keyH)
		
		bindKey("forwards","both",keyH)
		bindKey("backwards","both",keyH)
		bindKey("left","both",keyH)
		bindKey("right","both",keyH)
		
		bindKey("lalt","both",keyH)
		bindKey("space","both",keyH)
		bindKey("ralt","both",keyH)
		setElementCollisionsEnabled(localPlayer,false)
	else
		removeEventHandler("onClientRender",getRootElement(),flyingRender)
		unbindKey("lshift","both",keyH)
		unbindKey("rshift","both",keyH)
		unbindKey("lctrl","both",keyH)
		unbindKey("rctrl","both",keyH)
		
		unbindKey("forwards","both",keyH)
		unbindKey("backwards","both",keyH)
		unbindKey("left","both",keyH)
		unbindKey("right","both",keyH)
		
		unbindKey("space","both",keyH)
		
		keys.up = "up"
		keys.down = "up"
		keys.f = "up"
		keys.b = "up"
		keys.l = "up"
		keys.r = "up"
		keys.a = "up"
		keys.s = "up"
		setElementCollisionsEnabled(localPlayer,true)
	end
end
addEvent("onClientFlyToggle",true)
addEventHandler("onClientFlyToggle",getRootElement(),togFly)

function flyingRender()
	local x,y,z = getElementPosition(localPlayer)
	local speed = 10
	if keys.a=="down" then
		speed = 3
	elseif keys.s=="down" then
		speed = 50
	end
	
	if keys.f=="down" then
		local a = rotFromCam(0)
		setElementRotation(localPlayer,0,0,a)
		local ox,oy = dirMove(a)
		x = x + ox * 0.1 * speed
		y = y + oy * 0.1 * speed
	elseif keys.b=="down" then
		local a = rotFromCam(180)
		setElementRotation(localPlayer,0,0,a)
		local ox,oy = dirMove(a)
		x = x + ox * 0.1 * speed
		y = y + oy * 0.1 * speed
	end
	
	if keys.l=="down" then
		local a = rotFromCam(-90)
		setElementRotation(localPlayer,0,0,a)
		local ox,oy = dirMove(a)
		x = x + ox * 0.1 * speed
		y = y + oy * 0.1 * speed
	elseif keys.r=="down" then
		local a = rotFromCam(90)
		setElementRotation(localPlayer,0,0,a)
		local ox,oy = dirMove(a)
		x = x + ox * 0.1 * speed
		y = y + oy * 0.1 * speed
	end
	
	if keys.up=="down" then
		z = z + 0.1*speed
	elseif keys.down=="down" then
		z = z - 0.1*speed
	end
	
	setElementPosition(localPlayer,x,y,z)
end

function keyH(key,state)
	if key=="lshift" or key=="rshift" then
		keys.s = state
	end	
	if key=="lctrl" or key=="rctrl" then
		keys.down = state
	end	
	if key=="forwards" then
		keys.f = state
	end	
	if key=="backwards" then
		keys.b = state
	end	
	if key=="left" then
		keys.l = state
	end	
	if key=="right" then
		keys.r = state
	end	
	if key=="lalt" or key=="ralt" then
		keys.a = state
	end	
	if key=="space" then
		keys.up = state
	end	
end

function rotFromCam(rzOffset)
	local cx,cy,_,fx,fy = getCameraMatrix(localPlayer)
	local deltaY,deltaX = fy-cy,fx-cx
	local rotZ = math.deg(math.atan((deltaY)/(deltaX)))
	if deltaY >= 0 and deltaX <= 0 then -- 4 cwiartka
		rotZ = rotZ+180
	elseif deltaY <= 0 and deltaX <= 0 then -- 3 cwiartka
		rotZ = rotZ+180
	end
	return -rotZ+90 + rzOffset
end

function dirMove(a)
	local x = math.sin(math.rad(a))
	local y = math.cos(math.rad(a))
	return x,y
end


function math.round(number,decimals,method)
    decimals = decimals or 0
    local factor = 10 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end

local anims,builtins = {},{"Linear","InQuad","OutQuad","InOutQuad","OutInQuad","InElastic","OutElastic","InOutElastic","OutInElastic","InBack","OutBack","InOutBack","OutInBack","InBounce","OutBounce","InOutBounce","OutInBounce","SineCurve","CosineCurve"}

function table.find(t,v)
	for k,a in ipairs(t) do
		if a == v then
			return k
		end
	end
	return false
end

function animate(f,t,easing,duration,onChange,onEnd)
	assert(type(f) == "number","Bad argument @ 'animate' [expected number at argument 1,got "..type(f).."]")
	assert(type(t) == "number","Bad argument @ 'animate' [expected number at argument 2,got "..type(t).."]")
	assert(type(easing) == "string" or (type(easing) == "number" and (easing >= 1 or easing <= #builtins)),"Bad argument @ 'animate' [Invalid easing at argument 3]")
	assert(type(duration) == "number","Bad argument @ 'animate' [expected function at argument 4,got "..type(duration).."]")
	assert(type(onChange) == "function","Bad argument @ 'animate' [expected function at argument 5,got "..type(onChange).."]")
	table.insert(anims,{from = f,to = t,easing = table.find(builtins,easing) and easing or builtins[easing],duration = duration,start = getTickCount( ),onChange = onChange,onEnd = onEnd})
	return #anims
end

function destroyAnimation(a)
	if anims[a] then
		table.remove(anims,a)
	end
end

addEventHandler("onClientRender",root,function( )
	local now = getTickCount( )
	for k,v in ipairs(anims) do
		v.onChange(interpolateBetween(v.from,0,0,v.to,0,0,(now - v.start) / v.duration,v.easing))
		if now >= v.start+v.duration then
			if type(v.onEnd) == "function" then
				v.onEnd( )
			end
			table.remove(anims,k)
		end
	end
end)


function isCursorInPos(posX,posY,width,height)
	if isCursorShowing() then
		local mouseX,mouseY = getCursorPosition();
		local clientW,clientH = guiGetScreenSize();
		local mouseX,mouseY = mouseX * clientW,mouseY * clientH;
		if (mouseX > posX and mouseX < (posX+width) and mouseY > posY and mouseY < (posY+height)) then
			return true;
		end
	end
	return false;
end

function dxDrawGifImage ( x,y,w,h,path,iStart,iType,effectSpeed )
	local gifElement = createElement ( "dx-gif" )
	if ( gifElement ) then
		setElementData (
			gifElement,
			"gifData",
			{
				x = x,
				y = y,
				w = w,
				h = h,
				imgPath = path,
				startID = iStart,
				imgID = iStart,
				imgType = iType,
				speed = effectSpeed,
				tick = getTickCount ( )
			},
			false
		)
		return gifElement
	else
		return false
	end
end

addEventHandler ( "onClientRender",root,
	function ( )
		local currentTick = getTickCount ( )
		for index,gif in ipairs ( getElementsByType ( "dx-gif" ) ) do
			local gifData = getElementData ( gif,"gifData" )
			if ( gifData ) then
				if ( currentTick - gifData.tick >= gifData.speed ) then
					gifData.tick = currentTick
					gifData.imgID = ( gifData.imgID + 1 )
					if ( fileExists ( gifData.imgPath .."".. gifData.imgID ..".".. gifData.imgType ) ) then
						gifData.imgID = gifData.imgID
						setElementData ( gif,"gifData",gifData,false )
					else
						gifData.imgID = gifData.startID
						setElementData ( gif,"gifData",gifData,false )
					end
				end
				dxDrawImage ( gifData.x,gifData.y,gifData.w,gifData.h,gifData.imgPath .."".. gifData.imgID ..".".. gifData.imgType )
			end
		end
	end
)


local root = getRootElement()
local localPlayer = getLocalPlayer()
local PI = math.pi

local isEnabled = false
local wasInVehicle = isPedInVehicle(localPlayer)

local mouseSensitivity = 0.1
local rotX,rotY = 0,0
local mouseFrameDelay = 0
local idleTime = 2500
local fadeBack = false
local fadeBackFrames = 50
local executeCounter = 0
local recentlyMoved = false
local Xdiff,Ydiff

function toggleCockpitView ()
	if (not isEnabled) then
		if (getCameraTarget() == localPlayer or getCameraTarget() == getPedOccupiedVehicle(localPlayer)) then
			isEnabled = true
			addEventHandler ("onClientPreRender",root,updateCamera)
			addEventHandler ("onClientCursorMove",root,freecamMouse)
		end
	else --reset view
		isEnabled = false
		setCameraTarget (localPlayer,localPlayer)
		removeEventHandler ("onClientPreRender",root,updateCamera)
		removeEventHandler ("onClientCursorMove",root,freecamMouse)
	end
end

addCommandHandler("fp",toggleCockpitView)
addCommandHandler("cockpit",toggleCockpitView)

function updateCamera ()
	if (isEnabled) then
	
		local nowTick = getTickCount()
		
		-- check if the last mouse movement was more than idleTime ms ago
		if wasInVehicle and recentlyMoved and not fadeBack and startTick and nowTick - startTick > idleTime then
			recentlyMoved = false
			fadeBack = true
			if rotX > 0 then
				Xdiff = rotX / fadeBackFrames
			elseif rotX < 0 then
				Xdiff = rotX / -fadeBackFrames
			end
			if rotY > 0 then
				Ydiff = rotY / fadeBackFrames
			elseif rotY < 0 then
				Ydiff = rotY / -fadeBackFrames
			end
		end
		
		if fadeBack then
		
			executeCounter = executeCounter + 1
		
			if rotX > 0 then
				rotX = rotX - Xdiff
			elseif rotX < 0 then
				rotX = rotX + Xdiff
			end
		
			--if rotY > 0 then
			--	rotY = rotY - Ydiff
			--elseif rotY < 0 then
			--	rotY = rotY + Ydiff
			--end
		
			if executeCounter >= fadeBackFrames then
				fadeBack = false
				executeCounter = 0
			end
		
		end
		
		local camPosXr,camPosYr,camPosZr = getPedBonePosition (localPlayer,6)
		local camPosXl,camPosYl,camPosZl = getPedBonePosition (localPlayer,7)
		local camPosX,camPosY,camPosZ = (camPosXr + camPosXl) / 2,(camPosYr + camPosYl) / 2,(camPosZr + camPosZl) / 2 - 0.2
		
		camPosZ = camPosZ + 0.2
		local roll = 0
		
		inVehicle = isPedInVehicle(localPlayer)
		
		-- note the vehicle rotation
		if inVehicle then
			local rx,ry,rz = getElementRotation(getPedOccupiedVehicle(localPlayer))
			
			--roll = ry
			--if rx > 90 and rx < 270 then
			--	roll = ry - 180
			--end
			
			--if not wasInVehicle then
			--	rotX = rotX + math.rad(rz) --prevent camera from rotation when entering a vehicle
			--	if rotY > -PI/15 then --force camera down if needed
			--		rotY = -PI/15 
			--	end
			--end
			
			cameraAngleX = rotX - math.rad(rz)
			cameraAngleY = rotY + math.rad(rx)
			
			if getControlState("vehicle_look_behind") or ( getControlState("vehicle_look_right") and getControlState("vehicle_look_left") ) then
				cameraAngleX = cameraAngleX + math.rad(180)
				--cameraAngleY = cameraAngleY + math.rad(180)
			elseif getControlState("vehicle_look_left") then
				cameraAngleX = cameraAngleX - math.rad(90)
				--roll = rx doesn't work out well
			elseif getControlState("vehicle_look_right") then
				cameraAngleX = cameraAngleX + math.rad(90)  
				--roll = -rx
			end
		else
			local rx,ry,rz = getElementRotation(localPlayer)
			
			if wasInVehicle then
				rotX = rotX - math.rad(rz) --prevent camera from rotating when exiting a vehicle
			end
			cameraAngleX = rotX
			cameraAngleY = rotY
		end
		
		wasInVehicle = inVehicle
		
		--Taken from the freecam resource made by eAi
		
		-- work out an angle in radians based on the number of pixels the cursor has moved (ever)
		
		local freeModeAngleZ = math.sin(cameraAngleY)
		local freeModeAngleY = math.cos(cameraAngleY) * math.cos(cameraAngleX)
		local freeModeAngleX = math.cos(cameraAngleY) * math.sin(cameraAngleX)

		-- calculate a target based on the current position and an offset based on the angle
		local camTargetX = camPosX + freeModeAngleX * 100
		local camTargetY = camPosY + freeModeAngleY * 100
		local camTargetZ = camPosZ + freeModeAngleZ * 100

		-- Work out the distance between the target and the camera (should be 100 units)
		local camAngleX = camPosX - camTargetX
		local camAngleY = camPosY - camTargetY
		local camAngleZ = 0 -- we ignore this otherwise our vertical angle affects how fast you can strafe

		-- Calulcate the length of the vector
		local angleLength = math.sqrt(camAngleX*camAngleX+camAngleY*camAngleY+camAngleZ*camAngleZ)

		-- Normalize the vector,ignoring the Z axis,as the camera is stuck to the XY plane (it can't roll)
		local camNormalizedAngleX = camAngleX / angleLength
		local camNormalizedAngleY = camAngleY / angleLength
		local camNormalizedAngleZ = 0

		-- We use this as our rotation vector
		local normalAngleX = 0
		local normalAngleY = 0
		local normalAngleZ = 1

		-- Perform a cross product with the rotation vector and the normalzied angle
		local normalX = (camNormalizedAngleY * normalAngleZ - camNormalizedAngleZ * normalAngleY)
		local normalY = (camNormalizedAngleZ * normalAngleX - camNormalizedAngleX * normalAngleZ)
		local normalZ = (camNormalizedAngleX * normalAngleY - camNormalizedAngleY * normalAngleX)

		-- Update the target based on the new camera position (again,otherwise the camera kind of sways as the target is out by a frame)
		camTargetX = camPosX + freeModeAngleX * 100
		camTargetY = camPosY + freeModeAngleY * 100
		camTargetZ = camPosZ + freeModeAngleZ * 100

		-- Set the new camera position and target
		setCameraMatrix (camPosX,camPosY,camPosZ,camTargetX,camTargetY,camTargetZ,roll)
		--[[
		dxDrawText("fadeBack = "..tostring(fadeBack),400,200)
		dxDrawText("recentlyMoved = "..tostring(recentlyMoved),400,220)
		if executeCounter then dxDrawText("executeCounter = "..tostring(executeCounter),400,240) end
		dxDrawText("rotX = "..tostring(rotX),400,260)
		dxDrawText("rotY = "..tostring(rotY),400,280)
		if Xdiff then dxDrawText("Xdiff = "..tostring(Xdiff),400,300) end
		if Ydiff then dxDrawText("Ydiff = "..tostring(Ydiff),400,320) end
		if startTick then dxDrawText("startTick = "..tostring(startTick),400,340) end
		dxDrawText("nowTick = "..tostring(nowTick),400,360)
		]]
	end
end

function freecamMouse (cX,cY,aX,aY)
	
	--ignore mouse movement if the cursor or MTA window is on
	--and do not resume it until at least 5 frames after it is toggled off
	--(prevents cursor mousemove data from reaching this handler)
	if isCursorShowing() or isMTAWindowActive() then
		mouseFrameDelay = 5
		return
	elseif mouseFrameDelay > 0 then
		mouseFrameDelay = mouseFrameDelay - 1
		return
	end
	
	startTick = getTickCount()
	recentlyMoved = true
	
	-- check if the mouse is moved while fading back,if so abort the fading
	if fadeBack then
		fadeBack = false
		executeCounter = 0
	end
	
	-- how far have we moved the mouse from the screen center?
	local width,height = guiGetScreenSize()
	aX = aX - width / 2 
	aY = aY - height / 2
	
	rotX = rotX + aX * mouseSensitivity * 0.01745
	rotY = rotY - aY * mouseSensitivity * 0.01745

	local pRotX,pRotY,pRotZ = getElementRotation (localPlayer)
	pRotZ = math.rad(pRotZ)
	
	if rotX > PI then
		rotX = rotX - 2 * PI
	elseif rotX < -PI then
		rotX = rotX + 2 * PI
	end
	
	if rotY > PI then
		rotY = rotY - 2 * PI
	elseif rotY < -PI then
		rotY = rotY + 2 * PI
	end
	-- limit the camera to stop it going too far up or down
	--if isPedInVehicle(localPlayer) then
		--[[if rotY < -PI / 2 then
			rotY = -PI / 2
		elseif rotY > -PI/2 then
			rotY = -PI/2
		end]]
	--else
		if rotY < -PI / 4 then
			rotY = -PI / 4
		elseif rotY > PI / 2.1 then
			rotY = PI / 2.1
		end
	--end
end

function shadowedText(text,x,y,w,h,color,fontsize,font,aligX,alignY)
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x,y+1,w,h+1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, false, true) 
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x,y-1,w,h-1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, false, true)
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x-1,y,w-1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, false, true) 
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x+1,y,w+1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, false, true) 
    dxDrawText(text,x,y,w,h,color,fontsize,font,aligX,alignY, false, false, false, true)
end

function centeredText(text,x,y,w,h,color,size,font,shadow,leftcentered,rightcentered)
    if leftcentered then
        if shadow then
            shadowedText(text,x+20,y+h/2,x+20,y+h/2,color,size,font,"left","center",false,false,false,true)
        else
            dxDrawText(text,x+20,y+h/2,x+20,y+h/2,color,size,font,"left","center",false,false,false,true)
        end
	elseif rightcentered then
		if shadow then
            shadowedText(text,x+w,y+h/2,x+w-20,y+h/2,color,size,font,"right","center",false,false,false,true)
        else
            dxDrawText(text,x+20-20,y+h/2,x+20,y+h/2,color,size,font,"right","center",false,false,false,true)
        end
	else
        if shadow then 
            shadowedText(text,x+w/2,y+h/2,x+w/2,y+h/2,color,size,font,"center","center",false,false,false,true)
        else
            dxDrawText(text,x+w/2,y+h/2,x+w/2,y+h/2,color,size,font,"center","center",false,false,false,true)
        end
    end
end