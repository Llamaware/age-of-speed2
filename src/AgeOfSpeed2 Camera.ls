property ancestor, pTarget, pCameraType, pCameraData, pTargetOffset, pTargetOffsetTo, pCameraSourceOffset, pCameraSourceOffsetTo, pTransitionSteps, pTargetSteps, pSourceInterpolationDone, pTargetInterpolationDone, pTopViewHeight, pTopViewHeightMin, pTopViewHeightMax, pFOVEffectCoeff, pSlideShowAnimationData, pActualSlideShowAnimations, pCurrentSlideShowAnimation, pSlideShowInitTime, pFogParameters, pSmoothSourceOffsetTimer, pSmoothSourceOffsetInterpolationTime, pWithTimeFactorInterpolation, pTimeFactorStart, pTimeFactorEnd, pIntTransformStart, pIntTransformEnd, pIntStartTime, pIntEndTime, pCameraSourceOffsetStartInterp, pTargetOffsetStartInterp, pSmoothTargetOffsetInterpolationTime, pSmoothTargetOffsetTimer, pIntActive, pFadeActive, pPreviousTransform, pCameraSubType, pTargetRef, pTargetTransform, pNoise, pNoiseTimer, pNoiseIntensity, pNoisePointAt, pNoisePointAtTimer, pNoisePointAtIntensity, pTokenOrientationActive, pInterpolationValue, pInterpolationValueTo, pSpeedCoeff, pSpeedBase, pSlideRotationSign, pFadeEnterInterpolationStarted, pInterpolationTimer, pSpeedFactor, pRotCoeff, pPlayerInclination, pOnLoop, pDisablePreviousTransformTimer
global gGame

