--script by theMark

local train = false
local ped = false
addEvent('getTrainElement > ml', true)
addEventHandler('getTrainElement > ml', root, function(trainElement, pedElement)
	train = trainElement
	ped = pedElement
	ped:setControlState('accelerate', true)
end)

addEventHandler('onClientPreRender', root, function()
	Timer(function()
		-- triggerServerEvent('spawnTrainInPlayerJoin > ml', localPlayer, localPlayer, localPlayer:getData('trainElement > ml'), train.position.x, train.position.y, train.position.z)
		if not train then return end
		if getElementSpeed(train, 1) > -0.099 then
			train.trainSpeed = -0.099
		end
	end, 500, 1)
end)

--UTILS
function getElementSpeed(theElement, unit)
    -- Check arguments for errors
    assert(isElement(theElement), "Bad argument 1 @ getElementSpeed (element expected, got " .. type(theElement) .. ")")
    local elementType = getElementType(theElement)
    assert(elementType == "player" or elementType == "ped" or elementType == "object" or elementType == "vehicle" or elementType == "projectile", "Invalid element type @ getElementSpeed (player/ped/object/vehicle/projectile expected, got " .. elementType .. ")")
    assert((unit == nil or type(unit) == "string" or type(unit) == "number") and (unit == nil or (tonumber(unit) and (tonumber(unit) == 0 or tonumber(unit) == 1 or tonumber(unit) == 2)) or unit == "m/s" or unit == "km/h" or unit == "mph"), "Bad argument 2 @ getElementSpeed (invalid speed unit)")
    -- Default to m/s if no unit specified and 'ignore' argument type if the string contains a number
    unit = unit == nil and 0 or ((not tonumber(unit)) and unit or tonumber(unit))
    -- Setup our multiplier to convert the velocity to the specified unit
    local mult = (unit == 0 or unit == "m/s") and 50 or ((unit == 1 or unit == "km/h") and 180 or 111.84681456)
    -- Return the speed by calculating the length of the velocity vector, after converting the velocity to the specified unit
    return (Vector3(getElementVelocity(theElement)) * mult).length
end

function setElementSpeed(element, unit, speed)
    local unit    = unit or 0
    local speed   = tonumber(speed) or 0
	local acSpeed = getElementSpeed(element, unit)
	if acSpeed and acSpeed~=0 then -- if true - element is valid, no need to check again
		local diff = speed/acSpeed
		if diff ~= diff then return false end -- if the number is a 'NaN' return false.
        	local x, y, z = getElementVelocity(element)
		return setElementVelocity(element, x*diff, y*diff, z*diff)
	end
	return false
end

local col = ColShape.Sphere(-1002.4253, 946.8763, 34.5781, 5)

local joskaMessage = {
	{
		message = 'Meg akarsz halni bazdmeg?!'	
	},
	{
		message = 'Az életeddel játszol baszom a szádat!'	
	},
	{
		message = 'Menj már félre vakegér!!'
	},
	{
		message  = 'A jó büdös kurvaanyádat, én pénzért dolgozok itt, ne csinálj nekem plussz munkát!!'
	},
	{
		message = 'Riherongy kurva...'
	}
}

addEventHandler('onClientColShapeHit', col, function(hitElement, dim)
	if hitElement == train and dim then
		triggerServerEvent('restartJoskaResource > ml', root)
	end
end)

addEvent("playTTS", true) -- Add the event

local function playTTS(text, lang)
    --local URL = "http://translate.google.com/translate_tts?tl=" .. lang .. "&q=" .. text
    --local URL = "https://code.responsivevoice.org/getvoice.php?tl=" .. lang .. "&t=" .. text
    local URL = "http://translate.google.com/translate_tts?tl="..lang.."&q="..text.."&client=tw-ob"
    -- Play the TTS. BASS returns the sound element even if it can not be played.
    return true, playSound(URL), URL
end
addEventHandler("playTTS", root, playTTS)



function convertTextToSpeech(text, broadcastTo, lang)
    -- Ensure first argument is valid
    assert(type(text) == "string", "Bad argument 1 @ convertTextToSpeech [ string expected, got " .. type(text) .. "]")
    assert(#text <= 100, "Bad argument 1 @ convertTextToSpeech [ too long string; 100 characters maximum ]")
    if triggerClientEvent then -- Is this function called serverside?
        -- Ensure second and third arguments are valid
        assert(broadcastTo == nil or type(broadcastTo) == "table" or isElement(broadcastTo), "Bad argument 2 @ convertTextToSpeech [ table/element expected, got " .. type(broadcastTo) .. "]")
        assert(lang == nil or type(lang) == "string", "Bad argument 3 @ convertTextToSpeech [ string expected, got " .. type(lang) .. "]")
        -- Tell the client to play the speech
        return triggerClientEvent(broadcastTo or root, "playTTS", root, text, lang or "en")
    else -- This function is executed clientside
        local lang = broadcastTo
        -- Ensure second argument is valid
        assert(lang == nil or type(lang) == "string", "Bad argument 2 @ convertTextToSpeech [ string expected, got " .. type(lang) .. "]")
        return playTTS(text, lang or "en")
    end
end

-- VONAT
ID = 538

function TXDFile ()
	TXD = engineLoadTXD('models/1.txd' ) 
	engineImportTXD(TXD, ID)
end 
addEventHandler('onClientResourceStart', resourceRoot, TXDFile)


function DFFFile ()
	DFF = engineLoadDFF('models/1.dff', 0) 
	engineReplaceModel (DFF, ID)
end 
addEventHandler('onClientResourceStart', resourceRoot, DFFFile)

-- 
-- function TXDFile2()
-- 	TXD = engineLoadTXD('models/2.txd' ) 
-- 	engineImportTXD(TXD, 569)
-- end 
-- addEventHandler('onClientResourceStart', resourceRoot, TXDFile2)


-- function DFFFile2()
-- 	DFF = engineLoadDFF('models/2.dff', 0) 
-- 	engineReplaceModel(DFF, 569)
-- end 
-- addEventHandler('onClientResourceStart', resourceRoot, DFFFile2)
-- 
