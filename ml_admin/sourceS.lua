--Script by LENNON (112, 152, 207) #7098CF
local con = exports.ml_mysql:getConnection()
local prefix = "[ADMIN COMMAND]:"
local showAdminLog = true
local serverColor = exports.ml_core:getServerColor("hexamp")
local devSerials = {};
devSerials["2E5D2D668D7F93AFDB570931315CB5F4"] = true; -- LENNON
devSerials["127890FDB7E6AA423964F3AA7836CD94"] = true; -- theMark

addCommandHandler("setalevel", function(playerSource,commandName,who,rank)
	local serial = getPlayerSerial(playerSource)
	if getElementData(playerSource, "char > admin") >= 8 and getElementData(playerSource, "char > loggedin") or devSerials[serial] then
		if not (who) then
			outputChatBox(""..prefix.." #ffffff/"..commandName.." [ID] [szint]", playerSource,112, 152, 207,true)
		else
			local targetPlayer, targetPlayerName =  exports.ml_core:findPlayerByPartialNick(playerSource, who)
			if not targetPlayer then return outputChatBox("[ADMIN - ERROR]: #ffffffA kiválasztott játékos nem létezik.", playerSource, 112, 152, 207, true) end
			local name = getElementData(targetPlayer, "char > name"):gsub("_", " ")
			local accountID = getElementData(targetPlayer, "char > accountid")
			local adminnick = getElementData(playerSource, "char > adminnick") or "Ismeretlen"
			if (targetPlayer) then
				rank = tonumber(rank)
				local adminlevel = getElementData(targetPlayer, "char > admin")
				dbExec(con,"UPDATE `account` SET `adminlevel`=" .. tonumber(rank) .. " WHERE `id`=?",accountID)
				setElementData(targetPlayer, "char > admin", tonumber(rank))
				outputChatBox("[ADMIN] #7098CF" .. adminnick .. "#ffffff átállította #7098CF".. name .."#ffffff adminszintjét ==> #B05050" ..getElementData(targetPlayer, "char > admin").. "", getRootElement(), 112, 152, 207, true)
			end
		end
	end
end)

addCommandHandler("setanick",function (playerSource, commandName, who, nick)
    if getElementData(playerSource, "char > admin") >= 8 and getElementData(playerSource, "char > loggedin") then
        if not (who) then
            outputChatBox(""..prefix.." #ffffff/"..commandName.." [ID] [Név]", playerSource,112, 152, 207,true)
        else
            local targetPlayer, targetPlayerName = exports.ml_core:findPlayerByPartialNick(playerSource, who)
            if not targetPlayer then return outputChatBox("[ADMIN - ERROR]: #ffffffA kiválasztott játékos nem létezik.", playerSource, 112, 152, 207, true) end
            local name = getElementData(targetPlayer, "char > name"):gsub("_", " ")
            local ID = getElementData(targetPlayer, "char > accountid")
            if (targetPlayer) then
                dbExec(con,"UPDATE account SET adminnick = ? WHERE id = ?",nick,ID)
            	setElementData(targetPlayer, "char > adminnick", nick)
            	local aName = getElementData(playerSource, "char > adminnick") or "Ismeretlen"

                outputChatBox("[ADMIN] #ffffff" .. name .. "#ffffff új adminisztrátori neve: #7098CF" ..getElementData(targetPlayer, "char > adminnick").. "", getRootElement(), 112, 152, 207, true)
            end
        end
    end
end)

addCommandHandler("changename",function(playerSource, commandName, who, ...)
    if getElementData(playerSource, "char > admin") >= 8 and getElementData(playerSource, "char > loggedin") then
        if not (...) or not (who) then
            outputChatBox(""..prefix.." #ffffff/"..commandName.." [ID] [Karakter_Név]", playerSource,112, 152, 207,true)
        else
            local newName = table.concat({...}, "_")
            local targetPlayer, targetPlayerName =  exports.ml_core:findPlayerByPartialNick(playerSource, who)
            local aName = getElementData(playerSource, "char > adminnick") or "Ismeretlen Admin"
            local ID = getElementData(targetPlayer, "char > accountid")
            if not targetPlayer then return outputChatBox("[ADMIN - ERROR]: #ffffffA kiválasztott játékos nem létezik.", playerSource, 112, 152, 207, true) end
            if targetPlayer then
                if newName == targetPlayerName then
                    outputChatBox("[ADMIN]: A játékos már ezt a nevet viseli.", playerSource, 160, 160, 160,true)
                else
                	dbExec(con,"UPDATE `account` SET `name`=? WHERE `id`=?",newName,ID)
                    outputChatBox("[ADMIN]: #ffffffNévcsere sikeresen végrehajtva. #ffffff(Játékos: #7098CF"..getElementData(targetPlayer,"char > name").." ==> "..newName.."#ffffff)", playerSource, 112, 152, 207,true)
                    setElementData(targetPlayer,"char > name", newName)
                    outputChatBox("[ADMIN]: #7098CF"..getElementData(playerSource,"char > adminnick").." #ffffffátírta a karakter neved --> #7098CF"..newName.."", targetPlayer, 112, 152, 207, true)
                    sendAdminLog(aName.. " használta a #7098CF/"..commandName.."#ffffff parancsot a következő játékoson: #7098CF"..getElementData(targetPlayer,"char > name"):gsub("_", " ").."") 
                end
            end
        end
    end
end)

