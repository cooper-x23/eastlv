-- ikon méretek: 32x32(nyugodtan vedd lejebb ha kell), slotok számát add meg ahogy jónak érzed, inventory mérete is rád van bizva.
-- Action bar ugyan ez a szürke háttér, csak világosabbak a nyégzetek, és ennyi.
--Script by theMark
sx, sy = guiGetScreenSize()
local alpha = 0
local useData = {}
local tick = getTickCount()
local items = {}
local itemMoveStorage = {}
local Inventory = {
    show = false,
    size = Vector2(340, 175.5),
    movable = true,
    invSlot = 32,
    itemicons = 4,
    itemIconPNG = {
    	'files/bag.png',
    	'files/keys.png',
    	'files/wallet.png',
    	'files/craft.png'
    },
    itemIconPadding = 35,
    activePage = 1
}
setmetatable({}, {__index = Inventory})

local handlers = {
    {
        name = 'onClientRender',
        func = function(...)
            return Inventory:Render(...)
        end
    },
    {
        name = 'onClientRender',
        func = function(...)
            return Inventory:RenderSlot()
        end
    },
    {
    	name = 'onClientClick',
    	func = function(...)
    		return Inventory:MoveItem(...)
    	end
    },
    {
    	name = 'onClientClick',
    	func = function(...)
    		return Inventory:UsePlayerItem(...)
    	end
    },
    {
    	name = 'onClientClick',
    	func = function(...)
    		return Inventory:SelectPage(...)
    	end
    }
}


local itemLIST = {
	{
		itemid = 1,
		height = 1,
		page = 1,
		name = 'Hotdog'
	},
	{
		itemid = 2,
		height = 1,
		page = 1,
		name = 'Hamburger'
	}
}



function Inventory:Open(element)
    for _, event in pairs(handlers) do
        removeEventHandler(event.name, event.arg or root, event.func)
        addEventHandler(event.name, event.arg or root, event.func)
    end
    self.show = element
    self.activePage = 1
    self.hovered = false
    self.selectedSlot = false
    tick = getTickCount()
end

function getInventorySize()
	return Vector2(Inventory.size.x, Inventory.size.y)
end
getInventorySize()

function Inventory:Close()
    for _, event in pairs(handlers) do
        removeEventHandler(event.name, event.arg or root, event.func)
    end
    self.show = false
    self.hovered = false
    self.selectedSlot = false
    self.activePage = false
    tick = getTickCount()
end

