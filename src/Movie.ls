global gGame, gRequestPause, gScoreToTrace, gScoreChart, MiniclipGameManager

on mouseDown
  if not voidp(gGame) then
    gGame.OnMouseDown()
  end if
end

on IsInGame
  if (the frame >= 15) and (the frame <= 60) then
    return 1
  else
    return 0
  end if
end

on IsOffGame
  if (the frame >= 8) and (the frame <= 13) then
    return 1
  else
    return 0
  end if
end

on GotoOffGame
  go(8)
end

on flash_openURL me, strURL
  gotoNetPage(strURL, "_new")
end

on openURL me, strURL
  gotoNetPage(strURL)
end

on flash_quit_to_windows
  gotoNetPage("javaScript:CloseWindow()")
  halt()
end

on flash_quit_to_windows_projector
  quit()
end

on shockwaveTrackGamePlayEvent
  if not voidp(gGame) then
    if gGame.GetConfiguration() <> #debug then
      gotoNetPage("javascript:trackGamePlayEvent()")
    end if
  end if
end

on prepareMovie
  OnPrepareMovie()
end

on stopMovie
  if not voidp(gGame) then
    gGame.OnEnd()
  end if
end

on deactivateApplication
  DeactivateGame()
end

on activateApplication
  ActivateGame()
end

on deactivateWindow
  DeactivateGame()
end

on activateWindow
  ActivateGame()
end

on OnPrepareMovie
  _movie.exitLock = 1
  gGame = VOID
  cursor(200)
end