addCommandHandler("givepp", function(playerSource, commandName, who, amount)
    if getElementData(playerSource, "char > admin") >= 8 and getElementData(playerSource, "char > loggedin") then
        if not (who) or not (amount) then
            outputChatBox(""..prefix.." #ffffff/"..commandName.." [ID] [Összeg]", playerSource,112, 152, 207,true)
        else
            local targetPlayer, targetPlayerName = exports.ml_core:findPlayerByPartialNick(playerSource, who)
            if targetPlayer then
                local finalAmount = tonumber(amount)
                local premium = getElementData(targetPlayer, "char > premiumpoints")
                local aName = getElementData(playerSource, "char > adminnick") or "Ismeretlen"
                local name = getElementData(targetPlayer, "char > name"):gsub("_", " ")
                if tonumber(finalAmount) and finalAmount > 0 and finalAmount < 500000 then
                    outputChatBox("[ADMIN] #ffffffSikeresen adtál prémium pontot. ("..name..") ("..formatMoney(finalAmount)..")", playerSource, 112, 152, 207, true)
                    setElementData(targetPlayer,  "char > premiumpoints", premium + finalAmount)
                    sendAdminLog(aName.. " használta a #7098CF/"..commandName.."#ffffff parancsot a következő játékoson: #7098CF"..getElementData(targetPlayer,"char > name"):gsub("_", " ").."#ffffff Érték: #7098CF"..formatMoney(finalAmount).." PP") 
                else
                    outputChatBox("[ADMIN - ERROR]: #ffffffHibás érték.", playerSource, 112, 152, 207, true)
                end
            else
                outputChatBox("[ADMIN - ERROR]: #ffffffNincs ilyen játékos.", playerSource, 112, 152, 207, true)
            end
        end
    end
end)


addCommandHandler("setpp", function(playerSource, commandName, who, amount)
    if getElementData(playerSource, "char > admin") >= 8 and getElementData(playerSource, "char > loggedin") then
        if not (who) or not (amount) then
            outputChatBox(""..prefix.." #ffffff/"..commandName.." [ID] [Összeg]", playerSource,112, 152, 207,true)
        else
            local targetPlayer, targetPlayerName = exports.ml_core:findPlayerByPartialNick(playerSource, who)
            if targetPlayer then
                local finalAmount = tonumber(amount)
                local premium = getElementData(targetPlayer, "char > premiumpoints")
                local aName = getElementData(playerSource, "char > adminnick") or "Ismeretlen"
                local name = getElementData(targetPlayer, "char > name"):gsub("_", " ")
                if tonumber(finalAmount) and finalAmount >= 0 and finalAmount < 500000 then
                    outputChatBox("[ADMIN] #ffffffSikeresen beállítottad a prémium pontok számát. ("..name..") ("..formatMoney(finalAmount)..")", playerSource, 112, 152, 207, true)
                    setElementData(targetPlayer,  "char > premiumpoints", finalAmount)
                    sendAdminLog(aName.. " használta a #7098CF/"..commandName.."#ffffff parancsot a következő játékoson: #7098CF"..getElementData(targetPlayer,"char > name"):gsub("_", " ").."#ffffff Érték: #7098CF"..formatMoney(finalAmount).." PP") 
                else
                    outputChatBox("[ADMIN - ERROR]: #ffffffHibás érték.", playerSource, 112, 152, 207, true)
                end
            else
                outputChatBox("[ADMIN - ERROR]: #ffffffNincs ilyen játékos.", playerSource, 112, 152, 207, true)
            end
        end
    end
end)


