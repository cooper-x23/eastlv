--script by theMark
local sql = exports.ml_mysql:getConnection()
-- addEvent('giveButtonItem > ml', true)
-- addEventHandler('giveButtonItem > ml', root, function(player, item)
-- 	exports.ml_inventory:givePlayerItem(player, item, false, 1, 1, 100)
-- end)

addCommandHandler('addshop', function(player, cmd, name, item1, item2, item3, item4, item5, item6, item7, item8, item9, item1price, item2price, item3price, item4price, item5price, item6price, item7price, item8price, item9price)
	if name and item1 and item2 and item3 and item4 and item5 and item6 and item7 and item8 and item9 and item1price and item2price and item3price and item4price and item5price and item6price and item7price and item8price and item9price then
		local ped = createPed(107, player.position)
		ped:setData('ped > name', name)
		ped:setData('ped > shopped', true)
		sql:exec('INSERT INTO shop SET name=?, position=?, items=?, type=?, price=?', name, toJSON({player.position.x, player.position.y, player.position.z}), toJSON({item1, item2, item3, item4, item5, item6, item7, item8, item9}), 'no', toJSON({item1price, item2price, item3price, item4price, item5price, item6price, item7price, item8price, item9price}))
	else
		outputChatBox('#7098CF' .. '[BOLT]:' .. '#FFFFFF' .. 'Használat: ' .. '/' .. cmd .. ' ' .. '[Név] [Item1] [Item2] [Item3] [Item4] [Item5] [Item6] [Item7] [Item8] [Item9] [Item1 ára] [Iem2 ára] [Item3 ára] [Item4 ára] [Item5 ára] [Item6 ára] [Item7 ára] [Item8 ára] [Item9 ára]', player, 255, 255, 255, true)
	end
end)

addEventHandler('onResourceStart', resourceRoot, function()
	sql:query(function(qh)
		local result = qh:poll(0)
		if result then
			for _, row in pairs(result) do
				local pos = fromJSON(row.position)
				local items = fromJSON(row.items)
				local price = fromJSON(row.price)
				local ped = createPed(107, pos[1], pos[2], pos[3])
				ped:setData('ped > name', row.name)
				ped:setData('ped > shopped', true)
				ped:setData('ped > items', {
					{
						id = items[1],
						price = price[1]
					},
					{
						id = items[2],
						price = price[2]
					},
					{
						id = items[3],
						price = price[3]
					},
					{
						id = items[4],
						price = price[4]
					},
					{
						id = items[5],
						price = price[5]
					},
					{
						id = items[6],
						price = price[6]
					},
					{
						id = items[7],
						price = price[7]
					},
					{
						id = items[8],
						price = price[8]
					},
					{
						id = items[9],
						price = price[9]
					}
				})
			end
		end
	end, 'SELECT * FROM shop')
end)