do
	XPRACTICE.PAINSMITH.AnimationList={}
	----XPRACTICE.AnimationTemplate.QuickSetup(animationlist,			name,		index,	subindex,	priority,	duration,	nextanimation)
	--XPRACTICE.AnimationTemplate.QuickSetup(XPRACTICE.PAINSMITH.AnimationList,"-",5,	0,			"Active",	0.25,		nil)
	XPRACTICE.AnimationTemplate.QuickSetup(XPRACTICE.PAINSMITH.AnimationList,"Close",146,		0,			"Active",	0.5,		nil)
	XPRACTICE.AnimationTemplate.QuickSetup(XPRACTICE.PAINSMITH.AnimationList,"Opened",149,		0,			"Active",	0.5,		XPRACTICE.PAINSMITH.AnimationList.Close)
	XPRACTICE.AnimationTemplate.QuickSetup(XPRACTICE.PAINSMITH.AnimationList,"Open",148,		0,			"Active",	0.5,		XPRACTICE.PAINSMITH.AnimationList.Opened)
	--XPRACTICE.AnimationTemplate.QuickSetup(XPRACTICE.PAINSMITH.AnimationList,"Open",149,		0,			"Active",	1.0,		nil)
	XPRACTICE.AnimationTemplate.QuickSetup(XPRACTICE.PAINSMITH.AnimationList,"CustomSpell02",214,		0,			"Active",	0.5,		XPRACTICE.PAINSMITH.AnimationList.Open)
	
	--XPRACTICE.AnimationTemplate.QuickSetup(XPRACTICE.PAINSMITH.AnimationList,"CustomSpell01",213,		0,			"Active",	0.5,		XPRACTICE.PAINSMITH.AnimationList.CustomSpell02)
	XPRACTICE.AnimationTemplate.QuickSetup(XPRACTICE.PAINSMITH.AnimationList,"SpikedBallFall",40,		0,			"Passive",	1.0,		nil)
	XPRACTICE.AnimationTemplate.QuickSetup(XPRACTICE.PAINSMITH.AnimationList,"SpikedBallDestroy",150,		0,			"Active",	1.0,		nil)

	XPRACTICE.AnimationTemplate.QuickSetup(XPRACTICE.PAINSMITH.AnimationList,"BattleRoar",55,	0,				"Active",	1.0,nil)

	do	
		local super=XPRACTICE.GameObject
		XPRACTICE.PAINSMITH.SpikesRow=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.PAINSMITH.SpikesRow
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.rowcount=14
			self.movetimer=0
			self.safespot=nil
		end
		
		function class:Step(elapsed)
			super.Step(self,elapsed)
			self.movetimer=self.movetimer-elapsed
			--print("!",self.movetimer)
			if(self.movetimer<=0)then
				--print("!",self.movetimer)
				self.movetimer=self.movetimer+XPRACTICE.PAINSMITH.Config.IntermissionSpikeMoveRate				
				self.rowcount=self.rowcount-1
				for i=1,13 do
					if(i~=self.safespot)then								
						--local telegraphbox=XPRACTICE.PAINSMITH.SpikesTelegraphBox.new()
						--telegraphbox:Setup(self.environment,XPRACTICE.PAINSMITH.Config.ArenaTileSize*(i+0.5),XPRACTICE.PAINSMITH.Config.ArenaTileSize*(self.rowcount+0.5),XPRACTICE.PAINSMITH.Config.IntermissionSpikeTelegraphBoxZOffset)					
						for j=1,3 do
							local telegraph=XPRACTICE.PAINSMITH.SpikesTelegraph.new()
							telegraph:Setup(self.environment,XPRACTICE.PAINSMITH.Config.ArenaTileSize*(i+0.5),XPRACTICE.PAINSMITH.Config.ArenaTileSize*(self.rowcount+0.5),XPRACTICE.PAINSMITH.Config.IntermissionSpikeTelegraphZOffset)
						end
						local spikes=XPRACTICE.PAINSMITH.Spikes.new()
						spikes:Setup(self.environment,XPRACTICE.PAINSMITH.Config.ArenaTileSize*(i+0.5),XPRACTICE.PAINSMITH.Config.ArenaTileSize*(self.rowcount+0.5),0)
						spikes.scenario=self.scenario
						tinsert(self.scenario.spikes,spikes)
					end
				end
				if(self.rowcount==1)then self:Die() end
			end
		end
		
		
		
	end

	do
		--4004996 --9mw_domination_bossfloorspiketrap05
		local super=XPRACTICE.WoWObject
		XPRACTICE.PAINSMITH.SpikesTelegraphBox=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.PAINSMITH.SpikesTelegraphBox
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)	
			self.expirytime=self.environment.localtime+XPRACTICE.PAINSMITH.Config.IntermissionSpikeTelegraphBoxDuration			
			--self.expirytime=self.environment.localtime+1.25
			--self.alivetime=0
			self.scale=XPRACTICE.PAINSMITH.Config.IntermissionSpikeTelegraphBoxScale
		end
		function class:SetActorAppearanceViaOwner(actor)
			actor:SetModelByFileID(4043121)	--9fx_raid2_trapmaster_spiketrap_state
			--actor:SetModelByFileID(996266)	--box_001
			--actor:SetModelByFileID(3088272)	--box_001gray
			--actor:SetSpellVisualKit(114731) --transparent cyan
		end
		function class:SetDefaultAnimation()
			self.animationmodule:PlayAnimation(XPRACTICE.PAINSMITH.AnimationList.CustomSpell02)
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
		--4004996 --9mw_domination_bossfloorspiketrap05
		local super=XPRACTICE.WoWObject
		XPRACTICE.PAINSMITH.SpikesTelegraph=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.PAINSMITH.SpikesTelegraph
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)	
			--self.expirytime=self.environment.localtime+XPRACTICE.PAINSMITH.Config.IntermissionSpikeTelegraphDuration			
			self.expirytime=self.environment.localtime+3
			--self.alivetime=0
			self.scale=XPRACTICE.PAINSMITH.Config.IntermissionSpikeTelegraphScale
		end
		function class:SetActorAppearanceViaOwner(actor)
			actor:SetModelByFileID(4043121)	--9fx_raid2_trapmaster_spiketrap_state
			--actor:SetModelByFileID(996266)	--box_001
			--actor:SetModelByFileID(3088272)	--box_001gray
			--actor:SetSpellVisualKit(114731) --transparent cyan
		end
		function class:SetDefaultAnimation()
			self.animationmodule:PlayAnimation(XPRACTICE.PAINSMITH.AnimationList.CustomSpell02)
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
		--4004996 --9mw_domination_bossfloorspiketrap05
		local super=XPRACTICE.WoWObject
		XPRACTICE.PAINSMITH.Spikes=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.PAINSMITH.Spikes
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)	
			--self.expirytime=self.environment.localtime+XPRACTICE.PAINSMITH.Config.IntermissionSpikeTelegraphDuration			
			self.expirytime=self.environment.localtime+3
			self.alivetime=0
		end
		function class:SetActorAppearanceViaOwner(actor)
			actor:SetModelByFileID(4004996)	--9mw_domination_bossfloorspiketrap05
		end
		function class:SetDefaultAnimation()
			self.animationmodule:PlayAnimation(XPRACTICE.PAINSMITH.AnimationList.CustomSpell02)
		end	
		function class:Step(elapsed)
			super.Step(self,elapsed)
			self.alivetime=self.alivetime+elapsed
			-- if(self.alivetime>0.5 and self.alivetime<1.5)then
				-- local scenario=self.scenario
				-- local player=scenario.player
				-- if(player)then
					-- if(not player:IsDeadInGame())then
						-- local auras=player.combatmodule.auras:GetAurasByClassIfExist(XPRACTICE.PAINSMITH.Aura_PallyBubble)
						-- if(#auras==0)then --TODO: check lock portal
							-- local x1=self.position.x-XPRACTICE.PAINSMITH.Config.ArenaTileSize/2-XPRACTICE.PAINSMITH.Config.IntermissionSpikeExtraHitboxSize
							-- local x2=self.position.x+XPRACTICE.PAINSMITH.Config.ArenaTileSize/2+XPRACTICE.PAINSMITH.Config.IntermissionSpikeExtraHitboxSize
							-- local y1=self.position.y-XPRACTICE.PAINSMITH.Config.ArenaTileSize/2-XPRACTICE.PAINSMITH.Config.IntermissionSpikeExtraHitboxSize
							-- local y2=self.position.y+XPRACTICE.PAINSMITH.Config.ArenaTileSize/2+XPRACTICE.PAINSMITH.Config.IntermissionSpikeExtraHitboxSize
							-- if(player.position.x>=x1 and player.position.x<=x2)then
								-- if(player.position.y>=y1 and player.position.y<=y2)then
									-- local aura=player.combatmodule:ApplyAuraByClass(XPRACTICE.Aura_DeadInGame,player.combatmodule,player.environment.localtime)	
									-- scenario.statuslabel:SetText("Died from floor spikes.",3.0)
									-- --scenario.multiplayer:FormatAndSendCustom("DEAD_FLOORSPIKES")
								-- end
							-- end
						-- end
					-- end
				-- end
			-- end
			-- --self.alivetime=self.alivetime+elapsed
			-- self.displayobject.drawable:SetAnimation(214)
			-- --self.alpha=self.alivetime/XPRACTICE.PAINSMITH.Config.IntermissionSpikeTelegraphDuration
		end
		
		
	end			
end