addCommandHandler("givemoney", function(playerSource, commandName, who, amount)
    if getElementData(playerSource, "char > admin") >= 8 and getElementData(playerSource, "char > loggedin") then
        if not (who) or not (amount) then
            outputChatBox(""..prefix.." #ffffff/"..commandName.." [ID] [Összeg]", playerSource,112, 152, 207,true)
        else
            local targetPlayer, targetPlayerName = exports.ml_core:findPlayerByPartialNick(playerSource, who)
            if targetPlayer then
                local finalAmount = tonumber(amount)
                local money = getElementData(targetPlayer, "char > money")
                local aName = getElementData(playerSource, "char > adminnick") or "Ismeretlen"
                local name = getElementData(targetPlayer, "char > name"):gsub("_", " ")
                if tonumber(finalAmount) and finalAmount > 0 and finalAmount < 10000000 then
                    outputChatBox("[ADMIN] #ffffffSikeresen adtál pénz a játékosnak. ("..name..") ($"..formatMoney(finalAmount)..")", playerSource, 112, 152, 207, true)
                    setElementData(targetPlayer,  "char > money", money + finalAmount)
                    sendAdminLog(aName.. " használta a #7098CF/"..commandName.."#ffffff parancsot a következő játékoson: #7098CF"..getElementData(targetPlayer,"char > name"):gsub("_", " ").."#ffffff Érték: $#7098CF "..formatMoney(finalAmount).."") 
                else
                    outputChatBox("[ADMIN - ERROR]: #ffffffHibás érték.", playerSource, 112, 152, 207, true)
                end
            else
                outputChatBox("[ADMIN - ERROR]: #ffffffNincs ilyen játékos.", playerSource, 112, 152, 207, true)
            end
        end
    end
end)

addCommandHandler("setmoney", function(playerSource, commandName, who, amount)
    if getElementData(playerSource, "char > admin") >= 8 and getElementData(playerSource, "char > loggedin") then
        if not (who) or not (amount) then
            outputChatBox(""..prefix.." #ffffff/"..commandName.." [ID] [Összeg]", playerSource,112, 152, 207,true)
        else
            local targetPlayer, targetPlayerName = exports.ml_core:findPlayerByPartialNick(playerSource, who)
            if targetPlayer then
                local finalAmount = tonumber(amount)
                local money = getElementData(targetPlayer, "char > money")
                local aName = getElementData(playerSource, "char > adminnick") or "Ismeretlen"
                local name = getElementData(targetPlayer, "char > name"):gsub("_", " ")
                if tonumber(finalAmount) and finalAmount >= 0 and finalAmount < 10000000 then
                    outputChatBox("[ADMIN] #ffffffSikeresen beállítottad a játékos pénzét. ("..name..") ($"..formatMoney(finalAmount)..")", playerSource, 112, 152, 207, true)
                    setElementData(targetPlayer,  "char > money", finalAmount)
                    sendAdminLog(aName.. " használta a #7098CF/"..commandName.."#ffffff parancsot a következő játékoson: #7098CF"..getElementData(targetPlayer,"char > name"):gsub("_", " ").."#ffffff Érték: $#7098CF "..formatMoney(finalAmount).."") 
                else
                    outputChatBox("[ADMIN - ERROR]: #ffffffHibás érték.", playerSource, 112, 152, 207, true)
                end
            else
                outputChatBox("[ADMIN - ERROR]: #ffffffNincs ilyen játékos.", playerSource, 112, 152, 207, true)
            end
        end
    end
end)

local adminduty = false

addCommandHandler("aduty", function(playerSource)
    if getElementData(playerSource, "char > admin") >= 3 and getElementData(playerSource, "char > loggedin") and not adminduty then
        setElementData(playerSource, "char > adminduty", true)
        adminduty = true
        local aName = getElementData(playerSource, "char > adminnick") or "Ismeretlen"
        exports.ml_notification:addNotification(getRootElement(),""..aName.." admin szolgálatba lépett!","admin")
    elseif adminduty then
        setElementData(playerSource, "char > adminduty", false)
        adminduty = false
        local aName = getElementData(playerSource, "char > adminnick") or "Ismeretlen"
        exports.ml_notification:addNotification(getRootElement(),""..aName.." kilépett adminszolgálatból!","admin")
    end
end)

