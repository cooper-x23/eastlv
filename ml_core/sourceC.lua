fonts = {}
local fontsSource = {
	["eastFont"] = "files/font.ttf",
}

function getFont(font, size)
    local fontE = false
    
    if font and size then
	    local subText = font .. size
	    local value = fonts[subText]
	    if value then
		    fontE = value
		end
	end
    
    if not fontE then
		local v = fontsSource[font]
		fontE = dxCreateFont(v,size)
		local subText = font .. size 
		fonts[subText] = fontE
        outputDebugString("Font:" ..font.. " Méret: "..size.." létrehozva",0,100,100,100)
    end
    
	return fontE
end


bindKey("m", "down",
	function()
		showCursor(not isCursorShowing())
	end
)

function isInSlot(pX, pY, pW, pH)
	if not isCursorShowing() then
		return
	end
	local sX, sY = guiGetScreenSize()
	local cX, cY = getCursorPosition()
	cX, cY = cX * sX, cY * sY
	
	if (cX >= pX and cX <= pX + pW and cY >= pY and cY <= pY + pH) then
		return true
	else
		return false
	end
end

addEventHandler ("onClientPlayerDamage", getRootElement(),
	function()
		--if getElementData(source, "admin >> duty") then
			cancelEvent()
		--end
	end
)
 
addEventHandler("onClientPlayerStealthKill",localPlayer,
	function (targetPlayer)
		--if getElementData(targetPlayer,"admin >> duty") then
			cancelEvent()
		--end
	end
)


