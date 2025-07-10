property pPlayer, pChassisMDL, pChassisRB, pChassisRbName, pHoverPointList, pIsHoveringList, pHoverCollisionDetails, pHoverGroundNormal, pHoverDistList, pHoverContactPoint, pWheelOffset, pOBB, pOBBWidth, pOBBHeight, pLocalDown, pLocalForward, pLocalRight, pWorldUp, pWorldForward, pWorldRight, pWorldMdlPos, pWorldRBPos, pWorldRBCOM, pImpulseSum, pAngularImpulseSum, pLastImpulses, pChassisWidth, pWheelLongitudinal, pWheelRadius, pStrength, pDamping, pHoverDist, pMaxSpeed, pLimitSpeed, pMaxTurnSpeed, pLowVelocityTurnGain, pVehicleResistance, pAccGain, pDecGain, pBrakeGain, pTurnGain, pGrip, pLowGrip, pLowGripSpeed, pDrag, pEngineBrakeGain, pChassisMass, pGripOnAirFactor, pOppositeSteeringResistence, pRestPositionSteeringResistence, pSkill, pRestoreZ, pRestoreOnOutTrack, pRestoreAutoFlip, pAutoFlipRestoreSpeedLimit, pCurrentToken, pTokenTangent, pDirectionOnToken, pTrasversal, pLongitudinal, pCurrentTokenRef, pHaveToResetToTrack, pResetToTrackTrasversal, pResetToTrackCallback, pResetToTrackCallbackScript, pGroundType, pCalculateTrackPos, pRaceTrackPos, pTrackPos, pLap, pRaceTime, pLateralForceTimer, pLateralForceIntensity, pLateralForceSign, pPowerCoeff, pMinPowerCoeff, pMinAccelerationOnAir, pMaxAccelerationOnAir, pIsOnGround, pPreviousIsOnGround, pCurrSpeed, pPreviousSpeed, pCurrVel, pPreviousVelocity, pCurrAngVel, pPreviousPosition, pSpeedKmh, pDirection, pTurboTimer, pTurboCoeff, pGroundDistance, pUserData, pStillState, pLastForwardHit, pOutTrack, pFlippingTimer, pSpeedTimer, pForceToBrake, pShadow, pShadowMdl, pShadowPos, pShadowIntersectionNormal, pShadowType, pModelList, pCullerRayBlock, pAcceleration, pSteering, pSteeringEpsilon, pAccelerationEpsilon, pAccelerationFactor, pSteeringFactor, pBraking, pSlideSpeed, pSlopeImpulseActive, pSlopeImpulseCoeff, pRotationalCoeffType, pRotationalCoeffGraphCurve, pForceDragOnAir, pDisableControl, pRotationalCoeffFactor, pSteeringResistanceMethod, pTurnOnSteering, pMaxFlipTime, pAiRestoreEnabled, pAiRestoreTimeOut
global gGame

on new me
  pLocalDown = vector(0.0, 0.0, -1.0)
  pLocalForward = vector(0.0, 1.0, 0.0)
  pLocalRight = pLocalDown.cross(pLocalForward)
  pLocalRight.normalize()
  pImpulseSum = vector(0.0, 0.0, 0.0)
  pAngularImpulseSum = vector(0.0, 0.0, 0.0)
  pWheelOffset = vector(0.0, 0.0, 0.0)
  pFrontOrientation = vector(0.0, 1.0, 0.0)
  pRightOrientation = vector(1.0, 0.0, 0.0)
  pCurrentToken = 1
  pTokenTangent = vector(1, 0, 0)
  pTrasversal = 0
  pCurrentTokenRef = VOID
  pSpeedKmh = 0.0
  pPreviousVelocity = vector(0.0, 0.0, 0.0)
  pLateralForceTimer = -1
  pLateralForceIntensity = 0.0
  pLateralForceSign = 1.0
  pForceToBrake = 0.0
  pPowerCoeff = 1.0
  pMinPowerCoeff = 0.0
  pIsOnGround = 0
  pPreviousIsOnGround = 0
  pFlippingTimer = -1
  pSpeedTimer = -1
  pTurboTimer = -1
  pTurboCoeff = 1.0
  pModelList = VOID
  pChassisMass = VOID
  pChassisWidth = 1
  pWheelLongitudinal = 1
  pWheelRadius = 1
  pStrength = 1
  pDamping = 0.10000000000000001
  pHoverDist = 1
  pMaxSpeed = 15
  pLimitSpeed = 15
  pMaxTurnSpeed = 5
  pAccGain = 0.02
  pDecGain = 0.01
  pBrakeGain = 0.02
  pTurnGain = 0.05
  pGrip = 0.20000000000000001
  pLowGrip = 0.20000000000000001
  pLowGripSpeed = 20
  pDrag = 0.005
  pEngineBrakeGain = 0.005
  pLowVelocityTurnGain = 1.0
  pRestPositionSteeringResistence = -30.0
  pOppositeSteeringResistence = -3.0
  pVehicleResistance = 1.0
  pMinAccelerationOnAir = -0.25
  pMaxAccelerationOnAir = 0.20000000000000001
  pSkill = 1.0
  pStillState = 0
  pPreviousStillState = 0
  pUserData = [:]
  pShadow = VOID
  pGroundDistance = 0
  pLastImpulses = vector(0.0, 0.0, 0.0)
  pHoverCollisionDetails = []
  pOutTrack = 0
  pTrackPos = 0.0
  pCalculateTrackPos = 1
  pRaceTime = -1
  pBraking = 0
  pAcceleration = 0.0
  pSteering = 0.0
  pLap = -1
  pHaveToResetToTrack = 0
  pRestoreZ = -500.0
  pRestoreOnOutTrack = 1
  pResetToTrackTrasversal = 0.0
  pRestoreAutoFlip = 1
  pAutoFlipRestoreSpeedLimit = 50000
  pSlideSpeed = 0
  pSlopeImpulseActive = 1
  pSlopeImpulseCoeff = 1.0
  pChassisRbName = "veh_chassis"
  pRotationalCoeffType = #function
  pRotationalCoeffGraphCurve = VOID
  pForceDragOnAir = 0
  pGripOnAirFactor = 1.0
  pDisableControl = 0
  pRotationalCoeffFactor = 1.0
  pSteeringResistanceMethod = #timeStep
  pTurnOnSteering = 0
  pMaxFlipTime = 1300
  pAiRestoreEnabled = 1
  pAiRestoreTimeOut = 5000
  pCullerRayBlock = 0
  return me
end

