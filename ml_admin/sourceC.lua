--Script by LENNON (112, 152, 207) #7098CF
local s = {guiGetScreenSize()}
local box = {420,210}
local pos = {s[1]/2 - box[1]/2,s[2]/1.9 - box[2]/2}
local showAdminPanel = false
local maxshow = 7
local scrollData = 0

function getOnlineAdmins()
	admins = 0
	for k,v in pairs(getElementsByType("player")) do
        local adminlevel = getElementData(v, "char > admin") or 0
        if adminlevel >= 1 then
        	admins = admins + 1
        	return admins
        end
    end
end


function adminHelpPanel()
    if not showAdminPanel then
         return
    end
    showAdminPanel = true
    local adminCount = getOnlineAdmins() or 0
        
    dxDrawRectangle(pos[1], pos[2], box[1], box[2], tocolor(65,65,65,255))
    dxDrawRectangle(pos[1], pos[2], box[1], 2, tocolor(112, 152, 207,255))
    dxDrawRectangle(pos[1], pos[2] + 210, box[1], 2, tocolor(112, 152, 207,255))
    shadowedText("Jelenleg elérhető #7098CFadminok#ffffff száma: #B05050"..adminCount.."", pos[1] + 5, pos[2] + 5 , 0,0, tocolor(255,255,255,255),1, "defaul-bold", "left", "top", false, false, false, true)

    local count = 0
    for k,v in pairs(getElementsByType("player")) do
        local adminlevel = getElementData(v, "char > admin") or 0
        local adminNick = getElementData(v, "char > adminnick") or "Ismeretlen Admin"
        local adminLevelName = exports.ml_core:getAdminRank(v) or "Hiba"
        local duty = getElementData(v, "char > adminduty") 
        local id = getElementData(v, "char > id") or 0
        
        if duty then
        	dutyStatus = "#A2C67DIgen"
        else
        	dutyStatus = "#B05050Nem"
        end
        if (k > scrollData and count < maxshow) then
	        if adminlevel >= 1 and adminCount > 0 then
	        count = count + 1
    	        dxDrawRectangle(pos[1], pos[2] + (count * 25), box[1], 20, tocolor(45,45,45,255))
    	       shadowedText("("..id ..") "..adminNick.." #7098CF("..adminLevelName..") #ffffffSzolgálatban: "..dutyStatus.."", pos[1]+5, pos[2] + 3 + (count * 25) , 0,0, tocolor(255,255,255,255),1, "defaul-bold", "left", "top", false, false, false, true)
            elseif adminCount == 0 then
            	dxDrawRectangle(pos[1], pos[2], box[1], 20, tocolor(45,45,45,255))
                shadowedText("Jelenleg nincs online adminisztrátor! Keresd fel őket a Discord szerverünkön!", pos[1] + 2, pos[2] + 3 + (count * 25) , 0,0, tocolor(255,255,255,255),1, "defaul-bold", "left", "top", false, false, false, true)
	        end
	    end
    end
    --for k,v in ipairs(commands) do 
    	--if (k > scrollData and count < maxshow) then
    		--count = count + 1
    		--dxDrawRectangle(pos[1], pos[2] + (count * 25), box[1], 20, tocolor(45,45,45,255))
            --dxDrawText(v[1], pos[1]+5, pos[2] + 3 + (count * 25) , 0,0, tocolor(255,255,255,255),1, "defaul-bold", "left", "top", false, false, false, true)
     
        --end
    --end
end
addEventHandler("onClientRender", getRootElement(),adminHelpPanel)

addCommandHandler("admins",
function()
    showAdminPanel = not showAdminPanel
end)

bindKey("mouse_wheel_down", "down", 
function() 
    if showAdminPanel then
        if scrollData < #getElementsByType("player") - maxshow then
            scrollData = scrollData + 1       
        end
    end
end)


bindKey("mouse_wheel_up", "down", 
function() 
    if showAdminPanel then
        if scrollData > 0 then
            scrollData = scrollData - 1       
        end
    end
end)

function fly()
	if getElementData(localPlayer, "char > admin") >= 3 then
	    triggerEvent("onClientFlyToggle",localPlayer)
	end
end
addCommandHandler("fly",fly,false,false)

addCommandHandler("getpos", 
	function()
    local x,y,z = getElementPosition(localPlayer)
    outputChatBox("[Pozíció]: #ffffffXYZ: #6a6a6a"..math.round(x, 4)..", "..math.round(y, 4)..", "..math.round(z, 4).."#7098CF (Kimásolva vágólapra)", 112, 152, 207, true)
    local copy = setClipboard(math.round(x, 4)..", "..math.round(y, 4)..", "..math.round(z, 4))
end
)

function math.round(number, decimals, method)
    decimals = decimals or 0
    local factor = 8 ^ decimals
    if (method == "ceil" or method == "floor") then return math[method](number * factor) / factor
    else return tonumber(("%."..decimals.."f"):format(number)) end
end

function shadowedText(text,x,y,w,h,color,fontsize,font,aligX,alignY,a,b,c,d,rot)
	if not a then a = false end;
	if not b then b = false end;
	if not c then c = false end;
    if not d then d = true end;
    if not rot then rot = 0 end;
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x,y+1,w,h+1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, a,b,c,d,false,rot) 
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x,y-1,w,h-1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, a,b,c,d,false,rot)
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x-1,y,w-1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, a,b,c,d,false,rot) 
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x+1,y,w+1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, a,b,c,d,false,rot) 
    dxDrawText(text,x,y,w,h,color,fontsize,font,aligX,alignY, a,b,c,d,false,rot)
end

