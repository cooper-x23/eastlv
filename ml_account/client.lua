local sx, sy = guiGetScreenSize()
localPlayer:setData('char > rememberpw', 0)
local font = DxFont('files/font.ttf', 10)
local changelogColor = {}
-- 942.19696, 2585.38232, 32.59958
local clickTick = getTickCount()
Panel = {
	show = false,
	size = Vector2(500, 300),
	activePage = 'login',
	loginBox = 2,
	registerBox = 4,
	characterBox = 4,
	loginBoxText = {
		'Felhasználónév',
		'Jelszó'
	},
	loginGuis = {
		GuiEdit(-1000, -1000, 0,0, '', false),
		GuiEdit(-100, -1000, 0,0, '', false)
	},
	loginButtonText = {
		'Bejelentkezés',
		'Regisztráció'
	},
	loginButtonPNG = {
		'files/login.png',
		'files/register.png'
	},
	changelog = {
		'LENNON meg lett verve: ' .. '#6A6A6A' .. '{8 / 15 / 2021}',
		'theMark is meg lett verve: ' .. '#6A6A6A' .. '{8 / 16 / 2021}'
	},
	-- LOGIN
	registerGuiText = {
		'Felhasználónév',
		'Jelszó',
		'Jelszó 2x',
		'Email-cím'
	},
	registerGuis = {
		GuiEdit(-1000, -1000, 0,0, '', false),
		GuiEdit(-100, -1000, 0,0, '', false),
		GuiEdit(-1000, -1000, 0,0, '', false),
		GuiEdit(-100, -1000, 0,0, '', false)
	},
	characterGuis = {
		GuiEdit(-1000, -1000, 0,0, '', false),
		GuiEdit(-100, -1000, 0,0, '', false),
		GuiEdit(-1000, -1000, 0,0, '', false),
		GuiEdit(-100, -1000, 0,0, '', false)
	},
	characterText = {
		'Név',
		'Karakter leírás',
		'Hobbi',
		'Cél'
	}
}
Panel.editSize = Vector2(Panel.size.x - 20, 35)
Panel.editPos = Vector2(sx / 2 - Panel.editSize.x / 2, sy / 2 - Panel.editSize.y - Panel.editSize.y - 50 / 2) -- 75
Panel.pos = Vector2(sx / 2 - Panel.size.x / 2, sy / 2 - Panel.size.y / 2)


local boxPadding = false
local tick = getTickCount()


function renderAnimation(i, clicked)
	if boxPadding then
		local animation = interpolateBetween(0, 0, 0, Panel.editSize.x, 0, 0, (getTickCount() - tick) / 500, 'Linear')
		dxDrawRectangle(Panel.editPos.x, Panel.editPos.y + Panel.editSize.y + 3 + boxPadding * 39, animation, 2, tocolor(112, 152, 207))
	end
end


function destroyAnimation()
	removeEventHandler('onClientRender', root, renderAnimation)
	tick = getTickCount()
end

function drawAnimation(i, clicked)
	if i == clicked then
		-- renderAnimation(i, clicked)
		destroyAnimation()
		boxPadding = i
		removeEventHandler('onClientRender', root, renderAnimation)
		addEventHandler('onClientRender', root, renderAnimation)
	end
end


function drawText(text, position, size, ...)
	return dxDrawText(text, position.x, position.y, position.x + size.x, position.y + size.y, ...)
end


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
	},
	{
		name = 'onClientClick',
		func = function(...)
			return Panel:selectPage(...)
		end
	},
	{
		name = 'onClientClick',
		func = function(...)
			return Panel:changelogBack(...)
		end
	},
	{
		name = 'onClientClick',
		func = function(...)
			return Panel:loginClick(...)
		end
	},
	{
		name = 'onClientClick',
		func = function(...)
			return Panel:clickSelectPage(...)
		end
	},
	-- CharacterBringToFront
	{
		name = 'onClientClick',
		func = function(...)
			return Panel:CharacterBringToFront(...)
		end
	},
	{
		name = 'onClientClick',
		func = function(...)
			return Panel:OrderCharacterClick(...)
		end
	},
	{
		name = 'onClientClick',
		func = function(...)
			return Panel:rememberClickPw(...)
		end
	}
}


