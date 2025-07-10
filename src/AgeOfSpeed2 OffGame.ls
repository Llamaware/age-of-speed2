property ancestor, pZapakStartTime
global gGame

on new me, kFrame, kSprite
  me.ancestor = script("OffGame").new(8, 6, 15, "off_game_sprite", 10)
  pZapakStartTime = VOID
  return me
end

on GetZapakStartTime me
  return pZapakStartTime
end

on SetZapakStartTime me, kTime
  pZapakStartTime = kTime
end

on OnStart me, kSprite, kExitCode
  put "start offgame"
  gGame.GetSoundManager().StopAllSoundChannels()
  lTutorialEnabled = 0
  if gGame.GetTutorialEnabled() then
    lTutorialEnabled = 1
  end if
  lScore = gGame.GetPlayerScore()
  lIsQuickRace = gGame.GetGameType() = #quickRace
  if (gGame.GetGameStatus() = #endgood) and (gGame.GetExitCode() <> 2) and not lIsQuickRace then
    kSprite.InitChampData()
    lPlayers = gGame.GetPlayers()
    lRaceLaps = gGame.GetGameplay().GetRaceLaps()
    lTimeRef = gGame.GetPlayerVehicle().GetVehicle().GetRaceTime()
    repeat with li = 1 to lPlayers.count
      lVehicleRef = lPlayers[li].GetVehicle()
      if lVehicleRef.GetRaceTime() = -1 then
        lVehicleRef.pRaceTime = lTimeRef + (lTimeRef * ((gGame.GetTrackLength() * lRaceLaps) - lVehicleRef.GetRaceTrackPos()) / (gGame.GetTrackLength() * lRaceLaps))
      end if
      lVehicleRef.pRaceTime = integer(lVehicleRef.pRaceTime)
    end repeat
    repeat with li = 1 to lPlayers.count
      lPlayerRef = lPlayers[li]
      lPosition = 1
      repeat with lj = 1 to lPlayers.count
        lOtherPlayer = lPlayers[lj]
        if lPlayerRef <> lOtherPlayer then
          if lPlayerRef.GetVehicle().GetRaceTime() > lOtherPlayer.GetVehicle().GetRaceTime() then
            lPosition = lPosition + 1
            next repeat
          end if
          if (lPlayerRef.GetVehicle().GetRaceTime() = lOtherPlayer.GetVehicle().GetRaceTime()) and (li > lj) then
            lPosition = lPosition + 1
          end if
        end if
      end repeat
      lTextureId = lPlayerRef.GetVehicleId()
      kSprite.SetupChampData(lTextureId, lPosition, lPlayerRef.GetVehicle().GetRaceTime(), gGame.GetPlayerId())
      if li = 1 then
        lFinalRacePosition = lPosition
      end if
    end repeat
  else
    lFinalRacePosition = gGame.GetFinalPlacement()
  end if
  if lIsQuickRace then
    lPlayerRef = gGame.GetPlayers()[1]
    lQuickLevel = (4 * (gGame.GetAllId() - 1)) + gGame.GetLevelId()
    lQuickRaceTime = lPlayerRef.GetVehicle().GetRaceTime()
  end if
  kSprite.SetupGameData(lScore, lFinalRacePosition, gGame.GetGameplay().GetAvgSpeed(), gGame.GetSoundManager().GetAudioState(), lTutorialEnabled, lIsQuickRace, lQuickLevel, lQuickRaceTime, gGame.GetPlayerId())
  _movie.keyboardFocusSprite = sprite(2)
end
