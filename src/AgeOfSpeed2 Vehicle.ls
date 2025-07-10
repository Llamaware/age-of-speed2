property ancestor, pGravityCoeff, pShadowVisible, pGravity, pFlippingTimer, pTokenUp
global gGame

on new me
  me.ancestor = script("Vehicle Base").new()
  return me
end

on Initialize me, kPlayerRef, kShadow, kOBBData, kConfSet, kDriveData, kQuadTree
  ancestor.Initialize(kPlayerRef, kShadow, kOBBData, kConfSet, kDriveData, kQuadTree)
  pGravityCoeff = 1.0
  pFlippingTimer = -1
  return 1
end

on GetGravityCoeff me
  return pGravityCoeff
end

on GetShadowVisible me
  return pShadowVisible
end

on getGravity me
  return pGravity
end

on GetTokenUp me
  return pTokenUp
end

on OnCollision me, kCollisionDetails
  if gGame.GetGameStatus() = #play then
    lCollisionNormal = kCollisionDetails[4]
    if lCollisionNormal.dot(me.GetWorldUp()) > 0.80000000000000004 then
      return 0
    end if
    lAgainstOtherVehicle = 0
    lObjName = kCollisionDetails[2]
    lCollisionIntensity = kCollisionDetails[5]
    if lObjName starts "veh_" then
      lOtherRB = gGame.GetHavokPhysics().GetHavok().rigidBody(lObjName)
      lAgainstOtherVehicle = 1
    end if
    if abs(me.GetSpeedKmh()) > 50 then
      gGame.GetGameSoundManager().PlaySound("snd_hit", 50)
    end if
  end if
  return 1
end

