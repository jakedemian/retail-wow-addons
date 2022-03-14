
do	
	local super=XPRACTICE.Spell
	XPRACTICE.TERROROFCASTLENATHRIA.Spell_BloodShroudTeleport=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.TERROROFCASTLENATHRIA.Spell_BloodShroudTeleport


	function class:SetCustomInfo()
		super.SetCustomInfo(self)

		self.name="Blood Shroud"
		self.icon="interface/icons/ability_priest_angelicfeather.blp"

		self.requiresfacing=false		
		self.projectileclass=nil	
		if(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.SkipBloodShroudIntro==false)then
			self.basecastduration=0.85
			self.basechannelduration=1.5
		else
			self.basecastduration=0.0
			self.basechannelduration=0.0
		end
		self.basechannelticks=1
		self.tickonchannelstart=false
		self.hidecastbar=true
	end
	

	function class:StartCastingEffect(spellinstancepointer)
		local shriekwing=spellinstancepointer.castercombat.mob
		shriekwing.orientation.yaw=math.atan2(-shriekwing.position.y,-shriekwing.position.x)
		--print(spellinstancepointer.castercombat.mob.displayobject.drawable:GetActiveBoundingBox())
		shriekwing.displayobject.customboundingbox={-5.65511,-4.20898,-0.75779,3.85328,3.95412,5.75733}		
		shriekwing.animationmodule:PlayAnimation(XPRACTICE.TERROROFCASTLENATHRIA.AnimationList.TeleportCast1)
		shriekwing.scenario.phaseinprogress=true
		local auras=shriekwing.scenario.player.combatmodule.auras:GetAurasByClassIfExist(XPRACTICE.TERROROFCASTLENATHRIA.Aura_Bloodlight)
		if(#auras>0)then
			local aura=auras[1]
			if(aura.stacks>1)then
				aura.stacks=1
			end
		end
	end
	function class:ChannelingAnimationFunction(spellinstancepointer)	
		spellinstancepointer.castercombat.mob.animationmodule:PlayAnimation(XPRACTICE.TERROROFCASTLENATHRIA.AnimationList.TeleportCast2)		
		local alpha=0.75-spellinstancepointer:GetChannelProgress()
		if(alpha<0)then alpha=0 end
		local shriekwing=spellinstancepointer.castercombat.mob
		shriekwing.alpha=alpha
	end
	function class:OnChannelTick(spellinstancepointer,tickcount)
		local shriekwing=spellinstancepointer.castercombat.mob
		shriekwing.alpha=1
		shriekwing.position={x=0,y=0,z=0.0001}		
		shriekwing.orientation.yaw=math.pi
		shriekwing.orientation_displayed.yaw=math.pi
		shriekwing.targetlocationindex=-1		-- -1 default (center)
		shriekwing.firstmovementlocationindex=0
		shriekwing.movementdirection=0
		shriekwing.automovessincereversedirection=0	-- only used by auto movement for endless intermission setting
		shriekwing.totalshrieks=0			
		shriekwing.scenario:ClickButtonAfterDelay(shriekwing.scenario.bloodshroudbutton,0.5)		
	end

end




do	
	local super=XPRACTICE.Spell
	XPRACTICE.TERROROFCASTLENATHRIA.Spell_BloodShroud=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.TERROROFCASTLENATHRIA.Spell_BloodShroud


	function class:SetCustomInfo()
		super.SetCustomInfo(self)

		self.name="Blood Shroud"
		self.icon="interface/icons/ability_deathwing_bloodcorruption_earth.blp"

		self.requiresfacing=false		
		self.projectileclass=nil	
		if(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.SkipBloodShroudIntro==false)then
			self.basecastduration=6.0
			self.basechannelduration=2.0
		else
			self.basecastduration=0.0
			--self.basechannelduration=0.0	-- sudden death if player is already standing in middle
			self.basechannelduration=0.5
		end
		self.basechannelticks=4
		self.tickonchannelstart=true
	end
	
	function class:CastingAnimationFunction(spellinstancepointer)	
		--spellinstancepointer.castercombat.mob.animationmodule:PlayAnimation(XPRACTICE.TERROROFCASTLENATHRIA.AnimationList.RoarCast)
		if(spellinstancepointer:GetCastProgress()<(5.5/6.0) and self.basecastduration>0.0)then
			spellinstancepointer.castercombat.mob.animationmodule:TryOmniChannel()
		else
			spellinstancepointer.castercombat.mob.animationmodule:PlayOrContinueAnimation(XPRACTICE.TERROROFCASTLENATHRIA.AnimationList.SpellCastOmni)
		end
	end
	-- function class:ChannelingAnimationFunction(spellinstancepointer)	
		-- -- do nothing
	-- end
	
	function class:StartCastingEffect(spellinstancepointer)
		local shriekwing=spellinstancepointer.castercombat.mob							
		if(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.SkipBloodShroudIntro==false)then
			local iconsize="20"
			local icon="\124Tinterface\\icons\\ability_deathwing_bloodcorruption_earth:"..iconsize.."\124t"
			local link="\124cffff0000\124Hspell:328921\124h[Blood Shroud]\124h\124r"			
			local message=icon.." Shriekwing begins to fade under the effects of "..link.."!"
			XPRACTICE_RaidBossEmote(message,5.0,true)
			
			local telegraph=XPRACTICE.TERROROFCASTLENATHRIA.BloodShroudTelegraph.new()					
			telegraph:Setup(shriekwing.environment,shriekwing.position.x,shriekwing.position.y,0.1)	
		end
	end
	
	-- function class:CompleteCastingEffect(castendtime,spellinstancepointer)	
		-- spellinstancepointer.castercombat.mob.animationmodule:PlayAnimation(XPRACTICE.TERROROFCASTLENATHRIA.AnimationList.SpellCastOmni)
	-- end
	
	
	function class:OnChannelTick(spellinstancepointer,tickcount)	
		local scenario=self.scenario
		local shriekwing=spellinstancepointer.castercombat.mob		
		if(tickcount==0)then
		--if(XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.SkipBloodShroudIntro==false)then				
			local nova=XPRACTICE.TERROROFCASTLENATHRIA.BloodShroudNova.new()					
			nova:Setup(shriekwing.environment,shriekwing.position.x,shriekwing.position.y,0.1)						
			if(scenario.player)then
				local loslines=scenario:GetShriekLOSLines(scenario.player)
				local safe=true
				for i=1,#loslines do	
					local collision=scenario:LOSLineCollisionTest(loslines[i])			
					if(not collision)then
						safe=false
					end
				end			
				if(not safe)then
					self:QuickKnockback(spellinstancepointer,scenario.player)
				end
			end
			if(scenario.lanternghost)then
				local loslines=scenario:GetShriekLOSLines(scenario.lanternghost)
				local safe=true
				for i=1,#loslines do	
					local collision=scenario:LOSLineCollisionTest(loslines[i])			
					if(not collision)then
						safe=false
					end
				end			
				if(not safe)then
					self:QuickKnockback(spellinstancepointer,scenario.lanternghost)
				end
			end
		--end
			spellinstancepointer.castercombat.mob.targetable=false
		elseif(tickcount==4)then				
			shriekwing.displayobject.customboundingbox=nil
			if(shriekwing.murderpreytelegraph==nil)then
			--if(shriekwing)then
				local murderpreytelegraph
				murderpreytelegraph=XPRACTICE.TERROROFCASTLENATHRIA.MurderPreyTelegraph.new()		
				murderpreytelegraph:Setup(shriekwing.environment)		
				murderpreytelegraph.position={x=0,y=0,z=0}
				murderpreytelegraph.shriekwing=shriekwing
				shriekwing.murderpreytelegraph=murderpreytelegraph
				shriekwing.scenario:ClickButtonAfterDelay(shriekwing.scenario.echoingsonarbutton,0.0)
				-- local queuepointer=self.scenario.spell_echoingsonar:NewQueue()
				-- queuepointer.castercombat=shriekwing.combatmodule
				-- local errorcode=shriekwing.combatmodule:TryQueue(queuepointer)			
			--end
			end
		end
	end
	
	function class:QuickKnockback(spellinstancepointer,target)		
		local shriekwing=spellinstancepointer.castercombat.mob
		local angle=math.atan2(target.position.y-shriekwing.position.y,target.position.x-shriekwing.position.x)
		target.velocity.x=math.cos(angle)*28
		target.velocity.y=math.sin(angle)*28
		target.velocity.z=8		
	end


end


do
	local super=XPRACTICE.WoWObject
	XPRACTICE.TERROROFCASTLENATHRIA.BloodShroudTelegraph=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.TERROROFCASTLENATHRIA.BloodShroudTelegraph

	function class:SetCustomInfo()
		super.SetCustomInfo(self)		
		self.scale=2
		--self.expirytime=self.environment.localtime+6.0
	end
	function class:SetActorAppearanceViaOwner(actor)						
		actor:SetModelByFileID(2128086) -- 8fx_taloc_falloff_blood	
	end
	function class:SetDefaultAnimation()
		self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.Projectile2SpawnCustomDuration)
		self.projectilespawncustomduration=3.0
		self.projectileloopcustomduration=3.5
		self.projectiledespawncustomduration=0.25
	end		
	--TODO LATER: find the model used in the center of telegraph
	-- function class:CreateAssociatedObjects()
		-- local shadow
		-- shadow=XPRACTICE.TERROROFCASTLENATHRIA.BloodShroudTelegraphShadow.new()
		-- shadow:Setup(self.environment,self.position.x,self.position.y,0)	
	-- end		
