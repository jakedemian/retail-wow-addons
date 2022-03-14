do
	
	do	
		local super=XPRACTICE.Spell
		XPRACTICE.INDIGNATION.Spell_Massacre=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.INDIGNATION.Spell_Massacre
		
		
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)

			self.name="Massacre"
			self.icon="interface/icons/spell_shadow_charm.blp"

			self.requiresfacing=false		
			self.projectileclass=nil	
			self.basecastduration=0.0
			self.basechannelduration=nil
			self.basechannelticks=nil			
		end
		

		function class:CompleteCastingEffect(castendtime,spellinstancepointer)	
			self.scenario.massacrecontroller:Activate()
		end
	end


	do	
		local super=XPRACTICE.Spell
		XPRACTICE.INDIGNATION.Spell_Massacre_SingleLine=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.INDIGNATION.Spell_Massacre_SingleLine
		
		
		
		function class:SetCustomInfo()
			super.SetCustomInfo(self)

			self.name="Massacre (Single Line)"
			self.icon="interface/icons/ability_revendreth_warrior.blp"

			self.requiresfacing=false		
			self.projectileclass=nil	
			self.basecastduration=0.0
			self.basechannelduration=nil
			self.basechannelticks=nil
		end
		

		function class:CompleteCastingEffect(castendtime,spellinstancepointer)	
			-- local telegraph=XPRACTICE.INDIGNATION.MassacreTelegraph_Rectangle003.new()
			-- telegraph.originindex=math.floor(math.random()*12)+1			
			-- telegraph:Setup(self.scenario.game.environment_gameplay)			
			-- if(not telegraph.oob)then				
				-- telegraph:Start()
			-- end			
		end
	end


	do	
		local super=XPRACTICE.GameObject
		XPRACTICE.INDIGNATION.MassacreController=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.INDIGNATION.MassacreController

		-- in order: 123 465 879 CBA
		local ORIGININDEX_ORDER={1,2,3,4,6,5,8,7,9,12,11,10}

		--TODO: how many aim directly at player?

		function class:SetCustomInfo()
			super.SetCustomInfo(self)
			self.enabled=false
			self.swordcount=0
			self.totalswords=12 --TODO: savedata
			self.swordtimer=1.0
			self.targetrealms={}
		end

		function class:Step(elapsed)
			super.Step(self,elapsed)
			--print("STEP",elapsed,self.enabled)
			if(self.enabled)then
				self.swordtimer=self.swordtimer-elapsed
				if(self.swordtimer<=0)then
					local origin=(self.swordcount%12)+1
					local telegraph=XPRACTICE.INDIGNATION.MassacreTelegraph_Rectangle003.new()				
					telegraph.originindex=ORIGININDEX_ORDER[origin]
					--print("Telegraph #",origin,"index",ORIGININDEX_ORDER[origin])
					local targetrealm=self.targetrealms[self.swordcount%12+1]					
					local targetplayerindex					
					local mirror=false
					if(targetrealm==1)then
						mirror=true
						targetplayerindex=math.floor(math.random()*10)+1
					else
						targetplayerindex=math.floor(math.random()*10)+11
					end
					telegraph.targetplayer=self.scenario.allplayers[targetplayerindex]
					--print("target",targetrealm,targetplayerindex)
					-- we could also target the player instead of ghosts...
					if(math.random()<.2)then
						if(self.scenario.player.mirrorrealm==mirror)then
							telegraph.targetplayer=self.scenario.player
						end
					end					
					telegraph.scenario=self.scenario
					telegraph:Setup(self.environment)
					if(not telegraph.oob)then				
						telegraph:Start()
						self.swordcount=self.swordcount+1
						if(self.swordcount%3~=0)then						
							self.swordtimer=self.swordtimer+XPRACTICE.Config.Indignation.MassacreTimeBetweenSwords
						else
							self.swordtimer=self.swordtimer+XPRACTICE.Config.Indignation.MassacreTimeBetweenTriplets
						end
						if(self.swordcount>=self.totalswords)then
							self:Deactivate()
						end
					end					
				end
			end
		end
		
		function class:Activate()
			self.swordcount=0
			self.enabled=true
			self.targetrealms={1,1,1,1,1,1,2,2,2,2,2,2}
			XPRACTICE.ShuffleList(self.targetrealms)		
		end
		function class:Deactivate()
			self.enabled=false
		end		
	end
	
end