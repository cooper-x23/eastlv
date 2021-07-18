function bindAnimationStopKey()
	bindKey(source, "space", "down", stopAnimation)
end
addEvent("bindAnimationStopKey", false)
addEventHandler("bindAnimationStopKey", getRootElement(), bindAnimationStopKey)

function unbindAnimationStopKey()
	unbindKey(source, "space", "down", stopAnimation)
end
addEvent("unbindAnimationStopKey", false)
addEventHandler("unbindAnimationStopKey", getRootElement(), unbindAnimationStopKey)

function stopAnimation(thePlayer)
	local forcedanimation = getElementData(thePlayer, "job:object:hand")
	if not (forcedanimation) then
		setPedAnimation(thePlayer,nil,nil)
		triggerEvent("unbindAnimationStopKey", thePlayer)
	end
end
addEvent("AnimationStop", true)
addEventHandler("AnimationStop", getRootElement(), stopAnimation)

function resetAnimation(thePlayer)
	setPedAnimation(thePlayer,nil,nil)
end

function coverAnimation(thePlayer)
	if getElementData(thePlayer, "char > loggedin") then
		setPedAnimation(thePlayer, "ped", "duck_cower", -1, false, false, false)
	end
end
addCommandHandler("cover", coverAnimation, false, false)

function copawayAnimation(thePlayer)

	if getElementData(thePlayer, "char > loggedin") then
		setPedAnimation(thePlayer, "police", "coptraf_away", 1300, true, false, false)
	end
end
addCommandHandler("copaway", copawayAnimation, false, false)

function copcomeAnimation(thePlayer)
	if getElementData(thePlayer, "char > loggedin") then
		setPedAnimation(thePlayer, "POLICE", "CopTraf_Come", -1, true, false, false)
	end
end
addCommandHandler("copcome", copcomeAnimation, false, false)

function pedWait(thePlayer) 
	if getElementData(thePlayer, "char > loggedin") then
		setPedAnimation( thePlayer, "COP_AMBIENT", "Coplook_loop", -1, true, false, false)
	end
end
addCommandHandler ( "wait", pedWait, false, false )

function pedThink(thePlayer)
	if getElementData(thePlayer, "char > loggedin") then
		setPedAnimation( thePlayer, "COP_AMBIENT", "Coplook_think", -1, true, false, false)
	end
end
addCommandHandler ( "think", pedThink, false, false )

function pedLean(thePlayer)
	if getElementData(thePlayer, "char > loggedin") then
		setPedAnimation( thePlayer, "GANGS", "leanIDLE", -1, true, false, false)
	end
end
addCommandHandler ( "lean", pedLean, false, false )

function idleAnimation(thePlayer)
	if getElementData(thePlayer, "char > loggedin") then
		setPedAnimation(thePlayer, "DEALER", "DEALER_IDLE_01", -1, true, false, false)
	end
end
addCommandHandler("idle", idleAnimation, false, false)

function pedPiss(thePlayer)
	if getElementData(thePlayer, "char > loggedin")  then
		setPedAnimation( thePlayer, "PAULNMAC", "Piss_loop", -1, true, false, false)
	end
end
addCommandHandler ( "piss", pedPiss, false, false )

function pedWank(thePlayer)
	if getElementData(thePlayer, "char > loggedin") then
		setPedAnimation( thePlayer, "PAULNMAC", "wank_loop", -1, true, false, false)
	end
end
addCommandHandler ( "wank", pedWank, false, false )

function pedHandsup(thePlayer)
	if getElementData(thePlayer, "char > loggedin") then
		setPedAnimation( thePlayer, "ped", "handsup", -1, false, false, false)
	end
end
addCommandHandler ( "handsup", pedHandsup, false, false )

function pedFU(thePlayer)
	if getElementData(thePlayer, "char > loggedin") then
		setPedAnimation( thePlayer, "RIOT", "RIOT_FUKU", 800, false, true, false)
	end
end
addCommandHandler ( "fu", pedFU, false, false )

function pedLay( thePlayer, cmd, arg )
	arg = tonumber(arg)
	
	if getElementData(thePlayer, "char > loggedin") then
		if arg == 2 then
			setPedAnimation( thePlayer, "BEACH", "sitnwait_Loop_W", -1, true, false, false)
		else
			setPedAnimation( thePlayer, "BEACH", "Lay_Bac_Loop", -1, true, false, false)
		end
	end
end
addCommandHandler ( "lay", pedLay, false, false )

function pedCry( thePlayer )
	if getElementData(thePlayer, "char > loggedin") then
		setPedAnimation( thePlayer, "GRAVEYARD", "mrnF_loop", -1, true, false, false)
	end
end
addCommandHandler ( "cry", pedCry, false, false )

function danceAnimation(thePlayer, cmd, arg)
	arg = tonumber(arg)
	
	if getElementData(thePlayer, "char > loggedin") then
		if arg == 2 then
			setPedAnimation( thePlayer, "DANCING", "DAN_Down_A", -1, true, false, false)
		elseif arg == 3 then
			setPedAnimation( thePlayer, "DANCING", "dnce_M_d", -1, true, false, false)
		else
			setPedAnimation( thePlayer, "DANCING", "DAN_Right_A", -1, true, false, false)
		end
	end
end
addCommandHandler ( "dance", danceAnimation, false, false )
