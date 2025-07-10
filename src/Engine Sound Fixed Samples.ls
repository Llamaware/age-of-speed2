property pSoundChannelID, pVehicle, pTimeSource, pSpeedRanges, pPrevBackward, pLastSound, pGear, pMinVolume, pMaxVolume, pCurrentRange, pForceRangeDownTimer, pVehicleAcceleration, pEnabled, pEnableRetro, pPreviousSpeed, pRetroGear, pNotInRetroGear, pEndRetro, pNamePrefix
global gGame

on new me, kVehicle, kSoundChannelID, kTimeSource
  pVehicle = kVehicle
  pSoundChannelID = kSoundChannelID
  pTimeSource = kTimeSource
  pSpeedRanges = [0.0, 15.0, 40.0, 65.0, 90.0, 150.0, 500.0]
  pPrevBackward = 0
  pLastSound = #none
  pGear = 0
  pCurrentRange = 0
  pMinVolume = 10
  pMaxVolume = 70
  sound(pSoundChannelID).volume = 90
  pForceRangeDownTimer = -1
  pEnabled = 1
  pRetroGear = 0
  pNotInRetroGear = 1
  pEndRetro = 1
  pEnableRetro = 0
  pNamePrefix = EMPTY
  return me
end

on GetCurrentRange me
  return pCurrentRange
end

on GetEnabled me
  return pEnabled
end

on GetSoundName me, kName
  return pNamePrefix & kName
end

on SetSpeedRanges me, kSpeedRanges
  pSpeedRanges = kSpeedRanges
end

on SetEnabled me, kValue
  pEnabled = kValue
end

on SetNamePrefix me, kPrefix
  pNamePrefix = kPrefix
end

on EnableRetro me, kValue
  pEnableRetro = kValue
end

on ForceRangeDown me
  if (gGame.GetTimeManager().GetTime() - pForceRangeDownTimer) > 500 then
    pForceRangeDownTimer = gGame.GetTimeManager().GetTime()
    pGear = pGear - 1
    if pGear < 0 then
      pGear = 0
    end if
    pVehicleAcceleration = 0
  end if
end

on SetVolume me, kMinVolume, kMaxVolume
  pMinVolume = kMinVolume
  pMaxVolume = kMaxVolume
end

