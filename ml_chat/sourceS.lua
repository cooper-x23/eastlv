addEventHandler("onPlayerChat", getRootElement(), function(message, msgType)
	cancelEvent()
	if msgType == 0 then
		setElementData(source, "onClientSendICMessage", message)
	end
end)


addEventHandler("onPlayerQuit", getRootElement(), function(message) setElementData(source, "onClientQuit", message) end)

-- /me
addEventHandler("onPlayerChat", getRootElement(), function(message, msgType)
	cancelEvent()
	if msgType == 1 then
		--setElementData(source, "onClientSendMeMessage", message)
	end
end)

addEvent("onClientServerApplyAnimation",true)
addEventHandler("onClientServerApplyAnimation",getRootElement(),
	function(v)
		setPedAnimation(v, "DEALER", "shop_pay", 3000, false, true, true, false)
	end
)
