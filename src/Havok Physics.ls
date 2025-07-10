property pHavok, p3DMember, pInitData, pRealTime, pActive, pTimeMultiplier, pTimeStep, pSubstepCallbackActive, pSubstepCallbacks, pSimTime

on new me, k3DMember, kInitData
  p3DMember = k3DMember
  pInitData = kInitData
  pHavok = VOID
  pRealTime = 0.0
  pTimeMultiplier = 1.0
  pTimeStep = 0.02
  pSimTime = 0.0
  pActive = 1
  pSubstepCallbackActive = 0
  pSubstepCallbacks = VOID
  return me
end

on Initialize me
  pHavok = pInitData.havokMember
  if not pInitData.hkeFile then
    pHavok.Initialize(p3DMember, pInitData.collisionTolerance, pInitData.worldScale)
  else
    pHavok.Initialize(p3DMember)
  end if
  pHavok.dragParameters = pInitData.dragParameters
  pHavok.deactivationParameters = pInitData.deactivationParameters
  pHavok.gravity = pInitData.gravity
  pSubstepCallbackActive = 0
  pSubstepCallbacks = []
end

on GetHavok me
  return pHavok
end

on IsActive me
  return pActive
end

on GetTimeMultiplier me
  return pTimeMultiplier
end

on GetTimeStep me
  return pTimeStep
end

on GetSimTime me
  return pSimTime
end

on SetActive me, kActive
  pActive = kActive
end

on AddSubstepCallback me, kFunction, kScript
  pSubstepCallbacks.append([#function: kFunction, #script: kScript])
end

on RemoveSubstepCallback me, kFunction, kScript
  pSubstepCallbacks.deleteOne([#function: kFunction, #script: kScript])
end

on GetSubstepCallbackActive me
  return pSubstepCallbackActive
end

on SetSubstepCallbackActive me, kActive
  if kActive then
    assert(not pSubstepCallbackActive, "substep callback already active")
    me.GetHavok().registerStepCallback(#StepCallback, me)
    pSubstepCallbackActive = 1
  else
    assert(pSubstepCallbackActive, "substep callback already inactive")
    me.GetHavok().removeStepCallback(#StepCallback, me)
    pSubstepCallbackActive = 0
  end if
end

on StepCallback me, kSimTime
  repeat with it in pSubstepCallbacks
    call(it.function, it.script, kSimTime)
  end repeat
end

on update me, kDeltaTime
  if not voidp(pHavok) and pActive then
    lTimeStep = kDeltaTime * 0.001
    if lTimeStep > pInitData.timeStepClamping then
      lTimeStep = pInitData.timeStepClamping
    end if
    pSimTime = pSimTime + lTimeStep
    pHavok.step(lTimeStep, pInitData.subSteps)
    if lTimeStep <> 0.0 then
      pTimeMultiplier = pTimeStep / lTimeStep
    end if
    pTimeStep = lTimeStep
  end if
end

on shutDown me
  pHavok.shutDown()
end
