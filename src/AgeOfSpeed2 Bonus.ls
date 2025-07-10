property pModelRef, pModelName, pPosition, pRotation, pType, pActive, pZPos, pUp, pActivationDistance, pUserData, pPlacedTime, pRespawnTime, pTimer, pTestType, pMove, pZOffset, pToRemove, pShadowZ, pShadowModel, pShadowEnabled, pBonusProperties, pIsBillboard, pCheckpointListIndex, pRespawnCallbackData, pCanRespawnCallbackData, pTokenUp
global gGame

on new me, fPosition, fRotation, fType, fActivationDistance, fBonusProperties, fRespawnTime, fZPos, fMove, fTestType, fZOffset, fUserData, fToRemove, fShadowZ
  pPosition = fPosition
  pRotation = fRotation
  pType = fType
  pShadowZ = fShadowZ
  pShadowModel = VOID
  pModelRef = VOID
  pActive = 0
  pActivationDistance = fActivationDistance
  pActivationDistanceSqr = pActivationDistance * pActivationDistance
  pModelName = fBonusProperties.model
  pBonusProperties = fBonusProperties
  pUp = 1
  pUserData = fUserData
  pPlacedTime = 0
  pZPos = fZPos
  pMove = fMove
  pTestType = fTestType
  pZOffset = fZOffset
  pToRemove = fToRemove
  pRespawnTime = fRespawnTime
  pIsBillboard = fBonusProperties.isBillboard
  pShadowEnabled = 1
  pRespawnCallbackData = VOID
  if not voidp(fUserData) then
    if not (fUserData.findPos("RespawnCallbackData") = VOID) then
      pRespawnCallbackData = fUserData.RespawnCallbackData
    end if
  end if
  pCanRespawnCallbackData = VOID
  if not voidp(fUserData) then
    if not (fUserData.findPos("CanRespawnCallbackData") = VOID) then
      pCanRespawnCallbackData = fUserData.CanRespawnCallbackData
    end if
  end if
  return me
end

on EnableShadow me
  if me.pShadowZ <> -1 then
    me.pShadowEnabled = 1
  end if
end

on DisableShadow me
  me.pShadowEnabled = 0
end

on getPosition me
  return pPosition
end