addCommandHandler("goto",function(playerSource, commandName, who)
    if getElementData(playerSource, "char > admin") >= 3 and getElementData(playerSource, "char > loggedin") then
        if not (who) then
            outputChatBox(""..prefix.." #ffffff/"..commandName.." [ID]", playerSource,112, 152, 207,true)
        else
            local targetPlayer, targetPlayerName =  exports.ml_core:findPlayerByPartialNick(playerSource, who)
            if not targetPlayer then return outputChatBox("[ADMIN - ERROR]: #ffffffA kiválasztott játékos nem létezik.", playerSource, 112, 152, 207, true) end
            local aName = getElementData(playerSource, "char > adminnick") or "Ismeretlen Admin"
            local name = getElementData(targetPlayer, "char > name"):gsub("_", " ")
            if getElementData(targetPlayer, "char > loggedin")then
                local x, y, z = getElementPosition(targetPlayer)
                local interior = getElementInterior(targetPlayer)
                local dimension = getElementDimension(targetPlayer)
                local r = getPedRotation(targetPlayer)

                x = x + ( ( math.cos ( math.rad ( r ) ) ) * 2 )
                y = y + ( ( math.sin ( math.rad ( r ) ) ) * 2 )
                    
                setCameraInterior(playerSource, interior)
                    
                if (isPedInVehicle(playerSource)) then
                    local veh = getPedOccupiedVehicle(playerSource)
                    setVehicleTurnVelocity(veh, 0, 0, 0)
                    setElementInterior(playerSource, interior)
                    setElementDimension(playerSource, dimension)
                    setElementInterior(veh, interior)
                    setElementDimension(veh, dimension)
                    setElementPosition(veh, x, y, z + 1)
                    warpPedIntoVehicle ( playerSource, veh ) 
                    setTimer(setVehicleTurnVelocity, 50, 20, veh, 0, 0, 0)
                else
                    setElementPosition(playerSource, x, y, z)
                    setElementInterior(playerSource, interior)
                    setElementDimension(playerSource, dimension)
                end
                outputChatBox("[ADMIN]: #ffffffEgy admin hozzád teleportált. #7098CF(".. aName ..")", targetPlayer, 112, 152, 207,true)
                outputChatBox("[ADMIN]: #ffffffOda teleportáltál a kiválasztott játékoshoz. #7098CF("..name..")", playerSource, 112, 152, 207, true)
                sendAdminLog(aName.. " használta a #7098CF/"..commandName.."#ffffff parancsot a következő játékoson: #7098CF"..name.."")          
            else
                outputChatBox("[ADMIN - ERROR]: A kiválasztott játékos nincs bejelentkezve.", playerSource, 112, 152, 207, true)
            end
        end
    end
end)

addCommandHandler("gethere", function(playerSource, commandName, who)
    if getElementData(playerSource, "char > admin") >= 3 and getElementData(playerSource, "char > loggedin") then
        if not (who) then
            outputChatBox(""..prefix.." #ffffff/"..commandName.." [ID]", playerSource,112, 152, 207,true)
        else
            local targetPlayer, targetPlayerName =  exports.ml_core:findPlayerByPartialNick(playerSource, who)
            if not targetPlayer then return outputChatBox("[ADMIN - ERROR]: #ffffffA kiválasztott játékos nem létezik.", playerSource, 112, 152, 207, true) end
            pName = getElementData(targetPlayer, "char > name"):gsub("_", " ")
            local aName = getElementData(playerSource, "char > adminnick") or "Ismeretlen Admin"
                if getElementData(targetPlayer, "char > loggedin")then
            
                    local x, y, z = getElementPosition(playerSource)
                    local interior = getElementInterior(playerSource)
                    local dimension = getElementDimension(playerSource)
                    local r = getPedRotation(playerSource)
                    setCameraInterior(targetPlayer, interior)

                    x = x + ( ( math.cos ( math.rad ( r ) ) ) * 2 )
                    y = y + ( ( math.sin ( math.rad ( r ) ) ) * 2 )
                    
                if (isPedInVehicle(targetPlayer)) then
                    local veh = getPedOccupiedVehicle(targetPlayer)
                    setVehicleTurnVelocity(veh, 0, 0, 0)
                    setElementPosition(veh, x, y, z + 1)
                    setTimer(setVehicleTurnVelocity, 50, 20, veh, 0, 0, 0)
                    setElementInterior(veh, interior)
                    setElementDimension(veh, dimension)
                 
                else
                    setElementPosition(targetPlayer, x, y, z)
                    setElementInterior(targetPlayer, interior)
                    setElementDimension(targetPlayer, dimension)
                end
                outputChatBox("[ADMIN]: #ffffffEgy admin magához teleportált. #7098CF(".. aName ..")", targetPlayer, 112, 152, 207,true)
                outputChatBox("[ADMIN]: #ffffffMagadhoz teleportáltad a kiválasztott játékost #7098CF(" .. pName .. ")", playerSource, 112, 152, 207,true)
                sendAdminLog(aName.. " használta a #7098CF/"..commandName.."#ffffff parancsot a következő játékoson: #7098CF"..pName.."") 
            else
                outputChatBox("[ADMIN - ERROR]: A kiválasztott játékos nincs bejelentkezve.", playerSource, 112, 152, 207, true)
            end
        end
    end
end)

