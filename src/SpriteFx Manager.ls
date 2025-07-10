property p3D, pcamera, pOverlayManager, pScreenCenterPoint, pOverlayList, pOverlayTextures, pDynamicOverlayTextures, pFreeIdx, pEffectTypesList, pSpriteFxObjectList, pSpriteFxObjectCount
global gGame

on new me, k3D, kCamera, kOverlayManager, kInitializeOverlays
  p3D = k3D
  pcamera = kCamera
  pOverlayManager = kOverlayManager
  kScreenCenterPoint = point(sprite("3D").width * 0.5, sprite("3D").height * 0.5)
  pScreenCenterPoint = point(kScreenCenterPoint.locH, kScreenCenterPoint.locV)
  pOverlayList = []
  pDynamicOverlayList = []
  pOverlayTextures = []
  pDynamicOverlayTextures = []
  pFreeIdx = []
  pEffectTypesList = [:]
  pSpriteFxObjectList = []
  pSpriteFxObjectCount = 20
  lInitializeOverlays = 1
  if not voidp(kInitializeOverlays) then
    if not kInitializeOverlays then
      lInitializeOverlays = 0
    end if
  end if
  if lInitializeOverlays then
    me.CreateOverlays()
  end if
  me.InitializeEffects()
  return me
end

on SetSpriteFxObjectCount me, kValue
  pSpriteFxObjectCount = kValue
end

