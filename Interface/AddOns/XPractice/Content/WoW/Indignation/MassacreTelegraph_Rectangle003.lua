
do
	local super=XPRACTICE.INDIGNATION.MassacreTelegraph
	XPRACTICE.INDIGNATION.MassacreTelegraph_Rectangle003=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.INDIGNATION.MassacreTelegraph_Rectangle003

	function class:SetCustomInfo()
		super.SetCustomInfo(self)
		self.segments={}
		
	end
	
	function class:Start()
		super.Start(self)
		self.movingsegment=XPRACTICE.INDIGNATION.MassacreTelegraph_Rectangle003_Segment.new()
		self.movingsegment:Setup(self.environment)	
		self.movingsegmentprogress=0
		self.movingsegment.orientation_displayed.yaw=self.angle+self.movingsegment.yawoffset
		self:Update()
	end
	
	function class:Step(elapsed)
		super.Step(self,elapsed)	
		self:Update()		
	end
	
	function class:Update()
		if(self.movingsegment)then
			local scale=self.linewidth*(1/13.89)					
			self.movingsegment.scale=scale
			local seglength=55.55*scale			
			local segz=-1.3*scale
			if(self.state==1 or self.state==2)then
				local segx=self.lineend-seglength*0.5
				local x=self.origin.x+math.cos(self.angle)*segx
				local y=self.origin.y+math.sin(self.angle)*segx
				self.movingsegment.position={x=x,y=y,z=segz}
								
				--TODO: also check if new segment would be out of bounds
				local targetsegmentcount=math.floor((self.lineend-self.linestart)/seglength)+1
				if(#self.segments<targetsegmentcount)then
					for i=#self.segments+1,targetsegmentcount do
						local segment=XPRACTICE.INDIGNATION.MassacreTelegraph_Rectangle003_Segment.new()
						tinsert(self.segments,segment)
						local staticsegx=(#self.segments-0.5)*seglength
						local staticx=self.origin.x+math.cos(self.angle)*staticsegx
						local staticy=self.origin.y+math.sin(self.angle)*staticsegx
						--local x=math.cos(self.angle) --TODO:
						--local y=0			--TODO:
						segment:Setup(self.environment,staticx,staticy,segz)
						segment.scale=scale
						segment.orientation_displayed.yaw=self.angle+segment.yawoffset
					end
				end
			end
			if(self.state==3)then
				local segx=self.linestart+seglength*0.5
				local x=self.origin.x+math.cos(self.angle)*segx
				local y=self.origin.y+math.sin(self.angle)*segx
				self.movingsegment.position={x=x,y=y,z=segz}
				local floorsegment=math.ceil((self.linestart)/seglength)
				for i=1,floorsegment do
					if(self.segments[i] and not self.segments[i].dead)then
						self.segments[i]:Die()
					end
				end
				if(floorsegment>=#self.segments)then
					self.state=4
				end
			end
		
			
		end
		
	end
	
	function class:Cleanup()
		super.Cleanup(self)
		for i=1,#self.segments do
			if(self.segments[i] and not self.segments[i].dead)then
				self.segments[i]:Die()
			end
		end
		if(self.movingsegment and not self.movingsegment.dead)then
			self.movingsegment:Die()
		end		
	end

end

do
	local super=XPRACTICE.WoWObject
	XPRACTICE.INDIGNATION.MassacreTelegraph_Rectangle003_Segment=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.INDIGNATION.MassacreTelegraph_Rectangle003_Segment

	function class:SetCustomInfo()
		super.SetCustomInfo(self)
		self.visible=false
		self.yawoffset=math.pi/2
	end
	
	function class:SetActorAppearanceViaOwner(actor)
		actor:SetModelByFileID(3088270)	--scale_obj_rectangle_003red
	end	
			-- --scale_obj_rectangle_003red:
		-- --z=-1.3*recscale  (-1.375 better, but breaks at very small scale)
		-- --local RECLENGTH=13.9 	-- seam visible
		-- --local RECWIDTH=55.56	-- seam visible
		-- local TELEGRAPHWIDTH=3
		-- local RECSCALE=TELEGRAPHWIDTH*1/13.89
		-- local RECLENGTH=13.89
		-- local RECWIDTH=55.55		
		-- for x=1,1 do
			-- for y=-10,10 do
				-- local telegraph
				-- telegraph=XPRACTICE.WoWObject.new()
				-- telegraph:Setup(self.game.environment_gameplay)						
				-- telegraph.position={x=x*RECLENGTH*RECSCALE,y=y*RECWIDTH*RECSCALE,z=-1.3*RECSCALE}
				-- telegraph.scale=RECSCALE
				-- telegraph.alpha=1
				-- telegraph.visiblefromallphases=true	
			-- end
		-- end


end