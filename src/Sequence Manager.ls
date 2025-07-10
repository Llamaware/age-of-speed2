property pTimeSource, pTimeList, pIsActive, pInitTime, pStopTime, pStopDuration, pSequences, pUseRealTime, pActiveSequence
global gGame

on new me, kTimeManager
  pIsActive = #Init
  pTimeList = []
  pInitTime = 0
  pStopTime = 0
  pStopDuration = 0
  pTimeSource = kTimeManager
  pUseRealTime = 1
  pSequences = [:]
  pActiveSequence = VOID
  return me
end

on SetUseRealTime me, kUseRealTime
  pUseRealTime = kUseRealTime
end

on RegisterSequence me, kSequenceId, kSequenceData
  pSequences.addProp(kSequenceId, kSequenceData)
end

on GetSequence me, kSequenceId
  if pSequences.findPos(kSequenceId) = VOID then
    return VOID
  end if
  return pSequences[kSequenceId]
end

on GetTime me
  if pUseRealTime then
    return pTimeSource.GetRealTime()
  end if
  return pTimeSource.GetTime()
end

on AddElement me, fFunctionName, fScript, fParams, fOffsetTime
  lElem = [#functionname: fFunctionName, #scriptname: fScript, #params: fParams, #offsettime: fOffsetTime, #launched: 0]
  pTimeList.add(lElem)
end

on ClearAllElements me
  pIsActive = #Init
  pInitTime = 0
  pStopTime = 0
  pStopDuration = 0
  repeat with li = pTimeList.count down to 1
    pTimeList.deleteAt(li)
  end repeat
  pTimeList = []
end

on ResetElements me
  pIsActive = #Init
  pInitTime = 0
  pStopTime = 0
  pStopDuration = 0
  repeat with li = 1 to pTimeList.count
    pTimeList[li].launched = 0
  end repeat
end

on BeginSynchronizedTemporization me, fTime
  pInitTime = fTime
  pIsActive = #running
end

on StopSynchronizedTemporization me
  pIsActive = #stopped
  pActiveSequence = VOID
end

on UpdateSynchronized me, fTime
  if pIsActive = #running then
    lAllDone = 1
    lCurrentTime = fTime - pInitTime
    repeat with li = 1 to pTimeList.count
      if pTimeList[li].launched = 0 then
        lAllDone = 0
      end if
      if (lCurrentTime > pTimeList[li].offsettime) and (pTimeList[li].launched = 0) then
        if pTimeList[li].params <> VOID then
          call(pTimeList[li].functionname, pTimeList[li].scriptname, pTimeList[li].params)
        else
          call(pTimeList[li].functionname, pTimeList[li].scriptname)
        end if
        pTimeList[li].launched = 1
      end if
    end repeat
    return lAllDone
  end if
  return 0
end

on StartSequence me, kSequenceId
  me.ClearAllElements()
  me.ResetElements()
  pActiveSequence = kSequenceId
  lSequence = me.GetSequence(kSequenceId)
  if voidp(lSequence) then
    return 
  end if
  repeat with li = 1 to lSequence.count
    if lSequence[li].findPos(#cast) <> 0 then
      lFunctionCast = lSequence[li].cast
      lFunctionCastScript = script(lFunctionCast)
      if lFunctionCastScript <> VOID then
        lCallbackParams = VOID
        if lSequence[li].findPos(#params) <> 0 then
          lCallbackParams = lSequence[li].params
          me.AddElement(lSequence[li].function, lFunctionCastScript, lCallbackParams, lSequence[li].time)
        else
          me.AddElement(lSequence[li].function, lFunctionCastScript, VOID, lSequence[li].time)
        end if
      end if
      next repeat
    end if
    if lSequence[li].findPos(#object) <> 0 then
      lObject = lSequence[li].object
      if lObject <> VOID then
        if lSequence[li].findPos(#params) <> 0 then
          lCallbackParams = lSequence[li].params
          me.AddElement(lSequence[li].function, lObject, lCallbackParams, lSequence[li].time)
          next repeat
        end if
        me.AddElement(lSequence[li].function, lObject, VOID, lSequence[li].time)
      end if
    end if
  end repeat
  me.BeginSynchronizedTemporization(me.GetTime())
end

on BeginTemporization me
  if pIsActive = #Init then
    pInitTime = me.GetTime()
  else
    pStopDuration = pStopDuration + (me.GetTime() - pStopTime)
  end if
  pIsActive = #running
end

on StopTemporization me
  pIsActive = #stopped
  pStopTime = me.GetTime()
end

on IsSequenceBusy me
  return #running = pIsActive
end

on GetActiveSequence me
  return pActiveSequence
end

on update me
  if pIsActive = #running then
    lCurrentTime = me.GetTime() - pInitTime - pStopDuration
    repeat with li = 1 to pTimeList.count
      if (lCurrentTime > pTimeList[li].offsettime) and (pTimeList[li].launched = 0) then
        if pTimeList[li].params <> VOID then
          call(pTimeList[li].functionname, pTimeList[li].scriptname, pTimeList[li].params)
        else
          call(pTimeList[li].functionname, pTimeList[li].scriptname)
        end if
        put "LANCIO EVENTO " & pTimeList[li].functionname
        pTimeList[li].launched = 1
      end if
    end repeat
  end if
end
