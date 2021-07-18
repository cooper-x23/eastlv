local ids = {}

function isIDFree(ID)
    if tonumber(ID) then
        for _, player in pairs(getElementsByType("player")) do
            if getElementData(player, "char > id") == ID then
                return false
            end
        end
        return true
    end
end

function setPlayerID(player)
    if isElement(player) then
        for i=1, getMaxPlayers(), 1 do
            if isIDFree(i) then
                setElementData(player, "char > id", i)
                break
            end
        end
    end
end

addEventHandler("onPlayerJoin", getRootElement(), function()
    setPlayerID(source)
end)

addEventHandler("onPlayerQuit", getRootElement(), function()
    setElementData(source, "char > id", false)
end)

addEventHandler("onResourceStart", resourceRoot, function()
    for _, player in pairs(getElementsByType("player")) do
        setElementData(player, "char > id", false)
        setPlayerID(player)
    end
end)

serverData = {
    ['version'] = "Alpha v0.1",
    ['mod'] = 'EastMTA Las Venturas',
    ['city'] = 'Las Venturas',
}

addEventHandler('onResourceStart', resourceRoot,
    function()

        setMapName(serverData['city'])
        setGameType(serverData['mod'] .. " " .. serverData['version'])
        setRuleValue('modversion', serverData['version'])
        
       
    end
)
