--Script by LENNON (112, 152, 207) #7098CF

local sX, sY = guiGetScreenSize()
local sx, sy = guiGetScreenSize() --mert theMark (lennon: xddddd)
local zoom = math.min(1,sX / 1980);
setElementData(localPlayer, "char > toghud", true)

local components = { "weapon", "ammo", "health", "clock", "money", "breath", "armour", "wanted", "radio", "area_name", "radar", "vehicle_name" }

addEventHandler("onClientResourceStart", getResourceRootElement(getThisResource()),
function ()
	for _, component in ipairs( components ) do
		setPlayerHudComponentVisible( component, false )
	end
end)

res = function(value)
    return zoom * value;
end

resFont = function(value)
    return math.ceil(zoom * value);
end

local cPos = {};
local isEditing = false;
local moved = false;
local offsetX,offsetY = 0,0;
local cursorX, cursorY = -1,-1;
local resize = false;
local resizeHover = false;
local logoW, logoH = 140, 140
setCursorAlpha(255)

local font = dxCreateFont( "files/font.ttf", 10 )

local x,y = 26, 32+(18*getChatboxLayout()["chat_lines"]) --OOCchat

--datanév, x,y,szélesség,magasság, láthatóság(alapból ott e van), mozgatható/méretezhető, méretezhető/mozgatható határok pixelben
local widgets = {
	["hud"] = {sX/2 - 350/2 + 600, sY/2 - 60/2 - 400, 350, 80, "Karakter Adatok", true},
	["radar"] = {5,sY-220,200,200,"Radar (Méretzhető)",true,true,200,600},
    ['inventory'] = {sx / 2 - 300 / 2, sy / 2 - 300 / 2, 340 + 25, 175.5 + 35, 'Inventory', true},
    ['actionbar'] = {sx / 2 - 195 / 2 + 23.5, sy - 85 / 2, 195, 40, 'Action bar', true},
    ['speedo'] = { sX - 350, sY - 300, 250, 250, 'Kilóméteróra', true},
    ['fuel'] = { sX - 350 - 40, sy - 300 + 125, 20, 100, 'benzin', true},
    ['oil'] = { sX - 350 - 15, sY - 300 + 125, 20, 100, 'olaj', true},
    ['ooc'] = { x - 2, y - 23, 330, 180, 'OOC Chat', true},
}

