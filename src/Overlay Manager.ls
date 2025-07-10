property pIdList, pWorldRef, pCameraRef

on new me, fWorldRef, fCameraRef
  me.pWorldRef = fWorldRef
  me.pCameraRef = fCameraRef
  me.pIdList = []
  return me
end

on add me, fObjectName, fTexture, fPosition, fScale, fBlend, fRot
  li = pIdList.getOne(fObjectName)
  if li > 0 then
    return #name_already_exist
  else
    if fRot = VOID then
      fRot = 0
    end if
    me.pCameraRef.addOverlay(fTexture, fPosition, fRot)
    me.pIdList.add(fObjectName)
    lIndex = me.GetIndex(fObjectName)
    if not voidp(fScale) then
      pCameraRef.overlay[lIndex].scale = fScale
    end if
    if not voidp(fBlend) then
      pCameraRef.overlay[lIndex].blend = fBlend
    end if
    return #Ok
  end if
end

on Modify me, fObjectName, fTexture, fPosition, fScale, fBlend, fRot
  li = pIdList.getOne(fObjectName)
  if li > 0 then
    if not voidp(fTexture) then
      me.pCameraRef.overlay[li].source = fTexture
    end if
    if not voidp(fPosition) then
      me.pCameraRef.overlay[li].loc = fPosition
    end if
    if not voidp(fScale) then
      pCameraRef.overlay[li].scale = fScale
    end if
    if not voidp(fBlend) then
      pCameraRef.overlay[li].blend = fBlend
    end if
    if not voidp(fRot) then
      pCameraRef.overlay[li].rotation = fRot
    end if
    return #Ok
  else
    return #name_not_found
  end if
end

on Remove me, fObjectName
  li = pIdList.getOne(fObjectName)
  if li > 0 then
    me.pCameraRef.removeOverlay(li)
    me.pIdList.deleteAt(li)
    return #Ok
  else
    return #name_not_found
  end if
end

on GetIndex me, fObjectName
  li = pIdList.getOne(fObjectName)
  if li > 0 then
    return li
  else
    return #name_not_found
  end if
end

on GetOverlayCount
  return pIdList.length
end

on GetOverlayList
  return pIdList
end

on GetOverlayData me, kObjectName
  lData = [#texture: VOID, #position: VOID, #scale: VOID, #blend: VOID, #rot: VOID]
  li = pIdList.getOne(kObjectName)
  if li > 0 then
    lData.texture = pCameraRef.overlay[li].source
    lData.position = pCameraRef.overlay[li].loc
    lData.scale = pCameraRef.overlay[li].scale
    lData.blend = pCameraRef.overlay[li].blend
    lData.rot = pCameraRef.overlay[li].rotation
    return lData
  else
    return #name_not_found
  end if
end
