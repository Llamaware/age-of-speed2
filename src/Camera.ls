property ancestor, pCameraNode, pBeforePrerenderFOV, pIntTransformStart, pIntTransformEnd, pIntStartTime, pIntEndTime, pFadeOverlay, pFadeType, pFadeStartTime, pFadeEndTime
global gGame

on new me, kFSM, kInitState
  me.ancestor = script("FSM object").new(kFSM, kInitState)
  pFadeOverlay = "fader"
  pCameraNode = VOID
  pBeforePrerenderFOV = VOID
  return me
end

on GetCameraNode me
  return pCameraNode
end

on SetCameraNode me, kCameraNode
  pCameraNode = kCameraNode
end

on SetupInterpolation me, kTransformStart, kTransformEnd, kTime, kDuration
  pIntTransformStart = kTransformStart
  pIntTransformEnd = kTransformEnd
  pIntStartTime = kTime
  pIntEndTime = kTime + kDuration
end

on UpdateInterpolation me, kTime
  lPercent = (kTime - pIntStartTime) * 100.0 / (pIntEndTime - pIntStartTime)
  lPercent = Clamp(lPercent, 0.0, 100.0)
  lTransform = pIntTransformStart.duplicate()
  lTransform.interpolateTo(pIntTransformEnd, lPercent)
  me.pCameraNode.transform = lTransform
  return lPercent = 100.0
end

on InitFader me
  lImage = member("overlay").image
  lTexture = gGame.Get3D().newTexture("fader", #fromImageObject, lImage)
  lTexture.quality = #low
  gGame.GetOverlayManager().add("fader", lTexture, point(-100, -100), 64, 100.0)
end

on SetupFade me, kType, kTime, kDuration
  pFadeType = kType
  pFadeStartTime = kTime
  pFadeEndTime = kTime + kDuration
end

on UpdateFade me, kTime
  lFadeTime = pFadeEndTime - pFadeStartTime
  if lFadeTime <> 0 then
    lBlend = (kTime - pFadeStartTime) * 100.0 / lFadeTime
    lBlend = Clamp(lBlend, 0.0, 100.0)
  else
    lBlend = 100.0
  end if
  if pFadeType = #fadeIn then
    lBlend = 100.0 - lBlend
  end if
  gGame.GetOverlayManager().Modify(pFadeOverlay, VOID, VOID, VOID, lBlend)
  if pFadeType = #fadeIn then
    return lBlend = 0.0
  else
    return lBlend = 100.0
  end if
end

on PrerenderEnter me, kCamera, kTime
  put "Camera: PrerenderEnter"
  lImage = member("overlay").image
  lTexture = gGame.Get3D().newTexture("black_screen", #fromImageObject, lImage)
  gGame.GetOverlayManager().add("black_screen", lTexture, point(0, 0), 64)
  lCamNode = kCamera.GetCameraNode()
  pBeforePrerenderFOV = lCamNode.fieldOfView
  lCamNode.projection = #perspective
  lCamNode.fieldOfView = 90.0
  lCamNode.transform.position = vector(0.0, 0.0, 200000.0)
  lCamNode.pointAt(vector(0.0, 0.0, 0.0), vector(0.0, 1.0, 0.0))
  lCamNode.hither = 40.0
  lCamNode.yon = 220000.0
end

on PrerenderExec me, kCamera, kTime
  put "PrerenderExec: " & kTime
end

on PrerenderExit me, kCamera, kTime
  lCamNode = kCamera.GetCameraNode()
  lCamNode.fieldOfView = pBeforePrerenderFOV
  gGame.Get3D().deleteTexture("black_screen")
  gGame.GetOverlayManager().Remove("black_screen")
  put "Camera: PrerenderExit"
end
