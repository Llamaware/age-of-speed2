property pTimeSample1, pTimeSample2, pVirtualTime, pRealTime, pLastTime, pDeltaTime, pispaused, pTimeFactor, pPauseTime, pPauseEffect, pEffectQueue, pTimeWarpingEffectActive, pWarpSoundInitTime, pTimeCompensationEnabled, pTimeWarpEffectSoundChannel
global gGame

on new me
  me.pTimeFactor = 1.0
  me.pRealTime = the milliSeconds
  me.pLastTime = me.pRealTime
  me.pTimeWarpingEffectActive = 0
  me.pEffectQueue = []
  me.pPauseEffect = VOID
  me.pWarpSoundInitTime = -1
  me.pispaused = 0
  pTimeCompensationEnabled = 0
  pTimeWarpEffectSoundChannel = 7
  return me
end

on EnableTimeCompensation me
  pTimeCompensationEnabled = 1
end

on DisableTimeCompensation me
  pTimeCompensationEnabled = 0
end

on SetTimeWarpEffectSoundChannel me, kChannelId
  pTimeWarpEffectSoundChannel = kChannelId
end

on GetTimeWarpEffectSoundChannel me
  return pTimeWarpEffectSoundChannel
end

on InitTime me
  pRealTime = the milliSeconds
  pVirtualTime = pRealTime
  pTimeSample1 = 0
  pTimeSample2 = pRealTime
  pPauseTime = 0
end

on GetTimeFactor me
  return pTimeFactor
end

