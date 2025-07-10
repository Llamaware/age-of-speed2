property pPlayerId, pVehicleId, pName, pStatus, pScore, pEnergy, pCPUControl, pVehicle, pInputController, pHumanInputController, pAIController, pVehicleGfx, pVehicleEffects
global gGame

on new me, kName, kPlayerId, kVehicleId, kVehicle, kHumanInputController, kAiController, kCPUControl
  pName = kName
  pStatus = 0
  pScore = 0
  pEnergy = 100.0
  pCPUControl = kCPUControl
  pPlayerId = kPlayerId
  pVehicleId = kVehicleId
  pVehicle = kVehicle
  pHumanInputController = kHumanInputController
  pAIController = kAiController
  pInputController = VOID
  if not pCPUControl then
    pInputController = pHumanInputController
  else
    pInputController = pAIController
  end if
  return me
end

on Initialize me
end

on GetName me
  return pName
end

on GetStatus me
  return pStatus
end

on GetScore me
  return pScore
end

on GetEnergy me
  return pEnergy
end

on GetVehicleId me
  return pVehicleId
end

on GetPlayerId me
  return pPlayerId
end

on GetInputController me
  return pInputController
end

on GetVehicle me
  return pVehicle
end

on GetVehicleGfx me
  return pVehicleGfx
end

on GetVehicleEffects me
  return pVehicleEffects
end

on GetVehicleResistance me
  return pVehicle.pVehicleResistance
end

on getPosition me
  return pVehicle.getPosition()
end

on GetDirection me
  return pVehicle.GetDirection()
end

on GetTransform me
  return pVehicle.GetTransform()
end

on GetPreviousPosition me
  return pVehicle.GetPreviousPosition()
end

on GetCurrentToken me
  return pVehicle.pCurrentToken
end

on GetLongitudinal me
  return pVehicle.pLongitudinal
end

on GetTrasversal me
  return pVehicle.pTrasversal
end

on GetTokenTangent me
  return pVehicle.pTokenTangent
end

on getBSRadius me
  return pVehicle.getBSRadius()
end

on GetGfxTransform me
  return pVehicle.GetGfxTransform()
end

on GetWorldRight me
  return pVehicle.GetWorldRight()
end

on GetVelocity me
  return pVehicle.GetVelocity()
end

on GetSpeedKmh me
  return pVehicle.GetSpeedKmh()
end

on GetPlayerGfx me
  return pVehicle.GetPlayerGfx()
end

on GetGroundType me
  return pVehicle.GetGroundType()
end

on GetTrackPos me
  return pVehicle.pTrackPos
end

on GetRaceTrackPos me
  return pVehicle.pRaceTrackPos
end

on GetRaceTime me
  return pVehicle.pRaceTime
end

on GetWorldForward me
  return pVehicle.pWorldForward
end

on GetPreviousVelocity me
  return pVehicle.pPreviousVelocity
end

on GetSpeed me
  return pVehicle.GetSpeed()
end

on SetEnergy me, kEnergy
  pEnergy = kEnergy
end

on SetScore me, kScore
  pScore = kScore
end

on SetStatus me, kStatus
  pStatus = kStatus
end

on SetCPUControl me, kCPUControl
  pCPUControl = kCPUControl
end

on SetVehicleGfx me, kVehicleGfx
  pVehicleGfx = kVehicleGfx
end

on SetVehicleEffects me, kVehicleEffects
  pVehicleEffects = kVehicleEffects
end

on SetForceToBrake me, kValue
  pVehicle.SetForceToBrake(kValue)
end

on setPosition me, kPosition, kOrientation
  pVehicle.setPosition(kPosition, kOrientation)
end

on SetTransform me, kTransform
  pVehicle.SetTransform(kTransform)
end

on IsCPUControlled me
  return pCPUControl
end

on SubEnergy me, kEnergy
  pEnergy = Clamp(pEnergy - kEnergy, 0.0, 100.0)
end

on AddEnergy me, kEnergy
  pEnergy = Clamp(pEnergy + kEnergy, 0.0, 100.0)
end

on AddScore me, kScore
  pScore = pScore + kScore
  lInGame = gGame.GetInGame()
  lInGame.UpdateScore()
end

on EndGame me, kTime
end

on EndScene me, kTime
end

on GamePaused me
  pVehicle.GamePaused()
end

on GameResumed me
  pVehicle.GameResumed()
end

on SwapCpuControl me
  if me.IsCPUControlled() then
    pCPUControl = 0
    pInputController = pHumanInputController
  else
    pCPUControl = 1
    pInputController = pAIController
  end if
end

on update me, kTime
  lAcceleration = pInputController.GetAcceleration()
  lSteering = pInputController.GetSteering()
  pVehicle.update(lAcceleration, lSteering)
  STARTPROFILE(#Aicontroller)
  pInputController.update(kTime)
  ENDPROFILE()
end

on ExitFrameUpdate me, kTime
  pVehicle.ExitFrameUpdate()
end
