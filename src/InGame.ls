property ancestor, pMember, pOverlayManager, pOverlayButtons, pPopupTypes, pPopupHolders, pPausePopup, pExitPopup, pHelpPopup, pPausePopupShown, pQuitPopupShown, pHelpActive, pOverlayBitmapTime, pFPSCounter, pFlashSprite, pFlashTextRendererMovie
global gGame

on new me, kFSM, kInitState
  me.ancestor = script("FSM object").new(kFSM, kInitState)
  pOverlayButtons = VOID
  pPopupTypes = VOID
  pPopupHolders = VOID
  pPausePopup = VOID
  pExitPopup = VOID
  pHelpPopup = VOID
  pHelpActive = 0
  pFPSCounter = VOID
  pFlashSprite = VOID
  pFlashTextRendererMovie = VOID
  return me
end

on Initialize me, kMember, kOverlayManager
  pMember = kMember
  pOverlayManager = kOverlayManager
  pOverlayButtons = [:]
  pPopupTypes = [:]
  pPopupHolders = [:]
  pPausePopup = VOID
  pExitPopup = VOID
  pPausePopupShown = 0
  pQuitPopupShown = 0
  pFPSCounter = VOID
end

on InitializeFlashTextRenderer me, kSprite, kFlashTextRendererMovie
  pFlashSprite = kSprite
  pFlashTextRendererMovie = kFlashTextRendererMovie
end

on Get3D me
  return pMember
end

on GetOverlayManager me
  return pOverlayManager
end

on GetOverlayBitmapTime me
  return pOverlayBitmapTime
end

on GetPopupHolders me
  return pPopupHolders
end

on GetPausePopup me
  return pPausePopup
end

on GetHelpPopup me
  return pHelpPopup
end

on GetPausePopupShown me
  return pPausePopupShown
end

on GetQuitPopupShown me
  return pQuitPopupShown
end

on GetExitPopup me
  return pExitPopup
end

on GetPopupHolder me, kId
  if pPopupHolders.findPos(kId) = VOID then
    return VOID
  end if
  return pPopupHolders[kId]
end

on GetPopupType me, kId
  if pPopupTypes.findPos(kId) = VOID then
    return VOID
  end if
  return pPopupTypes[kId]
end

on GetOverlayButton me, kId
  if pOverlayButtons.findPos(kId) = VOID then
    return VOID
  end if
  return pOverlayButtons[kId]
end

on GetHelpActive me
  return pHelpActive
end

on GetOverlayButtons me
  return pOverlayButtons
end

on GetFPSCounter me
  return pFPSCounter
end

on SetPausePopup me, kPopup
  pPausePopup = kPopup
end

on SetHelpPopup me, kPopup
  pHelpPopup = kPopup
end

on SetExitPopup me, kPopup
  pExitPopup = kPopup
end

on SetPausePopupShown me, fShown
  pPausePopupShown = fShown
end

on SetQuitPopupShown me, fShown
  pQuitPopupShown = fShown
end

on SetHelpActive me, fHelpActive
  pHelpActive = fHelpActive
end

on SetOverlayBitmapTime me, kOverlayBitmapTime
  pOverlayBitmapTime = kOverlayBitmapTime
end

on SetFPSCounter me, kFPSCounter
  pFPSCounter = kFPSCounter
end

on AddGfxItem me, kOverlayName, kTexture, kInitialPosition, kInitialRotation
  pOverlayManager.add(kOverlayName, kTexture, kInitialPosition, VOID, VOID, kInitialRotation)
  return pOverlayManager[pOverlayManager.count]
end