on Place me, fIndex, fActive
  lId = the milliSeconds
  lName = "bonus_" & fIndex & "_" & lId & "_cam"
  if me.pShadowZ <> -1 then
    lNameShadow = "bonus_shadow_" & fIndex & "_" & lId & "_cam"
    me.pShadowModel = gGame.Get3D().newModel(lNameShadow, pBonusProperties.ShadowResourceRef)
    me.pShadowModel.transform.position = me.pPosition
    lPosition = me.pPosition.duplicate()
    lPosition.z = lPosition.z + 20.0
    lModelList = gGame.GetCullingManager().GetCullerRayBlockModels(lPosition)
    lArguments = [#maxNumberOfModels: 3, #levelOfDetail: #detailed, #modelList: lModelList]
    lIntersections = gGame.Get3D().modelsUnderRay(lPosition, vector(0.0, 0.0, -1.0), lArguments)
    repeat with lIntersection in lIntersections
      if not (lIntersection[1].name contains "_cam") then
        lNormal = lIntersection[#isectNormal]
        me.pShadowModel.pointAtOrientation = [vector(0.0, 0.0, 1.0), vector(0.0, 1.0, 0.0)]
        me.pShadowModel.pointAt(me.pPosition + (lNormal * 20.0), vector(0.0, 1.0, 0.0))
        exit repeat
      end if
    end repeat
    me.pShadowModel.transform.position.z = pShadowZ
    me.pShadowModel.shaderList = pBonusProperties.ShadowShaderRef
  end if
  lTokenResult = gGame.GetTokenManager().getToken(pUserData.tokenindex, pPosition.x, pPosition.y, pPosition, 0.0, 0.0)
  lTokenId = lTokenResult[1]
  lLongitudinal = lTokenResult[4]
  l_TrackToken = gGame.GetTokenManager().GetTokenRef(pUserData.tokenindex)
  pTokenUp = gGame.GetTokenManager().GetTokenUp(lTokenId, lLongitudinal)
  lArguments = [#maxNumberOfModels: 3, #levelOfDetail: #detailed]
  lIntersections = gGame.Get3D().modelsUnderRay(pPosition, -pTokenUp, lArguments)
  repeat with lIntersection in lIntersections
    pTokenUp = lIntersection[#isectNormal]
    exit repeat
  end repeat
  if lIntersections.count = 0 then
    put "NOTFOUND " & l_TrackToken.token
  end if
  pModelRef = gGame.Get3D().newModel(lName, pBonusProperties.ModelResourceRef)
  pModelRef.shaderList = pBonusProperties.ModelShaderRef
  pModelRef.pointAtOrientation = [vector(0.0, 0.0, 1.0), vector(0.0, 1.0, 0.0)]
  pModelRef.transform.position = pPosition
  pModelRef.pointAt(pPosition + (pTokenUp * 100.0))
  if pZPos <> "none" then
    pModelRef.transform.position.z = pZPos
  else
    pZPos = pModelRef.transform.position.z
  end if
  pActive = fActive
  if pRespawnTime = -1 then
    pPlacedTime = -1
  else
    pPlacedTime = gGame.GetTimeManager().GetTime()
  end if
  lCheckpointManagerRef = gGame.GetCheckpointManager()
  lName = me.pModelRef.name & string(lCheckpointManagerRef.pCheckpointList.count)
  pCheckpointListIndex = lCheckpointManagerRef.AddWithObject(lName, me.pModelRef.transform.position, me.pActivationDistance, 1, me, VOID, VOID, VOID, #spheric)
end

on update me, fCamera
  lRemoveBonusFromManager = 0
  if me.pActive then
    if me.pIsBillboard then
      gGame.GetBillboardManager().AlignModelToScreen(fCamera, me.pModelRef)
    else
      if me.pMove then
        me.pModelRef.rotate(0.0, 0.0, 1.80000000000000004)
        me.MoveBonus(me.pZPos + me.pZOffset, me.pZPos, me.pZPos + (me.pZOffset / 2.0), 5.0, 1.0)
        me.pPosition = me.pModelRef.transform.position
      end if
    end if
  end if
  if me.pActive = 0 then
    if me.pRespawnTime <> -1 then
      if me.pPlacedTime <> -1 then
        me.pTimer = gGame.GetTimeManager().GetTime() - me.pPlacedTime
        if me.pTimer > me.pRespawnTime then
          lCanRespawn = 1
          if not voidp(pCanRespawnCallbackData) then
            lCanRespawn = call(pCanRespawnCallbackData.callback, pCanRespawnCallbackData.CallbackScriptName, me)
          end if
          if lCanRespawn then
            me.pActive = 1
            me.pModelRef.visibility = #front
            gGame.GetCheckpointManager().pCheckpointList[pCheckpointListIndex].pIsActive = 1
            if not voidp(pRespawnCallbackData) then
              call(pRespawnCallbackData.callback, pRespawnCallbackData.CallbackScriptName, me)
            end if
            if (me.pShadowZ <> -1) and (me.pShadowEnabled = 1) then
              me.pShadowModel.visibility = #front
            end if
          end if
        end if
      end if
    else
      lRemoveBonusFromManager = 1
      delete me
    end if
  end if
  return lRemoveBonusFromManager
end

on Check me, fPosition
  if me.pActive = 1 then
    if me.pToRemove then
      me.pActive = 0
      me.pModelRef.visibility = #none
      if (me.pShadowZ <> -1) and (me.pShadowEnabled = 1) then
        me.pShadowModel.visibility = #none
      end if
    end if
    me.pPlacedTime = gGame.GetTimeManager().GetTime()
    return 1
  end if
  return 0
end

on MoveBonus me, top, bottom, Middle, Steps, VelBegin
  lDt = gGame.GetTimeManager().GetDeltaTime() * 0.001
  lTR = transform()
  lTR.rotation.z = lDt
  pModelRef.transform = pModelRef.transform * lTR
  return 
  if (me.pModelRef.transform.position.z >= top) and (me.pUp = 1) then
    me.pUp = 0
  else
    if (me.pModelRef.transform.position.z <= bottom) and (me.pUp = 0) then
      me.pUp = 1
    end if
  end if
  if me.pModelRef.transform.position.z <= Middle then
    l_vel = ((me.pModelRef.transform.position.z - bottom) * (lDt * Steps)) + VelBegin
  else
    l_vel = ((top - bottom - (me.pModelRef.transform.position.z - bottom)) * (lDt * Steps)) + VelBegin
  end if
  if me.pUp then
    me.pModelRef.transform.position.z = me.pModelRef.transform.position.z + l_vel
  else
    me.pModelRef.transform.position.z = me.pModelRef.transform.position.z - l_vel
  end if
end

on ResetParams me, fBonusProperties
  me.pIsBillboard = fBonusProperties.isBillboard
end

on ExecuteInAction me, kData, kPlayerRef
  lBonusType = gGame.GetBonusManager().pBonusTypes[me.pType]
  gGame.GetCheckpointManager().pCheckpointList[pCheckpointListIndex].pIsActive = 0
  call(#BonusManagementCallback, gGame.GetGameplay(), lBonusType, me, kPlayerRef)
end

on ExecuteOutAction me
end

on ForceRespawn me
  me.pActive = 1
  me.pModelRef.visibility = #front
  gGame.GetCheckpointManager().pCheckpointList[pCheckpointListIndex].pIsActive = 1
  if (me.pShadowZ <> -1) and (me.pShadowEnabled = 1) then
    me.pShadowModel.visibility = #front
  end if
  if not voidp(pRespawnCallbackData) then
    call(pRespawnCallbackData.callback, pRespawnCallbackData.CallbackScriptName, me)
  end if
end

on delete me
  gGame.GetCullingManager().removeModel(pModelRef)
  l3D = gGame.Get3D()
  l3D.deleteModel(pModelRef.name)
  if not voidp(pShadowModel) then
    l3D.deleteModel(pShadowModel.name)
  end if
end
