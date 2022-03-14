-- we may very well decide darkvein is to be used only as an invisible bunny for spellcasting

do
	local super=XPRACTICE.Mob
	XPRACTICE.SINSANDSUFFERING.LadyInervaDarkvein=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.SINSANDSUFFERING.LadyInervaDarkvein

	function class:SetCustomInfo()
		super.SetCustomInfo(self)
		self.scale=1.5
		self.alpha=0  -- if invisible bunny
	end
	function class:SetActorAppearanceViaOwner(actor)
		actor:SetModelByCreatureDisplayID(96806)	
	end

end