function renderWidgetCustom()

	resizeHover = false;
    if isCursorShowing() then 
        cursorX, cursorY = getCursorPosition();
        cursorX, cursorY = cursorX * sX, cursorY * sY;
    else 
        isEditing = false;
        removeEventHandler("onClientRender",root,renderWidgetCustom);
        showChat(true);
        resize = false;
        resizeHover = false;
    end

    
    dxDrawRectangle(0,0,sX,sY,tocolor(0,0,0,150));
    dxDrawImage(sX/2 - logoW/2, sY/2 - logoH/2 + 30, logoW, logoH, "files/small_logo.png", 0, 0, 0, tocolor(255,255,255,255))
    dxDrawImage(sX/2 - logoW/2 - 10, sY/2 - logoH/2 + 40, 32, 32, "files/delete.png", 0, 0, 0, tocolor(255,255,255,255))
    dxDrawImage(sX/2 - logoW/2 + 120, sY/2 - logoH/2 + 40, 32, 32, "files/reset.png", 0, 0, 0, tocolor(255,255,255,255))
    dxDrawText("Interface #7098CFszemélyreszabás",0,-90,sX,sY,tocolor(255,255,255),1,font,"center","center", false, false, false, true);


    if resize then 
        local widget = cPos[resize[1]];
        if resize[2] == "width" then 
            local new = math.max(widget[8], math.min(widget[9], resize[4] + (cursorX -resize[3])));
            cPos[resize[1]][3] = new;
            setElementData(localPlayer,resize[1]..".w",new);
        elseif resize[2] == "height" then 
            local new = math.max(widget[8], math.min(widget[9], resize[4] + (cursorY -resize[3])));
            cPos[resize[1]][4] = new;
            setElementData(localPlayer,resize[1]..".h",new);
        end
    end

    for k,v in pairs(cPos) do 
        local x,y,w,h,name,showing,sizable,min,max = unpack(v);
        if showing then 
            if moved == k then 
                x,y = cursorX+offsetX,cursorY+offsetY;
                cPos[k] = {x,y,w,h,name,showing,sizable,min,max};
                setElementData(localPlayer,k..".x",x);
                setElementData(localPlayer,k..".y",y);
                setElementData(localPlayer,k..".w",w);
                setElementData(localPlayer,k..".h",h);
                setElementData(localPlayer,k..".name",name);
                setElementData(localPlayer,k..".showing",showing);
            end
            dxDrawRectangle(x,y,w,h,tocolor(112, 152, 207,200),true);

            if sizable and not resizeHover then 
                if exports.ml_core:isInSlot(x+w-10,y,10,h) then 
                    --shadowedText("Magasság",cursorX,cursorY,cursorX,cursorY,tocolor(255,255,255),1,font,"center","center");
                    dxDrawImage(cursorX,cursorY,16,16, "files/move.png", 0, 0, 0, tocolor(255,255,255,255))                   
                    resizeHover = k;
                elseif exports.ml_core:isInSlot(x,y+h-10,w,10) then 
                    if tostring(v[10]) == "nil" then 
                        --shadowedText("Szélesség",cursorX,cursorY,cursorX,cursorY,tocolor(255,255,255),1,font,"center","center");
                        dxDrawImage(cursorX,cursorY,16,16, "files/move.png", 0, 0, 0, tocolor(255,255,255,255))                        
                        resizeHover = k;                     
                    end
                end
            end

            if h >= 20 or w >= 200 then 
                dxDrawText(name,x,y,x+w,y+h,tocolor(255,255,255),1,font,"center","center",false,false,true,true);
            end
        end
    end

    local unused,count = getUnusedWidgets();
    if count > 0 then 
        dxDrawText("Widget #7098CFlista:",sX/4-270,10,sX/4-360+255,10+25,tocolor(255,255,255),1,font,"left","center", false, false, false, true);
        local a = 0;
        for k,v in pairs(unused) do 
            local x,y,w,h,name,showing = unpack(v);
            if not showing then 
                a = a + 1;
                local color = tocolor(112, 152, 207,200);
                local shadowed = false;
                if exports.ml_core:isInSlot(sX/4-380,25+(a*30),240,25) then 
                    color = tocolor(112, 152, 207,220);
                    shadowed = true;
                end                           
                dxDrawRectangle(sX/4-350,25+(a*30),240,25,color);
                dxDrawText(name,sX/4-370,25+(a*30),sX/4-330+240,15+(a*30)+35,tocolor(255,255,255),1,font,"center","center", false, false, false, true);
            end
        end
    end
end


addEventHandler("onClientKey",root,function(button,state)
if not getElementData(localPlayer,"char > loggedin") then return end;
if not isCursorShowing() then return end;
    if button == "lctrl" or button == "rctrl" and isCursorShowing() then 
        if state then 
            removeEventHandler("onClientRender",root,renderWidgetCustom);
            addEventHandler("onClientRender",root,renderWidgetCustom);
            isEditing = true;
            showChat(false);
            tick = getTickCount()
        else 
            isEditing = false;
            removeEventHandler("onClientRender",root,renderWidgetCustom);
            showChat(true);
            moved = false;
            offsetX,offsetY = 0,0;
            tick = getTickCount()
        end
    end
end);  

