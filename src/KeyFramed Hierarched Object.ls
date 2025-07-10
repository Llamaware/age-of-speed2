property ancestor, pObjectMdl, pKeyFramedList, pPreviousAnimationPlayRate, pAnimationDelayStartTime
global gGame

on new me, kObjectMdl, kFSM, kInitState
  if not voidp(kFSM) then
    ancestor = script("FSM object").new(kFSM, kInitState)
  end if
  pObjectMdl = kObjectMdl
  pKeyFramedList = []
  me.Init(pObjectMdl)
  pAnimationDelayStartTime = -1
  return me
end

on GetObjectMdl me
  return pObjectMdl
end

on getPosition me
  return pObjectMdl.transform.position
end

on GetTransform me
  return pObjectMdl.transform
end

on GetKeyFramedList me
  return pKeyFramedList
end

on SetObjectMdl me, kObjectMdl
  pObjectMdl = kObjectMdl
end

on setPosition me, kPosition
  pObjectMdl.transform.position = kPosition
end

on SetTransform me, kTransform
  pObjectMdl.transform = kTransform
end

on SetRotation me, kRotation
  pObjectMdl.transform.rotation = kRotation
end

on SetVisibility me, kState
  SetHierarchyVisibility(pObjectMdl, kState)
end

on InitKeyframeObj me, kObj
  lIsKeyFramedObj = 0
  if ilk(kObj) <> #group then
    repeat with lj = 1 to kObj.modifier.count
      if kObj.modifier[lj] = #keyframePlayer then
        lIsKeyFramedObj = 1
        exit repeat
      end if
    end repeat
  end if
  if lIsKeyFramedObj then
    kObj.keyframePlayer.blendTime = 0
    kObj.keyframePlayer.autoBlend = 0
    kObj.keyframePlayer.blendFactor = 100
    kObj.keyframePlayer.playRate = 1.0
    kObj.keyframePlayer.rootLock = 0
    lMotionName = getProp(kObj.keyframePlayer.playList[1], #name)
    pKeyFramedList.add([#mdl: kObj, #motionName: lMotionName])
  end if
end

on HasModifier me, lKeyFrameMdl, lModifier
  repeat with li = 1 to lKeyFrameMdl.modifier.count
    if lKeyFrameMdl.modifier[li] = lModifier then
      return 1
    end if
  end repeat
  return 0
end

on Init me, kBaseMdl
  me.InitKeyframeObj(kBaseMdl)
  repeat with li = 1 to kBaseMdl.child.count
    lChild = kBaseMdl.child[li]
    me.Init(lChild)
  end repeat
end

on WaitAnimationEnd me, kTime, kAnimationState, kAnimationDelayTime
  lKeyframeToCheck = pKeyFramedList[1].mdl
  if (lKeyframeToCheck.keyframePlayer.playList.count = 0) or (lKeyframeToCheck.keyframePlayer.currentLoopState = 1) then
    if not voidp(kAnimationDelayTime) then
      if kTime > (pAnimationDelayStartTime + kAnimationDelayTime) then
        me.ChangeState(kAnimationState, kTime)
      end if
    else
      me.ChangeState(kAnimationState, kTime)
    end if
  else
    pAnimationDelayStartTime = kTime
  end if
end

on IsAnimationEnded me
  lKeyframeToCheck = pKeyFramedList[1].mdl
  return lKeyframeToCheck.keyframePlayer.currentLoopState
end

on GetMotionDuration me
  lMotionToCheck = pKeyFramedList[1].motionName
  return gGame.Get3D().motion(lMotionToCheck).duration
end

on startAnimation me, kStartTime, kEndTime, kPlayRate
  repeat with li = 1 to pKeyFramedList.count
    lKeyFramedMdl = pKeyFramedList[li].mdl
    lMotionName = pKeyFramedList[li].motionName
    lKeyFramedMdl.addModifier(#keyframePlayer)
    lKeyFramedMdl.keyframePlayer.play(lMotionName, 0, kStartTime, kEndTime, kPlayRate)
  end repeat
end

on StartAnimationLoop me, kStartTime, kEndTime, kPlayRate
  repeat with li = 1 to pKeyFramedList.count
    lKeyFramedMdl = pKeyFramedList[li].mdl
    lMotionName = pKeyFramedList[li].motionName
    lKeyFramedMdl.addModifier(#keyframePlayer)
    lKeyFramedMdl.keyframePlayer.play(lMotionName, 1, kStartTime, kEndTime, kPlayRate)
  end repeat
end

on ClearPlaylist me
  lTimeFactor = gGame.GetTimeManager().GetTimeFactor()
  repeat with li = 1 to pKeyFramedList.count
    lKeyFramedMdl = pKeyFramedList[li].mdl
    lMotionName = pKeyFramedList[li].motionName
    if me.HasModifier(lKeyFramedMdl, #keyframePlayer) then
      lCounter = lKeyFramedMdl.keyframePlayer.playList.count
      repeat with lj = 1 to lCounter
        lKeyFramedMdl.keyframePlayer.removeLast()
      end repeat
      lKeyFramedMdl.keyframePlayer.playRate = lTimeFactor
    end if
  end repeat
end

on ResetAnimations me
  lTimeFactor = gGame.GetTimeManager().GetTimeFactor()
  repeat with li = 1 to pKeyFramedList.count
    lKeyFramedMdl = pKeyFramedList[li].mdl
    lMotionName = pKeyFramedList[li].motionName
    if me.HasModifier(lKeyFramedMdl, #keyframePlayer) then
      lCounter = lKeyFramedMdl.keyframePlayer.playList.count
      repeat with lj = 1 to lCounter
        lKeyFramedMdl.keyframePlayer.removeLast()
      end repeat
      lKeyFramedMdl.keyframePlayer.playRate = lTimeFactor
      lKeyFramedMdl.removeModifier(#keyframePlayer)
    end if
  end repeat
end

on SetPlayRate me, kTimeFactor
  lTimeFactor = gGame.GetTimeManager().GetTimeFactor()
  repeat with li = 1 to pKeyFramedList.count
    lKeyFramedMdl = pKeyFramedList[li].mdl
    if me.HasModifier(lKeyFramedMdl, #keyframePlayer) then
      lKeyFramedMdl.keyframePlayer.playRate = kTimeFactor * lTimeFactor
    end if
  end repeat
end

on GetPlayRate me
  lTimeFactor = gGame.GetTimeManager().GetTimeFactor()
  if lTimeFactor = 0.0 then
    return 0.0
  else
    return pKeyFramedList[1].keyframePlayer.playRate / lTimeFactor
  end if
end

on GamePaused me
  me.PauseAnimations()
end

on GameResumed me
  me.ResumeAnimations()
end

on PauseAnimations me
  if pKeyFramedList.count > 0 then
    if me.HasModifier(pKeyFramedList[1].mdl, #keyframePlayer) then
      pPreviousAnimationPlayRate = pKeyFramedList[1].mdl.keyframePlayer.playRate
      repeat with li = 1 to pKeyFramedList.count
        lKeyFramedMdl = pKeyFramedList[li].mdl
        lKeyFramedMdl.keyframePlayer.playRate = 0.0
      end repeat
    end if
  end if
end

on ResumeAnimations me
  if pKeyFramedList.count > 0 then
    repeat with li = 1 to pKeyFramedList.count
      lKeyFramedMdl = pKeyFramedList[li].mdl
      if me.HasModifier(lKeyFramedMdl, #keyframePlayer) then
        lKeyFramedMdl.keyframePlayer.playRate = pPreviousAnimationPlayRate
      end if
    end repeat
  end if
end

on SetCurrentAnimTime me, kCurrentAnimTime
  repeat with li = 1 to pKeyFramedList.count
    lKeyFramedMdl = pKeyFramedList[li].mdl
    lKeyFramedMdl.keyframePlayer.currentTime = kCurrentAnimTime
  end repeat
end

on GetCurrentAnimTime me
  if pKeyFramedList.count = 0 then
    return -1
  end if
  lKeyFramedMdl = pKeyFramedList[1].mdl
  return lKeyFramedMdl.keyframePlayer.currentTime
end