on Initialize me, kPlayer, kShadowData, kOBBData, kConfSet, kDriveData, kQuadTree
  pPlayer = kPlayer
  me.SetVehicleConfSet(kConfSet)
  lChassisName = pChassisRbName
  pChassisMDL = gGame.Get3D().model(lChassisName)
  pChassisRB = gGame.GetHavokPhysics().GetHavok().rigidBody(lChassisName)
  pIsHoveringList = [0, 0, 0, 0]
  pHoverDistList = [0.0, 0.0, 0.0, 0.0]
  pHoverGroundNormal = []
  pHoverContactPoint = []
  lWheelPositionFrontRight = pWheelOffset + (pWheelLongitudinal * 0.5 * pLocalForward) + (pChassisWidth * 0.5 * pLocalRight)
  lWheelPositionFrontLeft = pWheelOffset + (pWheelLongitudinal * 0.5 * pLocalForward) + (pChassisWidth * 0.5 * -pLocalRight)
  lWheelPositionRearRight = pWheelOffset + (pWheelLongitudinal * 0.5 * -pLocalForward) + (pChassisWidth * 0.5 * pLocalRight)
  lWheelPositionRearLeft = pWheelOffset + (pWheelLongitudinal * 0.5 * -pLocalForward) + (pChassisWidth * 0.5 * -pLocalRight)
  pHoverPointList = [lWheelPositionFrontLeft, lWheelPositionFrontRight, lWheelPositionRearLeft, lWheelPositionRearRight]
  pChassisMDL.visibility = #none
  if voidp(pChassisMass) then
    pChassisMass = pChassisRB.mass
  else
    pChassisRB.mass = pChassisMass
  end if
  if not voidp(pChassisRB) then
    pChassisRB.restitution = kConfSet.ChassisRestitution
    pChassisRB.friction = kConfSet.ChassisFriction
  end if
  if not voidp(kShadowData) then
    pShadow = kShadowData.shadow
    pShadowType = kShadowData.shadowType
    if pShadowType = #calculated then
      pShadow.Initialize(me)
    end if
  end if
  if not voidp(kOBBData) then
    pOBBWidth = kOBBData.OBBWidth
    pOBBHeight = kOBBData.OBBHeight
  end if
  pSteeringEpsilon = kDriveData.SteeringEpsilon
  pAccelerationEpsilon = kDriveData.AccelerationEpsilon
  pLastForwardHit = gGame.GetTimeManager().GetTime()
  pWorldMdlPos = pChassisMDL.transform.position
  pPreviousPosition = me.getPosition()
  lVehicleTransform = pChassisMDL.transform.duplicate()
  lVehicleTransform.position = vector(0, 0, 0)
  lVehicleTransform.scale = vector(1, 1, 1)
  pDirection = lVehicleTransform * pLocalForward
  pShadowIntersectionNormal = vector(0, 0, 1)
end

on getPosition me
  return pChassisMDL.transform.position
end

on GetPreviousPosition me
  return pPreviousPosition
end

on GetDirection me
  return pDirection
end

on GetTransform me
  return pChassisMDL.transform
end

on GetChassisMdl me
  return pChassisMDL
end

on GetChassisRB me
  return pChassisRB
end

on GetPlayer me
  return pPlayer
end

on GetChassisMass me
  return pChassisMass
end

on GetShadow me
  return pShadow
end

on GetShadowPosition me
  return pShadowPos
end

on GetShadowIntersectionNormal me
  return pShadowIntersectionNormal
end

on GetGroundDistance me
  return pGroundDistance
end

on GetOutTrack me
  return pOutTrack
end

on GetTrackPos me
  return pTrackPos
end

on GetRaceTrackPos me
  return pRaceTrackPos
end

on GetCurrentTokenRef me
  return pCurrentTokenRef
end

on GetSkill me
  return pSkill
end

on GetLastImpulses me
  return pLastImpulses
end

on GetCurrentToken me
  return pCurrentToken
end

on GetTrasversal me
  return pTrasversal
end

on GetLongitudinal me
  return pLongitudinal
end

on GetTokenTangent me
  return pTokenTangent
end

on GetNormalizedSpeed me
  lMaxSpeedFactor = pSkill
  lNormalizedSpeed = min(abs(pCurrSpeed) / (pMaxSpeed * lMaxSpeedFactor), 1)
  return lNormalizedSpeed
end

on GetWorldRight me
  return pWorldRight
end

on GetWorldUp me
  return pWorldUp
end

on GetWorldForward me
  return pWorldForward
end

on GetNumWheelsOnGround me
  lNumWheels = 0
  repeat with li = 1 to 4
    if pIsHoveringList[li] then
      lNumWheels = lNumWheels + 1
    end if
  end repeat
  return lNumWheels
end

on GetPreviousIsOnGround me
  return pPreviousIsOnGround
end

on GetOBB me
  return pOBB
end

on getBSRadius me
  return pChassisMDL.boundingSphere[2]
end

on getBSSqRadius me
  return pChassisMDL.boundingSphere[2] * pChassisMDL.boundingSphere[2]
end

on GetSpeed me
  return pCurrSpeed
end

on GetSpeedKmh me
  return pSpeedKmh
end

on GetVelocity me
  return pCurrVel
end

on GetPreviousVelocity me
  return pPreviousVelocity
end

on GetSpeedFactor me
  lMaxSpeedFactor = pSkill
  return lMaxSpeedFactor
end

on GetRotationalCoeff me
  if pRotationalCoeffType = #function then
    lNormalizedSpeed = me.GetNormalizedSpeed()
    lAbsoluteCurrentSpeed = abs(pCurrSpeed)
    if pCurrSpeed < 0 then
      lRotationalCoeff = lAbsoluteCurrentSpeed / 500.0 * pMaxTurnSpeed * 0.80000000000000004
    else
      if (lAbsoluteCurrentSpeed > 0.0) and (lAbsoluteCurrentSpeed <= 500.0) then
        lRotationalCoeff = lAbsoluteCurrentSpeed / 500.0 * pMaxTurnSpeed * 2.10000000000000009
      else
        if (lAbsoluteCurrentSpeed > 500.0) and (lAbsoluteCurrentSpeed <= 1000.0) then
          lRotationalCoeff = (0.75 + (0.20000000000000001 * (lAbsoluteCurrentSpeed - 500.0) / 500.0)) * pMaxTurnSpeed * 0.88
        else
          if (lAbsoluteCurrentSpeed >= 1000.0) and (lAbsoluteCurrentSpeed < 1800.0) then
            lRotationalCoeff = (1.0 - (0.5 * (lAbsoluteCurrentSpeed - 1000.0) / 800.0)) * pMaxTurnSpeed * 2.60000000000000009
          else
            lRotationalCoeff = (0.5 + (0.5 * (1.0 - lNormalizedSpeed))) * pMaxTurnSpeed * 1.64999999999999991
          end if
        end if
      end if
    end if
  else
    lGraphCurveValue = pRotationalCoeffGraphCurve.GetValue(abs(me.GetSpeedKmh()))
    lRotationalCoeff = pMaxTurnSpeed * lGraphCurveValue
  end if
  return lRotationalCoeff