addCommandHandler("setskin",function(playerSource, commandName, who, skinID)
    if getElementData(playerSource, "char > admin") >= 5 and getElementData(playerSource, "char > loggedin") then
        if not (skinID) or not (who) then
            outputChatBox(""..prefix.." #ffffff/"..commandName.." [ID] [Skin ID]", playerSource,112, 152, 207,true)
        else
            local targetPlayer, targetPlayerName =  exports.ml_core:findPlayerByPartialNick(playerSource, who)
            if not targetPlayer then return outputChatBox("[ADMIN - ERROR]: #ffffffA kiválasztott játékos nem létezik.", playerSource, 112, 152, 207, true) end
            local name =  getElementData(targetPlayer, "char > name"):gsub("_", " ")
            local accountID = getElementData(targetPlayer, "char > accountid")
            local aName = getElementData(playerSource, "char > adminnick") or "Ismeretlen Admin"
            if (targetPlayer) then
                setElementModel(targetPlayer, tonumber(skinID))
                dbExec(con,"UPDATE `account` SET `skin`=" .. tonumber(skinID) .. " WHERE `id`=?",accountID)
                setElementData(targetPlayer, "char > skin", skinID)
                outputChatBox("[ADMIN]:#ffffff Megváltoztattad a játékos skinjét! #7098CF(" .. name .. ") #ffffff(".. skinID ..")", playerSource, 112, 152, 207,true)
                sendAdminLog(aName.. " használta a #7098CF/"..commandName.."#ffffff parancsot a következő játékoson: #7098CF"..name.."") 
            end
        end
    end
end)

addCommandHandler("healup", function(playerSource, commandName, who)
	if getElementData(playerSource, "char > admin") >= 3 and getElementData(playerSource, "char > loggedin") then
		if not (who) then
            outputChatBox(""..prefix.." #ffffff/"..commandName.." [ID]", playerSource,112, 152, 207,true)
        else
        	local targetPlayer, targetPlayerName =  exports.ml_core:findPlayerByPartialNick(playerSource, who)
        	if not targetPlayer then return outputChatBox("[ADMIN - ERROR]: #ffffffA kiválasztott játékos nem létezik.", playerSource, 112, 152, 207, true) end
        	local name =  getElementData(targetPlayer, "char > name"):gsub("_", " ")
        	local aName = getElementData(playerSource, "char > adminnick") or "Ismeretlen Admin"
            if (targetPlayer) then
            	setElementData(targetPlayer, "char > food", 100)
            	setElementData(targetPlayer, "char > drink", 100)
            	setElementHealth(targetPlayer, 100)
            	outputChatBox("[ADMIN]:#ffffff A kiválasztott játékos élete, szomjúság szintje, éhség szintje feltöltve. #7098CF("..name..")", playerSource, 112, 152, 207, true)
            	sendAdminLog(aName.. " használta a #7098CF/"..commandName.."#ffffff parancsot a következő játékoson: #7098CF"..name.."") 
            end
        end
	end
end)

addCommandHandler("disappear",function(playerSource, commandName)
    if getElementData(playerSource, "char > admin") >= 3 and getElementData(playerSource, "char > loggedin") then
        if getElementData(playerSource, "disappear") then
            outputChatBox("[ADMIN]: #ffffffSikeresen megjelentél!", playerSource, 112, 152, 207,true)
            setElementAlpha(playerSource, 255)
            setElementData(playerSource, "disappear", false)
        else
            outputChatBox("[ADMIN]: #ffffffSikeresen eltüntél!", playerSource, 112, 152, 207,true)
            setElementAlpha(playerSource, 0) 
            setElementData(playerSource, "disappear", true)
        end
    end
end)

addCommandHandler("kick",
    function(playerSource, commandName, who, ...)
        if getElementData(playerSource, "char > admin") >= 3 and getElementData(playerSource, "char > loggedin") then
            if not (who) or not (...) then
                outputChatBox(""..prefix.." #ffffff/"..commandName.." [ID] [Indok]", playerSource,112, 152, 207,true)
            else
                local kickReason = table.concat({...}, " ")
                local targetPlayer, targetPlayerName = exports.ml_core:findPlayerByPartialNick(playerSource, who)
                if not targetPlayer then return outputChatBox("[ADMIN - ERROR]: #ffffffA kiválasztott játékos nem létezik.", playerSource, 112, 152, 207, true) end
                local admin_name = getElementData(playerSource, "char > adminnick")
                local player_name = getElementData(targetPlayer, "char > name")
                local accountID = getElementData(targetPlayer, "char > accountid")
                if targetPlayer then
                    if getElementData(targetPlayer, "char > admin") > getElementData(playerSource, "char > admin") then
                        outputChatBox("[ADMIN - ERROR]: #ffffffNálad nagyobb rangú admint nem kickelhetsz.", playerSource, 112, 152, 207, true)
                        outputChatBox("[ADMIN - ERROR]: #ffffffEgy admin kickelni akart téged. #7098CF("..admin_name..")", targetPlayer, 112, 152, 207, true)
                        return 
                    end
                    kickPlayer(targetPlayer, admin_name, kickReason)
                    outputChatBox("[ADMIN - " .. getElementData(playerSource, "char > adminnick") .. "]:#ffffff Kirúgta a szerverről #7098CF"..player_name:gsub("_", " ").."#ffffff játékost, indok: #7098CF"..kickReason.."", getRootElement(), 112, 152, 207, true)
                end
            end
        end
    end
)

