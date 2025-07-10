property pPlayer, pVehicle, pGfxChassis, pPlayerGfx, pRollAngle, pRollAngleCoeff, pRollSmoothCoeff, pRollSmoothCoeffReturn, pMinRollAngle, pMaxRollAngle, pPitchAngle, pPitchAngleCoeff, pMinPitchAngle, pMaxPitchAngle, pPitchSmoothCoeff, pWheelRadius, pWheelList, pWheelContactPointList
global gGame

on new me, kPlayer, kVehicle, kConfSet
  pPlayer = kPlayer
  pVehicle = kVehicle
  pWheelRadius = kConfSet.WheelRadius
  return me
end

on GetGfxChassis me
  return pGfxChassis
end

on GetPlayerGfx me
  return pPlayerGfx
end

on GetPlayer me
  return pPlayer
end

on GetVehicle me
  return pVehicle
end

on GetPitchAngle me
  return pPitchAngle
end

on GetRollAngle me
  return pRollAngle
end

on GetWheelList me
  return pWheelList
end

on GetWheelContactPointList me
  return pWheelContactPointList
end

on GetMinRollAngle me
  return pMinRollAngle
end

on GetMaxRollAngle me
  return pMaxRollAngle
end

on SetGfxChassis me, kGfxChassis
  pGfxChassis = kGfxChassis
end

on SetPlayerGfx me, kPlayerGfx
  pPlayerGfx = kPlayerGfx
end

on SetRollAngle me, kRollAngle
  pRollAngle = kRollAngle
end

on SetRollAngleCoeff me, kRollAngleCoeff
  pRollAngleCoeff = kRollAngleCoeff
end

on SetRollSmoothCoeff me, kRollSmoothCoeff
  pRollSmoothCoeff = kRollSmoothCoeff
end

on SetRollSmoothCoeffReturn me, kRollSmoothCoeffReturn
  pRollSmoothCoeffReturn = kRollSmoothCoeffReturn
end

on SetMinRollAngle me, kMinRollAngle
  pMinRollAngle = kMinRollAngle
end

on SetMaxRollAngle me, kMaxRollAngle
  pMaxRollAngle = kMaxRollAngle
end

on SetPitchAngle me, kPitchAngle
  pPitchAngle = kPitchAngle
end

on SetPitchAngleCoeff me, kPitchAngleCoeff
  pPitchAngleCoeff = kPitchAngleCoeff
end

on SetMinPitchAngle me, kMinPitchAngle
  pMinPitchAngle = kMinPitchAngle
end

on SetMaxPitchAngle me, kMaxPitchAngle
  pMaxPitchAngle = kMaxPitchAngle
end

on SetPitchSmoothCoeff me, kPitchSmoothCoeff
  pPitchSmoothCoeff = kPitchSmoothCoeff
end

on SetWheelList me, kWheelList
  pWheelList = kWheelList
end

on SetWheelContactPointList me, kWheelContactPointList
  pWheelContactPointList = kWheelContactPointList
end

on PauseAnimations me
end

on UnPauseAnimations me
end

on GamePaused me
end

on GameResumed me
end

on CalculateWheelContactPoints me
  repeat with li = 1 to pWheelList.count
    lWheelMdl = pWheelList[li]
    if not voidp(lWheelMdl) then
      lWheelTransform = lWheelMdl.transform.duplicate()
      lWheelTransform.position = vector(0.0, 0.0, 0.0)
      lWheelTransform.scale = vector(1.0, 1.0, 1.0)
      lWheelTransform.rotation.x = 0.0
      pWheelContactPointList[li] = lWheelMdl.getWorldTransform().position - (lWheelTransform * vector(0.0, 0.0, pWheelRadius - 5.0))
    end if
  end repeat
end

on Initialize me
  pRollAngle = 0.0
  pRollAngleCoeff = 0.0075
  pRollSmoothCoeff = 10.0
  pRollSmoothCoeffReturn = 10.0
  pMinRollAngle = -9.0
  pMaxRollAngle = 9.0
  pPitchAngle = 0.0
  pPitchAngleCoeff = 0.0000065
  pMinPitchAngle = -10.0
  pMaxPitchAngle = 10.0
  pPitchSmoothCoeff = 5.0
  pWheelList = [VOID, VOID, VOID, VOID]
  pWheelContactPointList = [VOID, VOID, VOID, VOID]
end

on UpdateRollPitchAngles me
  me.UpdateRollAngle()
  me.UpdatePitchAngle()
end

on UpdateRollAngle me
  lDt = gGame.GetTimeManager().GetDeltaTime() * 0.001
  lSlideSpeed = pVehicle.GetWorldRight().dot(pVehicle.GetVelocity())
  lRollAngle = lSlideSpeed * pRollAngleCoeff
  lRollAngle = Clamp(lRollAngle, pMinRollAngle, pMaxRollAngle)
  if abs(lRollAngle) > abs(pRollAngle) then
    lRollSmoothCoeff = pRollSmoothCoeff
  else
    lRollSmoothCoeff = pRollSmoothCoeffReturn
  end if
  pRollAngle = ((lRollAngle - pRollAngle) * lDt * lRollSmoothCoeff) + pRollAngle
end

on UpdatePitchAngle me
  lDt = gGame.GetTimeManager().GetDeltaTime() * 0.001
  lPitchAngle = -pVehicle.GetLastImpulses().dot(pVehicle.GetWorldForward()) * pPitchAngleCoeff
  lPitchAngle = Clamp(lPitchAngle, pMinPitchAngle, pMaxPitchAngle)
  pPitchAngle = ((lPitchAngle - pPitchAngle) * lDt * pPitchSmoothCoeff) + pPitchAngle
end

on update me, kTime
end
