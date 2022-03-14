do
	--TODO: add aura snare category in core folder
	local super=XPRACTICE.Aura
	XPRACTICE.FATESCRIBEMULTIPLAYER.Aura_LaserDebuff = XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.FATESCRIBEMULTIPLAYER.Aura_LaserDebuff
	
	function class:SetCustomInfo()
		super.SetCustomInfo(self)
		self.baseduration=12.000	
		self.removeondeadingame=true			
		self.tickdelay=3.0
		self.basetickrate=3.0			
	end		
	
	function class:Tick(ticktime)
		self:OnTick(ticktime,1.0)
		--!!!
		--TODO: move to base aura class
		self.previousticktime=ticktime
	end	
	function class:OnTick(ticktime,percentage)	
		local player=self.targetcombat.mob
		local scenario=player.scenario
		local aura=player.combatmodule:ApplyAuraByClass(XPRACTICE.Aura_DeadInGame,scenario.boss.combatmodule,player.environment.localtime)							
		scenario.statuslabel:SetText("Died from Exposed Threads of Fate.",3.0)
		scenario.multiplayer:FormatAndSendCustom("DEAD_LINE")
	end
end

do
	local super=XPRACTICE.GameObject
	XPRACTICE.FATESCRIBEMULTIPLAYER.LaserDebuffIcon=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.FATESCRIBEMULTIPLAYER.LaserDebuffIcon
	
	function class:Setup(environment,x,y,z)
		super.Setup(self,environment,x,y,z)
		self.focus=nil
	end
	
	function class:CreateDisplayObject()
		self.displayobject=XPRACTICE.FATESCRIBEMULTIPLAYER.LaserDebuffIconDisplayObject.new()
		self.displayobject:Setup(self)
	end
	
	
	function class:Step(elapsed)
		super.Step(self,elapsed)
		local player=self.focus		
		if(player)then
			local auras=player.combatmodule.auras:GetAurasByClassIfExist(XPRACTICE.FATESCRIBEMULTIPLAYER.Aura_LaserDebuff)
			if(#auras>0)then
				local aura=auras[1]
				self.displayobject.drawable:Show()			
				local stacktext=""			
				if(aura.expirytime)then
					local remaining=math.floor(aura.expirytime-aura.targetcombat.localtime)
					stacktext=tostring(remaining)
				end
				self.displayobject.text.fontstring:SetText(stacktext)
			else
				self.displayobject.drawable:Hide()
			end			
		else
			self.displayobject.drawable:Hide()
		end
	end

	function class:Draw(elapsed)
		--TODO: maybe move this to base class but check for existence of displayobject?
		self.displayobject:SetPositionAndScale(self.position,self.scale)
	end	
	
	
end


do
	local super=XPRACTICE.DisplayObject
	XPRACTICE.FATESCRIBEMULTIPLAYER.LaserDebuffIconDisplayObject=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.FATESCRIBEMULTIPLAYER.LaserDebuffIconDisplayObject
	
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
		self.back.texture:Show();self.back.texture:SetTexture("interface/icons/inv_misc_web_01.blp")
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