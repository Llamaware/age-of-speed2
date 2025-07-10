property pStates, pGlobalState

on new me
  pStates = [:]
  pGlobalState = VOID
  return me
end

on SetGlobalState me, lExec, lCallbackScript
  pGlobalState = [#exec: lExec, #callbackScript: lCallbackScript]
end

on AddState me, lSymName, lEnter, lExec, lExit, lCallbackScript
  lState = [#enter: lEnter, #exec: lExec, #exit: lExit, #callbackScript: lCallbackScript]
  pStates.addProp(lSymName, lState)
end

on GetStateProperties me, lSymName
  return pStates[lSymName]
end

on update me, kEntity, kTime
  if not voidp(pGlobalState) then
    call(pGlobalState.exec, pGlobalState.callbackScript, kEntity, kTime)
  end if
  lState = pStates[kEntity.GetState()]
  call(lState.exec, lState.callbackScript, kEntity, kTime)
end
