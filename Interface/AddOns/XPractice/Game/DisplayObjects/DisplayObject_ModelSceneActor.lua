do
	local super=XPRACTICE.DisplayObject
	XPRACTICE.ModelSceneActor=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.ModelSceneActor


	function class:Setup(owner)
		super.Setup(self,owner)
		self.animation=0
		self.sequence=nil
	end
	
	function class:CreateDrawable()
		local msf=self.owner.environment.modelsceneframe
		--XPRACTICE.FrameVisibilityCheck(msf)
		local actor=XPRACTICE.ReusableModelSceneFrames:GetActor(msf)
		self.drawable=actor
		self:SetActorAppearance()
		tinsert(self.drawables,self.drawable)
	end
	
	function class:SetActorAppearance()
		--self.drawable:SetModelByCreatureDisplayID(81018)	-- Kiro	--!!!
		--self.drawable:SetModelByUnit("player")
		--self.drawable:SetModelByFileID(1)	-- checkerbox
		self.owner:SetInitialPositionViaOwner(self.drawable)
		self.owner:SetActorAppearanceViaOwner(self.drawable)
		self.owner:SetDisplayObjectCustomBoundingBoxViaOwner(self)
		self.drawable:Show()--!!!
		self.drawable:SetUseCenterForOrigin(true,true,false) --!!!
	end
	
	function class:SetPositionAndScale(position,scale,displayedpositionoffset)
		if(not displayedpositionoffset)then
			self.drawable:SetPosition((position.x)/scale,
									(position.y)/scale,
									(position.z)/scale)
		else
			self.drawable:SetPosition((position.x+displayedpositionoffset.x)/scale,
									(position.y+displayedpositionoffset.y)/scale,
									(position.z+displayedpositionoffset.z)/scale)
		end
		self.drawable:SetScale(scale)

		
	end	
	function class:SetOrientation(orientation)
		self.drawable:SetYaw(orientation.yaw)
		self.drawable:SetPitch(orientation.pitch)
		self.drawable:SetRoll(orientation.roll)
	end
	function class:SetAlpha(alpha)
		self.drawable:SetAlpha(alpha)
	end
	
	function class:PlayAnimation(animation,sequence)		
		if(self.animation~=animation or self.sequence~=sequence)then
			self.animation=animation
			self.sequence=sequence
			self.drawable:SetAnimation(animation,sequence)
		end
	end
	function class:ResetAnimation(animation,sequence)
		self.animation=animation
		self.sequence=sequence
		self.drawable:SetAnimation(animation,sequence)
	end
	
	function class:Cleanup()
		-- don't call super
		XPRACTICE.ReusableModelSceneFrames:RemoveActor(self.drawable.frame,self.drawable)
	end
end