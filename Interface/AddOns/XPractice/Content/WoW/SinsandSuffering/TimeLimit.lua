do
	local super=XPRACTICE.GameObject
	XPRACTICE.SINSANDSUFFERING.TimeLimit=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.SINSANDSUFFERING.TimeLimit
	
	local FLASHRATE=1/3.0
	function class:Setup(environment,x,y,z)
		super.Setup(self,environment,x,y,z)
		self.focus=nil
		self.trackedauraclass=nil
		self.trackedauralist=nil
		self.flashstate=0
		self.flashtimer=FLASHRATE
		
		self.starttime=0
		self.currenttime=0
		self.active=false
		self.running=false
	end
	
	
	function class:CreateDisplayObject()
		self.displayobject=XPRACTICE.TimeLimitDisplayObject.new()
		self.displayobject:Setup(self)
	end
	
	
	function class:Step(elapsed)
		super.Step(self,elapsed)
		if(self.active)then
			self.displayobject.drawable:Show()
			--if(aura.minimumflashstacks and aura.stacks>=aura.minimumflashstacks)then			
			if(self.running)then
				self.currenttime=self.environment.localtime
			end
			local timer=self.currenttime-self.starttime
			if(timer<0)then timer=0 end
			if(timer>XPRACTICE_SAVEDATA.SINSANDSUFFERING.TimeLimit)then timer=XPRACTICE_SAVEDATA.SINSANDSUFFERING.TimeLimit end

			
			if(self.running==false)then
				self.flashtimer=self.flashtimer-elapsed	
				--print(self.flashstate)
				if(self.flashtimer<=0)then
					self.flashstate=self.flashstate+1
					if(self.flashstate>2)then self.flashstate=0 end
					self.flashtimer=FLASHRATE
				end
			else
				self.flashstate=0
				self.flashtimer=FLASHRATE
			end
			local colortag
			local timetext=string.format("%0.1f",timer)
			if(self.flashstate<=1)then
				colortag="|cffffffff"
			else
				if(timer>=XPRACTICE_SAVEDATA.SINSANDSUFFERING.TimeLimit)then
					colortag="|cffff0000"
				else
					colortag="|cffffffff"
					timetext=""					
				end
			end					
			local resettag="|r"
			self.displayobject.text.fontstring:SetText(colortag..timetext..resettag)
			
			if(self.running)then
				if(timer>=XPRACTICE_SAVEDATA.SINSANDSUFFERING.TimeLimit)then
					self:StopTimer()
					local aura=self.scenario.player.combatmodule:ApplyAuraByClass(XPRACTICE.Aura_DeadInGame,self.scenario.player.combatmodule,self.localtime)
					local link="\124cffff0000\124Hspell:331527\124h[Indemnification]\124h\124r"			
					self.scenario.statuslabel:SetText("Time's up.  You died from "..link..".",3.0)
				end
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

	function class:StopTimer()
		self.running=false
		self.currenttime=self.environment.localtime
	end
	
	function class:HideTimer()
		self.active=false
	end
	
	function class:Draw(elapsed)
		self.displayobject:SetPositionAndScale(self.position,self.scale)
	end	
	
end


do
	local super=XPRACTICE.DisplayObject
	XPRACTICE.TimeLimitDisplayObject=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.TimeLimitDisplayObject
	
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
		self.back.texture:Show();self.back.texture:SetTexture("interface/icons/inv_misc_pocketwatch_01.blp")
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
	