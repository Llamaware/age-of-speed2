property ancestor, pPrerenderCounter

on new me, kFSM, kInitState
  me.ancestor = script("FSM object").new(kFSM, kInitState)
  return me
end

on GetPrerenderCounter me
  return pPrerenderCounter
end

on SetPrerenderCounter me, kCounter
  pPrerenderCounter = kCounter
end
