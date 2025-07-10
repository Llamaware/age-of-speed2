property ancestor, pObjectMdl, pObjectBase, pObjectRoot, pPreviousAnimationPlayRate, pMotionName, pBaseOffset, pBaseRotation
global gGame

on new me, kObjectMdl, kMotionName, kFSM, kInitState
  me.ancestor = script("FSM object").new(kFSM, kInitState)
  pBaseOffset = vector(0.0, 0.0, 0.0)
  pBaseRotation = vector(0.0, 0.0, 0.0)
  pObjectMdl = kObjectMdl
  pMotionName = kMotionName
  l3D = gGame.Get3D()
  pObjectBase = l3D.newGroup(pObjectMdl.name & "_base")
  pObjectBase.addChild(pObjectMdl)
  pObjectRoot = l3D.newGroup(pObjectMdl.name & "_root")
  pObjectRoot.addChild(pObjectBase)
  pObjectBase.transform.identity()
  pObjectBase.transform.position = pBaseOffset
  pObjectBase.transform.rotation = pBaseRotation
  pObjectMdl.keyframePlayer.blendTime = 0
  pObjectMdl.keyframePlayer.autoBlend = 0
  pObjectMdl.keyframePlayer.blendFactor = 100
  pObjectMdl.keyframePlayer.playRate = 1.0
  pObjectMdl.keyframePlayer.rootLock = 0
  pObjectMdl.pointAtOrientation = [vector(0.0, 1.0, 0.0), vector(0.0, 0.0, 1.0)]
  return me
end

on Destroy me
  l3D = gGame.Get3D()
  l3D.deleteModel(pObjectBase.name)
  l3D.deleteModel(pObjectRoot.name)
end

on GetObjectRoot me
  return pObjectRoot
end

on GetObjectMdl me
  return pObjectMdl
end

on GetObjectBase me
  return pObjectBase
end

on getPosition me
  return pObjectRoot.transform.position
end

on GetTransform me
  return pObjectRoot.transform
end

on GetCurrentAnimationTime me
  return pObjectMdl.keyframePlayer.currentTime
end

on SetObjectRoot me, kObjectRoot
  pObjectRoot = kObjectRoot
end

on SetObjectMdl me, kObjectMdl
  pObjectMdl = kObjectMdl
end

on setPosition me, kPosition
  pObjectRoot.transform.position = kPosition
end

on SetTransform me, kTransform
  pObjectRoot.transform = kTransform
end

on SetBaseOffset me, kOffset
  pBaseOffset = kOffset
  pObjectBase.transform.position = pBaseOffset
end

on SetBaseRotation me, kRotation
  pBaseRotation = kRotation
  pObjectBase.transform.rotation = pBaseRotation
end

on SetVisibility me, kState
  SetHierarchyVisibility(pObjectRoot, kState)
end

on SetCurrentAnimationTime me, kTime
  pObjectMdl.keyframePlayer.currentTime = kTime
end

on WaitAnimationEnd me, kTime, kAnimationState
  if pObjectMdl.keyframePlayer.currentLoopState = 1 then
    me.ChangeState(kAnimationState, kTime)
  end if
end

on startAnimation me, kStartTime, kEndTime, kPlayRate
  pObjectMdl.keyframePlayer.play(pMotionName, 0, kStartTime, kEndTime, kPlayRate)
  pObjectMdl.keyframePlayer.queue(pMotionName, 1, kEndTime, kEndTime, 0.0)
end

on StartAnimationLoop me, kStartTime, kEndTime, kPlayRate
  pObjectMdl.keyframePlayer.play(pMotionName, 1, kStartTime, kEndTime, kPlayRate)
end

on ResetAnimations me
  lCounter = pObjectMdl.keyframePlayer.playList.count
  repeat with li = 1 to lCounter
    pObjectMdl.keyframePlayer.removeLast()
  end repeat
  lTimeSource = gGame.GetTimeManager()
  pObjectMdl.keyframePlayer.playRate = 1.0 * lTimeSource.GetTimeFactor()
end

on SetPlayRate me, kTimeFactor
  lTimeSource = gGame.GetTimeManager()
  pObjectMdl.keyframePlayer.playRate = kTimeFactor * lTimeSource.GetTimeFactor()
end

on GetPlayRate me
  lTimeSource = gGame.GetTimeManager()
  lTimeFactor = lTimeSource.GetTimeFactor()
  if lTimeFactor = 0.0 then
    return 0.0
  else
    return pObjectMdl.keyframePlayer.playRate / lTimeSource.GetTimeFactor()
  end if
end

on update me, kTime
  me.ancestor.update(kTime)
end

on GamePaused me
  me.PauseAnimations()
end

on GameResumed me
  me.ResumeAnimations()
end

on PauseAnimations me
  pPreviousAnimationPlayRate = pObjectMdl.keyframePlayer.playRate
  pObjectMdl.keyframePlayer.playRate = 0.0
end

on ResumeAnimations me
  pObjectMdl.keyframePlayer.playRate = pPreviousAnimationPlayRate
  pPreviousAnimationPlayRate = 1.0
end