function Panel:Open(element)
	for _, event in pairs(handlers) do
		removeEventHandler(event.name, event.arg or root, event.func)
		addEventHandler(event.name, event.arg or root, event.func)
	end
	self.show = element
	self.hovered = false
	self.selectedbutton = false

	for k, v in pairs(self.loginGuis) do
		v.maxLength = 50
	end
	for k, v in pairs(self.characterGuis) do
		v.maxLength = 50
	end
	for k, v in pairs(self.registerGuis) do
		v.maxLength = 50
	end
end

function Panel:Close()
	for _, event in pairs(handlers) do
		removeEventHandler(event.name, event.arg or root, event.func)
	end
	self.show = false
	self.hovered = false
	self.selectedbutton = false	
end

function Panel:Render()
    localPlayer:setData('char > toghud', false)
	self.selectedbutton = false
	self.hovered = false
	local pos = self.pos
	-- pos.y = interpolateBetween(0, 0, 0, self.pos.y, 0, 0, (getTickCount() - tick) / 600, 'OutBack')
	local size = self.size
	local editSize = self.editSize
	local editPos = self.editPos
	dxDrawRectangle(pos, size, tocolor(45, 45, 45, 255))
	local page = self.activePage
	if page == 'login' then
		for i = 1, self.loginBox do	
			dxDrawRectangle(editPos + Vector2(0, i * 40), editSize, tocolor(65, 65, 65, 255))
			if self.loginGuis[i].text == '' then
				drawText(self.loginBoxText[i], editPos + Vector2(0, i * 40), editSize, tocolor(167, 167, 167), 1, font, 'center', 'center')
			else
				if i == 2 then
					drawText(string.rep('*', string.len(self.loginGuis[i].text)), editPos + Vector2(0, i * 40), editSize, tocolor(167, 167, 167), 1, font, 'center', 'center')
				else
					drawText(self.loginGuis[i].text, editPos + Vector2(0, i * 40), editSize, tocolor(167, 167, 167), 1, font, 'center', 'center')
				end
			end
			if isInSlot(editPos + Vector2(0, i * 40), editSize) then
				self.selectedbutton = i
				self.hovered = 'gui'
			end
		end
		local hovered = isInSlot(editPos + Vector2(0, self.loginBox * 40 + 40), editSize)
		if hovered then
			self.hovered = 'changelog'
		end
		changelogColor = hovered and {112, 152, 207, 255} or {112, 152, 207, 180}
		dxDrawRectangle(editPos + Vector2(0, self.loginBox * 40 + 40), editSize, tocolor(unpack(changelogColor))) -- changelog
		drawText('➔ Changelog megtekintése', editPos + Vector2(0, self.loginBox * 40 + 40), editSize, tocolor(255, 255, 255), 1, font, 'center', 'center')
	
		dxDrawRectangle(Vector2(sx / 2 - 480 / 2, sy / 2 + 135 / 2), Vector2(20, 20), tocolor(35, 35, 35)) -- changelog

		if isInSlot(Vector2(sx / 2 - 480 / 2, sy / 2 + 135 / 2), Vector2(20, 20)) then
			self.hovered = 'rememberpw'
		end

		drawText('Jelszó megjegyzése', editPos + Vector2(170, self.loginBox * 40 + 85), editSize - Vector2(500, 15), tocolor(255, 255, 255), 1, font, 'right', 'center')

		-- rememberpw

		if localPlayer:getData('char > rememberpw') == 0 then
			drawText('✘', Vector2(sx / 2 - 480 / 2, sy / 2 + 135 / 2), Vector2(20, 20), tocolor(255, 255, 255), 1, 'arial', 'center', 'center')
		elseif localPlayer:getData('char > rememberpw') == 1 then
			drawText('✔', Vector2(sx / 2 - 480 / 2, sy / 2 + 135 / 2), Vector2(20, 20), tocolor(255, 255, 255), 1, 'arial', 'center', 'center')
		end


	elseif page == 'changelog' then
		dxDrawRectangle(Vector2(self.editPos.x, sy / 2 - 100 / 2), self.editSize.x, 150, tocolor(25, 25, 25))
		for key, value in pairs(self.changelog) do

			drawText(value, Vector2(self.editPos.x + 10, sy / 2 - 200 / 2 + key * 20) - Vector2(0, 20), Vector2(self.editSize.x, 150), tocolor(255, 255, 255), 1, font, 'left', 'center', false, false, false, true)
			dxDrawRectangle(self.pos + Vector2(150, self.size.y + 5) - Vector2(140, 50), Vector2(130, 35), tocolor(112, 152, 207))
			drawText('Vissza', self.pos + Vector2(150, self.size.y + 5) - Vector2(140, 50), Vector2(130, 35), tocolor(255, 255, 255), 1, font, 'center', 'center')
		
			if isInSlot(self.pos + Vector2(150, self.size.y + 5) - Vector2(140, 50), Vector2(130, 35)) then
				self.hovered = 'changelogback'
			end
		end
	elseif page == 'register' then
		for i = 1, self.registerBox do
			dxDrawRectangle(editPos + Vector2(0, i * 40), editSize, tocolor(65, 65, 65, 255))
			if self.registerGuis[i].text == '' then
				drawText(self.registerGuiText[i], editPos + Vector2(0, i * 40), editSize, tocolor(255, 255, 255), 1, font, 'center', 'center')
			else
				if i == 2 or i == 3 then
					drawText(string.rep('*', string.len(self.registerGuis[i].text)), editPos + Vector2(0, i * 40), editSize, tocolor(255, 255, 255), 1, font, 'center', 'center')
				else
					drawText(self.registerGuis[i].text, editPos + Vector2(0, i * 40), editSize, tocolor(255, 255, 255), 1, font, 'center', 'center')
				end
			end
			if isInSlot(editPos + Vector2(0, i * 40), editSize) then
				self.hovered = 'gui'
				self.selectedbutton = i
			end
		end
	elseif page == 'charactercreate' then
		for i = 1, self.characterBox do
			-- outputChatBox('geci')
			dxDrawRectangle(editPos + Vector2(0, i * 40), editSize, tocolor(65, 65, 65, 255))
			if self.characterGuis[i].text == '' then
				drawText(self.characterText[i], editPos + Vector2(0, i * 40), editSize, tocolor(255, 255, 255), 1, font, 'center', 'center')

			else
				drawText(self.characterGuis[i].text, editPos + Vector2(0, i * 40), editSize, tocolor(255, 255, 255), 1, font, 'center', 'center')
			end

			if isInSlot(editPos + Vector2(0, i * 40), editSize) then
				self.hovered = 'charactergui'
				-- outputChatBox('geci')
				self.selectedbutton = i
				-- charactergui
			end
		end
		dxDrawRectangle(editPos + Vector2(0, 5 * 40), editSize, tocolor(112, 152, 207))
		drawText(self.characterGuis[1].text .. ' ' .. 'karakter létrehozása', editPos + Vector2(0, 5 * 40), editSize, tocolor(255, 255, 255), 1, font, 'center', 'center')
		-- outputChatBox('geci')
		-- characterbutton
		if isInSlot(editPos + Vector2(0, 5 * 40), editSize) then
			-- outputChatBox('Geci')
			self.hovered = 'characteracceptbutton'
		end
		-- outputChatBox('geci222222222')
	end
	-- LOGO, és szöveg {panel teteje, bal fent}
	local imageSize = Vector2(140, 140)
	dxDrawImage(self.pos - Vector2(20, 14), imageSize, 'files/small_logo.png')
	drawText('#000000' .. 'East' .. '#000000' .. ' MTA Las Venturas', self.pos - Vector2(61, 22) + Vector2(165, 0), imageSize, tocolor(0, 0, 0, 255), 1, font, 'right', 'center', false, false, false, true)
	drawText('#7098CF' .. 'East' .. '#FFFFFF' .. ' MTA Las Venturas', self.pos - Vector2(60, 21) + Vector2(165, 0), imageSize, tocolor(255, 255, 255, 255), 1, font, 'right', 'center', false, false, false, true)

	if page ~= 'changelog' then
		if page == 'charactercreate' then return end
		for i = 1, 2 do
			dxDrawRectangle(self.pos + Vector2(10 + i * 140, self.size.y + 8) - Vector2(140, 50), Vector2(130, 35), tocolor(112, 152, 207))
			drawText(self.loginButtonText[i], self.pos + Vector2(15 + i * 140, self.size.y + 8) - Vector2(140, 50), Vector2(130, 35), tocolor(255, 255, 255), 1, font, 'center', 'center')
			dxDrawImage(self.pos + Vector2(16 + i * 140, self.size.y + 17) - Vector2(140, 50), 16, 16, self.loginButtonPNG[i])
			if isInSlot(self.pos + Vector2(10 + i * 140, self.size.y + 8) - Vector2(140, 50), Vector2(130, 35)) then
				self.hovered = 'buttons'
				self.selectedbutton = i
			end
		end
	end