on update me, kAudioState, kIsGameStarted
  if gGame.IsPaused() then
    return 
  end if
  lStartSpeed = 0.0
  lEndSpeed = 100.0
  li = pSpeedRanges.count
  lVehicleSpeed = pVehicle.GetSpeedKmh()
  if kIsGameStarted and ((gGame.GetTimeManager().GetTime() - pForceRangeDownTimer) < 500) then
    lVehicleSpeed = lVehicleSpeed * 0.65000000000000002
  else
    pVehicleAcceleration = pVehicle.pAcceleration
  end if
  lSpeedReference = lVehicleSpeed
  if pEnableRetro then
    if (lSpeedReference >= -5.0) and (lSpeedReference < 5.0) then
      lSpeedReference = 5.0
    end if
  else
    if lSpeedReference < 5.0 then
      lSpeedReference = 5.0
    end if
  end if
  lChangeGearEffect = 0
  repeat while li > 0
    if lSpeedReference >= pSpeedRanges[li] then
      lStartSpeed = pSpeedRanges[li]
      lEndSpeed = pSpeedRanges[li + 1]
      if (li <> pCurrentRange) and kIsGameStarted then
        lChangeGearEffect = 1
      end if
      pCurrentRange = li
      exit repeat
    end if
    li = li - 1
  end repeat
  if not kAudioState or not kIsGameStarted or not pEnabled then
    return 
  end if
  lSoundPlaylist = sound(pSoundChannelID).getPlaylist()
  if voidp(pPreviousSpeed) then
    pPreviousSpeed = lSpeedReference
  end if
  lDt = gGame.GetTimeManager().GetDeltaTime() * 0.001
  lAcc = (lSpeedReference - pPreviousSpeed) / lDt
  pPreviousSpeed = lSpeedReference
  if (lSpeedReference >= 0.0) or (pVehicleAcceleration > -pVehicle.pAccelerationEpsilon) then
    pRetroGear = 0
    pNotInRetroGear = 1
  end if
  if lSpeedReference < 0.0 then
    if pVehicleAcceleration < -pVehicle.pAccelerationEpsilon then
      pEndRetro = 0
      if pRetroGear < 1 then
        lCheck = me.PlayEngineSample(pSoundChannelID, me.GetSoundName("snd_engine_back" & pRetroGear), lSoundPlaylist, 1.0, pNotInRetroGear)
        pNotInRetroGear = 0
        if lCheck then
          pRetroGear = pRetroGear + 1
        end if
      else
        me.PlayEngineSample(pSoundChannelID, me.GetSoundName("snd_engine_back1"), lSoundPlaylist, 1.0, 0)
      end if
    else
      if not pEndRetro then
        me.PlayEngineSample(pSoundChannelID, me.GetSoundName("snd_engine_back2"), lSoundPlaylist, 1.0, not pEndRetro)
        pEndRetro = 1
      end if
    end if
  else
    if (pVehicleAcceleration > pVehicle.pAccelerationEpsilon) and not (lAcc = 0.0) then
      if pLastSound = #Fly then
        pPrevBackward = 1
      end if
      if (li < (pGear - 1)) and (pGear < 5) and (pGear > 0) then
        lPitch = pGear
        if lPitch < 1 then
          lPitch = 1
        end if
        me.PlayEngineSample(pSoundChannelID, me.GetSoundName("snd_engine_dec"), lSoundPlaylist, lPitch, pPrevBackward or (pLastSound = #mid))
        pLastSound = #Dec
        pGear = pGear - 1
      else
        if pGear < 4 then
          lCheck = me.PlayEngineSample(pSoundChannelID, me.GetSoundName("snd_engine_acc" & pGear), lSoundPlaylist, 1.0, pPrevBackward or (pLastSound = #mid))
          if lCheck = 1 then
            pGear = pGear + 1
          end if
          pLastSound = #Acc
          pRevTime = -1
        else
          lCheck = me.PlayEngineSample(pSoundChannelID, me.GetSoundName("snd_engine_acc4"), lSoundPlaylist, 1.0, pLastSound = #mid)
          pLastSound = #Acc
          pRevTime = -1
        end if
      end if
      pPrevBackward = 0
    else
      if lVehicleSpeed < 30 then
        me.PlayEngineSample(pSoundChannelID, me.GetSoundName("snd_engine_min"), lSoundPlaylist, 1.0, pLastSound <> #min)
        pLastSound = #min
        pGear = 0
        pPrevBackward = 1
      else
        if (pLastSound = #Dec) or (pLastSound = #mid) then
          lCheck = me.PlayEngineSample(pSoundChannelID, me.GetSoundName("snd_engine_min"), lSoundPlaylist, 1.0, 0)
          pLastSound = #mid
          pGear = pCurrentRange
          pPrevBackward = 1
        end if
        if pLastSound <> #mid then
          if pGear > 0 then
            lCheck = me.PlayEngineSample(pSoundChannelID, me.GetSoundName("snd_engine_dec"), lSoundPlaylist, pGear, not pPrevBackward)
            pGear = li
            pLastSound = #Dec
          else
            me.PlayEngineSample(pSoundChannelID, me.GetSoundName("snd_engine_min"), lSoundPlaylist, 1.0, pLastSound <> #min)
            pLastSound = #min
            pGear = 0
          end if
        end if
        pPrevBackward = 1
      end if
    end if
  end if
  pLastGear = li
  sound(pSoundChannelID).volume = pMinVolume + (abs(lVehicleSpeed) / 100.0 * (pMaxVolume - pMinVolume))
  if not sound(pSoundChannelID).isBusy() then
    sound(pSoundChannelID).play()
  end if
end

on PlayEngineSample me, kChannel, kMemberName, kPlayList, kRateShift, kForcePlay
  if kForcePlay then
    sound(kChannel).stop()
    sound(kChannel).play([#member: member(kMemberName), #rateShift: kRateShift])
    sound(kChannel).setPlayList([])
    return 0
  else
    if kPlayList.count < 1 then
      sound(kChannel).queue([#member: member(kMemberName), #rateShift: kRateShift])
      return 1
    else
      kPlayList[1].member = member(kMemberName)
      kPlayList[1].rateShift = kRateShift
      sound(kChannel).setPlayList(kPlayList)
      return 0
    end if
  end if
end

on pause me
  sound(pSoundChannelID).volume = 0
end

on UnPause me
end
