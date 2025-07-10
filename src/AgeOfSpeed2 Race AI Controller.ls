property ancestor, pCurrentToken, pPlayerRef, pWeaponTimer
global gGame

on new me, kPlayerRef, kAIType, kAiConfsetsDriveData
  ancestor = script("Race AI Controller").new(kPlayerRef, kAIType, kAiConfsetsDriveData)
  me.SetPlayerRef(kPlayerRef)
  pPlayerRef = kPlayerRef
  pWeaponTimer = -1
  return me
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
  lWorldRight = pPlayerRef.GetWorldRight()
  lAcceleration = 1.0
  lSteering = 0.0
  lVehicle = pPlayerRef.GetVehicle()
  lDt = gGame.GetHavokPhysics().GetTimeStep()
  if not voidp(lTargetPos) then
    lTargetPosition = lTargetPos - lVehicle.GetWorldRBPos()
    lDotY = lTargetPosition.dot(lWorldForward)
    lDotX = lTargetPosition.dot(lWorldRight)
    lTarget = (lDotY * lWorldForward) + (lDotX * lWorldRight)
    lAngleToTarget = lTarget.angleBetween(lWorldForward)
    lVersusToTarget = lTarget.crossProduct(lWorldForward)
    lSign = Sign(lVersusToTarget.dot(lVehicle.GetWorldUp()))
    lSteering = lSign * lAngleToTarget / 8.0
    lSteering = Clamp(lSteering, -1.0, 1.0)
    lCurrVel = pPlayerRef.GetVelocity()
    lPreviousVelocity = pPlayerRef.GetPreviousVelocity()
    lCurrSpeed = pPlayerRef.GetSpeed()
    lNormalizedCurrentVelocity = lCurrVel.duplicate()
    lNormalizedCurrentVelocity.normalize()
    lNormalizedCurrentVelocity.z = lNormalizedCurrentVelocity.x
    lNormalizedCurrentVelocity.x = lNormalizedCurrentVelocity.y
    lNormalizedCurrentVelocity.y = -lNormalizedCurrentVelocity.z
    lNormalizedCurrentVelocity.z = 0.0
    lNormalizedCurrentVelocity = lWorldRight.duplicate()
    lAcceleration = (lCurrVel - lPreviousVelocity) / lDt
    lVersus = lCurrVel.crossProduct(lAcceleration)
    if lVersus.dot(lVehicle.GetWorldUp()) > 0.0 then
      CurrentVelocityNorm = -CurrentVelocityNorm
    end if
    lAccelerationModule = lAcceleration.magnitude
    if lAccelerationModule <> 0.0 then
      lAccelerationCircleRadius = lCurrSpeed * lCurrSpeed / lAccelerationModule
      lAccelerationCircleCenter = lVehicle.GetWorldRBPos() + (lNormalizedCurrentVelocity * lAccelerationCircleRadius)
      lTargetPosition = lTargetPos.duplicate()
      lCircleTargetDistance = (lTargetPosition - lAccelerationCircleCenter).magnitude
      lGoingBackward = 0
      lGoingForward = 0
      if lCircleTargetDistance < lAccelerationCircleRadius then
        lGoingBackward = 1
        lGoingForward = 0
      else
        lGoingForward = 1
        lGoingBackward = 0
      end if
      if lGoingForward then
        lAcceleration = 1.0
      end if
      if lGoingBackward then
        lAcceleration = -1.0
      end if
    end if
  end if
  me.SetAcceleration(lAcceleration)
  me.SetSteering(lSteering)
end

on WeaponCondition me, kCurrentWeapon
  lValutation = 1
  case kCurrentWeapon of
    #missile:
      lPositionInRace = gGame.GetPositionInRace(pPlayerRef)
      if lPositionInRace = 1 then
        lValutation = 0
      end if
    #god:
    #electric:
      lDistanceFromPlayer = pPlayerRef.GetVehicle().GetTrackPos() - gGame.GetPlayerVehicle().GetTrackPos()
      if (lDistanceFromPlayer < 0) or (lDistanceFromPlayer > 1400) then
        lValutation = 0
      end if
  end case
  return lValutation
end

on UpdateWeapon me, kTime
  if (kTime - pWeaponTimer) > 2000 then
    lCurrentWeapon = pPlayerRef.GetCurrentWeapon()
    if not voidp(lCurrentWeapon) then
      if me.WeaponCondition(lCurrentWeapon) then
        me.GetRacePlayer().UseWeapon()
      end if
    end if
    pWeaponTimer = kTime
  end if
end

on update me, kTime
  lVehicle = pPlayerRef.GetVehicle()
  lCurrentToken = lVehicle.GetCurrentToken()
  if pCurrentToken <> lCurrentToken then
    pCurrentToken = lCurrentToken
    lAiType = lVehicle.GetCurrentTokenRef().AiType
    if me.GetState() <> lAiType then
      me.ChangeState(lAiType, kTime)
    end if
  end if
  me.ancestor.ancestor.update(kTime)
  lPlayerPosition = pPlayerRef.getPosition()
  me.UpdateDrive(lPlayerPosition, me.GetTargetPosition(), me.GetBrakeFactor())
  if gGame.GetGameStatus() <> #play then
    return 
  end if
  me.UpdateWeapon(kTime)
end
