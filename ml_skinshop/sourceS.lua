--Script by LENNON  (112, 152, 207) #7098CF
local sql = exports.ml_mysql:getConnection()

addEvent("skinShopBuy > ml", true)
addEventHandler("skinShopBuy > ml", root, function(player, skin)
	if getElementData(player, "char > money") >= skins[skin][3] then
		setElementData(player, "char > money", getElementData(player, "char > money")-skins[skin][3])
		setElementModel(player, skins[skin][2])
		local query = dbQuery(sql, "UPDATE account SET skin=? WHERE id=?", skins[skin][2], getElementData(player, "char > accountid"))
		dbPoll(query, 500)
		outputChatBox("[SKINSHOP] #ffffffSikeresen megvetted a kiválasztott ruhát!", player, 112, 152, 207, true)
		exports.ml_notification:addNotification(player, "Sikeres ruha vásárlás!", "info")
	else
        outputChatBox("[SKINSHOP - ERROR] #ffffffNincs elég pénzed a ruhára.", player, 112, 152, 207, true)
        exports.ml_notification:addNotification(player, "Sikertelen ruha vásárlás!", "warning")
	end
end)