property ancestor, pSoundButtonEnabledBeforeExit, pHudValues, pCurrentLap, pPlayerRacePosition, pExitType, pPlayersPosition, pLapNum, pPlayerNames, pOverlayBitmapScore, pOverlayBitmapBestTime, pOverlayBitmapKmh, pLastLapOverlayShowed, pUpdateKmh
global gGame

on new me
  lMyFSM = script("FSM").new()
  lMyFSM.AddState(#VoidState, #VoidEnter, #VoidExec, #VoidExit, script("Void state"))
  lMyFSM.AddState(#GameStart, #GameStartEnter, #GameStartExec, #GameStartExit, me)
  me.ancestor = script("InGame").new(lMyFSM, #VoidState)
  pOverlayButtons = VOID
  pHudValues = [:]
  pExitType = #QuitRace
  pUpdateKmh = 1
  return me
end

on Initialize me, kMember, kOverlayManager
  me.ancestor.Initialize(kMember, kOverlayManager)
  pOverlayButtons = []
  me.InitializePopups()
  me.InitializeHud()
  me.InitializeButtons()
  me.InitializeSpriteFx()
  pCurrentLap = 1
  pLastLapOverlayShowed = 0
end

on InitializeHud me
  me.SetHudValue(#TimeTimer, 0.0)
  me.SetHudValue(#score, 0)
  me.SetHudValue(#energy, 0.0)
  me.SetHudValue(#IsTimeBlinking, 0)
  me.SetHudValue(#PlayerScore, 0)
  me.CreateGfxItem("logo1", "logo1", "logo1", point(0, 4))
  me.CreateGfxItem("logo2", "logo2", "logo2", point(128, 4))
  me.CreateGfxItem("miniclip1", "miniclip1", "miniclip1", point(12, 415))
  me.CreateGfxItem("miniclip2", "miniclip2", "miniclip2", point(140, 415))
  me.CreateGfxItem("panel_1", "panel_1", "panel_1", point(555, 0))
  me.CreateGfxItem("panel_2", "panel_2", "panel_2", point(526, 379))
  me.CreateGfxItem("lap", "lap", "lap", point(528, 63))
  me.CreateGfxItem("km_h", "km_h", "km_h", point(129, 397))
  me.CreateGfxItem("bolt", "bolt", "bolt", point(462, 377))
  me.CreateGfxItem("shield", "shield", "shield", point(506, 377))
  me.CreateGfxItem("missile", "missile", "missile", point(506, 377))
  gGame.GetOverlayManager().Modify("bolt", VOID, VOID, VOID, 0.0, VOID)
  gGame.GetOverlayManager().Modify("shield", VOID, VOID, VOID, 0.0, VOID)
  gGame.GetOverlayManager().Modify("missile", VOID, VOID, VOID, 0.0, VOID)
  repeat with li = 1 to gGame.GetGameplay().GetRaceLaps() - 1
    lName = "lap" & li + 1
    me.CreateTexture(lName, lName)
  end repeat
  me.CreateTexture("pos1", "pos1")
  me.CreateTexture("pos2", "pos2")
  me.CreateTexture("pos3", "pos3")
  me.CreateGfxItem("pos4", "pos4", "curr_pos", point(275, 4))
  me.CreateGfxItem("lap1", "lap1", "curr_lap", point(506, 63))
  lRace = "race" & gGame.GetLevelId()
  me.CreateGfxItem(lRace, lRace, lRace, point(540, 396))
  me.InitializeOverlayBitmapTime()
  lPlanetNames = ["saturn", "mercury", "mars", "uranus"]
  lPlanetName = lPlanetNames[gGame.GetAllId()]
  me.CreateGfxItem(lPlanetName, lPlanetName, lPlanetName, point(472, 397))
end

on InitializePopups me
  lPopupTexture = me.CreateTexture("p_fondo_1", "p_fondo_1")
  lPopupTextureLow = me.CreateTexture("p_fondo_2", "p_fondo_2")
  lGamePausedTexture = me.CreateTexture("p_paused", "p_paused")
  lRecordTexture = me.CreateTexture("p_record2", "p_record2")
  lPlayDnTexture = me.CreateTexture("p_play_dn", "p_play_dn")
  lPlayTexture = me.CreateTexture("p_play_up", "p_play_up")
  lYesTexture = me.CreateTexture("p_yes_up", "p_yes_up")
  lNoTexture = me.CreateTexture("p_no_up", "p_no_up")
  lYesDnTexture = me.CreateTexture("p_yes_dn", "p_yes_dn")
  lNoDnTexture = me.CreateTexture("p_no_dn", "p_no_dn")
  lQuitTexture = me.CreateTexture("p_quit", "p_quit")
  lHelpTexture = me.CreateTexture("p_help", "p_help")
  lBriefTexture = me.CreateTexture("p_brief", "p_brief")
  lWrongTexture = me.CreateTexture("p_wrong", "p_wrong")
  lMessage = [#background: [#x: 0, #y: 0, #texture: lPopupTextureLow, #type: #graphics], #tf_time: [#x: 117, #y: 32, #texture: VOID, #type: #text, #member: member("tfRecord"), #w: 128, #h: 16, #element_id: "tf_time"], #tf_gap: [#x: 113, #y: 46, #texture: VOID, #type: #text, #member: member("tfRecordGap"), #w: 128, #h: 16, #element_id: "tf_gap"]]
  me.AddPopupType("popup_record_low", lMessage, point(182, 378))
  lPause = [#background: [#x: 0, #y: 0, #texture: lPopupTexture, #type: #graphics], #background_mex: [#x: 62, #y: 25, #texture: lGamePausedTexture, #type: #graphics], #bt_play: [#x: 90, #y: 91, #texture: lPlayTexture, #texture_dn: lPlayDnTexture, #type: #button, #w: 60, #h: 32, #button_id: #play]]
  me.AddPopupType("popup_pause", lPause, point(188, 138))
  lWrong = [#background: [#x: 0, #y: 0, #texture: lWrongTexture, #type: #graphics]]
  me.AddPopupType("popup_wrong", lWrong, point(188, 138))
  lQuit = [#background: [#x: 0, #y: 0, #texture: lPopupTexture, #type: #graphics], #background_mex: [#x: 62, #y: 25, #texture: lQuitTexture, #type: #graphics], #bt_yes: [#x: 87, #y: 91, #texture: lYesTexture, #texture_dn: lYesDnTexture, #type: #button, #w: 28, #h: 16, #button_id: #yes], #bt_no: [#x: 127, #y: 91, #texture: lNoTexture, #texture_dn: lNoDnTexture, #type: #button, #w: 20, #h: 16, #button_id: #no]]
  me.AddPopupType("popup_quit", lQuit, point(188, 138))
  lHelp = [#background: [#x: 0, #y: 0, #texture: lPopupTexture, #type: #graphics], #help: [#x: 58, #y: 0, #texture: lHelpTexture, #type: #graphics], #bt_back: [#x: 98, #y: 175, #texture: lPlayTexture, #texture_dn: lPlayDnTexture, #type: #button, #w: 49, #h: 32, #button_id: #back]]
  me.AddPopupType("popup_help", lHelp, point(188, 138))
  lBrief = [#background: [#x: 0, #y: 0, #texture: lPopupTexture, #type: #graphics], #brief: [#x: 58, #y: 0, #texture: lBriefTexture, #type: #graphics]]
  me.AddPopupType("popup_brief", lBrief, point(188, 138))
  lTutorial = [#background: [#x: 0, #y: 0, #texture: lPopupTexture, #type: #graphics], #help: [#x: 58, #y: 0, #texture: lHelpTexture, #type: #graphics]]
  me.AddPopupType("popup_tutorial", lTutorial, point(188, 138))
  lMainPopupHolder = script("Popup Holder").new(me.Get3D(), me.GetOverlayManager(), gGame.GetTimeManager())
  me.AddPopupHolder("main_holder", lMainPopupHolder)
  lMainPopupHolder.SetRefPosition(point(0, 0))
end

on InitializeButtons me
  lPlayButton = me.AddButton("play_button", me, #OnPlayClick, "bn_play_up", "bn_play_dn", "bn_play_gh", point(7, 387), 20, 32)
  lPauseButton = me.AddButton("pause_button", me, #OnPauseClick, "bn_pause_up", "bn_pause_dn", "bn_pause_gh", point(7, 387), 20, 32)
  lAudioOnButton = me.AddButton("soundon_button", me, #OnSoundOnClick, "bn_soundon_up", "bn_soundon_dn", "bn_soundon_gh", point(29, 387), 20, 32)
  lAudioOffButton = me.AddButton("soundoff_button", me, #OnSoundOffClick, "bn_soundoff_up", "bn_soundoff_dn", "bn_soundoff_gh", point(29, 387), 50, 32)
  lExitButton = me.AddButton("exit_button", me, #OnExitClick, "bn_exit_up", "bn_exit_dn", "bn_exit_gh", point(49, 387), 32, 32)
  lPlayButton.SetVisibility(0)
  lAudioState = gGame.GetSoundManager().GetAudioState()
  me.SetSoundOnOffButtons(lAudioState)
end

on InitializeOverlayBitmapTime me
  lOverlayBitmapTime = script("Overlay Bitmap Time").new(me, 1)
  me.SetOverlayBitmapTime(lOverlayBitmapTime)
  repeat with i = 0 to 9
    lOverlayBitmapTime.AddSymbol(EMPTY & i, "symboltime_" & i, 16)
  end repeat
  lOverlayBitmapTime.AddSymbol("separator", "symboltime_2dots", 5)
  lOverlayBitmapTime.create(0, point(436, 28), 1)
  lOverlayBitmapBestTime = script("Overlay Bitmap Time").new(me, 1, #time, VOID, "best_time")
  repeat with i = 0 to 9
    lOverlayBitmapBestTime.AddSymbol(EMPTY & i, "symbol_" & i, 10)
  end repeat
  lOverlayBitmapBestTime.AddSymbol("dash", "symbol_best_dash", 10)
  lOverlayBitmapBestTime.AddSymbol("separator", "symbol_2dots", 3)
  lOverlayBitmapBestTime.create(gGame.GetBestTime(), point(480, 7), 1)
  me.SetOverlayBitmapBestTime(lOverlayBitmapBestTime)
  lOverlayBitmapScore = script("Overlay Bitmap Time").new(me, 0, #score, 8, "score")
  repeat with i = 0 to 9
    lOverlayBitmapScore.AddExistingSymbol(EMPTY & i, "symbol_" & i, 10)
  end repeat
  lOverlayBitmapScore.create(gGame.GetPlayerScore(), point(462, 418), 0)
  me.SetOverlayBitmapScore(lOverlayBitmapScore)
  me.UpdateScore()
  lOverlayBitmapKmh = script("Overlay Bitmap Time").new(me, 0, #score, 3, "kmh")
  repeat with i = 0 to 9
    lOverlayBitmapKmh.AddExistingSymbol(EMPTY & i, "symbol_" & i, 10)
  end repeat
  lOverlayBitmapKmh.create(0, point(94, 395), 0)
  me.SetOverlayBitmapKmh(lOverlayBitmapKmh)
end

on InitializeSpriteFx me
  lSpriteFxManager = gGame.GetSpriteFxManager()
  lSpriteFxManager.RegisterTexture("f_3", "f_3")
  lSpriteFxManager.RegisterTexture("f_2", "f_2")
  lSpriteFxManager.RegisterTexture("f_1", "f_1")
  lSpriteFxManager.RegisterTexture("f_go", "f_go")
  lSpriteFxManager.RegisterTexture("finish1", "finish1")
  lSpriteFxManager.RegisterTexture("finish2", "finish2")
  lSpriteFxManager.RegisterTexture("finish3", "finish3")
  lSpriteFxManager.RegisterTexture("finish4", "finish4")
  lSpriteFxManager.RegisterTexture("f_final_lap", "f_final_lap")
  lSpriteFxManager.RegisterTexture("f_200", "f_200")
  lSpriteFxManager.RegisterTexture("f_500", "f_500")
  lSpriteFxManager.RegisterTexture("f_1000", "f_1000")
  lCustomEffect = gGame.GetSpriteFxManager().CloneEffectType("standard_directional", "custom_directional")
  lCustomEffect.startscale = 0.80000000000000004
  lCustomEffect.startBlendTime = 0.5
  lCustomEffect.EndDirectionTime = 1.0
  lCustomEffect.flyingTime = 2000
  lCustomEffect.speed = vector(500, 500, 0)
  lCustomEffect.acceleration = -120
  lEffect = gGame.GetSpriteFxManager().CloneEffectType("central_flash", "custom_flash")
  lEffect.flyingTime = 1000
  lEffect.acceleration = 2.0
  lEffect.speed = vector(400, 400, 0)
  lEffect.initPos = point(270, 110)
  lEffect = gGame.GetSpriteFxManager().CloneEffectType("custom_flash", "custom_finish")
  lEffect.flyingTime = 3000
  lEffect.initPos = point(270, 138)
  lEffect = gGame.GetSpriteFxManager().CloneEffectType("custom_flash", "custom_123")
  lEffect.flyingTime = 600
  lEffect.initPos = point(270, 138)
  lEffect = gGame.GetSpriteFxManager().CloneEffectType("custom_flash", "custom_go")
  lEffect.flyingTime = 1000
  lEffect.initPos = point(270, 138)
end

on GetCurrentLap me
  return pCurrentLap
end

on GetHudValues me
  return pHudValues
end

on GetHudValue me, kValue
  return pHudValues[kValue]
end

on GetOverlayBitmapScore me
  return pOverlayBitmapScore
end

on GetOverlayBitmapKmh me
  return pOverlayBitmapKmh
end

on GetOverlayBitmapBestTime me
  return pOverlayBitmapBestTime
end

on SetHudValue me, kName, kValue
  if voidp(pHudValues.getaProp(kName)) then
    pHudValues.addProp(kName, kValue)
  else
    pHudValues[kName] = kValue
  end if
end

on UpdateLapNumber me, kValue
  pCurrentLap = kValue
  lTexture = gGame.Get3D().texture("lap" & kValue)
  gGame.GetOverlayManager().Modify("curr_lap", lTexture, VOID, VOID, VOID, VOID, VOID)
end

on SetPlayerPosition me, kValue
  lTexture = gGame.Get3D().texture("pos" & kValue)
  gGame.GetOverlayManager().Modify("curr_pos", lTexture)
  pPlayerRacePosition = kValue
end

on SetOverlayBitmapScore me, kOverlayBitmapScore
  pOverlayBitmapScore = kOverlayBitmapScore
end

on SetOverlayBitmapKmh me, kOverlayBitmapKmh
  pOverlayBitmapKmh = kOverlayBitmapKmh
end

on SetOverlayBitmapBestTime me, kOverlayBitmapBestTime
  pOverlayBitmapBestTime = kOverlayBitmapBestTime
end

on SetUpdateKmh me, kUpdateKmh
  pUpdateKmh = kUpdateKmh
end

on GameStartEnter me, kCamera, kTime
end

on GameStartExec me, kCamera, kTime
  me.FlushKeyEvents()
end

on GameStartExit me, kCamera, kTime
end

on TopViewEnter me, kCamera, kTime
end

on TopViewExec me, kCamera, kTime
  me.FlushKeyEvents()
end

on TopViewExit me, kCamera, kTime
end

on OnPauseClick me
  me.ancestor.OnPauseClick()
end

on OnPlayClick me
  me.ancestor.OnPlayClick()
end

on OnSoundOnClick me
  me.ancestor.OnSoundOnClick()
end

on OnSoundOffClick me
  me.ancestor.OnSoundOffClick()
  gGame.GetGameSoundManager().OnSoundOffClick()
end

on OnExitClick me
  pExitType = #QuitRace
  me.ancestor.OnExitClick()
end

on OnRestartRaceClick me
  pExitType = #RestartRace
  me.ancestor.OnExitClick()
end

on OnMainMenuClick me
  pExitType = #GoToMainMenu
  me.ancestor.OnExitClick()
end

on OnHelpClick me
  me.ancestor.OnHelpClick()
end

on OnExitYesClick me
  me.ancestor.OnExitYesClick()
  gGame.exit(2)
end

on OnExitNoClick me
  me.ancestor.OnExitNoClick()
end

on OnHelpBackClick me
  me.ancestor.OnHelpBackClick()
  gGame.UnPause()
end

on GamePaused me
  lSoundOnButton = me.GetOverlayButton("soundon_button")
  lSoundOffButton = me.GetOverlayButton("soundoff_button")
  lPlayButton = me.GetOverlayButton("play_button")
  lExitButton = me.GetOverlayButton("exit_button")
  lPausePopup = me.ShowPausePopup(-1)
  me.SetPausePopup(lPausePopup)
  me.ancestor.SetPausePopupShown(1)
  lSoundOnButton.Disable()
  lSoundOffButton.Disable()
  me.ancestor.GamePaused()
end

on GameResumed me
  lSoundOnButton = me.GetOverlayButton("soundon_button")
  lSoundOffButton = me.GetOverlayButton("soundoff_button")
  lPlayButton = me.GetOverlayButton("play_button")
  lExitButton = me.GetOverlayButton("exit_button")
  me.GetPopupHolder("main_holder").RemoveFromFront()
  me.SetPausePopup(VOID)
  me.ancestor.SetPausePopupShown(0)
  lSoundOnButton.Enable()
  lSoundOffButton.Enable()
  me.ancestor.GameResumed()
end

on QuitRequested me
  lExitPopup = me.ShowExitPopup(-1)
  me.SetExitPopup(lExitPopup)
  lSoundOnButton = me.GetOverlayButton("soundon_button")
  lSoundOffButton = me.GetOverlayButton("soundoff_button")
  lPauseButton = me.GetOverlayButton("pause_button")
  lPlayButton = me.GetOverlayButton("play_button")
  lPauseButton.Disable()
  lPlayButton.Disable()
  pSoundButtonEnabledBeforeExit = lSoundOnButton.IsEnabled() and lSoundOffButton.IsEnabled()
  if pSoundButtonEnabledBeforeExit then
    lSoundOnButton.Disable()
    lSoundOffButton.Disable()
  end if
end

on ResumedFromQuit me
  me.GetPopupHolder("main_holder").RemoveFromFront()
  me.SetExitPopup(VOID)
  lPauseButton = me.GetOverlayButton("pause_button")
  lPlayButton = me.GetOverlayButton("play_button")
  lSoundOnButton = me.GetOverlayButton("soundon_button")
  lSoundOffButton = me.GetOverlayButton("soundoff_button")
  lPauseButton.Enable()
  lPlayButton.Enable()
  if pSoundButtonEnabledBeforeExit then
    lSoundOnButton.Enable()
    lSoundOffButton.Enable()
    pSoundButtonEnabledBeforeExit = 1
  end if
end

on ShowActiveWeapon me, kWeapon
  gGame.GetOverlayManager().Modify("bolt", VOID, VOID, VOID, 0.0, VOID)
  gGame.GetOverlayManager().Modify("shield", VOID, VOID, VOID, 0.0, VOID)
  gGame.GetOverlayManager().Modify("missile", VOID, VOID, VOID, 0.0, VOID)
  if kWeapon <> #none then
    gGame.GetOverlayManager().Modify(string(kWeapon), VOID, VOID, VOID, 100.0, VOID)
  end if
end

on ShowInitialBriefing me
  lPopup = script("Popup").new(me.GetPopupType("popup_brief"), [])
  me.GetPopupHolder("main_holder").AddToFront(lPopup, 3700.0, VOID, VOID, VOID)
  return lPopup
end

on ShowHelpPopup me, kDuration
  lPopup = script("Popup").new(me.GetPopupType("popup_help"), [])
  me.GetPopupHolder("main_holder").AddToFront(lPopup, kDuration, VOID, VOID, VOID)
  return lPopup
end

on ShowTutorialPopup me, kDuration
  lPopup = script("Popup").new(me.GetPopupType("popup_tutorial"), [])
  me.GetPopupHolder("main_holder").AddToFront(lPopup, kDuration, VOID, VOID, VOID)
  return lPopup
end

on ShowRecordPopup me, kDuration, kTimeString, kGapString
  lPopupName = "popup_record_low"
  lSize = 16
  lPopup = script("Popup").new(me.GetPopupType(lPopupName), [#tf_time: [#text: string(kTimeString), #size: lSize, #color: rgb(255, 255, 255)], #tf_gap: [#text: string(kGapString), #size: lSize, #color: rgb(255, 255, 255)]])
  me.GetPopupHolder("main_holder").AddToFront(lPopup, kDuration, VOID, VOID, VOID)
  return lPopup
end

on ShowPausePopup me, kDuration
  lPopup = script("Popup").new(me.GetPopupType("popup_pause"), [])
  me.GetPopupHolder("main_holder").AddToFront(lPopup, kDuration, VOID, VOID, VOID)
  return lPopup
end

on ShowExitPopup me, kDuration
  lPopup = script("Popup").new(me.GetPopupType("popup_quit"), [])
  me.GetPopupHolder("main_holder").AddToFront(lPopup, kDuration, VOID, VOID, VOID)
  return lPopup
end

on ShowWrongWayPopup me, kDuration
  lPopup = script("Popup").new(me.GetPopupType("popup_wrong"), [])
  me.GetPopupHolder("main_holder").AddToFront(lPopup, kDuration, VOID, VOID, VOID)
  return lPopup
end

on AddOneOverlay me
  gGame.GetSpriteFxManager().AddSpriteFxObject("custom_123", 0, "f_1")
end

on AddTwoOverlay me
  gGame.GetSpriteFxManager().AddSpriteFxObject("custom_123", 0, "f_2")
end

on AddThreeOverlay me
  gGame.GetSpriteFxManager().AddSpriteFxObject("custom_123", 0, "f_3")
end

on AddGoOverlay me
  gGame.GetSpriteFxManager().AddSpriteFxObject("custom_go", 0, "f_go")
end

on AddRandomScoreOverlay me, kScoreId
  lSpriteFxManager = gGame.GetSpriteFxManager()
  lChangedEffect = lSpriteFxManager.GetEffectType("custom_directional")
  lRandomVector = vector(random(-6, 6), random(-6, 6), 0)
  if (lRandomVector.x = 0) and (lRandomVector.y = 0) then
    lRandomVector = vector(-1, -1, 0)
  end if
  lChangedEffect.direction = lRandomVector
  gGame.GetSpriteFxManager().AddSpriteFxObject("custom_directional", 0, kScoreId)
end

on addFinishOverlay me
  gGame.GetSpriteFxManager().AddSpriteFxObject("custom_finish", 0, "finish" & gGame.GetFinalPlacement())
end

on ShowFinalOverlay me
  me.addFinishOverlay()
end

on UpdateTime me, kTime
  me.GetOverlayBitmapTime().update(kTime)
end

on UpdateBestTime me, kTime
  me.GetOverlayBitmapBestTime().update(kTime)
end

on UpdateScore me
  lScoreString = string(gGame.GetPlayerScore())
  me.GetOverlayBitmapScore().update(lScoreString)
end

on UpdateKmh me
  if pUpdateKmh then
    lKmh = gGame.GetPlayerVehicle().GetSpeedKmh()
    if lKmh < 0 then
      lKmh = 0
    end if
    lKmhString = string(integer(lKmh))
    me.GetOverlayBitmapKmh().update(lKmhString)
  end if
end

on CheckPopupButtons me
  me.ancestor.CheckPopupButtons()
  lPausePopup = me.GetPausePopup()
  if not voidp(lPausePopup) then
    lPausePopup.UpdateButtons(me.GetOverlayManager())
    if lPausePopup.GetButtonPressed() = #play then
      me.OnPlayClick()
    end if
  end if
  lExitPopup = me.GetExitPopup()
  if not voidp(lExitPopup) then
    lExitPopup.UpdateButtons(me.GetOverlayManager())
    lExitButtonPressed = lExitPopup.GetButtonPressed()
    if lExitButtonPressed = #yes then
      me.OnExitYesClick()
    else
      if lExitButtonPressed = #no then
        me.OnExitNoClick()
      end if
    end if
  end if
  lHelpPopup = me.GetHelpPopup()
  if not voidp(lHelpPopup) then
    lHelpPopup.UpdateButtons(me.GetOverlayManager())
    if gGame.GetInputManager().IsKeyPressed(SPACE) then
      me.OnHelpBackClick()
    end if
  end if
end

on AddLastLapOverlay me
  gGame.GetSpriteFxManager().AddSpriteFxObject("custom_123", 0, "f_final_lap")
end

on update me, kTime
  me.ancestor.update(kTime)
  me.UpdateKmh()
  lActualPosition = gGame.GetPositionInRace(gGame.GetPlayerVehicle())
  if lActualPosition <> pPlayerRacePosition then
    me.SetPlayerPosition(lActualPosition)
  end if
  if gGame.GetConfiguration() <> #release_web then
    gGame.GetFrameCounter().update(kTime)
  end if
  me.CheckPopupButtons()
end
