--script by theMark

local sql = exports.ml_mysql:getConnection()

addEvent('uploadSqlItems > ml', true)
addEventHandler('uploadSqlItems > ml', root, function(player, itemid, slot, count, page, percentage)	
	sql:query(function(qh)
		local result = qh:poll(0)
		if #result > 0 then
			-- sql:exec('UPDATE items SET itemid=?, slot=?, count=?, page=?, percentage=? WHERE playerid=?', itemid, slot, count, page, percentage, player:getData('char > accountid'))
		else
			sql:exec('INSERT INTO items SET playerid=?, itemid=?, slot=?, count=?, page=?, percentage=?', player:getData('char > accountid'), itemid, slot, count, page, percentage)
		end
	end, 'SELECT * FROM items WHERE playerid=? and slot=?', player:getData('char > accountid'), slot)
end)

addEvent('serverResourceStart > ml', true)
addEventHandler('serverResourceStart > ml', root, function(player)
	Timer(function()
		sql:query(function(qh)
			local result = qh:poll(0)
			if result then
				for _, row in pairs(result) do
					triggerClientEvent(player, 'giveItemAcceptedServer > ml', player, row['itemid'], row['slot'], row['count'], row['page'], row['percentage'])
					print('Itemek betöltve!')
				end
			end
		end, 'SELECT * FROM items WHERE playerid=?', player:getData('char > accountid'))
	end, 500, 1)
end)

function addLoginItems()
	
end

addEvent('deleteItemWhereSlot > ml', true)
addEventHandler('deleteItemWhereSlot > ml', root, function(player, slot, page)
	sql:exec('DELETE FROM items WHERE playerid=? and slot=? and page=?', player:getData('char > accountid'), slot, page)
end)

addEvent('updateItemSlot > ml', true)
addEventHandler('updateItemSlot > ml', root, function(player, oldSlot, newSlot, page)
	outputChatBox(oldSlot .. ' ' .. 'új slot:' .. newSlot) 
	outputChatBox('frissült')
	sql:exec('UPDATE items SET slot=? WHERE playerid=? and slot=? and page=?', newSlot, player:getData('char > accountid'), oldSlot, page)
end)

-- 			local targetPlayer, targetPlayerName =  exports.ml_core:findPlayerByPartialNick(playerSource, who)

addCommandHandler('giveitem', function(player, cmd, target, itemid, count)
	if target and itemid and count then
		local targetPlayer, targetPlayerName =  exports.ml_core:findPlayerByPartialNick(player, target)
		if not targetPlayer then return end
		triggerClientEvent(targetPlayer, 'giveTargetItem > ml', targetPlayer, itemid, count)
	else
		outputChatBox('[EastMTA]: Használat:' .. ' ' .. '/' .. cmd .. ' ' .. '[Játkos] [ItemID] [Darabszám]', player, 255, 255, 255, true)
	end
end, false, false)


function givePlayerItem(element, itemid, count)
	triggerClientEvent(element, 'giveTargetItem > ml', element, itemid, count)
end