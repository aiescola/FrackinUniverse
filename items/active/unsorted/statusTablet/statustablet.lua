function activate(fireMode, shiftHeld)
	if shiftHeld then
	if fireMode == "primary" then 
			activeItem.interact("ScriptPane", "/zb/researchTree/data.config")
			animator.playSound("activate")
	elseif shiftHeld then
	if fireMode == "alt" then
			activeItem.interact("ScriptPane", "/interface/scripted/mmutility/mmutility.config")
			animator.playSound("activate3")
 
	elseif fireMode == "primary" then
		activeItem.interact("ScriptPane", "/interface/scripted/statWindow/statWindow.config")
		animator.playSound("activate")
	elseif fireMode == "alt" then
		activeItem.interact("ScriptPane", "/zb/questList/questList.config")
		animator.playSound("activate2")
    end

end


function update()
	if mcontroller.crouching() then
		activeItem.setArmAngle(-0.15)
	else
		activeItem.setArmAngle(-0.5)
	end
end
