require "/stats/effects/fu_statusUtil.lua"

function init()
	self.tickDamagePercentage = config.getParameter("poisonPercent", 0.005)
	self.tickTime = config.getParameter("poisonSpeed", 2)
	self.tickTimer = self.tickTime

	local foodStats=config.getParameter("stats")
	if foodStats then
		effect.addStatModifierGroup(foodStats)
	end
	self.foodControlMods=config.getParameter("controlModifiers")

	script.setUpdateDelta(5)
end

function update(dt)
	self.tickTimer = self.tickTimer - dt
	if self.tickTimer <= 0 then
		self.tickTimer = self.tickTime
		status.applySelfDamageRequest({
			damageType = "IgnoresDef",
			damage = math.floor(status.resourceMax("health") * self.tickDamagePercentage) + 1,
			damageSourceKind = "poison",
			sourceEntityId = entity.id()
		})
		local modifierSet=self.foodControlMods or {}
		modifierSet.airJumpModifier=0.08
		modifierSet.speedModifier=0.08
		applyFilteredModifiers(modifierSet)
		effect.setParentDirectives("fade=806e4f="..self.tickTimer * 0.25)
		status.removeEphemeralEffect("wellfed")
		if status.resourcePercentage("food") > 0.85 then status.setResourcePercentage("food", 0.85) end
	else
		if self.foodControlMods then
			applyFilteredModifiers(self.foodControlMods)
		end
	end

end

function uninit()
	filterModifiers({},true)
end
