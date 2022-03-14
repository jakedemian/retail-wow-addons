XPRACTICE.KELTHUZADMULTIPLAYER.Config={}

--------------------------------------------------------------------------------
--
--	User-editable values.
--  Changes will not take effect until you /reload World of Warcraft.
--
--  When playing with a group, all players should have identical config files.
--------------------------------------------------------------------------------

---------------------------------------------------------------------
-- LAYOUT
---------------------------------------------------------------------
-- Default 20.
XPRACTICE.KELTHUZADMULTIPLAYER.Config.ArenaRadius=20
-- Default 1.45.
XPRACTICE.KELTHUZADMULTIPLAYER.Config.ArenaCylinderScale=1.45
-- Default XPRACTICE.KELTHUZADMULTIPLAYER.Config.ArenaCylinderScale*-27.77.
XPRACTICE.KELTHUZADMULTIPLAYER.Config.ArenaCylinderZOffset=XPRACTICE.KELTHUZADMULTIPLAYER.Config.ArenaCylinderScale*-27.77

-- Default 0.75.  Affects DoT stack timing and murloc swirl prediction.
XPRACTICE.KELTHUZADMULTIPLAYER.Config.PhaseTimeLagEstimate=0.75
-- Default 6.0.  Swirls will not appear underneath players who have not spent this much time in phase.
XPRACTICE.KELTHUZADMULTIPLAYER.Config.MinimumPhaseSwirlTime=6.0
-- Default 3.0.  Boss's GCD will reset to this value if there are no players in phase.
XPRACTICE.KELTHUZADMULTIPLAYER.Config.MinimumPhaseSpellcastTime=3.0

