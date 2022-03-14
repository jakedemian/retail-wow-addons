do
	local LINEZ=1	
	local SWIRLZ=1
		
	do	
		local super=XPRACTICE.Spell
		XPRACTICE.SINSANDSUFFERING.Spell_SharedSuffering_Telegraph=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.SINSANDSUFFERING.Spell_SharedSuffering_Telegraph

		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)

			self.name="Shared Suffering (Telegraph)"
			self.icon="interface/icons/achievement_pvp_h_01.blp"

			self.requiresfacing=false		
			self.projectileclass=nil	
			self.basecastduration=0.0
			self.basechannelduration=nil
			self.basechannelticks=nil
		end
		

		function class:CompleteCastingEffect(castendtime,spellinstancepointer)	
			for i=1,#self.scenario.sharedsufferingarrows do
				local arrow=self.scenario.sharedsufferingarrows[i]
				arrow:Activate()
			end			
			self.scenario:ClickButtonAfterDelay(self.scenario.moveghostsbutton,1.0)
			self.scenario:ClickButtonAfterDelay(self.scenario.sharedsufferingknockbackbutton,2.0)
			self.scenario:ClickButtonAfterDelay(self.scenario.sharedsufferinglinkbutton,3.5)			
		end
	end

	do	
		local super=XPRACTICE.WoWObject
		XPRACTICE.SINSANDSUFFERING.SharedSuffering_TelegraphArrow1=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.SINSANDSUFFERING.SharedSuffering_TelegraphArrow1
		
		function class:SetActorAppearanceViaOwner(actor)
			actor:SetModelByFileID(3635055)	--8fx_rl_personalresponsibility_arrow_red
			self.scale=1		
			self.enabled=false
		end
		
		function class:SetDefaultAnimation()
			-- play despawn animation so the spawn animation plays properly on activation
			self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileDespawnCustomDuration)
			self.projectilespawncustomduration=0.4
			self.projectileloopcustomduration=3
			self.projectiledespawncustomduration=1
		end	
		
		function class:Step(elapsed)
			super.Step(self,elapsed)
			if(self.player)then			
				self.alpha=self.player.alpha
				self.position.x=self.player.position.x
				self.position.y=self.player.position.y
				self.position.z=self.player.position.z+4
			end
			if(not self.enabled)then
				self.alpha=0
			end
		end
		
		function class:Activate()
			self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileSpawnCustomDuration)
			self.enabled=true
		end
		
		function class:OnProjectileDespawned()
			-- don't call super		
			self.enabled=false
		end
	end

	do	
		local super=XPRACTICE.SINSANDSUFFERING.SharedSuffering_TelegraphArrow1
		XPRACTICE.SINSANDSUFFERING.SharedSuffering_TelegraphArrow2=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.SINSANDSUFFERING.SharedSuffering_TelegraphArrow2
		
		function class:SetActorAppearanceViaOwner(actor)
			actor:SetModelByFileID(3039596)	--8fx_rl_personalresponsibility_targeted_red
			self.scale=1		
			self.alpha=0
		end
	end


	do	
		local super=XPRACTICE.Spell
		XPRACTICE.SINSANDSUFFERING.Spell_SharedSuffering_Knockback=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.SINSANDSUFFERING.Spell_SharedSuffering_Knockback

		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)

			self.name="Shared Suffering (Knockback)"
			--self.icon="interface/icons/achievement_pvp_h_01.blp"

			self.requiresfacing=false		
			self.projectileclass=nil	
			self.basecastduration=0.0
			self.basechannelduration=nil
			self.basechannelticks=nil
		end
		
		function class:CompleteCastingEffect(castendtime,spellinstancepointer)	
			for i=1,3 do
				if(i<=2)then player=self.scenario.ghosts[i] else player=self.scenario.player end
				if(player.enabled)then
					local angle=math.atan2(player.position.y,player.position.x)
					player.velocity.x=math.cos(angle)*10
					player.velocity.y=math.sin(angle)*10
					player.velocity.z=10
				end			
			end
		end
	end


	do	
		local super=XPRACTICE.WoWObject
		XPRACTICE.SINSANDSUFFERING.SharedSuffering_TelegraphSwirl=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.SINSANDSUFFERING.SharedSuffering_TelegraphSwirl
		
		function class:SetActorAppearanceViaOwner(actor)
			actor:SetModelByFileID(3581779)	--9fx_raid1_sommelier_sharedsuffering_dot
			self.scale=1		
			self.enabled=false
		end
		
		function class:SetDefaultAnimation()
			-- play despawn animation so the spawn animation plays properly on activation
			self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileDespawnCustomDuration)
			self.projectilespawncustomduration=1
			self.projectileloopcustomduration=nil
			self.projectiledespawncustomduration=1
		end	
		
		function class:Step(elapsed)
			super.Step(self,elapsed)
			if(self.player)then			
				self.alpha=self.player.alpha
				self.position.x=self.player.position.x
				self.position.y=self.player.position.y
				self.position.z=self.player.position.z+SWIRLZ
				self.orientation_displayed.yaw=self.player.orientation_displayed.yaw
			end
			if(not self.enabled)then
				self.alpha=0
			end
		end
		
		function class:Activate()
			self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileSpawnCustomDuration)
			self.enabled=true
		end
		function class:Deactivate()
			self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileDespawnCustomDuration)
		end	
		
		function class:OnProjectileDespawned()
			-- don't call super		
			self.enabled=false
		end
	end

	-- do	
		-- local super=XPRACTICE.VisibleLine
		-- XPRACTICE.SINSANDSUFFERING.SharedSuffering_Beam=XPRACTICE.inheritsFrom(super)
		-- local class=XPRACTICE.SINSANDSUFFERING.SharedSuffering_Beam
		
		-- function class:SetActorAppearanceViaOwner(actor)
			-- self.fileid=166331	--holy_missile_low
			-- self.particlexoffset=0
			-- self.particleyoffset=0		
			-- actor:SetModelByFileID(self.fileid)	
			-- self.scale=1
			-- self.alpha=0
		-- end
	-- end


	do	
		local super=XPRACTICE.GameObject
		XPRACTICE.SINSANDSUFFERING.SharedSufferingLineController=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.SINSANDSUFFERING.SharedSufferingLineController

		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.enabled=false
		end

		function class:CreateAssociatedObjects()
			self.lines={}
			self.swirls={}
			for i=1,3 do
				local p1,p2
				if(i==1)then p1=self.scenario.player;p2=self.scenario.ghosts[1]
				elseif(i==2)then p1=self.scenario.ghosts[1];p2=self.scenario.ghosts[2]
				else p1=self.scenario.ghosts[2];p2=self.scenario.player end
				local line=XPRACTICE.VisibleLine.new()		
				line:Setup(self.environment,p1.position.x,p1.position.y,p1.position.z+LINEZ,p2.position.x,p2.position.y,p2.position.z+LINEZ)
				--local fileid=970786-- hunter_focusingshot_missile
				local fileid=1363271-- cfx_deathknight_deathscaress_missile
				--local scale=0.25
				local scale=1/3.0
				line:ChangeLineActorID(fileid,0,0) 
				line.scale=scale
				line.visible=true		
				line.alpha=0
				tinsert(self.lines,line)
				local swirl=XPRACTICE.SINSANDSUFFERING.SharedSuffering_TelegraphSwirl.new()
				swirl:Setup(self.environment,p1.position.x,p1.position.y,p1.position.z+SWIRLZ)
				swirl.player=p1
				swirl.alpha=0
				tinsert(self.swirls,swirl)
			end
		end
		
		function class:Step(elapsed)
			local targetalpha
			for i=1,3 do
				local line=self.lines[i]
				local p1,p2
				if(i==1)then p1=self.scenario.player;p2=self.scenario.ghosts[1]
				elseif(i==2)then p1=self.scenario.ghosts[1];p2=self.scenario.ghosts[2]
				else p1=self.scenario.ghosts[2];p2=self.scenario.player end
							
				if(not self.enabled)then
					targetalpha=0
					line.enabled=false
				else
					--TODO LATER: fix this mess
					if(p1.enabled and p2.enabled and (p1.position.z==0 or p1==self.scenario.player) and (p2.position.z==0 or p2==self.scenario.player))then					
					--if(p1.enabled and p2.enabled and (p1.ghostalpha==1 or p1==self.scenario.player) and (p2.ghostalpha==1 or p2==self.scenario.player))then					
						line.enabled=true
						targetalpha=1 
					else
						line.enabled=false
						targetalpha=0 
					end
				end
				local ALPHARATE=2
				if(line.alpha<targetalpha)then
					line.alpha=line.alpha+elapsed*ALPHARATE
					if(line.alpha>targetalpha)then line.alpha=targetalpha end
				end
				if(line.alpha>targetalpha)then
					line.alpha=line.alpha-elapsed*ALPHARATE
					if(line.alpha<targetalpha)then line.alpha=targetalpha end
				end
			

				line.linesegment.x1=p1.position.x
				line.linesegment.y1=p1.position.y
				line.linesegment.z1=p1.position.z+LINEZ
				line.linesegment.x2=p2.position.x
				line.linesegment.y2=p2.position.y
				line.linesegment.z2=p2.position.z+LINEZ
				line:SetMissileOrientationAlongLine()
				
			end
		end
		
		function class:Activate()
			self.enabled=true
			self.scenario.timelimit:ResetTimer()
			for i=1,#self.swirls do
				self.swirls[i]:Activate()
			end
		end
		function class:Deactivate()
			self.enabled=false
			for i=1,#self.swirls do
				self.swirls[i]:Deactivate()
			end
		end		
	end


	do	
		local super=XPRACTICE.Spell
		XPRACTICE.SINSANDSUFFERING.Spell_SharedSuffering_Link=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.SINSANDSUFFERING.Spell_SharedSuffering_Link


		function class:SetCustomInfo()
			super.SetCustomInfo(self)

			self.name="Shared Suffering (Link)"
			self.icon="interface/icons/ui_venthyranimaboss_orblines.blp"

			self.requiresfacing=false		
			self.projectileclass=nil	
			self.basecastduration=0.0
			self.basechannelduration=nil
			self.basechannelticks=nil
		end
		

		function class:CompleteCastingEffect(castendtime,spellinstancepointer)	
			local controller=self.scenario.sharedsufferinglinecontroller
			--if(not controller.enabled)then
			if(true)then
				controller:Activate()
			else
				controller:Deactivate()
			end
		end
	end
end