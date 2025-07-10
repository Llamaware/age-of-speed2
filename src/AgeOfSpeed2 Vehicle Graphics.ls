property ancestor, pVehicle, pPlayer, pShadowMdl, pWheelSpinCoeffFront, pWheelSpinCoeffBack, pMaxWheelTurn, pWheelTurn, pWheelSpinFront, pWheelSpinBack, pHoverDist, pWheelPointList, pWheelRadiusFront, pWheelRadiusBack, pBackWheelBlocked, pRightOrientation, pFrontOrientation, pPitch, pDistanceToRb
global gGame

on new me, kPlayer, kVehicle, kConfSet
  me.ancestor = script("Vehicle Graphics").new(kPlayer, kVehicle, kConfSet)
  pWheelRadiusFront = 36.77250000000000085
  pWheelRadiusBack = 49.82099999999999795
  pMaxWheelTurn = kConfSet.MaxWheelTurn
  pHoverDist = kConfSet.HoverDist
  pWheelSpinCoeffBack = 360.0 / (2.0 * PI * pWheelRadiusBack)
  pWheelSpinCoeffFront = 360.0 / (2.0 * PI * pWheelRadiusFront)
  pWheelSpinFront = 0.0
  pWheelSpinBack = 0.0
  pWheelTurn = 0.0
  pVehicle = kVehicle
  pPlayer = kPlayer
  return me
end

on Initialize me, kConfSet
  me.ancestor.Initialize()
  me.SetMinRollAngle(-3.0)
  me.SetMaxRollAngle(3.0)
  me.SetRollAngleCoeff(0.0064)
  me.SetRollSmoothCoeff(2.0)
  me.SetRollSmoothCoeffReturn(4.0)
  me.CreateGfx()
  me.InitWheel()
  pFrontOrientation = VOID
  pRightOrientation = VOID
  pShadowMdl = gGame.Get3D().model("veh_shadow_" & pPlayer.GetPlayerId())
  pPitch = 0.0
  pDistanceToRb = 0.0
end

on CreateGfx me
  lGfxChassis = gGame.Get3D().model("veh_chassis_" & me.GetPlayer().GetPlayerId() & "_gfx_cam")
  me.SetGfxChassis(lGfxChassis)
  lGfxChassis.pointAtOrientation = [vector(0.0, 1.0, 0.0), vector(0.0, 0.0, 1.0)]
end

on InitWheel me
  lId = me.GetPlayer().GetPlayerId()
  lWheelFrontLeftModelName = "veh_wheel_fl_" & lId
  lWheelFrontRightModelName = "veh_wheel_fr_" & lId
  lWheelRearLeftModelName = "veh_wheel_bl_" & lId
  lWheelRearRightModelName = "veh_wheel_br_" & lId
  lWheelList = [gGame.Get3D().model(lWheelFrontLeftModelName), gGame.Get3D().model(lWheelFrontRightModelName), gGame.Get3D().model(lWheelRearLeftModelName), gGame.Get3D().model(lWheelRearRightModelName)]
  me.SetWheelList(lWheelList)
  lWheelContactPointList = [VOID, VOID, VOID, VOID]
  me.SetWheelContactPointList(lWheelContactPointList)
  pWheelPointList = me.GetVehicle().GetHoverPointList()
end

on GamePaused me
end

on GameResumed me
end

