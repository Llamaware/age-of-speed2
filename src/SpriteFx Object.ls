property p3D, pObjectData, pOverlayManager, pwidth, pHeigth, pObjectTime, pObjectTextureRef, pStartScale, pStartScaleTime, pEndScale, pEndScaleTime, pFixedScaling, pstartblend, pStartBlendTime, pendblend, pEndBlendTime, pStartRotationTime, pStartRotationAngle, pEndRotationAngle, pEndRotationTime, pInterpBeginValue, pInterpChangeValue, pFlyingTime, pInitPos, pDirection, pStartDirectionTime, pEndDirectionTime, pSpeed, pAcceleration, pFloatAmplitude, pFloatFrequency, pName, pFinishedMoving, pForceRemoval
global gGame

on new me, k3D, kEffectData, kObjectData, kOverlayManager
  p3D = k3D
  pOverlayManager = kOverlayManager
  pObjectData = kObjectData
  pwidth = kObjectData.width
  pHeigth = kObjectData.height
  pObjectTime = kObjectData.time
  pObjectTextureRef = kObjectData.textureRef
  pStartScale = kEffectData.startscale
  pStartScaleTime = kEffectData.startScaleTime
  pEndScale = kEffectData.endscale
  pEndScaleTime = kEffectData.endScaleTime
  pFixedScaling = kEffectData.fixedScaling
  pstartblend = kEffectData.StartBlend
  pStartBlendTime = kEffectData.startBlendTime
  pendblend = kEffectData.EndBlend
  pEndBlendTime = kEffectData.endBlendTime
  pStartRotationTime = kEffectData.startRotationTime
  pStartRotationAngle = kEffectData.startRotationAngle
  pEndRotationAngle = kEffectData.endRotationAngle
  pEndRotationTime = kEffectData.endRotationTime
  pInterpBeginValue = kEffectData.interpBeginValue
  pInterpChangeValue = kEffectData.interpChangeValue
  pFlyingTime = kEffectData.flyingTime
  pInitPos = kEffectData.initPos
  pDirection = kEffectData.direction
  pStartDirectionTime = kEffectData.StartDirectionTime
  pEndDirectionTime = kEffectData.EndDirectionTime
  pDirection.normalize()
  pSpeed = kEffectData.speed
  pAcceleration = kEffectData.acceleration
  pFloatAmplitude = kEffectData.floatamplitude
  pFloatFrequency = kEffectData.floatFrequency
  pName = kObjectData.name
  pFinishedMoving = 0
  return me
end

on ForceRemoval me
  pForceRemoval = 1
end

on update me, kTime
  lDt = gGame.GetTimeManager().GetDeltaTime() * 0.001
  pObjectTime = pObjectTime + lDt
  lOverlayTime = pObjectTime
  lNormTime = float(lOverlayTime / (pFlyingTime * 0.001))
  lScalingCompensation = point(0.0, 0.0)
  lNewScale = pStartScale
  if (pEndScale - pStartScale) <> 0.0 then
    if lNormTime < pStartScaleTime then
      lNewScale = pStartScale
    else
      if (lNormTime >= pStartScaleTime) and (lNormTime <= pEndScaleTime) then
        lScaleSpeed = 1 / (pEndScaleTime - pStartScaleTime)
        lNewScale = pStartScale + ((pEndScale - pStartScale) * (lNormTime - pStartScaleTime) * lScaleSpeed)
      else
        lNewScale = pEndScale
      end if
    end if
    if pFixedScaling then
      lScalingCompensation = -point(integer(pwidth * 0.5 * lNewScale), integer(pHeigth * 0.5 * lNewScale))
    end if
  end if
  lNewBlend = pstartblend
  if (pendblend - pstartblend) <> 0.0 then
    if lNormTime < pStartBlendTime then
    else
      if (lNormTime >= pStartBlendTime) and (lNormTime <= pEndBlendTime) then
        lBlendSpeed = 1.0 / (pEndBlendTime - pStartBlendTime)
        lNewBlend = pstartblend + ((pendblend - pstartblend) * (lNormTime - pStartBlendTime) * lBlendSpeed)
      else
        lNewBlend = pendblend
      end if
    end if
  end if
  lRotationAngle = pStartRotationAngle
  if (pEndRotationAngle - pStartRotationAngle) <> 0.0 then
    if lNormTime < pStartRotationTime then
      lRotationAngle = pStartRotationAngle
    else
      if (lNormTime >= pStartRotationTime) and (lNormTime <= pEndRotationTime) then
        lRotationSpeed = InterpInQuad(lNormTime - pStartRotationTime, pInterpBeginValue, pInterpChangeValue, pEndRotationTime)
        lRotationAngle = pStartRotationAngle + ((pEndRotationAngle - pStartRotationAngle) * (lNormTime - pStartRotationTime) * lRotationSpeed)
        if lRotationAngle >= pEndRotationAngle then
          lRotationAngle = pEndRotationAngle
        end if
      else
        lRotationAngle = pEndRotationAngle
      end if
    end if
  end if
  if not pFinishedMoving then
    pSpeed = pSpeed + (pAcceleration * lDt)
  end if
  lDeltaDirection = point(0, 0)
  lFinalPos = point(0, 0)
  if lNormTime < pStartDirectionTime then
  else
    if (lNormTime >= pStartDirectionTime) and (lNormTime <= pEndDirectionTime) then
      lDeltaDirection.locH = pDirection.x * pSpeed.x * (lNormTime - pStartDirectionTime)
      lDeltaDirection.locV = pDirection.y * pSpeed.y * (lNormTime - pStartDirectionTime)
    else
      lDeltaDirection.locH = pDirection.x * pSpeed.x * (pEndDirectionTime - pStartDirectionTime)
      lDeltaDirection.locV = pDirection.y * pSpeed.y * (pEndDirectionTime - pStartDirectionTime)
      pFinishedMoving = 1
    end if
  end if
  lFloatPos = 0.0
  if pFloatAmplitude <> 0 then
    lFloatPos = point(cos(kTime * pFloatFrequency) * pFloatAmplitude, 0.0)
  end if
  lFinalPos = pInitPos + lDeltaDirection + lFloatPos + lScalingCompensation
  pOverlayManager.Modify(pName, pObjectTextureRef, lFinalPos, lNewScale, lNewBlend, lRotationAngle)
  lRemoveOverlay = 0
  if (lNormTime > 1.0) or not voidp(pForceRemoval) then
    lRemoveOverlay = 1
    lTex = p3D.texture("DefaultTexture")
    pOverlayManager.Modify(pName, lTex, point(0, 0), 0, 0)
  end if
  return lRemoveOverlay
end
