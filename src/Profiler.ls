property pTasks, pLastCalledTask, pLastSampleIdx, pLastRootSampleIdx

on new me
  pLastCalledTask = 0
  pLastSampleIdx = 0
  pLastRootSampleIdx = 0
  pTasks = [:]
  return me
end

on RegisterTask me, lTaskSym, lTaskName
  lTask = [#name: lTaskName, #LastCall: 0, #LastParent: 0, #LastParentSample: 0, #Samples: []]
  pTasks.addProp(lTaskSym, lTask)
end

on UnregisterTask me, lTaskSym
  lPos = findPos(pTasks, lTaskSym)
  if not voidp(lPos) then
    pTasks.deleteAt(lPos)
  end if
end

on STARTPROFILE me, lTaskSym
  lTask = pTasks[lTaskSym]
  assert(not voidp(lTask), "Undefined task: " & lTaskSym)
  lTask.LastCall = the milliSeconds
  lTask.LastParent = pLastCalledTask
  lTask.LastParentSample = pLastSampleIdx
  pLastCalledTask = lTaskSym
  pLastSampleIdx = lTask.Samples.count + 1
  if lTaskSym = #ROOT then
    pLastRootSampleIdx = pLastSampleIdx
  end if
end

on ENDPROFILE me
  if pLastCalledTask = 0 then
    return 
  end if
  lNow = the milliSeconds
  lTask = pTasks[pLastCalledTask]
  lSample = [#time: lNow - lTask.LastCall, #parent: lTask.LastParent, #parentSample: lTask.LastParentSample, #rootParentSample: pLastRootSampleIdx]
  lTask.Samples.append(lSample)
  pLastCalledTask = lTask.LastParent
  pLastSampleIdx = lTask.LastParentSample
end

on Output me
  put "-------------------------- profiler output --------------------------------------"
  repeat with lTask in pTasks
    put "---------------------------------------------------------------------------------"
    put "- task name: " & lTask.name & ", # of samples: " & lTask.Samples.count
    lTotTime = 0
    lAvgTime = 0
    lMinTime = 10000000000.0
    lMaxTime = 0
    lParentsInfo = [:]
    lRootParentTime = [:]
    repeat with lSample in lTask.Samples
      lSampleTime = lSample.time
      lSampleParent = lSample.parent
      lSampleParentIdx = lSample.parentSample
      lSampleRootParentIdx = lSample.rootParentSample
      lTotTime = lTotTime + lSampleTime
      lRootTime = lRootParentTime.getaProp(lSampleRootParentIdx)
      if voidp(lRootTime) then
        lRootParentTime.addProp(lSampleRootParentIdx, [lSampleRootParentIdx, lSampleTime])
      else
        lRootTime[2] = lRootTime[2] + lSampleTime
      end if
      if lSampleTime < lMinTime then
        lMinTime = lSampleTime
      end if
      if lSampleTime > lMaxTime then
        lMaxTime = lSampleTime
      end if
      if lSampleParent <> 0 then
        lTaskParent = pTasks[lSampleParent]
        lPos = findPos(lParentsInfo, lSampleParent)
        if voidp(lPos) then
          lParentsInfo.addProp(lSampleParent, [#name: lTaskParent.name, #Sym: lSampleParent, #nCalls: 0, #totT: 0, #avgT: 0, #minT: 10000000000.0, #maxT: 0, #totP: 0.0, #avgP: 0.0, #minP: 100.0, #maxP: 0.0, #SampleParentTime: [:]])
        end if
        lParentInfo = lParentsInfo[lSampleParent]
        lParentInfo.nCalls = lParentInfo.nCalls + 1
        lParentInfo.totT = lParentInfo.totT + lSampleTime
        if lSampleTime < lParentInfo.minT then
          lParentInfo.minT = lSampleTime
        end if
        if lSampleTime > lParentInfo.maxT then
          lParentInfo.maxT = lSampleTime
        end if
        lSampleParentTotTime = lParentInfo.SampleParentTime.getaProp(lSampleParentIdx)
        if voidp(lSampleParentTotTime) then
          lParentInfo.SampleParentTime.addProp(lSampleParentIdx, [lSampleParentIdx, lSampleTime])
          next repeat
        end if
        lSampleParentTotTime[2] = lSampleParentTotTime[2] + lSampleTime
      end if
    end repeat
    repeat with lInfo in lParentsInfo
      lTaskParent = pTasks[lInfo.Sym]
      lSampleParentTime = lInfo.SampleParentTime
      repeat with lItem in lSampleParentTime
        lSampleParentIdx = lItem[1]
        lSampleTime = lItem[2]
        if lSampleParentIdx <= lTaskParent.Samples.count then
          lTime = lTaskParent.Samples[lSampleParentIdx].time
          if lTime > 0 then
            lPerc = float(lSampleTime) * 100.0 / float(lTime)
          else
            lPerc = 0.0
          end if
        else
          assert(0, "Profiler error")
        end if
        lParentInfo.totP = lParentInfo.totP + lPerc
        if lPerc < lParentInfo.minP then
          lParentInfo.minP = lPerc
        end if
        if lPerc > lParentInfo.maxP then
          lParentInfo.maxP = lPerc
        end if
      end repeat
    end repeat
    if lTask.Samples.count > 0 then
      lAvgTime = float(lTotTime) / float(lTask.Samples.count)
    else
      lAvgTime = 0.0
    end if
    lTotPerc = 0
    repeat with lItem in lRootParentTime
      if lItem[1] > pTasks[#ROOT].Samples.count then
        next repeat
      end if
      lRootTime = pTasks[#ROOT].Samples[lItem[1]].time
      if lRootTime > 0 then
        lPerc = float(lItem[2]) * 100.0 / float(lRootTime)
      else
        lPerc = 0
      end if
      lTotPerc = lTotPerc + lPerc
    end repeat
    if lRootParentTime.count > 0 then
      lAvgPerc = float(lTotPerc) / float(lRootParentTime.count)
    else
      lAvgPerc = 0.0
    end if
    put " tot: " & lTotTime && "min: " & lMinTime && "avg: " & lAvgTime && "max: " & lMaxTime && "prc: " & lAvgPerc
    repeat with lj = 1 to lParentsInfo.count
      lParentInfo = lParentsInfo[lj]
      if lParentInfo.nCalls > 0 then
        lParentInfo.avgT = float(lParentInfo.totT) / float(lParentInfo.nCalls)
      else
        lParentInfo.avgT = 0.0
      end if
      if lParentInfo.SampleParentTime.count > 0 then
        lParentInfo.avgP = float(lParentInfo.totP) / float(lParentInfo.SampleParentTime.count)
      else
        lParentInfo.avgP = 0.0
      end if
      put " parent: " & lParentInfo.name & ", # of calls: " & lParentInfo.nCalls
      put "  totT: " & lParentInfo.totT && "minT: " & lParentInfo.minT && "avgT: " & lParentInfo.avgT && "maxT: " & lParentInfo.maxT
      put "  minP: " & lParentInfo.minP && "avgP: " & lParentInfo.avgP && "maxP: " & lParentInfo.maxP
    end repeat
    put "---------------------------------------------------------------------------------"
  end repeat
end
