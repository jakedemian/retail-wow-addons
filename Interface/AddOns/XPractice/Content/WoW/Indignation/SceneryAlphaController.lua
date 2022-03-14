do
	local super=XPRACTICE.GameObject
	XPRACTICE.INDIGNATION.SceneryAlphaController=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.INDIGNATION.SceneryAlphaController

	function class:SetCustomInfo()
		super.SetCustomInfo(self)
		self.multisolid=nil
		self.objs=nil
		self.direction=-1
	end
	function class:SetAlpha(alpha)
		--print("alpha:",alpha)
		if(self.multisolid)then
			for i=1,#self.multisolid.actors do
				self.multisolid.actors[i]:SetAlpha(alpha)
			end
		end
		if(self.objs)then
			for i=1,#self.objs do
				self.objs[i].alpha=alpha
			end
		end
	end
	function class:SetDesaturation(desat)
		if(self.multisolid)then
			for i=1,#self.multisolid.actors do
				self.multisolid.actors[i]:SetDesaturation(desat)
				--self.multisolid.actors[i]:SetSpellVisualKit(125722)
				--self.multisolid.actors[i]:SetSpellVisualKit(128250)
			end
		end	
	end
	
	function class:Step(elapsed)
		super.Step(self,elapsed)
		-- this code is mostly copied from WoWObject.  since SceneryAlphaController is not a WoWObject, this shouldn't cause conflicts
		local fadealpha=1
		if(self.fadestoptime and self.fadestarttime)then
			fadealpha=(self.environment.localtime-self.fadestarttime)/(self.fadestoptime-self.fadestarttime)			
			if(self.direction<0)then fadealpha=1-fadealpha end			
			if(fadealpha>1)then fadealpha=1 end
			if(fadealpha<0)then fadealpha=0 end	
			self:SetAlpha(fadealpha)
			--print("fadealpha",fadealpha)
			if(self.environment.localtime>=self.fadestoptime)then
				self.fadestoptime=nil
			end			
		end

	end

end