on new me
  lMyFSM = script("FSM").new()
  lMyFSM.AddState(#VoidState, #VoidEnter, #VoidExec, #VoidExit, script("Void state"))
  lMyFSM.AddState(#preRender, #PrerenderEnter, #PrerenderExec, #PrerenderExit, me)
  lMyFSM.AddState(#FadeEnter, #FadeEnterEnter, #FadeEnterExec, #FadeEnterExit, me)
  lMyFSM.AddState(#GameStart, #GameStartEnter, #GameStartExec, #GameStartExit, me)
  lMyFSM.AddState(#ThirdPersonSpot, #ThirdPersonSpotEnter, #ThirdPersonSpotExec, #ThirdPersonSpotExit, me)
  lMyFSM.AddState(#ThirdPersonSpotStart, #ThirdPersonSpotStartEnter, #ThirdPersonSpotStartExec, #ThirdPersonSpotStartExit, me)
  lMyFSM.AddState(#ThirdPersonSpotFinish, #ThirdPersonSpotFinishEnter, #ThirdPersonSpotFinishExec, #ThirdPersonSpotFinishExit, me)
  lMyFSM.AddState(#top, #TopEnter, #TopExec, #TopExit, me)
  lMyFSM.AddState(#Lateral, #LateralEnter, #LateralExec, #LateralExit, me)
  me.ancestor = script("Camera").new(lMyFSM, #VoidState)
  pTopViewHeight = 10000.0
  pTopViewHeightMin = 150.0
  pTopViewHeightMax = 20000.0
  pFogParameters = [:]
  pFogParameters.addProp(#enabled, 0)
  pFogParameters.addProp(#farplane, 0)
  pFogParameters.addProp(#nearplane, 0)
  pFogParameters.addProp(#decayMode, #linear)
  pFogParameters.addProp(#colorR, 150)
  pFogParameters.addProp(#colorG, 150)
  pFogParameters.addProp(#colorB, 150)
  pIntActive = 0
  pFadeActive = 0
  pSourceInterpolationDone = 1
  pTargetInterpolationDone = 1
  pCameraSubType = #ThirthPersonSpotStart
  pTokenOrientationActive = 0
  pSmoothSourceOffsetTimer = -1
  pSmoothTargetOffsetTimer = -1
  pWithTimeFactorInterpolation = 0
  pInterpolationValue = 450.0
  pInterpolationValueTo = pInterpolationValue
  pSlideRotationSign = -1.0
  return me
end

on Initialize me, kTargetModel, kCameraData
  pTarget = kTargetModel
  pCameraData = kCameraData
end

on GetFOV me
  return me.GetCameraNode().fieldOfView
end

on GetTarget me
  return pTarget
end

on IsInterpolating me
  return pIntActive
end

on IsFading me
  return pFadeActive
end

on SetSlideRotationSign me, kValue
  pSlideRotationSign = kValue
end

on SetSpeedCoeff me, kSpeedCoeff
  pSpeedCoeff = kSpeedCoeff
end

on SetSpeedBase me, kSpeedBase
  pSpeedBase = kSpeedBase
end

on SetTarget me, kTargetModel
  pTarget = kTargetModel
end

on SetTokenOrientationActive me, kValue
  pTokenOrientationActive = kValue
end

on SetInterpolationValue me, kValue
  pInterpolationValue = kValue
end

on SetFOV me, kFOVValue
  me.GetCameraNode().fieldOfView = kFOVValue
end

on SetBackCameraOn me, kValue
  me.pIsBackCameraOn = kValue
end

on SetCameraType me, fCameraType
  me.pCameraType = fCameraType
end

on SetFogFarPlane me, fFarPlane
  pFogParameters.farplane = fFarPlane
  me.GetCameraNode().fog.far = fFarPlane
end

on SetFogNearPlane me, fNearPlane
  pFogParameters.farplane = fNearPlane
  me.GetCameraNode().fog.near = fNearPlane
end

on SetFogDecayMode me, fDecayMode
  pFogParameters.decayMode = fDecayMode
  me.GetCameraNode().fog.decayMode = fDecayMode
end

on SetFogColor me, fColorR, fColorG, fColorB
  if voidp(pFogParameters.findPos(#colorR)) then
    pFogParameters.addProp(#colorR, fColorR)
  else
    pFogParameters[#colorR] = fColorR
  end if
  if voidp(pFogParameters.findPos(#colorG)) then
    pFogParameters.addProp(#colorG, fColorG)
  else
    pFogParameters[#colorG] = fColorG
  end if
  if voidp(pFogParameters.findPos(#colorB)) then
    pFogParameters.addProp(#colorB, fColorB)
  else
    pFogParameters[#colorB] = fColorB
  end if
  me.GetCameraNode().fog.color = color(#rgb, pFogParameters.colorR, pFogParameters.colorG, pFogParameters.colorB)
end

on SetupCameraSubType me, kSubType, kTransitionSteps, kForceChange
  put "SetupCameraSubType: " & pCameraSubType & ", " & kSubType & " kTransitionSteps: " & kTransitionSteps
  lCanChange = 0
  if pCameraSubType <> kSubType then
    lCanChange = 1
  else
    if kForceChange <> VOID then
      if kForceChange = 1 then
        lCanChange = 1
      end if
    end if
  end if
  if lCanChange then
    pTransitionSteps = kTransitionSteps
    pCameraSubType = kSubType
    me.SetupCameraData(pTransitionSteps)
  end if
end

on SetupCameraData me, kTransitionSteps
  case pCameraType of
    #ThirthPerson:
      lCameraData = VOID
      case pCameraSubType of
        #ThirthPerson_Spot:
          lCameraData = pCameraData.ThirthPerson_Spot
        #ThirthPerson_SpotStart:
          lCameraData = pCameraData.ThirthPerson_SpotStart
        #ThirthPerson_SpotFinish:
          lCameraData = pCameraData.ThirthPerson_SpotFinish
      end case
      pCameraUp = lCameraData.CameraUp
      pSourceSteps = lCameraData.SourceSteps
      pTargetSteps = lCameraData.TargetSteps
      if (pTransitionSteps = 0) or (pTransitionSteps = -1) then
        pCameraSourceOffset = lCameraData.CameraSourceOffset.duplicate()
        pOffset = lCameraData.CameraSourceOffset.duplicate()
        pTargetOffset = lCameraData.TargetOffset
        if pTransitionSteps = -1 then
          pImmediateTransition = 1
          pTransitionSteps = 0
        end if
      end if
      pOffsetTo = lCameraData.CameraSourceOffset.duplicate()
      pOffset = pOffsetTo
      pTargetOffsetTo = lCameraData.TargetOffset.duplicate()
      pCameraSourceOffsetTo = lCameraData.CameraSourceOffset.duplicate()
  end case
end

on SetCameraSourceOffsetInterpolation me, kCameraSourceOffset, kInterpolationTime, kWithTimeFactorInterpolation, kTimeFactorStart, kTimeFactorEnd
  pCameraSourceOffsetTo = kCameraSourceOffset
  pCameraSourceOffsetStartInterp = pCameraSourceOffset
  pSmoothSourceOffsetInterpolationTime = kInterpolationTime
  pSmoothSourceOffsetTimer = gGame.GetTimeManager().GetTime()
  pWithTimeFactorInterpolation = kWithTimeFactorInterpolation
  pTimeFactorStart = kTimeFactorStart
  pTimeFactorEnd = kTimeFactorEnd
end

on SetCameraTargetOffsetInterpolation me, kTargetOffset, kInterpolationTime
  pTargetOffsetTo = kTargetOffset
  pTargetOffsetStartInterp = pTargetOffset
  pSmoothTargetOffsetInterpolationTime = kInterpolationTime
  pSmoothTargetOffsetTimer = gGame.GetTimeManager().GetTime()
end

on DisableFog me
  pFogParameters.enabled = 0
  me.GetCameraNode().fog.enabled = 0
end

on EnableFog me
  pFogParameters.enabled = 1
  me.GetCameraNode().fog.enabled = 1
end

on SetupCameraPosition me, kSourceOffset, kTargetOffset
  lTargetRef = gGame.GetPlayerVehicle()
  lTargetTransform = lTargetRef.GetTransform().duplicate()
  lTargetTransform.scale = vector(1, 1, 1)
  lFrom = lTargetTransform * kSourceOffset
  lCamNode = me.GetCameraNode()
  lCamNode.transform.position = lFrom.duplicate()
  lPositionTarget = lTargetRef.getPosition() + kTargetOffset
  lCamNode.pointAt(lPositionTarget, vector(0.0, 0.0, 1.0))
end

on GameStartEnter me, kCamera, kTime
  me.InitFader()
  lCamNode = me.GetCameraNode()
  lCamNode.fieldOfView = 15.0
  lCamNode.colorBuffer.clearValue = rgb(64, 104, 166)
  pIntActive = 0
  pFadeActive = 0
end

on GameStartExec me, kCamera, kTime
  me.ChangeState(#VoidState, kTime)
end

on GameStartExit me, kCamera, kTime
end

on FadeEnterEnter me, kCamera, kTime
  put "*** FadeEnterEnter ***"
  pTargetRef = gGame.GetPlayerVehicle().GetVehicle()
  me.SetupFade(#fadeIn, kTime, 1500.0)
  me.ChangeState(#ThirdPersonSpot, kTime)
  pCameraSourceOffset = pCameraData.ThirthPersonSpotStart.CameraSourceOffset.duplicate()
  pTargetOffset = pCameraData.ThirthPersonSpotStart.TargetOffset.duplicate()
  me.SetCameraSourceOffsetInterpolation(pCameraData.BackCar.CameraSourceOffset, 3500, 0)
  me.SetCameraTargetOffsetInterpolation(pCameraData.BackCar.TargetOffset, 4000)
end

on FadeEnterExec me, kCamera, kTime
end

on FadeEnterExit me, kCamera, kTime
  put "*** FadeEnterExit ***"
end

on DisablePreviousTransform me, kTime
  pDisablePreviousTransformTimer = kTime
end

on ThirdPersonSpotEnter me, kCamera, kTime
  pTargetRef = gGame.GetPlayerVehicle().GetVehicle()
  pTargetTransform = gGame.GetPlayerVehicle().GetVehicleGfx().GetGfxChassis().transform
  put "*** ThirdPersonSpotEnter ***"
  pNoise = vector(0.0, 0.0, 0.0)
  pNoiseTimer = -1
  pNoisePointAt = vector(0.0, 0.0, 0.0)
  pNoisePointAtTimer = -1
  pSpeedCoeff = pCameraData.BackCar.SpeedCoeff
  pSpeedBase = pCameraData.BackCar.SpeedBase
  pTargetOffset = pCameraData.BackCar.TargetOffset
  pCameraSourceOffset = pCameraData.BackCar.CameraSourceOffset
  lCamNode = me.GetCameraNode()
  lCamNode.hither = 40
  lCamNode.fieldOfView = 45.0
  pRotCoeff = 0.94999999999999996
  pSpeedFactor = 1.0
  pPlayerInclination = 0.0
  pOnLoop = 0
end

on ThirdPersonSpotExec me, kCamera, kTime
  if gGame.GetConfiguration() = #debug then
    me.ThirdPersonKeyInput()
    lEvent = me.GetNextKeyEvent()
    repeat while not voidp(lEvent)
      case lEvent of
        #TopCameraMode:
          me.ChangeState(#top, kTime)
        #LateralCameraMode:
          me.ChangeState(#Lateral, kTime)
      end case
      lEvent = me.GetNextKeyEvent()
    end repeat
  end if
  pFadeActive = me.UpdateFade(kTime)
  lCamNode = me.GetCameraNode()
  lDt = gGame.GetTimeManager().GetDeltaTime() * 0.001
  if pSmoothSourceOffsetTimer <> -1 then
    if (kTime - pSmoothSourceOffsetTimer) < pSmoothSourceOffsetInterpolationTime then
      lInterpolationTime = (kTime - pSmoothSourceOffsetTimer) / pSmoothSourceOffsetInterpolationTime
      pCameraSourceOffset = pCameraSourceOffsetStartInterp + ((pCameraSourceOffsetTo - pCameraSourceOffsetStartInterp) * lInterpolationTime)
      lTimeFactor = lInterpolationTime
    else
      lTimeFactor = 1.0
      pCameraSourceOffset = pCameraSourceOffsetTo
      pSmoothSourceOffsetTimer = -1
    end if
    if pWithTimeFactorInterpolation then
      lTimeFactor = pTimeFactorStart + ((pTimeFactorEnd - pTimeFactorStart) * lTimeFactor)
      gGame.GetTimeManager().SetTimeFactor(lTimeFactor)
    end if
  end if
  if pSmoothTargetOffsetTimer <> -1 then
    if (kTime - pSmoothTargetOffsetTimer) < pSmoothTargetOffsetInterpolationTime then
      lInterpolationTime = (kTime - pSmoothTargetOffsetTimer) / pSmoothTargetOffsetInterpolationTime
      pTargetOffset = pTargetOffsetStartInterp + ((pTargetOffsetTo - pTargetOffsetStartInterp) * lInterpolationTime)
    else
      pTargetOffset = pTargetOffsetTo
      pSmoothTargetOffsetTimer = -1
    end if
  end if
  lZeroVector = vector(0.0, 0.0, 0.0)
  lTargetTransform = pTargetTransform.duplicate()
  lTo = lTargetTransform * pTargetOffset
  lWorldUpDir = pTargetTransform.zAxis
  lVehicleDir = lTargetTransform.yAxis
  lBackCarCameraData = pCameraData.BackCar
  lSlideSpeed = pTargetRef.GetSlideSpeed()
  lSlideAngle = lSlideSpeed / lBackCarCameraData.AngleCoeff
  lMatSlideRotation = transform()
  lMatSlideRotation.rotation.z = pSlideRotationSign * lSlideAngle * 180.0 / PI
  lVehicleDir = lMatSlideRotation * lVehicleDir
  lTangent = pTargetRef.pTokenTangent
  lMaxAngle1 = PI * 0.5
  lMaxAngle2 = PI
  lDistFactor = 0.0
  lResetFactor = 0.0
  lAxisAngle = me.FindAxisAnglePair(lTangent, lVehicleDir)
  if lAxisAngle.angle > lMaxAngle2 then
    lDistFactor = (lAxisAngle.angle - lMaxAngle2) / (PI - lMaxAngle2)
  end if
  if lAxisAngle.angle > lMaxAngle1 then
    lResetFactor = (lAxisAngle.angle - lMaxAngle1) / (PI - lMaxAngle1)
    lAxisAngle.angle = (1.0 - lResetFactor) * lMaxAngle1
  end if
  lSpeedCoeff = (abs(pTargetRef.pSpeedKmh) / pSpeedCoeff) + pSpeedBase
  pSpeedFactor = pSpeedFactor + ((lSpeedCoeff - pSpeedFactor) * lDt * 4.79999999999999982)
  lNegativeSpeedCoeff = pTargetRef.pSpeedKmh / 600.0
  if lNegativeSpeedCoeff > 0.0 then
    lNegativeSpeedCoeff = 0.0
  end if
  lOffset = pCameraSourceOffset.duplicate()
  lOffset.y = lOffset.y - (lDistFactor * 180.0)
  lOffset.z = lOffset.z + (lDistFactor * 300.0)
  lOffset = vector(lOffset.x, lOffset.z - (lNegativeSpeedCoeff * 400.0), -lOffset.y * pSpeedFactor)
  if pTokenOrientationActive then
    lMatAxisAngle = transform()
    lMatAxisAngle.rotate(lZeroVector, lAxisAngle.axis, lAxisAngle.angle * 180.0 / PI)
    lCamDir = lMatAxisAngle * lTangent
  else
    lCamDir = pTarget.transform.yAxis
  end if
  lCamNode.transform.position = lZeroVector
  lCamNode.pointAt(lCamDir * 20.0, lWorldUpDir)
  lMatCam = lCamNode.transform.duplicate()
  if pDisablePreviousTransformTimer <> -1 then
    if (kTime - pDisablePreviousTransformTimer) > 800 then
      pDisablePreviousTransformTimer = -1
    end if
    pPreviousTransform = VOID
  end if
  if voidp(pPreviousTransform) then
    pPreviousTransform = lMatCam
  else
    pInterpolationValue = pInterpolationValue + ((pInterpolationValueTo - pInterpolationValue) * lDt * 2.0)
    lIntValue = pInterpolationValue * lDt
    if lIntValue > 100.0 then
      lIntValue = 100.0
    end if
    pPreviousTransform.interpolateTo(lMatCam, lIntValue)
  end if
  lWorldOffset = pPreviousTransform * lOffset
  lFrom = lTo + lWorldOffset
  lCameraTransitionSmoothCoeff = lDt * 10.0
  lNoisePointAtActive = 0
  if (kTime - pNoisePointAtTimer) < 0 then
    lNoisePointAtActive = 1
  end if
  if lNoisePointAtActive then
    lNoise = randomVector()
    lNoise = random(pNoisePointAtIntensity) * lNoise
    pNoisePointAt = pNoisePointAt + ((lNoise - pNoisePointAt) * lDt * 8.5)
  else
    pNoisePointAt = vector(0.0, 0.0, 0.0)
  end if
  lNoiseActive = 0
  if (kTime - pNoiseTimer) < 0 then
    lNoiseActive = 1
  end if
  if lNoiseActive then
    lNoise = randomVector()
    lNoise = random(pNoiseIntensity) * lNoise
    pNoise = pNoise + ((lNoise - pNoise) * lDt * 8.5)
  else
    pNoise = vector(0.0, 0.0, 0.0)
  end if
  lCamNode.transform.position = lFrom + pNoise
  lCamNode.pointAt(lTo + pNoisePointAt, lWorldUpDir)
  lPlayerInclinationTo = -gGame.GetPlayerVehicle().GetVehicleGfx().GetRollAngle() * 4.5
  lSmooth = 10.0
  if pPlayerInclination < lPlayerInclinationTo then
    lSmooth = 7.5
  end if
  pPlayerInclination = pPlayerInclination + ((lPlayerInclinationTo - pPlayerInclination) * lDt * lSmooth)
  lTR = transform()
  lTR.rotation = vector(0.0, 0.0, 1.0) * pPlayerInclination
  lCamNode.transform = lCamNode.transform * lTR
  if gGame.GetGameStatus() = #play then
    lOnLoop = pTargetRef.GetCurrentTokenRef().token = "loop"
    if lOnLoop then
      if not pOnLoop then
        pOnLoop = 1
        me.SetCameraSourceOffsetInterpolation(vector(0.0, -600.0, -180.0), 600, 0)
        me.SetCameraTargetOffsetInterpolation(vector(-24.0, 62.0, 230.0), 600)
      end if
    else
      if pOnLoop then
        me.SetCameraSourceOffsetInterpolation(pCameraData.BackCar.CameraSourceOffset, 600, 0)
        me.SetCameraTargetOffsetInterpolation(pCameraData.BackCar.TargetOffset, 600)
        pOnLoop = 0
      end if
    end if
  end if
end

on ThirdPersonSpotExit me, kCamera, kTime
  put "*** ThirdPersonSpotExit ***"
end

on StartNoisePointAt me, kTime, kDuration, kNoiseIntensity
  pNoisePointAtTimer = kTime + kDuration
  pNoisePointAtIntensity = kNoiseIntensity
end

on StartNoise me, kTime, kDuration, kNoiseIntensity
  pNoiseTimer = kTime + kDuration
  pNoiseIntensity = kNoiseIntensity
end

on TopEnter me, kCamera, kTime
  pCameraType = #top
end

on TopExec me, kCamera, kTime
  lCamNode = me.GetCameraNode()
  lCamNode.transform.position = pTarget.transform.position + vector(0, 0, pTopViewHeight)
  lCamNode.pointAt(pTarget.transform.position, vector(1.0, 0.0, 0.0))
  lEvent = me.GetNextKeyEvent()
  repeat while not voidp(lEvent)
    case lEvent of
      #TopCameraMode:
        me.ChangeState(#ThirdPersonSpot, kTime)
      #LateralCameraMode:
        me.ChangeState(#Lateral, kTime)
      #TopHeightUp:
        pTopViewHeight = pTopViewHeight + 60.0
        pTopViewHeight = Clamp(pTopViewHeight, pTopViewHeightMin, pTopViewHeightMax)
      #TopHeightDown:
        pTopViewHeight = pTopViewHeight - 60.0
        pTopViewHeight = Clamp(pTopViewHeight, pTopViewHeightMin, pTopViewHeightMax)
    end case
    lEvent = me.GetNextKeyEvent()
  end repeat
end

on TopExit me, kCamera, kTime
end

on ThirdPersonSpotStartEnter me, kCamera, kTime
end

on ThirdPersonSpotStartExec me, kCamera, kTime
end

on ThirdPersonSpotStartExit me, kCamera, kTime
  pIntActive = 0
end

on ThirdPersonSpotFinishEnter me, kCamera, kTime
  me.SetupCameraMovement(VOID, #ThirthPersonSpotFinish)
end

on ThirdPersonSpotFinishExec me, kCamera, kTime
  lEndInterp = me.UpdateCameraMovement()
  return 
  lEvent = me.GetNextKeyEvent()
  repeat while not voidp(lEvent)
    case lEvent of
      #TopCameraMode:
        me.ChangeState(#ThirdPersonSpot, kTime)
      #LateralCameraMode:
        me.ChangeState(#Lateral, kTime)
      #TopHeightUp:
        pTopViewHeight = pTopViewHeight + 60.0
        pTopViewHeight = Clamp(pTopViewHeight, pTopViewHeightMin, pTopViewHeightMax)
      #TopHeightDown:
        pTopViewHeight = pTopViewHeight - 60.0
        pTopViewHeight = Clamp(pTopViewHeight, pTopViewHeightMin, pTopViewHeightMax)
    end case
    lEvent = me.GetNextKeyEvent()
  end repeat
end

on ThirdPersonSpotFinishExit me, kCamera, kTime
end

on FindAxisAnglePair me, kA, kB
  lVector = kA.cross(kB)
  lSin = lVector.magnitude
  lCos = kA.dot(kB)
  lAngle = atan(lSin / lCos)
  if lCos < 0.0 then
    lAngle = lAngle + PI
  end if
  if lSin > 0.001 then
    lVector = lVector / lSin
  end if
  assert((lAngle >= 0.0) and (lAngle <= PI), "Wrong (axis,angle) pair")
  return [#axis: lVector, #angle: lAngle]
end

on SetupCameraMovement me, kCameraDataStart, kCameraDataEnd
  if not voidp(kCameraDataStart) then
    lCameraData = pCameraData[kCameraDataStart]
    pCameraSourceOffset = lCameraData.CameraSourceOffset.duplicate()
    pTargetOffset = lCameraData.TargetOffset
    pTransitionSteps = lCameraData.SourceSteps
    pTargetSteps = lCameraData.TargetSteps
  end if
  lCameraData = pCameraData[kCameraDataEnd]
  pTargetOffsetTo = lCameraData.TargetOffset.duplicate()
  pCameraSourceOffsetTo = lCameraData.CameraSourceOffset.duplicate()
  pSourceInterpolationDone = 0
  pTargetInterpolationDone = 0
end

on UpdateCameraMovement me
  lDt = gGame.GetTimeManager().GetDeltaTime() * 0.001
  lDiffSource = vector(0.0, 0.0, 0.0)
  lDiffTarget = vector(0.0, 0.0, 0.0)
  if pTransitionSteps <> 0 then
    lCameraTransitionSmoothCoeff = lDt * 9.5
    lDiffSource = pCameraSourceOffsetTo - pCameraSourceOffset
    pCameraSourceOffset = (lDiffSource * (lCameraTransitionSmoothCoeff / pTransitionSteps)) + pCameraSourceOffset
    if lDiffSource.magnitude < 10 then
      pSourceInterpolationDone = 1
      pTransitionSteps = 0
    end if
  else
    pSourceInterpolationDone = 1
  end if
  if pTargetSteps <> 0 then
    lCameraTransitionSmoothCoeff = lDt * 9.5
    lDiffTarget = pTargetOffsetTo - pTargetOffset
    pTargetOffset = (lDiffTarget * (lCameraTransitionSmoothCoeff / pTargetSteps)) + pTargetOffset
    if lDiffTarget.magnitude < 10 then
      pTargetSteps = 0
      pTargetInterpolationDone = 1
    end if
  else
    pTargetInterpolationDone = 1
  end if
  if pTargetInterpolationDone and pSourceInterpolationDone then
    return 1
  end if
  me.SetupCameraPosition(pCameraSourceOffset, pTargetOffset)
  return 0
end

on SetupInterpolation me, kTransformStart, kTransformEnd, kTime, kDuration
  pIntTransformStart = kTransformStart
  pIntTransformEnd = kTransformEnd
  pIntStartTime = kTime
  pIntEndTime = kTime + kDuration
end

on UpdateInterpolation me, kTime
  lPercent = (kTime - pIntStartTime) * 100.0 / (pIntEndTime - pIntStartTime)
  lPercent = Clamp(lPercent, 0.0, 100.0)
  lTransform = pIntTransformStart.duplicate()
  lTransform.interpolateTo(pIntTransformEnd, lPercent)
  me.pCameraNode.transform = lTransform
  return lPercent = 100.0
end

on LateralEnter me, kCamera, kTime
  pCameraType = #Lateral
end

on LateralExec me, kCamera, kTime
  lCamNode = me.GetCameraNode()
  lCamNode.transform.position = pTarget.transform.position + (650 * gGame.GetPlayerVehicle().GetWorldRight())
  lCamNode.pointAt(pTarget.transform.position, vector(0.0, 0.0, 1.0))
  lEvent = me.GetNextKeyEvent()
  repeat while not voidp(lEvent)
    case lEvent of
      #TopCameraMode:
        me.ChangeState(#ThirdPersonSpot, kTime)
    end case
    lEvent = me.GetNextKeyEvent()
  end repeat
end

on LateralExit me, kCamera, kTime
end

on ThirdPersonKeyInput me
  lKeypressedSourceLateral = gGame.GetInputManager().IsKeyPressed("q")
  lKeypressedSourceDistance = gGame.GetInputManager().IsKeyPressed("w")
  lKeypressedSourceHeight = gGame.GetInputManager().IsKeyPressed("e")
  lKeypressedTargetLateral = gGame.GetInputManager().IsKeyPressed("a")
  lKeypressedTargetDistance = gGame.GetInputManager().IsKeyPressed("s")
  lKeypressedTargetHeight = gGame.GetInputManager().IsKeyPressed("d")
  lKeyPressPlus = gGame.GetInputManager().IsKeyPressed(".")
  if lKeyPressPlus then
    if lKeypressedSourceLateral then
      pCameraSourceOffset.x = pCameraSourceOffset.x + 4.0
    end if
    if lKeypressedSourceDistance then
      pCameraSourceOffset.y = pCameraSourceOffset.y + 4.0
    end if
    if lKeypressedSourceHeight then
      pCameraSourceOffset.z = pCameraSourceOffset.z + 4.0
    end if
    if lKeypressedTargetLateral then
      pTargetOffset.x = pTargetOffset.x + 4.0
    end if
    if lKeypressedTargetDistance then
      pTargetOffset.y = pTargetOffset.y + 4.0
    end if
    if lKeypressedTargetHeight then
      pTargetOffset.z = pTargetOffset.z + 4.0
    end if
  end if
  lKeyPressMinus = gGame.GetInputManager().IsKeyPressed(",")
  if lKeyPressMinus then
    if lKeypressedSourceLateral then
      pCameraSourceOffset.x = pCameraSourceOffset.x - 4.0
    end if
    if lKeypressedSourceDistance then
      pCameraSourceOffset.y = pCameraSourceOffset.y - 4.0
    end if
    if lKeypressedSourceHeight then
      pCameraSourceOffset.z = pCameraSourceOffset.z - 4.0
    end if
    if lKeypressedTargetLateral then
      pTargetOffset.x = pTargetOffset.x - 4.0
    end if
    if lKeypressedTargetDistance then
      pTargetOffset.y = pTargetOffset.y - 4.0
    end if
    if lKeypressedTargetHeight then
      pTargetOffset.z = pTargetOffset.z - 4.0
    end if
  end if
  if lKeyPressPlus or lKeyPressMinus then
    pTransitionSteps = 0
    pTargetOffsetTo = pTargetOffset
    pCameraSourceOffsetTo = pCameraSourceOffset
    put "CameraSourceOffset: " & pCameraSourceOffset & ", TargetOffset: " & pTargetOffset
  end if
end
