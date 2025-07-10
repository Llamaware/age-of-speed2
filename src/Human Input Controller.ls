property pPlayerRef, pGoingLeft, pGoingRight, pGoingForwardPressed, pGoingBackwardPressed, pKeyEvents, pActive, pAcceleration, pAccelerationFactor, pAccelerationEpsilon, pSteering, pSteeringFactor, pSteeringEpsilon
global gGame

on new me, kPlayerRef, kDriveData
  pPlayerRef = kPlayerRef
  pAccelerationFactor = kDriveData.AccelerationFactor
  pAccelerationEpsilon = kDriveData.AccelerationEpsilon
  pSteeringFactor = kDriveData.SteeringFactor
  pSteeringEpsilon = kDriveData.SteeringEpsilon
  me.Initialize()
  return me
end

on Initialize me
  pKeyEvents = []
  pGoingLeft = 0
  pGoingRight = 0
  pGoingForwardPressed = 0
  pGoingBackwardPressed = 0
  pActive = 0
  lInputManager = gGame.GetInputManager()
  lInputManager.AddKeyEvent(#LeftDown, me, 123, #OnDown)
  lInputManager.AddKeyEvent(#RightDown, me, 124, #OnDown)
  lInputManager.AddKeyEvent(#ForwardDown, me, 126, #OnDown)
  lInputManager.AddKeyEvent(#BackwardDown, me, 125, #OnDown)
  pAcceleration = 0.0
  pSteering = 0.0
end

on GetRacePlayer me
  return pPlayerRef
end

on GetAcceleration me
  return pAcceleration
end

on GetSteering me
  return pSteering
end

on GetGoingLeft me
  return pGoingLeft
end

on GetGoingRight me
  return pGoingRight
end

on GetGoingForwardPressed me
  return pGoingForwardPressed
end

on GetGoingBackwardPressed me
  return pGoingBackwardPressed
end

on SetEnableUserInput me, kValue
  pActive = kValue
end

on SetGoingLeft me, kValue
  pGoingLeft = kValue
end

on SetGoingRight me, kValue
  pGoingRight = kValue
end

on SetGoingForward me, kValue
  pGoingForwardPressed = kValue
end

on SetGoingBackward me, kValue
  pGoingBackwardPressed = kValue
end

on SetAcceleration me, kAcceleration
  pAcceleration = kAcceleration
end

on UpdateDrive me
  lDt = gGame.GetTimeManager().GetDeltaTime()
  if not pGoingForwardPressed and not pGoingBackwardPressed then
    if pAcceleration > 0.0 then
      pAcceleration = pAcceleration - (lDt * pAccelerationFactor)
    else
      pAcceleration = pAcceleration + (lDt * pAccelerationFactor)
    end if
    if (pAcceleration < pAccelerationEpsilon) and (pAcceleration > -pAccelerationEpsilon) then
      pAcceleration = 0.0
    end if
  else
    if pGoingForwardPressed then
      if pAcceleration < 0 then
        pAcceleration = 0.0
      end if
      pAcceleration = pAcceleration + (lDt * pAccelerationFactor)
    end if
    if pGoingBackwardPressed then
      if pAcceleration > 0 then
        pAcceleration = 0.0
      end if
      pAcceleration = pAcceleration - (lDt * pAccelerationFactor * 0.75)
    end if
  end if
  lNormalizedSpeed = pPlayerRef.GetVehicle().GetNormalizedSpeed()
  lSteeringFactorRelease = (0.29999999999999999 + (0.69999999999999996 * (1.0 - lNormalizedSpeed))) * pSteeringFactor
  lSteeringFactorTurning = (0.29999999999999999 + (0.69999999999999996 * (1.0 - lNormalizedSpeed))) * pSteeringFactor
  if not pGoingRight and not pGoingLeft then
    if pSteering > pSteeringEpsilon then
      pSteering = pSteering - (lDt * lSteeringFactorRelease)
      if pSteering <= -pSteeringEpsilon then
        pSteering = 0.0
      end if
    else
      if pSteering < -pSteeringEpsilon then
        pSteering = pSteering + (lDt * lSteeringFactorRelease)
        if pSteering >= pSteeringEpsilon then
          pSteering = 0.0
        end if
      end if
    end if
    if (pSteering < pSteeringEpsilon) and (pSteering > -pSteeringEpsilon) then
      pSteering = 0.0
    end if
  else
    if pGoingRight then
      pSteering = pSteering + (lDt * lSteeringFactorTurning)
    end if
    if pGoingLeft then
      pSteering = pSteering - (lDt * lSteeringFactorTurning)
    end if
  end if
  pAcceleration = Clamp(pAcceleration, -0.69999999999999996, 1.0)
  pSteering = Clamp(pSteering, -1.0, 1.0)
end

on SendKeyEvent me, kEvent
  pKeyEvents.append(kEvent)
end

on UpdateKeyEvents me
  if pActive then
    lEvent = me.GetNextKeyEvent()
    repeat while not voidp(lEvent)
      case lEvent of
        #LeftDown:
          pGoingLeft = 1
        #RightDown:
          pGoingRight = 1
        #ForwardDown:
          pGoingForwardPressed = 1
        #BackwardDown:
          pGoingBackwardPressed = 1
      end case
      lEvent = me.GetNextKeyEvent()
    end repeat
  end if
end

on FlushKeyEvents me
  pKeyEvents = []
end

on GetNextKeyEvent me
  lEventsCount = pKeyEvents.count
  if lEventsCount > 0 then
    lEvent = pKeyEvents[lEventsCount]
    pKeyEvents.deleteAt(lEventsCount)
    return lEvent
  else
    return VOID
  end if
end

on update me, kTime
  pGoingLeft = 0
  pGoingRight = 0
  pGoingForwardPressed = 0
  pGoingBackwardPressed = 0
  if pActive then
    me.UpdateKeyEvents()
  end if
  me.FlushKeyEvents()
  me.UpdateDrive(kTime)
end