end

on GetTurboCoeff me
  return pTurboCoeff
end

on GetTurboTimer me
  return pTurboTimer
end

on GetLaps me
  return pLap
end

on GetRaceTime me
  return pRaceTime
end

on GetAcceleration me
  return pAcceleration
end

on GetSteering me
  return pSteering
end

on GetSteeringEpsilon me
  return pSteeringEpsilon
end

on GetIsHoveringList me
  return pIsHoveringList
end

on GetHoverPointList me
  return pHoverPointList
end

on GetHoverDistList me
  return pHoverDistList
end

on GetHoverGroundNormal me
  return pHoverGroundNormal
end

on GetHoverContactPoint me
  return pHoverContactPoint
end

on GetHoverCollisionDetails me
  return pHoverCollisionDetails
end

on GetGrip me
  return pGrip
end

on GetDrag me
  return pDrag
end

on GetAccGain me
  return pAccGain
end

on GetLimitSpeed me
  return pLimitSpeed
end

on GetSlideSpeed me
  return pSlideSpeed
end

on GetMaxTurnSpeed me
  return pMaxTurnSpeed
end

on GetChassisWidth me
  return pChassisWidth
end

on GetResetToTrackTrasversal me
  return pResetToTrackTrasversal
end

on GetRotationalCoeffType me
  return pRotationalCoeffType
end

on GetForceDragOnAir me
  return pForceDragOnAir
end

on GetDisableControl me
  return pDisableControl
end

on GetRotationalCoeffFactor me
  return pRotationalCoeffFactor
end

on GetSteeringResistanceMethod me
  return pSteeringResistanceMethod
end

on GetLocalDown me
  return pLocalDown
end

on GetLocalForward me
  return pLocalForward
end

on GetWorldRBPos me
  return pWorldRBPos
end

on GetImpulseSum me
  return pImpulseSum
end

on GetAngularImpulseSum me
  return pAngularImpulseSum
end

on getOBBWidth me
  return pOBBWidth
end

on getOBBHeight me
  return pOBBHeight
end

on GetHoverDist me
  return pHoverDist
end

on GetStrength me
  return pStrength
end

on GetDamping me
  return pDamping
end

on GetModelList me
  return pModelList
end

on GetCurrAngVel me
  return pCurrAngVel
end

on GetWorldRBCOM me
  return pWorldRBCOM
end

on GetWheelLongitudinal me
  return pWheelLongitudinal
end

on GetDirectionOnToken me
  return pDirectionOnToken
end

on GetTurnGain me
  return pTurnGain
end

on GetAiRestoreEnabled me
  return pAiRestoreEnabled
end

on GetPowerCoeff me
  return pPowerCoeff
end

on GetMinPowerCoeff me
  return pMinPowerCoeff
end

on GetMaxSpeed me
  return pMaxSpeed
end

on GetRestoreOnOutTrack me
  return pRestoreOnOutTrack
end

on SetShadowPosition me, kShadowPos
  pShadowPos = kShadowPos
end

on SetShadowIntersectionNormal me, kShadowIntersectionNormal
  pShadowIntersectionNormal = kShadowIntersectionNormal
end

on SetGroundDistance me, kGroundDistance
  pGroundDistance = kGroundDistance
end

on SetTrackPos me, kTrackPos
  pTrackPos = kTrackPos
end

on SetRaceTrackPos me, kRaceTrackPos
  pRaceTrackPos = kRaceTrackPos
end

on SetAcceleration me, kAcceleration
  pAcceleration = kAcceleration
end

on SetSteering me, kSteering
  pSteering = kSteering
end

on SetWorldUp me, kWorldUp
  pWorldUp = kWorldUp
end

on SetWorldForward me, kWorldForward
  pWorldForward = kWorldForward
end

on SetWorldRight me, kWorldRight
  pWorldRight = kWorldRight
end

on SetWorldMdlPos me, kWorldMdlPos
  pWorldMdlPos = kWorldMdlPos
end

on SetWorldRBPos me, kWorldRBPos
  pWorldRBPos = kWorldRBPos
end

on SetWorldRBCOM me, kWorldRBCOM
  pWorldRBCOM = kWorldRBCOM
end

on SetImpulseSum me, kImpulseSum
  pImpulseSum = kImpulseSum
end

on SetAngularImpulseSum me, kAngularImpulseSum
  pAngularImpulseSum = kAngularImpulseSum
end

on SetHoverPointList me, kHoverPointList
  pHoverPointList = kHoverPointList
end

on SetVelocity me, kCurrVel
  pCurrVel = kCurrVel
end

on SetPreviousSpeed me, kPreviousSpeed
  pPreviousSpeed = kPreviousSpeed
end

on SetSpeed me, kCurrSpeed
  pCurrSpeed = kCurrSpeed
end

on SetSpeedKmh me, kSpeedKmh
  pSpeedKmh = kSpeedKmh
end

on SetCurrAngVel me, kCurrAngVel
  pCurrAngVel = kCurrAngVel
end

on SetLastImpulses me, kLastImpulses
  pLastImpulses = kLastImpulses
end

on SetOBB me, kOBB
  pOBB = kOBB
end

on SetModelList me, kModelList
  pModelList = kModelList
end

on SetOnCullerRayBlock me, kValue
  pCullerRayBlock = kValue
end

on SetIsHoveringList me, kIsHoveringList
  pIsHoveringList = kIsHoveringList
end

on SetHoverGroundNormal me, kIdx, kHoverGroundNormal
  pHoverGroundNormal[kIdx] = kHoverGroundNormal
end

on SetHoverContactPoint me, kIdx, kHoverContactPoint
  pHoverContactPoint[kIdx] = kHoverContactPoint
end

on SetHoverDistList me, kIdx, kHoverDistList
  pHoverDistList[kIdx] = kHoverDistList
end

on SetHoverCollisionDetails me, kHoverCollisionDetails
  pHoverCollisionDetails = kHoverCollisionDetails
end

on SetTurnOnSteering me, kValue
  pTurnOnSteering = kValue
end

on SetCurrentToken me, kCurrentToken
  pCurrentToken = kCurrentToken
end

on SetGripOnAirFactor me, kGripOnAirFactor
  pGripOnAirFactor = kGripOnAirFactor
end

on SetResetToTrackCallbackData me, kResetToTrackCallback, kResetToTrackCallbackScript
  pResetToTrackCallback = kResetToTrackCallback
  pResetToTrackCallbackScript = kResetToTrackCallbackScript
end

on SetSlopeImpulseActive me, kActive
  pSlopeImpulseActive = kActive
end

on SetSlopeImpulseCoeff me, kValue
  pSlopeImpulseCoeff = kValue