end

-- do
	-- local super=XPRACTICE.WoWObject
	-- XPRACTICE.TERROROFCASTLENATHRIA.BloodShroudTelegraphShadow=XPRACTICE.inheritsFrom(super)
	-- local class=XPRACTICE.TERROROFCASTLENATHRIA.BloodShroudTelegraphShadow

	-- function class:SetCustomInfo()
		-- super.SetCustomInfo(self)		
		-- self.scale=3
	-- end
	-- function class:SetActorAppearanceViaOwner(actor)						
		-- -- this is the wrong model, but we can't find the right one
		-- actor:SetModelByFileID(3642466) -- target_anima_revendreth_state_centeronly	
	-- end
	-- function class:SetDefaultAnimation()
		-- self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileSpawnCustomDuration)
		-- self.projectilespawncustomduration=0.25
		-- self.projectileloopcustomduration=5.75+0.5
		-- self.projectiledespawncustomduration=0.25
	-- end		
-- end

do
	local super=XPRACTICE.WoWObject
	XPRACTICE.TERROROFCASTLENATHRIA.BloodShroudNova=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.TERROROFCASTLENATHRIA.BloodShroudNova

	function class:SetCustomInfo()
		super.SetCustomInfo(self)		
		self.scale=1.3
		self.expirytime=self.environment.localtime+1.0
	end
	function class:SetActorAppearanceViaOwner(actor)				
		--this is probably not the correct model, but it's close enough
		--TODO: why isn't this visible at long distances?
		actor:SetModelByFileID(2066478) --8fx_uldir_bloodofghuun_contagion_novalarge		
	end
end





