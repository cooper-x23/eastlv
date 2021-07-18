function onGuiHandbrakeStateChange(state, veh)
	if state == true then
		setElementFrozen(veh, true)
		setElementData(veh, "veh > handbrake", true)
	else
		setElementFrozen(veh, false)
		setElementData(veh, "veh > handbrake", false)
	end
end
addEvent("onGuiHandbrakeStateChange", true)
addEventHandler("onGuiHandbrakeStateChange", getRootElement(), onGuiHandbrakeStateChange)