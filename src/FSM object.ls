property pFSM, pOldState, pState, pFSMActive, pKeyEvents
global gGame

on new me, kFSM, kInitState
  pFSM = kFSM
  pOldState = VOID
  pState = kInitState
  pFSMActive = 1
  if not voidp(pState) then
    lStateProps = pFSM.GetStateProperties(pState)
    call(lStateProps.enter, lStateProps.callbackScript, me, -1)
  end if
  pKeyEvents = []
  return me
end

on IsFSMActive me
  return pFSMActive
end

on ActivateFSM me
  assert(not pFSMActive, "FSM already active")
  pFSMActive = 1
end

on DeactivateFSM me
  assert(pFSMActive, "FSM not active")
  pFSMActive = 0
end

on GetOldState me
  return pOldState
end

on GetState me
  return pState
end

on ChangeState me, kState, kTime
  if voidp(pFSM) then
    return 
  end if
  pOldState = pState
  lOldStateProps = pFSM.GetStateProperties(pOldState)
  call(lOldStateProps.exit, lOldStateProps.callbackScript, me, kTime)
  pState = kState
  lNewStateProps = pFSM.GetStateProperties(pState)
  call(lNewStateProps.enter, lNewStateProps.callbackScript, me, kTime)
end

on SendKeyEvent me, kEvent
  pKeyEvents.append(kEvent)
end

on GetNextKeyEvent me
  if gGame.IsPaused() or gGame.GetTimeManager().IsInPauseTransition() then
    return VOID
  end if
  lEventsCount = pKeyEvents.count
  if lEventsCount > 0 then
    lEvent = pKeyEvents[lEventsCount]
    pKeyEvents.deleteAt(lEventsCount)
    return lEvent
  else
    return VOID
  end if
end

on FlushKeyEvents me
  pKeyEvents = []
end

on update me, kTime
  if not voidp(pFSM) and pFSMActive then
    pFSM.update(me, kTime)
  end if
end
