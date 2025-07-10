property pConfiguration, pProfilerActive, pGameplay, pInGame, pOffgame, pcamera, pAutoPauseState, pCameraUpdatePlace, pProfiler, pExitCode, pVersionId, p3D, p3DSprite, pHavokPhysics, pKeyEvents, pispaused, pGameType, pOffGameAudioState, pOffGameMusicState, pPreilluminationEnabled, pPreilluminationCalculate, pPreilluminationDataMember, pPreilluminationOutputMember, pPreilluminationBlendType, pSoundStateBeforePause, pIngameScriptName, pCameraScriptName, pScore, pTutorialEnabled, pGameStatus, pResourceTool, pTimeFactorBackup, pAllowAutopause, pGameplayStartState, pPauseTempo, pUnpauseTempo, pOffgamePaused, pLockTime, pUseNewOverlayManager, pDayId, pTutorialId, pPauseWithTimeWarp, pConfigLoader, pConfigPath, pDataPath, pServerConnection, pTimeManager, pSoundManager, pBlinkManager, pOverlayManager, pCullingManager, pInputManager, pTextureShifter, pBonusManager, pCheckpointManager, pCheckLineManager, pParticlesManager, pFlyingOverlayManager, pSpriteFxManager, pSequenceManager, pExplosiveObjectManager, pTokenManager, pPathManager, pCarsManager, pSkyManager, pAnimationManager, pEngineSoundManager
global gRequestPause

on new me
  pConfiguration = #debug
  pProfilerActive = 0
  pGameplay = VOID
  pInGame = VOID
  pOffgame = VOID
  pcamera = VOID
  pProfiler = VOID
  pVersionId = "Ver.0.00"
  pExitCode = 0
  p3D = VOID
  p3DSprite = VOID
  pHavokPhysics = VOID
  pispaused = 0
  pInputManager = VOID
  pTimeManager = VOID
  pOverlayManager = VOID
  pBlinkManager = VOID
  pFlyingOverlayManager = VOID
  pSpriteFxManager = VOID
  pSequenceManager = VOID
  pAnimationManager = VOID
  pEngineSoundManager = VOID
  pKeyEvents = []
  pGameType = #championship
  pOffGameAudioState = 1
  pOffGameMusicState = 1
  pAutoPauseState = #none
  pIngameScriptName = VOID
  pCameraScriptName = VOID
  pPreilluminationEnabled = 0
  pPreilluminationCalculate = 0
  pPreilluminationDataMemberIndex = VOID
  pPreilluminationOutputMemberIndex = VOID
  pPreilluminationBlendType = #multiply
  pScore = 0
  pTutorialEnabled = 1
  pResourceTool = VOID
  pGameStatus = #Init
  pCameraUpdatePlace = #prepareFrame
  pTimeFactorBackup = 1.0
  pAllowAutopause = 1
  pGameplayStartState = #GameStart
  pPauseTempo = 5
  pUnpauseTempo = 300
  pOffgamePaused = 0
  pLockTime = -1
  pUseNewOverlayManager = 0
  pPauseWithTimeWarp = 1
  pConfigLoader = VOID
  pConfigPath = "dswmedia\"
  pDataPath = "dswmedia\"
  pServerConnection = VOID
  return me
end

on Initialize me, kGameplayScriptName, kIngameScriptName, kOffgameScriptName, kCameraScriptName
  pGameplay = script(kGameplayScriptName).new()
  pOffgame = script(kOffgameScriptName).new()
  pIngameScriptName = kIngameScriptName
  pCameraScriptName = kCameraScriptName
  pTimeFactorBackup = 1.0
end

