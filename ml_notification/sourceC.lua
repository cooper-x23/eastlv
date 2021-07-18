--Script by LENNON

local displayWidth, displayHeight = guiGetScreenSize();
local notificationData = {};
local font = dxCreateFont('files/Roboto.ttf', 10 , false);

addEventHandler('onClientRender', root,
	function()
		for k, v in pairs(notificationData) do
			if (v.State == 'fadeIn') then
				local alphaProgress = (getTickCount() - v.AlphaTick) / 650;
				local alphaAnimation = interpolateBetween(0, 0, 0, 255, 0, 0, alphaProgress, 'InOutBack');
				
				if (alphaAnimation) then
					v.Alpha = alphaAnimation;
				else
					v.Alpha = 255;
				end
				
				if (alphaProgress > 1) then
					v.Tick = getTickCount();
					v.State = 'openTile';
				end
			elseif (v.State == 'fadeOut') then
				local alphaProgress = (getTickCount() - v.AlphaTick) / 650;
				local alphaAnimation = interpolateBetween(255, 0, 0, 0, 0, 0, alphaProgress, 'InOutBack');
				
				if (alphaAnimation) then
					v.Alpha = alphaAnimation;
				else
					v.Alpha = 0;
				end
				
				if (alphaProgress > 1) then
					notificationData = {};
				end
			elseif (v.State == 'openTile') then
				local tileProgress = (getTickCount() - v.Tick) / 1350;
				local tilePosition = interpolateBetween(v.StartX, 0, 0, v.EndX, 0, 0, tileProgress, 'OutElastic');
				local tileWidth = interpolateBetween(0, 0, 0, v.Width, 0, 0, tileProgress, 'OutElastic');
				
				if (tilePosition and tileWidth) then
					v.CurrentX = tilePosition;
					v.CurrentWidth = tileWidth;
				else
					v.CurrentX = v.EndX;
					v.CurrentWidth = v.Width;
				end
				
				if (tileProgress > 1) then
					v.State = 'fixTile';
					
					setTimer(function()
						v.Tick = getTickCount();
						v.State = 'closeTile';
					end, 3000, 1);
				end
			elseif (v.State == 'closeTile') then
				local tileProgress = (getTickCount() - v.Tick) / 1350;
				local tilePosition = interpolateBetween(v.EndX, 0, 0, v.StartX, 0, 0, tileProgress, 'InOutBack');
				local tileWidth = interpolateBetween(v.Width, 0, 0, 0, 0, 0, tileProgress, 'InOutBack');
				
				if (tilePosition and tileWidth) then
					v.CurrentX = tilePosition;
					v.CurrentWidth = tileWidth;
				else
					v.CurrentX = v.StartX;
					v.CurrentWidth = 0;
				end
				
				if (tileProgress > 1) then
					v.AlphaTick = getTickCount();
					v.State = 'fadeOut';
				end
			elseif (v.State == 'fixTile') then
				v.Alpha = 255;
				v.CurrentX = v.EndX;
				v.CurrentWidth = v.Width ;
			end

			now = getTickCount()
            local yANIM, alpha = interpolateBetween(-5, 0, 0, 20, 255, 0, now / 2000, "CosineCurve")
            local p = ( getTickCount() - tick ) / 1200
            local pANIM = interpolateBetween(0, 0, 0, 255, 255, 255, p, "Linear", pANIM)
			
			dxDrawRectangle(v.CurrentX, 20, 25 + v.CurrentWidth, 25, tocolor(65,65,65, 255), _, true);
			--dxCreateBorder(v.CurrentX, 20, 25 + v.CurrentWidth, 25, tocolor(0, 0, 0, 255), _, true);

			dxDrawRectangle(v.CurrentX + 2, 20 + 2, 26 - 4, 25 - 4, tocolor(112, 152, 207, pANIM), _, true);
			dxDrawImage(v.CurrentX + 5, 24, 16, 16, image, 0, 0, 0, tocolor(255, 255, 255, alpha))
			
			if (v.Alpha == 255) then				
				--dxDrawText(v.Text, v.CurrentX + 26 + 10, 20, v.CurrentX + 26 + 10 + v.CurrentWidth - 20, 20 + 25, tocolor(0, 0, 0, 255), 1, font, 'center', 'center', true, false, true); -- szöveg + 26 + 10
				dxDrawText(v.Text, v.CurrentX + 25 + 10, 20, v.CurrentX + 25 + 10 + v.CurrentWidth - 20, 20 + 25, tocolor(255, 255, 255, 255), 1, font, 'center', 'center', true, false, true); -- szöveg
			end
		end
	end
)

function addNotification(text, type)
	if (text and type) then
		if (notificationData ~= nil) then
			table.remove(notificationData, #notificationData);
		end

		tick = getTickCount()
		
		table.insert(notificationData,
			{
				StartX = (displayWidth / 2) - (20 / 2),
				EndX = (displayWidth / 2) - ((dxGetTextWidth(text, 1.0, font) + 20 + 25) / 2),
				Text = text,
				Width = dxGetTextWidth(text, 1.0, font) + 20,
				Alpha = 0,
				State = 'fadeIn',
				Tick = 0,
				AlphaTick = getTickCount(),
				CurrentX = (displayWidth / 2) - (20 / 2),
				CurrentWidth = 0,
				Type = type or 'info'
			}
		);
		if type == "info" then
			playSound("files/effect.mp3")
			image = "files/icon.png"
		elseif type == "warning" then
			playSound("files/effect.mp3")
			image = "files/warning.png"
		elseif type == "admin" then
			playSound("files/effect.mp3")
			image = "files/admin.png"
		end
	end
end
addEvent("notification",true)
addEventHandler("notification",root,addNotification)

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

function dxCreateBorder(x,y,w,h,color)
	dxDrawRectangle(x,y,w+1,1,color) 
	dxDrawRectangle(x,y+1,1,h,color) 
	dxDrawRectangle(x+1,y+h,w,1,color) 
	dxDrawRectangle(x+w,y+1,1,h,color)
end