end
-- 
-- drawAnimation(1, 1)

function Panel:Click(button, state)
	if self.show and self.selectedbutton and self.hovered == 'gui' then
		if button == 'left' and state == 'down' then
			-- outputChatBox(self.selectedbutton)
			drawAnimation(self.selectedbutton, self.selectedbutton)
			if self.activePage == 'login' then
				self.loginGuis[self.selectedbutton]:bringToFront()
			elseif self.activePage == 'register' then
				self.registerGuis[self.selectedbutton]:bringToFront()
			end
		end
	end
end

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

function Panel:selectPage(button, state)
	if self.show and self.hovered == 'changelog' then
		-- outputChatBox('ez egy changelog geciiiii')
		self.activePage = self.hovered
		destroyAnimation()
	end
end

function Panel:changelogBack(button, state)
	if self.show and self.activePage == 'changelog' and self.hovered == 'changelogback' then
		self.activePage = 'login'
	end
end

addCommandHandler('teszt', function(cmd, username, password, email)
	if not username or not password or not email then return end
	triggerServerEvent('registeraccount > ml', localPlayer, localPlayer, username, password, email)
end)

function Panel:loginClick(button, state)
	if self.show and self.hovered == 'buttons' and self.selectedbutton == 1 then
		for key, value in pairs(self.loginGuis) do
			if value.text == '' then
				-- outputChatBox('A mezők kitöltése kötelező!')
				if clickTick + (5000) > getTickCount() then return end
				exports.ml_notification:addNotification('A mezők kitöltése kötelező!', 'warning')
				destroyAnimation()
				break
			else
				triggerServerEvent('loginaccount > ml', localPlayer, localPlayer, self.loginGuis[1].text, self.loginGuis[2].text)
				destroyAnimation()
			end
		end
	elseif self.show and self.hovered == 'buttons' and self.selectedbutton == 2 then
		for key, value in ipairs(self.registerGuis) do
			if value.text == '' then
				if clickTick + (5000) > getTickCount() then return end
				exports.ml_notification:addNotification('A mezők kitöltése kötelező!', 'warning')
				break
			else
				if self.registerGuis[2].text == self.registerGuis[3].text then
					if isValidMail(self.registerGuis[4].text) then
						triggerServerEvent('registeraccount > ml', localPlayer, localPlayer, self.registerGuis[1].text, self.registerGuis[2].text, self.registerGuis[4].text)
						break
					else
						exports.ml_notification:addNotification('Valós emailt adj meg!', 'warning')
						break
					end

				else
					exports.ml_notification:addNotification('A két jelszó nem egyezik!', 'warning')
					break
				end
			end
		end
	end