on CreateGfxItem me, kImageName, kTextureName, kOverlayName, kInitialPosition
  lImage = member(kImageName).image
  lTexture = pMember.newTexture(kTextureName, #fromImageObject, lImage)
  SetupIngameTexture(lTexture)
  pOverlayManager.add(kOverlayName, lTexture, kInitialPosition)
  return [#texture: lTexture, #overlay: pOverlayManager[pOverlayManager.count]]
end

on CreateTexture me, kImageName, kTextureName
  lImage = member(kImageName).image
  lTexture = pMember.newTexture(kTextureName, #fromImageObject, lImage)
  SetupIngameTexture(lTexture)
  return lTexture
end

on AddButton me, kOverlayName, kCallListener, kClickFunction, kUpImage, kDownImage, kGhostImage, kPositionPoint, kWidth, kHeight
  lButton = script("overlay button").new(pMember, pOverlayManager, kOverlayName, kCallListener, kClickFunction, kUpImage, kDownImage, kGhostImage, kPositionPoint, kWidth, kHeight)
  pOverlayButtons.addProp(kOverlayName, lButton)
  return lButton
end

on CreateTextItem me, kOverlayName, kTextFieldMember, kTextureName, kPosition, kWidth, kHeight, kText, kFontSize, kTextColor
  lTexture = utiCreateTextureFromText(pMember, kTextFieldMember, kTextureName, kWidth, kHeight, string(kText), kFontSize, kTextColor)
  pOverlayManager.add(kOverlayName, lTexture, kPosition)
end

on CreateFlashTextItem me, kOverlayName, kFlashMovieclipName, kTextureName, kPosition, kWidth, kHeight, kText, kFontSize, kTextColor, kIsFlashTextVarName
  lTexture = utiCreateTextureFromFlashText(pMember, pFlashSprite, pFlashTextRendererMovie, kFlashMovieclipName, kTextureName, kWidth, kHeight, string(kText), kFontSize, kTextColor, kIsFlashTextVarName)
  pOverlayManager.add(kOverlayName, lTexture, kPosition)
end

on UpdateTextItem me, kTextFieldMember, kTextureName, kWidth, kHeight, kText, kFontSize, kTextColor, kBackgroundImg
  return utiCreateTextureFromText(pMember, kTextFieldMember, kTextureName, kWidth, kHeight, string(kText), kFontSize, kTextColor, kBackgroundImg)
end

on UpdateFlashTextItem me, kFlashMovieclipName, kTextureName, kWidth, kHeight, kText, kFontSize, kTextColor, kIsFlashTextVarName
  return utiCreateTextureFromFlashText(pMember, pFlashSprite, pFlashTextRendererMovie, kFlashMovieclipName, kTextureName, kWidth, kHeight, string(kText), kFontSize, kTextColor, kIsFlashTextVarName)
end

on CreateTextureFromFlashText me, pMember, kFlashMovieclipName, kTextureName, kWidth, kHeight, kText, kFontSize, kTextColor, kIsFlashTextVarName
  return utiCreateTextureFromFlashText(pMember, pFlashSprite, pFlashTextRendererMovie, kFlashMovieclipName, kTextureName, kWidth, kHeight, string(kText), kFontSize, kTextColor, kIsFlashTextVarName)
end

on AddPopupHolder me, kId, kPopupHolder
  pPopupHolders.addProp(kId, kPopupHolder)
end

on AddPopupType me, kId, kPopupType, kRefPos
  pPopupTypes.addProp(kId, [#items: kPopupType, #refPos: kRefPos])
end

on SetPlayPauseButtons me, kPauseButtonState
  lPauseButton = me.GetOverlayButton("pause_button")
  if not voidp(lPauseButton) then
    lPauseButton.SetVisibility(kPauseButtonState)
  end if
  lPlayButton = me.GetOverlayButton("play_button")
  if not voidp(lPlayButton) then
    lPlayButton.SetVisibility(not kPauseButtonState)
  end if
end

on SetSoundOnOffButtons me, kSoundState
  lSoundOnButton = me.GetOverlayButton("soundon_button")
  if not voidp(lSoundOnButton) then
    lSoundOnButton.SetVisibility(kSoundState)
  end if
  lSoundOffButton = me.GetOverlayButton("soundoff_button")
  if not voidp(lSoundOffButton) then
    lSoundOffButton.SetVisibility(not kSoundState)
  end if
end

on SetMusicOnOffButtons me, kMusicState
  lMusicOnButton = me.GetOverlayButton("musicon_button")
  if not voidp(lMusicOnButton) then
    lMusicOnButton.SetVisibility(kMusicState)
  end if
  lMusicOffButton = me.GetOverlayButton("musicoff_button")
  if not voidp(lMusicOffButton) then
    lMusicOffButton.SetVisibility(not kMusicState)
  end if
end

on OnPauseClick me
  if not gGame.GetTimeManager().IsInPauseTransition() then
    gGame.pause()
  end if
end

on OnPlayClick me
  if me.GetQuitPopupShown() then
    gGame.ResumeFromQuitGame()
    return 
  end if
  if not gGame.GetTimeManager().IsInPauseTransition() then
    gGame.UnPause()
  end if
end

on GamePaused me
  me.SetPlayPauseButtons(0)
end

on GameResumed me
  me.SetPlayPauseButtons(1)
end

on OnSoundOnClick me
  me.SetSoundOnOffButtons(0)
  lSoundManager = gGame.GetSoundManager()
  lSoundManager.SetAudioState(0)
  lSoundManager.PauseAllSoundChannels(1)
end

on OnSoundOffClick me
  me.SetSoundOnOffButtons(1)
  lSoundManager = gGame.GetSoundManager()
  lSoundManager.SetAudioState(1)
  lSoundManager.ResumeAllSoundChannels(1)
end

on OnMusicOnClick me
  me.SetMusicOnOffButtons(0)
  lSoundManager = gGame.GetSoundManager()
  lSoundManager.SetMusicState(0)
  lSoundManager.PauseBackgroundMusic()
end

on OnMusicOffClick me
  me.SetMusicOnOffButtons(1)
  lSoundManager = gGame.GetSoundManager()
  lSoundManager.SetMusicState(1)
  lSoundManager.ResumeBackgroundMusic()
end

on OnExitClick me
  if me.GetQuitPopupShown() then
    return 
  end if
  if not gGame.IsPaused() then
    if not gGame.GetTimeManager().IsInPauseTransition() then
      gGame.RequestQuitGame()
      me.SetQuitPopupShown(1)
    end if
  else
    gGame.QuitRequested()
    me.SetQuitPopupShown(1)
  end if
end

on OnHelpClick me
  if me.GetQuitPopupShown() then
    return 
  end if
  if gGame.GetTimeManager().IsInPauseTransition() then
    return 
  end if
  if not gGame.IsPaused() then
    me.SetHelpActive(1)
    gGame.pause()
  end if
end

on OnExitYesClick me
  gGame.GetSoundManager().StopAllSoundChannels()
  gGame.GameResumed()
end

on OnExitNoClick me
  gGame.ResumeFromQuitGame()
end

on OnHelpBackClick me
end

on CheckPopupButtons me
  if voidp(pOverlayButtons) then
    return 
  end if
  repeat with li = 1 to pOverlayButtons.count
    lOverlayButton = pOverlayButtons[li]
    lOverlayButton.update()
  end repeat
end

on update me, kTime
  me.ancestor.update(kTime)
  repeat with li = 1 to pOverlayButtons.count
    lOverlayButton = pOverlayButtons[li]
    lOverlayButton.update()
  end repeat
  repeat with li = 1 to pPopupHolders.count
    pPopupHolders[li].update()
  end repeat
  if not voidp(pFPSCounter) then
    pFPSCounter.update(kTime)
  end if
end