addCommandHandler("asay",
    function(playerSource, commandName, ...)
        if getElementData(playerSource, "char > admin") >= 3 and getElementData(playerSource, "char > loggedin") then
            if not (...) then
                outputChatBox(""..prefix.." #ffffff/"..commandName.." [szöveg]", playerSource, 112, 152, 207,true)
            else
                message = table.concat({...}, " ")
                local adminRank = exports.ml_core:getAdminRank(playerSource)
                outputChatBox("#A03434[Adminfelhívás - " .. getElementData(playerSource, "char > adminnick") .. " ("..adminRank..") ]:#ffffff "..message.."", getRootElement(), 255, 255, 255, true)
            end
        end
    end
)

function unflipveh(playerSource, commandName, who)
    if (tonumber(getElementData(playerSource, "char > admin")) > 3) then
        if not who then
            if not (isPedInVehicle(playerSource)) then
                 outputChatBox(""..prefix.." #ffffff/"..commandName.." [ID]", playerSource, 112, 152, 207,true)
            else
                local veh = getPedOccupiedVehicle(playerSource)
                local rx, ry, rz = getVehicleRotation(veh)
                setVehicleRotation(veh, 0, ry, rz);
                outputChatBox("[ADMIN]: #ffffffA járműved vissza lett borítva.", playerSource, 112, 152, 207, true)
            end
        else
            local targetPlayer = exports.ml_core:findPlayerByPartialNick(playerSource, who)
            local player_name = getElementData(targetPlayer, "char > name")
            local admin_name = getElementData(playerSource, "char > adminnick")
            if targetPlayer then
                
                if not getElementData(targetPlayer, "char > loggedin") then
                    outputChatBox("[ADMIN]: #ffffffA játékos nincs bejelentkezve.", playerSource, 112, 152, 207, true)
                else
                    local veh = getPedOccupiedVehicle(targetPlayer)
                    if veh then
                        local rx, ry, rz = getVehicleRotation(veh)
                        setVehicleRotation(veh, 0, ry, rz)
                        outputChatBox("[ADMIN]: #ffffffVissza borítottad a kiválasztott játékos járművet. #7098CF("..player_name:gsub("_", " ")..")", playerSource, 112, 152, 207, true)
                        outputChatBox("[ADMIN]: #ffffffEgy admin vissza borította a járműved. #7098CF("..admin_name..")", targetPlayer, 112, 152, 207, true)
                        sendAdminLog(admin_name.. " használta a #7098CF/"..commandName.."#ffffff parancsot a következő játékoson: #7098CF"..player_name:gsub("_", " ").."") 
                    else
                        outputChatBox("[ADMIN]: #ffffffA játékos nincs járműben.", playerSource, 112, 152, 207, true)
                    end
                end
            end
        end
    end
end
addCommandHandler("unflip", unflipveh, false, false);

addCommandHandler("fixveh", function(playerSource, commandName, who)
	if getElementData(playerSource, "char > admin") >= 5 and getElementData(playerSource, "char > loggedin") then
		if not (who) then
            outputChatBox(""..prefix.." #ffffff/"..commandName.." [ID]", playerSource,112, 152, 207,true)
        else
        	local targetPlayer, targetPlayerName =  exports.ml_core:findPlayerByPartialNick(playerSource, who)
        	if not targetPlayer then return outputChatBox("[ADMIN - ERROR]: #ffffffA kiválasztott játékos nem létezik.", playerSource, 112, 152, 207, true) end
        	local name =  getElementData(targetPlayer, "char > name"):gsub("_", " ")
        	local aName = getElementData(playerSource, "char > adminnick") or "Ismeretlen Admin"
            if (targetPlayer) then
            	if isPedInVehicle(targetPlayer) then
            	    local carCheck = getPedOccupiedVehicle(targetPlayer)
            	    outputChatBox("[ADMIN]:#ffffff A kiválasztott játékos járműve megszerelve. #7098CF("..name..")", playerSource, 112, 152, 207, true)
            	    sendAdminLog(aName.. " használta a #7098CF/"..commandName.."#ffffff parancsot a következő játékoson: #7098CF"..name.."")
            	    fixVehicle(carCheck)
            	else
                    outputChatBox("[ADMIN - ERROR]: #ffffffA kiválasztott játékos nincs járműben.", playerSource, 112, 152, 207, true) 
            	end 
            end
        end

	end
end)

