property ancestor, pAIController, pDriftTimer, pDrifting, pEnableDrift, pWheeling, pWheelieTimer, pEnableWheelie, pIsJumping, pMaxDistanceFromGround, pCurrentWeapon, pUnderWeaponEffect, pGodMode, pUnderMissileTarget, pPreviousUnderMissileTarget, pMirinoMdl, pMissileDistance, pUnderMissileTargetCount, pLastBipTime, pUnderElektro, pUnderElektroTimer, pUnderMissile, pUnderMissileTimer
global gGame

on new me, kName, kPlayerId, kVehicleId, kCPUControl, kAIType, kOBBData, kDriveData, kConfSet, kQuadTree
  lVehicle = script("AgeOfSpeed2 Vehicle").new()
  lHumanInputController = script("AgeOfSpeed2 Human Input Controller").new(me, kDriveData)
  lAiConfsetsDriveData = [#DistanceForBestTrasversal: -1, #CPUMinLookahead: kConfSet.CPUMinLookahead, #CPUSpeedLookaheadFactor: kConfSet.CPUSpeedLookaheadFactor]
  pAIController = script("AgeOfSpeed2 Race AI Controller").new(me, kAIType, lAiConfsetsDriveData)
  pAIController.SetAccelerationCircleRatio(0.92000000000000004)
  pAIController.SetTargetTrasversalStep(0.10000000000000001)
  pAIController.SetBestTrasversalSmoothCoeff(0.59999999999999998)
  pAIController.SetMinTargetTrasversal(-0.65000000000000002)
  pAIController.SetMaxTargetTrasversal(0.65000000000000002)
  lShadowData = [#visible: 1, #ShadowInclinationLimit: -1.0, #ShadowMdlName: "veh_shadow_" & kPlayerId]
  lShadowSript = script("Calc Hover Shadow").new(lShadowData)
  lShadowData = [#shadow: lShadowSript, #shadowType: #calculated]
  me.ancestor = script("Race Player").new(kName, kPlayerId, kVehicleId, lVehicle, lHumanInputController, pAIController, kCPUControl)
  lVehicle.SetChassisRbName("veh_chassis_" & kPlayerId)
  lVehicle.SetRestoreZ(-8000000)
  lVehicle.SetRestoreAutoFlip(0)
  lVehicle.SetCalculateTrackPos(0)
  lVehicle.SetTurnOnSteering(1)
  lVehicle.SetRotationalCoeffType(#GraphCurve)
  lGraphCurve = [[#x: 0.0, #y: 0.0], [#x: 5.0, #y: 0.20000000000000001], [#x: 20.0, #y: 1.60000000000000009], [#x: 120.0, #y: 1.0], [#x: 400.0, #y: 0.75]]
  lVehicle.SetRotationalCoeffGraphCurve(script("GraphCurve").new(lGraphCurve))
  lVehicle.SetResetToTrackCallbackData(#ResetToTrackCallback, gGame.GetGameplay())
  lVehicle.SetOnCullerRayBlock(1)
  lVehicle.SetSlopeImpulseActive(0)
  lVehicle.Initialize(me, lShadowData, kOBBData, kConfSet, kDriveData, kQuadTree)
  lVehicle.GetShadow().SetShadowZOffset(8.0)
  lVehicle.GetShadow().SetShadowMdl(VOID)
  lVehicleGfx = script("AgeOfSpeed2 Vehicle Graphics").new(me, lVehicle, kConfSet)
  me.SetVehicleGfx(lVehicleGfx)
  me.GetVehicleGfx().Initialize(kConfSet)
  lVehicleEffects = script("AgeOfSpeed2 Vehicle Effects").new(me, lVehicle, lVehicleGfx, kConfSet)
  me.SetVehicleEffects(lVehicleEffects)
  lVehicleEffects.Initialize()
  me.Initialize()
  return me
end

on Initialize me
  me.ancestor.Initialize()
  pDriftTimer = -1
  pDrifting = 0
  pEnableDrift = 1
  pWheeling = 0
  pEnableWheelie = 1
  pIsJumping = 0
  pMaxDistanceFromGround = 0
  pCurrentWeapon = VOID
  pUnderWeaponEffect = 0
  pGodMode = 0
  pUnderMissileTarget = 0
  pPreviousUnderMissileTarget = 0
  pUnderMissileTargetCount = 0
  pUnderElektro = 0
  pUnderElektroTimer = -1
  pUnderMissile = 0
  pUnderMissileTimer = -1
end

on GetAiController me
  return pAIController
end

on GetUnderElektro me
  return pUnderElektro
end

on GetUnderMissile me
  return pUnderMissile
end

on SetUnderElektro me, kValue
  pUnderElektro = kValue
  pUnderElektroTimer = gGame.GetTimeManager().GetTime()
  me.SetUnderWeaponEffect(1)
end

on SetUnderMissile me, kValue
  pUnderMissile = kValue
  pUnderMissileTimer = gGame.GetTimeManager().GetTime()
  me.SetUnderWeaponEffect(1)
end

on GamePaused me
  me.ancestor.GamePaused()
  me.GetVehicleEffects().GamePaused()
end

on GameResumed me
  me.ancestor.GameResumed()
  me.GetVehicleEffects().GameResumed()
end

on GetCurrentWeapon me
  return pCurrentWeapon
end

on GodMode me
  return pGodMode
end

on SetMissileDistance me, kDistance
  pMissileDistance = kDistance
end

on SetCurrentWeapon me, kWeaponType
  pCurrentWeapon = kWeaponType
end

on SetUnderWeaponEffect me, kValue
  if kValue then
    pUnderWeaponEffect = pUnderWeaponEffect + 1
  else
    pUnderWeaponEffect = pUnderWeaponEffect - 1
  end if
end

on SetGodMode me, kValue
  pGodMode = kValue
end

on HaveWeapon me
  return not voidp(pCurrentWeapon)
end

on IsUnderWeaponEffect me
  return pUnderWeaponEffect > 0
end

on SetUnderMissileTarget me, kValue
  if kValue then
    pUnderMissileTarget = kValue
    pUnderMissileTargetCount = pUnderMissileTargetCount + 1
  else
    pUnderMissileTargetCount = pUnderMissileTargetCount - 1
    if pUnderMissileTargetCount = 0 then
      pUnderMissileTarget = kValue
    end if
  end if
end

on UseWeapon me
  if me.HaveWeapon() and not me.IsUnderWeaponEffect() then
    case pCurrentWeapon of
      #missile:
        gGame.GetMissileManager().ShootMissile(me)
        if me.GetPlayerId() = 1 then
          gGame.GetGameSoundManager().PlaySound("snd_lancio_missile", 2)
          gGame.GetInGame().ShowActiveWeapon(#none)
        end if
      #god:
        me.SetGodMode(1)
        me.GetVehicleEffects().StartGodMode()
        if me.GetPlayerId() = 1 then
          gGame.GetGameSoundManager().PlaySound("snd_invulnerability", 2)
          gGame.GetInGame().ShowActiveWeapon(#none)
        end if
      #electric:
        me.GetVehicleEffects().StartElektro()
        if me.GetPlayerId() = 1 then
          gGame.GetGameSoundManager().PlaySound("snd_lighting_bolt", 2)
          gGame.GetInGame().ShowActiveWeapon(#none)
        end if
    end case
    pCurrentWeapon = VOID
  end if
end

on UpdateJumping me, kTime
  lDistanceFromGround = Clamp(abs(me.GetVehicle().GetGroundDistance()), 0.0, 1000.0)
  if pIsJumping then
    if lDistanceFromGround > pMaxDistanceFromGround then
      pMaxDistanceFromGround = lDistanceFromGround
    end if
    if lDistanceFromGround < 65.0 then
      pIsJumping = 0
      if pMaxDistanceFromGround >= 400 then
        if me.GetPlayerId() = 1 then
          if me.GetVehicle().GetShadowVisible() then
            if gGame.GetGameStatus() = #play then
              gGame.GetGameSoundManager().PlaySound("snd_land", 1)
            end if
            lFact = pMaxDistanceFromGround * 0.0033
            lFact = Clamp(lFact, 5.0, 50.0)
            lIntensity = lFact * 15.0
            lDuration = 200.0 + (lFact * 20.0)
            gGame.GetCamera().StartNoisePointAt(kTime, lDuration, lIntensity)
            gGame.GetCamera().StartNoise(kTime, lDuration, lIntensity)
          end if
        end if
        if me.GetVehicle().GetShadowVisible() then
          me.GetVehicleEffects().StartSparkesDown(kTime)
        end if
      end if
      pMaxDistanceFromGround = 0
    end if
  else
    if lDistanceFromGround > 65.0 then
      pIsJumping = 1
    end if
  end if
end

on UpdateUnderElektro me, kTime
  if pUnderElektroTimer <> -1 then
    if (kTime - pUnderElektroTimer) > 1000 then
      pUnderElektroTimer = -1
      pUnderElektro = 0
      me.SetUnderWeaponEffect(0)
    end if
  end if
end

on UpdateUnderMissile me, kTime
  if pUnderMissileTimer <> -1 then
    if (kTime - pUnderMissileTimer) > 1000 then
      pUnderMissileTimer = -1
      pUnderMissile = 0
      me.SetUnderWeaponEffect(0)
    end if
  end if
end

on update me, kTime
  me.ancestor.update(kTime)
  me.UpdateJumping(kTime)
end

on ExitFrameUpdate me, kTime
  me.ancestor.ExitFrameUpdate(kTime)
  me.GetVehicleGfx().update(kTime)
  me.GetVehicleEffects().update(kTime)
  me.UpdateUnderElektro(kTime)
  me.UpdateUnderMissile(kTime)
end
