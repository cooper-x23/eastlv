local connection = exports.ml_mysql:getConnection()

addEvent( "setWalk", true )
addEventHandler( "setWalk", root,
	function(wid)
		dbExec(connection,"UPDATE `account` SET `walkstyle`=? WHERE `id`="..getElementData(source,"char > accountid"),wid)
		setPedWalkingStyle(source,wid)		
	end
)