end

local tbl = {'login', 'register'}

function Panel:clickSelectPage(button, state)
	if self.show and self.hovered == 'buttons' then
		if button == 'left' and state == 'down' then
			if self.activePage ~= tbl[self.selectedbutton] then
				self.activePage = tbl[self.selectedbutton]
				outputChatBox(self.selectedbutton)
				destroyAnimation()
				for key, value in pairs(self.loginGuis) do
					clickTick = getTickCount()
					value.text = ''
				end
			end
		end
	end
end

function isValidMail( mail )
    assert( type( mail ) == "string", "Bad argument @ isValidMail [string expected, got " .. tostring( mail ) .. "]" )
    return mail:match( "[A-Za-z0-9%.%%%+%-]+@[A-Za-z0-9%.%%%+%-]+%.%w%w%w?%w?" ) ~= nil
end

addEvent('successlogin > ml', true)
addEventHandler('successlogin > ml', root, function(message)
	if message == 'login' then
		Camera.setMatrix(localPlayer.position)
		setCameraTarget(localPlayer)
		Panel:Close()
		localPlayer:setData('char > toghud', true)
		exports.ml_notification:addNotification('Sikeresen bejelentkeztél!', 'info')
		Camera.fade(true)
	elseif message == 'charactercreate' then
		-- outputChatBox('geci')
		Panel.activePage = 'charactercreate'
	end
end)