end

on SetChassisRbName me, kChassisRbName
  pChassisRbName = kChassisRbName
end

on SetVehicleConfSet me, kSetupData
  pChassisMass = kSetupData.ChassisMass
  pLowVelocityTurnGain = kSetupData.LowVelocityTurnGain
  pChassisWidth = kSetupData.ChassisWidth
  pWheelLongitudinal = kSetupData.WheelLongitudinal
  pWheelRadius = kSetupData.WheelRadius
  pStrength = kSetupData.strength
  pDamping = kSetupData.damping
  pHoverDist = kSetupData.HoverDist
  pMaxSpeed = kSetupData.maxSpeed
  pLimitSpeed = kSetupData.LimitSpeed
  pAccGain = kSetupData.AccGain
  pDecGain = kSetupData.DecGain
  pBrakeGain = kSetupData.BrakeGain
  pMaxTurnSpeed = kSetupData.MaxTurnSpeed
  pTurnGain = kSetupData.TurnGain
  pGrip = kSetupData.Grip
  pLowGrip = kSetupData.LowGrip
  pLowGripSpeed = kSetupData.LowGripSpeed
  pDrag = kSetupData.drag
  pEngineBrakeGain = kSetupData.EngineBrakeGain
  pRestPositionSteeringResistence = kSetupData.RestPositionSteeringResistence
  pOppositeSteeringResistence = kSetupData.OppositeSteeringResistence
  pVehicleResistance = kSetupData.VehicleResistance
  pWheelOffset = kSetupData.WheelOffset
  pMinPowerCoeff = kSetupData.MinPowerCoeff
  pMinAccelerationOnAir = kSetupData.MinAccelerationOnAir
  pMaxAccelerationOnAir = kSetupData.MaxAccelerationOnAir
end

on SetMinPowerCoeff me, kMinPowerCoeff
  pMinPowerCoeff = kMinPowerCoeff
end

on SetIfHaveToResetToTrack me, kValue
  pHaveToResetToTrack = kValue
end

on SetPlayer me, kPlayer
  pPlayer = kPlayer
end

on setPosition me, kPosition, kOrientation
  pChassisRB.linearVelocity = vector(0.0, 0.0, 0.0)
  pChassisRB.angularVelocity = vector(0.0, 0.0, 0.0)
  if voidp(kOrientation) then
    kOrientation = [vector(0.0, 0.0, 1.0), 0.0]
  end if
  pChassisRB.interpolatingMoveTo(kPosition, kOrientation)
end

on SetForceToBrake me, pValue
  pForceToBrake = pValue
end

on SetTurboBoost me, kTurboTime, kTurboCoeff
  if voidp(kTurboTime) then
    kTurboTime = 1000
  end if
  pTurboTimer = gGame.GetTimeManager().GetTime() + kTurboTime
  pTurboCoeff = kTurboCoeff
end

on SetChassisMDL me, kChassisMDL
  pChassisMDL = kChassisMDL
end

on SetTurboTimer me, kTurboTimer
  pTurboTimer = kTurboTimer
end

on SetTurboCoeff me, kTurboCoeff
  pTurboCoeff = kTurboCoeff
end

on SetSkill me, kSkill
  pSkill = kSkill
end

on SetLaps me, kLap
  pLap = kLap
end

on SetRestoreZ me, kRestoreZ
  pRestoreZ = kRestoreZ
end

on SetMaxFlipTime me, kMaxFlipTime
  pMaxFlipTime = kMaxFlipTime
end

on SetRestoreAutoFlip me, kRestoreAutoFlip
  pRestoreAutoFlip = kRestoreAutoFlip
end

on SetAutoFlipRestoreSpeedLimit me, kAutoFlipRestoreSpeedLimit
  pAutoFlipRestoreSpeedLimit = kAutoFlipRestoreSpeedLimit
end

on SetLongitudinal me, kLongitudinal
  pLongitudinal = kLongitudinal
end

on SetTrasversal me, kTrasversal
  pTrasversal = kTrasversal
end

on SetTokenTangent me, kTokenTangent
  pTokenTangent = kTokenTangent
end

on SetCurrentTokenRef me, kCurrentTokenRef
  pCurrentTokenRef = kCurrentTokenRef
end

on SetOutTrack me, kValue
  pOutTrack = kValue
end

on SetRestoreOnOutTrack me, kValue
  pRestoreOnOutTrack = kValue
end

on SetResetToTrackTrasversal me, kResetToTrackTrasversal
  pResetToTrackTrasversal = kResetToTrackTrasversal
end

on SetGrip me, kGrip
  pGrip = kGrip
end

on SetLowGrip me, kGrip
  pLowGrip = kGrip
end

on SetDrag me, kDrag
  pDrag = kDrag
end

on SetLimitSpeed me, kLimitSpeed
  pLimitSpeed = kLimitSpeed
end

on SetAccGain me, kAccGain
  pAccGain = kAccGain
end

on SetBrakeGain me, kBrakeGain
  pBrakeGain = kBrakeGain
end

on SetTurnGain me, kTurnGain
  pTurnGain = kTurnGain
end

on SetMaxTurnSpeed me, kMaxTurnSpeed
  pMaxTurnSpeed = kMaxTurnSpeed
end

on SetRestPositionSteeringResistence me, kRestPositionSteeringResistence
  pRestPositionSteeringResistence = kRestPositionSteeringResistence
end

on SetOppositeSteeringResistence me, kOppositeSteeringResistence
  pOppositeSteeringResistence = kOppositeSteeringResistence
end

on SetLowVelocityTurnGain me, kLowVelocityTurnGain
  pLowVelocityTurnGain = kLowVelocityTurnGain
end

on SetForceEngineBrake me, kValue
  pForceEngineBrake = kValue
end

on SetEngineBrakeGain me, KEngineBrakeGain
  pEngineBrakeGain = KEngineBrakeGain
end

on SetHoverDistance me, kHoverDist
  pHoverDist = kHoverDist
end

on SetRotationalCoeffType me, kRotationalCoeffType
  pRotationalCoeffType = kRotationalCoeffType
end

on SetRotationalCoeffGraphCurve me, kRotationalCoeffGraphCurve
  pRotationalCoeffGraphCurve = kRotationalCoeffGraphCurve
end

on SetForceDragOnAir me, kForceDragOnAir
  pForceDragOnAir = kForceDragOnAir
end

on SetDisableControl me, kDisableControl
  pDisableControl = kDisableControl
end

on SetRotationalCoeffFactor me, kRotationalCoeffFactor
  pRotationalCoeffFactor = kRotationalCoeffFactor
end

on SetSteeringResistanceMethod me, kSteeringResistanceMethod
  pSteeringResistanceMethod = kSteeringResistanceMethod
end