function Inventory:Render()
	if not exports.ml_interface:isWidgetShowing('inventory') then return end
	local inventoryX, inventoryY = localPlayer:getData('inventory.x'), localPlayer:getData('inventory.y')
	local alphaAnimation = interpolateBetween(0, 0, 0, 255, 0, 0, (getTickCount() - tick) / 600, 'Linear')
	Inventory.pos = Vector2(inventoryX, inventoryY)
    self.hovered = false
    self.selectedSlot = false
    dxDrawRectangle(self.pos, self.size, tocolor(25, 25, 25, 255))
    -- ANIMÁCIÓ :D

	dxDrawRectangle(self.pos + Vector2(0, self.size.y), Vector2(self.size.x, 35), tocolor(30, 30, 30, 230))

    local linearAnimation = interpolateBetween(0, 0, 0, self.size.x, 0, 0, (getTickCount() - tick) / 600, 'Linear')
    if linearAnimation ~= self.size.x then
    	dxDrawRectangle(self.pos + Vector2(0, self.size.y), Vector2(linearAnimation, 35), tocolor(20, 20, 20, 230))
    elseif linearAnimation == self.size.x then
	    dxDrawRectangle(self.pos + Vector2(0, self.size.y), Vector2(self.size.x, 35), tocolor(20, 20, 20, 255))
    end
    -- SÚLY HÁTTÉR

    dxDrawRectangle(self.pos + Vector2(self.size.x, 0), Vector2(20, self.size.y + 35), tocolor(20, 20, 20, 255))
    -- SÚLY BETÖLTÉS

    local testAnimation = interpolateBetween(0, 0, 0, self.size.y - 50, 0, 0, (getTickCount() - tick) / 600, 'Linear')
	dxDrawRectangle(self.pos + Vector2(self.size.x, self.size.y + 35), Vector2(20, -testAnimation), tocolor(112, 152, 207))
    local inSlot = isInSlot(self.pos, self.size)
    
    if inSlot then
        self.hovered = 'inventory'
    end
    
    for i = 1, #self.itemIconPNG do


   		local imageHovered = isInSlot(self.pos + Vector2(i * self.itemIconPadding - 20, 0) + Vector2(0, self.size.y + 5), Vector2(25, 25))

   		imageColor = imageHovered and {255, 255, 255} or {65, 65, 65}

    	dxDrawImage(self.pos + Vector2(i * self.itemIconPadding - 20, 0) + Vector2(0, self.size.y + 5), Vector2(25, 25), self.itemIconPNG[i], 0, 0, 0, tocolor(unpack(imageColor)))
   
    	if self.activePage == i then
	    	dxDrawImage(self.pos + Vector2(i * self.itemIconPadding - 20, 0) + Vector2(0, self.size.y + 5), Vector2(25, 25), self.itemIconPNG[i], 0, 0, 0, tocolor(255, 255, 255))
    	end

    	if imageHovered then
    		self.hovered = 'image'
    		self.selectedSlot = i
    	end
   	end
end

local SlothoverColor = 255
local slotColor = {}

local imageColor = {}

function Inventory:RenderSlot()
	if not exports.ml_interface:isWidgetShowing('inventory') then return end
	if self.activePage == 4 then return end -- KRAFTOLÁSMIATT!!!!!!
    local slotCount = 0
    local x = 0
    local y = 0

    for i = 1, self.invSlot do 

        local slotHovered = isInSlot(self.pos + Vector2(12 + x, 10 + y), Vector2(35, 35))

        slotColor = slotHovered and {40, 40, 40} or {20, 20, 20}

        dxDrawRectangle(self.pos + Vector2(12 + x, 10 + y), Vector2(35, 35), tocolor(unpack(slotColor)))

        if #items > 0 then
	    	for slot, item in pairs(items) do

        		if isInSlot(self.pos + Vector2(12 + x, 10 + y), Vector2(35, 35)) then
        			self.hovered = 'slot'
        			self.selectedSlot = i
        			-- outputChatBox(self.selectedSlot)
        		end


	    		if items[slot].slot == i and items[slot].page == self.activePage then
	    			if itemMoveStorage[2] and itemMoveStorage[1] == items[slot].slot then
	    				if not isCursorShowing() then itemMoveStorage = {} return end
	    				local cursorX, cursorY = getCursorPosition()
	        			dxDrawImage(Vector2(cursorX * sx - 10, cursorY * sy - 10), Vector2(35, 35), getItemImagePath(items[slot].item), 0, 0, 0, tocolor(255, 255, 255), true)
    					drawText(items[slot].count, Vector2(cursorX * sx - 10, cursorY * sy - 10), Vector2(35, 35), tocolor(255, 255, 255), 1, 'arial', 'right', 'bottom', false, false, true)
	    			else
	        			dxDrawImage(self.pos + Vector2(12 + x, 10 + y), Vector2(35, 35), getItemImagePath(items[slot].item), 0, 0, 0, tocolor(255, 255, 255), true)
    					drawText(items[slot].count, self.pos + Vector2(12 + x, 10 + y), Vector2(35, 35), tocolor(255, 255, 255), 1, 'arial', 'right', 'bottom', false, false, true)
	        		end
	        		-- if not items[slot].item == itemMoveStorage[2] then
	        			-- dxDrawImage(self.pos + Vector2(12 + x, 10 + y), Vector2(35, 35), getItemImagePath(items[slot].item), 0, 0, 0, tocolor(255, 255, 255), true)
						-- drawText(items[slot].count, self.pos + Vector2(12 + x, 10 + y), Vector2(35, 35), tocolor(255, 255, 255), 1, 'arial', 'right', 'bottom', false, false, true)
	        		-- end
	        	end
	        end
        end
        slotCount = slotCount + 1
        x = x + 40
        if slotCount == 8 then
            x = 0
            slotCount = 0
            y = y + 40
        end
    end