on InitProfiler me
  pProfiler = script("Profiler").new()
  pProfiler.RegisterTask(#ROOT, "Root")
  pProfiler.RegisterTask(#Render, "Render")
  pProfiler.RegisterTask(#Physics, "Physics")
  pProfiler.RegisterTask(#GameUpdates, "Game updates")
  pProfiler.RegisterTask(#InGame, "InGame")
end

on DeactivateProfiler me
  pProfiler = VOID
end

on GetOverlayManager me
  return pOverlayManager
end

on GetChecklineManager me
  return pCheckLineManager
end

on GetTimeManager me
  return pTimeManager
end

on GetSequenceManager me
  return pSequenceManager
end

on GetSoundManager me
  return pSoundManager
end

on GetBlinkManager me
  return pBlinkManager
end

on GetInputManager me
  return pInputManager
end

on GetTextureShifter me
  return pTextureShifter
end

on GetBonusManager me
  return pBonusManager
end

on GetCheckpointManager me
  return pCheckpointManager
end

on GetCullingManager me
  return pCullingManager
end

on GetParticlesManager me
  return pParticlesManager
end

on GetFlyingOverlayManager me
  return pFlyingOverlayManager
end

on GetSpriteFxManager me
  return pSpriteFxManager
end

on GetPreilluminationEnabled me
  return pPreilluminationEnabled
end

on GetPreilluminationCalculate me
  return pPreilluminationCalculate
end

on GetPreilluminationDataMember me
  return pPreilluminationDataMember
end

on GetPreilluminationOutputMember me
  return pPreilluminationOutputMember
end

on GetPreilluminationBlendType me
  return pPreilluminationBlendType
end

on GetExplosiveObjectManager me
  return pExplosiveObjectManager
end

on GetTokenManager me
  return pTokenManager
end

on GetPathManager me
  return pPathManager
end

on GetCarsManager me
  return pCarsManager
end

on GetSkyManager me
  return pSkyManager
end

on GetAnimationManager me
  return pAnimationManager
end

on GetEngineSoundManager me
  return pEngineSoundManager
end

on GetCameraUpdatePlace me
  return pCameraUpdatePlace
end

on GetAllowAutopause me
  return pAllowAutopause
end

on GetGameplayStartState me
  return pGameplayStartState
end

on GetOffgamePaused me
  return pOffgamePaused
end

on GetPauseWithTimeWarp me
  return pPauseWithTimeWarp
end

on GetConfigLoader me
  return pConfigLoader
end

on GetConfigPath me
  return pConfigPath
end

on GetDataPath me
  return pDataPath
end

on GetServerConnection me
  return pServerConnection
end

on SetConfiguration me, kConf
  assert((kConf = #debug) or (kConf = #release_local) or (kConf = #release_web), "Invalid configuration")
  pConfiguration = kConf
end

on SetProfilerActive me, kFlag
  pProfilerActive = kFlag
end

on SetGameStatus me, kStatus
  pGameStatus = kStatus
end

on Set3D me, k3D
  p3D = k3D
end

on SetAutoPauseState me, kState
  pAutoPauseState = kState
end

on Set3DSprite me, k3DSprite
  p3DSprite = k3DSprite
end

on SetHavokPhysics me, kHavokPhysics
  pHavokPhysics = kHavokPhysics
end

on SetCullingManager me, kCullingManager
  pCullingManager = kCullingManager
end

on SetCheckpointManager me, kCheckPointManager
  pCheckpointManager = kCheckPointManager
end

on SetChecklineManager me, kCheckLineManager
  pCheckLineManager = kCheckLineManager
end

on SetExplosiveObjectManager me, kExplosiveObjectManager
  pExplosiveObjectManager = kExplosiveObjectManager
end

on SetTokenManager me, kTokenManager
  pTokenManager = kTokenManager
end

on SetSkyManager me, kSkyManager
  pSkyManager = kSkyManager
end

on SetGameType me, kGameType
  pGameType = kGameType
end

on SetVersionId me, kVersionId
  pVersionId = kVersionId
end

on SetExitCode me, kExitCode
  pExitCode = kExitCode
end

on SetOffGameAudioState me, kAudioState
  pOffGameAudioState = kAudioState
end

on SetOffGameMusicState me, kAudioState
  pOffGameMusicState = kAudioState
end

on SetPreillumination me, kPreilluminationEnabled, kPreilluminationCalculate, kPreilluminationDataMember, kPreilluminationOutputMember, kPreilluminationBlendType
  pPreilluminationEnabled = kPreilluminationEnabled
  pPreilluminationCalculate = kPreilluminationCalculate
  pPreilluminationDataMember = kPreilluminationDataMember
  pPreilluminationOutputMember = kPreilluminationOutputMember
  if voidp(kPreilluminationBlendType) then
    pPreilluminationBlendType = #multiply
  else
    pPreilluminationBlendType = kPreilluminationBlendType
  end if
end

on SetScore me, kScore
  pScore = kScore
end

on SetTutorialEnabled me, kState
  pTutorialEnabled = kState
end

on SetResourceTool me, kResourceTool
  pResourceTool = kResourceTool
end

on SetEngineSoundManager me, kEngineSoundManager
  pEngineSoundManager = kEngineSoundManager
end

on SetCameraUpdatePlace me, kCameraUpdatePlace
  pCameraUpdatePlace = kCameraUpdatePlace
end

on SetAllowAutopause me, kAllowAutopause
  pAllowAutopause = kAllowAutopause
end

on SetGameplayStartState me, kGameplayStartState
  pGameplayStartState = kGameplayStartState
end

on SetPauseTempo me, kPauseTempo
  pPauseTempo = kPauseTempo
end

on SetUnpauseTempo me, kUnpauseTempo
  pUnpauseTempo = kUnpauseTempo
end

on SetOffgamePaused me, kOffgamePaused
  pOffgamePaused = kOffgamePaused
end

on SetUseNewOverlayManager me, kFlag
  pUseNewOverlayManager = kFlag
end

on SetDayId me, kValue
  pDayId = kValue
end

on SetTutorialId me, kValue
  pTutorialId = kValue
end

on SetBonusManager me, kBonusManager
  pBonusManager = kBonusManager
end

on SetPauseWithTimeWarp me, kPauseWithTimeWarp
  pPauseWithTimeWarp = kPauseWithTimeWarp
end

on SetConfigLoader me, kConfigLoader
  pConfigLoader = kConfigLoader
end

on SetConfigPath me, kConfigPath
  pConfigPath = kConfigPath
end

on SetDataPath me, kDataPath
  pDataPath = kDataPath
end

on SetServerConnection me, kServerConnection
  pServerConnection = kServerConnection
end

on GetConfiguration me
  return pConfiguration
end

on GetProfilerActive me
  return pProfilerActive
end

on GetProfiler me
  return pProfiler
end

on GetGameStatus me
  return pGameStatus
end

on Get3D me
  return p3D
end

on Get3DSprite me
  return p3DSprite
end

on GetHavokPhysics me
  return pHavokPhysics
end

on GetHavok me
  if voidp(pHavokPhysics) then
    return VOID
  end if
  return pHavokPhysics.GetHavok()
end

on GetGameType me
  return pGameType
end

on GetVersionId me
  return pVersionId
end

on GetCamera me, kCamera
  return pcamera
end

on GetGameplay me
  return pGameplay
end

on GetOffGame me
  return pOffgame
end

on GetInGame me
  return pInGame
end

on GetExitCode me
  return pExitCode
end

on IsPaused me
  return pispaused
end

on GetOffGameAudioState me, kAudioState
  return pOffGameAudioState
end

on GetOffGameMusicState me
  return pOffGameMusicState
end

on GetScore me
  return pScore
end

on GetTutorialEnabled me
  return pTutorialEnabled
end

on GetResourceTool me
  return pResourceTool
end

on GetPauseTempo me
  return pPauseTempo
end

on GetUnpauseTempo me
  return pUnpauseTempo
end

on GetUseNewOverlayManager me
  return pUseNewOverlayManager
end

on GetDayId me
  return pDayId
end

on GetTutorialId me
  return pTutorialId
end

on AddScore me, kScore
  pScore = pScore + kScore
end

on EnablePhysics me
  if not voidp(pHavokPhysics) then
    pHavokPhysics.SetActive(1)
  end if
end

on DisablePhysics me
  if not voidp(pHavokPhysics) then
    pHavokPhysics.SetActive(0)
  end if
end

on IsPhysicsEnabled me
  if not voidp(pHavokPhysics) then
    return pHavokPhysics.IsActive()
  else
    return 0
  end if
end

on InitializeIngame me
  pInGame.Initialize(me.Get3D(), pOverlayManager)
end

on OnPreload me
  assert(0, "OnPreload")
end

on OnLoaded me
  assert(0, "OnLoaded")
end

on OnBegin me, kSprite, kOverlayCamera, kInitSpriteFx, kInitFlyingOverlays
  set the floatPrecision to 4
  me.Set3DSprite(kSprite)
  pInGame = script(pIngameScriptName).new()
  pcamera = script(pCameraScriptName).new()
  me.pcamera.SetCameraNode(kSprite.camera)
  pTimeManager = script("Time Manager").new(pGameplay)
  pTimeManager.InitTime()
  pSoundManager = script("Sound Manager").new("data/Music.txt", 200, 200)
  pSoundManager.SetAudioState(me.GetOffGameAudioState())
  pSoundManager.SetMusicState(me.GetOffGameMusicState())
  pSoundManager.LoadSounds()
  pInputManager = script("Input Manager").new()
  pInputManager.Initialize()
  if voidp(kOverlayCamera) then
    kOverlayCamera = kSprite.camera
  end if
  if pUseNewOverlayManager then
    pOverlayManager = script("overlay manager new").new(me.Get3D(), kOverlayCamera)
  else
    pOverlayManager = script("overlay manager").new(me.Get3D(), kOverlayCamera)
  end if
  lInitFlyingOverlays = 1
  if not voidp(kInitFlyingOverlays) then
    if kInitFlyingOverlays = 0 then
      lInitFlyingOverlays = 0
    end if
  end if
  if lInitFlyingOverlays then
    pFlyingOverlayManager = script("Flying Overlay Manager").new(me.Get3D(), kSprite.camera, pOverlayManager)
  end if
  lInitSpriteFx = 1
  if not voidp(kInitSpriteFx) then
    if kInitSpriteFx = 0 then
      lInitSpriteFx = 0
    end if
  end if
  if lInitSpriteFx then
    pSpriteFxManager = script("SpriteFx Manager").new(me.Get3D(), kSprite.camera, pOverlayManager)
  end if
  pBlinkManager = script("Blink Manager").new(pOverlayManager)
  pTextureShifter = script("Texture Shifter").new(me.Get3D())
  pParticlesManager = script("Particles Manager").new(pTimeManager)
  pSequenceManager = script("Sequence Manager").new(pTimeManager)
  pBonusManager = script("Bonus Manager").new(kSprite.camera)
  pAnimationManager = script("Animation Manager").new()
  if pPreilluminationCalculate then
    PrecalculateAndSavePreillumination(me.Get3D(), "lm_", pPreilluminationOutputMember, pPreilluminationDataMember)
  end if
  if pPreilluminationEnabled then
    ApplyPreilluminationFromCast(me.Get3D(), pPreilluminationOutputMember, pPreilluminationBlendType)
  end if
end

on onUpdate me
  assert(0, "OnUpdate")
end

on OnEnd me
  if not voidp(pHavokPhysics) then
    pHavokPhysics.shutDown()
  end if
  me.Get3D().unload()
  me.Get3D().resetWorld()
end

on OnTimeFactorUpdate me, fParam
  if fParam = #timefactorchanged then
    me.GetAnimationManager().RefreshPlayrates(me.GetTimeManager().GetTimeFactor())
  end if
end

on GetLoadPercent me
  return me.Get3D().percentStreamed
end

on IsLoaded me
  return me.Get3D().state = 4
end

on pause me
  if not me.GetTimeManager().IsInPauseTransition() then
    me.OnBeginPause()
  end if
end

on UnPause me
  if not me.GetTimeManager().IsInPauseTransition() then
    me.OnBeginUnpause()
  end if
end

on OnBeginPause me
  if pPauseWithTimeWarp then
    lCallback = [:]
    lCallback.addProp(#function, #GamePaused)
    lCallback.addProp(#script, me)
    lCurrentTimeFactor = pTimeManager.GetTimeFactor()
    pTimeFactorBackup = lCurrentTimeFactor
    pTimeManager.PauseWithTimeWarp(lCallback, 250, lCurrentTimeFactor, 0.0, "snd_popup")
  else
    lCurrentTimeFactor = pTimeManager.GetTimeFactor()
    pTimeFactorBackup = lCurrentTimeFactor
    me.GetAnimationManager().RefreshPlayrates(0.0)
    pTimeManager.PlayTimeWarpSound("snd_popup")
    pTimeManager.pispaused = 1
    me.GamePaused()
  end if
end

on LockGame me, kLockTime
  put "LOCK GAME"
  pLockTime = the milliSeconds + kLockTime
  lCallback = [:]
  lCallback.addProp(#function, #LockGameCallback)
  lCallback.addProp(#script, me.GetGameplay())
  lCurrentTimeFactor = pTimeManager.GetTimeFactor()
  pTimeFactorBackup = lCurrentTimeFactor
  pTimeManager.PauseWithTimeWarp(lCallback, 250, lCurrentTimeFactor, 0.0)
end

on UpdateLockGame me
  if pLockTime <> -1 then
    if the milliSeconds > pLockTime then
      put "UNLOCK GAME"
      lCallback = [:]
      lCallback.addProp(#function, #UnLockGameCallback)
      lCallback.addProp(#script, me.GetGameplay())
      lCurrentTimeFactor = pTimeManager.GetTimeFactor()
      pLockTime = -1
      pTimeManager.UnPauseWithTimeWarp(lCallback, 250, lCurrentTimeFactor, pTimeFactorBackup)
    end if
  end if
end

on OnBeginUnpause me
  if pPauseWithTimeWarp then
    lCallback = [:]
    lCallback.addProp(#function, #GameResumed)
    lCallback.addProp(#script, me)
    lCurrentTimeFactor = pTimeManager.GetTimeFactor()
    lDuration = 350
    pTimeManager.UnPauseWithTimeWarp(lCallback, lDuration, lCurrentTimeFactor, pTimeFactorBackup)
  else
    pTimeManager.pispaused = 0
    pTimeManager.UnPauseWithOutTimeWarp()
    me.GameResumed()
    me.GetAnimationManager().RefreshPlayrates(pTimeFactorBackup)
  end if
end

on RequestQuitGame me
  if pPauseWithTimeWarp then
    lCallback = [:]
    lCallback.addProp(#function, #QuitRequested)
    lCallback.addProp(#script, me)
    lCurrentTimeFactor = pTimeManager.GetTimeFactor()
    pTimeFactorBackup = lCurrentTimeFactor
    pTimeManager.PauseWithTimeWarp(lCallback, 350, lCurrentTimeFactor, 0.0, "snd_popup")
  else
    lCurrentTimeFactor = pTimeManager.GetTimeFactor()
    pTimeFactorBackup = lCurrentTimeFactor
    me.GetAnimationManager().RefreshPlayrates(0.0)
    pTimeManager.PlayTimeWarpSound("snd_popup")
    pTimeManager.pispaused = 1
    me.QuitRequested()
  end if
end

on ResumeFromQuitGame me
  if me.GetInGame().GetPausePopupShown() then
    me.ResumedFromQuit()
    me.GetInGame().SetQuitPopupShown(0)
  else
    if pPauseWithTimeWarp then
      lCallback = [:]
      lCallback.addProp(#function, #ResumedFromQuit)
      lCallback.addProp(#script, me)
      lCurrentTimeFactor = pTimeManager.GetTimeFactor()
      lDuration = 350
      pTimeManager.UnPauseWithTimeWarp(lCallback, lDuration, lCurrentTimeFactor, pTimeFactorBackup)
    else
      pTimeManager.pispaused = 0
      pTimeManager.UnPauseWithOutTimeWarp()
      me.ResumedFromQuit()
      me.GetAnimationManager().RefreshPlayrates(pTimeFactorBackup)
    end if
  end if
end

on GamePaused me
  put "GamePaused"
  pispaused = 1
  lSoundManager = me.GetSoundManager()
  pSoundStateBeforePause = lSoundManager.GetAudioState()
  lSoundManager.SetAudioState(0)
  lSoundManager.PauseAllSoundChannels()
  _movie.puppetTempo(pPauseTempo)
end

on GameResumed me
  put "GameResumed"
  pispaused = 0
  _movie.puppetTempo(pUnpauseTempo)
  if pSoundStateBeforePause then
    lSoundManager = me.GetSoundManager()
    lSoundManager.SetAudioState(pSoundStateBeforePause)
    lSoundManager.ResumeAllSoundChannels()
  end if
end

on GetSoundStateBeforePause me
  return pSoundStateBeforePause
end

on OnMouseDown me
  if me.GetOffgamePaused() then
    ActivateGame()
  end if
  if IsInGame() then
    if not voidp(me.GetInGame()) then
      me.GetInGame().CheckPopupButtons()
    end if
  end if
end

on QuitRequested me
  put "QuitRequested"
end

on ResumedFromQuit me
  put "ResumedFromQuit"
  me.GetInGame().SetQuitPopupShown(0)
end

on exit me, kExitCode
  pExitCode = kExitCode
end

on SendKeyEvent me, kEvent
  pKeyEvents.append(kEvent)
end

on GetNextKeyEvent me
  lEventsCount = pKeyEvents.count
  if lEventsCount > 0 then
    lEvent = pKeyEvents[lEventsCount]
    pKeyEvents.deleteAt(lEventsCount)
    return lEvent
  else
    return VOID
  end if
end

on FlushKeyEvents me
  pKeyEvents = []
end

on update me
  me.UpdateLockGame()
  if pExitCode = 0 then
    pTimeManager.UpdateTime()
    lTime = pTimeManager.GetTime()
    pInputManager.update()
    if not me.IsPaused() then
      if not voidp(pHavokPhysics) then
        STARTPROFILE(#Physics)
        pHavokPhysics.update(pTimeManager.GetDeltaTime())
        ENDPROFILE()
      end if
      pGameplay.update(lTime)
      if pCameraUpdatePlace = #prepareFrame then
        pcamera.update(lTime)
      end if
    end if
    if not me.IsPaused() then
      pBlinkManager.update(lTime)
      pTextureShifter.update(lTime)
      if not voidp(pFlyingOverlayManager) then
        pFlyingOverlayManager.update(lTime)
      end if
      if not voidp(pSpriteFxManager) then
        pSpriteFxManager.update(lTime)
      end if
    end if
    lRealTime = me.GetTimeManager().GetRealTime()
    if pSequenceManager.UpdateSynchronized(lRealTime) then
      me.GetSequenceManager().ResetElements()
    end if
    me.GetParticlesManager().update(lTime)
    if (gRequestPause > 0) and not me.IsPaused() then
      gRequestPause = gRequestPause - 1
      if gRequestPause = 0 then
        me.pause()
        gRequestPause = -1
      end if
    end if
    STARTPROFILE(#GameUpdates)
    me.onUpdate()
    ENDPROFILE()
    if not me.IsPaused() then
      if pCameraUpdatePlace = #PrepareFrameEnd then
        pcamera.update(lTime)
      end if
    end if
    STARTPROFILE(#InGame)
    pInGame.update(lTime)
    ENDPROFILE(#InGame)
  end if
end

on ExitFrameUpdate me
  lTime = pTimeManager.GetTime()
  if (pCameraUpdatePlace = #exitFrame) and not me.IsPaused() then
    pcamera.update(lTime)
  end if
end