on DeactivateGame
  if voidp(gGame) then
    return 
  end if
  if not gGame.GetAllowAutopause() and not IsOffGame() then
    return 
  end if
  cursor(0)
  _player.appMinimize()
  gRequestPause = 2
  if IsOffGame() then
    lOffGame = gGame.GetOffGame()
    lOffGameSprite = lOffGame.GetSprite()
    if not voidp(lOffGameSprite) then
      _movie.puppetTempo(2)
      if not voidp(lOffGameSprite.StopMusic) then
        lOffGameSprite.StopMusic()
      end if
      gGame.SetOffgamePaused(1)
    end if
  end if
  lInputManager = gGame.GetInputManager()
  if not voidp(lInputManager) then
    if gGame.GetConfiguration() = #debug then
      lInputManager.SetActive(0)
    end if
    if IsInGame() then
      gGame.SetAutoPauseState(#pauserequested)
    end if
  end if
end

on ActivateGame
  if voidp(gGame) then
    return 
  end if
  gRequestPause = -1
  if IsOffGame() then
    lOffGame = gGame.GetOffGame()
    lOffGameSprite = lOffGame.GetSprite()
    if not voidp(lOffGameSprite) then
      _movie.puppetTempo(25)
      gGame.SetOffgamePaused(0)
      lOffGameSprite.StartMusic()
      cursor(0)
    else
      cursor(200)
    end if
  end if
  lInputManager = gGame.GetInputManager()
  if not voidp(lInputManager) then
    if IsInGame() then
      gGame.SetAutoPauseState(#resumerequested)
    end if
    if gGame.GetConfiguration() = #debug then
      lInputManager.SetActive(1)
    end if
  end if
end

on startMovie
  _movie.enableFlashLingo = 1
end

on validDomain
  validDomains = ["miniclip.com", "miniclip.net", "miniclip.co.uk", "miniclips.com", "silentbaystudios.com", "silentbay.developers.miniclip.com"]
  repeat with sDomain in validDomains
    if the moviePath contains sDomain then
      return 1
    end if
  end repeat
  return 0
end

on validDomainLandini
  validDomains = ["landini.it", "landini.com", "silentbaystudios.com"]
  repeat with sDomain in validDomains
    if the moviePath contains sDomain then
      return 1
    end if
  end repeat
  return 0
end

on validDomainEnelDucati
  lDomain = "217.72.98.127"
  if externalParamCount() > 0 then
    lSw9 = externalParamValue("sw9")
    if not voidp(lSw9) then
      if lSw9 <> EMPTY then
        lDomain = urlDecode(lSw9)
      end if
    end if
  end if
  validDomains = ["silentbaystudios.com"]
  validDomains.add(lDomain)
  repeat with sDomain in validDomains
    if the moviePath contains sDomain then
      return 1
    end if
  end repeat
  return 0
end

on validDomainPirelli
  validDomains = ["pirelli.it", "nurun.it", "pirellityre.com", "pirellityre.it", "silentbaystudios.com", "pirelli.com"]
  repeat with sDomain in validDomains
    if the moviePath contains sDomain then
      return 1
    end if
  end repeat
  return 0
end

on validDomainNissan
  lPostURL = "http://213.215.197.45/"
  if externalParamCount() > 0 then
    lSw8 = externalParamValue("sw8")
    if not voidp(lSw8) then
      if lSw8 <> EMPTY then
        lPostURL = urlDecode(lSw8)
      end if
    end if
  end if
  lDomain = chars(lPostURL, 8, lPostURL.length - 1)
  validDomains = ["silentbaystudios.com", "nissan-4x4challenge.it"]
  validDomains.add(lDomain)
  repeat with sDomain in validDomains
    if the moviePath contains sDomain then
      return 1
    end if
  end repeat
  return 0
end

on validDomainColacao
  validDomains = ["silentbaystudios.com", "comoquierascolacao.com", "es.games.yahoo.com", "colacao.com", "demos.mediacontacts.com", "colacaoxtremegames.es"]
  repeat with sDomain in validDomains
    if the moviePath contains sDomain then
      return 1
    end if
  end repeat
  return 0
end

on validDomainSBS
  return 1
end

on validDomainShockwave
  if externalParamValue("src") starts "http:" then
    return 0
  end if
  validDomains = ["shockwave.com", "developertestdomain.com", "silentbaystudios.com"]
  repeat with sDomain in validDomains
    if the moviePath contains sDomain then
      return 1
    end if
  end repeat
  return 0
end

on validDomainFlashAndDash
  if externalParamValue("src") starts "http:" then
    return 0
  end if
  validDomains = ["flash-and-dash.com", "flash-and-dash.co.uk", "silentbaystudios.com", "testaluna.it"]
  repeat with sDomain in validDomains
    if the moviePath contains sDomain then
      return 1
    end if
  end repeat
  return 0
end

on validDomainSpillGames
  if externalParamValue("src") starts "http:" then
    return 0
  end if
  validDomains = ["www8.agame.com", "gamedev.dev.spillgroup.com", "silentbaystudios.com"]
  repeat with sDomain in validDomains
    if the moviePath contains sDomain then
      return 1
    end if
  end repeat
  return 0
end

on validDomainZapak
  validDomains = ["zapak.com", "silentbaystudios.com", "zapakkids.com", "zapakgirls.com", "zapakworld.com"]
  repeat with sDomain in validDomains
    if the moviePath contains sDomain then
      return 1
    end if
  end repeat
  return 0
end

on validDomainESPN
  return 1
  validDomains = ["silentbaystudios.com", "espn.go.com"]
  repeat with sDomain in validDomains
    if the moviePath contains sDomain then
      return 1
    end if
  end repeat
  return 0
end

on GetUrl me, tStringFromFlash, tName
  gotoNetPage(tStringFromFlash, tName)
end

on CheckForExpiration fExpireDay, fExpireMonth, fExpireYear
  return 1
  lResult = 1
  lFilePath = getOSDirectory() & "\a1zw25j"
  lFileObj = new(xtra("fileIO"))
  lFileObj.openfile(lFilePath, 1)
  if not (lFileObj.status() <> 0) then
    lResult = 0
  end if
  closeFile(lFileObj)
  lFileObj = 0
  if lResult and (the systemDate > date(fExpireYear, fExpireMonth, fExpireDay)) then
    lFileObj = new(xtra("fileIO"))
    createFile(lFileObj, lFilePath)
    openfile(lFileObj, lFilePath, 0)
    lContent = "init env"
    writeString(lFileObj, string(lContent))
    closeFile(lFileObj)
    lFileObj = 0
    lResult = 0
  end if
  return lResult
end

on SendToHighScore me, kGame, kScoreLoc, kSave, kTime, kReverse, kMulti, kSuffix
  gScoreToTrace = kScoreLoc
  gScoreChart = kSuffix
  if not GetBool(kSave) then
    go(11)
  else
    go(12)
  end if
end

on ShowMiniclipAdvert me, spriteNum
  sprite(integer(spriteNum)).visible = 1
end

on HideMiniclipAdvert me, spriteNum
  sprite(integer(spriteNum)).visible = 0
end

on ShowHighScoreMiniclip me, kGame, kScoreLoc, kSave, kTime, kReverse, kMulti, kSuffix
  gScoreToTrace = kScoreLoc
  gScoreChart = kSuffix
  if not objectp(MiniclipGameManager) then
    return 
  end if
  go(11)
  if not GetBool(kSave) then
    MiniclipGameManager.services.showHighScores(3, "Miniclip Back To Game")
  else
    MiniclipGameManager.services.saveHighScore(kScoreLoc, 3, "Miniclip Back To Game")
  end if
end

on HideHighScore a
  go(10)
end

on flash_start_game me
  go(8)
end

on flash_start_checker me
  go(the frame + 1)
end

on flash_start_intro me
  go(4)
end

on flash_onrollover me
  cursor(280)
end

on flash_onrollout me
  cursor(-1)
end

on ConvertCheckpointActions lStrValue
  lRet = #none
  case lStrValue of
    "#SchoolIn":
      lRet = #SchoolIn
    "#SchoolOut":
      lRet = #SchoolOut
    "#MechanicIn":
      lRet = #MechanicIn
    "#MechanicOut":
      lRet = #MechanicOut
    "#Tut_expl":
      lRet = #Tut_expl
    "#Tut_rail":
      lRet = #Tut_rail
    "#Tut_toxic":
      lRet = #Tut_toxic
  end case
  return lRet
end

on ConvertChecklineActions lStrValue
  lRet = #none
  case lStrValue of
    "#SilosIn":
      lRet = #SilosIn
    "#SilosOut":
      lRet = #SilosOut
    "#TunnelBegin":
      lRet = #TunnelBegin
    "#TunnelEnd":
      lRet = #TunnelEnd
    "#FogBegin":
      lRet = #FogBegin
    "#FogEnd":
      lRet = #FogEnd
    "#ParkSilosIn":
      lRet = #ParkSilosIn
    "#SurpBendBegin":
      lRet = #SurpBendBegin
    "#SurpBendEnd":
      lRet = #SurpBendEnd
    "#SurpBegin":
      lRet = #SurpBegin
    "#SurpEnd":
      lRet = #SurpEnd
  end case
  return lRet
end

on RemoveBeginReturn fString
  lString = fString
  if charToNum(chars(fString, 1, 1)) = 10 then
    lString = chars(fString, 2, lString.length)
  end if
  return lString
end

on readWord fString, fI
  li = fI
  lReturnString = EMPTY
  lReturnCode = #none
  repeat while 1
    lChar = chars(fString, li, li)
    if li > fString.length then
      lReturnCode = #endstring
    else
      if lChar = RETURN then
        lReturnCode = #newline
      else
        if lChar = " " then
          lReturnCode = #space
        end if
      end if
    end if
    if lReturnCode <> #none then
      exit repeat
    end if
    lReturnString = lReturnString & lChar
    li = li + 1
  end repeat
  return [lReturnString, li, lReturnCode]
end

on ReadWordUserData fString, fI
  li = fI
  lReturnString = EMPTY
  lReturnCode = #none
  repeat while 1
    lChar = chars(fString, li, li)
    if li > fString.length then
      lReturnCode = #endstring
    else
      if lChar = " " then
        lReturnCode = #space
      else
        if lChar = "," then
          lReturnCode = #endValue
        else
          if lChar = ":" then
            lReturnCode = #endProp
          end if
        end if
      end if
    end if
    if lReturnCode <> #none then
      exit repeat
    end if
    lReturnString = lReturnString & lChar
    li = li + 1
  end repeat
  return [lReturnString, li, lReturnCode]
end

on ParseUserData fUserDataString
  lRetUserData = [:]
  lIndex = 0
  repeat while 1
    lPropCode = #none
    repeat while lPropCode <> #endProp
      lWordResult = ReadWordUserData(fUserDataString, lIndex + 1)
      lProp = lWordResult[1]
      lIndex = lWordResult[2]
      lPropCode = lWordResult[3]
    end repeat
    lValueCode = #none
    repeat while (lValueCode <> #endValue) and (lValueCode <> #endstring)
      lWordResult = ReadWordUserData(fUserDataString, lIndex + 1)
      lValue = lWordResult[1]
      lIndex = lWordResult[2]
      lValueCode = lWordResult[3]
    end repeat
    lRetUserData.addProp(lProp, lValue)
    if lValueCode = #endstring then
      exit repeat
    end if
  end repeat
  return lRetUserData
end

on STARTPROFILE kTaskSym
  if gGame.GetProfilerActive() then
    gGame.GetProfiler().STARTPROFILE(kTaskSym)
  end if
end

on ENDPROFILE
  if gGame.GetProfilerActive() then
    gGame.GetProfiler().ENDPROFILE()
  end if
end

on doFlashTracker me, kURL
  if (the environment)[#runMode] <> "Author" then
    gotoNetPage("javaScript:flashTracker('" & kURL & "');")
  end if
end