end


bindKey('i', 'down', function()
    if Inventory.show then
        Inventory:Close()
    else
        Inventory:Open(true) 
    end
end)

local inventorySlot = 1

function givePlayerItem(itemid, slot, count, page, percentage)
	if #items >= 32 then return end
	if itemid and count and page and percentage then
		if slot then
			inventorySlot = slot
		else
			if #items == 0 then
				inventorySlot = 1
			end
			for key, value in pairs(items) do
				if items[key].slot == inventorySlot then
					inventorySlot = inventorySlot + 1
				end
			end
		end
		-- local itemheight = itemLIST[itemid].height
		table.insert(items, {
			item = itemid,
			slot = inventorySlot,
			count = count,
			page = page,
			percentage = page,
			-- height = itemheight
		})
		triggerServerEvent('uploadSqlItems > ml', localPlayer, localPlayer, itemid, inventorySlot, count, page, percentage)
	end
end

addEventHandler('onClientResourceStart', resourceRoot, function()
	items = {}
	triggerServerEvent('serverResourceStart > ml', localPlayer, localPlayer)
end)


addEvent('giveItemAcceptedServer > ml', true)
addEventHandler('giveItemAcceptedServer > ml', root, function(itemid, slot, count, page, percentage)
	givePlayerItem(itemid, slot, count, page, percentage)
end)

function getItemImagePath(image)
	return 'files/' .. image .. '.png'
end

function drawText(text, position, size, ...)
	return dxDrawText(text, position.x, position.y, position.x + size.x, position.y + size.y, ...)
end

addCommandHandler('geci', function()
	-- givePlayerItem(2, 5, 1, 3, 100)
	givePlayerItem(1, 32, 1, 3, 100)
end)


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

--ITEM MOZGATÁS

function Inventory:MoveItem(button, state)
	if button == 'left' then
    	for slot, item in pairs(items) do
			if state == 'down' then
				if self.selectedSlot and self.selectedSlot == items[slot].slot and self.hovered == 'slot' then
					itemMoveStorage = {items[slot].slot, items[slot].item, items[slot].count, items[slot].page, self.selectedSlot}
					-- outputChatBox('felemleve')
					return
				end
			elseif state == 'up' then
				self.selectedSlot = self.selectedSlot
				-- self.selectedSlot = 1
				if self.selectedSlot then
					if items[slot].slot == itemMoveStorage[1] then
						for w = 1, #items do
							if items[w].slot == self.selectedSlot then
								itemMoveStorage = {}
								return
							end
						end
						-- outputChatBox(itemMoveStorage[5])
						items[slot].slot = self.selectedSlot
						triggerServerEvent('updateItemSlot > ml', localPlayer, localPlayer, itemMoveStorage[5], self.selectedSlot, self.activePage)
						itemMoveStorage = {}
					end
				else
					itemMoveStorage = {}
				end
			end
		end
	end
end
  
function takePlayerItem(slot)
	if slot then
		table.remove(items, slot)
	end
end


function useItem(i, page)
	if i then
		for key, value in pairs(items) do
			if #useData <= 0 then
				if items[key].slot == i and  items[key].page == page then
					if items[key].item == 1 then
						outputChatBox('Sikeresen ettél egy hotdogot!')
						takePlayerItem(key)
					elseif items[key].item == 2 then
						outputChatBox('Sikeresen ettél egy hamburgert!')
						takePlayerItem(key)
					elseif items[key].item == 3 then
						outputChatBox('majd flex')
						-- useData = {items[key].item, Panel.selectedSlot}
					end
				end
			end
		end
	end
