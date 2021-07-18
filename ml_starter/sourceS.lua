local threadTimer
local threads = {}
local load_speed = 1000
local load_speed_multipler = 2
local canConnect = false

addEventHandler("onResourceStart", resourceRoot,
    function()
        for k, v in pairs(importantResources) do
            local res = getResourceFromName(k)
            if res then
                startResource(res)
                outputDebugString(k.. " resource elindítva! (Important Resource)", 0,100,100,100)
            end
        end   
        for k,v in pairs(normalResources) do
            resource = getResourceFromName(v[1])
            threads[resource] = true
        end       
        threadTimer = setTimer(
        function()
            local num = 0            
            for k,v in pairs(threads) do
                num = num + 1                   
                if num > load_speed_multipler then
                    break
                end                   
                startResource(k)                   
                threads[k] = nil                    
                outputDebugString(getResourceName(k).. " resource elinditva! (Normal Resource)", 0,100,100,100)
            end                
            local length = 0
            for k,v in pairs(threads) do length = length + 1 end
            if length == 0 then
                killTimer(threadTimer)
                outputDebugString("Összes Resource Elinditva!", 0,100,100,100)
                threadTimer = nil
                canConnect = true                   
                if getResourceState(getResourceFromName("ml_interface")) == "running" then 
                    restartResource(getResourceFromName("ml_interface")) 
                end                   
            end
        end, load_speed, 0
        )
    end
)

addEventHandler("onPlayerConnect", root,
    function()
        if not canConnect then
            cancelEvent(true, "Rendszer \n Nem tudsz felcsatlakozni amíg a mod nem tőlt be!")
        end
    end
)

addCommandHandler( "allres",function( thePlayer, command )
    for i, v in pairs(normalResources) do 
	    local resourceName = getResourceFromName(v[1])
        local state = getResourceState(resourceName)
        outputChatBox("Név: "..v[1].." | Állapot: "..state, thePlayer, 255,255,255,true)
    end

end)