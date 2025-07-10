property pcamera, pBonusArray, pBonusTypes

on new me, fCamera
  pcamera = fCamera
  pBonusTypes = []
  pBonusArray = []
  return me
end

on InitBonusTypes me, fBonusTypes
  me.pBonusTypes = fBonusTypes
  repeat with li = 1 to me.pBonusTypes.count
    lBonusModel = me.pBonusTypes[li].model
    if not voidp(lBonusModel) then
      lBonusModel.removeFromWorld()
      lBonusModel.visibility = #none
    end if
  end repeat
end

on GetBonusArray me
  return pBonusArray
end

on AddBonus me, fPosition, fTokenId, fBonusType, fActivationDistance, fRespawn, fZPos, fZOffset, fMove, fOrient, fOrientation, fToRemove, fShadowZ, fCustomRotation, fUserData
  lRotation = vector(0.0, 0.0, 0.0)
  if fOrient then
    if fOrientation = "#custom" then
      lDirection = float(fCustomRotation)
      lRotation = vector(0.0, 0.0, lDirection)
    end if
  end if
  if voidp(fUserData) then
    lUserData = [:]
  else
    if ilk(fUserData) <> #propList then
      lUserData = [:]
    else
      lUserData = fUserData.duplicate()
    end if
  end if
  lUserData.addProp(#tokenindex, fTokenId)
  lBonusElement = new(script("AgeOfSpeed2 Bonus"), fPosition, lRotation, fBonusType, fActivationDistance, me.pBonusTypes[fBonusType], fRespawn, fZPos, fMove, #sphere, fZOffset, lUserData, fToRemove, fShadowZ)
  pBonusArray.add(lBonusElement)
end

on AddDynamicBonus me, fPosition, fTokenId, fBonusType, fActivationDistance, fRespawn, fZPos, fZOffset, fMove, fOrient, fOrientation, fToRemove, fShadowZ, fCustomRotation, fUserData
  lRotation = vector(0.0, 0.0, 0.0)
  if fOrient then
    if fOrientation = "#custom" then
      lDirection = float(fCustomRotation)
      lRotation = vector(0.0, 0.0, lDirection)
    end if
  end if
  lUserData = [#tokenindex: fTokenId]
  if not voidp(fUserData) then
    if not (fUserData.findPos("RespawnCallbackData") = VOID) then
      lUserData.addProp("RespawnCallbackData", fUserData.RespawnCallbackData)
    end if
  end if
  lBonusElement = new(script("AgeOfSpeed2 Bonus"), fPosition, lRotation, fBonusType, fActivationDistance, me.pBonusTypes[fBonusType], fRespawn, fZPos, fMove, #sphere, fZOffset, lUserData, fToRemove, fShadowZ)
  pBonusArray.add(lBonusElement)
  lBonusElement.Place(pBonusArray.count, 1)
  lBonusElement.pModelRef.addToWorld()
  lBonusElement.pModelRef.visibility = #front
  return lBonusElement
end

on PlaceBonus me
  repeat with li = 1 to pBonusArray.count
    pBonusArray[li].Place(li, 1)
  end repeat
end

on UpdateBonus me
  repeat with li = pBonusArray.count down to 1
    lBonusHit = pBonusArray[li]
    if lBonusHit.pModelRef.isInWorld() then
      lRemove = lBonusHit.update(pcamera)
      if lRemove then
        pBonusArray.deleteAt(li)
      end if
    end if
  end repeat
end

on RespawnAll me
  repeat with li = 1 to pBonusArray.count
    lBonusHit = pBonusArray[li]
    if lBonusHit.pModelRef.isInWorld() then
      lBonusHit.ForceRespawn()
    end if
  end repeat
end