on OnTimeFactorChanged me
  gGame.OnTimeFactorUpdate(#timefactorchanged)
end

on SetTimeFactor me, fTimeFactor
  if fTimeFactor < 0 then
    return 
  end if
  pTimeFactor = fTimeFactor
  if pPauseEffect <> VOID then
    pPauseEffect.endValue = pTimeFactor
  end if
  me.OnTimeFactorChanged()
end

on GetTime me
  return pVirtualTime
end

on GetRealTime me
  return pRealTime
end

on UpdateTime me
  if pTimeFactor < 0.0 then
    pTimeFactor = 0.0
  end if
  if pTimeFactor > 3.0 then
    pTimeFactor = 3.0
  end if
  if not pispaused then
    me.UpdateTimeWarpSound()
    if pTimeWarpingEffectActive then
      me.UpdateEffect()
    end if
    lMilliseconds = the milliSeconds
    lDiff = lMilliseconds - pPauseTime - pLastTime
    lHavokPhysics = gGame.GetHavokPhysics()
    if pTimeCompensationEnabled and not voidp(lHavokPhysics) then
      lClampingMilliseconds = lHavokPhysics.pInitData.timeStepClamping * 1000.0
      if lDiff > lClampingMilliseconds then
        lCompensatedTime = lDiff - lClampingMilliseconds
        pPauseTime = pPauseTime + lCompensatedTime
      end if
    end if
    pRealTime = lMilliseconds - pPauseTime
    pTimeSample1 = pTimeSample2
    pTimeSample2 = pRealTime
    pVirtualTime = pVirtualTime + ((pTimeSample2 - pTimeSample1) * me.pTimeFactor)
    pDeltaTime = pRealTime - pLastTime
    pLastTime = pRealTime
  end if
end

on CompensateWithPhysics me, kHavokPhysics
  lPhysicsDeltaTime = kHavokPhysics.pTimeStep * 1000.0
  if lPhysicsDeltaTime < pDeltaTime then
    lDifference = pDeltaTime - lPhysicsDeltaTime
    pDeltaTime = lPhysicsDeltaTime
    pRealTime = pRealTime - lDifference
    pVirtualTime = pVirtualTime - (lDifference * me.pTimeFactor)
    pLastTime = pRealTime
    pTimeSample2 = pRealTime
    put "Compensated " & lDifference & " milliseconds "
  end if
end

on GetDeltaTime me
  return Clamp(pDeltaTime * pTimeFactor, 1.0, 100.0)
end

on UpdateEffect me
  if not voidp(pPauseEffect) then
    lEffectProgressPause = me.pRealTime - pPauseEffect.startTime
    lStartValuePause = pPauseEffect.StartValue
    lEffectSpanPause = pPauseEffect.endValue - pPauseEffect.StartValue
    me.pTimeFactor = InterpLinear(lEffectProgressPause, lStartValuePause, lEffectSpanPause, pPauseEffect.duration)
    if lEffectProgressPause >= pPauseEffect.duration then
      me.pTimeFactor = pPauseEffect.endValue
      me.EndTimeEffect(pPauseEffect)
    end if
  end if
  if pTimeFactor < 0.0 then
    pTimeFactor = 0.0
  end if
  if pEffectQueue.count = 0 then
    if not voidp(pPauseEffect) then
      me.OnTimeFactorChanged()
    end if
    return 
  end if
  lActiveEffect = pEffectQueue[1]
  lEffectProgress = float(me.pRealTime - lActiveEffect.startTime)
  lStartValue = lActiveEffect.StartValue
  lEffectSpan = lActiveEffect.endValue - lActiveEffect.StartValue
  case lActiveEffect.type of
    #InterpConstant:
      me.pTimeFactor = me.pTimeFactor
    #InterpLinear:
      me.pTimeFactor = InterpLinear(lEffectProgress, lStartValue, lEffectSpan, lActiveEffect.duration)
    #InterpInQuad:
      me.pTimeFactor = InterpInQuad(lEffectProgress, lStartValue, lEffectSpan, lActiveEffect.duration)
    #InterpOutQuad:
      me.pTimeFactor = InterpOutQuad(lEffectProgress, lStartValue, lEffectSpan, lActiveEffect.duration)
    #InterpInOutQuad:
      me.pTimeFactor = InterpInOutQuad(lEffectProgress, lStartValue, lEffectSpan, lActiveEffect.duration)
    #InterpInCubic:
      me.pTimeFactor = InterpInCubic(lEffectProgress, lStartValue, lEffectSpan, lActiveEffect.duration)
    #InterpOutCubic:
      me.pTimeFactor = InterpOutCubic(lEffectProgress, lStartValue, lEffectSpan, lActiveEffect.duration)
    #InterpInQuart:
      me.pTimeFactor = InterpInQuart(lEffectProgress, lStartValue, lEffectSpan, lActiveEffect.duration)
    #InterpInOutQuart:
      me.pTimeFactor = InterpInOutQuart(lEffectProgress, lStartValue, lEffectSpan, lActiveEffect.duration)
    #InterpInQuint:
      me.pTimeFactor = InterpInQuint(lEffectProgress, lStartValue, lEffectSpan, lActiveEffect.duration)
    #InterpOutQuint:
      me.pTimeFactor = InterpOutQuint(lEffectProgress, lStartValue, lEffectSpan, lActiveEffect.duration)
    #InterpInOutQuint:
      me.pTimeFactor = InterpInOutQuint(lEffectProgress, lStartValue, lEffectSpan, lActiveEffect.duration)
  end case
  if pTimeFactor < 0.0 then
    pTimeFactor = 0.0
  end if
  me.OnTimeFactorChanged()
  if lEffectProgress >= lActiveEffect.duration then
    me.EndTimeEffect(lActiveEffect)
  end if
end

on PauseWithTimeWarp me, fCallback, fDuration, fStartTimeK, fEndTimeK, fSound
  if pispaused = 0 then
    if fDuration = VOID then
      fDuration = 700
    end if
    if fStartTimeK = VOID then
      fStartTimeK = 1.0
    end if
    if fEndTimeK = VOID then
      fEndTimeK = 0.0
    end if
    pPauseEffect = [#type: #InterpLinear, #startTime: me.pRealTime, #duration: fDuration, #StartValue: fStartTimeK, #endValue: fEndTimeK, #originalK: me.pTimeFactor, #callback: fCallback, #action: #pause]
    pTimeWarpingEffectActive = 1
    if fSound <> #NoPauseSound then
      me.PlayTimeWarpSound(fSound)
    end if
  end if
end

on UnPauseWithTimeWarp me, fCallback, fDuration, fStartTimeK, fEndTimeK
  if pispaused = 1 then
    if fDuration = VOID then
      fDuration = 700
    end if
    if fStartTimeK = VOID then
      fStartTimeK = 0.0
    end if
    if fEndTimeK = VOID then
      fEndTimeK = 1.0
    end if
    pPauseEffect = [#type: #InterpLinear, #startTime: me.pRealTime, #duration: fDuration, #StartValue: fStartTimeK, #endValue: fEndTimeK, #originalK: me.pTimeFactor, #callback: fCallback, #action: #UnPause]
    me.pispaused = 0
    pPauseTime = pPauseTime + (the milliSeconds - (me.pRealTime + pPauseTime))
    call(fCallback.function, fCallback.script)
    pTimeWarpingEffectActive = 1
  end if
end

on UnPauseWithOutTimeWarp me
  pPauseTime = pPauseTime + (the milliSeconds - (me.pRealTime + pPauseTime))
end

on IsInPauseTransition me
  return not voidp(pPauseEffect)
end

on IsPaused me
  return pispaused
end

on AddInterpEffect me, fType, fDuration, fStartTimeK, fEndTimeK
  lEffectDescriptor = [#type: fType, #startTime: me.pRealTime, #duration: fDuration, #StartValue: fStartTimeK, #endValue: fEndTimeK, #originalK: me.pTimeFactor, #action: #none]
  me.pEffectQueue.add(lEffectDescriptor)
  pTimeWarpingEffectActive = 1
end

on RemoveAllEffects me
  pEffectQueue = []
end

on EndTimeEffect me, fEffectFinished
  me.OnTimeFactorChanged()
  if pPauseEffect = fEffectFinished then
    if fEffectFinished = pPauseEffect then
      case pPauseEffect.action of
        #pause:
          me.pispaused = 1
          call(fEffectFinished.callback.function, fEffectFinished.callback.script)
          pPauseEffect = VOID
        #UnPause:
          pPauseEffect = VOID
      end case
      return 
    end if
  end if
  pTimeWarpingEffectActive = 0
  if pEffectQueue.count > 0 then
    lAction = pEffectQueue[1].action
    pEffectQueue.deleteAt(1)
    if pEffectQueue.count > 0 then
      pEffectQueue[1].startTime = me.pRealTime
      pTimeWarpingEffectActive = 1
    end if
  end if
end

on PlayTimeWarpSound me, fSound
  if pWarpSoundInitTime = -1 then
    lSoundManager = gGame.GetSoundManager()
    lSoundManager.PauseAllSoundChannels()
    pWarpSoundInitTime = me.GetRealTime()
    lSoundManager.PlaySound(fSound, pTimeWarpEffectSoundChannel)
  end if
end

on UpdateTimeWarpSound me
  if pWarpSoundInitTime = -1 then
  else
    lSoundDuration = 450
    if (me.GetRealTime() - pWarpSoundInitTime) > lSoundDuration then
      me.EndTimeWarpSound()
    end if
  end if
end

on EndTimeWarpSound me
  if pWarpSoundInitTime <> -1 then
    pWarpSoundInitTime = -1
    gGame.GetSoundManager().ResumeAllSoundChannels()
  end if
end
