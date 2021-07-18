--Script by LENNON  (112, 152, 207) #7098CF

local skinMarker = createMarker(1544.5011, 856.3522, 5.8125, "cylinder", 1, 112, 152, 207,50)
setElementData(skinMarker, "skin > shopMarker", true)
setElementDimension(skinMarker, 0)
setElementInterior(skinMarker, 0)
local sX, sY = guiGetScreenSize()
local panelW, panelH = 300, 100
local panelX, panelY = sX/2 - panelW/2, sY/2 - panelH/2
local showSkinShop = false
local font = exports.ml_core:getFont("eastFont",10)
local selectedSkin = 0


function icon()
    local pPos = Vector3(getElementPosition(localPlayer));
    for k,v in pairs(getElementsByType("marker",resourceRoot)) do 
        if getElementData(v,"skin > shopMarker")  then 
            local oPos = Vector3(getElementPosition(v))
            if getDistanceBetweenPoints3D(pPos.x,pPos.y,pPos.z, oPos.x, oPos.y, oPos.z) < 15 then 
                local x,y = getScreenFromWorldPosition(oPos.x,oPos.y,oPos.z+1)
                if x and y then                              
                    dxDrawImage(x - 32,y - 50,64,64, "files/icon.png", 0, 0, 0, tocolor(20,20,20,200))
                end
            end
        end
    end
end
addEventHandler("onClientRender",root,icon)


addEventHandler("onClientRender", getRootElement(), function()
	if showSkinShop then
		dxDrawRectangle(panelX - 5, panelY + 250 - 5, panelW + 10, panelH + 10, tocolor(35,35,35,255))
	    dxDrawRectangle(panelX, panelY + 250, panelW, panelH, tocolor(20,20,20,255))
	    dxDrawImage(panelX + 120, panelY + 270, 64, 64, "files/icon.png", 0, 0, 0, tocolor(60,60,60,150))
	    centerText("East#7098CFMTA#ffffff - Ruhabolt", panelX, panelY + 250 - 35, panelW, panelH, tocolor(255,255,255,255), 1, font)
	    centerText("Skin váltás: #7098CFNyilak, #ffffffVásárlás: #7098CEEnter", panelX, panelY + 250, panelW, panelH, tocolor(255,255,255,255), 1, font)
	    centerText("Jelenlegi ruha: #7098CE"..selectedSkin.."#ffffff Ára: #7098CE$350", panelX, panelY + 250 + 35, panelW, panelH, tocolor(255,255,255,255), 1, font)
	end
end)

addEventHandler ( "onClientMarkerHit", getRootElement(), function(hitElement, dim)
	if hitElement == localPlayer and dim then
		if getElementData(source, "skin > shopMarker") and not isPedInVehicle(localPlayer) then
            showSkinShop = true
            toggleAllControls(false)
            selectedSkin = 1
            refreshSkin()
		end
	end
end)

addEventHandler ( "onClientMarkerLeave", getRootElement(), function(hitElement, dim)
	if hitElement == localPlayer and dim then
		if getElementData(source, "skin > shopMarker") then
			local getSkin = getElementData(localPlayer, "char > skin")
            showSkinShop = false
            toggleAllControls(true)
            setElementFrozen(localPlayer, false)
            setElementModel(localPlayer, getSkin)
		end
	end
end)

bindKey("backspace", "down", function()
	if showSkinShop then
		local getSkin = getElementData(localPlayer, "char > skin")
		showSkinShop = false
		setElementModel(localPlayer, getSkin)
		toggleAllControls(true)
		setElementFrozen(localPlayer, false)
	end
end)

bindKey("enter", "down",function()
	if showSkinShop then
		triggerServerEvent("skinShopBuy > ml", localPlayer, localPlayer, selectedSkin)
		local getSkin = getElementData(localPlayer, "char > skin")
		showSkinShop = false
		outputChatBox(selectedSkin)
		setElementModel(localPlayer, getSkin)
		toggleAllControls(true)
       	setElementFrozen(localPlayer, false)

	end
end)

bindKey("arrow_l", "down",function ()
	if showSkinShop then
		if selectedSkin > 1 then
			selectedSkin = selectedSkin -1 
			refreshSkin()
		end
	end
end)

bindKey("arrow_r", "down",function ()
	if showSkinShop then
		if selectedSkin < #skins then
			selectedSkin = selectedSkin + 1
			refreshSkin()
		end
	end
end)

function refreshSkin()
	setElementModel(localPlayer, skins[selectedSkin][2])
	--outputChatBox(skins[selectedSkin][2])
end


function centerText(text, x, y, w, h, color, fontS, font)
    dxDrawText(text, x+w/2, y+h/2, x+w/2, y+h/2, color, fontS, font, "center", "center", false, false, false, true)
end 