addCommandHandler("a", function(playerSource, commandName, ...)
     if getElementData(playerSource, "char > admin") >= 3 and getElementData(playerSource, "char > loggedin") then
        if not (...) then
            outputChatBox(""..prefix.." #ffffff/"..commandName.." [Szöveg]", playerSource,112, 152, 207,true)
        else
            local message = table.concat({...}, " ")
            local aName = getElementData(playerSource, "char > adminnick") or "Ismeretlen admin" 
            local aRank = exports.ml_core:getAdminRank(playerSource)
            for k, arrayPlayer in ipairs(getElementsByType("player")) do
                if getElementData( arrayPlayer, "char > admin" ) >= 3 then
                    outputChatBox("[Admin chat] #A84E4E[" .. aRank .. "] #6a6a6a[" .. aName .. "]: #ffffff" .. message.. "", arrayPlayer, 112, 152, 207,true)
                end
            end
        end
    end
end)

addCommandHandler("as", function(playerSource, commandName, ...)
     if getElementData(playerSource, "char > admin") >= 1 and getElementData(playerSource, "char > loggedin") then
        if not (...) then
            outputChatBox(""..prefix.." #ffffff/"..commandName.." [Szöveg]", playerSource,112, 152, 207,true)
        else
            local message = table.concat({...}, " ")
            local aName = getElementData(playerSource, "char > adminnick") or "Ismeretlen admin" 
            for k, arrayPlayer in ipairs(getElementsByType("player")) do
                if getElementData( arrayPlayer, "char > admin" ) >= 1 then
                    outputChatBox("[Adminsegéd Chat] [" .. aName .. "]: #ffffff" .. message.. "", arrayPlayer, 112, 152, 207,true)
                end
            end
        end
    end
end)


function tempVeh(playerSource, commandName, vehid )
    if getElementData(playerSource, "char > admin") >= 8 and getElementData(playerSource, "char > loggedin") then
    	if not vehid then return
            outputChatBox(""..prefix.." #ffffff/"..commandName.." [Kocsi ID]", playerSource,112, 152, 207,true)
    	else
	        local x, y, z = getElementPosition (playerSource) 
	        local rotZ = getElementRotation (playerSource) 
	        local aName = getElementData(playerSource, "char > adminnick") or "Ismeretlen Admin"

	        if vehid then
		        local newVehicle = createVehicle(vehid, x + 2, y, z, 0, 0, rotZ)
                if not newVehicle then
                   outputChatBox("[ADMIN - ERROR]: #ffffffHibás jármű ID.", playerSource, 112, 152, 207,true)
                   return
                end
                local vehName = getVehicleNameFromModel(tonumber(vehid))
		        outputChatBox("[ADMIN]:#ffffff Sikeresen létrehoztál egy ideiglenes járművet. #7098CF("..vehName:gsub("_", " ")..")", playerSource, 112, 152, 207,true)
		        sendAdminLog(aName.. " használta a #7098CF/"..commandName.."#ffffff parancsot, jármű: #7098CF"..vehName:gsub("_", " ")..".")
	        end
	    end
    end
end
addCommandHandler("veh", tempVeh)

