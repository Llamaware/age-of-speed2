property pMember, pOverlayManager, pPosition, pwidth, pheight, pOverlayName, pUpTexture, pDownTexture, pGhostTexture, pVisible, pEnabled, pState, pCallListener, pClickFunction, pMouseDownSwitch, pClickBehavior
global gGame

on new me, kMember, kOverlayManager, kOverlayName, kCallListener, kClickFunction, kUpImage, kDownImage, kGhostImage, kPositionPoint, kWidth, kHeight
  pMember = kMember
  pOverlayManager = kOverlayManager
  pPosition = kPositionPoint
  pwidth = kWidth
  pheight = kHeight
  pOverlayName = kOverlayName
  pCallListener = kCallListener
  pClickFunction = kClickFunction
  pMouseDownSwitch = 0
  pUpTexture = pMember.newTexture(kUpImage, #fromImageObject, member(kUpImage).image)
  SetupIngameTexture(pUpTexture)
  pDownTexture = pMember.newTexture(kDownImage, #fromImageObject, member(kDownImage).image)
  SetupIngameTexture(pDownTexture)
  if not voidp(kGhostImage) then
    pGhostTexture = pMember.newTexture(kGhostImage, #fromImageObject, member(kGhostImage).image)
    SetupIngameTexture(pGhostTexture)
  else
    pGhostTexture = VOID
  end if
  pState = #up
  pOverlayManager.add(pOverlayName, pUpTexture, pPosition)
  pVisible = 1
  pEnabled = 1
  pClickBehavior = 1
  return me
end

on Disable me
  assert(not voidp(pGhostTexture), "Ghost texture doesn't exist")
  pOverlayManager.Modify(pOverlayName, pGhostTexture, pPosition)
  pEnabled = 0
end

on IsEnabled me
  return pEnabled
end

on Enable me
  if pState = #up then
    pOverlayManager.Modify(pOverlayName, pUpTexture, pPosition)
  else
    if pState = #down then
      pOverlayManager.Modify(pOverlayName, pDownTexture, pPosition)
    end if
  end if
  pEnabled = 1
  pMouseDownSwitch = 1
end

on SetVisibility me, kState
  if pVisible <> kState then
    if gGame.GetUseNewOverlayManager() then
      pOverlayManager.player.SetOverlayVisible(pOverlayName, kState)
    else
      lOverlayIndex = pOverlayManager.GetIndex(pOverlayName)
      if kState = 1 then
        pMouseDownSwitch = 1
        pOverlayManager.pCameraRef.overlay[lOverlayIndex].scale = 1.0
      else
        pOverlayManager.pCameraRef.overlay[lOverlayIndex].scale = 0.0
      end if
    end if
  end if
  pVisible = kState
end

on update me
  if not pEnabled or not pVisible then
    return 
  end if
  lMouseX = the mouseH
  lMouseY = the mouseV
  if (lMouseX >= pPosition.locH) and (lMouseX <= (pPosition.locH + pwidth)) and (lMouseY >= pPosition.locV) and (lMouseY <= (pPosition.locV + pheight)) then
    if (pClickBehavior and _mouse.mouseDown and not pMouseDownSwitch) or (not pClickBehavior and _mouse.mouseDown) then
      call(pClickFunction, pCallListener)
    end if
    if pState <> #down then
      pState = #down
      pOverlayManager.Modify(pOverlayName, pDownTexture, pPosition)
    end if
  else
    if pState <> #up then
      pState = #up
      pOverlayManager.Modify(pOverlayName, pUpTexture, pPosition)
    end if
  end if
  pMouseDownSwitch = _mouse.mouseDown
end

on SetClickBehavior me, kFlag
  pClickBehavior = kFlag
end

on GetClickBehavior me
  return pClickBehavior
end

on setPosition me, kPos
  pPosition = kPos
end

on getPosition me
  return pPosition
end

on GetOverlayName me
  return pOverlayName
end
