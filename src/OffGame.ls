property pFlashFrame, pFlashStartFrame, pFlashEndFrame, pFlashSprite, pFlashLoadingFrame, pCustumBackground

on new me, kFrame, kStartFrame, kEndFrame, kSprite, kLoadingFrame
  pFlashFrame = kFrame
  pFlashStartFrame = kStartFrame
  pFlashEndFrame = kEndFrame
  pFlashSprite = kSprite
  pFlashLoadingFrame = kLoadingFrame
  pCustumBackground = VOID
  return me
end

on PlaceBackground me, kBackgroundColor
  if not voidp(pCustumBackground) then
    me.RemoveBackground()
  end if
  lRoot = me.GetSprite()
  lRect = me.GetSpriteObject().rect
  lColor = (kBackgroundColor.red * 65536) + (kBackgroundColor.green * 256) + kBackgroundColor.blue
  pCustumBackground = lRoot.createEmptyMovieClip("mc_bg", lRoot.getNextHighestDepth())
  pCustumBackground.beginFill(lColor)
  pCustumBackground.moveTo(lRect.left, lRect.top)
  pCustumBackground.lineTo(lRect.right, lRect.top)
  pCustumBackground.lineTo(lRect.right, lRect.bottom)
  pCustumBackground.lineTo(lRect.left, lRect.bottom)
  pCustumBackground.lineTo(lRect.left, lRect.top)
  pCustumBackground.endFill()
  pCustumBackground.swapDepths(-16384)
end

on RemoveBackground me
  assert(not voidp(pCustumBackground), "Invalid RemoveBackground")
  lRoot = me.GetSprite()
  lMCName = pCustumBackground._name
  pCustumBackground = VOID
  lRoot.removeMovieClip(lMCName)
end

on GetFlashFrame me
  return pFlashFrame
end

on GetSprite me
  assert((the frame >= pFlashStartFrame) and (the frame <= pFlashEndFrame), "Coudn't get flash sprite: wrong frame")
  lSprite = sprite(pFlashSprite)
  return getVariable(lSprite, "_level0", 0)
end

on GetSpriteObject me
  assert((the frame >= pFlashStartFrame) and (the frame <= pFlashEndFrame), "Coudn't get flash sprite: wrong frame")
  lSprite = sprite(pFlashSprite)
  return lSprite
end

on SetLoadPercent me, kPercent
  getVariable(sprite(pFlashSprite), "_level0", 0).mcLoading.gotoAndStop(kPercent)
end

on SetInitializing me
  getVariable(sprite(pFlashSprite), "_level0", 0).mcLoading.gotoAndStop(101)
end

on OnStart me, kSprite, kExitCode
  assert(0, "OnStart")
end

on GoToLoadScreen me
  getVariable(sprite(pFlashSprite), "_level0", 0).gotoAndStop(pFlashLoadingFrame)
end

on start me, kExitCode
  lSprite = me.GetSprite()
  me.OnStart(lSprite, kExitCode)
  lSprite.StartOffGame(kExitCode)
end

on InitPage me, kExitCode
  lSprite = me.GetSprite()
  lSprite.StartOffGame(kExitCode)
end
