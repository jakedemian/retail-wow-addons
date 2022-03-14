do
	local WEBZ1=3.0
	local WEBZ2=3.0*2/3
	local INITIAL_LENGTH=-4
	
	do	
		local super=XPRACTICE.Spell
		XPRACTICE.INDIGNATION.Spell_Indignation=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.INDIGNATION.Spell_Indignation
		
		
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)

			self.name="Indignation"
			self.icon="interface/icons/spell_animarevendreth_nova.blp"

			self.requiresfacing=false		
			self.projectileclass=nil	
			self.basecastduration=0.0
			self.basechannelduration=8.0
			if(DEBUG_FASTSTART)then self.basechannelduration=0.08 end --!!!
			self.basechannelticks=32	--every 250 milliseconds, apparently

			if(XPRACTICE_SAVEDATA.INDIGNATION.startfrommidway>0)then self.basechannelduration=nil;self.basechannelticks=nil end
			--print(XPRACTICE_SAVEDATA.INDIGNATION.startfrommidway,"midway")
			
		end
		
		function class:ChannelingAnimationFunction(spellinstancepointer)				
			--if(spellinstancepointer:GetCastProgress()<(5.5/6.0) and self.basecastduration>0.0)then
				spellinstancepointer.castercombat.mob.animationmodule:TryOmniChannel()
			--else
				--spellinstancepointer.castercombat.mob.animationmodule:PlayOrContinueAnimation(XPRACTICE.TERROROFCASTLENATHRIA.AnimationList.SpellCastOmni)
			--end
		end		
		
		
		function class:FinishStartingPhase3()			
			self.scenario:GetScheduleClass().Run(self.scenario)
			self.scenario.denathrius.displayobject.drawable:SetSpellVisualKit(131725)
			self.scenario.mirrorsactive=false
			self.scenario.denathrius.autoattacktimer=0.25+0.75	--wait for spell01 animation to finish, if it was playing
		end
		

		function class:CompleteCastingEffect(castendtime,spellinstancepointer)	
			self.scenario.currentphase=3
			self.scenario.phaseinprogress=true
			
			if(XPRACTICE_SAVEDATA.INDIGNATION.startfrommidway>0)then self:FinishStartingPhase3();return end
	
			self.scenario.denathrius.position.x=0
			self.scenario.denathrius.position.y=0
			self.scenario.denathrius.position.z=0			
			--self.scenario.denathrius.orientation.yaw=math.pi;self.scenario.denathrius.orientation_displayed.yaw=self.scenario.denathrius.orientation.yaw
			self.scenario.denathrius.orientation.yaw=0;self.scenario.denathrius.orientation_displayed.yaw=self.scenario.denathrius.orientation.yaw
			--TODO: if Denathrius AI has a target position, clear it
			local remornia=self.scenario.remornia
			remornia.mobclickzone:Die()
			remornia.nameplate:Die()
			remornia.fadestarttime=cabalist.environment.localtime+0.0
			remornia.expirytime=cabalist.environment.localtime+0.5
			local cabalist=self.scenario.cabalist
			local aura=cabalist.combatmodule:ApplyAuraByClass(XPRACTICE.Aura_DeadInGame,cabalist.combatmodule,cabalist.environment.localtime)
			cabalist.mobclickzone:Die()
			cabalist.nameplate:Die()
			cabalist.fadestarttime=cabalist.environment.localtime+2.0
			cabalist.expirytime=cabalist.environment.localtime+4.0

			for i=1,#self.scenario.allplayers do
				local ghost=self.scenario.allplayers[i]
				local distsqr=(self.scenario.tanks[1].position.x-ghost.position.x)*(self.scenario.tanks[1].position.x-ghost.position.x)+(self.scenario.tanks[1].position.y-ghost.position.y)*(self.scenario.tanks[1].position.y-ghost.position.y)
				local radius=15*1.24 -- Front of the Pack ilvl 226
				if(distsqr<=radius*radius)then
					local aura=ghost.combatmodule:ApplyAuraByClass(XPRACTICE.Aura_StampedingRoar,ghost.combatmodule,ghost.localtime)
				end
			end
			

			if(self.basechannelduration and self.basechannelduration>1)then 
			-- initialize ghosts only if we're not skipping the channel.  otherwise, ghosts will get confused when they go through mirror
				for i=1,2 do
					local ghost=self.scenario.allplayers[i]
					if(ghost.cpu)then
						ghost.destx=-100
						ghost.desty=0
						ghost.remainingreactiontime=math.random()*0.25+0.5	
					end
				end
				for i=3,10 do
					local ghost=self.scenario.allplayers[i]
					if(ghost.cpu)then
						ghost.destx=-100
						ghost.desty=0					
						ghost.remainingreactiontime=math.random()*2.0+0.25	
					end
				end
				for i=11,20 do
					local ghost=self.scenario.allplayers[i]
					if(ghost.cpu)then													
						if(ghost:ApproachPoint(0,0,21,10))then												
							ghost.remainingreactiontime=math.random()*2.0+0.25	
						end
					end
				end
			end
			

			
			--TODO: crescendo controller (for now, attached to channel ticks, but we need one for surprise ending)
		end
		
		function class:OnChannelTick(spellinstancepointer,tickcount)			
			if(tickcount==1)then
				self.scenario.denathrius:CreateSpeechBubble("\124cffff3f40Enough! I have been a patient host. I showed restraint.\nEven courtesy.\124r",6.0)
				self.scenario:ClickButtonAfterDelay(self.scenario.crescendobutton,0)				
			elseif(tickcount==32)then				
				--self.scenario.denathrius.orientation.yaw=0
				local scenario=self.scenario
				for i=1,#scenario.mirrors do
					local mirror=scenario.mirrors[i]
					mirror.animationmodule:PlayAnimation(XPRACTICE.INDIGNATION.AnimationList.MirrorBreak)
				end
				scenario.scenerycontroller_mirrors.fadestarttime=self.scenario.game.environment_gameplay.localtime+2.0
				scenario.scenerycontroller_mirrors.fadestoptime=self.scenario.game.environment_gameplay.localtime+4.0
				if(self.basechannelduration>4.0)then
					--don't disable mirrors if we're using quickindignation cheat
					scenario.mirrorsactive=false
				end
				

				-- scenario.scenerycontroller_outerwings.fadestarttime=self.scenario.game.environment_gameplay.localtime+2.0
				-- scenario.scenerycontroller_outerwings.fadestoptime=self.scenario.game.environment_gameplay.localtime+4.0
				-- scenario.scenerycontroller_cornerplatforms.fadestarttime=self.scenario.game.environment_gameplay.localtime+2.0
				-- scenario.scenerycontroller_cornerplatforms.fadestoptime=self.scenario.game.environment_gameplay.localtime+4.0
			
				class.CreateIndignationEffects(scenario)
				

				
				spellinstancepointer.castercombat.mob.displayobject.drawable:SetSpellVisualKit(131725)
				
				local event={}
				event.time=self.scenario.game.environment_gameplay.localtime+1.0
				event.func=function(scenario)
						scenario.denathrius:CreateSpeechBubble("\124cffff3f40Yet you continue to provoke my wrath. Very well.\nYou shall have it!\124r")
					end
				tinsert(self.scenario.events,event)
				
				scenario.denathrius.animationmodule:PlayAnimation(XPRACTICE.INDIGNATION.AnimationList.CustomSpell01)				

				if(self.scenario.player.mirrorrealm)then
					tinsert(self.scenario.mirrorgroup,self.scenario.player)
				else
					--print("tinsert rangedgroup")
					tinsert(self.scenario.rangedgroup,self.scenario.player)
				end							
				
				self:FinishStartingPhase3()
			end
		end
		
		-- global static
		function class.CreateIndignationEffects(scenario)
			local obj
			obj=XPRACTICE.WoWObject.new()
			obj:Setup(scenario.denathrius.environment)		
			obj.displayobject.drawable:SetModelByFileID(3611071)	--9fx_raid1_denathrius_indignation_state
			obj.position={x=0,y=0,z=0}
			obj.scale=1
			obj.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileSpawnCustomDuration)
			obj.projectilespawncustomduration=0.5;obj.projectileloopcustomduration=nil;obj.projectiledespawncustomduration=0.5
			obj.visiblefromallphases=true
			tinsert(scenario.phase3tempobjs,obj)
			
			local obj
			obj=XPRACTICE.WoWObject.new()
			obj:Setup(scenario.denathrius.environment)		
			obj.displayobject.drawable:SetModelByFileID(3601357)	--9fx_raid1_denathrius_arenaring_state
			obj.position={x=0,y=0,z=0}
			obj.scale=1
			obj.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileSpawnCustomDuration)
			obj.projectilespawncustomduration=1.0;obj.projectileloopcustomduration=nil;obj.projectiledespawncustomduration=1.0
			obj.visiblefromallphases=true	
			tinsert(scenario.phase3tempobjs,obj)
		end
	end

	
end