function Panel:CharacterBringToFront(button, state)
	if self.show and self.hovered == 'charactergui' and self.selectedbutton and self.activePage == 'charactercreate' then
		if button == 'left' and state == 'down' then
			self.characterGuis[self.selectedbutton]:bringToFront()
			-- outputChatBox('geci')
			drawAnimation(self.selectedbutton, self.selectedbutton)
		end
	end
end

function Panel:OrderCharacterClick(button, state)
	if self.show and self.hovered == 'characteracceptbutton' and self.activePage == 'charactercreate' then
		if button == 'left' and state == 'down' then
			for k, v in pairs(self.characterGuis) do
				if v.text == '' then
					return exports.ml_notification:addNotification('A mezők kitöltése kötelező!', 'warning')
				else
					triggerServerEvent('createcharacter > ml', localPlayer, localPlayer, self.characterGuis[1].text:gsub(' ', '_'), self.characterGuis[2].text, self.characterGuis[3].text, self.characterGuis[4].text)
					break
				end
			end
		end
	end
end

addEvent('panelCloseAndOpen', true)
addEventHandler('panelCloseAndOpen', root, function()
	-- Panel:Close()
	-- outputChatBox('bezárva')
	-- Panel:Open(true)
	outputChatBox('Sikeres karakter létrehozás!')
	Panel.activePage = 'login'
	for k, v in pairs(Panel.characterGuis) do
		v.text = ''
	end
end)

addEventHandler('onClientResourceStart', resourceRoot, function()
	triggerServerEvent('server > rememberdata', localPlayer, localPlayer)
end)

function Panel:rememberClickPw(button, state)
	if self.show and self.hovered == 'rememberpw' and self.activePage == 'login' then
		if button == 'left' and state == 'down' then
			if localPlayer:getData('char > rememberpw') == 0 then
				outputChatBox('geci')
				localPlayer:setData('char > rememberpw', 1)
				outputChatBox('1')
				triggerServerEvent('acceptClientRememberData', localPlayer, localPlayer, 1)
			elseif localPlayer:getData('char > rememberpw') == 1 then
				localPlayer:setData('char > rememberpw', 0)
				outputChatBox('0')
				triggerServerEvent('acceptClientRememberData', localPlayer, localPlayer, 0)
			end
		end
	end
end

addEvent('setguidata', true)
addEventHandler('setguidata', root, function(username, password)
	-- localPlayer:setData('char > rememberpw', 1)
	Panel.loginGuis[1].text = username
	Panel.loginGuis[2].text = password
end)

addEvent('setelementadatagui', true)
addEventHandler('setelementadatagui', root, function(ok)
	Timer(function()
		if ok == 1 then
			localPlayer:setData('char > rememberpw', 1)
		elseif ok == 2 then
			localPlayer:setData('char > rememberpw', 2)
		end
	end, 1000, 1)
end)

addEventHandler('onClientResourceStart', resourceRoot, function()
	if localPlayer:getData('char > loggedin') then return end
	Panel:Open(true)
	Camera.fade(true)
	Camera.setMatrix(961.17670, 2592.01147, 27.44864)
end)