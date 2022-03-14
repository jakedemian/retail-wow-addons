do
	local super=XPRACTICE.GameObject
	XPRACTICE.KELTHUZADMULTIPLAYER.DoTDebuffIcon=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.KELTHUZADMULTIPLAYER.DoTDebuffIcon
	
	function class:Setup(environment,x,y,z)
		super.Setup(self,environment,x,y,z)
		self.focus=nil
	end
	
	function class:CreateDisplayObject()
		self.displayobject=XPRACTICE.KELTHUZADMULTIPLAYER.DoTDebuffIconDisplayObject.new()
		self.displayobject:Setup(self)
	end
	
	
	function class:Step(elapsed)
		super.Step(self,elapsed)
		local player=self.focus
		if(player)then
			local timeinphase=player.timeinphase-XPRACTICE.KELTHUZADMULTIPLAYER.Config.PhaseTimeLagEstimate
			if(timeinphase>=2.0)then
				self.displayobject.drawable:Show()
				local stacktext=""
				if(timeinphase>=4.0)then
					stacktext=math.floor(timeinphase/2.0)
				end
				self.displayobject.text.fontstring:SetText(stacktext)
				
			else
				self.displayobject.drawable:Hide()
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
	XPRACTICE.KELTHUZADMULTIPLAYER.DoTDebuffIconDisplayObject=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.KELTHUZADMULTIPLAYER.DoTDebuffIconDisplayObject
	
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
		self.back.texture:Show();self.back.texture:SetTexture("interface/icons/spell_necro_inevitableend.blp")
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
	
do
	local super=XPRACTICE.Spell
	XPRACTICE.KELTHUZADMULTIPLAYER.Spell_ResetStacks = XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.KELTHUZADMULTIPLAYER.Spell_ResetStacks
	
	function class:SetCustomInfo()
		super.SetCustomInfo(self)
		self.name="(Reset stacks)"
		self.icon="interface/icons/spell_necro_inevitableend.blp"
		self.requiresfacing=false;self.projectileclass=nil;self.basecastduration=0;self.basechannelduration=nil;self.basechannelticks=nil;self.tickonchannelstart=false;self.usablewhilemoving=true
	end
	
	function class:StartCastingEffect(spellinstancepointer)
		local scenario=spellinstancepointer.castercombat.mob.scenario
		scenario.multiplayer:FormatAndSendCustom("RESETSTACKS")
	end
end