---------------------------------------------------------------------
-- SWIRLS (Shadow Fissure)
---------------------------------------------------------------------
-- Default 3.0.
XPRACTICE.KELTHUZADMULTIPLAYER.Config.SwirlAimMaxOffset=3.0
-- Default 4.0.
XPRACTICE.KELTHUZADMULTIPLAYER.Config.SwirlRadius=4.0
-- Default 1.
XPRACTICE.KELTHUZADMULTIPLAYER.Config.SwirlScale=1			
-- Default 0.05.
XPRACTICE.KELTHUZADMULTIPLAYER.Config.SwirlZOffset=0.05
-- Default false.
XPRACTICE.KELTHUZADMULTIPLAYER.Config.DisplaySwirlRim=false
-- Default 0.0.
-- If SwirlAimDelay is >0, player swirls will appear where players were standing previously, not where they are standing now.
-- (this feature hasn't been thoroughly playtested and might be buggy; use at your own risk)
XPRACTICE.KELTHUZADMULTIPLAYER.Config.SwirlAimDelay=0.0
-- Default 3.0.
XPRACTICE.KELTHUZADMULTIPLAYER.Config.SwirlExplosionTime=3.0
--base points 150
XPRACTICE.KELTHUZADMULTIPLAYER.Config.SwirlZKnockback=15		
--misc value[0] 100		
XPRACTICE.KELTHUZADMULTIPLAYER.Config.SwirlXYKnockback=10		
-- Default 4.0.
XPRACTICE.KELTHUZADMULTIPLAYER.Config.PoolRadius=4.0
-- XPRACTICE.KELTHUZADMULTIPLAYER.Config.PoolScale=0.275		-- approx 4 yard pools
-- XPRACTICE.KELTHUZADMULTIPLAYER.Config.PoolZOffset=-0.35
-- XPRACTICE.KELTHUZADMULTIPLAYER.Config.PoolScale=0.2		-- approx <4 yard pools
-- XPRACTICE.KELTHUZADMULTIPLAYER.Config.PoolZOffset=-0.25
-- Default 0.175.
XPRACTICE.KELTHUZADMULTIPLAYER.Config.PoolScale=0.175		-- even smaller pools
-- Default -0.2.  (The pool graphic is a 3D cylinder which clips into the floor.)
XPRACTICE.KELTHUZADMULTIPLAYER.Config.PoolZOffset=-0.2
-- Default 10.0.
XPRACTICE.KELTHUZADMULTIPLAYER.Config.PoolDuration=10.0
-- Default 2.5.  You die if you spend this much time in a pool.
XPRACTICE.KELTHUZADMULTIPLAYER.Config.PoolTolerance=2.5
-- Default 0.25.  You "heal" pool damage at 0.25x the rate you incur it.
XPRACTICE.KELTHUZADMULTIPLAYER.Config.PoolRecoveryRate=0.25
-- Default true.
XPRACTICE.KELTHUZADMULTIPLAYER.Config.DisplayPoolRim=true	-- only displayed when player is too close
-- Default 1.
XPRACTICE.KELTHUZADMULTIPLAYER.Config.PoolRimScale=1
-- Default 0.05.
XPRACTICE.KELTHUZADMULTIPLAYER.Config.PoolRimZOffset=0.05



---------------------------------------------------------------------
-- DOT (Sinister Miasma)
---------------------------------------------------------------------
-- Default 2.0.
XPRACTICE.KELTHUZADMULTIPLAYER.Config.DotStackRate=2.0

---------------------------------------------------------------------
-- ICE BEAM (Freezing Blast)
---------------------------------------------------------------------
-- Default 3.5.
XPRACTICE.KELTHUZADMULTIPLAYER.Config.IceBeamCastTime=3.5	--mythic
-- Default 3.7.  (Mythic; heroic was 4.9 on PTR.)
XPRACTICE.KELTHUZADMULTIPLAYER.Config.IceBeamCastGCD=3.7	--mythic
-- Default 5.0.  (Might be lower in the actual game.  Was 6.0 during playtesting.  We prefer to err in the boss's favor.)
XPRACTICE.KELTHUZADMULTIPLAYER.Config.IceBeamRadius=5.0
-- Default 1.5.
XPRACTICE.KELTHUZADMULTIPLAYER.Config.IceBeamSwirlScale=1.5
-- Default 4.0.
XPRACTICE.KELTHUZADMULTIPLAYER.Config.IceBeamRootDuration=4.0
--When the boss is aiming Freezing Blast, his model will turn slightly out of sync with the area of effect so his hand lines up properly.
XPRACTICE.KELTHUZADMULTIPLAYER.Config.IceBeamBossAngleOffset=0.0
-- Default math.pi*(3/32).
XPRACTICE.KELTHUZADMULTIPLAYER.Config.IceBeamBossAngleOffsetPhase3=math.pi*(3/32)

---------------------------------------------------------------------
-- TORNADO (Glacial Winds)
---------------------------------------------------------------------
--all times heroic.  
-- Default 3.0.
XPRACTICE.KELTHUZADMULTIPLAYER.Config.TornadoCastTime=3.0
-- Default 3.65.
XPRACTICE.KELTHUZADMULTIPLAYER.Config.TornadoCastGCD=3.65	--3.65 if GW > FB, higher if GW > GW
-- Default 13.3.
XPRACTICE.KELTHUZADMULTIPLAYER.Config.TornadoCooldown=13.3
-- Default 1.
XPRACTICE.KELTHUZADMULTIPLAYER.Config.TornadoScale=1
-- Default 4.0.
XPRACTICE.KELTHUZADMULTIPLAYER.Config.TornadoRadius=4.0
-- Default 5.0.
XPRACTICE.KELTHUZADMULTIPLAYER.Config.TornadoDuration=5.0
-- Default 6.0.
XPRACTICE.KELTHUZADMULTIPLAYER.Config.TornadoFreezeTime=6.0


---------------------------------------------------------------------
-- PUSHBACK (Foul Winds)
---------------------------------------------------------------------
--mythic only
-- Default 2.0.
XPRACTICE.KELTHUZADMULTIPLAYER.Config.PushbackCastTime=2.0
-- Default 8.5.  Seemed to vary on PTR depending on the following spell.
XPRACTICE.KELTHUZADMULTIPLAYER.Config.PushbackCastGCD=8.5	--8.5 if FW > FB, higher if FW > FW
-- Default 12.9.
XPRACTICE.KELTHUZADMULTIPLAYER.Config.PushbackCooldown=12.9  
-- Default 6.0.
XPRACTICE.KELTHUZADMULTIPLAYER.Config.PushbackDuration=6.0
-- Default 0.5.
XPRACTICE.KELTHUZADMULTIPLAYER.Config.StartPushbackStrength=0.5
-- Default 1.7.
XPRACTICE.KELTHUZADMULTIPLAYER.Config.EndPushbackStrength=1.7
-- Default 1.0.
XPRACTICE.KELTHUZADMULTIPLAYER.Config.PushbackVisualScale=1.0
-- Default 0.25.
XPRACTICE.KELTHUZADMULTIPLAYER.Config.PushbackVisualAlpha=0.25

---------------------------------------------------------------------
-- PHASE END (Necrotic Obliteration)
---------------------------------------------------------------------
-- Default 10.0.
XPRACTICE.KELTHUZADMULTIPLAYER.Config.PhaseEndCastTime=10.0
-- Default 5.0.
XPRACTICE.KELTHUZADMULTIPLAYER.Config.ExitPortalTriggerRadius=5



---------------------------------------------------------------------
-- it is not recommended to change the following
---------------------------------------------------------------------
XPRACTICE.KELTHUZADMULTIPLAYER.Config.MainPhaseYOffset=-100
XPRACTICE.KELTHUZADMULTIPLAYER.Config.MainPhasePhylacteryTriggerYOffset=-30
XPRACTICE.KELTHUZADMULTIPLAYER.Config.MainPhasePhylacteryTriggerRadius=12
XPRACTICE.KELTHUZADMULTIPLAYER.Config.BossGCDSafetyBuffer=5.0