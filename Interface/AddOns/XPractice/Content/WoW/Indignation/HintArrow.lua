do
	local super=XPRACTICE.WoWObject
	XPRACTICE.INDIGNATION.HintArrow=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.INDIGNATION.HintArrow
	
	function class:Setup(environment,x,y,z)
		super.Setup(self,environment,x,y,z)
		self.changecount=0
		self.prevx=nil
		self.prevy=nil
	end
	
	function class:Step(elapsed)
		local scenario=self.scenario
		if(scenario.player)then
			if(scenario.player.destx and scenario.player.desty and XPRACTICE_SAVEDATA.INDIGNATION.hintarrow==true)then
			--if(false)then				
				self.alpha=1
				self.position.x=scenario.player.destx
				self.position.y=scenario.player.desty		
				self.position.z=1				
				self.scale=2
				--print("!!!",scenario.player.destx,scenario.player.desty,self.scale)
				if(self.position.x~=self.prevx or self.position.y~=self.prevy)then
					self.changecount=self.changecount+1
					--print("ARROW",self.changecount,self.position.x,self.position.y)
				end
			else
				self.alpha=0
			end
		end
		self.prevx=self.position.x
		self.prevy=self.position.y	
	end
	
	function class:SetActorAppearanceViaOwner(actor)
		actor:SetModelByFileID(948186) --spells/arrow_state_animated.m2
	end
		
	
end

function XPRACTICE.INDIGNATION.QuickStampedingRoar(scenario)
	for i=1,#scenario.allplayers do
		local ghost=scenario.allplayers[i]
		local aura=ghost.combatmodule:ApplyAuraByClass(XPRACTICE.Aura_StampedingRoar,ghost.combatmodule,ghost.localtime)
	end
end