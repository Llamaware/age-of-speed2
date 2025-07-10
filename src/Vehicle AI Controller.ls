property ancestor, pPlayerRef, pAIType, pActive, pAcceleration, pSteering, pCPUMinLookahead, pCPUSpeedLookaheadFactor, pDistanceForBestTrasversal, pCurrentToken, pBestTrasversal, pTargetTrasversal, pTargetPosition, pBrakeFactor, pTargetTrasversalStep, pBestTrasversalSmoothCoeff, pMinTargetTrasversal, pMaxTargetTrasversal, pAccelerationCircleRatio, pTargetModel, pTakeRightSideMinTrasversalLimit, pTakeRightSideMaxTrasversalLimit, pForceSteering
global gGame

on new me, kPlayerRef, kStartPos, kNavMesh
  lMyFSM = script("FSM").new()
  lMyFSM.AddState(#VoidState, #VoidEnter, #VoidExec, #VoidExit, script("Void state"))
  me.ancestor = script("FSM object").new(lMyFSM, #VoidState)
  pPlayerRef = kPlayerRef
  pActive = 0
  pDistanceForBestTrasversal = -1
  me.Initialize()
  return me
end

on Initialize me
  pAcceleration = 0.0
  pSteering = 0.0
  pBrakeFactor = 0.0
  pForceSteering = 0.0
  pBestTrasversal = 0.0
  pTargetTrasversal = 0.0
  pTargetTrasversalStep = 1.30000000000000004
  pBestTrasversalSmoothCoeff = 8.0
  pMinTargetTrasversal = -0.80000000000000004
  pMaxTargetTrasversal = 0.80000000000000004
  pAccelerationCircleRatio = 1.0
  pTakeRightSideMaxTrasversalLimit = 0.75
  pTakeRightSideMinTrasversalLimit = -0.75
end

on GetPlayerRef me
  return pPlayerRef
end

on GetTargetPosition me
  if voidp(pTargetPosition) then
    return VOID
  else
    return pTargetPosition.duplicate()
  end if
end

on GetAcceleration me
  return pAcceleration
end

on GetSteering me
  return pSteering
end

on SetTargetPosition me, kValue
  pTargetPosition = kValue
end

on SetPlayerRef me, kValue
  pPlayerRef = kValue
end

on SetAcceleration me, kAcceleration
  pAcceleration = kAcceleration
end

on SetSteering me, kSteering
  pSteering = kSteering
end

on SetActive me, kValue
  pActive = kValue
end

on SetBrakeFactor me, kValue
  pBrakeFactor = kValue
end

on SetForceSteering me, kValue
  pForceSteering = kValue
end

on SetTargetModel me, kMdl
  pTargetModel = kMdl
  pTargetModel.visibility = #front
end

on UpdateDrive me, kVehiclePosition, kTargetPosition, kBrakeFactor
  lTargetPos = kTargetPosition
  lVehiclePosition = kVehiclePosition
  lBrakeFactor = kBrakeFactor
  if voidp(lBrakeFactor) then
    lBrakeFactor = 0.0
  end if
  lWorldForward = pPlayerRef.GetWorldForward()
  if voidp(lWorldForward) then
    return 
  end if
  pAcceleration = 0.0
  if not voidp(lTargetPos) then
    lTargetPosition = lTargetPos.duplicate()
    lTargetPosition.z = lVehiclePosition.z
    lWorldForward2D = lWorldForward.duplicate()
    lWorldForward2D.z = 0.0
    lWorldForward2D.normalize()
    lTargetDirection = lTargetPos - lVehiclePosition
    lTargetDirection.z = 0.0
    lTargetDirection.normalize()
    lAngleToTarget = lTargetDirection.angleBetween(lWorldForward2D)
    lVersusToTarget = lTargetDirection.crossProduct(lWorldForward2D)
    lSign = Sign(lVersusToTarget.z)
    pSteering = lSign * lAngleToTarget / 8.0
    if pForceSteering <> 0.0 then
      pSteering = pForceSteering
    end if
    pSteering = Clamp(pSteering, -1.0, 1.0)
  end if
  if not voidp(lTargetPos) then
    lCurrVel = pPlayerRef.GetVelocity()
    lPreviousVelocity = pPlayerRef.GetPreviousVelocity()
    lCurrSpeed = pPlayerRef.GetSpeed()
    lNormalizedCurrentVelocity = lCurrVel.duplicate()
    lNormalizedCurrentVelocity.normalize()
    lNormalizedCurrentVelocity.z = lNormalizedCurrentVelocity.x
    lNormalizedCurrentVelocity.x = lNormalizedCurrentVelocity.y
    lNormalizedCurrentVelocity.y = -lNormalizedCurrentVelocity.z
    lNormalizedCurrentVelocity.z = 0.0
    lAcceleration = (lCurrVel - lPreviousVelocity) / gGame.GetHavokPhysics().GetTimeStep()
    lVersus = lCurrVel.crossProduct(lAcceleration)
    if lVersus.z > 0.0 then
      lNormalizedCurrentVelocity = -lNormalizedCurrentVelocity
    end if
    lAccelerationModule = lAcceleration.magnitude
    if lAccelerationModule <> 0.0 then
      lAccelerationCircleRadius = lCurrSpeed * lCurrSpeed / lAccelerationModule
      lAccelerationCircleCenter = lVehiclePosition + (lNormalizedCurrentVelocity * lAccelerationCircleRadius)
      lAccelerationCircleCenter.z = 0.0
      lTargetPosition = lTargetPos.duplicate()
      lTargetPosition.z = 0.0
      lCircleTargetDistance = (lTargetPosition - lAccelerationCircleCenter).magnitude
      lGoingBackward = 0
      lGoingForward = 0
      if lCircleTargetDistance < (lAccelerationCircleRadius * pAccelerationCircleRatio) then
        lGoingBackward = 1
        lGoingForward = 0
      else
        lGoingForward = 1
        lGoingBackward = 0
      end if
      if lGoingForward and (lBrakeFactor = 0.0) then
        pAcceleration = 1.0
      end if
      if lBrakeFactor <> 0.0 then
        pAcceleration = lBrakeFactor
      end if
      if lGoingBackward then
        pAcceleration = -1.0
      end if
    end if
  end if
end

on update me, kTime
  if not pActive then
    return 
  end if
  me.ancestor.update(kTime)
  lPlayerPosition = pPlayerRef.getPosition()
  me.UpdateDrive(lPlayerPosition, pTargetPosition, pBrakeFactor)
  if voidp(pTargetPosition) then
    return 
  end if
  if not voidp(pTargetModel) then
    pTargetModel.transform.position = pTargetPosition
    pTargetModel.transform.position.z = pPlayerRef.getPosition().z + 100.0
  end if
end
