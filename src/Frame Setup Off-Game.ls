global gGame

on enterFrame
  cursor(-1)
  lExitCode = gGame.GetExitCode()
  if lExitCode <> 0 then
    gGame.SetExitCode(0)
    gGame.GetOffGame().start(lExitCode)
  else
    gGame.GetOffGame().GetSprite().SetupAudioState(1)
    gGame.GetOffGame().InitPage(lExitCode)
  end if
end
