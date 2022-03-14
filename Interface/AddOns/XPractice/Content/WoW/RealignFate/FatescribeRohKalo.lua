do

	XPRACTICE.FATESCRIBEMULTIPLAYER.AnimationList={}
	----XPRACTICE.AnimationTemplate.QuickSetup(animationlist,			name,		index,	subindex,	priority,	duration,	nextanimation)
	XPRACTICE.AnimationTemplate.QuickSetup(XPRACTICE.FATESCRIBEMULTIPLAYER.AnimationList,"HeightChangeWalk",4,	0,			"Active",	0.25,		nil)
	XPRACTICE.AnimationTemplate.QuickSetup(XPRACTICE.FATESCRIBEMULTIPLAYER.AnimationList,"HeightChangeRun",5,	0,			"Active",	0.25,		nil)

	--TODO: use less duct tape!
	XPRACTICE.AnimationTemplate.QuickSetup(XPRACTICE.FATESCRIBEMULTIPLAYER.AnimationList,"ProjectileDespawnCustomDuration",215,	0,		"Idle",		nil,nil)
	XPRACTICE.AnimationTemplate.QuickSetup(XPRACTICE.FATESCRIBEMULTIPLAYER.AnimationList,"ProjectileLoopCustomDuration",214,	0,			"Idle",		nil,XPRACTICE.FATESCRIBEMULTIPLAYER.AnimationList.ProjectileDespawnCustomDuration)
	XPRACTICE.AnimationTemplate.QuickSetup(XPRACTICE.FATESCRIBEMULTIPLAYER.AnimationList,"ProjectileSpawnCustomDuration",213,	0,			"Idle",		nil,XPRACTICE.FATESCRIBEMULTIPLAYER.AnimationList.ProjectileLoopCustomDuration)


	do		
		local super=XPRACTICE.Mob
		XPRACTICE.FATESCRIBEMULTIPLAYER.FatescribeRohKalo=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.FATESCRIBEMULTIPLAYER.FatescribeRohKalo
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			--self.alivetime=0
			--self.state=0
			self.gravity=0
			self.maxheight=7
			self.targetheight=0					
			self.basemovespeed=14
			self.defaultspeechbubbleduration=4.0
		end

		function class:SetActorAppearanceViaOwner(actor)
			--actor:SetModelByCreatureDisplayID(100911) --?
			actor:SetModelByCreatureDisplayID(101528) --Fatescribe Roh-Kalo (mawinquisitorboss.m2)

			self.scale=3
			self.displayedpositionoffset={x=13,y=0,z=0}
		end
		
		function class:SetDisplayObjectCustomBoundingBoxViaOwner(displayobject)
			local radius=1
			local base=0.25
			local height=4.0
			displayobject.customboundingbox={-radius,-radius,base,radius,radius,base+height}
		end
		
		function class:CreateCombatModule()
			super.CreateCombatModule(self)
			local spell_rfcosmetic=XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_RealignFateCosmetic.new()
			spell_rfcosmetic:Setup(self.combatmodule)
			self.combatmodule.spellbook.spell_rfcosmetic=spell_rfcosmetic
		end			

		
		function class:Step(elapsed)
			super.Step(self,elapsed)

			if(self.velocity.z>0)then
				if(self.position.z>=self.targetheight)then self.velocity.z=0;self.position.z=self.targetheight end
			elseif(self.velocity.z<0)then
				if(self.position.z<=0)then self.velocity.z=0;self.position.z=0 end
			end
			if(self.position.z<self.targetheight)then
				self.velocity.z=14.0				
				self.animationmodule:PlayAnimation(XPRACTICE.FATESCRIBEMULTIPLAYER.AnimationList.HeightChangeRun)
			elseif(self.position.z>self.targetheight)then
				self.velocity.z=-7.0
				self.animationmodule:PlayAnimation(XPRACTICE.FATESCRIBEMULTIPLAYER.AnimationList.HeightChangeWalk)
			end			
		end
		
		function class:Draw(elapsed)
			local offset=13/3*self.scale
			self.displayedpositionoffset={x=offset*math.cos(self.orientation_displayed.yaw),
										  y=offset*math.sin(self.orientation_displayed.yaw),
										  z=0}
			super.Draw(self,elapsed)
		end
	end

	
	do	
		local super=XPRACTICE.Spell
		XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_MoveBossToCenter=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_MoveBossToCenter
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)

			self.name="(Move Boss to Center)"
			self.icon="interface/icons/ability_hunter_markedfordeath.blp"

			self.requiresfacing=false		
			self.projectileclass=nil	
			self.basecastduration=0.0
			self.basechannelduration=nil
			self.basechannelticks=nil
		end
		
		function class:CompleteCastingEffect(castendtime,spellinstancepointer)	
			local scenario=spellinstancepointer.castercombat.mob.scenario
			scenario.boss.ai.targetposition={x=0,y=0}
		end
	end	
	do	
		local super=XPRACTICE.Spell
		XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_MoveBossUp=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_MoveBossUp
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.name="(Move Boss Up)"
			self.icon="interface/icons/inv_icon_feather06a.blp"
			self.requiresfacing=false;self.projectileclass=nil;self.basecastduration=0.0;self.basechannelduration=nil;self.basechannelticks=nil
		end

		
		function class:CompleteCastingEffect(castendtime,spellinstancepointer)	
			local scenario=spellinstancepointer.castercombat.mob.scenario
			scenario.boss.ai.targetposition=nil
			scenario.boss.targetheight=self.maxheight
		end
	end
	
	do	
		local super=XPRACTICE.Spell
		XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_MoveBossDown=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.FATESCRIBEMULTIPLAYER.Spell_MoveBossDown
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.name="(Move Boss Down)"
			self.icon="interface/icons/inv_icon_feather06b.blp"			
			self.requiresfacing=false;self.projectileclass=nil;self.basecastduration=0.0;self.basechannelduration=nil;self.basechannelticks=nil
		end
		
		function class:CompleteCastingEffect(castendtime,spellinstancepointer)	
			local scenario=spellinstancepointer.castercombat.mob.scenario
			scenario.boss.targetheight=0			
		end
	end	
end