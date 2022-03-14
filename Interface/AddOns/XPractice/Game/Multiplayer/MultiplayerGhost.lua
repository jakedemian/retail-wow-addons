
do
	local super=XPRACTICE.Mob
	XPRACTICE.MULTIPLAYER.MultiplayerGhost=XPRACTICE.inheritsFrom(XPRACTICE.Mob)
	local class=XPRACTICE.MULTIPLAYER.MultiplayerGhost
	
	function class:SetCustomInfo()
		super.SetCustomInfo(self)
				
		self.targetghostalpha=1
		self.ghostalpha=1
		self.ghostalphamultiplier=1.0
		self.enabled=false
		self.destx=nil
		self.desty=nil
		self.multidestx=nil
		self.multidesty=nil
		self.playername=self.playername or "[Unknown]"
		self.officer=false
		
	end	
	function class:CreateDisplayObject()
		self.displayobject=XPRACTICE.ModelSceneActor.new()
		self.displayobject:Setup(self)
		self.displayobject.drawable:SetModelByCreatureDisplayID(67812) -- murky (murky is missing a lot of animations.  will that be a problem?)
		--self.displayobject.drawable:SetModelByUnit("player")
	end	
	function class:CreateAssociatedObjects()
		local nameplate=XPRACTICE.PlayerNameplate.new()
		nameplate:Setup(self.environment,self)
		local name,server=strsplit("-",self.playername)
		local myname,myserver=UnitFullName("player")
		if(server==myserver)then
			nameplate:SetText(name)
		else
			nameplate:SetText(name.." (*)")
		end
		--nameplate:SetSelected(false)
		nameplate:SetSelected(true)
		local mobclickzone=XPRACTICE.MobClickZone.new()
		mobclickzone:Setup(self.environment,self)
	end

	function class:CreateCombatModule()
		super.CreateCombatModule(self)
		local spell_roll=XPRACTICE.Spell_Roll.new()
		spell_roll:Setup(self.combatmodule)
		--TODO: don't hardcode roll.  it's already spellbook[1]
		self.combatmodule.spellbook.roll=spell_roll
	end	
	function class:Step(elapsed)
		super.Step(self,elapsed)
		
		if(self.remainingreactiontime~=nil and self.destx and self.desty)then			
			self.remainingreactiontime=self.remainingreactiontime-elapsed
			if(self.remainingreactiontime<=0)then
				if(not self:IsInMidair())then
					self.remainingreactiontime=nil
					self.ai:SetTargetPosition(self.destx,self.desty)
					if(self.destyaw)then 
						--print("set yaw to destyaw",self.destyaw)
						self.orientation.yaw=self.destyaw 					
						self.destyaw=nil
					else
						if(self.desty and self.destx)then
							local angle=math.atan2(self.desty-self.position.y,self.destx-self.position.x)
							if(self.desty~=self.position.y or self.destx~=self.position.x)then
								self.orientation.yaw=angle
							end
						else
							self.orientation.yaw=self.orientation_displayed.yaw
						end
					end
				end
			end
		end
		
		
		if(self.scenario and self.scenario.player)then
			if(self.ghostalpha>self.targetghostalpha)then
				self.ghostalpha=self.ghostalpha-elapsed*0.5
				if(self.ghostalpha<self.targetghostalpha)then self.ghostalpha=self.targetghostalpha end
			end
			if(self.ghostalpha<self.targetghostalpha)then
				self.ghostalpha=self.ghostalpha+elapsed*0.5				
				if(self.ghostalpha>self.targetghostalpha)then self.ghostalpha=self.targetghostalpha end
			end			
		end
		self.alpha=self.ghostalpha*self.ghostalphamultiplier
	end
	
	
	

end
