do	
	local super=XPRACTICE.Spell
	XPRACTICE.TERROROFCASTLENATHRIA.Spell_EchoingSonar=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.TERROROFCASTLENATHRIA.Spell_EchoingSonar


	function class:SetCustomInfo()
		super.SetCustomInfo(self)

		self.name="Echoing Sonar"
		self.icon="interface/icons/spell_nature_wispsplode.blp"

		self.requiresfacing=false		
		self.projectileclass=nil		
		self.basecastduration=0.000
		self.basechannelduration=1.000 * (6+XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.ExtraSonarWaves)
		self.basechannelticks=(6+XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.ExtraSonarWaves)
		self.tickonchannelstart=false
		self.usablewhilemoving=true
		self.firingangle=0
	end
	
	function class:CastingAnimationFunction(spellinstancepointer)
		spellinstancepointer.castercombat.mob.animationmodule:TryDirectedChannel()
	end
	
	function class:ChannelingAnimationFunction(spellinstancepointer)
		spellinstancepointer.castercombat.mob.animationmodule:TryDirectedChannel()
	end
		

	
	function class:CompleteCastingEffect(castendtime,spellinstancepointer)
		self.firingangle=math.random()*(math.pi*2)
	end
	
	function class:OnChannelTick(spellinstancepointer,tickcount)
		--print("EchoingSonar tick",tickcount)
		--local angle=self.firingangle+(tickcount-1)*math.pi*2/6
		--local angle=self.firingangle+(tickcount-1)*math.pi*2/12
		--local angle=self.firingangle+(tickcount-1)*math.pi*2/18
		--self.firingangle=self.firingangle+math.pi*0.125*math.random()
		self.firingangle=self.firingangle+math.pi*2/18
		local angle=self.firingangle
		local pos=spellinstancepointer.castercombat.mob.position
		
		--if(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.Difficulty==1)then
		if(false)then
			self.scenario:Quick4Sonar(pos.x,pos.y,pos.z,angle)
		else
			self.scenario:QuickRandom5Sonar(pos.x,pos.y,pos.z,angle)
		end
	end
	
	function class:CompleteChannelingEffect(castendtime,spellinstancepointer)
		self.scenario:ClickButtonAfterDelay(self.scenario.moveshriekwingbutton,2.0)
	end
end


