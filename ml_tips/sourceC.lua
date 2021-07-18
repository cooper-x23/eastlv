--Script by LENNON (112, 152, 207) #7098CF
local tips = {
    [1] = {"Szükséged lenne koordinátákra? Használd a #7098CF/getpos#ffffff parancsot, vagy nyisd meg a #7098CFtérképed!"},
    [2] = {"Nehéz a tájékozódás? Használd a 3D Blip rendszerünket. #7098CF(/3dblips)"},
    [3] = {"Érdekelnek a legújabb fejlesztések? A bejelentkező felületen kattints a #7098CFCHANGELOG#ffffff gombra!"},
    [4] = {"Nem megfelelő a karaktered séta stílusa? Ird be a #7098CF/walk#ffffff vagy #7098CF/seta#ffffff parancsot!"},
};
local last = 0

function createTip()
    local rand = math.random(1,#tips);
    while (last==rand) do 
        createTip();
        return;
    end
    last = rand;
    outputChatBox("[➔ Tipp] #ffffff"..tips[rand][1],214, 208, 123 ,true);
end

setTimer(function()
    createTip();
end,1000*60*10,0)

createTip();