on UpdateWheels me
  lTimeStep = gGame.GetHavokPhysics().GetTimeStep()
  lVehicle = me.GetVehicle()
  lSteering = lVehicle.GetSteering()
  lSteeringEpsilon = lVehicle.GetSteeringEpsilon()
  lCurrSpeed = lVehicle.GetSpeed()
  lGfxChassis = me.GetGfxChassis()
  lLocalRight = vector(1.0, 0.0, 0.0)
  if not pPlayer.IsCPUControlled() then
    if lSteering < 0.0 then
      pWheelTurn = pWheelTurn - (3.5 * lTimeStep)
      if pWheelTurn < -1.0 then
        pWheelTurn = -1.0
      end if
    else
      if lSteering > 0.0 then
        pWheelTurn = pWheelTurn + (3.5 * lTimeStep)
        if pWheelTurn > 1.0 then
          pWheelTurn = 1.0
        end if
      end if
    end if
    if (lSteering < lSteeringEpsilon) and (lSteering > -lSteeringEpsilon) then
      if not (pWheelTurn = 0) then
        if abs(pWheelTurn) < (0.59999999999999998 * lTimeStep) then
          pWheelTurn = 0
        else
          if pWheelTurn < 0 then
            pWheelTurn = pWheelTurn + (0.59999999999999998 * lTimeStep)
          else
            pWheelTurn = pWheelTurn - (0.59999999999999998 * lTimeStep)
          end if
        end if
      end if
    end if
  else
    lTargetPos = pPlayer.GetAiController().GetTargetPosition()
    lPlayerPos = lVehicle.getPosition()
    lToTargetPos = lTargetPos - lPlayerPos
    lFront = lVehicle.GetWorldForward()
    lAngleBetween = lFront.angleBetween(lToTargetPos)
    if lAngleBetween < 10.0 then
      pWheelTurn = pWheelTurn + (-pWheelTurn * lTimeStep * 1.5)
    else
      lCross = lFront.cross(lToTargetPos)
      if lCross.z > 0 then
        pWheelTurn = pWheelTurn - (1.5 * lTimeStep)
        if pWheelTurn < -1.0 then
          pWheelTurn = -1.0
        end if
      else
        pWheelTurn = pWheelTurn + (1.5 * lTimeStep)
        if pWheelTurn > 1.0 then
          pWheelTurn = 1.0
        end if
      end if
    end if
  end if
  lBackWheelSpinMultiplier = 1.0
  if pBackWheelBlocked then
    lBackWheelSpinMultiplier = 0.0
  end if
  pWheelSpinFront = pWheelSpinFront - (lCurrSpeed * pWheelSpinCoeffFront * lTimeStep)
  pWheelSpinFront = pWheelSpinFront mod 360
  pWheelSpinBack = pWheelSpinBack - (lCurrSpeed * lTimeStep * pWheelSpinCoeffBack * lBackWheelSpinMultiplier)
  pWheelSpinBack = pWheelSpinBack mod 360
  lGfxChassisTr = lGfxChassis.transform
  lChassisTransf = lGfxChassisTr
  lWorldDown = -lGfxChassisTr.zAxis
  lIsHoveringList = me.GetVehicle().GetIsHoveringList()
  lHoverDistList = lVehicle.GetHoverDistList()
  lWheelList = me.GetWheelList()
  repeat with li = 1 to lWheelList.count
    if not voidp(lWheelList[li]) then
      if li < 3 then
        lWheelRadius = pWheelRadiusFront
      else
        lWheelRadius = pWheelRadiusBack
      end if
      lRelativeWheelPosition = pWheelPointList[li]
      lWorldWheelPosition = (lChassisTransf * lRelativeWheelPosition) - (35.0 * lWorldDown)
      lWheelTransform = lWheelList[li].transform
      lWheelDistance = pHoverDist
      if lIsHoveringList[li] then
        lWheelDistance = lHoverDistList[li]
      end if
      lWheelDistance = lWheelDistance - lWheelRadius
      lWheelMinDistance = 25.0
      if lWheelDistance < lWheelMinDistance then
        lWheelDistance = lWheelMinDistance
      end if
      lWheelMaxDistance = 30.0
      if lWheelDistance > lWheelMaxDistance then
        lWheelDistance = lWheelMaxDistance
      end if
      lWheelTransform.position = lWorldWheelPosition + (lWheelDistance * lWorldDown)
      if li < 3 then
        lWheelSpin = pWheelSpinFront
        lWheelTransform.rotation = lGfxChassis.transform.rotation + (pMaxWheelTurn * pWheelTurn * 0.34999999999999998 * lWorldDown)
      else
        lWheelTransform.rotation = lGfxChassis.transform.rotation
        lWheelSpin = pWheelSpinBack
      end if
      lWheelNormalizedTransform = lWheelTransform.duplicate()
      lWheelNormalizedTransform.position = vector(0.0, 0.0, 0.0)
      lWheelNormalizedTransform.scale = vector(1.0, 1.0, 1.0)
      lWheelRight = lWheelNormalizedTransform * lLocalRight
      lWheelRight.normalize()
      lWheelTransform.rotate(lWheelTransform.position, lWheelRight, lWheelSpin)
    end if
  end repeat
end

on UpdateChassisGfx me
  lGfxChassis = me.GetGfxChassis()
  lGfxChassis.transform = me.GetVehicle().GetTransform()
  lGfxChassis.transform.rotation = lGfxChassis.transform.rotation - (me.GetRollAngle() * vector(0.0, 1.0, 0.0))
end

