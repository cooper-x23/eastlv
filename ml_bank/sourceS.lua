--Script by LENNON  (112, 152, 207) #7098CF
local sql = exports.ml_mysql:getConnection()

function loadOneAtm(id)
	local Query = dbPoll(dbQuery(sql, "SELECT * FROM atms WHERE id = ? ", id),100)
	if (Query) then
		for k,v in ipairs(Query) do
			atmObj = createObject(2942,v["x"],v["y"],v["z"]-0.56,0,0,v["rotation"])
			setElementInterior(atmObj,v["interior"])
			setElementDimension(atmObj,v["dimension"])
			setElementData(atmObj, "isAtm", true)
			setElementData(atmObj, "atmID", id) 
			setElementData(atmObj, 'atmProgress', 100)
			setElementData(atmObj, 'atmStart', 100)
			setElementData(atmObj, 'atmBy', false)
		end	
	end
end

function loadAllAtms()
	local result = dbQuery(sql,"SELECT * FROM atms")
	local handler = dbPoll(result, 100)
	local atmCount = 0
	if (handler) then
		for i, row in ipairs(handler) do
			loadOneAtm(row["id"])
			atmCount = atmCount + 1
		end
		outputDebugString("ATM-ek betöltve! ("..atmCount..")", 0,100,100,100)
	end
end
addEventHandler("onResourceStart", resourceRoot, loadAllAtms)

addCommandHandler("delatm",function(playerSource)
	if getElementData(playerSource, "char > admin") >= 8 then
		local x, y, _ = getElementPosition(playerSource)
		local shape = createColCircle ( x,y,3 )
		local atmsNearBy = 0
		for _,v in ipairs(getElementsWithinColShape(shape,"object")) do
			if getElementData(v, "isAtm") == true then
				local atmID = getElementData(v, "atmID")
				atmsNearBy = atmsNearBy + 1
				destroyElement(v)
				dbPoll ( dbQuery(sql, "DELETE FROM atms WHERE id = '?'", atmID), 100)
				outputChatBox("[ATM] #ffffffSikeresen kitörölve. #7098CF(ID: "..atmID..")",playerSource, 112, 152, 207, true)
				destroyElement(shape)
				return
			end
		end
		if(atmsNearBy == 0) then
			outputChatBox("[ATM] #ffffffNincs a közeledbe ATM!", playerSource, 112, 152, 207, true)
			destroyElement(shape)
		end
	end
end)

addCommandHandler("createatm",function(playerSource)
	if getElementData(playerSource, "char > admin") >= 8 then
		local x, y, z = getElementPosition(playerSource)
		local interior = getElementInterior(playerSource)
		local dimension = getElementDimension(playerSource)
		local rotation = getPlayerRotation(playerSource)
		local query = dbQuery(sql, "INSERT INTO atms SET x = ? , y = ? , z = ? , interior = ? , dimension = ? , rotation = ?",x, y, z, interior, dimension, rotation)
		local beszurasQueryEredmeny, _, atmid = dbPoll (query, 500)
		if beszurasQueryEredmeny then
			outputChatBox("[ATM] #ffffffSikeresen lerakva. #7098CF(ID: "..atmid..")",playerSource, 112, 152, 207, true)
			loadOneAtm(atmid)
		end
	end
end)

addEvent("bankMoneyChange > ml",true);
addEventHandler("bankMoneyChange > ml",root,function(player,paytype,amount)
	if getElementData(player, "char > loggedin") then
		if paytype == "payIn" then --befizetés
			setElementData(player, "char > money", getElementData(player, "char > money")-amount) 
            setElementData(player, "char > bankmoney", getElementData(player, "char > bankmoney")+amount) 
		elseif paytype == "payOut" then --kifizetés
			setElementData(player, "char > money", getElementData(player, "char > money")+amount) 
            setElementData(player, "char > bankmoney", getElementData(player, "char > bankmoney")-amount) 
		end
	end
end)

addCommandHandler("penz", function(playerSource)
	setElementData(playerSource, "char > money", getElementData(playerSource, "char > money") + 15250)
	local money = getElementData(playerSource, "char > money")
	dbExec(sql,"UPDATE account SET money=? WHERE id="..getElementData(playerSource,"char > accountid"), money)	
end)

addCommandHandler("penz2", function(playerSource)
	setElementData(playerSource, "char > bankmoney", getElementData(playerSource, "char > bankmoney") + 15250)
	local money = getElementData(playerSource, "char > bankmoney")
	dbExec(sql,"UPDATE account SET bankmoney=? WHERE id="..getElementData(playerSource,"char > accountid"), money)	
end)

addEvent('setPlayerBankAnimation > ml', true)
addEventHandler('setPlayerBankAnimation > ml', root, function(player, block, anim)
	-- outputChatBox('asd')
	player:setAnimation(block, anim)
end)

addEvent('setBankModel > ml', true)
addEventHandler('setBankModel > ml', root, function(atmElement)
	atmElement.model = 2943
end)