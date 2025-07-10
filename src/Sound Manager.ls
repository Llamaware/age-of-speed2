property pSourceFileName, pSoundDatas, pAudioOn, pMusicOn, pActiveSounds, pFileCastMember, pBaseSoundsCastMember, pEnableBackgroundMusic, pBackGroundMusicName, pManualMusicControl
global gGame

on new me, fSourceFileName, fFileCastMember, fBaseSoundsCastMember
  pSourceFileName = fSourceFileName
  pSoundDatas = [:]
  pFileCastMember = fFileCastMember
  pBaseSoundsCastMember = fBaseSoundsCastMember
  pAudioOn = 1
  pMusicOn = 1
  pActiveSounds = []
  pEnableBackgroundMusic = 1
  pManualMusicControl = 0
  return me
end

on GetAudioState me
  return pAudioOn
end

on GetMusicState me
  return pMusicOn
end

on GetManualMusicControl me
  return pManualMusicControl
end

on SetAudioState me, fAudioState
  pAudioOn = fAudioState
end

on SetMusicState me, fMusicState
  pMusicOn = fMusicState
end

on SetBackgroundMusicName me, kName
  pBackGroundMusicName = kName
end

on SetBackgroundMusicState me, kState
  pEnableBackgroundMusic = kState
end

on SetManualMusicControl me, kManualMusicControl
  pManualMusicControl = kManualMusicControl
end

on PlaySound me, fName, fChannel
  if pSoundDatas.findPos(fName) = VOID then
    put EMPTY
    put "----------------------------------------------------------------------"
    put " ERRORE SUONO: Non trovato: " & fName
    put "----------------------------------------------------------------------"
    return 
  end if
  if pManualMusicControl then
    lCanPlay = ((pAudioOn = 1) and (fChannel > 1)) or ((pMusicOn = 1) and (fChannel = 1))
  else
    lCanPlay = pAudioOn
  end if
  if lCanPlay then
    sound(fChannel).volume = pSoundDatas[fName].volume
    sound(fChannel).pan = 0
    sound(fChannel).play(member(fName))
  end if
end

on Play3dSound me, fName, fChannel, kWorldPos, kListenerFrame, kVolumeFallOff, kPanFallOff
  if voidp(pSoundDatas.findPos(fName)) then
    put EMPTY
    put "----------------------------------------------------------------------"
    put " ERRORE SUONO: Non trovato: " & fName
    put "----------------------------------------------------------------------"
    return 
  end if
  if pManualMusicControl then
    lCanPlay = ((pAudioOn = 1) and (fChannel > 1)) or ((pMusicOn = 1) and (fChannel = 1))
  else
    lCanPlay = pAudioOn
  end if
  if lCanPlay then
    lListenerPos = kListenerFrame.inverse() * kWorldPos
    lLinDist = lListenerPos.magnitude
    lPanDist = lListenerPos.x
    lVolume = integer(Clamp(1.0 - (lLinDist * kVolumeFallOff), 0.0, 1.0) * 255.0)
    lPan = integer(lPanDist * kPanFallOff * 100.0)
    sound(fChannel).volume = lVolume
    sound(fChannel).pan = Clamp(lPan, -100, 100)
    sound(fChannel).play(member(fName))
  end if
end

on StopSound me, fChannel
  sound(fChannel).stop()
end

on LoadSounds me
  if gGame.GetConfiguration() = #debug then
    pSourceMemberObj = member(pFileCastMember).importFileInto(pSourceFileName)
  end if
  pSoundDatas = [:]
  lText = member(pFileCastMember).text
  if lText = EMPTY then
    return 
  end if
  me.ParseFile(lText)
  lCastMember = pBaseSoundsCastMember
  repeat with li = 1 to pSoundDatas.count
    pSoundDatas[li].castMember = lCastMember + li
    if gGame.GetConfiguration() = #debug then
      member(pSoundDatas[li].castMember).importFileInto(pSoundDatas[li].path)
    end if
    member(pSoundDatas[li].castMember).loop = pSoundDatas[li].loop
    member(pSoundDatas[li].castMember).name = pSoundDatas.getPropAt(li)
  end repeat
end

on RemoveBeginReturn me, fString
  lString = fString
  if charToNum(chars(fString, 1, 1)) = 10 then
    lString = chars(fString, 2, lString.length)
  end if
  return lString
end

