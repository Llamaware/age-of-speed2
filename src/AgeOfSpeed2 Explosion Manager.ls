property pActiveExplosions, pModelsPool, pTextureShiftX, pTextureShiftY, pTextureShiftTime
global gGame

on new me, kMdlName, kPoolSize
  pActiveExplosions = []
  pTextureShiftX = 0.0
  pTextureShiftY = -0.12
  pTextureShiftTime = 50.0
  pModelsPool = []
  repeat with li = 1 to kPoolSize
    lMdl = gGame.Get3D().model(kMdlName).cloneDeep("explosion_sphere_" & li & "_dyn")
    pModelsPool.add([#mdl: lMdl, #free: 1, #shaderShift: 0])
  end repeat
  gGame.Get3D().deleteModel(kMdlName)
  return me
end

on SetTextureShiftX me, kTextureShiftX
  pTextureShiftX = kTextureShiftX
end

on SetTextureShiftY me, kTextureShiftY
  pTextureShiftY = kTextureShiftY
end

on SetTextureShiftTime me, kTextureShiftTime
  pTextureShiftTime = kTextureShiftTime
end

on GetExplosionMdl me
  lReturn = VOID
  repeat with li = 1 to pModelsPool.count
    lModelPoolRef = pModelsPool[li]
    if lModelPoolRef.free then
      lModelPoolRef.free = 0
      lReturn = [#mdl: lModelPoolRef.mdl, #index: li]
      exit repeat
    end if
  end repeat
  return lReturn
end

on FreeExplosionMdl me, kIndex
  pModelsPool[kIndex].free = 1
  pModelsPool[kIndex].mdl.removeFromWorld()
end

on AddActiveExplosion me, kExplosionPosition, kScaleFactor
  lExplosionMdlData = me.GetExplosionMdl()
  if not voidp(lExplosionMdlData) then
    lNewExplosion = script("AgeOfSpeed2 Explosion").new(kExplosionPosition, lExplosionMdlData, kScaleFactor)
    pActiveExplosions.add(lNewExplosion)
  end if
end

on update me, kTime
  repeat with li = pActiveExplosions.count down to 1
    lDone = pActiveExplosions[li].update(kTime)
    if lDone then
      pActiveExplosions.deleteAt(li)
    end if
  end repeat
end