addEventHandler("onClientClick",root,function(button,state,posx,posy)
	if isEditing then
        if button == "left" and state == "down" then
            if not moved and not resize then 
                for k,v in pairs(cPos) do 
                    local x,y,w,h,name,showing, sizable = unpack(v);
                    if showing then 
                        if (sizable and exports.ml_core:isInSlot(x,y,w-10,h-10)) or (not sizable and exports.ml_core:isInSlot(x,y,w,h)) then  --mozgatás
                            moved = k;
                            offsetX,offsetY = x-posx,y-posy;
                            local click = playSound("files/click.mp3")
                            break;
                        end
                    end
                end
                if resizeHover then 
                    local widget = cPos[resizeHover];
                    if exports.ml_core:isInSlot(widget[1]+widget[3]-10,widget[2],10,widget[4]) then --méretezés
                        resize = {resizeHover,"width",posx,widget[3]};
                        setCursorAlpha(0)
                    elseif exports.ml_core:isInSlot(widget[1],widget[2]+widget[4]-10,widget[3],10) and tostring(widget[10]) == "nil" then
                        resize = {resizeHover,"height",posy,widget[4]};
                        setCursorAlpha(0)
                    end
                end
                local unused,count = getUnusedWidgets();
                local a = 0;
                for k,v in pairs(unused) do 
                    a = a + 1;
                    if exports.ml_core:isInSlot(sX/4-380,25+(a*30),240,25) then 
                        local x,y,w,h,name,showing = unpack(widgets[k]);
                        cPos[k][1] = x;
                        cPos[k][2] = y;
                        cPos[k][3] = w;
                        cPos[k][4] = h;
                        cPos[k][5] = name;
                        cPos[k][6] = true;
                        setElementData(localPlayer,k..".x",x);
                        setElementData(localPlayer,k..".y",y);
                        setElementData(localPlayer,k..".w",w);
                        setElementData(localPlayer,k..".h",h);
                        setElementData(localPlayer,k..".name",name);
                        setElementData(localPlayer,k..".showing",true);
                    end
                end
            end
        elseif button == "left" and state == "up" then 
            if moved then                            
                if exports.ml_core:isInSlot(sX/2 - logoW/2 + 120, sY/2 - logoH/2 + 40, 32, 32) then --alap pozicióba állítás
                    cPos[moved][1] = widgets[moved][1];
                    cPos[moved][2] = widgets[moved][2];
                    cPos[moved][3] = widgets[moved][3];
                    cPos[moved][4] = widgets[moved][4];
                    cPos[moved][5] = widgets[moved][5];
                    setElementData(localPlayer,moved..".x",widgets[moved][1]);
                    setElementData(localPlayer,moved..".y",widgets[moved][2]);
                    setElementData(localPlayer,moved..".w",widgets[moved][3]);
                    setElementData(localPlayer,moved..".h",widgets[moved][4]);
                    setElementData(localPlayer,moved..".name",widgets[moved][5]);
                    setElementData(localPlayer,moved..".showing",true);
                end 
                if exports.ml_core:isInSlot(sX/2 - logoW/2 - 10, sY/2 - logoH/2 + 40, 32, 32) then --törlés
                    if moved ~= "phone" then 
                        cPos[moved][6] = false;
                        setElementData(localPlayer,moved..".showing",false);
                    end
                end
                moved = false;
                offsetX,offsetY = 0,0;
            end
            if resize then 
                resize = false;
                setCursorAlpha(255)
            end
        end
    end
end);

--MENTÉSEK

function saveWidgets()
	if fileExists("ml_widgets.xml") then
		fileDelete("ml_widgets.xml");
	end
	local xmlNode = xmlCreateFile("ml_widgets.xml","root");
	for k,v in pairs(cPos) do 
		local m = xmlCreateChild(xmlNode,k);
		xmlNodeSetValue(xmlCreateChild(m,"x"),v[1]);
		xmlNodeSetValue(xmlCreateChild(m,"y"),v[2]);
		xmlNodeSetValue(xmlCreateChild(m,"w"),v[3]);
		xmlNodeSetValue(xmlCreateChild(m,"h"),v[4]);
		xmlNodeSetValue(xmlCreateChild(m,"show"),tostring(v[6]));
	end
	outputDebugString("WIDGET POZICIÓK MENTVE!",0,100,100,100);
	xmlSaveFile(xmlNode);
end
addEventHandler("onClientResourceStop",resourceRoot,saveWidgets);

