local mysqlDatas = {
	["host"] = "mysql.srkhost.eu",
	["username"] = "u9529_AT9xdlDf6Y",
	["dbName"] = "s9529_eastlv",
	["password"] = "YxCK4kbCrkM1",
}
local mysqlConnect = nil

function makeConnection()
	mysqlConnect = dbConnect("mysql","dbname=" .. mysqlDatas["dbName"] ..";host=" .. mysqlDatas["host"] .. "", "" .. mysqlDatas["username"] .. "", "" .. mysqlDatas["password"] .. "", "autoreconnect=1")
	if not mysqlConnect then
		outputChatBox("[East - Connection] Kapcsolat megszakadt!")
		cancelEvent(true)
	else
		outputChatBox("[East - Connection] Kapcsolat létrejött!")
	end
end
addEventHandler("onResourceStart", resourceRoot, makeConnection)

function getConnection()
	if not mysqlConnect then
		outputChatBox("[East - Connection] Kapcsolat megszakadt!")
		return
	end
	return mysqlConnect
end