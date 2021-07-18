--script by theMark
local sx, sy = guiGetScreenSize()
local font = exports.ml_core:getFont("eastFont",10)
local Panel = {
	show = false,
	size = Vector2(300, 400),
	-- items = {
	-- 	{
	-- 		id = 1,
	-- 		price = 10000000
	-- 	},
	-- 	{
	-- 		id = 2,
	-- 		price = 2
	-- 	},
	-- 	{
	-- 		id = 1,
	-- 		price = 3
	-- 	},
	-- 	{
	-- 		id = 2,
	-- 		price = 4
	-- 	},
	-- 	{
	-- 		id = 1,
	-- 		price = 5
	-- 	},
	-- 	{
	-- 		id = 2,
	-- 		price = 6
	-- 	},
	-- 	{
	-- 		id = 1,
	-- 		price = 7
	-- 	},
	-- 	{
	-- 		id = 2,
	-- 		price = 8
	-- 	},
	-- 	{
	-- 		id = 1,
	-- 		price = 9
	-- 	}
	-- }
	items = false
}

local handlers = {
	{
		name = 'onClientRender',
		func = function(...)
			return Panel:Render(...)
		end
	},
	{
		name = 'onClientClick',
		func = function(...)
			return Panel:Click(...)
		end
	}
}

setmetatable({}, {__index = Panel})
Panel.pos = Vector2(sx / 2 - Panel.size.x / 2, sy / 2 - Panel.size.y / 2)


function Panel:Open(element)
	for key, value in pairs(handlers) do
		removeEventHandler(value.name, value.arg or root, value.func)
		addEventHandler(value.name, value.arg or root, value.func)
	end
	self.show = element
	self.hovered = false
	self.selectedButton = false
end

function Panel:Close()
	for key, value in pairs(handlers) do
		removeEventHandler(value.name, value.arg or root, value.func)
	end
	self.show = false
	self.hovered = false
	self.selectedButton = false
end

local itemAlpha = false

function Panel:Render()
	local distance = getDistanceBetweenPoints3D(localPlayer.position, self.show.position)
	if distance > 5 then Panel:Close() end
	self.hovered = false
	self.selectedButton = false
	local pos = self.pos
	local size = self.size
	dxDrawRectangle(pos, size, tocolor(30, 30, 30))
	dxDrawRectangle(pos, size - Vector2(0, 355), tocolor(25, 25, 25))
	drawText('EastMTA - Bolt', pos, size - Vector2(0, 355), tocolor(255, 255, 255), 1, font, 'center', 'center')

	for i = 1, 9 do

		local btnHovered = isInSlot(pos + Vector2(size.y - 210, 50 + i * 40) - Vector2(0, 40), Vector2(100, 25))

		if btnHovered then
			self.hovered = 'btn'
			self.selectedButton = i
		end

		itemAlpha = btnHovered and 255 or 200

		dxDrawRectangle(pos + Vector2(0, 45 + i * 40) - Vector2(0, 40), Vector2(size.x, 35), tocolor(20, 20, 20))

		dxDrawRectangle(pos + Vector2(size.y - 210, 50 + i * 40) - Vector2(0, 40), Vector2(100, 25), tocolor(112, 152, 207, itemAlpha))

		drawText('Vásárlás', pos + Vector2(size.y - 210, 50 + i * 40) - Vector2(0, 40), Vector2(100, 25), tocolor(255, 255, 255), 1, font, 'center', 'center')
		
		drawText(tostring(exports.ml_inventory:getItemName(tonumber(self.items[i].id))), pos + Vector2(40, 45 + i * 40) - Vector2(0, 40), Vector2(size.x, 35), tocolor(255, 255, 255), 1, font, 'left', 'top')
		
		drawText('Ár: $' .. '#7098CF' .. self.items[i].price, pos + Vector2(40, 45 + i * 40) - Vector2(0, 40), Vector2(size.x, 35), tocolor(255, 255, 255), 1, font, 'left', 'bottom', false, false, false, true)
		-- dxDrawImage(pos + Vector2(0, 45 + i * 40) - Vector2(0, 40), Vector2(35, 35), exports.ml_inventory:getItemImage(1))
		
		exports.ml_inventory:drawItemImage(pos + Vector2(0, 45 + i * 40) - Vector2(0, 40), Vector2(35, 35), self.items[i].id)
	end
end
function drawText(text, position, size, ...)
	return dxDrawText(text, position.x, position.y, position.x + size.x, position.y + size.y, ...)
end

addEventHandler('onClientClick', root, function(button, state, x, y, wx, wy, wz, element)
	if button == 'right' and state == 'down' then
		if element and element:getData('ped > shopped') then
			local distance = getDistanceBetweenPoints3D(localPlayer.position, element.position)
			if distance > 5 then return end
			Panel.items = element:getData('ped > items')
			outputChatBox(inspect(element:getData('ped > items')))
			Timer(function()
				Panel:Open(element)
			end, 100, 1)
		end
	end
end)

--UTILS
function isInSlot(position, size) 
    if isCursorShowing() then 
        cPosX, cPosY = getCursorPosition()
        cPosX, cPosY = cPosX * sx, cPosY * sy
        if ( (cPosX > position.x) and (cPosY > position.y) and (cPosX < position.x + size.x) and (cPosY < position.y + size.y) ) then 
            return true 
        else
            return false
        end
    end
end

function Panel:Click(button, state)
	if self.hovered == 'btn' and self.selectedButton then
		if button == 'left' and state == 'down' then
			Sound('sound/click.mp3')
			-- outputChatBox(inspect(self.selectedButton))
			if localPlayer:getData('char > money') >= tonumber(self.items[self.selectedButton].price) then
				-- triggerServerEvent('giveButtonItem > ml', localPlayer, localPlayer, self.items[self.selectedButton].id)
				exports.ml_inventory:givePlayerItem(self.items[self.selectedButton].id, false, 1, 1, 100)
				exports.ml_notification:addNotification('Sikeresen megvásároltad a kiválasztott tárgyat! (' .. 'ID:' .. self.items[self.selectedButton].id .. ')' .. ' ' .. 'Ára: $' .. self.items[self.selectedButton].price, 'info')
				localPlayer:setData('char > money', localPlayer:getData('char > money') - self.items[self.selectedButton].price)
				Panel:Close()
			else
				outputChatBox('#7098CF' .. '[BOLT]:' .. ' ' .. '#FFFFFF' .. 'Erre nincs elég pénzed!', 255, 255, 255, true)
			end
		end
	end
end

bindKey('backspace', 'down', function()
	if Panel.show then
		Panel:Close()
	end
end)