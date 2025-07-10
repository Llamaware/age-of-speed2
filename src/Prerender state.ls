global gGame

on PrerenderEnter me, kGameplay, kTime
  kGameplay.SetPrerenderCounter(5)
end

on PrerenderExec me, kGameplay, kTime
  lCounter = kGameplay.GetPrerenderCounter()
  lCounter = lCounter - 1
  if lCounter = 0 then
    kGameplay.ChangeState(gGame.GetGameplayStartState(), kTime)
  else
    kGameplay.SetPrerenderCounter(lCounter)
  end if
end

on PrerenderExit me, kGameplay, kTime
end
