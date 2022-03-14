do

	do
		local super=XPRACTICE.WoWObject
		XPRACTICE.FATESCRIBEMULTIPLAYER.RingCenter=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.FATESCRIBEMULTIPLAYER.RingCenter
		
		function class:SetActorAppearanceViaOwner(actor)
			actor:SetModelByFileID(4037576)	--9mw_torghastraid_ringcenter01
			self.scale=1
			self.displayedpositionoffset={x=0,y=0,z=-1}
			self.orientation_displayed.yaw=-math.pi/2-math.pi/2
		end	
	end

	
	do	
		local super=XPRACTICE.WoWObject
		XPRACTICE.FATESCRIBEMULTIPLAYER.Floor=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.FATESCRIBEMULTIPLAYER.Floor
		
		function class:SetActorAppearanceViaOwner(actor)
			actor:SetModelByFileID(1591934)	--7du_tombofsargeras_councilfloor01
			self.scale=2.25
			local FLOORZ=-0.425*(2.25/3)-0.333
			self.displayedpositionoffset={x=0,y=0,z=FLOORZ}
		end
	end

	do
		local super=XPRACTICE.WoWObject
		XPRACTICE.FATESCRIBEMULTIPLAYER.DecorWindRadial=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.FATESCRIBEMULTIPLAYER.DecorWindRadial
		function class:SetActorAppearanceViaOwner(actor)
			actor:SetModelByFileID(4067420)	--9fx_raid2_korrath_fatescribe_windradialground_state
		end
		function class:SetDefaultAnimation()
			self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileSpawnCustomDuration)
			self.projectilespawncustomduration=0.4
			self.projectileloopcustomduration=XPRACTICE.FATESCRIBEMULTIPLAYER.Config.SwirlyWindDuration-0.8
			self.projectiledespawncustomduration=0.4
		end	
		function class:Step(elapsed)
			super.Step(self,elapsed)
			
			local scenario=self.scenario
			--apply pushback here, probably?
			for k,v in pairs(scenario.multiplayer.allplayers) do
				local player=v
				local auras=player.combatmodule.auras:GetAurasByClassIfExist(XPRACTICE.FATESCRIBEMULTIPLAYER.Aura_PallyBubble)
				if(#auras==0)then
					local angle=math.atan2(player.position.y,player.position.x)
					--print(k,"angle:",angle)
					local distsqr=player.position.x*player.position.x+player.position.y*player.position.y
					if(distsqr<=47.5*47.5)then
						local force=7.0*1.0
						player.position.x=player.position.x+math.cos(angle)*force*elapsed
						player.position.y=player.position.y+math.sin(angle)*force*elapsed
					end
				end
			end
		end
		function class:OnProjectileDespawned()
			class.Knockback(self.scenario)
			
			super.OnProjectileDespawned(self)
		end		
		function class.ApplyStampedingRoar(scenario)
			-- this is also a good time to apply stamp roar to the group.  do this before knockback because we exit early if player is immune
			for k,v in pairs(scenario.multiplayer.allplayers) do
				local ghost=v
				local aura=ghost.combatmodule:ApplyAuraByClass(XPRACTICE.Aura_StampedingRoar,ghost.combatmodule,ghost.localtime)
			end

			---- OOPS IT TURNS OUT INITIAL KNOCKBACK DOESN'T EXIST.  APPLY STAMEDING ROAR THEN QUIT
			if(true)then return end

			-- local player=scenario.player			
			-- local auras=player.combatmodule.auras:GetAurasByClassIfExist(XPRACTICE.FATESCRIBEMULTIPLAYER.Aura_PallyBubble)
			-- if(#auras>0)then return end
			-- local angle=math.atan2(player.position.y,player.position.x)
			-- local dist=math.sqrt(player.position.x*player.position.x+player.position.y*player.position.y)
			-- if(dist<=11.5)then
				-- player.velocity.z=100*(1/10)
				-- local xyvelocity=80*(1/10)	-- this is a smallish number because pushback is happening simultaneously
				-- player.velocity.x=math.cos(angle)*xyvelocity
				-- player.velocity.y=math.sin(angle)*xyvelocity
				-- scenario.multiplayer:SendMidair()				
			-- end
		end
		function class.Knockback(scenario)
			--TODO: must check ALL players for OOB if z>0
			local player=scenario.player
			local auras=player.combatmodule.auras:GetAurasByClassIfExist(XPRACTICE.FATESCRIBEMULTIPLAYER.Aura_PallyBubble)
			if(#auras>0)then return end
			
			local angle=math.atan2(player.position.y,player.position.x)
			local dist=math.sqrt(player.position.x*player.position.x+player.position.y*player.position.y)
			if(dist<=47.5)then
				player.velocity.z=100*(1/10) 	-- i'm not 100% satisfied with the player's trajectory compared to the video footage but we're running up against crunch time.
				local xyvelocity=400*(1/10)		
				player.velocity.x=math.cos(angle)*xyvelocity
				player.velocity.y=math.sin(angle)*xyvelocity
				scenario.multiplayer:SendMidair()
			end
		end
	end
	

end