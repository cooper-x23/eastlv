function addNotification(player,text,type)
	if player and text and type then 
		triggerClientEvent(player,"notification",player,text,type)
	end
end

addCommandHandler("infob",
    function()
    	exports.ml_notification:addNotification(getRootElement(),"Szia lajos! Szia bazdmeg.","info")

    end
)

addCommandHandler("warnb",
    function()
    	exports.ml_notification:addNotification(getRootElement(),"ez lesz a figyelmeztetős infobox teszteljük le","warning")

    end
)

addCommandHandler("adminb",
    function()
    	exports.ml_notification:addNotification(getRootElement(),"ez az adminduty infobox teszteljük le","admin")

    end
)