on UpdateTrackPosInfo me
  if gGame.GetGameStatus() <> #play then
    return 
  end if
  lTokenRef = me.GetCurrentTokenRef()
  lDistanceFromStart = lTokenRef.DistanceFromStart
  lRoadLength = lTokenRef.RoadLength
  lTokenTrackPos = me.GetLongitudinal() * lRoadLength
  lTrackPos = lDistanceFromStart + lTokenTrackPos
  lTrackLength = gGame.GetTrackLength()
  if lTrackPos >= lTrackLength then
    lTrackPos = lTrackPos - lTrackLength
  end if
  lRaceTrackPos = (me.GetLaps() * lTrackLength) + lTrackPos
  if lRaceTrackPos < 0 then
    lRaceTrackPos = 0
  end if
  me.SetTrackPos(lTrackPos)
  me.SetRaceTrackPos(lRaceTrackPos)
  lGroundDistance = me.GetGroundDistance()
  if abs(lGroundDistance) > 110.0 then
    return 
  end if
  if lTokenRef.turbo then
    me.SetTurboBoost(1000.0, 2.75)
  else
    case gGame.GetLevelId() of
      1:
        if (me.GetCurrentToken() = #t25) or (me.GetCurrentToken() = #t30) then
          me.SetTurboBoost(200.0, 1.75)
        end if
      2:
        if (me.GetCurrentToken() = #t8) or (me.GetCurrentToken() = #t19) then
          me.SetTurboBoost(200.0, 1.75)
        end if
    end case
  end if
end

on UpdateGravity me
  lGroundDistance = me.GetGroundDistance()
  lGroundDistance = Clamp(lGroundDistance, -1400.0, 1400.0)
  if abs(lGroundDistance) > 200 then
    me.SetMinPowerCoeff(0.22)
  else
    me.SetMinPowerCoeff(0.69999999999999996)
  end if
  lChassisTr = me.GetChassisMdl().transform
  lAxisX = lChassisTr.xAxis
  lAxisY = lChassisTr.yAxis
  lTR = lChassisTr.duplicate()
  lTR.position = vector(0.0, 0.0, 0.0)
  lTR.rotation.x = 0.0
  lTR.rotation.y = 0.0
  lUp = me.GetShadowIntersectionNormal()
  lTorqueCoeff = 1.80000000000000004
  if abs(lGroundDistance) > 400 then
    lTorqueCoeff = 0.34999999999999998
  else
    lTorqueCoeff = (1.0 - (abs(lGroundDistance) / 400.0)) * 4.0
  end if
  lYProj = lUp.dot(lAxisY)
  lTorqueAxis = lAxisX
  lTorque = -lYProj * 900000.0
  me.GetChassisRB().applyTorque(lTorqueAxis * lTorque * lTorqueCoeff)
  lXProj = lUp.dot(lAxisX)
  lTorque = lXProj * 1000000.0
  lTorqueAxis = lAxisY
  me.GetChassisRB().applyTorque(lTorqueAxis * lTorque)
end

on UpdateTokenInfo me
  lPos = me.getPosition()
  lTokenManager = gGame.GetTokenManager()
  lResult = lTokenManager.getToken(me.GetCurrentToken(), lPos.x, lPos.y, lPos, 0.0, 0.0)
  if lResult[1] = 0 then
    lOutTrack = 1
  else
    lOutTrack = 0
  end if
  if lOutTrack and not me.HaveToResetToTrack() then
    lExpansionResult = lTokenManager.GetTokenWithExpansion(me.GetCurrentToken(), lPos.x, lPos.y, lPos)
    if lExpansionResult[1] = 0 then
      if me.GetRestoreOnOutTrack() then
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
    lCurrentToken = lResult[1]
    me.SetCurrentToken(lCurrentToken)
    me.SetTokenTangent(lResult[3])
    me.SetLongitudinal(lResult[4])
    me.SetTrasversal(lResult[5])
    me.SetCurrentTokenRef(lTokenManager.GetTokenRef(lCurrentToken))
  end if
end

on UpdateHoverOnCullerRayBlock me
  lDt = gGame.GetHavokPhysics().GetTimeStep()
  me.SetModelList(gGame.GetCullingManager().GetCullerRayBlockModels(me.GetChassisRB().position))
  lWorldDown = -me.GetWorldUp()
  lHoverDistance = me.GetHoverDist()
  lHoverPointList = me.GetHoverPointList()
  lIsHoveringList = [0, 0, 0, 0]
  lUp = vector(0.0, 0.0, 1.0)
  lHoverGroundNormal = [lUp, lUp, lUp, lUp]
  lHoverContactPoint = [VOID, VOID, VOID, VOID]
  lHoverDistList = me.GetHoverDistList()
  lShadowVisible = 1
  lHoverCollisionDetails = []
  repeat with i = 1 to lHoverPointList.count
    lWorldHoverPoint = me.GetTransform() * lHoverPointList[i]
    lIntersectionInfo = VOID
    lArgs = [#maxNumberOfModels: 3, #levelOfDetail: #detailed, #modelList: me.GetModelList()]
    lIntersectDetails = gGame.Get3D().modelsUnderRay(lWorldHoverPoint, lWorldDown, lArgs)
    repeat with lIntersectDetailsRef in lIntersectDetails
      lExclude = 0
      if me.GetPlayer().GetPlayerId() = 1 then
        if lIntersectDetailsRef.meshID = 2 then
          lIntMdl = lIntersectDetailsRef.model
          lTextureIdxs = lIntMdl.meshDeform.mesh[lIntersectDetailsRef.meshID].face[lIntersectDetailsRef.faceID]
          lu = lIntersectDetailsRef.uvCoord.u
          lV = lIntersectDetailsRef.uvCoord.v
          ltc = lIntMdl.meshDeform.mesh[lIntersectDetailsRef.meshID].textureCoordinateList
          lC1 = ltc[lTextureIdxs[1]]
          lC2 = ltc[lTextureIdxs[2]]
          lc3 = ltc[lTextureIdxs[3]]
          lRes = ((1.0 - lu - lV) * lC1) + (lu * lC2) + (lV * lc3)
          if lRes[1] > 0.5 then
            lExclude = 1
          end if
        end if
      end if
      if not lExclude then
        if lIntersectDetailsRef[1].visibility <> #none then
          lIntersectionInfo = lIntersectDetailsRef
          lHoverCollisionDetails.add(lIntersectionInfo.model.name)
          exit repeat
        end if
      end if
    end repeat
    if not voidp(lIntersectionInfo) then
      lChassisPoint = lIntersectionInfo[3]
      lToGround = lChassisPoint - lWorldHoverPoint
      lToGroundDistance = lToGround.length
      if lIntersectionInfo.model.shader.blend <> 0 then
        if lIntersectionInfo[2] < lHoverDistance then
          lPointVelocity = me.GetVelocity() + me.GetCurrAngVel().cross(lWorldHoverPoint - me.GetWorldRBCOM())
          lForce = -me.GetStrength() * (lHoverDistance - lToGroundDistance) * lDt * 7.5
          lProjectedPointVelocity = lPointVelocity.dot(lToGround)
          if lProjectedPointVelocity > 0 then
            lDampingForce = me.GetDamping() * lProjectedPointVelocity * 0.075
          else
            lDampingForce = me.GetDamping() * lProjectedPointVelocity * 0.14999999999999999
          end if
          lForce = lForce - lDampingForce
          lAppliedForce = lToGround * lForce * me.GetChassisMass()
          me.GetChassisRB().applyImpulseAtPoint(lAppliedForce * 0.0015, lHoverPointList[i])
          lIsHoveringList[i] = 1
        end if
      else
        lShadowVisible = 0
        lToGroundDistance = 1000.0
      end if
      lHoverGroundNormal[i] = lIntersectionInfo[4]
      lHoverContactPoint[i] = lChassisPoint
      lHoverDistList[i] = lToGroundDistance
    end if
  end repeat
  me.SetIsHoveringList(lIsHoveringList)
  me.SetHoverCollisionDetails(lHoverCollisionDetails)
  me.SetHoverGroundNormal(1, lHoverGroundNormal[1])
  me.SetHoverGroundNormal(2, lHoverGroundNormal[2])
  me.SetHoverGroundNormal(3, lHoverGroundNormal[3])
  me.SetHoverGroundNormal(4, lHoverGroundNormal[4])
  me.SetHoverContactPoint(1, lHoverContactPoint[1])
  me.SetHoverContactPoint(2, lHoverContactPoint[2])
  me.SetHoverContactPoint(3, lHoverContactPoint[3])
  me.SetHoverContactPoint(4, lHoverContactPoint[4])
  me.SetHoverDistList(1, lHoverDistList[1])
  me.SetHoverDistList(2, lHoverDistList[2])
  me.SetHoverDistList(3, lHoverDistList[3])
  me.SetHoverDistList(4, lHoverDistList[4])
  pShadowVisible = lShadowVisible
end

on UpdatePhysics me, kAcceleration, kSteering
  me.SetAcceleration(kAcceleration)
  me.SetSteering(kSteering)
  lNormTrans = me.GetTransform().duplicate()
  lNormTrans.position = vector(0.0, 0.0, 0.0)
  lNormTrans.scale = vector(1.0, 1.0, 1.0)
  me.SetWorldUp(lNormTrans * -me.GetLocalDown())
  me.SetWorldForward(lNormTrans * me.GetLocalForward())
  me.SetWorldRight(me.GetWorldUp().cross(me.GetWorldForward()))
  me.SetWorldMdlPos(me.GetChassisMdl().transform.position)
  me.SetWorldRBPos(me.GetChassisRB().position)
  me.SetWorldRBCOM(me.GetWorldRBPos() + me.GetChassisRB().centerOfMass)
  me.SetVelocity(me.GetChassisRB().linearVelocity)
  me.SetPreviousSpeed(me.GetSpeed())
  me.SetSpeed(me.GetVelocity().dot(me.GetWorldForward()))
  me.SetCurrAngVel(me.GetChassisRB().angularVelocity)
  me.UpdateHoverOnCullerRayBlock()
  if not voidp(me.GetShadow()) then
    me.UpdateShadow()
  end if
  if not me.GetDisableControl() then
    me.UpdateRecover()
    me.UpdateAutoFlip()
  end if
  me.AiRestore()
  me.UpdateDrive()
  me.SetLastImpulses(me.GetImpulseSum())
  me.FlushImpulses()
  me.FlushAngularImpulses()
  if not voidp(me.getOBBWidth()) then
    lWorldTr = me.GetChassisMdl().getWorldTransform()
    lPos = lWorldTr.position
    lAngle = lWorldTr.rotation.z * PI / 180.0
    lOBB = CreateOBBPack(lPos, lAngle, me.getOBBWidth(), me.getOBBHeight())
    me.SetOBB(lOBB)
  end if
end

on StartMissileEffect me
  me.GetChassisRB().applyImpulse((me.GetTransform().zAxis * 300000.0) + (me.GetTransform().xAxis * 150000.0))
end

on UpdateUnderWeaponEffect me, kAcceleration
  lMaxSpeedPos = 100.0
  lMaxSpeedPos = Clamp(lMaxSpeedPos, 175, 250)
  lBrakeAccPos = -0.28000000000000003
  lAccPosFactor = 0.59999999999999998
  lMaxSpeedNeg = -70
  lBrakeAccNeg = -0.40000000000000002
  lAccNegFactor = 0.40000000000000002
  if me.GetSpeedKmh() > 0 then
    if me.GetSpeedKmh() > lMaxSpeedPos then
      if kAcceleration > lBrakeAccPos then
        kAcceleration = lBrakeAccPos
      end if
    else
      kAcceleration = kAcceleration * lAccPosFactor
    end if
  else
    if me.GetSpeedKmh() < lMaxSpeedNeg then
      if kAcceleration < lBrakeAccNeg then
        kAcceleration = lBrakeAccNeg
      end if
    else
      kAcceleration = kAcceleration * lAccNegFactor
    end if
  end if
  return kAcceleration
end

on UpdateRestore me
  lAngleToUp = me.GetWorldUp().dot(pTokenUp)
  if lAngleToUp < 0.20000000000000001 then
    if pFlippingTimer = -1 then
      pFlippingTimer = gGame.GetTimeManager().GetTime()
    end if
    if (gGame.GetTimeManager().GetTime() - pFlippingTimer) > 2000 then
      pFlippingTimer = -1
      if me.GetPlayer().GetPlayerId() = 1 then
        call(#ResetToTrackWithFade, gGame.GetGameplay())
      else
        me.ResetToTrack()
      end if
    end if
  else
    pFlippingTimer = -1
  end if
end

on update me, kAcceleration, kSteering
  if me.GetPlayer().GetUnderElektro() or me.GetPlayer().GetUnderMissile() then
    kAcceleration = me.UpdateUnderWeaponEffect(kAcceleration)
    lRandom = random(100)
    if lRandom < 50 then
      kSteering = 1.0
    else
      kSteering = -1.0
    end if
  end if
  me.ancestor.pHoverContactPoint = []
  me.UpdatePhysics(kAcceleration, kSteering)
  me.UpdateGravity()
  me.UpdateTokenInfo()
  me.UpdateTrackPosInfo()
  lDt = gGame.GetTimeManager().GetDeltaTime() * 0.001
  pGravity = -me.GetTransform().zAxis * -me.GetShadowIntersectionNormal().dot(-me.GetTransform().zAxis) * 80000.0 * lDt
  if abs(me.GetGroundDistance()) > 1000.0 then
    if me.GetShadowVisible() then
      lGravityCoeff = 3.25
    else
      lGravityCoeff = 1.25
    end if
  else
    lGravityCoeff = 1.0
  end if
  pGravity = pGravity * lGravityCoeff * 1.12000000000000011
  pTokenUp = gGame.GetTokenManager().GetTokenUp(me.GetCurrentToken(), me.GetLongitudinal())
  me.UpdateRestore()
end
