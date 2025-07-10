property ancestor, pMaxTime, pTimeCountUp, pStartRaceTime, pTimeElapsedFlag, pGameplayTime, pResetToTrackFader, pFinishLine, pNumLaps, pStartPositionList, pPartialResults, pAvgSpeed, pRaceTime, pInitialStartRaceTime, pSafePointsInfo, pStartPlaneRef, pStartShaderRef, pLastLapShaderRef, pFinishShaderRef, pStartPlaneTimer, pWrongWayTimer, pWrongWayPopupTimer, pWrongWayShowed
global gGame

on new me
  lMyFSM = script("FSM").new()
  lMyFSM.AddState(#VoidState, #VoidEnter, #VoidExec, #VoidExit, script("Void state"))
  lMyFSM.AddState(#preRender, #PrerenderEnter, #PrerenderExec, #PrerenderExit, script("Prerender state"))
  lMyFSM.AddState(#GameStart, #GameStartEnter, #GameStartExec, #GameStartExit, script("GameStart state"))
  lMyFSM.AddState(#Race, #RaceEnter, #RaceExec, #RaceExit, me)
  lMyFSM.AddState(#EndOfRace, #EndOfRaceEnter, #EndOfRaceExec, #EndOfRaceExit, me)
  me.ancestor = script("Gameplay").new(lMyFSM, #VoidState)
  return me
end

on Initialize me
  pTimeCountUp = 1
  pTimeElapsedFlag = 0
  pMaxTime = 300000
  pNumLaps = 3
  pGameplayTime = 0
  pResetToTrackFadeOutTimer = -1
  pPartialResults = []
  repeat with li = 1 to gGame.GetHowManyPlayers()
    pPartialResults.add([])
  end repeat
  pAvgSpeed = 0
  pRaceTime = 0
  pInitialStartRaceTime = 0
  pStartPlaneRef = gGame.Get3D().model("const_startplane")
  pStartShaderRef = gGame.Get3D().shader("as2_start_mat")
  pLastLapShaderRef = gGame.Get3D().shader("as2_lastlap_mat")
  pFinishShaderRef = gGame.Get3D().shader("as2_finish_mat")
  pStartPlaneTimer = -1
  pWrongWayTimer = -1
  pWrongWayPopupTimer = -1
  pWrongWayShowed = 0
end

on HandleWrongWay me, kTime
  lVehicle = gGame.GetPlayerVehicle().GetVehicle()
  lTokenTangent = lVehicle.GetTokenTangent()
  lFrontDir = lVehicle.GetWorldForward()
  lDot = lTokenTangent.dot(lFrontDir)
  if lDot < -0.5 then
    if gGame.GetGameStatus() <> #play then
      return 
    end if
    if pWrongWayTimer = -1 then
      pWrongWayTimer = kTime
    else
      if (kTime - pWrongWayTimer) > 2500 then
        gGame.GetInGame().ShowWrongWayPopup(1000)
        pWrongWayTimer = kTime
      end if
    end if
  else
    pWrongWayTimer = -1
  end if
end

on InitializeGates me, kGatesList
  lTokenManager = gGame.GetTokenManager()
  repeat with li = 1 to kGatesList.count
    lGateRef = kGatesList[li]
    lGetTokenResult = lTokenManager.GetTokenUnOptimized(0, lGateRef.x, lGateRef.y, lGateRef, 0.0, 0.0)
    lTokenId = lGetTokenResult[1]
    lTokenTangent = lGetTokenResult[3]
    lLongitudinal = lGetTokenResult[4]
    lTrackPos = lTokenManager.GetDistanceFromStart(lTokenId) + (lTokenManager.GetTokenRoadLength(lTokenId) * lLongitudinal)
    if lTrackPos >= gGame.GetTrackLength() then
      lTrackPos = lTrackPos - gGame.GetTrackLength()
    end if
    lOrthoTangent = vector(-lTokenTangent.y, lTokenTangent.x, 0.0)
    lPosA = lGateRef + (lOrthoTangent * 2000.0)
    lPosB = lGateRef - (lOrthoTangent * 2000.0)
    lCheckline = script("Checkline").new(0, "gate_" & li, lPosA, lPosB, #gate, #gate, VOID, VOID, VOID, #generic)
    lTokenManager.GetTokenRef(lTokenId).CheckLineList.addProp(lTrackPos, [#trackPos: lTrackPos, #Pos: lGateRef, #ckl: lCheckline])
  end repeat
  repeat with lTrackToken in lTokenManager.GetTrackTokens()
    lTrackToken.sort()
  end repeat
end

on InitializeFinishLine me, kPosA, kPosB
  pFinishLine = script("Checkline").new(0, "finishline", kPosA, kPosB, #finish_front, #finish_back, VOID, VOID, VOID, #generic)
end

on RaceEnter me, kEntity, kTime
  pStartRaceTime = gGame.GetTimeManager().GetTime()
  pInitialStartRaceTime = pStartRaceTime
end

on RaceExec me, kEntity, kTime
  me.UpdateTime()
  if gGame.GetGameStatus() = #play then
    me.CheckFinishLine(kTime)
  end if
  me.HandleWrongWay(kTime)
  me.CheckResetToTrackFader(kTime)
end

on RaceExit me, kEntity, kTime
end

on EndOfRaceEnter me, kEntity, kTime
  gGame.GetCamera().SetupFade(#fadeOut, kTime, 2500.0)
end

on EndOfRaceExec me, kEntity, kTime
  lEndFade = gGame.GetCamera().UpdateFade(kTime)
  if lEndFade then
    case gGame.GetGameStatus() of
      #endgood:
        if me.LevelPassed() then
          me.ExitGood()
        else
          me.ExitBad()
        end if
      #endTimeup:
        me.ExitTimeUp()
    end case
  end if
end

on EndOfRaceExit me, kEntity, kTime
end

on GetRaceLaps me
  return pNumLaps
end

on GetFinishLine me
  return pFinishLine
end

on GetMaxTime me
  return pMaxTime
end

on GetGameplayTime me
  return pGameplayTime
end

on GetStartRaceTime me
  return pStartRaceTime
end

on GetAvgSpeed me
  return pAvgSpeed
end

on SetCkpList me, kCkpList
  pCkpList = kCkpList
end

on SetMaxTime me, kMaxTime
  pMaxTime = kMaxTime
end

on SetStartRaceTime me, kStartRaceTime
  pStartRaceTime = kStartRaceTime
end

on SetResetToTrackFader me, fValue
  pResetToTrackFader = fValue
end

on SetStartPositionList me, kStartPositionList
  pStartPositionList = kStartPositionList
end

on SetAvgSpeed me, kAvgSpeed
  pAvgSpeed = kAvgSpeed
end

on LevelPassed me
  lLevelPassed = 0
  if gGame.GetFinalPlacement() = 1 then
    lLevelPassed = 1
  end if
  return lLevelPassed
end

on SetHudTimeElapsed me
  gGame.GetInGame().UpdateTime(0)
end

on EnableUserInput me
end

on DisableUserInput me
  gGame.GetPlayerVehicle().GetVehicle().SetEnableUserInput(0)
end

on StartVehicles me
  lPlayers = gGame.GetPlayers()
  repeat with li = 1 to lPlayers.count
    lPlayers[li].SetForceToBrake(0)
  end repeat
  lHavokPhys = gGame.GetHavokPhysics()
  lHavokPhys.RemoveSubstepCallback(#BlockOnStartPos, me)
end

on AiActivation me
  lPlayers = gGame.GetPlayers()
  repeat with li = 1 to lPlayers.count
    lPlayerRef = lPlayers[li]
    if lPlayerRef.IsCPUControlled() then
      lPlayerRef.pInputController.SetActive(1)
    end if
  end repeat
end

on StartPlayerVehicle me
  gGame.GetPlayerVehicle().SetForceToBrake(0)
end

on StopVehicles me
  lPlayers = gGame.GetPlayers()
  repeat with li = 1 to lPlayers.count
    lPlayers[li].SetForceToBrake(1.0)
  end repeat
end

on StopAllSounds me
  lSoundManager = gGame.GetSoundManager()
  lSoundManager.StopAllSoundChannels()
end

on PlaySoundLevelEndGood me
  if gGame.GetPositionInRace(gGame.GetPlayerVehicle()) = 1 then
    gGame.GetGameSoundManager().PlaySound("snd_finish", 1)
  else
    gGame.GetGameSoundManager().PlaySound("snd_game_over", 1)
  end if
end

on SetFinalAnimation me
  if gGame.GetFinalPlacement() = 1 then
    gGame.GetPlayerVehicle().GetVehicleGfx().GetPlayerGfx().SetHappy(1)
  else
    gGame.GetPlayerVehicle().GetVehicleGfx().GetPlayerGfx().SetSad(1)
  end if
end

on DisableEngineSound me
  gGame.GetEngineSoundManager().SetEnabled(0)
  gGame.GetSoundManager().StopSound(2)
end

on HumanToCpuControl me
  gGame.GetPlayerVehicle().SwapCpuControl()
  if gGame.GetPlayerVehicle().IsCPUControlled() then
    lAIController = gGame.GetPlayerVehicle().GetInputController()
    lAIController.SetActive(1)
    lAIController.ChangeState(#AiSimple, gGame.GetTimeManager().GetTime())
  end if
end

on CountDown me
end

on PopupSound me
  gGame.GetGameSoundManager().PlaySound("snd_popup", 1)
end

on Ready me
  gGame.GetInGame().AddThreeOverlay()
  gGame.EnableDynamycFov()
end

on Three me
  gGame.GetInGame().AddThreeOverlay()
  gGame.EnableDynamycFov()
end

on Two me
  gGame.GetInGame().AddTwoOverlay()
end

on One me
  gGame.GetInGame().AddOneOverlay()
end

on StartInputControl me
  gGame.GetPlayerVehicle().GetInputController().SetEnableUserInput(1)
end

on go me
  gGame.GetInGame().AddGoOverlay()
  gGame.GetInGame().SetUpdateKmh(1)
  gGame.SetGameStatus(#play)
  gGame.GetGameSoundManager().SetSoundsActive(1)
  gGame.GetEngineSoundManager().SetEnabled(1)
  me.StartInputControl()
end

on GoSound me
  gGame.GetGameSoundManager().PlaySound("snd_go", 1)
end

on ReadySound me
  gGame.GetGameSoundManager().PlaySound("snd_ready", 1)
end

on StartGameplay me
  me.ChangeState(#Race)
end

on SetStartCamera me
  gGame.GetCamera().ChangeState(#FadeEnter, gGame.GetTimeManager().GetTime())
end

on SetFinishCamera me
  gGame.GetCamera().SetCameraSourceOffsetInterpolation(vector(-600.0, 350.0, 160.0), 2500.0)
end

on StartFadeEndLevel me
  me.ChangeState(#EndOfRace, gGame.GetTimeManager().GetTime())
end

on SetLevelCompleted me
  gGame.SetGameStatus(#endgood)
  gGame.GetInGame().UpdateTime(me.GetGameplayTime())
  gGame.GetEngineSoundManager().SetEnabled(0)
  gGame.SetFinalPlacement(gGame.GetPositionInRace(gGame.GetPlayerVehicle()))
end

on SetLevelFailedTimeOut me
  gGame.SetGameStatus(#endTimeup)
  gGame.SetPlayerTime(0)
end

on PopupLevelEndGood me
  gGame.GetInGame().addFinishOverlay()
end

on PopupLevelEndTimeOut me
end

on PopupTutorial me
  gGame.GetInGame().ShowTutorialPopup(4000.0)
end

on ShowInitialBriefing me
  gGame.GetInGame().ShowInitialBriefing()
end

on PupupTutorialSound me
  gGame.GetGameSoundManager().PlaySound("snd_popup", 1)
end

on SetHudFinishTime me
  gGame.GetInGame().GetOverlayBitmapTime().update(gGame.GetPlayerVehicle().GetVehicle().GetRaceTime())
end

on ExitGood me
  if gGame.GetGameType() = #championship then
    gGame.exit(3)
  else
    gGame.exit(4)
  end if
end

on ExitTimeUp me
  gGame.exit(4)
end

on ExitBad me
  if gGame.GetGameType() = #championship then
    gGame.exit(3)
  else
    gGame.exit(4)
  end if
end

on CalculateAvgSpeed me
  lRaceTime = pRaceTime / 3600000
  lTrackLength = gGame.GetTrackLength() * me.GetRaceLaps()
  lTrackLength = lTrackLength / 100000
  if lRaceTime <> 0 then
    lAvgSpeed = lTrackLength / lRaceTime
    lAvgSpeed = integer(lAvgSpeed)
  else
    lAvgSpeed = 0
  end if
  me.SetAvgSpeed(lAvgSpeed)
  put "lRaceTime: " & lRaceTime & " lTrackLength: " & lTrackLength
  put "lAvgSpeed: " & lAvgSpeed
  return 
  lRaceTime = gGame.GetPlayerVehicle().GetVehicle().GetRaceTime()
  if lRaceTime = -1 then
    lRaceTime = me.GetGameplayTime()
  end if
  lTrackLength = gGame.GetTrackLength(0) * me.GetRaceLaps()
  lAvgSpeed = lTrackLength / lRaceTime
  lRaceTimeh = lRaceTime / 3600000
  lRaceLength = lTrackLength / 160934.39999999999417923
  if lRaceTimeh <> 0 then
    lAvgSpeed = integer(lRaceLength / lRaceTimeh)
  else
    lAvgSpeed = 0
  end if
  me.SetAvgSpeed(lAvgSpeed)
  put "lRaceTime: " & lRaceTime & " lTrackLength: " & lTrackLength
  put "lAvgSpeed: " & lAvgSpeed
end

on CallbackLevelCompleted
end

on CheckResetToTrackFader me, kTime
  if pResetToTrackFader <> #none then
    lEndFade = gGame.GetCamera().UpdateFade(kTime)
    if lEndFade then
      if pResetToTrackFader = #fadeOut then
        gGame.GetCamera().SetupFade(#fadeIn, kTime, 800.0)
        put "ResetToTrack da CheckResetToTrackFader"
        gGame.GetPlayerVehicle().GetVehicle().ResetToTrack()
        me.SetResetToTrackFader(#fadeIn)
        gGame.GetPlayerVehicle().GetVehicle().SetForceToBrake(0.10000000000000001)
        pResetToTrackFadeOutTimer = kTime
      else
        me.SetResetToTrackFader(#none)
        gGame.GetPlayerVehicle().GetVehicle().SetIfHaveToResetToTrack(0)
        if gGame.GetGameStatus() = #play then
          gGame.GetPlayerVehicle().GetVehicle().SetForceToBrake(0.0)
        end if
      end if
    end if
  end if
end

on ResetToTrackWithFade me
  gGame.GetPlayerVehicle().GetVehicle().SetIfHaveToResetToTrack(1)
  gGame.GetCamera().SetupFade(#fadeOut, gGame.GetTimeManager().GetTime(), 600.0)
  me.SetResetToTrackFader(#fadeOut)
end

on InitializeSafePointsInfo me, kSafePointsInfo
  pSafePointsInfo = []
  lSafePointsInfo = []
  lTokenManager = gGame.GetTokenManager()
  repeat with li = 1 to kSafePointsInfo.count
    lPosition = kSafePointsInfo[li]
    lGetTokenResult = lTokenManager.GetTokenUnOptimized(0, lPosition.x, lPosition.y, vector(lPosition.x, lPosition.y, 0.0), 0.0, 0.0)
    lTokenId = lGetTokenResult[1]
    lTokenTangent = lGetTokenResult[3]
    lLongitudinal = lGetTokenResult[4]
    lTrackPos = lTokenManager.GetTrackPos(lPosition)
    if lTrackPos > gGame.GetTrackLength() then
      lTrackPos = lTrackPos - gGame.GetTrackLength()
    end if
    lSafePointsInfo.add([#trackPos: lTrackPos, #worldPos: lPosition, #TokenId: lTokenId, #longitudinal: lLongitudinal, #tokenTangent: lTokenTangent])
    pSafePointsInfo.add([])
  end repeat
  repeat with li = 1 to lSafePointsInfo.count
    lSafePoint = lSafePointsInfo[li]
    lTrackPos = lSafePoint.trackPos
    lIdx = 1
    repeat with lj = 1 to lSafePointsInfo.count
      if li <> lj then
        lOtherTrackPos = lSafePointsInfo[lj].trackPos
        if lOtherTrackPos < lTrackPos then
          lIdx = lIdx + 1
        end if
      end if
    end repeat
    pSafePointsInfo[lIdx] = [#trackPos: lSafePoint.trackPos, #worldPos: lSafePoint.worldPos, #TokenId: lSafePoint.TokenId, #longitudinal: lSafePoint.longitudinal, #tokenTangent: lSafePoint.tokenTangent]
  end repeat
end

on ResetToTrackCallback me, kVehicle
  lLastSafeTokenId = kVehicle.GetCurrentToken()
  if lLastSafeTokenId = #t1 then
    lLastSafeTokenId = #t2
  end if
  lLastSafeTokenRef = gGame.GetTokenManager().GetTokenRef(lLastSafeTokenId)
  lTestForJump = 0
  repeat while not lTestForJump
    if (lLastSafeTokenRef.token <> "d2jump") and (lLastSafeTokenRef.token <> "d3jump") and (lLastSafeTokenRef.token <> "twist") and (lLastSafeTokenRef.token <> "loop") then
      lTestForJump = 1
      next repeat
    end if
    lTrackTokens = gGame.GetTokenManager().GetTrackTokens()
    if (lLastSafeTokenRef.token <> "twist") and (lLastSafeTokenRef.token <> "loop") then
      lLastSafeTokenId = lTrackTokens[lLastSafeTokenRef.Prev[1]].Prev[1]
    else
      lLastSafeTokenId = lLastSafeTokenRef.Prev[1]
    end if
    lLastSafeTokenRef = gGame.GetTokenManager().GetTokenRef(lLastSafeTokenId)
  end repeat
  lLastSafeTokenTransform = lLastSafeTokenRef.model.transform
  lNewPosition = gGame.GetTokenManager().TokenToWorld3DByRef(lLastSafeTokenRef, 0.01, 0.0)
  lTokenUp = lLastSafeTokenRef.normal
  lOffsetFromToken = 450
  lDirection = lLastSafeTokenTransform.axisAngle
  lResult = gGame.GetTokenManager().getToken(lLastSafeTokenId, lNewPosition.x, lNewPosition.y, lNewPosition, 0.0, 0.0)
  lTokenTangent = lResult[3]
  lRefDirection = vector(0.0, 1.0, 0.0)
  lAngleBtw = lTokenTangent.angleBetween(lRefDirection)
  lVersus = lTokenTangent.crossProduct(lRefDirection)
  if lVersus.z >= 0.0 then
    lAngleBtw = -lAngleBtw
  end if
  lRes = kVehicle.GetChassisRB().interpolatingMoveTo(lNewPosition + (lTokenUp * lOffsetFromToken), [lTokenUp, lAngleBtw])
  kVehicle.SetCurrentToken(lLastSafeTokenId)
  if kVehicle.GetPlayer().GetPlayerId() = 1 then
    gGame.GetCamera().DisablePreviousTransform(gGame.GetTimeManager().GetTime())
  end if
  return 
  lTokenTangent = lLastSafeTokenTransform.yAxis
  lTrasversalList = [0.0, -0.14999999999999999, 0.14999999999999999, 0.25]
  lTrasversal = lTrasversalList[kVehicle.GetPlayer().GetPlayerId()]
  lIntersectionNormal = vector(0.0, 0.0, 1.0)
  lNewPosition = lNewPosition + (lTokenUp * lOffsetFromToken)
  lModelList = [lLastSafeTokenRef.model]
  lArguments = [#maxNumberOfModels: 5, #levelOfDetail: #detailed, #modelList: lModelList]
  lIntersections = gGame.Get3D().modelsUnderRay(lNewPosition, -lTokenUp, lArguments)
  repeat with lIntersection in lIntersections
    if lIntersection[1].name starts "l_t" then
      lGroundPosition = lIntersection.isectPosition
      lIntersectionNormal = lIntersection.isectNormal
      lNewPosition = lGroundPosition + (lTokenUp * 300.0)
      exit repeat
    end if
  end repeat
  lRefDirection = vector(0.0, 1.0, 0.0)
  lAngleBtw = lTokenTangent.angleBetween(lRefDirection)
  lVersus = lTokenTangent.crossProduct(lRefDirection)
  if lVersus.z >= 0.0 then
    lAngleBtw = -lAngleBtw
  end if
  kVehicle.SetCurrentToken(lLastSafeTokenId)
  lRes = kVehicle.GetChassisRB().interpolatingMoveTo(lNewPosition, [lIntersectionNormal, lAngleBtw])
  return 
  lSafePoint = pSafePointsInfo[1]
  lTrackPos = kVehicle.GetTrackPos()
  repeat with li = 1 to pSafePointsInfo.count
    lSafePoint = pSafePointsInfo[li]
    if lTrackPos < lSafePoint.trackPos then
      if li > 1 then
        lSafePoint = pSafePointsInfo[li - 1]
      end if
      exit repeat
    end if
  end repeat
  lTokenId = lSafePoint.TokenId
  lLongitudinal = lSafePoint.longitudinal
  lTokenTangent = lSafePoint.tokenTangent
  lSafePos = lSafePoint.worldPos
  lTrasversalList = [0.0, -0.14999999999999999, 0.14999999999999999, 0.25]
  lTrasversal = lTrasversalList[kVehicle.GetPlayer().GetPlayerId()]
  lNewPosition = gGame.GetTokenManager().TokenToWorld(lTokenId, lLongitudinal, lTrasversal)
  lNewPosition.z = lSafePos.z
  lModelList = gGame.GetCullingManager().GetCullerBlockModels(lNewPosition)
  lArguments = [#maxNumberOfModels: 5, #levelOfDetail: #detailed, #modelList: lModelList]
  lIntersections = gGame.Get3D().modelsUnderRay(lNewPosition + vector(0, 0, 200), vector(0.0, 0.0, -1.0), lArguments)
  repeat with lIntersection in lIntersections
    if lIntersection[1].name starts "l_t" then
      lGroundPosition = lIntersection.isectPosition
      lNewPosition.z = lGroundPosition.z + 200.0
      exit repeat
    end if
  end repeat
  lRefDirection = vector(0.0, 1.0, 0.0)
  lAngleBtw = lTokenTangent.angleBetween(lRefDirection)
  lVersus = lTokenTangent.crossProduct(lRefDirection)
  if lVersus.z >= 0.0 then
    lAngleBtw = -lAngleBtw
  end if
  kVehicle.SetCurrentToken(lTokenId)
  kVehicle.SetLongitudinal(lLongitudinal)
  kVehicle.SetTrasversal(lTrasversal)
  lRes = kVehicle.GetChassisRB().interpolatingMoveTo(lNewPosition, [vector(0.0, 0.0, 1.0), lAngleBtw])
end

on ShowLapTime me
  lLap = gGame.GetPlayerVehicle().GetVehicle().pLap
  lPartialsHumanPlayer = pPartialResults[1]
  lCurrentLapTime = lPartialsHumanPlayer[lLap]
  lPrecedentLapTime = 0.0
  lLapTime = lCurrentLapTime - lPrecedentLapTime
  lGap = abs(gGame.GetBestTime() - lLapTime)
  lGapSign = "+"
  if (gGame.GetBestTime() = -1) or (gGame.GetBestTime() > lLapTime) then
    lGapSign = "-"
    if gGame.GetBestTime() = -1 then
      lGapString = "--:--:--"
    else
      lGapString = lGapSign & MillisecondsToTime(lGap, 1)
    end if
    gGame.SetBestTime(lLapTime)
    gGame.SetRecordOnBestTime(1)
    gGame.GetInGame().UpdateBestTime(lLapTime)
    gGame.GetGameSoundManager().PlaySound("snd_best_lap", 1)
  end if
  lTimeString = MillisecondsToTime(lLapTime, 1)
  gGame.GetInGame().ShowRecordPopup(3000, lTimeString, lGapString)
end

on SavePartialTime me, kVehicleId, kLap, kTime
  lPartialTime = pPartialResults[kVehicleId]
  if lPartialTime.count < kLap then
    lPartialTime.add(kTime)
    return #TimeSaved
  end if
  return #AlreadyPres
end

on CheckFinishLine me, kTime
  if pStartPlaneTimer <> -1 then
    if (kTime - pStartPlaneTimer) > 10000.0 then
      pStartPlaneTimer = -1
      pStartPlaneRef.visibility = #front
    end if
  end if
  lPlayers = gGame.GetPlayers()
  repeat with li = 1 to lPlayers.count
    lPlayerRef = lPlayers[li]
    lVehicleRef = lPlayerRef.GetVehicle()
    if lVehicleRef.GetCurrentToken() <> #t1 then
      next repeat
    end if
    lFinishLine = pFinishLine.Check(lVehicleRef.getPosition(), lVehicleRef.GetPreviousPosition())
    if lFinishLine[1] <> #none then
      if lFinishLine[1] = #finish_front then
        lVehicleRef.pLap = lVehicleRef.pLap + 1
        if lPlayerRef.GetPlayerId() = 1 then
          lNewHudCurrentLap = lVehicleRef.pLap + 1
          lHudCurrentLap = gGame.GetInGame().GetCurrentLap()
          if (lNewHudCurrentLap > lHudCurrentLap) and (lNewHudCurrentLap <= me.GetRaceLaps()) then
            gGame.GetInGame().UpdateLapNumber(lNewHudCurrentLap)
            if lNewHudCurrentLap = me.GetRaceLaps() then
              gGame.GetInGame().AddLastLapOverlay()
            end if
          end if
        end if
        if lVehicleRef.pLap = me.GetRaceLaps() then
          if lPlayerRef = gGame.GetPlayerVehicle() then
            gGame.GetSequenceManager().StartSequence("LevelEndNormal")
          end if
          lVehicleRef.pRaceTime = me.GetGameplayTime()
        end if
        lTimeSavedResult = me.SavePartialTime(lPlayerRef.GetPlayerId(), lVehicleRef.pLap, me.GetGameplayTime())
        if (lPlayerRef.GetPlayerId() = 1) and (lTimeSavedResult = #TimeSaved) then
          if lVehicleRef.pLap = me.GetRaceLaps() then
            me.ShowLapTime()
          else
            gGame.GetGameSoundManager().PlaySound("snd_popup_lap", 1)
          end if
        end if
        if lPlayerRef.GetPlayerId() = 1 then
          pStartPlaneRef.visibility = #none
          if lVehicleRef.pLap = (me.GetRaceLaps() - 1) then
            pStartPlaneTimer = kTime
            pStartPlaneRef.shader = pFinishShaderRef
          else
            if lVehicleRef.pLap = (me.GetRaceLaps() - 2) then
              pStartPlaneTimer = kTime
              pStartPlaneRef.shader = pLastLapShaderRef
            end if
          end if
        end if
        next repeat
      end if
      if lFinishLine[1] = #finish_back then
        lVehicleRef.pLap = lVehicleRef.pLap - 1
      end if
    end if
  end repeat
end

on SetupUIQuitPopup me
end

on UpdateTime me
  if gGame.GetGameStatus() <> #play then
    return 
  end if
  lNow = gGame.GetTimeManager().GetTime()
  if pTimeCountUp = 1 then
    lMillisecondsElapsed = lNow - pStartRaceTime
  else
    lMillisecondsElapsed = pMaxTime - (lNow - pStartRaceTime)
    if (lMillisecondsElapsed < 0) and not pTimeElapsedFlag then
      pTimeElapsedFlag = 1
      gGame.GetSequenceManager().StartSequence("LevelEndTimeOut")
    end if
  end if
  pRaceTime = lNow - pInitialStartRaceTime
  pGameplayTime = lMillisecondsElapsed
  if pTimeCountUp = 0 then
    me.HandleHurryUp()
  end if
  lActualTime = gGame.GetTimeManager().GetTime()
  lUpdateHudTime = gGame.GetInGame().GetHudValue(#TimeTimer)
  if (lActualTime - lUpdateHudTime) > 150 then
    gGame.GetInGame().UpdateTime(pGameplayTime)
    gGame.GetInGame().SetHudValue(#TimeTimer, lActualTime)
  end if
end

on HandleHurryUp me
  lHurryUpTime = 10000
  if pGameplayTime < lHurryUpTime then
    lIsTimeBlinking = gGame.GetInGame().GetHudValue(#IsTimeBlinking)
    if not lIsTimeBlinking then
      gGame.GetInGame().SetHudValue(#IsTimeBlinking, 1)
      gGame.GetBlinkManager().AddElement("tf_time", gGame.GetTimeManager().GetTime(), 500, 500, lHurryUpTime)
      gGame.GetInGame().ShowHurryUpPopup(1000)
      gGame.GetGameSoundManager().PlayHurryUpSound()
    end if
  else
    lIsTimeBlinking = gGame.GetInGame().GetHudValue(#IsTimeBlinking)
    if lIsTimeBlinking then
      if pGameplayTime >= lHurryUpTime then
        gGame.GetGameSoundManager().StopHurryUpSound()
        gGame.GetInGame().SetHudValue(#IsTimeBlinking, 0)
        gGame.GetBlinkManager().RemoveElement("tf_time")
      end if
    end if
  end if
end

on UpdateScore me, fScore
  gGame.SetPlayerScore(gGame.GetPlayerScore() + fScore)
  gGame.GetInGame().SetHudValue(#PlayerScore, gGame.GetPlayerScore())
  gGame.GetInGame().UpdateScore()
  gGame.GetInGame().AddRandomScoreOverlay("f_" & fScore)
end

on BonusManagementCallback me, fBonusHitType, fBonus, fPlayerRef
  if voidp(fPlayerRef) then
    fPlayerRef = gGame.GetPlayerVehicle()
  end if
  if gGame.GetGameStatus() = #play then
    if fBonus.Check(fPlayerRef.getPosition()) then
      case fBonusHitType.effect of
        #money:
          if fPlayerRef.GetPlayerId() = 1 then
            gGame.GetGameSoundManager().PlaySound("snd_bonus_money", 6)
            me.UpdateScore(200)
          end if
        #shield:
          if fPlayerRef.GetPlayerId() = 1 then
            gGame.GetGameSoundManager().PlaySound("snd_presa_bonus", 6)
            gGame.GetInGame().ShowActiveWeapon(#shield)
          end if
          fPlayerRef.SetCurrentWeapon(#god)
        #missile:
          if fPlayerRef.GetPlayerId() = 1 then
            gGame.GetGameSoundManager().PlaySound("snd_presa_bonus", 6)
            gGame.GetInGame().ShowActiveWeapon(#missile)
          end if
          fPlayerRef.SetCurrentWeapon(#missile)
        #bolt:
          if fPlayerRef.GetPlayerId() = 1 then
            gGame.GetGameSoundManager().PlaySound("snd_presa_bonus", 6)
            gGame.GetInGame().ShowActiveWeapon(#bolt)
          end if
          fPlayerRef.SetCurrentWeapon(#electric)
      end case
    end if
  end if
end

on CheckpointManagementCallback me, fCheckpointHit, fResult, fPlayerId
  if voidp(fPlayerId) then
    fPlayerRef = gGame.GetPlayerVehicle().GetVehicleController()
  else
    fPlayerRef = gGame.GetPlayers()[fPlayerId]
  end if
  if fCheckpointHit.pType = #generic then
    lAction = fResult[1]
    lDatas = fResult[2]
    case lAction of
      #Bonus_in:
        lDatas.mdl.addToWorld()
      #Bonus_out:
        lDatas.mdl.removeFromWorld()
    end case
  else
    if fCheckpointHit.pType = #object then
      lObject = fResult[1]
      lDatas = fResult[2]
      lInOut = fResult[3]
      if lInOut = #in then
        lObject.ExecuteInAction(lDatas, fPlayerRef)
      else
        if lInOut = #out then
          lObject.ExecuteOutAction(lDatas, fPlayerRef)
        end if
      end if
    end if
  end if
end

on ChecklineManagementCallback me, fResult, fCheckLine
  if fCheckLine.pType = #generic then
    lAction = fResult[1]
    lDatas = fResult[2]
  else
    if fCheckLine.pType = #object then
      lObject = fResult[1]
      lDatas = fResult[2]
      lInOut = fResult[3]
      if lInOut = #front then
        lObject.ExecuteFrontAction(lDatas)
      else
        if lInOut = #back then
          lObject.ExecuteBackAction(lDatas)
        end if
      end if
    end if
  end if
end

on AddExplosiveObject me, kExplosiveObjectPosition, kRadius, kRotationVector, kModel, kOneShoot, kRespawnTime, kUserData
end

on ExplosiveObjCallback me, kPos, kModelRef, kPlayerRef
  if gGame.GetGameStatus() = #play then
  end if
end

on MissileStartCallBack me, kPlayerRef, kEffectName, kMdl
  lParticleProperties = gGame.GetParticlesManager().GetEmitter(#MissileWhiteSmoke)
  lParticleTexture = gGame.GetParticlesManager().GetTexture("fx_fumo_bianco_dyn")
  lEmitterRegion = [vector(0.0, -175.0, 0.0)]
  lDir = vector(0, 0, 1)
  lParticleEffect = script("Particles").new(gGame.Get3D(), kEffectName, lParticleTexture, lEmitterRegion, lDir, lParticleProperties)
  gGame.GetParticlesManager().AddParticles(kEffectName, lParticleEffect, kMdl, -1, -1)
  gGame.GetParticlesManager().StartParticle(kEffectName)
end

on MissileExplosionCallBack me, kTarget, kExplosionPos, kEffectName
  lPlayers = gGame.GetPlayers()
  repeat with li = 1 to lPlayers.count
    lPlayerRef = lPlayers[li]
    if not lPlayerRef.IsUnderWeaponEffect() and not lPlayerRef.GodMode() then
      lDistanceFromExplosion = kExplosionPos - lPlayerRef.getPosition()
      lDistanceFromExplosion.z = 0
      lDistanceFromExplosion = lDistanceFromExplosion.magnitude
      if lDistanceFromExplosion < 280.0 then
        lPlayerRef.GetVehicle().StartMissileEffect()
        if not lPlayerRef.GetUnderMissile() then
          lPlayerRef.SetUnderMissile(1)
        end if
      end if
    end if
  end repeat
  gGame.GetGameSoundManager().PlayExplosionSound(kExplosionPos)
  gGame.GetParticlesManager().StopParticle(kEffectName)
  gGame.GetParticlesManager().DeleteByName(kEffectName)
  gGame.GetExplosionManager().AddActiveExplosion(kExplosionPos, 150.0)
end

on BlockOnStartPos_OLD me
  lPlayers = gGame.GetPlayers()
  repeat with li = 1 to lPlayers.count
    lVehicleRef = lPlayers[li].GetVehicle()
    lTR = lVehicleRef.GetTransform()
    lRb = lVehicleRef.GetChassisRB()
    lRb.linearVelocity = vector(0.0, 0.0, 0.0)
  end repeat
end

on BlockOnStartPos me
  lPlayers = gGame.GetPlayers()
  repeat with li = 1 to lPlayers.count
    lPlayers[li].GetVehicle().setPosition(pStartPositionList[li][1], pStartPositionList[li][2])
  end repeat
end