do
	local super=XPRACTICE.WoWObject
	XPRACTICE.TERROROFCASTLENATHRIA.EchoingSonarProjectile=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.TERROROFCASTLENATHRIA.EchoingSonarProjectile

	function class:SetCustomInfo()
		super.SetCustomInfo(self)
		--self.scale=1
		local scalemodifier=1+XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.EchoingSonarProjectileSize*XPRACTICE.Config.Shriekwing.SonarSavedataSizeMultiplier
		self.scale=XPRACTICE.Config.Shriekwing.SonarScale*scalemodifier
		--print("Scale",self.scale)
		if(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.Difficulty==1)then
			self.scale=self.scale*XPRACTICE.Config.Shriekwing.SonarHeroicScaleMultiplier
		end
		--self.scale=0.8
		--self.scale=0.5
		--self.basemovespeed=14.0
		local speedmodifier=1+(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.EchoingSonarProjectileSpeed*0.25)
		self.basemovespeed=XPRACTICE.Config.Shriekwing.SonarSpeed*speedmodifier
		--self.basemovespeed=7.0*0.9		
		--self.basemovespeed=7.0*0.8
		--self.basemovespeed=7.0*.5		
		

		-- Square pillar collision is no longer used.
		self.PILLARSQUARECOLLISION=false	
		
		self.cruelcooldownremaining=0

		self.nextghosttime=0		
	end
	function class:SetActorAppearanceViaOwner(actor)
		--actor:SetModelByCreatureDisplayID(89415)	-- Voidspawn Annihilator
		actor:SetModelByFileID(3621935) --9fx_raid1_gargoylebat_sonicwave_missile
		--actor:SetModelByFileID(3621938) --9fx_raid1_gargoylebat_sonicwave_nova_raidlow
		--actor:SetModelByFileID(3621932) --9fx_raid1_gargoylebat_sonicwave_impact
		--actor:SetModelByFileID(3670323) --9fx_raid1_dredgerbrute_pillarexplosion_explosion		
	end
	---- at some point between beta and live, the missile graphic gained an extra-large circle around it.
	---- there doesn't appear to be a way to remove it.  :(
	-- function class:SetDefaultAnimation()
		-- self.animationmodule:PlayAnimation(XPRACTICE.TERROROFCASTLENATHRIA.AnimationList.InFlight)
	-- end		

	function class:Step(elapsed)
		super.Step(self,elapsed)
		local yaw=self.orientation.yaw
		self.velocity={x=math.cos(yaw)*self.basemovespeed,y=math.sin(yaw)*self.basemovespeed,z=0}		
		
		if(self.cruelcooldownremaining>0)then
			self.cruelcooldownremaining=self.cruelcooldownremaining-elapsed
			if(self.cruelcooldownremaining<=0)then
				self.cruelcooldownremaining=0
			end
		end
		
		local scalemodifier=1+XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.EchoingSonarProjectileSize*0.25
		--print("Scalemodifier",scalemodifier)
		
		----CIRCLE-BASED COLLISION DETECTION
		if(self.PILLARSQUARECOLLISION==false)then			
			local RADIUS=XPRACTICE.Config.Shriekwing.PillarRoughCollisionRadius
				+ XPRACTICE.Config.Shriekwing.SonarObjectCollisionRadius*scalemodifier
			for i=1,#self.scenario.pillars do						
				local pillar=self.scenario.pillars[i]
				local xdist=(pillar.position.x-self.position.x)
				local ydist=(pillar.position.y-self.position.y)
				local distsqr=xdist*xdist+ydist*ydist
				if(distsqr<RADIUS*RADIUS) then
					local normal2d=math.atan2(-ydist,-xdist)
					local dist=math.sqrt(distsqr)
					self:Bounce(normal2d,RADIUS,dist)
				end
			end
		end
		----CORNER-BASED COLLISION DETECTION (same as circles)
		local RADIUS=XPRACTICE.Config.Shriekwing.SonarObjectCollisionRadius*scalemodifier
		for i=1,#self.scenario.outsidecorners do
			local outsidecorner=self.scenario.outsidecorners[i]
			if(self.PILLARSQUARECOLLISION or outsidecorner.linetype==XPRACTICE.TERROROFCASTLENATHRIA.LINETYPE.WALL)then
				local xdist=(outsidecorner.position.x-self.position.x)
				local ydist=(outsidecorner.position.y-self.position.y)
				local distsqr=xdist*xdist+ydist*ydist
				if(distsqr<RADIUS*RADIUS) then					
					local normal2d=math.atan2(-ydist,-xdist)
					local dist=math.sqrt(distsqr)
					self:Bounce(normal2d,RADIUS,dist)
				end
			end
		end		
		----LINE-BASED COLLISION DETECTION
		local RADIUS=XPRACTICE.Config.Shriekwing.SonarObjectCollisionRadius*scalemodifier
		for i=1,#self.scenario.lines do
			local line=self.scenario.lines[i]
			if(self.PILLARSQUARECOLLISION or line.linetype==XPRACTICE.TERROROFCASTLENATHRIA.LINETYPE.WALL)then
				local distsqr=XPRACTICE.PointLineDistSqr(self.position.x,self.position.y,line.linesegment.x1,line.linesegment.y1,line.linesegment.x2,line.linesegment.y2)
				if(distsqr<RADIUS*RADIUS) then
					local yaw=self.orientation.yaw					
					local dist=math.sqrt(distsqr)
					self:Bounce(line.normal2d,RADIUS,dist)							
				end
			end
		end
	end

	function class:Bounce(normal,RADIUS,dist)
		local yaw=self.orientation.yaw
		local difference=XPRACTICE.AngleDifference(yaw,normal)		
		if(math.abs(difference)>math.pi/2)then
			local adjustment=RADIUS-dist
			self.position.x=self.position.x+math.cos(normal)*adjustment
			self.position.y=self.position.y+math.sin(normal)*adjustment						
			local newangle=self:CheckCruelty()			
			if(not newangle)then
				newangle=self:GetBounceAngle(normal,difference)
			end
			self.orientation.yaw=newangle
		end	
	end

	function class:CheckToggleCollisionType()
		-- if(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.PillarCollisionStyle>=3)then
			-- if(math.random()>.5)then self.PILLARSQUARECOLLISION=false else self.PILLARSQUARECOLLISION=true end
		-- end
	end
	function class:GetBounceAngle(normal2d,difference)
		local defaultangle=normal2d+(math.pi-difference)
		if(not (XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.PillarCollisionStyle>=2))then return defaultangle end
		--local maxrandomness=math.pi*(3/16)
		local maxrandomness=math.pi*(4/16)
		local randomdiff=((math.random()-0.5)*2)*maxrandomness
		local randomangle=defaultangle+randomdiff		
		local normaldiff=math.abs(normal2d-randomangle)
		if(normaldiff>math.pi/2)then
			return defaultangle	
		end
		--print(randomdiff)
		return randomangle
	end
	
	function class:CheckCruelty()
		--returns nil if not cruel, or cruelangle if cruel.
		if(self.cruelcooldownremaining>0)then return nil end
		if(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.PillarCollisionStyle~=3)then return nil end		
		if(math.random()>=XPRACTICE.Config.Shriekwing.CrueltyRate)then return nil end
		local scenario=self.scenario
		local player=scenario.player
		if(not player)then return nil end
		if(player:IsDeadInGame())then return nil end
		
		
		--TODO: also line circle collision against pillars?
		--TODO: check if lines are pillars or walls?
		for i=1,#self.scenario.lines do
			local line=self.scenario.lines[i]
			if(self.PILLARSQUARECOLLISION or line.linetype==XPRACTICE.TERROROFCASTLENATHRIA.LINETYPE.WALL)then
				if(XPRACTICE.LineLineIntersection(self.position.x,self.position.y,player.position.x,player.position.y,
				line.linesegment.x1,line.linesegment.y1,line.linesegment.x2,line.linesegment.y2))then
					return nil
				end
			end
		end
		if(not self.PILLARSQUARECOLLISION)then
			for i=1,#self.scenario.pillars do										
				local pillar=self.scenario.pillars[i]
				local distsqr=XPRACTICE.PointLineDistSqr(pillar.position.x,pillar.position.y,self.position.x,self.position.y,player.position.x,player.position.y)
				local RADIUS=XPRACTICE.Config.Shriekwing.PillarRoughCollisionRadius
				if(distsqr<RADIUS*RADIUS) then
					return nil
				end
			end	
		end
		
		local cruelangle=math.atan2(player.position.y-self.position.y,player.position.x-self.position.x)
		--print(cruelangle)
		-- cooldown helps prevent weird things from happening if projectile gets caught on the edge of a pillar
		self.cruelcooldownremaining=3.0
		return cruelangle
	end
	
	
	
end