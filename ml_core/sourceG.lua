local ownerSerial = "42069XD"

function getOwnerSerial()
	return ownerSerial
end

function getServerColor(colorType)
	if (tostring(colorType) == "rgb") then
		return 112, 152, 207
	elseif (tostring(colorType) == "hexamp") then
		return "7098CF"
	end
end

function findPlayerByPartialNick(playerSource, targetNick, nType)
	if targetNick == "*" or utfSub(targetNick, 1, 1) == "*" then
        return playerSource, getPlayerName(playerSource)
    end
	local tempTable = {}
	if (not playerSource or type(playerSource) == "string" or not targetNick) then
		return
	end
	local byName = false
	local byID = false
	if (tonumber(targetNick)) then
		byID = true
	else
		byName = true
	end
	if byName then
		targetNick = string.gsub(targetNick, " ", "_")
		targetNick = string.lower(targetNick)
		for k, v in ipairs(getElementsByType("player")) do
			local playerName = string.lower(tostring(getPlayerName(v):gsub("_", " ")))
			
			if string.find(playerName, tostring(targetNick)) then
				local playerID = tonumber(getElementData(v, "char > id")) or 0
				local stringStart, stringEnd = string.find(playerName, tostring(targetNick))
				if tonumber(stringStart) > 0 and tonumber(stringEnd) > 0 then
					tempTable[#tempTable + 1] = {v, getPlayerName(v):gsub("_", " ")}
				end
			end
		end
	elseif byID then
		for k, v in ipairs(getElementsByType("player")) do
			local playerID = getElementData(v, "char > id") -- targetID
			local playerName = getPlayerName(v):gsub("_", " ")
			if (tonumber(playerID) == tonumber(targetNick)) then
				tempTable[#tempTable + 1] = {v, playerName}
			end			
		end
	end
	if (#tempTable == 0) then
		if (nType == 1) then
			outputChatBox("Nincs találat", playerSource)
			return false
		elseif (nType == 2) then
			return false, "Nincs találat"
		end
	elseif (#tempTable == 1) then
		return tempTable[#tempTable][1], tempTable[#tempTable][2]
	elseif (#tempTable > 1) then
		if (nType == 1) then
			outputChatBox("[INFO] " .. tempTable[#tempTable][1] .. " : " .. tempTable[#tempTable][2], playerSource)
		elseif (nType == 2) then
			return false, "Több találat (" .. #tempTable .. ")"
		end
	end
	-- return false
end

local vehNames = {
	[411] = "Ferrari 408",
	[560] = "Mitsubishi Lancer Evolution X"
}

function getVehicleName(vehicleID)
	if (tonumber(vehicleID)) then
		if (vehNames[tonumber(vehicleID)]) then
			return vehNames[tonumber(vehicleID)]
		else
			return getVehicleNameFromModel(vehicleID)
		end
	end
end

function getAdminRank(playerSource)
    if getElementData(playerSource, "char > admin") == 1 then
        return "IDG Adminsegéd"
    elseif getElementData(playerSource, "char > admin") == 2 then
        return "Adminsegéd"
    elseif getElementData(playerSource, "char > admin") == 3 then
        return "Admin 1"
    elseif getElementData(playerSource, "char > admin") == 4 then
        return "Admin 2"
    elseif getElementData(playerSource, "char > admin") == 5 then
        return "Admin 3"
    elseif getElementData(playerSource, "char > admin") == 6 then
        return "Admin 4"
    elseif getElementData(playerSource, "char > admin") == 7 then
        return "Főadmin"
    elseif getElementData(playerSource, "char > admin") == 8 then
        return "SzuperAdmin"
    elseif getElementData(playerSource, "char > admin") == 9 then
        return "Server Manager"
    elseif getElementData(playerSource, "char > admin") == 10 then
        return "Tulajdonos"
    elseif getElementData(playerSource, "char > admin") == 11 then
        return "Fejlesztő"
    end
end
