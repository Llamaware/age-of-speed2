global gGame

on flash_start me, kIsQuickRace, kScore, kAudioState, kGenericHelp, kLevelId, kPlayerId, kBestTime
  kBestSessionScore = 0
  kBestTime = integer(kBestTime)
  if kBestTime = 0 then
    kBestTime = -1
  end if
  lTable = [[1, 1, 1, 1], [2, 1, 1, 1], [3, 1, 1, 1], [4, 1, 1, 1], [1, 2, 2, 2], [2, 2, 2, 2], [3, 2, 2, 2], [4, 2, 2, 2], [1, 3, 3, 3], [2, 3, 3, 3], [3, 3, 3, 3], [4, 3, 3, 3], [1, 4, 4, 4], [2, 4, 4, 4], [3, 4, 4, 4], [4, 4, 4, 4]]
  lData = lTable[integer(kLevelId)]
  lLevel3d = lData[1]
  lAllId = lData[2]
  lSetId = lData[3]
  lDifficult = lData[4]
  gGame.SetSetId(lSetId)
  gGame.SetAllId(lAllId)
  gGame.SetDifficult(lDifficult)
  gGame.SetLevelId(lLevel3d)
  gGame.SetPlayerScore(integer(kScore))
  gGame.SetBestSessionScore(integer(kBestSessionScore))
  gGame.SetPlayerId(integer(kPlayerId))
  lAudioState = integer(kAudioState) = 1
  gGame.SetOffGameAudioState(lAudioState)
  gGame.SetTutorialEnabled(kGenericHelp = "1")
  if integer(kIsQuickRace) = 1 then
    gGame.SetGameType(#quickRace)
  else
    gGame.SetGameType(#championship)
  end if
  gGame.SetHowManyPlayers(4)
  gGame.SetPreillumination(0, 0, member(2), member(61 + gGame.GetLevelId()))
  gGame.SetBestTime(kBestTime)
  go(13)
end
