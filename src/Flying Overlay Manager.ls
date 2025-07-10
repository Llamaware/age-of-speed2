property p3D, pcamera, pOverlayManager, pScreenCenterPoint, pOverlayList, pOverlayTextures, pDynamicOverlayTextures, pFreeIdx, pLastTime
global gGame

on new me, k3D, kCamera, kOverlayManager
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
  pLastTime = -1
  me.CreateOverlays()
  return me
end

on RegisterTexture me, kName, kMember
  if me.GetFlyingOverlayTextureData(kName) <> VOID then
    return #alreadydefined
  end if
  lTexture = CreateTextureFromMember(p3D, kMember)
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
  repeat with li = 0 to 19
    lName = "FlyingOverlay" & li
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

on addDynamicOverlay me, kTextureName, kOverlayData
  if kOverlayData.findPos(#isDynamic) = VOID then
    kOverlayData.addProp(#isDynamic, 1)
  end if
  me.AddFlyingOverlay(kTextureName, kOverlayData)
end

on AddFlyingOverlay me, kTextureName, kOverlayData
  if pFreeIdx.count = 0 then
    return 
  end if
  if kOverlayData.findPos(#isDynamic) = VOID then
    kOverlayData.addProp(#isDynamic, 0)
  end if
  if kOverlayData.findPos(#startscale) = VOID then
    kOverlayData.addProp(#startscale, 10)
  end if
  if kOverlayData.findPos(#endscale) = VOID then
    kOverlayData.addProp(#endscale, 100)
  end if
  if kOverlayData.findPos(#flyingTime) = VOID then
    kOverlayData.addProp(#flyingTime, 3000)
  end if
  if kOverlayData.findPos(#StartBlend) = VOID then
    kOverlayData.addProp(#StartBlend, 100.0)
  end if
  if kOverlayData.findPos(#EndBlend) = VOID then
    kOverlayData.addProp(#EndBlend, 0.0)
  end if
  if kOverlayData.findPos(#floatamplitude) = VOID then
    kOverlayData.addProp(#floatamplitude, 30)
  end if
  if kOverlayData.findPos(#effectType) = VOID then
    kOverlayData.addProp(#effectType, #standard)
  end if
  if kOverlayData.findPos(#fixedScaling) = VOID then
    kOverlayData.addProp(#fixedScaling, 0)
  end if
  if (kOverlayData.findPos(#pos3d) = VOID) and (kOverlayData.findPos(#pos2d) = VOID) then
    kOverlayData.addProp(#pos2d, point(pScreenCenterPoint.locH, pScreenCenterPoint.locV))
  end if
  lPos = point(0, 0)
  if kOverlayData.findPos(#pos2d) <> VOID then
    lPos = kOverlayData.pos2d
  else
    lPos3d = kOverlayData.pos3d
    lPos = pcamera.worldSpaceToSpriteSpace(lPos3d)
    if voidp(lPos) then
      lPos = point(pScreenCenterPoint.locH, pScreenCenterPoint.locV)
    end if
  end if
  if kOverlayData.isDynamic then
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
  lPos.locH = lPos.locH - integer(lTextureData.textureRef.width * 0.5)
  lPos.locV = lPos.locV - integer(lTextureData.textureRef.height * 0.5)
  lNow = gGame.GetTimeManager().GetTime()
  lSpecialEffectData = VOID
  case kOverlayData.effectType of
    #directional:
      if kOverlayData.findPos(#directionalData) = VOID then
        put "ERROR: directional data not defined"
      else
        lDirectionVector = kOverlayData.directionalData[1]
        lSpeed = kOverlayData.directionalData[2]
        lDirectionVector.normalize()
        lDelta = point(lDirectionVector.x, lDirectionVector.y) * lSpeed
        lSpecialEffectData = lDelta
      end if
    #rotational:
      if kOverlayData.findPos(#RotationalData) = VOID then
        put "ERROR: rotational data not defined"
      else
        lSpecialEffectData = kOverlayData.RotationalData
      end if
  end case
  lName = "FlyingOverlay" & lIdx
  pOverlayList.append([#idx: lIdx, #name: lName, #initPos: lPos, #floatamplitude: kOverlayData.floatamplitude, #time: 0.0, #startscale: kOverlayData.startscale, #endscale: kOverlayData.endscale, #fixedScaling: kOverlayData.fixedScaling, #StartBlend: kOverlayData.StartBlend, #EndBlend: kOverlayData.EndBlend, #effectType: kOverlayData.effectType, #specialEffectData: lSpecialEffectData, #textureRef: lTextureData.textureRef, #verticalDistance: kOverlayData.verticalDistance, #flyingTime: kOverlayData.flyingTime, #height: lTextureData.textureRef.height, #width: lTextureData.textureRef.width, #InitTime: lNow, #phi: random(100) / 100.0])
end

on update me, kTime
  lToDelete = []
  lDynToDelete = []
  lTex = p3D.texture("DefaultTexture")
  repeat with li = 1 to pOverlayList.count
    lOverlay = pOverlayList[li]
    lStartScale = lOverlay.startscale
    lEndScale = lOverlay.endscale
    lStartBlend = lOverlay.StartBlend
    lEndBlend = lOverlay.EndBlend
    lDt = gGame.GetTimeManager().GetDeltaTime() * 0.001
    lDt = Clamp(lDt, 0.0, 0.06660000000000001)
    lOverlay.time = lOverlay.time + lDt
    lNormTime = float(lOverlay.time / (lOverlay.flyingTime * 0.001))
    lName = lOverlay.name
    lNewPos = lOverlay.initPos - point(0, float(lOverlay.verticalDistance) * lNormTime)
    lNewScale = lStartScale + ((lEndScale - lStartScale) * lNormTime)
    lNewBlend = lStartBlend + ((lEndBlend - lStartBlend) * lNormTime)
    lFloatPos = 0
    if lOverlay.floatamplitude <> 0 then
      lFloatPos = point(cos((kTime * 0.001) + lOverlay.phi) * lOverlay.floatamplitude, 0.0)
    end if
    lRotation = 0.0
    lScalingCompensation = point(0.0, 0.0)
    if lOverlay.fixedScaling then
      lScalingCompensation = -point(integer(lOverlay.width * 0.5 * lNewScale), integer(lOverlay.height * 0.5 * lNewScale))
    end if
    case lOverlay.effectType of
      #directional:
        lDelta = lOverlay.specialEffectData
        lNewPos = lNewPos + (lDelta * lOverlay.time)
      #rotational:
        if (lOverlay.time * 1000) < lOverlay.specialEffectData[2] then
          lRotation = lOverlay.specialEffectData[1] * InterpInQuad(lOverlay.time * 1000, 0, 10, 2500)
        end if
    end case
    lFinalPos = lNewPos + lFloatPos + lScalingCompensation
    pOverlayManager.Modify(lName, pOverlayList[li].textureRef, lFinalPos, lNewScale, lNewBlend, lRotation)
    lRemoveOverlay = 0
    if lNormTime > 1.0 then
      lRemoveOverlay = 1
    end if
    if lRemoveOverlay then
      lToDelete.append(li)
      pOverlayManager.Modify(lName, lTex, point(0, 0), 0, 0)
      pFreeIdx.append(integer(lOverlay.idx))
    end if
  end repeat
  repeat with li = lToDelete.count down to 1
    pOverlayList.deleteAt(lToDelete[li])
  end repeat
end
