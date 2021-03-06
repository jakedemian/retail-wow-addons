do
	local super=XPRACTICE.GameObject
	XPRACTICE.Label=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.Label
	
	function class:Setup(environment,x,y,z)
		self.anchor="BOTTOMLEFT"
		super.Setup(self,environment,x,y,z)		
	end
	
	function class:CreateDisplayObject()
		self.displayobject=XPRACTICE.LabelDisplayObject.new()
		self.displayobject:Setup(self)
	end
	
	function class:SetSize(wid,hgt)
		self.displayobject.drawable:SetSize(wid,hgt)
	end
	
	function class:SetText(text)
		self.displayobject.drawable.fontstring:SetText(text)
	end
	
	function class:AutoSize()
		local drawable=self.displayobject.drawable
		--TODO: more elegant solution
		drawable:SetSize(1000,500)
		drawable:SetSize(drawable.fontstring:GetStringWidth(),drawable.fontstring:GetStringHeight())
	end
	
	function class:Draw(elapsed)
		self.displayobject:SetPositionAndScale(self.position,self.scale)
		self.displayobject.drawable:SetAlpha(self.alpha)
	end	
	function class:Select(toggle)
		-- do nothing!
	end
	function class:EnableMouse(toggle)
		-- do nothing!
	end
	function class:SetLockedStartingAlpha(toggle)
		-- do nothing!
	end
end

do
	local super=XPRACTICE.DisplayObject
	XPRACTICE.LabelDisplayObject=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.LabelDisplayObject
	
	function class:CreateDrawable()
		local f=XPRACTICE.ReusableFrames:GetFrame()
		self.drawable=f	
		tinsert(self.drawables,f)
	end
	function class:SetAppearance()
		self.drawable:Show();self.drawable:SetAlpha(1)
		self.parentframe=self.owner.environment.frame
		self.drawable:SetParent(self.parentframe)
		self.drawable:SetSize(50,50)
		self.drawable:SetFrameLevel(200)
		self.drawable.fontstring:Show()
		self.drawable.fontstring:SetText("")
	end
	function class:SetPositionAndScale(position,scale)	
		--self.drawable:SetPoint("BOTTOMLEFT",self.parentframe,"BOTTOMLEFT",position.x,position.y)
		self.drawable:SetPoint(self.owner.anchor,self.parentframe,"BOTTOMLEFT",position.x,position.y)
		--self.drawable:SetAllPoints(self.parentframe)
	end

end