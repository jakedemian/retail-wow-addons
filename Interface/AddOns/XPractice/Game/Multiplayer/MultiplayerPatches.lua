

do
	local super=XPRACTICE.Nameplate
	XPRACTICE.PlayerNameplate=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.PlayerNameplate
	function class:CreateDisplayObject()
		self.displayobject=XPRACTICE.PlayerNameplateDisplayObject.new()
		self.displayobject:Setup(self)
	end		
	function class:SetNearby()
		self:SetLongrange()
	end	
	function class:Step(elapsed)
		if(self.mob.alreadyfadestarted or self.mob.dead)then
			self:Die()
		end
		if(self.selected)then
			self.selectsize=self.selectsize+elapsed*(10)
			if(self.selectsize>1)then self.selectsize=1 end
		else
			self.selectsize=self.selectsize-elapsed*(10)
			if(self.selectsize<0)then self.selectsize=0 end	
		end
		self.displayobject.background:SetSize(145+65*self.selectsize,15+5*self.selectsize)
		self.displayobject:SetFillPoints()
		--self.displayobject.drawable:SetSize(145+65*self.selectsize,55+5*self.selectsize)
	end		
	
	function class:SetTextonlySize(size)
		--print("!!!")
		local scale=size/100 --tentative
		--print("Textonly scale",scale)
		self.displayobject.textonly.fontstring:SetScale(scale)	--!!!
		self.displayobject.textonly:SetWidth(size*4)				--!!!
		self.displayobject.textonly:SetHeight(53) --!!!  --TODO: without this line, why does height change after closing+reopening xpractice?
	end		
end
do
	local super=XPRACTICE.NameplateDisplayObject
	XPRACTICE.PlayerNameplateDisplayObject=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.PlayerNameplateDisplayObject
	
	function class:SetSelected(selected)
		local texture,gradient1,gradient2,textcolor
		if(not selected)then
			--texture={0,0,0,0.75}
			texture={0,0,0,1}
			gradient1={"VERTICAL",0,0.4375,0.8633,0.75,0,0,0,0.75}
			gradient2={"VERTICAL",0,0.4375,0.8633,0.75,1,0,0,0.75}
			textcolor={0,0.4375,0.8633,0.75}
		else
			texture={1,1,1,1}
			gradient1={"VERTICAL",0,0.4375,0.8633,1,0,0,0,1}
			gradient2={"VERTICAL",0,0.4375,0.86331,1,0,0,1}
			textcolor={0,0.4375,0.8633,1}
		end
		--self.background.texture:SetColorTexture(unpack(texture))
		self.bordertop.texture:SetColorTexture(unpack(texture))
		self.borderbottom.texture:SetColorTexture(unpack(texture))
		self.borderleft.texture:SetColorTexture(unpack(texture))
		self.borderright.texture:SetColorTexture(unpack(texture))
		self.topfill.texture:SetGradientAlpha(unpack(gradient1))		
		self.bottomfill.texture:SetGradientAlpha(unpack(gradient2))
		self.name.fontstring:SetTextColor(unpack(textcolor))
		self.textonly.fontstring:SetTextColor(unpack(textcolor))
	end
	
	function class:SetText(text)
		self.name.fontstring:SetText(text)
		self.name:SetSize(self.name.fontstring:GetStringWidth(),self.name.fontstring:GetStringHeight()+5)	
		self.name.fontstring:SetScale(1)	--TODO: this shouldn't be necessary, but it isn't being applied in ResetProperties
		
		self.textonly.fontstring:SetText(text)
		--self.textonly:SetSize(self.textonly.fontstring:GetStringWidth(),self.textonly.fontstring:GetStringHeight()+5)	
		self.textonly:SetSize(self.textonly.fontstring:GetStringWidth(),self.textonly.fontstring:GetStringHeight()+5)	
	end	

end



