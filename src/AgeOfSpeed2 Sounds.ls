property pEngineFadeOutTimer, pSgommataTimer, pBrakeSgommata, pPriorityList, pTurboOn, pArcoChannel
global gGame

on new me
  gGame.GetSoundManager().SetBackgroundMusicName("snd_base")
  gGame.GetSoundManager().PlayBackgroundMusic()
  gGame.GetTimeManager().SetTimeWarpEffectSoundChannel(3)
  return me
end

on Initialize me
  pEngineFadeOutTimer = -1
  pSgommataTimer = -1
  pBrakeSgommata = 0
  pPriorityList = [101, 101, 101, 101, 101, 101, 101, 101]
  pTurboOn = 0
  pArcoChannel = 8
end

on OnSoundOffClick me
end

on SetSoundsActive me, kValue
  pSoundsActive = kValue
end

on PlayHurryUpSound me
end

on StopHurryUpSound me
end

on PlaySound me, kName, kPriority
  lChannel = -1
  repeat with li = 3 to 8
    if not sound(li).isBusy() then
      lChannel = li
      exit repeat
    end if
  end repeat
  if lChannel = -1 then
    lLowPriority = -1
    repeat with li = 3 to 8
      lPriority = pPriorityList[li]
      if lPriority > lLowPriority then
        lChannel = li
        lLowPriority = lPriority
      end if
    end repeat
    if lLowPriority < kPriority then
      lChannel = -1
    end if
  end if
  if lChannel <> -1 then
    gGame.GetSoundManager().PlaySound(kName, lChannel)
    pPriorityList[lChannel] = kPriority
  end if
  return lChannel
end

on PlayElectricSound me
  lIdx = (random(1000) mod 3) + 1
  me.PlaySound("snd_electric" & lIdx, 50)
end

on UpdateGates me, kVehicle
  if (kVehicle.GetSpeedKmh() < 120) or not kVehicle.GetShadowVisible() then
    return 
  end if
  lCurrentTokenRef = kVehicle.GetCurrentTokenRef()
  repeat with lGateRef in lCurrentTokenRef.CheckLineList
    lCklResult = lGateRef.ckl.Check(kVehicle.getPosition(), kVehicle.GetPreviousPosition())
    if lCklResult[1] <> #none then
      lArcoChannel = me.PlaySound("snd_arco", 1)
      if lArcoChannel = -1 then
        gGame.GetSoundManager().PlaySound("snd_arco", pArcoChannel)
      else
        pArcoChannel = lArcoChannel
      end if
      lPan = Clamp(integer(kVehicle.GetTrasversal() * 100), -100, 100)
      sound(pArcoChannel).pan = lPan
      exit repeat
    end if
  end repeat
end

on PlayExplosionSound me, kPos
  lChannel = me.PlaySound("snd_explosion", 1)
  if lChannel <> -1 then
    lPlayerPos = gGame.GetPlayerVehicle().getPosition()
    lDiff = lPlayerPos - kPos
    lDistance = lDiff.magnitude
    if lDistance > 12000 then
      lVolume = 0
      lPan = 0
    else
      if lDistance = 0 then
        lVolume = 250
        lPan = 0
      else
        lVolume = (12000.0 - lDistance) / 12000.0
        lMinVolume = 110
        lVolume = integer(lMinVolume + (lVolume * 140))
        lCameraTransform = gGame.GetCamera().GetCameraNode().transform.duplicate()
        lCameraTransform.position = vector(0.0, 0.0, 0.0)
        lCameraDir = lCameraTransform * vector(1.0, 0.0, 0.0)
        lProjection = lCameraDir.dotProduct(lDiff)
        lProjection = lProjection * -1.0
        lProjection = lProjection / lDistance
        lPan = lProjection * 100
      end if
    end if
    sound(lChannel).volume = lVolume
    sound(lChannel).pan = lPan
  end if
end

on update me, kTime
  if gGame.GetGameStatus() <> #play then
    return 
  end if
  lVehicle = gGame.GetPlayerVehicle().GetVehicle()
  lTurboOn = (lVehicle.GetTurboTimer() <> -1) and (lVehicle.GetTurboCoeff() = 2.75)
  if lTurboOn then
    if not pTurboOn then
      me.PlaySound("snd_turbo", 1)
      pTurboOn = 1
    end if
  else
    if pTurboOn then
      pTurboOn = 0
    end if
  end if
  me.UpdateGates(lVehicle)
end