on SetCalculateTrackPos me, kValue
  pCalculateTrackPos = kValue
end

on SetAiRestoreEnabled me, kFlag
  pAiRestoreEnabled = kFlag
end

on SetAiRestoreTimeOut me, kValue
  pAiRestoreTimeOut = kValue
end

on GamePaused me
end

on GameResumed me
end

on IsOutTrack me
  return pOutTrack
end

on IsOnGround me
  return pIsOnGround
end

on HaveToResetToTrack me
  return pHaveToResetToTrack
end

on SetupRestFlag me
  if abs(pSpeedKmh) < 5.0 then
    lRestTest = (pAcceleration < pAccelerationEpsilon) and (pAcceleration > -pAccelerationEpsilon)
    if lRestTest then
      pLastForwardHit = gGame.GetTimeManager().GetTime()
      pStillState = 1
    else
      pStillState = 0
    end if
  else
    pLastForwardHit = gGame.GetTimeManager().GetTime()
    pStillState = 0
  end if
end

on ApplyImpulseToVehicle me, fImpulse
  pImpulseSum = pImpulseSum + fImpulse
end

on FlushImpulses me
  pChassisRB.applyImpulse(pImpulseSum)
  pImpulseSum = vector(0.0, 0.0, 0.0)
end

on ApplyAngularImpulseToVehicle me, fImpulse
  pAngularImpulseSum = pAngularImpulseSum + fImpulse
end

on FlushAngularImpulses me
  pChassisRB.applyAngularImpulse(pAngularImpulseSum)
  pAngularImpulseSum = vector(0.0, 0.0, 0.0)
end