on UpdateGfxTransform_RayCompensation me, kTime
  lDt = gGame.GetTimeManager().GetDeltaTime() * 0.001
  lHoverDistance = 40.0
  lVehicleGfxTransform = me.GetGfxChassis().transform
  lVehicleRbTransform = pVehicle.GetTransform()
  lProjectGfx = 1
  lHoverContactPointCounter = 0
  lHoverContactPoint = pVehicle.GetHoverContactPoint()
  if lHoverContactPoint.count < 4 then
    lProjectGfx = 0
  else
    repeat with li = 1 to lHoverContactPoint.count
      if voidp(lHoverContactPoint[li]) or (lHoverContactPoint[li] = 0) then
        lProjectGfx = 0
        next repeat
      end if
      lHoverContactPointCounter = lHoverContactPointCounter + 1
    end repeat
  end if
  lGroundDistance = abs(pVehicle.GetGroundDistance())
  if lProjectGfx then
    lUp = pVehicle.GetTokenUp()
    if lUp.dot(lVehicleRbTransform.zAxis) < 0.90000000000000002 then
      lProjectGfx = 0
    end if
  end if
  if (lGroundDistance > 85) or not lProjectGfx then
    lDistanceToRb = 68.0
    pDistanceToRb = pDistanceToRb + ((lDistanceToRb - pDistanceToRb) * lDt * 9.0)
    lToChassis = lVehicleRbTransform.zAxis
    lCenterPoint = lVehicleRbTransform.position - (lToChassis * pDistanceToRb)
    lRight = lVehicleRbTransform.xAxis
    lFront = lVehicleRbTransform.yAxis
    pRightOrientation = pRightOrientation + ((lRight - pRightOrientation) * lDt * 9.0)
    pFrontOrientation = pFrontOrientation + ((lFront - pFrontOrientation) * lDt * 9.0)
    lUp = -pFrontOrientation.cross(pRightOrientation)
    lShadowPos = lVehicleRbTransform.position - (lToChassis * lGroundDistance)
    if lHoverContactPointCounter = 4 then
      lFront = lHoverContactPoint[1] - lHoverContactPoint[3]
      lRight = lHoverContactPoint[4] - lHoverContactPoint[3]
      lRight.normalize()
      lFront.normalize()
    end if
  else
    lFront = lHoverContactPoint[1] - lHoverContactPoint[3]
    lRight = lHoverContactPoint[4] - lHoverContactPoint[3]
    if voidp(pFrontOrientation) then
      pFrontOrientation = lFront.duplicate()
      pFrontOrientation.normalize()
    end if
    if voidp(pRightOrientation) then
      pRightOrientation = lRight.duplicate()
      pRightOrientation.normalize()
    end if
    lRight.normalize()
    lFront.normalize()
    lCenterPoint = (lHoverContactPoint[1] + lHoverContactPoint[2] + lHoverContactPoint[3] + lHoverContactPoint[4]) * 0.25
    lToChassis = lVehicleRbTransform.position - lCenterPoint
    pDistanceToRb = lToChassis.magnitude
    lToChassis.normalize()
    lShadowPos = lCenterPoint + (lToChassis * 8.0)
    pRightOrientation = pRightOrientation + ((lRight - pRightOrientation) * lDt * 9.0)
    pFrontOrientation = pFrontOrientation + ((lFront - pFrontOrientation) * lDt * 9.0)
    lUp = -pFrontOrientation.cross(pRightOrientation)
  end if
  lPos = lCenterPoint + (lHoverDistance * lToChassis)
  lVehicleGfxTransform.position = lPos
  me.GetGfxChassis().pointAt(lPos + (pFrontOrientation * 10.0), lUp)
  if pVehicle.GetShadowVisible() and (lProjectGfx or ((lHoverContactPointCounter > 0) and (abs(pVehicle.GetTrasversal()) < 1.00099999999999989))) then
    pShadowMdl.visibility = #front
    pShadowMdl.transform.position = lShadowPos
    pShadowMdl.pointAt(lShadowPos + (lFront * 10.0), lUp)
  else
    pShadowMdl.visibility = #none
  end if
end

on UpdateChassisInclination me
  lDt = gGame.GetTimeManager().GetDeltaTime() * 0.001
  lVehicle = me.GetVehicle()
  lSpeedFactor = abs(lVehicle.GetSpeedKmh()) / 180.0
  if lSpeedFactor > 1.0 then
    lSpeedFactor = 1.0
  end if
  if abs(lVehicle.GetSpeedKmh()) < 4.0 then
    lPitchTo = 0.0
    lSmooth = 8.0
  else
    if lVehicle.GetAcceleration() > 0.0 then
      lPitchTo = 4.0 * (1.0 - lSpeedFactor)
      lSmooth = 0.25
    else
      if lVehicle.GetAcceleration() = 0.0 then
        lPitchTo = 0.0
        lSmooth = 0.5
      else
        lPitchTo = -3.0 * (1.0 - lSpeedFactor)
        lSmooth = 0.5
      end if
    end if
  end if
  pPitch = pPitch + ((lPitchTo - pPitch) * lDt * lSmooth)
  lVehicleGfxTransform = me.GetGfxChassis().transform
  lVehicleGfxTransform.rotation = lVehicleGfxTransform.rotation - (me.GetRollAngle() * vector(0.0, 1.0, 0.0)) + (pPitch * vector(1.0, 0.0, 0.0))
end

on CalculateWheelContactPoints me
  lWheelContactPointList = [0.0, 0.0, 0.0, 0.0]
  lWheelList = me.GetWheelList()
  lDown = -me.GetGfxChassis().transform.zAxis
  repeat with li = 1 to lWheelList.count
    lWheelMdl = lWheelList[li]
    if li < 3 then
      lWheelRadius = pWheelRadiusFront
    else
      lWheelRadius = pWheelRadiusBack
    end if
    lWheelContactPointList[li] = lWheelMdl.transform.position + (lDown * (lWheelRadius - 4.0))
  end repeat
  me.SetWheelContactPointList(lWheelContactPointList)
end

on update me, kTime
  me.ancestor.update(kTime)
  me.UpdateRollAngle()
  me.UpdateGfxTransform_RayCompensation(kTime)
  me.UpdateWheels()
  me.CalculateWheelContactPoints()
  me.UpdateChassisInclination()
end