addCommandHandler("spec", function(playerSource, commandName, targetPlayer)
    if getElementData(playerSource, "char > admin") >= 8 and getElementData(playerSource, "char > loggedin") then
        if not targetPlayer then
            outputChatBox(""..prefix.." #ffffff/"..commandName.." [ID/Név]", playerSource,112, 152, 207,true)
        else
            targetPlayer = exports.ml_core:findPlayerByPartialNick(playerSource, targetPlayer)

            if targetPlayer then
                local aName = getElementData(playerSource, "char > adminnick") or "Ismeretlen admin" 
                local player_name = getElementData(targetPlayer, "char > name"):gsub("_", " ")

                if targetPlayer == playerSource then 
                    local playerLastPos = getElementData(playerSource, "playerLastPos")

                    if playerLastPos then 
                        local currentTarget = getElementData(playerSource, "spectateTarget") 
                        local spectatingPlayers = getElementData(currentTarget, "spectatingPlayers") or {} 

                        spectatingPlayers[playerSource] = nil 
                        setElementData(currentTarget, "spectatingPlayers", spectatingPlayers) 

                        setElementAlpha(playerSource, 255)
                        setElementInterior(playerSource, playerLastPos[4])
                        setElementDimension(playerSource, playerLastPos[5])
                        setCameraInterior(playerSource, playerLastPos[4])
                        setCameraTarget(playerSource, playerSource)
                        setElementFrozen(playerSource, false)
                        setElementCollisionsEnabled(playerSource, true)
                        setElementPosition(playerSource, playerLastPos[1], playerLastPos[2], playerLastPos[3])
                        setElementRotation(playerSource, 0, 0, playerLastPos[6])

                        removeElementData(playerSource, "spectateTarget")
                        removeElementData(playerSource, "playerLastPos")


                        outputChatBox("[ADMIN]: #ffffffKikapcsoltad a játékos nézést.", playerSource,112, 152, 207,true)
                        sendAdminLog(aName.. " használta a #7098CF/"..commandName.."#ffffff parancsot, állapot: #7098CFKikapcsolva.")
                    end
                else
                    local targetInterior = getElementInterior(targetPlayer)
                    local targetDimension = getElementDimension(targetPlayer)
                    local currentTarget = getElementData(playerSource, "spectateTarget")
                    local playerLastPos = getElementData(playerSource, "playerLastPos")

                    if currentTarget and currentTarget ~= targetPlayer then
                        local spectatingPlayers = getElementData(currentTarget, "spectatingPlayers") or {} 

                        spectatingPlayers[playerSource] = nil 
                        setElementData(currentTarget, "spectatingPlayers", spectatingPlayers) 
                    end

                    if not playerLastPos then 
                        local localX, localY, localZ = getElementPosition(playerSource)
                        local localRotX, localRotY, localRotZ = getElementPosition(playerSource)
                        local localInterior = getElementInterior(playerSource)
                        local localDimension = getElementDimension(playerSource)

                        setElementData(playerSource, "playerLastPos", {localX, localY, localZ, localInterior, localDimension, localRotZ}, false)
                    end

                    setElementAlpha(playerSource, 0)
                    setPedWeaponSlot(playerSource, 0)
                    setElementInterior(playerSource, targetInterior)
                    setElementDimension(playerSource, targetDimension)
                    setCameraInterior(playerSource, targetInterior)
                    setCameraTarget(playerSource, targetPlayer)
                    setElementFrozen(playerSource, true)
                    setElementCollisionsEnabled(playerSource, false)

                    local spectatingPlayers = getElementData(targetPlayer, "spectatingPlayers") or {} 

                    spectatingPlayers[playerSource] = true 
                    setElementData(targetPlayer, "spectatingPlayers", spectatingPlayers) 

                    setElementData(playerSource, "spectateTarget", targetPlayer)

                    local player_name = getElementData(targetPlayer, "char > name"):gsub("_", " ")

                    outputChatBox("[ADMIN]: #ffffffElkezdted nézni a játékost. #7098CF(" .. player_name .. ")", playerSource,112, 152, 207,true)
                    outputChatBox("[ADMIN]: #ffffffKikapcsoláshoz /spec [Saját ID/Név]", playerSource,112, 152, 207,true)
                    sendAdminLog(aName.. " használta a #7098CF/"..commandName.."#ffffff parancsot, állapot: #7098CFBekapcsolva#ffffff, célpont: #7098CF" .. player_name .. ".")
                end
            end
        end
    end
end)

addCommandHandler("adminlog", function(playerSource)
    if getElementData(playerSource, "admin > log") then
        setElementData(playerSource, "admin > log", false)
        outputChatBox("[ADMIN]: #ffffffAdmin-log bekapcsolva!", playerSource,112, 152, 207,true)
    else
        setElementData(playerSource, "admin > log", true)
        outputChatBox("[ADMIN]: #ffffffAdmin-log kikapcsolva!", playerSource,112, 152, 207,true)
    end
end)

function sendAdminLog(text)
    for k,v in pairs(getElementsByType("player")) do
        local adminlevel = getElementData(v, "char > admin") or 0
        if adminlevel > 3 and not getElementData(v, "admin > log") then
            outputChatBox("[ADMIN LOG]: #ffffff"..text, v, 176, 80, 80, true)
        end
    end
end

function formatMoney(amount)
    local formated = tonumber(amount)
    if formated then
        while true do  
            formated, k = string.gsub(formated, "^(-?%d+)(%d%d%d)", '%1,%2')
        if (k==0) then
            break
        end
    end
        return formated
    else
        return amount
    end
end