on UpdateTokenInfo me
  lResult = gGame.GetTokenManager().getToken(pCurrentToken, pWorldMdlPos.x, pWorldMdlPos.y, pWorldMdlPos, 0.0, 0.0)
  if lResult[1] = 0 then
    pOutTrack = 1
  else
    pOutTrack = 0
  end if
  if pOutTrack and not me.HaveToResetToTrack() then
    lExpansionResult = gGame.GetTokenManager().GetTokenWithExpansion(pCurrentToken, pWorldMdlPos.x, pWorldMdlPos.y)
    if lExpansionResult[1] = 0 then
      if pRestoreOnOutTrack then
        if me.pPlayer.GetPlayerId() = 1 then
          call(#ResetToTrackWithFade, gGame.GetGameplay())
        else
          me.ResetToTrack()
        end if
      end if
    else
      lResult = lExpansionResult
    end if
  end if
  if lResult[1] <> 0 then
    pCurrentToken = lResult[1]
    pTokenTangent = lResult[3]
    pLongitudinal = lResult[4]
    pTrasversal = lResult[5]
    pDirectionOnToken = me.GetDirection()
    pCurrentTokenRef = gGame.GetTokenManager().GetTokenRef(pCurrentToken)
    if pCalculateTrackPos then
      if (gGame.GetGameStatus() = #Init) or (gGame.GetGameStatus() = #play) then
        lDistanceFromStart = pCurrentTokenRef.DistanceFromStart
        lRoadLength = pCurrentTokenRef.RoadLength
        lTokenTrackPos = pLongitudinal * lRoadLength
        pTrackPos = lDistanceFromStart + lTokenTrackPos
        lTrackLength = gGame.GetTrackLength()
        if pTrackPos >= lTrackLength then
          pTrackPos = pTrackPos - lTrackLength
        end if
        pRaceTrackPos = (pLap * lTrackLength) + pTrackPos
        if pRaceTrackPos < 0 then
          pRaceTrackPos = 0
        end if
      end if
    end if
  end if
end

on update me, kAcceleration, kSteering
  pAcceleration = kAcceleration
  pSteering = kSteering
  lNormTrans = pChassisMDL.transform.duplicate()
  lNormTrans.position = vector(0.0, 0.0, 0.0)
  lNormTrans.scale = vector(1.0, 1.0, 1.0)
  pWorldUp = lNormTrans * -pLocalDown
  pWorldForward = lNormTrans * pLocalForward
  pWorldRight = pWorldUp.cross(pWorldForward)
  pWorldMdlPos = pChassisMDL.transform.position
  pWorldRBPos = pChassisRB.position
  pWorldRBCOM = pWorldRBPos + pChassisRB.centerOfMass
  pCurrVel = pChassisRB.linearVelocity
  pPreviousSpeed = pCurrSpeed
  pCurrSpeed = pCurrVel.dot(pWorldForward)
  pCurrAngVel = pChassisRB.angularVelocity
  if pCullerRayBlock then
    me.UpdateHoverOnCullerRayBlock()
  else
    me.UpdateHover()
  end if
  me.UpdateShadow()
  if not pDisableControl then
    me.UpdateRecover()
    me.UpdateAutoFlip()
  end if
  if pAiRestoreEnabled then
    me.AiRestore()
  end if
  me.UpdateDrive()
  pLastImpulses = pImpulseSum
  me.FlushImpulses()
  me.FlushAngularImpulses()
  if not voidp(pOBBWidth) then
    lWorldTr = pChassisMDL.getWorldTransform()
    lPos = lWorldTr.position
    lAngle = lWorldTr.rotation.z * PI / 180.0
    pOBB = CreateOBBPack(lPos, lAngle, pOBBWidth, pOBBHeight)
  end if
end

on AiRestore me
  if not pPlayer.IsCPUControlled() then
    return 
  end if
  if not (gGame.GetGameStatus() = #play) then
    return 
  end if
  if (abs(pCurrSpeed) < 600.0) and (pForceToBrake = 0.0) then
    if pSpeedTimer = -1 then
      pSpeedTimer = gGame.GetTimeManager().GetTime()
    else
      if (gGame.GetTimeManager().GetTime() - pSpeedTimer) > pAiRestoreTimeOut then
        me.ResetToTrack()
        pSpeedTimer = -1
      end if
    end if
  else
    pSpeedTimer = -1
  end if
end

on UpdateHover me
  pModelList = gGame.GetCullingManager().GetCullerBlockModels(pChassisRB.position)
  lWorldDown = -pWorldUp
  lHoverDistance = pHoverDist
  lDt = gGame.GetHavokPhysics().GetTimeStep()
  pHoverCollisionDetails = []
  repeat with i = 1 to pHoverPointList.count
    pIsHoveringList[i] = 0
    lWorldHoverPoint = pChassisMDL.transform * pHoverPointList[i]
    lIntersectionInfo = VOID
    lArgs = [#maxNumberOfModels: 3, #levelOfDetail: #detailed, #modelList: pModelList]
    lIntersectDetails = gGame.Get3D().modelsUnderRay(lWorldHoverPoint, lWorldDown, lArgs)
    repeat with j = 1 to lIntersectDetails.count
      lIntersectDetailsRef = lIntersectDetails[j]
      if not (lIntersectDetailsRef[1].name starts "veh_") and not (lIntersectDetailsRef[1].name contains "_cam") and (lIntersectDetailsRef[1].visibility <> #none) then
        lIntersectionInfo = lIntersectDetailsRef
        pHoverCollisionDetails.add(lIntersectionInfo.model.name)
        exit repeat
      end if
    end repeat
    if not voidp(lIntersectionInfo) then
      lChassisPoint = lIntersectionInfo[3]
      if lIntersectionInfo[2] < lHoverDistance then
        lPointVelocity = pCurrVel + pCurrAngVel.cross(lWorldHoverPoint - pWorldRBCOM)
        lToGround = lChassisPoint - lWorldHoverPoint
        lToGroundDistance = lToGround.length
        lForce = -pStrength * (lHoverDistance - lToGroundDistance) * lDt * 7.5
        lProjectedPointVelocity = lPointVelocity.dot(lToGround)
        if lProjectedPointVelocity > 0 then
          lDampingForce = pDamping * lProjectedPointVelocity * 0.075
        else
          lDampingForce = pDamping * lProjectedPointVelocity * 0.14999999999999999
        end if
        lForce = lForce - lDampingForce
        lAppliedForce = lToGround * lForce * pChassisMass
        pChassisRB.applyImpulseAtPoint(lAppliedForce * 0.0015, pHoverPointList[i])
        pIsHoveringList[i] = 1
      end if
      pHoverGroundNormal[i] = lIntersectionInfo[4]
      pHoverContactPoint[i] = lChassisPoint
      pHoverDistList[i] = lToGroundDistance
    end if
  end repeat
end

on UpdateHoverOnCullerRayBlock me
  pModelList = gGame.GetCullingManager().GetCullerRayBlockModels(pChassisRB.position)
  lWorldDown = -pWorldUp
  lHoverDistance = pHoverDist
  lDt = gGame.GetHavokPhysics().GetTimeStep()
  pHoverCollisionDetails = []
  repeat with i = 1 to pHoverPointList.count
    pIsHoveringList[i] = 0
    lWorldHoverPoint = pChassisMDL.transform * pHoverPointList[i]
    lIntersectionInfo = VOID
    lArgs = [#maxNumberOfModels: 3, #levelOfDetail: #detailed, #modelList: pModelList]
    lIntersectDetails = gGame.Get3D().modelsUnderRay(lWorldHoverPoint, lWorldDown, lArgs)
    repeat with j = 1 to lIntersectDetails.count
      lIntersectDetailsRef = lIntersectDetails[j]
      if lIntersectDetailsRef[1].visibility <> #none then
        lIntersectionInfo = lIntersectDetailsRef
        pHoverCollisionDetails.add(lIntersectionInfo.model.name)
        exit repeat
      end if
    end repeat
    if not voidp(lIntersectionInfo) then
      lChassisPoint = lIntersectionInfo[3]
      if lIntersectionInfo[2] < lHoverDistance then
        lPointVelocity = pCurrVel + pCurrAngVel.cross(lWorldHoverPoint - pWorldRBCOM)
        lToGround = lChassisPoint - lWorldHoverPoint
        lToGroundDistance = lToGround.length
        lForce = -pStrength * (lHoverDistance - lToGroundDistance) * lDt * 7.5
        lProjectedPointVelocity = lPointVelocity.dot(lToGround)
        if lProjectedPointVelocity > 0 then
          lDampingForce = pDamping * lProjectedPointVelocity * 0.075
        else
          lDampingForce = pDamping * lProjectedPointVelocity * 0.14999999999999999
        end if
        lForce = lForce - lDampingForce
        lAppliedForce = lToGround * lForce * pChassisMass
        pChassisRB.applyImpulseAtPoint(lAppliedForce * 0.0015, pHoverPointList[i])
        pIsHoveringList[i] = 1
      end if
      pHoverGroundNormal[i] = lIntersectionInfo[4]
      pHoverContactPoint[i] = lChassisPoint
      pHoverDistList[i] = lToGroundDistance
    end if
  end repeat
end

on UpdateAutoFlip me
  if pRestoreAutoFlip then
    lAngleToUp = pWorldUp.dot(-pLocalDown)
    lSpeed = abs(pCurrSpeed)
    if (lAngleToUp < 0.20000000000000001) and (lSpeed < pAutoFlipRestoreSpeedLimit) then
      if pFlippingTimer = -1 then
        pFlippingTimer = gGame.GetTimeManager().GetTime()
      end if
      if (gGame.GetTimeManager().GetTime() - pFlippingTimer) > pMaxFlipTime then
        pFlippingTimer = -1
        if me.pPlayer.GetPlayerId() = 1 then
          call(#ResetToTrackWithFade, gGame.GetGameplay(), VOID)
        else
          me.ResetToTrack()
        end if
      end if
    else
      pFlippingTimer = -1
    end if
  end if
end

on IsFlipping me
  return pFlippingTimer <> -1
end

on UpdateRecover me
  lCheckPosition = me.getPosition()
  if lCheckPosition.z < pRestoreZ then
    if me.pPlayer.GetPlayerId() = 1 then
      if not me.HaveToResetToTrack() then
        call(#ResetToTrackWithFade, gGame.GetGameplay())
      end if
    else
      me.ResetToTrack()
    end if
  end if
  if not pIsOnGround then
    lTimeStep = gGame.GetHavokPhysics().GetTimeStep()
    lRBangularVelocity = pChassisRB.angularVelocity.duplicate()
    lRBangularVelocity = lRBangularVelocity * (0.90000000000000002 - (3.60000000000000009 * lTimeStep))
    pChassisRB.angularVelocity = vector(lRBangularVelocity.x, lRBangularVelocity.y, pChassisRB.angularVelocity.z)
  end if
end

on ResetToTrack me
  pChassisRB.linearVelocity = vector(0, 0, 0)
  pChassisRB.angularVelocity = vector(0, 0, 0)
  if not voidp(pResetToTrackCallback) then
    call(pResetToTrackCallback, pResetToTrackCallbackScript, me)
  else
    put "reset on pCurrentToken: " & pCurrentToken & " pLongitudinal: " & pLongitudinal
    lNewPosition = gGame.GetTokenManager().TokenToWorld(pCurrentToken, pLongitudinal, pResetToTrackTrasversal)
    lModelList = gGame.GetCullingManager().GetCullerBlockModels(lNewPosition)
    lArguments = [#maxNumberOfModels: 4, #levelOfDetail: #detailed, #modelList: lModelList]
    lIntersections = gGame.Get3D().modelsUnderRay(lNewPosition + vector(0, 0, 8000), vector(0.0, 0.0, -1.0), lArguments)
    repeat with lIntersection in lIntersections
      if not (lIntersection[1].name contains "_cam") then
        lGroundPosition = lIntersection.isectPosition
        lNewPosition.z = lGroundPosition.z + 200.0
        put "reset on " & lIntersection.model.name
        exit repeat
      end if
    end repeat
    lRefDirection = vector(0.0, 1.0, 0.0)
    lAngleBtw = pTokenTangent.angleBetween(lRefDirection)
    lVersus = pTokenTangent.crossProduct(lRefDirection)
    if lVersus.z >= 0.0 then
      lAngleBtw = -lAngleBtw
    end if
    lRes = pChassisRB.interpolatingMoveTo(lNewPosition, [vector(0.0, 0.0, 1.0), lAngleBtw])
    put "ResetToTrack: " & lRes
  end if
end

on UpdateShadow me
  if pShadowType = #ray then
    lIntersections = pShadow.update(pModelList, pChassisMDL.transform.rotation[3])
    pShadowPos = pShadow.GetIntersectionPosition()
    pGroundDistance = (pShadowPos - me.getPosition()).magnitude
    pShadowIntersectionNormal = pShadow.GetIntersectionNormal()
  else
    pShadow.update()
    pShadowPos = pShadow.GetIntersectionPosition()
    pGroundDistance = pShadow.GetGroundDistance()
    pShadowIntersectionNormal = pShadow.GetIntersectionNormal()
  end if
end

on ExitFrameUpdate me
  lPos = me.getPosition()
  pDirection = lPos - pPreviousPosition
  pDirection.normalize()
  pPreviousPosition = lPos
  pPreviousVelocity = pCurrVel.duplicate()
  pPreviousIsOnGround = pIsOnGround
end

on Deactivate me
  return 
end

on PutLateralForce me, kIntensity, kDuration, kLateralForceSign
  if pLateralForceTimer = -1 then
    pLateralForceTimer = gGame.GetTimeManager().GetTime() + kDuration
    pLateralForceIntensity = kIntensity
    if voidp(kLateralForceSign) then
      kLateralForceSign = 1.0
    end if
    pLateralForceSign = kLateralForceSign
  end if
end

on OnCollision me, kCollisionDetails
  lImpactedRB = kCollisionDetails[2]
  lCollisionNormal = kCollisionDetails[4]
  if lCollisionNormal.dot(pWorldUp) > 0.80000000000000004 then
    return 0
  end if
  lCollPnt = kCollisionDetails[3] - (pChassisRB.position + pChassisRB.centerOfMass)
  lTmpTr = pChassisMDL.transform.inverse()
  lTmpTr.position = vector(0.0, 0.0, 0.0)
  lCollPnt = lTmpTr * lCollPnt
  lVA = me.pCurrVel + lCollPnt.cross(vector(0.0, 0.0, pChassisRB.angularVelocity.z))
  lVA.z = 0.0
  lRelativeVelocityOfImpact = lVA * 0.036
  lCollisionNormal = -lCollisionNormal
  lDotCollision = lRelativeVelocityOfImpact.dot(lCollisionNormal)
  if lDotCollision > 40.0 then
    gGame.VehicleCollision(lRelativeVelocityOfImpact, lCollisionNormal)
    return 1
  end if
  return 0
end

on UpdateDrive me
  kTime = gGame.GetTimeManager().GetTime()
  lTimeStep = gGame.GetHavokPhysics().GetTimeStep()
  pPowerCoeff = pIsHoveringList[1] + pIsHoveringList[2] + pIsHoveringList[3] + pIsHoveringList[4]
  if pPowerCoeff = 0 then
    pIsOnGround = 0
  else
    pIsOnGround = 1
  end if
  pPowerCoeff = pPowerCoeff * 0.25
  if pPowerCoeff < pMinPowerCoeff then
    pPowerCoeff = pMinPowerCoeff
  end if
  pSpeedKmh = pCurrSpeed * 0.036
  if pForceToBrake > 0.0 then
    pBraking = 1
    pAcceleration = 0.0
  else
    pBraking = 0
  end if
  if abs(pSpeedKmh) < 2.0 then
    if pPlayer.IsCPUControlled() then
      lGoingForwardPressed = 0
      lGoingBackwardPressed = 0
    else
      lInputController = pPlayer.GetInputController()
      lGoingForwardPressed = lInputController.GetGoingForwardPressed()
      lGoingBackwardPressed = lInputController.GetGoingBackwardPressed()
    end if
    if not lGoingForwardPressed and not lGoingBackwardPressed then
      pLastForwardHit = gGame.GetTimeManager().GetTime()
      pStillState = 1
    else
      pStillState = 0
    end if
  else
    pLastForwardHit = gGame.GetTimeManager().GetTime()
    pStillState = 0
  end if
  if not pIsOnGround then
    pAcceleration = Clamp(pAcceleration, pMinAccelerationOnAir, pMaxAccelerationOnAir)
  end if
  lRotationalCoeff = me.GetRotationalCoeff() * pRotationalCoeffFactor
  if pSkill < 1.0 then
    lRotationalCoeff = lRotationalCoeff * pSkill
  end if
  lCanTurn = abs(pCurrAngVel.dot(pWorldUp)) < lRotationalCoeff
  pSlideSpeed = pWorldRight.dot(pCurrVel)
  if pTurboTimer <> -1 then
    if kTime > pTurboTimer then
      pTurboTimer = -1
    end if
  end if
  if not pDisableControl then
    if pIsOnGround then
      if pBraking then
        lImpulse = -pCurrSpeed * pForceToBrake * pBrakeGain * 3.0 * pChassisMass * lTimeStep * pWorldForward * pPowerCoeff
        me.ApplyImpulseToVehicle(lImpulse)
      else
        if pStillState then
          lImpulse = -pCurrSpeed * pBrakeGain * 36.0 * pChassisMass * lTimeStep * pWorldForward * pPowerCoeff
          me.ApplyImpulseToVehicle(lImpulse)
        end if
      end if
    end if
    if pTurboTimer <> -1 then
      lMaxSpeedFactor = me.GetSpeedFactor()
      lAcceleration = Clamp(pAcceleration, 0.5, 1.0)
      lAccGain = pAccGain * 3.0 * pTurboCoeff * lAcceleration
      lDelta = (pMaxSpeed * lMaxSpeedFactor * 1.19999999999999996) - pCurrSpeed
      lImpulse = lDelta * lAccGain * lTimeStep * pChassisMass * pWorldForward * pPowerCoeff
      me.ApplyImpulseToVehicle(lImpulse)
    else
      if not pBraking then
        lMaxSpeedFactor = me.GetSpeedFactor()
        if (pAcceleration > pAccelerationEpsilon) or (pAcceleration < -pAccelerationEpsilon) then
          lAccGain = pAccGain * pAcceleration * 3.0 * pSkill
          lDelta = (pMaxSpeed * lMaxSpeedFactor) - pCurrSpeed
          if pCurrSpeed < (pLimitSpeed * pSkill) then
            lImpulse = lDelta * lAccGain * lTimeStep * pChassisMass * pWorldForward * pPowerCoeff
            lSlopeImpulse = vector(0, 0, 0)
            if pSlopeImpulseActive then
              lShadowIntersectionNormal = me.GetShadowIntersectionNormal()
              if not voidp(lShadowIntersectionNormal) then
                lSlopeCross = vector(0, 0, 1).cross(me.GetShadowIntersectionNormal())
                lDot = lSlopeCross.dot(pWorldRight)
                if lDot < 0 then
                  lSkill = pSkill
                  if lSkill < 1.0 then
                    lSkill = 1.0
                  end if
                  lSlopeImpulse = -lDot * pChassisMass * pPowerCoeff * pWorldForward * lTimeStep * 3450.0 * lSkill * pAcceleration * pSlopeImpulseCoeff
                end if
              end if
            end if
            lImpulse = lImpulse + lSlopeImpulse
            me.ApplyImpulseToVehicle(lImpulse)
          end if
        end if
        if (pAcceleration < -pAccelerationEpsilon) and (pCurrSpeed > 130.0) then
          lImpulse = pCurrSpeed * pBrakeGain * 3.0 * pAcceleration * lTimeStep * pChassisMass * pWorldForward * pPowerCoeff
          me.ApplyImpulseToVehicle(lImpulse)
        end if
        if (pAcceleration < -pAccelerationEpsilon) and (pCurrSpeed <= 130.0) then
          lMaxSpeed = pMaxSpeed * 0.59999999999999998
          lDelta = -(lMaxSpeed * 0.10000000000000001 * lMaxSpeedFactor) - pCurrSpeed
          lImpulse = lDelta * pDecGain * 3.0 * lTimeStep * pChassisMass * pWorldForward * pPowerCoeff
          me.ApplyImpulseToVehicle(lImpulse)
        end if
      end if
    end if
    if pLateralForceTimer <> -1 then
      if pLateralForceTimer > kTime then
        lImp = pWorldRight * pLateralForceIntensity * lTimeStep * pChassisMass * pCurrSpeed * pLateralForceSign
        me.ApplyImpulseToVehicle(lImp)
      else
        pLateralForceTimer = -1
      end if
    end if
    if pSpeedKmh < pLowGripSpeed then
      lGrip = pLowGrip
    else
      lGrip = pGrip
    end if
    lGrip = lGrip * pSkill
    if pBraking then
      lGrip = lGrip * 2.0
      if pForceToBrake > 0.0 then
        lGrip = lGrip * 1.5
      end if
    end if
    if not pIsOnGround then
      lGrip = lGrip * 3.0
    end if
    lImpulse = pWorldRight * (-pSlideSpeed * pChassisMass * lGrip * lTimeStep * 5.0) * pPowerCoeff
    if not pIsOnGround then
      lImpulse.z = 0.0
      lImpulse = pGripOnAirFactor * lImpulse
    end if
    me.ApplyImpulseToVehicle(lImpulse)
    if (lCanTurn = 0) or ((pSteering >= -pSteeringEpsilon) and (pSteering <= pSteeringEpsilon)) then
      if pSteeringResistanceMethod = #timeStep then
        lImpulse = pWorldUp * pCurrAngVel.dot(pWorldUp) * (pRestPositionSteeringResistence * pChassisMass * lTimeStep) * pPowerCoeff
      else
        lImpulse = pWorldUp * pCurrAngVel.dot(pWorldUp) * (pRestPositionSteeringResistence * pChassisMass * 0.02) * pPowerCoeff
      end if
      me.ApplyAngularImpulseToVehicle(lImpulse)
    else
      lAngularVelocity = pCurrAngVel.dot(pWorldUp)
      if lAngularVelocity <> 0.0 then
        if pCurrSpeed > 0.0 then
          lAngleVersus = lAngularVelocity
        else
          lAngleVersus = -lAngularVelocity
        end if
        if ((pSteering < -pSteeringEpsilon) and (lAngleVersus < 0.0)) or ((pSteering > pSteeringEpsilon) and (lAngleVersus > 0.0)) then
          if pSteeringResistanceMethod = #timeStep then
            lImpulse = pWorldUp * lAngularVelocity * (pOppositeSteeringResistence * pChassisMass * lTimeStep) * pPowerCoeff
          else
            lImpulse = pWorldUp * lAngularVelocity * (pOppositeSteeringResistence * pChassisMass * 0.02) * pPowerCoeff
          end if
          me.ApplyAngularImpulseToVehicle(lImpulse)
        end if
      end if
    end if
    lTurnGain = pTurnGain
    if pTurnOnSteering then
      lTurnOnSteeringCoeff = abs(pSteering)
    else
      lTurnOnSteeringCoeff = 1.0
    end if
    if lCanTurn and (pSteering < -pSteeringEpsilon) then
      lImpulse = pWorldUp * (lTurnGain * pChassisMass) * pPowerCoeff * lRotationalCoeff * lTimeStep * 25.0 * lTurnOnSteeringCoeff
      if pCurrSpeed < 0.0 then
        lImpulse = -lImpulse
      end if
      me.ApplyAngularImpulseToVehicle(lImpulse)
    end if
    if lCanTurn and (pSteering > pSteeringEpsilon) then
      lImpulse = pWorldUp * (-lTurnGain * pChassisMass) * pPowerCoeff * lRotationalCoeff * lTimeStep * 25.0 * lTurnOnSteeringCoeff
      if pCurrSpeed < 0.0 then
        lImpulse = -lImpulse
      end if
      me.ApplyAngularImpulseToVehicle(lImpulse)
    end if
    if pIsOnGround or pForceDragOnAir then
      if pCurrSpeed <= 0.0 then
        lImpulse = -pCurrVel * (pDrag * 6.0 * pChassisMass * lTimeStep)
      else
        lImpulse = -pCurrVel * (pDrag * 1.94999999999999996 * pChassisMass * lTimeStep)
      end if
      me.ApplyImpulseToVehicle(lImpulse)
    end if
    if pIsOnGround then
      if (pAcceleration >= -pAccelerationEpsilon) and (pAcceleration <= pAccelerationEpsilon) then
        if pCurrSpeed <= 0.0 then
          lImpulse = -pCurrVel * (pEngineBrakeGain * 6.0 * pChassisMass * lTimeStep)
        else
          lImpulse = -pCurrVel * (pEngineBrakeGain * 1.94999999999999996 * pChassisMass * lTimeStep)
        end if
        me.ApplyImpulseToVehicle(lImpulse)
      end if
    end if
  end if
end

on OnChangeEngineGear me
end
