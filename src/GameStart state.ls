property pStartSequenceStarted
global gGame

on GameStartEnter me, kGameplay, kTime
  gGame.GetCamera().ChangeState(#GameStart, kTime)
  pStartSequenceStarted = 0
end

on GameStartExec me, kGameplay, kTime
  if (gGame.GetCamera().GetState() = #VoidState) and not pStartSequenceStarted then
    if gGame.GetTutorialEnabled() then
      gGame.SetTutorialEnabled(0)
      gGame.GetSequenceManager().StartSequence("LevelStartWithHelp")
    else
      gGame.GetSequenceManager().StartSequence("LevelStart")
    end if
    pStartSequenceStarted = 1
  end if
end

on GameStartExit me, kGameplay, kTime
  pStartSequenceStarted = 0
end