on AddSpriteFxObject me, EffectName, isDynamic, kTextureName
  if isDynamic then
    lTextureData = VOID
    repeat with li = 1 to pDynamicOverlayTextures.count
      lDinTexture = pDynamicOverlayTextures[li]
      if lDinTexture.name = kTextureName then
        lTextureData = lDinTexture
      end if
    end repeat
    if lTextureData = VOID then
      return 
    end if
  else
    lTextureData = me.GetFlyingOverlayTextureData(kTextureName)
    assert(lTextureData <> VOID)
  end if
  lIdx = pFreeIdx[1]
  pFreeIdx.deleteAt(1)
  lName = "SpriteFxOverlay" & lIdx
  lNow = gGame.GetTimeManager().GetTime()
  lObjectData = [#idx: lIdx, #name: lName, #time: 0.0, #textureRef: lTextureData.textureRef, #height: lTextureData.textureRef.height, #width: lTextureData.textureRef.width, #InitTime: lNow, #phi: random(100) / 100.0]
  lNewOverlayObject = script("SpriteFx Object").new(p3D, me.GetEffectType(EffectName), lObjectData, pOverlayManager)
  pSpriteFxObjectList.add(lNewOverlayObject)
  return lName
end

on AddEffectType me, kName, kEffectData
  pEffectTypesList.addProp(kName, kEffectData)
end

on GetEffectType me, kEffectName
  if pEffectTypesList.findPos(kEffectName) = VOID then
    return VOID
  end if
  return pEffectTypesList[kEffectName]
end

on GetSpriteFxObjectByName me, kName
  lObjectRef = VOID
  repeat with li = 1 to pSpriteFxObjectList.count
    if pSpriteFxObjectList[li].pName = kName then
      lObjectRef = pSpriteFxObjectList[li]
      exit repeat
    end if
  end repeat
  return lObjectRef
end

on CloneEffectType me, kEffectName, kNewEffectName
  lEffectData = me.GetEffectType(kEffectName)
  lNewEffectData = lEffectData.duplicate()
  me.AddEffectType(kNewEffectName, lNewEffectData)
  return me.GetEffectType(kNewEffectName)
end

on InitializeEffects me
  lEffectData = [#startscale: 0.0, #startScaleTime: 0.0, #endscale: 1.0, #endScaleTime: 0.59999999999999998, #fixedScaling: 1, #StartBlend: 0.0, #startBlendTime: 0.0, #EndBlend: 100.0, #endBlendTime: 0.5, #startRotationAngle: 0.0, #startRotationTime: 0.0, #endRotationAngle: 720.0, #endRotationTime: 0.59999999999999998, #interpBeginValue: 0.0, #interpChangeValue: 10.0, #floatamplitude: 0.0, #floatFrequency: 0.0, #flyingTime: 4000, #initPos: point(290, 140), #direction: vector(0, 0, 0), #StartDirectionTime: 0.0, #EndDirectionTime: 0.0, #speed: vector(200, 200, 0), #acceleration: 0.0]
  me.AddEffectType("standard_spinner", lEffectData)
  lEffectData = [#startscale: 0.80000000000000004, #startScaleTime: 0.0, #endscale: 2.0, #endScaleTime: 1.0, #fixedScaling: 1, #StartBlend: 100.0, #startBlendTime: 0.80000000000000004, #EndBlend: 0.0, #endBlendTime: 1.0, #startRotationAngle: 0.0, #startRotationTime: 0.0, #endRotationAngle: 0.0, #endRotationTime: 1.0, #interpBeginValue: 1.0, #interpChangeValue: 0.5, #floatamplitude: 30.0, #floatFrequency: 0.002, #flyingTime: 12000, #initPos: pScreenCenterPoint, #direction: vector(0, -1, 0), #StartDirectionTime: 0.40000000000000002, #EndDirectionTime: 0.90000000000000002, #speed: vector(5, 20, 2), #acceleration: 0.0]
  me.AddEffectType("vertical_floater", lEffectData)
  lEffectData = [#startscale: 0.80000000000000004, #startScaleTime: 0.0, #endscale: 1.0, #endScaleTime: 0.10000000000000001, #fixedScaling: 1, #StartBlend: 100.0, #startBlendTime: 0.80000000000000004, #EndBlend: 0.0, #endBlendTime: 1.0, #startRotationAngle: 0.0, #startRotationTime: 0.0, #endRotationAngle: 0.0, #endRotationTime: 0.0, #interpBeginValue: 0.0, #interpChangeValue: 0.0, #floatamplitude: 30.0, #floatFrequency: 0.0, #flyingTime: 4000, #initPos: point(280, 150), #direction: vector(0, 0, 0), #StartDirectionTime: 0.59999999999999998, #EndDirectionTime: 1.0, #speed: vector(300, 300, 0), #acceleration: 0.80000000000000004]
  me.AddEffectType("central_flash", lEffectData)
  lEffectData = [#startscale: 1.0, #startScaleTime: 0.0, #endscale: 1.0, #endScaleTime: 1.0, #fixedScaling: 1, #StartBlend: 100.0, #startBlendTime: 0.0, #EndBlend: 0.0, #endBlendTime: 1.0, #startRotationAngle: 0.0, #startRotationTime: 0.0, #endRotationAngle: 0.0, #endRotationTime: 0.0, #interpBeginValue: 0.0, #interpChangeValue: 0.0, #floatamplitude: 0.0, #floatFrequency: 0.0, #flyingTime: 2000, #initPos: pScreenCenterPoint, #direction: vector(1, 0, 0), #StartDirectionTime: 0.0, #EndDirectionTime: 1.0, #speed: vector(300, 300, 0), #acceleration: -0.0]
  me.AddEffectType("standard_directional", lEffectData)
end

on RegisterTexture me, kName, kMember
  if me.GetFlyingOverlayTextureData(kName) <> VOID then
    return #alreadydefined
  end if
  lTexture = CreateTextureFromMember(p3D, kMember)
  pOverlayTextures.add([#name: kName, #textureRef: lTexture])
end

on RegisterExistingTexture me, kName, kTextureName
  if me.GetFlyingOverlayTextureData(kName) <> VOID then
    return #alreadydefined
  end if
  lTexture = p3D.texture(kTextureName)
  pOverlayTextures.add([#name: kName, #textureRef: lTexture])
end

on GetFlyingOverlayTextureData me, kName
  repeat with li = 1 to pOverlayTextures.count
    lTexturesData = pOverlayTextures[li]
    if lTexturesData.name = kName then
      return lTexturesData
    end if
  end repeat
  return VOID
end

on CreateOverlays me
  lTex = p3D.texture("DefaultTexture")
  repeat with li = 1 to pSpriteFxObjectCount
    lName = "SpriteFxOverlay" & li
    pOverlayManager.add(lName, lTex, point(0, 0), 0.0, 0)
    pFreeIdx.append(li)
  end repeat
end

on SetDynamicOverlayTexture me, kName, kTexture
  repeat with li = 1 to pDynamicOverlayTextures.count
    lTexturesData = pDynamicOverlayTextures[li]
    if lTexturesData.name = kName then
      lTexturesData.textureRef = kTexture
      return 
    end if
  end repeat
  pDynamicOverlayTextures.add([#name: kName, #textureRef: kTexture])
end

on RemoveAllOverlays me
  repeat with li = 1 to pSpriteFxObjectList.count
    pSpriteFxObjectList[li].ForceRemoval()
  end repeat
end

on update me, kTime
  lToDelete = []
  lDynToDelete = []
  repeat with li = 1 to pSpriteFxObjectList.count
    lRemoveOverlay = pSpriteFxObjectList[li].update(kTime)
    if lRemoveOverlay then
      lToDelete.append(li)
      pFreeIdx.append(integer(pSpriteFxObjectList[li].pObjectData.idx))
    end if
  end repeat
  repeat with li = lToDelete.count down to 1
    pSpriteFxObjectList.deleteAt(lToDelete[li])
  end repeat
end
