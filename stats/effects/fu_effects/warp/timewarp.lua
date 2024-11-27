function init()
	if not world.entityType(entity.id()) then delayInit=true return end
	script.setUpdateDelta(1)
	self.worldData=self.worldData or {}
	self.worldData[world.type()]=true
	self.rescuePosition = mcontroller.position()
	self.resources={}
	self.lockedResources={}
	self.hidden=config.getParameter("effectHidden",false)
	self.numerals=config.getParameter("effectHasNumerals",false)

	local configuredResources=status.resourceNames() --root.assetJson("/player.config:statusControllerSettings.resources")
	for _,v in pairs(configuredResources) do
		self.resources[v]=status.resource(v)
		if status.resourceLocked(v) then self.lockedResources[v]=true end
	end
	self.facing=mcontroller.rotation()
	self.velocity={mcontroller.xVelocity(),mcontroller.yVelocity()}
	if animator.hasSound("timewarp_windup") then
		animator.playSound("timewarp_windup", -1)
	end
	if not self.hidden then
		effect.setParentDirectives("fade=6a2284=0.4")
		if self.numerals then
			self.numeralList={"n1","n2","n3","n4","n5","n6","n7","n8","n9","n10","n11","n12"}
			for _, numeral in ipairs(self.numeralList) do
				animator.setParticleEmitterOffsetRegion(numeral, mcontroller.boundBox())
				animator.setParticleEmitterBurstCount(numeral, 1)
			end

			self.particle_n=0
		end
	end
end

function update(dt)
	if delayInit then
		teleported=true
		delayInit=false
		effect.expire()
	end

	if self.numerals then
		if self.particle_n>=9 then --every 10 updates
			animator.burstParticleEmitter(self.numeralList[math.random(12)]) --play random numeral
			self.particle_n=0
		else
			self.particle_n=self.particle_n+1
		end
	end
end

function uninit()
	status.addEphemeralEffect("futimewarpcomplete")
	if teleported or (status.resource("health")<=0) then return end
	teleported=true
	for k,v in pairs(self.resources) do
		status.setResource(k,v)
		if self.lockedResources[k] then status.setResourceLocked(k,true) end
	end
	mcontroller.setPosition(self.rescuePosition)
	mcontroller.setRotation(self.facing)
	mcontroller.setVelocity(self.velocity)
end
