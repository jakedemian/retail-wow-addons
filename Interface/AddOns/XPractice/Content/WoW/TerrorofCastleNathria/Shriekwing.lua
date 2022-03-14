do
	XPRACTICE.TERROROFCASTLENATHRIA.AnimationList={}
	----XPRACTICE.AnimationTemplate.QuickSetup(animationlist,							name,		index,	subindex,	priority,	duration,	nextanimation)
	XPRACTICE.AnimationTemplate.QuickSetup(XPRACTICE.TERROROFCASTLENATHRIA.AnimationList,"Settle2",	0,		0,			"Active",		nil,		nil)
	--TODO: once model viewers have been updated, check exact duration
	--XPRACTICE.AnimationTemplate.QuickSetup(XPRACTICE.TERROROFCASTLENATHRIA.AnimationList,"Settle",	464,	0,		"Active",		1.75,		XPRACTICE.TERROROFCASTLENATHRIA.AnimationList.Settle2)
	XPRACTICE.AnimationTemplate.QuickSetup(XPRACTICE.TERROROFCASTLENATHRIA.AnimationList,"Settle",	464,	0,		"Active",		1.75,		XPRACTICE.TERROROFCASTLENATHRIA.Idle)
	XPRACTICE.AnimationTemplate.QuickSetup(XPRACTICE.TERROROFCASTLENATHRIA.AnimationList,"RoarCast",	74,		0,		"Active",		3.5,		XPRACTICE.TERROROFCASTLENATHRIA.Idle)

	--XPRACTICE.AnimationTemplate.QuickSetup(XPRACTICE.TERROROFCASTLENATHRIA.AnimationList,"SpellCastOmni",	54,		0,	"Passive",	2.0,		nil)	
	XPRACTICE.AnimationTemplate.QuickSetup(XPRACTICE.TERROROFCASTLENATHRIA.AnimationList,"SpellCastOmni",	54,		0,	"Passive",	1.5,		nil)
	--XPRACTICE.AnimationTemplate.QuickSetup(XPRACTICE.TERROROFCASTLENATHRIA.AnimationList,"SpellCastOmni",	54,		0,	"Passive",	1.0,		nil)	
	--XPRACTICE.AnimationTemplate.QuickSetup(XPRACTICE.TERROROFCASTLENATHRIA.AnimationList,"SpellCastOmni",	54,		0,	"Passive",	0.0,		nil)	
	
	-- inflight is for echoing sonar, not shriekwing
	XPRACTICE.AnimationTemplate.QuickSetup(XPRACTICE.TERROROFCASTLENATHRIA.AnimationList,"InFlight",	144,		0,	"Active",	nil,		nil)	
	
	XPRACTICE.AnimationTemplate.QuickSetup(XPRACTICE.TERROROFCASTLENATHRIA.AnimationList,"TeleportCast2",	548,		0,	"Passive",	0.1,		nil)	
	XPRACTICE.AnimationTemplate.QuickSetup(XPRACTICE.TERROROFCASTLENATHRIA.AnimationList,"TeleportCast1",	564,		0,	"Passive",	0.85,		XPRACTICE.TERROROFCASTLENATHRIA.AnimationList.TeleportCast2)	
	
end

do
	local super=XPRACTICE.Mob
	XPRACTICE.TERROROFCASTLENATHRIA.Shriekwing=XPRACTICE.inheritsFrom(super)
	local class=XPRACTICE.TERROROFCASTLENATHRIA.Shriekwing

	function class:SetCustomInfo()
		super.SetCustomInfo(self)
		self.scale=2
		--self.scale=0.5
		self.basemovespeed=14.0
		self.walkspeed=XPRACTICE.Config.Shriekwing.BossWalkSpeed*(1+XPRACTICE_SAVEDATA.TERROROFCASTLENATHRIA.ShriekwingMovementSpeed*0.25)
		self.targetlocationindex=-1		-- -1 default (center)
										-- 1 northwest, then clockwise
		self.firstmovementlocationindex=0
		self.movementdirection=0
		self.automovessincereversedirection=0	-- only used by auto movement for endless intermission setting
		self.totalshrieks=0
	end
	function class:SetActorAppearanceViaOwner(actor)
		actor:SetModelByCreatureDisplayID(97268)	-- gargoylebruteboss.m2 (Shriekwing)
	end
	function class:SetFacepullRadiusViaOwner(ai)
		ai.facepullradius=20
	end

	-- function class:SetDisplayObjectCustomBoundingBoxViaOwner(displayobject)
		-- -- local radius=1.5
		-- -- local base=2
		-- -- local height=3.5
		-- -- displayobject.customboundingbox={-radius,-radius,base,radius,radius,base+height}
		-- displayobject.customboundingbox={-5.65511,-4.20898,-0.75779,3.85328,3.95412,5.75733}
	-- end	
	
	function class:Step(elapsed)
		super.Step(self,elapsed)
	end
	
	function class:OnArrivedAtAIDestination()
		self.scenario:ClickButtonAfterDelay(self.scenario.sonarshriekbutton,0.0)
	end	
end