function loadWidgets()
	local xmlNode = false;
	if fileExists("ml_widgets.xml") then 
		xmlNode = xmlLoadFile("ml_widgets.xml");
		for k,v in pairs(widgets) do 
			cPos[k] = {};
			local w = xmlFindChild(xmlNode,tostring(k),0);
			if w then 
				local x = xmlNodeGetValue(xmlFindChild(w,"x",0));
				local y = xmlNodeGetValue(xmlFindChild(w,"y",0));
				local ww = xmlNodeGetValue(xmlFindChild(w,"w",0));
				local h = xmlNodeGetValue(xmlFindChild(w,"h",0));
				local show = xmlNodeGetValue(xmlFindChild(w,"show",0));
				if show == "true" then 
					show = true;
				else 
					show = false;
                end
				cPos[k][1] = tonumber(x) or widgets[k][1];
				cPos[k][2] = tonumber(y) or widgets[k][2];
				cPos[k][3] = tonumber(ww) or widgets[k][3];
				cPos[k][4] = tonumber(h) or widgets[k][4];
				cPos[k][5] = widgets[k][5];
				cPos[k][6] = show;
				cPos[k][7] = widgets[k][7];
				cPos[k][8] = widgets[k][8];
				cPos[k][9] = widgets[k][9];
				cPos[k][10] = widgets[k][10];
			else 
				cPos[k] = widgets[k];
			end
		end
		for k,v in pairs(cPos) do
			local x,y,w,h,nev,show = unpack(v)
			setElementData(localPlayer, k .. ".x", x);
			setElementData(localPlayer, k .. ".y", y);
			setElementData(localPlayer, k .. ".w", w);
			setElementData(localPlayer, k .. ".h", h);	
			setElementData(localPlayer, k .. ".showing", show);	
		end
		outputDebugString("WIDGET POZICIÓK BETÖLVE!",0,100,100,100);
        xmlUnloadFile(xmlNode);
    else
        cPos = {};
        for k,v in pairs(widgets) do 
            local x,y,w,h,nev,show = unpack(v);
            cPos[k] = {x,y,w,h,nev,show};
            setElementData(localPlayer, k .. ".x", x);
			setElementData(localPlayer, k .. ".y", y);
			setElementData(localPlayer, k .. ".w", w);
			setElementData(localPlayer, k .. ".h", h);	
			setElementData(localPlayer, k .. ".showing", show);	
        end
	end
end
addEventHandler("onClientResourceStart", resourceRoot, loadWidgets);

--EGYÉB SZARSÁGOK

function getWidgetDatas(name)
    return unpack(cPos[name] or {});
end


function isWidgetShowing(name)
    if cPos[name] and cPos[name][6] then
    return cPos[name][6]
    end
    return false
end

function getUnusedWidgets()
    local table = {};
    local count = 0;
    for k,v in pairs(cPos) do 
        local x,y,w,h,name,showing = unpack(v);
        if not showing then 
            table[k] = {x,y,w,h,name,showing};
            count = count + 1;
        end
    end
    return table,count;
end

function shadowedText(text,x,y,w,h,color,fontsize,font,aligX,alignY)
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x,y+1,w,h+1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, true, true) 
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x,y-1,w,h-1,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, true, true)
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x-1,y,w-1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, true, true) 
    dxDrawText(text:gsub("#%x%x%x%x%x%x",""),x+1,y,w+1,h,tocolor(0,0,0,255),fontsize,font,aligX,alignY, false, false, true, true) 
    dxDrawText(text,x,y,w,h,color,fontsize,font,aligX,alignY, false, false, true, true)
end

function formatMoney(value)
    return value;
end

function dxDrawBorder(x, y, w, h, radius, color) 
    dxDrawRectangle(x - radius, y, radius, h, color)
    dxDrawRectangle(x + w, y, radius, h, color)
    dxDrawRectangle(x - radius, y - radius, w + (radius * 2), radius, color)
    dxDrawRectangle(x - radius, y + h, w + (radius * 2), radius, color)
end

addCommandHandler("resethud",function(command)
	cPos = {};
	moved = false;
	for k,v in pairs(widgets) do 
		cPos[k] = widgets[k];
	end
	for k,v in pairs(cPos) do
		local x,y,w,h,nev,show = unpack(v)
		setElementData(localPlayer, k .. ".x", x);
		setElementData(localPlayer, k .. ".y", y);
		setElementData(localPlayer, k .. ".w", w);
		setElementData(localPlayer, k .. ".h", h);	
		setElementData(localPlayer, k .. ".showing", show);	
	end
	outputChatBox("widgetreset",255,255,255,true);
end);

addCommandHandler("toghud", function()
    if getElementData(localPlayer, "char > toghud") == false then
        setElementData(localPlayer, "char > toghud", true)
        showChat(true)
    else
        setElementData(localPlayer, "char > toghud", false)
        showChat(false)
    end
end)