do	

	local function NewSwirl(self,x,y,playername,swirltag)
		swirltag=swirltag or 255
		local swirl=XPRACTICE.KELTHUZADMULTIPLAYER.Swirl.new()
		swirl:Setup(self.environment,x,y,0)
		swirl.scenario=self.scenario
		swirl.playername=playername
		swirl.swirltag=swirltag
		tinsert(self.scenario.swirls,swirl)
		local player=self.scenario.multiplayer.allplayers[playername]
		if(self.scenario.multiplayer.allplayers[playername])then
			if(player.swirlpositions and player.swirlpositions[swirltag])then
				swirl.x=player.swirlpositions[swirltag].x
				swirl.y=player.swirlpositions[swirltag].y
				player.swirlpositions[swirltag]=nil
			end
		end

		if(XPRACTICE.KELTHUZADMULTIPLAYER.Config.DisplaySwirlRim)then
			local swirl2=XPRACTICE.KELTHUZADMULTIPLAYER.Swirl2.new()
			swirl2:Setup(self.environment,x,y,0)
			swirl2.scenario=self.scenario	
		end
	end

	do	
		local super=XPRACTICE.GameObject
		XPRACTICE.KELTHUZADMULTIPLAYER.SwirlController=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.KELTHUZADMULTIPLAYER.SwirlController
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.swirltimer=0
			self.active=false
			-- savedata patch
			if(XPRACTICE_SAVEDATA.KELTHUZADMULTIPLAYER.swirltype==2)then XPRACTICE_SAVEDATA.KELTHUZADMULTIPLAYER.swirltype=3 end
			self.swirlfrequency=XPRACTICE_SAVEDATA.KELTHUZADMULTIPLAYER.swirltype
			self.swirltag=1
		end
		
		function class:Step(elapsed)
			if(self.active and self.swirlfrequency>0 and self.scenario.inphasecount>0)then
				self.swirltimer=self.swirltimer-elapsed
				if(self.swirltimer<0)then
					--TODO: stored swirlfrequency
					self.swirltimer=self.swirltimer+self.swirlfrequency
					--for i=1,#self.scenario.allplayers do
					local playerswirlx,playerswirly=nil,nil
					for k,v in pairs(self.scenario.multiplayer.allplayers) do
						--local player=self.scenario.allplayers[i]
						local player=v
						if(player.inphase and not player:IsDeadInGame())then
							if(player.timeinphase>=XPRACTICE.KELTHUZADMULTIPLAYER.Config.MinimumPhaseSwirlTime)then							
								--local x,y=XPRACTICE.RandomPointInCircle(player.position.x,player.position.y,XPRACTICE.KELTHUZADMULTIPLAYER.Config.SwirlAimMaxOffset)
								local x,y=player.position.x,player.position.y
								if(player~=self.scenario.player)then
									--if(player.ai.targetposition)then
										--x,y=player.ai.targetposition.x,player.ai.targetposition.y										
									--end
									if(player.velocity.x~=0 or player.velocity.y~=0)then
										x=player.position.x+player.velocity.x*XPRACTICE.KELTHUZADMULTIPLAYER.Config.PhaseTimeLagEstimate
										y=player.position.y+player.velocity.y*XPRACTICE.KELTHUZADMULTIPLAYER.Config.PhaseTimeLagEstimate
									end
								end
								--print("Check offset",self.swirltag)
								if(player.swirloffsets and player.swirloffsets[self.swirltag])then
									x=x+player.swirloffsets[self.swirltag].x
									y=y+player.swirloffsets[self.swirltag].y
								else
									--print("Not found for",k)
								end
								if(player==self.scenario.player)then
									playerswirlx=x;playerswirly=y
								end
								
								--TODO: *maybe* keep swirl in bounds
								if(XPRACTICE.KELTHUZADMULTIPLAYER.Config.SwirlAimDelay>0)then
									local swirl=XPRACTICE.KELTHUZADMULTIPLAYER.PreSwirl.new()
									swirl:Setup(self.environment,x,y,0)
									swirl.scenario=self.scenario
									swirl.playername=k
									swirl.swirltag=self.swirltag
								else
									NewSwirl(self,x,y,k,self.swirltag)
								end								
							end
						end 
					end
					local prevtag=self.swirltag
					self.swirltag=self.swirltag+1
					if(self.swirltag>127)then self.swirltag=2 end
					local player=self.scenario.player
					local offsetx,offsety=XPRACTICE.RandomPointInCircle(0,0,XPRACTICE.KELTHUZADMULTIPLAYER.Config.SwirlAimMaxOffset)
					if(playerswirlx and playerswirly)then
						self.scenario.multiplayer:FormatAndSendCustom("MYSWIRL",string.char(prevtag),playerswirlx,playerswirly,string.char(self.swirltag),offsetx,offsety)					
						if(not player.swirlpositions)then player.swirlpositions={} end
						player.swirlpositions[prevtag]={x=playerswirlx,y=playerswirly}
						--print("MYSWIRL",prevtag,playerswirlx,playerswirly,self.swirltag,offsetx,offsety)
					else
						self.scenario.multiplayer:FormatAndSendCustom("MYSWIRL",string.char(253),0,0,string.char(self.swirltag),offsetx,offsety)						
						if(not player.swirlpositions)then player.swirlpositions={} end
						player.swirlpositions[prevtag]=nil
						--print("(no swirl)")
					end
					if(not player.swirlpositions)then player.swirlpositions={} end
					if(not player.swirloffsets)then player.swirloffsets={} end
					
					player.swirloffsets[self.swirltag]={x=offsetx,y=offsety}
					
				end
				--print("!")
			else
				self.swirltimer=self.swirlfrequency
				--print(self.active, self.swirlfrequency, self.scenario.inphasecount)
			end
		end

	end



	do	
		local super=XPRACTICE.GameObject
		XPRACTICE.KELTHUZADMULTIPLAYER.PreSwirl=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.KELTHUZADMULTIPLAYER.PreSwirl
		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.expirytime=self.environment.localtime+XPRACTICE.KELTHUZADMULTIPLAYER.Config.SwirlAimDelay
		end
		function class:OnExpiry()
			super.OnExpiry(self)
			NewSwirl(self,self.position.x,self.position.y,self.playername)
		end
	end



	do	
		local super=XPRACTICE.WoWObject
		XPRACTICE.KELTHUZADMULTIPLAYER.Swirl=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.KELTHUZADMULTIPLAYER.Swirl		
		function class:SetActorAppearanceViaOwner(actor)
			actor:SetModelByFileID(3621953)	--target_anima_maldraxxus_state_centeronly (0,158,159)			
			self.scale=XPRACTICE.KELTHUZADMULTIPLAYER.Config.SwirlScale
			self.displayedpositionoffset={x=0,y=0,z=XPRACTICE.KELTHUZADMULTIPLAYER.Config.SwirlZOffset}
		end
		function class:SetDefaultAnimation()
			self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileSpawnCustomDuration)
			self.projectilespawncustomduration=0.25
			self.projectileloopcustomduration=XPRACTICE.KELTHUZADMULTIPLAYER.Config.SwirlExplosionTime-self.projectilespawncustomduration
			self.projectiledespawncustomduration=0.25		
		end	
		function class:OnProjectileDespawning()
			super.OnProjectileDespawning(self)
			
			if(self.disarmed)then return end			
			if(not self.scenario.multiplayer.roomlocked)then return end
			
			local expl=XPRACTICE.KELTHUZADMULTIPLAYER.SwirlExplosion.new()
			expl:Setup(self.environment,self.position.x,self.position.y,0)			
			
			local pool=XPRACTICE.KELTHUZADMULTIPLAYER.Pool.new()
			
			local player=self.scenario.multiplayer.allplayers[self.playername]
			local swirltag=self.swirltag
			
			local x,y=self.position.x,self.position.y
			if(player and player.swirlpositions and player.swirlpositions[swirltag])then
				x=player.swirlpositions[swirltag].x
				y=player.swirlpositions[swirltag].y
				player.swirlpositions[swirltag]=nil
				--print(self.playername,"pool",swirltag,"move to:",x,y)
			else
				--print("Match not found for tag",swirltag)
			end
			pool:Setup(self.environment,x,y,0)
			tinsert(self.scenario.pools,pool)			
			
			
			local player=self.scenario.player

			if(not player:IsDeadInGame())then				
				local auras=player.combatmodule.auras:GetAurasByClassIfExist(XPRACTICE.KELTHUZADMULTIPLAYER.Aura_PallyBubble)
				if(#auras>0)then return end
				local xdist=player.position.x-self.position.x
				local ydist=player.position.y-self.position.y
				local distsqr=xdist*xdist+ydist*ydist
				if(distsqr<=XPRACTICE.KELTHUZADMULTIPLAYER.Config.SwirlRadius*XPRACTICE.KELTHUZADMULTIPLAYER.Config.SwirlRadius)then
					--apply aura BEFORE player velocity; aura is hardcoded to 0 x/y upon application
					local aura=player.combatmodule:ApplyAuraByClass(XPRACTICE.Aura_DeadInGame,player.combatmodule,player.environment.localtime)
					local aura=player.combatmodule:ApplyAuraByClass(XPRACTICE.KELTHUZADMULTIPLAYER.Aura_ChangePhaseForced,player.combatmodule,player.environment.localtime)
					aura.scenario=self.scenario
					player.velocity.z=XPRACTICE.KELTHUZADMULTIPLAYER.Config.SwirlZKnockback	
					local xyvelocity=XPRACTICE.KELTHUZADMULTIPLAYER.Config.SwirlXYKnockback 
					local angle=math.atan2(player.position.y,player.position.x)
					player.velocity.x=math.cos(angle)*xyvelocity
					player.velocity.y=math.sin(angle)*xyvelocity
					self.scenario.statuslabel:SetText("Died from Shadow Fissure.",3.0)
					self.scenario.multiplayer:FormatAndSendCustom("DEAD_SWIRL")
				end
			end
		end
	end
	do	
		local super=XPRACTICE.WoWObject
		XPRACTICE.KELTHUZADMULTIPLAYER.Swirl2=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.KELTHUZADMULTIPLAYER.Swirl2
		
		function class:SetActorAppearanceViaOwner(actor)
			actor:SetModelByFileID(3622771)	--target_anima_maldraxxus_state_rimonly (0,158,159)			
			self.scale=XPRACTICE.KELTHUZADMULTIPLAYER.Config.SwirlScale
			self.displayedpositionoffset={x=0,y=0,z=XPRACTICE.KELTHUZADMULTIPLAYER.Config.SwirlZOffset}
		end
		function class:SetDefaultAnimation()
			self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileSpawnCustomDuration)
			self.projectilespawncustomduration=0.25
			self.projectileloopcustomduration=XPRACTICE.KELTHUZADMULTIPLAYER.Config.SwirlExplosionTime-self.projectilespawncustomduration
			self.projectiledespawncustomduration=0.25		
		end	
	end
	
	do	
		local super=XPRACTICE.WoWObject
		XPRACTICE.KELTHUZADMULTIPLAYER.SwirlExplosion=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.KELTHUZADMULTIPLAYER.SwirlExplosion
		function class:SetActorAppearanceViaOwner(actor)
			actor:SetModelByFileID(4025153)	--9fx_raid2_KELTHUZADMULTIPLAYER_shadowfissure
			self.scale=XPRACTICE.KELTHUZADMULTIPLAYER.Config.SwirlScale
			self.displayedpositionoffset={x=0,y=0,z=0}
		end
		function class:SetDefaultAnimation()
			self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileDespawnCustomDuration)
			self.projectiledespawncustomduration=1.0
		end	
	end	
	
	do	
		local super=XPRACTICE.WoWObject
		XPRACTICE.KELTHUZADMULTIPLAYER.Pool=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.KELTHUZADMULTIPLAYER.Pool
		function class:SetActorAppearanceViaOwner(actor)
			actor:SetModelByFileID(3088343)	--scale_obj_cylinder_001gray
			actor:SetSpellVisualKit(6531)
			self.startingphasealpha=0
			self.scale=XPRACTICE.KELTHUZADMULTIPLAYER.Config.PoolScale
			self.displayedpositionoffset={x=0,y=0,z=XPRACTICE.KELTHUZADMULTIPLAYER.Config.PoolZOffset}
			self.fadestarttime=self.environment.localtime+10.0
			self.expirytime=self.environment.localtime+11.0
		end
		function class:CreateAssociatedObjects()
			self.rim=XPRACTICE.KELTHUZADMULTIPLAYER.PoolRim.new()
			self.rim:Setup(self.environment,self.position.x,self.position.y,0)
			self.rim.pool=self
		end
	end	
	
	do	
		local super=XPRACTICE.WoWObject
		XPRACTICE.KELTHUZADMULTIPLAYER.PoolRim=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.KELTHUZADMULTIPLAYER.PoolRim
		function class:SetActorAppearanceViaOwner(actor)
			actor:SetModelByFileID(1040159)	--target_void_state_rimonly
			self.alpha=0
			self.targetalpha=0
			self.scale=XPRACTICE.KELTHUZADMULTIPLAYER.Config.PoolRimScale
			self.displayedpositionoffset={x=0,y=0,z=XPRACTICE.KELTHUZADMULTIPLAYER.Config.PoolRimZOffset}
		end
		function class:SetDefaultAnimation()
			self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileSpawnCustomDuration)
			self.projectilespawncustomduration=0.25
			self.projectileloopcustomduration=10.5
			self.projectiledespawncustomduration=0.25		
		end	
		function class:Step(elapsed)
			super.Step(self,elapsed)			
			if(XPRACTICE.KELTHUZADMULTIPLAYER.Config.DisplayPoolRim)then
				if(self.pool.dead)then targetalpha=0 end
				if(self.alpha<self.targetalpha)then
					self.alpha=self.alpha+elapsed*2
					if(self.alpha>self.targetalpha)then self.alpha=self.targetalpha end
				end
				if(self.alpha>self.targetalpha)then
					self.alpha=self.alpha-elapsed*2
					if(self.alpha<self.targetalpha)then self.alpha=self.targetalpha end
				end			
			else
				self.targetalpha=0
				self.alpha=0
			end
		end
	end		


	do
		local super=XPRACTICE.Spell
		XPRACTICE.KELTHUZADMULTIPLAYER.Spell_SwirlSync_5 = XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.KELTHUZADMULTIPLAYER.Spell_SwirlSync_5
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.name="Shadow Fissure (5 sec)"
			self.icon="interface/icons/ability_argus_soulburst.blp"
			self.requiresfacing=false;self.projectileclass=nil;self.basecastduration=0;self.basechannelduration=nil;self.basechannelticks=nil;self.tickonchannelstart=false;self.usablewhilemoving=true
		end
		
		function class:StartCastingEffect(spellinstancepointer)
			local scenario=spellinstancepointer.castercombat.mob.scenario
			scenario.multiplayer:FormatAndSendCustom("SWIRLSYNC_SLOW")
		end
	end

	do
		local super=XPRACTICE.Spell
		XPRACTICE.KELTHUZADMULTIPLAYER.Spell_SwirlSync_2 = XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.KELTHUZADMULTIPLAYER.Spell_SwirlSync_2
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.name="Shadow Fissure (2 sec)"
			self.icon="interface/icons/ability_argus_soulburst.blp"
			self.requiresfacing=false;self.projectileclass=nil;self.basecastduration=0;self.basechannelduration=nil;self.basechannelticks=nil;self.tickonchannelstart=false;self.usablewhilemoving=true
		end
		
		function class:StartCastingEffect(spellinstancepointer)
			local scenario=spellinstancepointer.castercombat.mob.scenario
			scenario.multiplayer:FormatAndSendCustom("SWIRLSYNC_FAST")
		end
	end
	
	do
		local super=XPRACTICE.Spell
		XPRACTICE.KELTHUZADMULTIPLAYER.Spell_SwirlSync_Stop = XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.KELTHUZADMULTIPLAYER.Spell_SwirlSync_Stop
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.name="Shadow Fissure (stop)"
			self.icon="interface/icons/ability_argus_soulburst.blp"
			self.requiresfacing=false;self.projectileclass=nil;self.basecastduration=0;self.basechannelduration=nil;self.basechannelticks=nil;self.tickonchannelstart=false;self.usablewhilemoving=true
		end
		
		function class:StartCastingEffect(spellinstancepointer)
			local scenario=spellinstancepointer.castercombat.mob.scenario
			scenario.multiplayer:FormatAndSendCustom("SWIRLSYNC_STOP")
		end
	end	
	
	
	
	
	do
		local super=XPRACTICE.GameObject
		XPRACTICE.KELTHUZADMULTIPLAYER.PoolDebuffIcon=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.KELTHUZADMULTIPLAYER.PoolDebuffIcon
		
		function class:Setup(environment,x,y,z)
			super.Setup(self,environment,x,y,z)
			self.focus=nil
		end
		
		function class:CreateDisplayObject()
			self.displayobject=XPRACTICE.KELTHUZADMULTIPLAYER.PoolDebuffIconDisplayObject.new()
			self.displayobject:Setup(self)
		end
		
		
		function class:Step(elapsed)
			super.Step(self,elapsed)
			local player=self.focus
			if(player)then
				if(player.inphase and self.scenario.inpool)then
					self.displayobject.drawable:Show()
					local stacktext=string.format("%0.1f",self.scenario.pooltime)
					self.displayobject.text.fontstring:SetText(stacktext)					
				else
					self.displayobject.drawable:Hide()
				end
			else
				self.displayobject.drawable:Hide()
			end
		end

		function class:ResetTimer()
			self.running=true
			self.active=true
			self.starttime=self.environment.localtime
			self.currenttime=self.starttime
		end


		
		function class:Draw(elapsed)
			self.displayobject:SetPositionAndScale(self.position,self.scale)
		end	
		
		
	end


	do
		local super=XPRACTICE.DisplayObject
		XPRACTICE.KELTHUZADMULTIPLAYER.PoolDebuffIconDisplayObject=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.KELTHUZADMULTIPLAYER.PoolDebuffIconDisplayObject
		
		function class:CreateDrawable()		
			local f=XPRACTICE.ReusableFrames:GetFrame()
			self.drawable=f
			self.drawable.owner=self
			self.back=f
			tinsert(self.drawables,f)
			local f=XPRACTICE.ReusableFrames:GetFrame()
			self.text=f
			tinsert(self.drawables,f)
		end
		function class:SetAppearance()
			--self.parentframe=self.owner.environment.hudframe
			self.parentframe=self.owner.environment.frame
			--self.parentframe=UIParent
			self.back:SetParent(self.parentframe)
			self.back.texture:Show();self.back.texture:SetTexture("interface/icons/ability_argus_soulburst.blp")
			self.back:Show();self.back:SetAlpha(1)
			self.back:SetSize(100,100)
			self.back:SetFrameLevel(200)				
			
			self.text:Show();self.text:SetAlpha(1)
			self.text:SetParent(self.back)
			--self.text:SetAllPoints(self.icon)
			self.text:SetAllPoints(self.back)
			self.text.fontstring:Show();self.text.fontstring:SetScale(2)
			self.text.fontstring:SetText("")
			self.text:SetFrameLevel(202)
			
		end	
		function class:SetPositionAndScale(position,scale)
			self.back:SetPoint("BOTTOMLEFT",self.parentframe,"BOTTOMLEFT",position.x,position.y)
		end

		
	end
	
	
end