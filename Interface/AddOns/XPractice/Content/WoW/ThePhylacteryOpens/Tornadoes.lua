do
	do	
		local super=XPRACTICE.Spell
		XPRACTICE.KELTHUZADMULTIPLAYER.Spell_TornadoesMulti=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.KELTHUZADMULTIPLAYER.Spell_TornadoesMulti
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.name="Glacial Winds"		
			self.icon="interface/icons/ability_skyreach_four_wind.blp"
			self.queuespellname="Tornadoes"
			self.requiresfacing=false;self.projectileclass=nil;self.basecastduration=0.0;self.basechannelduration=nil;self.basechannelticks=nil
		end
				
		function class:CompleteCastingEffect(castendtime,spellinstancepointer)	
			local scenario=spellinstancepointer.castercombat.mob.scenario		
			scenario.multiplayer:FormatAndSendCustom("QUEUE_CYCLO")
		end
	end		
	

	do
		local super=XPRACTICE.Spell
		XPRACTICE.KELTHUZADMULTIPLAYER.Spell_Tornadoes = XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.KELTHUZADMULTIPLAYER.Spell_Tornadoes
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)

			self.name="Glacial Winds"
			self.icon="interface/icons/ability_skyreach_four_wind.blp"

			self.requiresfacing=false		
			self.projectileclass=nil		
			self.basecastduration=XPRACTICE.KELTHUZADMULTIPLAYER.Config.TornadoCastTime
			self.basechannelduration=nil		
			self.basechannelticks=nil
			self.tickonchannelstart=false
			self.usablewhilemoving=true
		end
		
		function class:Broadcast(scenario)
			local boss=scenario.boss
			local angle=XPRACTICE.WrapAngle(math.random()*math.pi*2)
			scenario.multiplayer:FormatAndSendCustom("CAST_CYCLO",angle)	
		end		
		
		function class:StartCastingEffect(spellinstancepointer)
			local boss=spellinstancepointer.castercombat.mob
			local scenario=boss.scenario
			-- local allplayers=scenario.allplayers
			-- local players={}
			-- local player=nil
			-- for i=1,#allplayers do
				-- if(allplayers[i].inphase and not allplayers[i]:IsDeadInGame())then
					-- tinsert(players,allplayers[i])
				-- end				
			-- end
			-- if(#players>0)then
				-- local i=math.floor(math.random()*#players)+1
				-- player=players[i]
			-- end
			-- local angle=boss.orientation.yaw
			-- if(player)then
				-- angle=math.atan2(player.position.y-boss.position.y,player.position.x-boss.position.x)
				-- boss.orientation.yaw=angle
			-- end
			--animation doesn't loop into itself, so we can't use CastingAnimationFunction
			if(scenario.currentphase==3)then
				boss.animationmodule:PlayAnimation(XPRACTICE.KELTHUZADMULTIPLAYER.AnimationList.MagSpellPrecastBoth_Phase3)
			else
				boss.animationmodule:PlayAnimation(XPRACTICE.KELTHUZADMULTIPLAYER.AnimationList.MagSpellPrecastBoth)
			end			
		end
		
		-- function class:CastingAnimationFunction(spellinstancepointer)	
			-- --spellinstancepointer.castercombat.mob.animationmodule:TryDirectedSpellcast()
			-- spellinstancepointer.castercombat.mob.animationmodule:PlayAnimation(XPRACTICE.KELTHUZADMULTIPLAYER.AnimationList.MagSpellPrecastBoth)
		-- end
		-- function class:ChannelingAnimationFunction(spellinstancepointer)				
			-- spellinstancepointer.castercombat.mob.animationmodule:TryOmniChannel()
		-- end
		function class:CompleteCastingAnimationFunction(spellinstancepointer)				
			local scenario=spellinstancepointer.castercombat.mob.scenario
			--if(scenario.currentphase==3)then
			if(false)then
				spellinstancepointer.castercombat.mob.animationmodule:PlayAnimation(XPRACTICE.KELTHUZADMULTIPLAYER.AnimationList.SpellCastDirected_Phase3)
			else
				spellinstancepointer.castercombat.mob.animationmodule:PlayAnimation(XPRACTICE.KELTHUZADMULTIPLAYER.AnimationList.SpellCastDirected)
			end
		end

		function class:CompleteCastingEffect(castendtime,spellinstancepointer)							
			local scenario=spellinstancepointer.scenario
			local boss=scenario.boss
			local initialangle=spellinstancepointer.savedangle
			for i=1,3 do
				local torn=XPRACTICE.KELTHUZADMULTIPLAYER.Tornado.new()
				torn:Setup(boss.environment)
				torn.index=i
				--torn.initialangle=boss.orientation.yaw
				torn.initialangle=initialangle
				local x,y=torn:GetPosition(0)
				torn.position.x=x
				torn.position.y=y	
				tinsert(scenario.tornadoes,torn)
			end						
		end
	end
	
	
	do	
		local super=XPRACTICE.WoWObject
		XPRACTICE.KELTHUZADMULTIPLAYER.Tornado=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.KELTHUZADMULTIPLAYER.Tornado
		function class:SetActorAppearanceViaOwner(actor)
			actor:SetModelByFileID(2529592) -- 8fx_jaina_blisteringtornado (0,158,159)
			self.scale=XPRACTICE.KELTHUZADMULTIPLAYER.Config.TornadoScale
			self.displayedpositionoffset={x=0,y=0,z=XPRACTICE.KELTHUZADMULTIPLAYER.Config.SwirlZOffset}
		end
		function class:SetDefaultAnimation()
			self.animationmodule:PlayAnimation(XPRACTICE.AnimationList.ProjectileSpawnCustomDuration)
			self.projectilespawncustomduration=1.0
			self.projectiledespawncustomduration=0.5
			self.projectileloopcustomduration=XPRACTICE.KELTHUZADMULTIPLAYER.Config.TornadoDuration-self.projectilespawncustomduration-self.projectiledespawncustomduration
		end	
		function class:GetPosition(realtime)
			if(true)then
				return XPRACTICE.KELTHUZADMULTIPLAYER.Tornado.GetPositionSpiral(self,realtime)
			else
				return XPRACTICE.KELTHUZADMULTIPLAYER.Tornado.GetPositionTripleCircle(self,realtime)
			end
		end
		function class:GetPositionSpiral(realtime)
			local t=realtime/XPRACTICE.KELTHUZADMULTIPLAYER.Config.TornadoDuration
			local maxdist=20
			local mindist=4
			local dist=t*(maxdist-mindist)+mindist
			local offset=math.pi/2+self.index*(math.pi*0.5)/2+self.initialangle
			local loops=2.5
			local angle=t*(math.pi*2*loops)+offset
			local x=dist*math.cos(angle)
			local y=dist*math.sin(angle)
			return x,y
		end
		function class:GetPositionTripleCircle(realtime)
			local t=realtime/XPRACTICE.KELTHUZADMULTIPLAYER.Config.TornadoDuration
			local offsetx=-3	--TODO:
			local offsety=0		--TODO:
			local maxdist=18
			local middist=10
			local mindist=2
			--local dist=t*(maxdist-mindist)+mindist
			if(t<0.2)then 
				dist=(t/0.2)*(middist-mindist)+mindist
			elseif(t>=0.2 and t<0.5)then dist=middist
			elseif(t>=0.5 and t<0.7)then
				dist=((t-0.5)/0.2)*(maxdist-middist)+middist
			elseif(t>=0.7)then dist=maxdist
			end
			local offset=math.pi/2+self.index*(math.pi*0.5)/2+self.initialangle
			local loops=2.0
			local angle=t*(math.pi*2*loops)+offset
			-- if(t<0.4)then angle=t*(math.pi*2*loops)+offset
			-- elseif(t>=0.4 and t<=0.6)then
			-- else
				-- angle=t*(math.pi*2*loops)
						-- +offset
			-- end
			local x=dist*math.cos(angle)+offsetx
			local y=dist*math.sin(angle)+offsety
			return x,y
		end		
		function class:Step(elapsed)
			super.Step(self,elapsed)
			self.alivetime=self.alivetime or 0
			self.alivetime=self.alivetime+elapsed
			local x,y=self:GetPosition(self.alivetime)
			self.position.x=x
			self.position.y=y
		end
	end
	
	----------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------
	----------------------------------------------------------------------------------------
	
	
	do
		local super=XPRACTICE.Spell
		XPRACTICE.KELTHUZADMULTIPLAYER.Spell_Tornadoes_Debug = XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.KELTHUZADMULTIPLAYER.Spell_Tornadoes_Debug
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)

			self.name="Glacial Winds"
			self.icon="interface/icons/ability_skyreach_four_wind.blp"

			self.requiresfacing=false		
			self.projectileclass=nil		
			self.basecastduration=0.0
			self.basechannelduration=nil		
			self.basechannelticks=nil
			self.tickonchannelstart=false
			self.usablewhilemoving=true
		end
		
		function class:StartCastingEffect(spellinstancepointer)
			local boss=spellinstancepointer.castercombat.mob
			local scenario=boss.scenario

			local initialangle=XPRACTICE.WrapAngle(math.random()*math.pi*2)
			for j=0,2 do
				local multi=XPRACTICE.MultiSolid.new()
				multi:Setup(boss.environment)
				for i=1,100 do
					--local t=i*(16/100)
					--local a=t+(j*math.pi*0.5/2)
					--local x=t*math.cos(a)
					--local y=t*math.sin(a)
					local t=5.0*(i/100)
					self.index=j
					self.initialangle=initialangle
					
					local x,y=XPRACTICE.KELTHUZADMULTIPLAYER.Tornado.GetPosition(self,t)
					local a=multi:AddActorByClass(XPRACTICE.SOLIDS.Box001,x,y,0.5,0.05,0)
					a:SetSpellVisualKit(6531)
				end
			end
			

		end

	end	
end