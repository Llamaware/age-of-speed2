global gGame, gRequestPause, gConfiguration

on exitFrame me
  gRequestPause = -1
  gGame = script("AgeOfSpeed2 Game").new()
  gGame.SetConfiguration(gConfiguration)
  gGame.SetProfilerActive(0)
  gGame.SetUnpauseTempo(70)
  gGame.Set3D(member(1))
  go(6)
end
