local sql = exports.ml_mysql:getConnection()

local multiAccounts = {
	['127890FDB7E6AA423964F3AA7836CD94'] = true
}

addEvent('registeraccount > ml', true)
addEventHandler('registeraccount > ml', root, function(player, username, password, email)
	sql:query(function(qh)
		local result = qh:poll(0)
		if #result > 0 then
			exports.ml_notification:addNotification(player, 'Neked már van accountod!', 'warning')
			-- break
		else
			sql:exec('INSERT INTO account SET username=?, password=?, email=?, serial=?', username, base64Encode(password), email, player.serial)
		end
	end, 'SELECT * FROM account WHERE serial=?', player.serial)
end)

addEvent('loginaccount > ml', true)
addEventHandler('loginaccount > ml', root, function(player, username, password)
	-- print('result van')
	sql:query(function(qh)
		local result = qh:poll(0)
		if result then
			for _, row in ipairs(result) do
				if username == row['username'] and base64Encode(password) == row['password'] then
					-- outputChatBox('sikeres')
					player:setData('char > have', row['haveaccount'])
					-- outputChatBox(player:getData('char > have'))
					if player:getData('char > have') == 0 then
						triggerClientEvent(player, 'successlogin > ml', player, 'charactercreate')										
					elseif player:getData('char > have') == 1 then
						triggerClientEvent(player, 'successlogin > ml', player, 'login')
						-- exports.ml_inventory:addLoginItems()
						player:setData('char > name', row['name'])
						-- outputChatBox(player:getData('char > name'))
						local position = fromJSON(row['position'])
						player:setData('char > loggedin', true)
						player:spawn(position[1], position[2], position[3], 0, row['skin'])
						-- player.model = row['skin']

						player:setData('char > admin', row['adminlevel'])
						player:setData('char > adminnick', row['adminnick'])

						player:setData('char > accountid', row['id'])
						player:setData('char > walkingstyle', row['walkstyle'])
						player:setWalkingStyle(row['walkstyle'])
						player:setData('char > skin', row['skin'])
						player:setData('char > money', row['money'])
						player:setData('char > bankmoney', row['bankmoney']) 
						player:setData('char > premiumpoints', row['premiumpoints'])
						player:setData('char > level', row['level'])
						player:setData('char > playedtime', row['playedtime'])
					end
				else
					-- outputChatBox('sikertelen')
					exports.ml_notification:addNotification(player, 'Hibás felhasználónév vagy jelszó!', 'warning')
					-- outputChatBox(sha256(password) .. ' ' .. ' ' .. row['password'])
				end 
			end
		end
	end, 'SELECT * FROM account WHERE serial=?', player.serial)
end)

addEvent('createcharacter > ml', true)
addEventHandler('createcharacter > ml', root, function(player, name, description, hobby, target)
	sql:query(function(qh)
		local result = qh:poll(0)
		sql:exec('UPDATE account SET name=?, description=?, hobby=?, target=?, haveaccount=?, skin=?, position=? WHERE serial=?', name, description, hobby, target, 1, 23, toJSON({2338.9397, 2352.9326, 10.8203}), player.serial)
		triggerClientEvent(player, 'panelCloseAndOpen', player)
	end, 'SELECT * FROM account WHERE serial=?', player.serial)
end)

Timer(function()
	for k, v in pairs(Element.getAllByType('player')) do
		if not v:getData('char > loggedin') then return end
		local position = v.position
		sql:exec('UPDATE account SET position=?, skin=?, bankmoney=?, money=?, premiumpoints=?, level=?, playedtime=? WHERE serial=?', toJSON({position.x, position.y, position.z}), v.model, v:getData('char > bankmoney'), v:getData('char > money'), v:getData('char > premiumpoints'), v:getData('char > level'), v:getData('char > playedtime'), v.serial)
	end
end, 1000, 0)


addEvent('server > rememberdata', true)
addEventHandler('server > rememberdata', root, function(player)
	sql:query(function(qh)
		local result = qh:poll(0)
		if result then
			for _, row in pairs(result) do
				--outputChatBox(inspect(row['rememberpw']))
				-- outputChatBox(tostirng(player:getData('char > rememberpw')))
				iprint(tonumber(row['rememberpw']))
				if row['rememberpw'] == 1 then
					triggerClientEvent(player, 'setguidata', player, row['username'], base64Decode(row['password']))
				end
				triggerClientEvent(player, 'setelementadatagui', player, row['rememberpw'])
			end
		end
	end, 'SELECT * FROM account WHERE serial=?', player.serial)
end)

addEvent('acceptClientRememberData', true)
addEventHandler('acceptClientRememberData', root, function(player, remember)
	sql:exec('UPDATE account SET rememberpw=? WHERE serial=?', tonumber(remember), player.serial)
end)