do
	do
		local super=XPRACTICE.WoWObject
		XPRACTICE.PAINSMITH.Swirl=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.PAINSMITH.Swirl
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)	
			self.scale=1.0
		end
		function class:SetActorAppearanceViaOwner(actor)
			actor:SetModelByFileID(1034184)	--target_fire_state_centeronly
			--actor:SetModelByFileID(3642466)	--target_anima_revendreth_state_centeronly
		end
		function class:SetDefaultAnimation()
			self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileSpawnCustomDuration)
			self.projectilespawncustomduration=0.25
			self.projectileloopcustomduration=XPRACTICE.PAINSMITH.Config.IntermissionSwirlTelegraphTime-self.projectilespawncustomduration
			self.projectiledespawncustomduration=0.25		
		end	
		
		function class:OnProjectileDespawning()
			local impact=XPRACTICE.PAINSMITH.SwirlImpact.new()
			impact:Setup(self.environment,self.position.x,self.position.y)
			if(self.adds)then
				local add=XPRACTICE.PAINSMITH.ShadowsteelHorror.new()
				add:Setup(self.environment,self.position.x,self.position.y)
				add:FreezeOrientation(math.random()*math.pi*2)
			end
			local scenario=self.scenario
			local player=scenario.player
			if(player)then
				if(not player:IsDeadInGame())then
					local auras=player.combatmodule.auras:GetAurasByClassIfExist(XPRACTICE.PAINSMITH.Aura_PallyBubble)
					if(#auras==0)then	--TODO: check lock portal
						local xdist=self.position.x-player.position.x
						local ydist=self.position.y-player.position.y
						local distsqr=xdist*xdist+ydist*ydist
						--print(distsqr)
						if(distsqr<=3.0*3.0)then
							local aura=player.combatmodule:ApplyAuraByClass(XPRACTICE.Aura_DeadInGame,player.combatmodule,player.environment.localtime)	
							scenario.statuslabel:SetText("Died from Shadowsteel Embers.",3.0)
							scenario.multiplayer:FormatAndSendCustom("DEAD_EMBERS")
						end
					end
				end
			end
		end
		
		
		-- function class:Step(elapsed)
			-- super.Step(self,elapsed)
			-- -- self.alivetime=self.alivetime+elapsed
			-- -- --self.alpha=self.alivetime/XPRACTICE.PAINSMITH.Config.IntermissionSpikeTelegraphDuration
			-- -- if(self.alivetime>=XPRACTICE.PAINSMITH.Config.IntermissionSpikeTelegraphDuration)then
				-- -- self:Die()
			-- -- end
		-- end
	end	
	

	do
		local super=XPRACTICE.WoWObject
		XPRACTICE.PAINSMITH.SwirlImpact=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.PAINSMITH.SwirlImpact
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)	
			self.scale=2.5
			self.expirytime=self.environment.localtime+1.0
		end
		function class:SetActorAppearanceViaOwner(actor)
			--actor:SetModelByFileID(1034184)	--target_fire_state_centeronly
			--actor:SetModelByFileID(166583)	--moltenblast_impact_chest
			actor:SetModelByFileID(166131)	--fireblast_impact_chest
		end
	end
	
	do
		local super=XPRACTICE.Mob
		XPRACTICE.PAINSMITH.ShadowsteelHorror=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.PAINSMITH.ShadowsteelHorror
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)	
			self.fadestarttime=self.environment.localtime+5.0
			self.expirytime=self.environment.localtime+7.0
			self.scale=1.5
		end
		function class:SetActorAppearanceViaOwner(actor)
			actor:SetModelByCreatureDisplayID(38549)	-- Shadowsteel Horror
		end
	end
	
end