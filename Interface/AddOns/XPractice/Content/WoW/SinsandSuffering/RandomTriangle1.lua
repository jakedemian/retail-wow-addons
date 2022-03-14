do
	XPRACTICE.SINSANDSUFFERING.RandomTriangle1={}
	
	--static function!
	function XPRACTICE.SINSANDSUFFERING.RandomTriangle1.Generate()
		local centerx,centery,radius=XPRACTICE.SINSANDSUFFERING.RandomCircle1.Generate()
		--print("Circle",centerx,centery,radius)
		local roffset=math.random()*math.pi*2
		local r1=0
		local MINDIFF=math.pi*1/3
		local MAXDIFF=math.pi*3/3
		local diff=math.random()*(MAXDIFF-MINDIFF)+MINDIFF
		--diff=math.pi*2/3
		local r2=r1+diff
		local MINDIFF=math.pi*1/3
		local MAXDIFF=math.pi*2/3
		local diff=math.random()*(MAXDIFF-MINDIFF)+MINDIFF
		--diff=math.pi*2/3
		local r3=r1-diff
		if(math.random()>0.5)then
			r2=-r2
			r3=-r3
		end
		r1=r1+roffset
		r2=r2+roffset
		r3=r3+roffset		
		local squish=math.random()*0.5+0.5
		squish=math.sqrt(squish)
		--print("squish:",squish)
		local x1=centerx+radius*math.cos(r1)
		local y1=centery+radius*math.sin(r1)*squish
		local x2=centerx+radius*math.cos(r2)
		local y2=centery+radius*math.sin(r2)*squish
		local x3=centerx+radius*math.cos(r3)
		local y3=centery+radius*math.sin(r3)*squish
		local rotation=math.random()*math.pi*2
		x1,y1=XPRACTICE.Transform_Rotate2D(x1,y1,rotation,0,0)
		x2,y2=XPRACTICE.Transform_Rotate2D(x2,y2,rotation,0,0)
		x3,y3=XPRACTICE.Transform_Rotate2D(x3,y3,rotation,0,0)
		return x1,y1,x2,y2,x3,y3
	end
end