on ParseFile me, fString
  lIndex = 0
  repeat while 1
    lWordResult = readWord(fString, lIndex + 1)
    lId = lWordResult[1]
    lIndex = lWordResult[2]
    lWordResult = readWord(fString, lIndex + 1)
    lPath = lWordResult[1]
    lIndex = lWordResult[2]
    lWordResult = readWord(fString, lIndex + 1)
    lVol = integer(lWordResult[1])
    lIndex = lWordResult[2]
    lWordResult = readWord(fString, lIndex + 1)
    lLoop = lWordResult[1]
    if lLoop = "true" then
      lLoop = 1
    else
      if lLoop = "false" then
        lLoop = 0
      end if
    end if
    lIndex = lWordResult[2]
    lCode = lWordResult[3]
    lSoundDatasElement = [#castMember: -1, #path: lPath, #volume: lVol, #loop: lLoop]
    pSoundDatas.addProp(lId, lSoundDatasElement)
    if lCode = #endstring then
      exit repeat
    end if
  end repeat
end

on PlayBackgroundMusic me
  if pManualMusicControl then
    lCanPlayBackgroundMusic = pMusicOn
  else
    lCanPlayBackgroundMusic = pAudioOn
  end if
  if lCanPlayBackgroundMusic and pEnableBackgroundMusic then
    me.PlaySound(pBackGroundMusicName, 1)
  end if
end

on PauseBackgroundMusic me
  if pManualMusicControl then
    lCanPauseBackgroundMusic = pMusicOn
  else
    lCanPauseBackgroundMusic = pAudioOn
  end if
  if not lCanPauseBackgroundMusic then
    sound(1).pause()
  end if
end

on ResumeBackgroundMusic me
  if pManualMusicControl then
    lCanPlayBackgroundMusic = pMusicOn
  else
    lCanPlayBackgroundMusic = pAudioOn
  end if
  if lCanPlayBackgroundMusic then
    if not sound(1).isBusy() then
      me.PlayBackgroundMusic()
    else
      sound(1).play()
    end if
  end if
end

on FadeOutBackgroundMusic me, kFadeChannel, kFadeTime
  if pManualMusicControl then
    lCanPlayBackgroundMusic = pMusicOn
  else
    lCanPlayBackgroundMusic = pAudioOn
  end if
  if lCanPlayBackgroundMusic and pEnableBackgroundMusic then
    lDuration = member(pBackGroundMusicName).duration
    lCurrentTime = sound(1).currentTime
    lCurrentVolume = sound(1).volume
    lFadeTime = float(kFadeTime) * (float(lCurrentVolume) / float(pSoundDatas[pBackGroundMusicName].volume))
    lEndTime = (lCurrentTime + lFadeTime) mod lDuration
    sound(kFadeChannel).volume = lCurrentVolume
    sound(kFadeChannel).pan = 0
    sound(kFadeChannel).play([#member: member(pBackGroundMusicName), #startTime: lCurrentTime, #loopStartTime: lCurrentTime, #endTime: lEndTime, #loopEndTime: lEndTime])
    sound(kFadeChannel).fadeOut(integer(lFadeTime))
  end if
end

on FadeInBackgroundMusic me, kFadeTime
  me.PlayBackgroundMusic()
  sound(1).fadeIn(kFadeTime)
end

on StopAllSoundChannels me
  sound(1).stop()
  sound(2).stop()
  sound(3).stop()
  sound(4).stop()
  sound(5).stop()
  sound(6).stop()
  sound(7).stop()
  sound(8).stop()
end

on PauseAllSoundChannels me, kManualCheck
  lMustPauseMusic = 1
  if not voidp(kManualCheck) then
    if kManualCheck then
      if pManualMusicControl and pMusicOn then
        lMustPauseMusic = 0
      end if
    end if
  end if
  if lMustPauseMusic then
    sound(1).pause()
  end if
  repeat with li = 2 to 8
    lTimeWarpChannel = gGame.GetTimeManager().GetTimeWarpEffectSoundChannel()
    if li = lTimeWarpChannel then
      lPauseChannel = 1
      if not gGame.GetPauseWithTimeWarp() and sound(li).isBusy() then
        lSoundMember = sound(li).member
        if not voidp(lSoundMember) then
          if lSoundMember.name = "snd_popup" then
            lPauseChannel = 0
          end if
        end if
      end if
      if lPauseChannel then
        sound(li).pause()
      end if
      next repeat
    end if
    sound(li).pause()
  end repeat
end

on ResumeAllSoundChannels me
  if pManualMusicControl then
    lCanResumeMusic = pMusicOn
  else
    lCanResumeMusic = pAudioOn
  end if
  if lCanResumeMusic then
    if not sound(1).isBusy() then
      me.PlayBackgroundMusic()
    else
      if pBackGroundMusicName <> sound(1).member.name then
        me.PlayBackgroundMusic()
      else
        sound(1).play()
      end if
    end if
  end if
  if pAudioOn then
    sound(2).play()
    sound(3).play()
    sound(4).play()
    sound(5).play()
    sound(6).play()
    sound(7).play()
    sound(8).play()
  end if
end

on BackupActiveSounds me
  repeat with li = 1 to 8
    if (sound(li).status = 3) or (sound(li).status = 4) then
      pActiveSounds.add(sound(li).member)
      next repeat
    end if
    pActiveSounds.add(VOID)
  end repeat
end

on RestoreActiveSounds me
  repeat with li = 1 to 8
    if pActiveSounds[li] <> VOID then
      lMemberRef = member(pActiveSounds[li])
      if lMemberRef <> VOID then
        lMemberName = lMemberRef.name
        me.PlaySound(lMemberName, li)
      end if
    end if
  end repeat
end
