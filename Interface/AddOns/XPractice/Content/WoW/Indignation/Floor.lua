do
	local FLOORZ_RECTANGLE=-1.41	
	local FLOORZ_BORDER=-1.45
	local FLOORZ_SMALLRAMP=-3.5
	--local FLOORZ_RAMP=-7
	local FLOORZ_RAMP=-7.075
	local UP=0.1
	local DOWN=-0.05	

	local function GetShapeClass(shape,number,color)
		local classname=shape..number
		if(XPRACTICE_SAVEDATA.INDIGNATION.floorcolor==1)then
			classname=classname..color
		elseif(XPRACTICE_SAVEDATA.INDIGNATION.floorcolor==2)then
			-- blue; do nothing
		elseif(XPRACTICE_SAVEDATA.INDIGNATION.floorcolor==3)then
			classname=classname.."Gray"
		end
		return XPRACTICE.SOLIDS[classname]
	end

	do
		local super=XPRACTICE.MultiSolid
		XPRACTICE.INDIGNATION.Floor_InnerCircle=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.INDIGNATION.Floor_InnerCircle

		function class:Setup(environment,x,y,z)
			super.Setup(self,environment,x,y,z)
	
			local scale
			--scale=4.8
			-- 4.8 reaches the outer circle but unfortunately clips the inner cutout corner
			scale=4.64
			local class=GetShapeClass("Rectangle","001","Gray")
			self:AddActorByClass(class,0,0,FLOORZ_RECTANGLE*scale,scale,math.pi/4)

			--INNER CIRCLE------------------------------------
			local layout=XPRACTICE.INDIGNATION.Layout			
			layout.CreateInnerCirclePoints(0)
			--TODO LATER: clean up messy logic
			for i=1,#layout.points do
				local p=i%(#layout.points/4)
				--if(p>=3)then
				if(true)then
					local i2=i+1					
					if(i==#layout.points)then i2=1 end
					local xdist=layout.points[i2].x-layout.points[i].x
					local ydist=layout.points[i2].y-layout.points[i].y
					local angle=math.atan2(ydist,xdist)
					local dist=math.sqrt(xdist*xdist+ydist*ydist)
					scale=dist/14.0
					local offset,class
					local yaw=angle
					if(p==1 or p==0)then 	--p==12, but modulo
						offset=0.5
						class=GetShapeClass("Rectangle","002","")
						yaw=yaw+math.pi/2 
					elseif(p==2 or p==11)then
						offset=0.5
						class=GetShapeClass("Rectangle","001","")
					elseif((p>=5 and p<=8))then
						offset=1
						class=GetShapeClass("Rectangle","002","")
					else
						offset=2
						class=GetShapeClass("Rectangle","003","")
					end
					local x=layout.points[i].x+xdist/2+dist*math.cos(angle-math.pi/2)*offset
					local y=layout.points[i].y+ydist/2+dist*math.sin(angle-math.pi/2)*offset
					self:AddActorByClass(class,x,y,FLOORZ_BORDER*scale,scale,yaw)
				end
			end
			------------------------------------------------------------------------
			--DECOR UNDERNEATH------------------------------------
			for i=0,0 do
				local z=-90
				local scale=3
				local class=GetShapeClass("Box","003","Gray")
				local yaw=math.pi/16*i
				self:AddActorByClass(class,x,y,z,scale,yaw,0,0)
			end
			------------------------------------------------------------------------				
		end
	end
	

	do
		local super=XPRACTICE.MultiSolid
		XPRACTICE.INDIGNATION.Floor_OuterWings=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.INDIGNATION.Floor_OuterWings

		function class:Setup(environment,x,y,z)
			super.Setup(self,environment,x,y,z)	
			local layout=XPRACTICE.INDIGNATION.Layout			
			layout.CreatePoints(0)
			--WING EDGE------------------------------------			
			for i=1,#layout.points do
				local p=i%(#layout.points/4)
				if(p>=4 and p<=13)then
					local i2=i+1					
					if(i==#layout.points)then i2=1 end
					local xdist=layout.points[i2].x-layout.points[i].x
					local ydist=layout.points[i2].y-layout.points[i].y
					local angle=math.atan2(ydist,xdist)
					local dist=math.sqrt(xdist*xdist+ydist*ydist)
					local scale=dist/14.0
					local offset,class
					local yaw=angle
					if(p==4 or p==13 or p==6 or p==11)then
						offset=0.5
						class=GetShapeClass("Rectangle","001","")
					elseif(p==5 or p==12)then
						offset=0.125
						class=GetShapeClass("Rectangle","003","")
						yaw=yaw+math.pi/2
						scale=scale/4				
					else
						offset=0.125
						class=GetShapeClass("Rectangle","003","")
						yaw=yaw+math.pi/2
						scale=scale/4										
					end
					local x=layout.points[i].x+xdist/2+dist*math.cos(angle-math.pi/2)*offset
					local y=layout.points[i].y+ydist/2+dist*math.sin(angle-math.pi/2)*offset
					--local obj=class.new()						
					--obj:Setup(self.environment,x,y,FLOORZ_BORDER*scale);obj.scale=scale;obj.visiblefromallphases=true					
					--obj.orientation_displayed.yaw=yaw
					--tinsert(self.objs,obj)	
					self:AddActorByClass(class,x,y,FLOORZ_BORDER*scale,scale,yaw)
				end
			end
			------------------------------------------------------------------------			
			----WING MIDDLE------------------------------------
			for i=1,4 do
				local angle=math.pi/2*i
				local dist=84
				local x=math.cos(angle)*dist
				local y=math.sin(angle)*dist
				local class=GetShapeClass("Rectangle","002","Gray")
				local scale=1
				-- obj:Setup(self.environment,x,y,FLOORZ_BORDER*scale);obj.scale=scale;obj.visiblefromallphases=true					
				local yaw=angle+math.pi/2
				self:AddActorByClass(class,x,y,FLOORZ_BORDER*scale,scale,yaw)
				--tinsert(self.objs,obj)				
			end
			layout.CreatePoints(1)
			for i=1,4 do
				local xdist=layout.points[7].x-layout.points[5].x
				local ydist=layout.points[7].y-layout.points[5].y
				local angle=math.atan2(ydist,xdist)
				local dist=math.sqrt(xdist*xdist+ydist*ydist)
				local scale=dist/14.0
				local offset,class
				local yaw=angle
				local multiplier=1.2
				offset=0.25*multiplier
				yaw=yaw+math.pi/2-math.pi/2*i
				scale=scale/2*multiplier
				local x=layout.points[5].x+xdist/2+dist*math.cos(angle-math.pi/2)*offset
				local y=layout.points[5].y+ydist/2+dist*math.sin(angle-math.pi/2)*offset				
				local class=GetShapeClass("Rectangle","002","Gray")
				local xx,yy
				xx,yy=XPRACTICE.Transform_Rotate2D(x,y,-math.pi/2*i,0,0)	--clockwise
				-- obj:Setup(self.environment,xx,yy,FLOORZ_BORDER*scale);obj.scale=scale;obj.visiblefromallphases=true					
				-- obj.orientation_displayed.yaw=yaw
				-- tinsert(self.objs,obj)
				self:AddActorByClass(class,xx,yy,FLOORZ_BORDER*scale,scale,yaw)	
				x=-x
				xx,yy=XPRACTICE.Transform_Rotate2D(x,y,-math.pi/2*i,0,0)	--clockwise
				--local obj=XPRACTICE.SOLIDS.Rectangle002Gray.new()	
				--obj:Setup(self.environment,xx,yy,FLOORZ_BORDER*scale);obj.scale=scale;obj.visiblefromallphases=true					
				yaw=-angle+math.pi/2-math.pi/2*i
				--obj.orientation_displayed.yaw=yaw
				self:AddActorByClass(class,xx,yy,FLOORZ_BORDER*scale,scale,yaw)	
				--tinsert(self.objs,obj)	
			end
			------------------------------------------------------------------------			
			--DECOR UNDERNEATH------------------------------------
			for i=0,3 do
				local angle=math.pi/2*i
				local dist=55
				local x=dist*math.cos(angle)
				local y=dist*math.sin(angle)
				local z=-35
				local scale=5
				local class=GetShapeClass("Rectangle","001","Gray")
				local yaw=angle+math.pi/2
				local pitch=math.pi/2
				local roll=0
				self:AddActorByClass(class,x,y,z,scale,yaw,pitch,roll)
			end
			------------------------------------------------------------------------			
		end
	end
		
		
	do
		local super=XPRACTICE.MultiSolid
		XPRACTICE.INDIGNATION.Floor_CornerPlatforms=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.INDIGNATION.Floor_CornerPlatforms

		function class:Setup(environment,x,y,z)
			super.Setup(self,environment,x,y,z)	
			local layout=XPRACTICE.INDIGNATION.Layout			
			----CORNER PLATFORMS------------------------------------

			for j=0,3 do
				layout.CreateOuterPlatformsPoints(j)
				for i=1,#layout.points do
					if(true)then
						local i2=i+1					
						if(i==#layout.points)then i2=1 end
						local xdist=layout.points[i2].x-layout.points[i].x
						local ydist=layout.points[i2].y-layout.points[i].y
						local angle=math.atan2(ydist,xdist)
						local dist=math.sqrt(xdist*xdist+ydist*ydist)						
						local offset,class
						local yaw=angle
						local ok=false
						-- offset=0
						-- local scale=dist/19.7		-- 14*sqrt(2)
						-- class=XPRACTICE.SOLIDS.Ramp002
						-- local x=layout.points[i].x+xdist/2-dist*math.cos(angle-math.pi/2)*offset
						-- local y=layout.points[i].y+ydist/2-dist*math.sin(angle-math.pi/2)*offset
						-- local obj=class.new()		
						-- yaw=yaw-math.pi/4
						-- local pitch=math.pi/2
						-- self:AddActorByClass(class,x,y,FLOORZ_RAMP*scale,scale,yaw,pitch)
						if(i==2 or i==14) then
							ok=true
							yaw=yaw+math.pi/2			
							class=GetShapeClass("Ramp","002","Gray")
						elseif(i==4 or  i==8 or i==12)then
							ok=true
							yaw=yaw+math.pi/2
							class=GetShapeClass("Ramp","002","")
						elseif(i==3 or i==15)then
							ok=true
							yaw=yaw+math.pi
							class=GetShapeClass("Ramp","002","Gray")
						elseif(i==5 or i==9 or i==13)then
							ok=true
							yaw=yaw+math.pi
							class=GetShapeClass("Ramp","002","")
						end
						local up=UP
						if(i==8 or i==9)then
							up=0
						end
						if(ok)then
							offset=0.5
							local scale=dist/14							
							local x=layout.points[i].x+xdist/2-dist*math.cos(angle-math.pi/2)*offset
							local y=layout.points[i].y+ydist/2-dist*math.sin(angle-math.pi/2)*offset
							local obj=class.new()									
							local pitch=math.pi/2
							self:AddActorByClass(class,x,y,FLOORZ_RAMP*scale+up,scale,yaw,pitch)						
						end
					end
				end
				for i=1,#layout.points do
					local i2=i+1					
					if(i==#layout.points)then i2=1 end
					local xdist=layout.points[i2].x-layout.points[i].x
					local ydist=layout.points[i2].y-layout.points[i].y
					local angle=math.atan2(ydist,xdist)
					local dist=math.sqrt(xdist*xdist+ydist*ydist)										
					local scale=dist/14.0
					local yaw=angle
					local offset=0.5	
					local class
					local ok
					if(i==1 or i==16)then
						ok=true
						class=GetShapeClass("Rectangle","001","Gray")
					elseif(i==6 or i==7 or i==10 or i==11)then
						ok=true
						class=GetShapeClass("Rectangle","001","")
					else
						ok=false
					end
					if(ok)then						
						local x=layout.points[i].x+xdist/2-dist*math.cos(angle-math.pi/2)*offset
						local y=layout.points[i].y+ydist/2-dist*math.sin(angle-math.pi/2)*offset					
						--obj:Setup(self.environment,x,y,FLOORZ_BORDER*scale);obj.scale=scale;obj.visiblefromallphases=true					
						--obj.orientation_displayed.yaw=angle+math.pi/2
						--tinsert(self.objs,obj)
						local yaw=angle+math.pi/2
						self:AddActorByClass(class,x,y,FLOORZ_BORDER*scale,scale,yaw)
					end
					--TODO: maybe branch off 002s or 003s at 45 degree angle?  (connect to side of triangles)
					--TODO: turn triangle so one of the right-angle sides (not hypotenuse) is up against the edge
				end
				do	
					local i=7
					local i2=11
					local xdist=layout.points[i2].x-layout.points[i].x
					local ydist=layout.points[i2].y-layout.points[i].y
					local angle=math.atan2(ydist,xdist)
					local dist=math.sqrt(xdist*xdist+ydist*ydist)										
					local scale=dist/14.0
					local yaw=angle
					local offset=0.5	
					local class=GetShapeClass("Rectangle","001","")
					local x=layout.points[i].x+xdist/2-dist*math.cos(angle-math.pi/2)*offset
					local y=layout.points[i].y+ydist/2-dist*math.sin(angle-math.pi/2)*offset					
					local yaw=angle+math.pi/2
					self:AddActorByClass(class,x,y,FLOORZ_BORDER*scale,scale,yaw)
					local offset=0
					local x=layout.points[i].x+xdist/2-dist*math.cos(angle-math.pi/2)*offset
					local y=layout.points[i].y+ydist/2-dist*math.sin(angle-math.pi/2)*offset					
					local yaw=angle+math.pi/2
					--local yaw=angle+math.pi/2+math.pi/4
					local class=GetShapeClass("Rectangle","001","")
					--self:AddActorByClass(class,x,y,FLOORZ_BORDER*scale*.2,scale*.2,yaw)	
					--self:AddActorByClass(class,x,y,FLOORZ_BORDER*scale*.45,scale*.5,yaw)	
					--self:AddActorByClass(class,x,y,FLOORZ_BORDER*scale*.08,scale*.07,yaw)
					--self:AddActorByClass(class,x,y,FLOORZ_BORDER*scale*.27,scale*.3,yaw)
					self:AddActorByClass(class,x,y,FLOORZ_BORDER*scale*.1,scale*.07,yaw)
				end
				do	
					local i=3
					local i2=5
					local xdist=layout.points[i2].x-layout.points[i].x
					local ydist=layout.points[i2].y-layout.points[i].y
					local angle=math.atan2(ydist,xdist)
					local dist=math.sqrt(xdist*xdist+ydist*ydist)										
					local scale=dist/14.0
					local yaw=angle
					local offset=1.27
					local class=GetShapeClass("Rectangle","002","Gray")
					local x=layout.points[i].x+xdist/2-dist*math.cos(angle-math.pi/2)*offset
					local y=layout.points[i].y+ydist/2-dist*math.sin(angle-math.pi/2)*offset					
					self:AddActorByClass(class,x,y,FLOORZ_BORDER*scale,scale,yaw)
				end				
				do	
					local i=13
					local i2=15
					local xdist=layout.points[i2].x-layout.points[i].x
					local ydist=layout.points[i2].y-layout.points[i].y
					local angle=math.atan2(ydist,xdist)
					local dist=math.sqrt(xdist*xdist+ydist*ydist)										
					local scale=dist/14.0
					local yaw=angle
					local offset=1.27
					local class=GetShapeClass("Rectangle","002","Gray")
					local x=layout.points[i].x+xdist/2-dist*math.cos(angle-math.pi/2)*offset
					local y=layout.points[i].y+ydist/2-dist*math.sin(angle-math.pi/2)*offset					
					self:AddActorByClass(class,x,y,FLOORZ_BORDER*scale,scale,yaw)
				end						
			end			
			------------------------------------------------------------------------			
			--DECOR UNDERNEATH------------------------------------
			-- for i=0,3 do
				-- local angle=math.pi/2*i+math.pi/4
				-- local dist=105
				-- local x=dist*math.cos(angle)
				-- local y=dist*math.sin(angle)
				-- local z=-27
				-- local scale=2.5
				-- local class=XPRACTICE.SOLIDS.Ramp002Gray
				-- local yaw=math.pi/2*i-math.pi/2
				-- local pitch=math.pi/2
				-- self:AddActorByClass(class,x,y,z,scale,yaw,pitch)			
			-- end			
		-- for i=1,#self.actors do
			-- self.actors[i]:SetAlpha(0.25)
		-- end			
			for i=0,3 do
				local tilt=0.225
				local yawtilt=0.6325
				local angle=math.pi/2*i+math.pi/4+tilt
				local dist=78
				local x=dist*math.cos(angle)
				local y=dist*math.sin(angle)
				local z=-15.3
				local scale=2.2
				local class=GetShapeClass("Ramp","002","Gray")
				local yaw=math.pi/2*i-math.pi/2-yawtilt
				local pitch=math.pi/2
				self:AddActorByClass(class,x,y,z,scale,yaw,pitch)
				local angle=math.pi/2*i+math.pi/4-tilt
				local x=dist*math.cos(angle)
				local y=dist*math.sin(angle)
				local class=GetShapeClass("Ramp","002","Gray")
				local yaw=math.pi/2*i-math.pi/2+yawtilt
				local pitch=math.pi/2
				self:AddActorByClass(class,x,y,z,scale,yaw,pitch)				
			end
			------------------------------------------------------------------------				
		end
	end


	
	do
		local super=XPRACTICE.WoWObject
		XPRACTICE.INDIGNATION.Mirror=XPRACTICE.inheritsFrom(super)
		local class=XPRACTICE.INDIGNATION.Mirror		
		function class:SetActorAppearanceViaOwner(actor)
			actor:SetModelByFileID(3095195)	--9vm_vampire_mirror02
			----test:
			--actor:SetModelByFileID(193039)	--lightblue
			--actor:SetModelByFileID(194163)	--purple
			--actor:SetModelByFileID(199040)	--green
		end
	end	
	
end