end

function isSlotFree(slot)
	if slot then
		for i = 1, 32 do
			if items[i].slot ~= slot then
				return true
				-- break
			else
				return false
			end
		end
	end
end

function findIndex(tbl)
	for i = 1, 32 do
		if tbl[i] then
			return true
		else 
			return false
		end
	end
end

-- self.hovered = 'slot'
-- self.selectedSlot = i

function Inventory:UsePlayerItem(button, state)
	if self.hovered == 'slot' and self.selectedSlot then
		if button == 'right' and state == 'down' then
			-- outputChatBox('?')
			useItem(self.selectedSlot, self.activePage)
			triggerServerEvent('deleteItemWhereSlot > ml', localPlayer, localPlayer, self.selectedSlot, self.activePage)
		end
	end
end

function Inventory:SelectPage(button, state)
	if self.hovered == 'image' and self.selectedSlot then
		if button == 'left' and state == 'down' then
			self.activePage = self.selectedSlot
			outputChatBox(self.activePage)
		end
	end	
end

-- local guiStack = GuiEdit(self.pos + Vector2(0, self.size.y + 5), Vector2(50, 20), '0', false)

function Inventory_ActionBarRender()
	 if not getElementData(localPlayer, 'char > toghud') then return end
	if not exports.ml_interface:isWidgetShowing('actionbar') then return end
	local actionbarX, actionbarY = localPlayer:getData('actionbar.x'), localPlayer:getData('actionbar.y')
	dxDrawRectangle(Vector2(actionbarX, actionbarY), Vector2(195, 40), tocolor(25, 25, 25))
	for i = 1, 5 do
		-- dxDrawRectangle(Vector2(sx / 2 - 32 + i * 76 / 2 - 76, sy - 80 / 2), Vector2(35, 35), tocolor(30, 30, 30))
		dxDrawRectangle(Vector2(actionbarX + (i * 38) - 34.4, actionbarY + 2), Vector2(35, 35), tocolor(20, 20, 20))
	end
end
addEventHandler('onClientRender', root, Inventory_ActionBarRender)

--UTILS

function isValueInTable(theTable, value, columnID)
    assert(theTable, "Bad argument 1 @ isValueInTable (table expected, got " .. type(theTable) .. ")")
    local checkIsTable = type(theTable)
    assert(checkIsTable == "table", "Invalid value type @ isValueInTable (table expected, got " .. checkIsTable .. ")")
    assert(value, "Bad argument 2 @ isValueInTable (value expected, got " .. type(value) .. ")")
    assert(columnID, "Bad argument 3 @ isValueInTable (number expected, got " .. type(columnID) .. ")")
    local checkIsID = type(columnID)
    assert(checkIsID == "number", "Invalid value type @ isValueInTable (number expected, got " ..checkIsID .. ")")
    for i,v in ipairs (theTable) do
        if v[columnID] == value then
            return true,i
        end
    end
    return false
end

--ITEMKÉPEK
-- Kaja, = piros,  Ital = kék, fegyver = világosszürke, iratok = narancssárga, kulcsok = zöldes
-- Kaja, = piros,  Ital = kék, fegyver = világosszürke, iratok = narancssárga, kulcsok = zöldes
-- Kaja, = piros,  Ital = kék, fegyver = világosszürke, iratok = narancssárga, kulcsok = zöldes
--
-- function givePlayerItem(itemid, slot, count, page, percentage)
addEvent('giveTargetItem > ml', true)
addEventHandler('giveTargetItem > ml', root, function(itemid, count)
	givePlayerItem(itemid, false, count, 1, 100)
	-- outputChatBox(inspect(items))
end)

function drawItemImage(position, size, img)
	return dxDrawImage(position, size, getItemImagePath(img))
end
function getItemName(id)
	return itemLIST[id].name
end