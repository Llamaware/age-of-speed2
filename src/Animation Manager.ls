property pScene, pAnimModels, pOldTimeFactor

on new me
  pScene = VOID
  return me
end

on Initialize me, kScene
  pScene = kScene
  pAnimModels = []
  repeat with li = 1 to pScene.model.count
    lMdl = pScene.model[li]
    repeat with lj = 1 to lMdl.modifier.count
      if lMdl.modifier[lj] = #bonesPlayer then
        pAnimModels.append([#model: lMdl, #anim: #bones])
      end if
      if lMdl.modifier[lj] = #keyframePlayer then
        pAnimModels.append([#model: lMdl, #anim: #keyframes])
      end if
    end repeat
  end repeat
  pOldTimeFactor = 1.0
end

on RefreshPlayrates me, kNewTimeFactor
  if pOldTimeFactor = 0.0 then
    pOldTimeFactor = 0.00001
  end if
  if kNewTimeFactor = 0.0 then
    kNewTimeFactor = 0.00001
  end if
  if not voidp(pAnimModels) then
    repeat with li = 1 to pAnimModels.count
      lAnimMdl = pAnimModels[li]
      lMdl = lAnimMdl.model
      lAnim = lAnimMdl.anim
      if voidp(lMdl) then
        next repeat
      end if
      if lAnim = #bones then
        lOldPlayrate = lMdl.bonesPlayer.playRate / pOldTimeFactor
        lMdl.bonesPlayer.playRate = lOldPlayrate * kNewTimeFactor
        lOldBlendTime = lMdl.bonesPlayer.blendTime / pOldTimeFactor
        lMdl.bonesPlayer.blendTime = lOldBlendTime * kNewTimeFactor
        next repeat
      end if
      if lAnim = #keyframes then
        lOldPlayrate = lMdl.keyframePlayer.playRate / pOldTimeFactor
        lMdl.keyframePlayer.playRate = lOldPlayrate * kNewTimeFactor
        lOldBlendTime = lMdl.keyframePlayer.blendTime / pOldTimeFactor
        lMdl.keyframePlayer.blendTime = lOldBlendTime * kNewTimeFactor
        next repeat
      end if
    end repeat
  end if
  pOldTimeFactor = kNewTimeFactor
end
