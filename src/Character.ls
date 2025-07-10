property ancestor, pCharacterMdl, pCharacterBase, pCharacterRoot, pPreviousAnimationPlayRate, pCharacterMotionName, pBaseOffset, pBaseRotation, pAnimationDelayStartTime
global gGame

on new me, kCharacterMdl, kCharacterMotionName, kFSM, kInitState
  me.ancestor = script("FSM object").new(kFSM, kInitState)
  pBaseOffset = vector(0.0, 0.0, 0.0)
  pBaseRotation = vector(0.0, 0.0, 0.0)
  pCharacterMdl = kCharacterMdl
  pCharacterMotionName = kCharacterMotionName
  l3D = gGame.Get3D()
  pCharacterBase = l3D.newGroup(pCharacterMdl.name & "_base")
  pCharacterBase.addChild(pCharacterMdl)
  pCharacterRoot = l3D.newGroup(pCharacterMdl.name & "_root")
  pCharacterRoot.addChild(pCharacterBase)
  pCharacterBase.transform.position = pBaseOffset
  pCharacterBase.transform.rotation = pBaseRotation
  pCharacterMdl.bonesPlayer.blendTime = 0
  pCharacterMdl.bonesPlayer.autoBlend = 0
  pCharacterMdl.bonesPlayer.blendFactor = 100
  pCharacterMdl.bonesPlayer.playRate = 1.0
  pCharacterMdl.bonesPlayer.rootLock = 0
  pCharacterRoot.pointAtOrientation = [vector(0.0, 1.0, 0.0), vector(0.0, 0.0, 1.0)]
  pAnimationDelayStartTime = -1
  return me
end

on Destroy me
  l3D = gGame.Get3D()
  l3D.deleteModel(pCharacterBase.name)
  l3D.deleteModel(pCharacterRoot.name)
end

on GetCharacterRoot me
  return pCharacterRoot
end

on GetCharacterMdl me
  return pCharacterMdl
end

on GetCharacterBase me
  return pCharacterBase
end

on getPosition me
  return pCharacterRoot.transform.position
end

on GetTransform me
  return pCharacterRoot.transform
end

on GetBoneWorldTransform me, kBoneName
  lBoneId = pCharacterMdl.resource.getBoneId(kBoneName)
  return pCharacterMdl.bonesPlayer.bone[lBoneId].worldTransform
end

on GetBoneTransform me, kBoneName
  lBoneId = pCharacterMdl.resource.getBoneId(kBoneName)
  return pCharacterMdl.bonesPlayer.bone[lBoneId].transform
end

on GetCurrentAnimationTime me
  return pCharacterMdl.bonesPlayer.currentTime
end

on SetCharacterRoot me, kCharacterRoot
  pCharacterRoot = kCharacterRoot
end

on SetCharacterMdl me, kCharacterMdl
  pCharacterMdl = kCharacterMdl
end

on setPosition me, kPosition
  pCharacterRoot.transform.position = kPosition
end

on SetTransform me, kTransform
  pCharacterRoot.transform = kTransform
end

on SetBaseOffset me, kOffset
  pBaseOffset = kOffset
  pCharacterBase.transform.position = pBaseOffset
end

on SetBaseRotation me, kRotation
  pBaseRotation = kRotation
  pCharacterBase.transform.rotation = pBaseRotation
end

on SetVisibility me, kState
  SetHierarchyVisibility(pCharacterRoot, kState)
end

on SetCurrentAnimationTime me, kTime
  pCharacterMdl.bonesPlayer.currentTime = kTime
end

on WaitAnimationEnd me, kTime, kAnimationState, kAnimationDelayTime
  if pCharacterMdl.bonesPlayer.currentLoopState = 1 then
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

on IsAnimationEnded me, kTime
  if pCharacterMdl.bonesPlayer.currentLoopState = 1 then
    return 1
  end if
  return 0
end

on startAnimation me, kStartTime, kEndTime, kPlayRate, kMotionName
  lMotionName = pCharacterMotionName
  if not voidp(kMotionName) then
    lMotionName = kMotionName
  end if
  pCharacterMdl.bonesPlayer.play(lMotionName, 0, kStartTime, kEndTime, kPlayRate)
  pCharacterMdl.bonesPlayer.queue(lMotionName, 1, kEndTime, kEndTime, 0.0)
end

on StartAnimationLoop me, kStartTime, kEndTime, kPlayRate, kMotionName
  lMotionName = pCharacterMotionName
  if not voidp(kMotionName) then
    lMotionName = kMotionName
  end if
  pCharacterMdl.bonesPlayer.play(lMotionName, 1, kStartTime, kEndTime, kPlayRate)
end

on ResetAnimations me
  lCounter = pCharacterMdl.bonesPlayer.playList.count
  repeat with li = 1 to lCounter
    pCharacterMdl.bonesPlayer.removeLast()
  end repeat
  lTimeSource = gGame.GetTimeManager()
  pCharacterMdl.bonesPlayer.playRate = 1.0 * lTimeSource.GetTimeFactor()
end

on SetPlayRate me, kTimeFactor
  lTimeSource = gGame.GetTimeManager()
  pCharacterMdl.bonesPlayer.playRate = kTimeFactor * lTimeSource.GetTimeFactor()
end

on GetPlayRate me
  lTimeSource = gGame.GetTimeManager()
  lTimeFactor = lTimeSource.GetTimeFactor()
  if lTimeFactor = 0.0 then
    return 0.0
  else
    return pCharacterMdl.bonesPlayer.playRate / lTimeSource.GetTimeFactor()
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
  pPreviousAnimationPlayRate = pCharacterMdl.bonesPlayer.playRate
  pCharacterMdl.bonesPlayer.playRate = 0.0
end

on ResumeAnimations me
  pCharacterMdl.bonesPlayer.playRate = pPreviousAnimationPlayRate
  pPreviousAnimationPlayRate = 1.0
end
