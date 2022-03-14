do
	do	
		----odds of getting picked:
		--doubles ranged: (1 - 9/10 * 8/9) = 20%
		--singles ranged: (1 - 9/10) = 10%
		--doubles mirror: (1 - 7/8 * 6/7) = 25%
		--singles mirror: (1 - 7/8) = 12.5%
		----for now, let's double those odds
	
		--9 yard range
		
		local REDX="\124TInterface\\TargetingFrame\\UI-RaidTargetingIcon_7:12\124t"
		local PURPLEDIAMOND="\124TInterface\\TargetingFrame\\UI-RaidTargetingIcon_3:12\124t"
		local YELLOWSTAR="\124TInterface\\TargetingFrame\\UI-RaidTargetingIcon_1:12\124t"
		local GREENTRIANGLE="\124TInterface\\TargetingFrame\\UI-RaidTargetingIcon_4:12\124t"
		local ORANGECIRCLE="\124TInterface\\TargetingFrame\\UI-RaidTargetingIcon_2:12\124t"
		
		
		local super=XPRACTICE.Spell
		XPRACTICE.INDIGNATION.Spell_FatalFinesse=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.INDIGNATION.Spell_FatalFinesse

		function class:SetCustomInfo()
			super.SetCustomInfo(self)

			self.name="Fatal Finesse"
			self.icon="interface/icons/spell_animarevendreth_groundstate.blp"

			self.requiresfacing=false		
			self.projectileclass=nil	
			self.basecastduration=0.0
			self.basechannelduration=nil
			self.basechannelticks=nil
			
		end
		
		function class:CompleteCastingEffect(castendtime,spellinstancepointer)	
			local scenario=self.scenario
			
			--TODO LATER: shouldntsoak tracker is expected to malfunction for FF6+7 combo
			scenario.playershouldntsoak=false
			
			scenario.fatalfinessecount=scenario.fatalfinessecount+1
			if(scenario.fatalfinessecount>7)then scenario.fatalfinessecount=1 end
			
			-- local detailedrangedhint=""
			-- local detailedmirrorhint=""
			-- --local simplehint="Drop seeds to the right, near the edge."
			-- if(scenario.fatalfinessecount==1)then				
				-- detailedrangedhint="Go right and drop at the edge."
				-- detailedmirrorhint="Go right and drop towards "..PURPLEDIAMOND.." purple diamond."
			-- elseif(scenario.fatalfinessecount==2)then
				-- detailedrangedhint="Go forward/right and drop towards "..REDX.." red X."
				-- detailedmirrorhint="Go forward/right and drop in the middle of the room."
			-- elseif(scenario.fatalfinessecount==3)then
				-- detailedrangedhint="Run far!  Drop at the edge on the other side of "..PURPLEDIAMOND.." purple diamond."
				-- detailedmirrorhint="Stop running!  Drop just outside the pizza slice!"
			-- elseif(scenario.fatalfinessecount==4)then
				-- detailedrangedhint="Shuffle right/backwards and drop along the pizza slice towards "..YELLOWSTAR.." yellow star."
				-- detailedmirrorhint="Run far right and drop in front of "..REDX.." red X."
			-- elseif(scenario.fatalfinessecount==5)then
				-- detailedrangedhint="Go right and drop along the pizza slice."
				-- detailedmirrorhint="Go right and drop near "..REDX.." red X."			
			-- elseif(scenario.fatalfinessecount==6)then
				-- detailedrangedhint="Go right and drop at the edge."
				-- detailedmirrorhint="Run past the boss and drop along the pizza slice."
			-- elseif(scenario.fatalfinessecount==7)then
				-- detailedrangedhint="Go left or right and drop along the pizza slice."
				-- detailedmirrorhint="Go right and drop at the edge."
			-- end
			
			local reversedouble=scenario.reversedoubleseedtracker[scenario.fatalfinessecount]
			local player=scenario.player
			--first determine odds that player gets picked
			local basechance=0
			if(reversedouble==false and player.mirrorrealm==false)then
				basechance=0.2
			elseif(reversedouble==true and player.mirrorrealm==false)then
				basechance=0.1
			elseif(reversedouble==false and player.mirrorrealm==true)then
				basechance=0.25
			elseif(reversedouble==true and player.mirrorrealm==true)then
				basechance=0.125
			end			
			local chance=basechance*2
			local savedatacheckname="target_ff_"..tostring(scenario.fatalfinessecount)
			if(XPRACTICE_SAVEDATA.INDIGNATION[savedatacheckname]==1)then
				chance=2.0
			elseif(XPRACTICE_SAVEDATA.INDIGNATION[savedatacheckname]==2)then
				chance=-1.0
			end			
			--does player get picked?
			local playerpick=false			
			if(math.random()<chance)then 
				playerpick=true 
				scenario.playershouldntsoak=true
			end
			
			local picklist={}
			local rangedcount=0
			local mirrorcount=0
			local rangedtotal=2
			local mirrortotal=1
			if(reversedouble)then rangedtotal,mirrortotal=mirrortotal,rangedtotal end
			--playerpick=true;rangedtotal,mirrortotal=1,2 --debug only.
			--playerpick=true;rangedtotal,mirrortotal=2,1 --debug only.
			--playerpick=true						--debug only. 
			
			if(player:IsDeadInGame())then playerpick=false end
			
			local prevranged=nil
			local prevmirror=nil
			if(playerpick)then		
				tinsert(picklist,player)
				XPRACTICE_RaidBossEmote("Fatal Finesse on YOU",5.0,true)
				--print("Pick player at chance ",chance)
				if(player.mirrorrealm==false)then
					rangedcount=rangedcount+1
					prevranged=player
				else
					mirrorcount=mirrorcount+1
					prevmirror=player
				end				
			end
			for i=1,21 do
				scenario.allplayers[i].FFpartner=nil
			end
			local rangedpicks={11,12,13,14,15,16,17,18,19,20}
			for i=rangedcount+1,rangedtotal do				
				local pickindex=math.floor(math.random()*#rangedpicks)+1
				tinsert(picklist,scenario.allplayers[rangedpicks[pickindex]])
				if(prevranged)then					
					prevranged.FFpartner=scenario.allplayers[rangedpicks[pickindex]]
					scenario.allplayers[rangedpicks[pickindex]].FFpartner=prevranged
					--print("ranged partner")
				end
				prevranged=scenario.allplayers[rangedpicks[pickindex]]
				--print("Pick ranged ",rangedpicks[pickindex])
				tremove(rangedpicks,pickindex)
			end
			local mirrorpicks={3,4,5,6,7,8,9,10}
			for i=mirrorcount+1,mirrortotal do
				local pickindex=math.floor(math.random()*#mirrorpicks)+1
				tinsert(picklist,scenario.allplayers[mirrorpicks[pickindex]])
				if(prevmirror)then					
					prevmirror.FFpartner=scenario.allplayers[mirrorpicks[pickindex]]
					scenario.allplayers[mirrorpicks[pickindex]].FFpartner=prevmirror
					--print("mirror partner")
				end
				prevmirror=scenario.allplayers[mirrorpicks[pickindex]]
				--print("Pick mirror ",mirrorpicks[pickindex])				
				tremove(mirrorpicks,pickindex)
			end	
			--print("Player partner:",scenario.player.FFpartner)
	

			XPRACTICE.ShuffleList(picklist)
			for i=1,#picklist do
				local symbol=REDX
				if(i==1)then
					symbol=PURPLEDIAMOND
				elseif(i==2)then
					symbol=YELLOWSTAR
				elseif(i==3)then
					symbol=ORANGECIRCLE
				end
				local player=picklist[i]
				if(not player.murloc)then
					player:CreateSpeechBubble("Fatal Finesse ("..i..symbol..") on "..player.playername)
				else
					player:CreateSpeechBubble("Skrgl mrrrggk n br mmmrk")
				end
				
				player.fatalfinesse=true
				--print("mark FF player",player,true)
				
				local telegraph=XPRACTICE.INDIGNATION.FatalFinesseDropTelegraph.new()
				telegraph:Setup(player.environment,player.position.x,player.position.y,0)
				telegraph.player=player
				telegraph.symbol=symbol
				if(playerpick)then telegraph.playersoakoptional=true end
				if(scenario.player:IsDeadInGame())then telegraph.playersoakoptional=true end
				
				
				--telegraph.playersoakoptional=false -- debug only
				
				if(player.mirrorrealm) then 
					telegraph.singledouble=mirrortotal -- 1 is single, 2 is double					
				else
					telegraph.singledouble=rangedtotal
				end
				telegraph.mirrorrealm=player.mirrorrealm
				telegraph.scenario=self.scenario
				telegraph.fatalfinessecount=scenario.fatalfinessecount
				player.telegraph=telegraph
			end
			
			--this callback is necessary because the queued FF spell has a cast delay and we can't check seeds until it runs
			--we check 3 times, once for every drop, but callback is nil after first check so it only runs once
			if(self.scenario.fatalfinessecallback)then
				local event={}
				event.time=self.scenario.game.environment_gameplay.localtime+0.1
				event.func=function(scenario)		
					if(scenario.fatalfinessecallback)then
						scenario:fatalfinessecallback()
						scenario.fatalfinessecallback=nil
					end
				end
				--event.alwayshappens=true				
				tinsert(self.scenario.events,event)				
			end	
			
			
		end

		--static!
		function class.InitFatalFinesseCounts(scenario)
			local reversecount
			local i=math.random()
			--print("rand:",i)
			if(i<0.3)then
				reversecount=1
			elseif(i<0.67)then
				reversecount=2
			else
				reversecount=3
			end
			scenario.reversedoubleseedcount=reversecount
			scenario.reversedoubleseedtracker={false,false,false,false,false,false,false}
			local seedchooser={1,2,3,4,5,6,7}			
			for i=1,reversecount do
				local choiceindex=math.floor(math.random()*#seedchooser)+1
				local choice=seedchooser[choiceindex]
				scenario.reversedoubleseedtracker[choice]=true
				--print("chose",choice)
				tremove(seedchooser,choiceindex)
			end
		end
	end


	do
		local super=XPRACTICE.WoWObject
		XPRACTICE.INDIGNATION.FatalFinesseDropTelegraph=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.INDIGNATION.FatalFinesseDropTelegraph
		
		--"within 9 yards"
		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.scale=9.0*(3/12.0)
			self.alivetime=0
			self.state=0
			self.spawnedghost=false
		end

		function class:SetDefaultAnimation()
			self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileSpawnCustomDuration)
			self.projectilespawncustomduration=0.25
			self.projectileloopcustomduration=5.0-0.25
			self.projectiledespawncustomduration=0.25
		end	

		function class:SetActorAppearanceViaOwner(actor)
			actor:SetModelByFileID(3642468)	-- target_anima_revendreth_state_rimonly.m2		
		end
		
		function class:Step(elapsed)
			super.Step(self,elapsed)
			self.alivetime=self.alivetime+elapsed
						
			if(self.player and not self.player.dead)then
				self.position={x=self.player.position.x,y=self.player.position.y,z=0}
				if(math.floor(self.alivetime)>self.state)then	 -- this check prevents us from calling new state on every frame
					self.state=math.floor(self.alivetime)
					local message=nil
					if(self.state>=2 and self.state<=4)then
						message=self.symbol.." "..tostring(5-self.state)
					end

					if(message)then
						if(not self.player.murloc)then
							self.player:CreateSpeechBubble(message)
						else
							self.player:CreateSpeechBubble("N")
						end
					end
								
				end			
				--denathrius ghost cleave at about 4.5
				if(self.spawnedghost==false and self.alivetime>4.5)then
					self.spawnedghost=true
					local ghost=XPRACTICE.INDIGNATION.FatalFinesseGhostFlourish.new()
					local angle=math.random()*math.pi*2
					ghost:Setup(self.environment,self.position.x-math.cos(angle)*3,self.position.y-math.sin(angle)*3,0)
					ghost.orientation_displayed.yaw=angle
				end
			end
		end
		
		function class:OnProjectileDespawning()
			if(not self.scenario)then return end
			
			--TODO: FF small explosion effect?
			
			if(self.player==self.scenario.player)then
				self.scenario.collision:CheckPlayerFFCleaveGhosts(self)
				self.scenario.collision:CheckPlayerNearFFCamp()
			else
				self.scenario.collision:CheckGhostsFFCleavePlayer(self)
			end
			
			--print(self.player.mirrorrealm,self.scenario.player.mirrorrealm)
			if(self.player.mirrorrealm~=self.scenario.player.mirrorrealm)then
				--don't need graphics for same-phase
				local telegraph=XPRACTICE.INDIGNATION.FatalFinesseSoakTelegraph.new()
				telegraph.playersoakoptional=self.playersoakoptional
				telegraph.singledouble=self.singledouble
				telegraph:Setup(self.environment,self.position.x,self.position.y,0)
				telegraph.scenario=self.scenario
				telegraph.fatalfinessecount=self.fatalfinessecount
				telegraph.mirrorrealm=self.mirrorrealm
				telegraph.player=self.player
				self.soaktelegraph=telegraph
				-- add seeds to scenario list
				-- (but 7th drop doesn't count)
				if(self.scenario.fatalfinessecount<7)then					
					tinsert(self.scenario.seeds,telegraph)
				end
				if(self.player.ffcamp)then
					self.player.ffcamp.seed=telegraph
				end
			end

			--we check 3 times, once for every drop, but callback is nil after first check so it only runs once
			if(self.scenario.dropseedscallback)then
				local event={}
				event.time=self.scenario.game.environment_gameplay.localtime+0.1
				event.func=function(scenario)		
					if(scenario.dropseedscallback)then
						scenario:dropseedscallback()
						scenario.previousdropseedscallback=scenario.dropseedscallback
						scenario.dropseedscallback=nil
					end
				end
				--event.alwayshappens=true				
				tinsert(self.scenario.events,event)				
			end				
							
		end
	end



	do
		local super=XPRACTICE.WoWObject
		XPRACTICE.INDIGNATION.FatalFinesseSoakTelegraph=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.INDIGNATION.FatalFinesseSoakTelegraph
		
		--10 seconds
		--need 15 total soaks to clear
		--checks every 0.7 seconds
		
		--"within 3 yards"
		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.scale=3.0*(3/12.0)
			self.alivetime=0
			self.nexttick=0.7
			self.playersoakrate=3
			self.playerpartnersoakmultiplier=0.5
			self.ghostsoakrate=1	-- remember ghosts have travel time too.  8 ticks expected, leaving 7 soaks for player
			self.soakmultiplier=1
			self.ghostsoakstarttick=5
			self.tickcount=0
			self.state=0
			self.soaksremaining=15
		end
		function class:CreateAssociatedObjects()
			local orb=XPRACTICE.INDIGNATION.FatalFinesseSoakOrb.new()
			orb:Setup(self.environment,self.position.x,self.position.y,7.5)
			orb.telegraph=self
			self.orb=orb
			--9fx_generic_anima_revendreth_precast_hand_high.m2?
		end

		function class:SetDefaultAnimation()
			self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileSpawnCustomDuration)
			self.projectilespawncustomduration=0.25
			self.projectileloopcustomduration=nil
			self.projectiledespawncustomduration=0.25
		end	

		function class:SetActorAppearanceViaOwner(actor)
			actor:SetModelByFileID(3642468)	-- target_anima_revendreth_state_rimonly
		end
		
		function class:Step(elapsed)
			super.Step(self,elapsed)
			self.alivetime=self.alivetime+elapsed
			if(self.alivetime>=self.nexttick)then
				self.nexttick=self.nexttick+0.7
				self.tickcount=self.tickcount+1
				local partner=nil
				if(self.player.FFpartner)then 
					partner=self.player.FFpartner.telegraph.soaktelegraph
				end
					
				if(self.tickcount>self.ghostsoakstarttick)then
					local optionalmultiplier=1
					if(self.playersoakoptional or self.scenario.player:IsDeadInGame())then
						optionalmultiplier=3
					end
					if(self.fatalfinessecount<7)then
						self.soaksremaining=self.soaksremaining-self.ghostsoakrate*self.soakmultiplier*optionalmultiplier
					end
				end
				if(self.scenario.player and not self.scenario.player.dead)then
					local scenario=self.scenario
					local player=self.scenario.player
					local distx=player.position.x-self.position.x
					local disty=player.position.y-self.position.y
					local distsqr=distx*distx+disty*disty
					if(distsqr<=3*3)then
						self.soaksremaining=self.soaksremaining-self.playersoakrate*self.soakmultiplier							
						--print("Remaining",self.soaksremaining)
						if(partner)then							
							partner.soaksremaining=partner.soaksremaining-self.playersoakrate*self.playerpartnersoakmultiplier
							--print("partner!",partner.soaksremaining)
						end
						if(scenario.playershouldntsoak)then
							if(XPRACTICE_SAVEDATA.INDIGNATION.killplayerforunnecessarysoak==true)then
								scenario:AttemptKillPlayer(1,"You died from soaking Smoldering Ire while Fatal Finesse was still active.")
							end
						end						
					end			
				end
				if(self.soaksremaining<=0)then
					self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileDespawnCustomDuration)
					if(partner)then
						--print("Soakmultiplier 2")
						partner.soakmultiplier=2
					end
				else
					if(self.tickcount>=14)then
						local ok=false
						if(self.playersoakoptional)then ok=true end
						if(self.fatalfinessecount>=7)then ok=true end
												
						self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileDespawnCustomDuration)
						if(not ok)then
							self.scenario:AttemptKillPlayer(1,"You died from a Smoldering Ire explosion.",false)
						end
					end
				end
			end
		end

	end



	do
		local super=XPRACTICE.WoWObject
		XPRACTICE.INDIGNATION.FatalFinesseSoakOrb=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.INDIGNATION.FatalFinesseSoakOrb
		
		--10 seconds
		--need 15 total soaks to clear
		--checks every 0.7 seconds
		
		local MAX_SCALE=2.5
		local MIN_SCALE=0.5
		
		--"within 3 yards"
		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.scale=MAX_SCALE
			self.alivetime=0
			self.state=0			
		end

		function class:SetDefaultAnimation()
			self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileSpawnCustomDuration)
			self.projectilespawncustomduration=0.25
			self.projectileloopcustomduration=nil
			self.projectiledespawncustomduration=0.25
		end	

		function class:SetActorAppearanceViaOwner(actor)
			--actor:SetModelByFileID(3490420)	-- 9fx_generic_anima_revendreth_precast_hand_high
			actor:SetModelByFileID(1784199)	-- 7fx_deathtitan_volatileorb_state_red
		end
		
		function class:Step(elapsed)
			super.Step(self,elapsed)
			if(self.telegraph)then
				self.scale=MIN_SCALE+(MAX_SCALE-MIN_SCALE)*(self.telegraph.soaksremaining/15)
				if(self.telegraph.dead)then
					self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileDespawnCustomDuration)
					self.telegraph=nil
				end
			end
		end
	end
	
	
	do
		local super=XPRACTICE.WoWObject
		XPRACTICE.INDIGNATION.FatalFinesseGhostFlourish=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.INDIGNATION.FatalFinesseGhostFlourish
		
		function class:Setup(environment,x,y,z)
			super.Setup(self,environment,x,y,z)
			self.animationmodule:PlayAnimation(XPRACTICE.INDIGNATION.AnimationList.CombatWhirlwind)			
		end
		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.scale=3
					--2.0 from spawn until channel ends
					--5.75 after the channel ends
			self.fadestarttime=self.environment.localtime+1.00
			self.expirytime=self.fadestarttime+0.05
		end		
		function class:SetActorAppearanceViaOwner(actor)			
			actor:SetModelByCreatureDisplayID(96951)
			actor:SetSpellVisualKit(131725)			
		end
	end

end



--[[
	Check archives for soak timing notes.
]]--
