property pTimeSource, pActiveEffects, pParticlesTextureList, pEmitterPropertiesList
global gGame

on new me, kTimeSource
  pActiveEffects = [:]
  pParticlesTextureList = [:]
  pEmitterPropertiesList = [:]
  pTimeSource = kTimeSource
  return me
end

on CreateTextureFromCastMember me, fpMember, fMemberName
  lParticleTexture = fpMember.newTexture(fMemberName, #fromImageObject, member(fMemberName).image)
  li = findPos(pParticlesTextureList, fMemberName)
  if li > 0 then
    return #nameAlreadyExist
  else
    pParticlesTextureList.addProp(fMemberName, lParticleTexture)
    return #Ok
  end if
end

on CreateTextureFromModel me, fpMember, fModelName
  lParticleTexture = fpMember.model(fModelName).shader.texture
  li = findPos(pParticlesTextureList, fModelName)
  if li > 0 then
    return #nameAlreadyExist
  else
    pParticlesTextureList.addProp(fModelName, lParticleTexture)
    return #Ok
  end if
end

on CreateTexture me, fpMember, fTextureName
  lParticleTexture = fpMember.texture(fTextureName)
  li = findPos(pParticlesTextureList, fTextureName)
  if li > 0 then
    return #nameAlreadyExist
  else
    pParticlesTextureList.addProp(fTextureName, lParticleTexture)
    return #Ok
  end if
end

on GetTexture me, fName
  return getProp(pParticlesTextureList, fName)
end

on GetEmitter me, fName
  return getProp(pEmitterPropertiesList, fName)
end

on AddEffect me, fEmitterName, fEmitterProperties
  li = findPos(pEmitterPropertiesList, fEmitterName)
  if li > 0 then
    return #propertiesAlreadyExist
  else
    pEmitterPropertiesList.addProp(fEmitterName, fEmitterProperties)
    return #Ok
  end if
end

on AddParticles me, fName, fParticleEffect, fPosition, fDuration, fDeleteTime, fBone, foffset
  li = findPos(pActiveEffects, fName)
  if li > 0 then
    return #nameAlreadyExist
  else
    if fDuration <> -1 then
      fDuration = fDuration + pTimeSource.GetTime()
      fDeleteTime = fDeleteTime + pTimeSource.GetTime()
    end if
    pActiveEffects.addProp(fName, [#effect: fParticleEffect, #position: fPosition, #offset: foffset, #bone: fBone, #duration: fDuration, #deletetime: fDeleteTime])
    return #Ok
  end if
end

on GetEffectTransform me, kActEffect
  if not voidp(kActEffect.bone) then
    lOffset = transform()
    if not voidp(kActEffect.offset) then
      lOffset.translate(kActEffect.offset)
    end if
    lCharaMdl = kActEffect.position.GetCharacterMdl()
    lCharaBase = kActEffect.position.GetCharacterBase()
    lCharaRoot = kActEffect.position.GetCharacterRoot()
    lCharaSuperRoot = VOID
    if lCharaRoot.parent <> gGame.Get3D().group("world") then
      lCharaSuperRoot = lCharaRoot.parent
    end if
    lId = lCharaMdl.resource.getBoneId(kActEffect.bone)
    lBoneWorldTr = lCharaRoot.transform * lCharaBase.transform * lCharaMdl.bonesPlayer.bone[lId].worldTransform * lOffset
    if not voidp(lCharaSuperRoot) then
      lBoneWorldTr = lCharaSuperRoot.getWorldTransform() * lBoneWorldTr
    end if
    lTransf = lBoneWorldTr
  else
    if not voidp(kActEffect.position) then
      lTransf = kActEffect.position.getWorldTransform()
    else
      lTransf = VOID
    end if
  end if
  return lTransf
end

on update me, fCurrentTime
  repeat with li = pActiveEffects.count down to 1
    lActEffect = pActiveEffects[li]
    lTransf = me.GetEffectTransform(lActEffect)
    lActEffect.effect.UpdateParticle(lTransf)
    if lActEffect.duration <> -1 then
      if fCurrentTime > lActEffect.duration then
        lActEffect.effect.StopParticle()
        if (lActEffect.deletetime <> -1) and (fCurrentTime > lActEffect.deletetime) then
          delete lActEffect.effect
          pActiveEffects.deleteAt(li)
        end if
      end if
    end if
  end repeat
end

on DeleteByName me, fName
  lIdx = pActiveEffects.findPos(fName)
  if not voidp(lIdx) then
    delete pActiveEffects[lIdx].effect
    pActiveEffects.deleteAt(lIdx)
  end if
end

on StartParticle me, fName
  lTransf = me.GetEffectTransform(pActiveEffects[fName])
  pActiveEffects[fName].effect.StartParticle(lTransf)
end

on GetParticle me, fName
  return pActiveEffects[fName].effect
end

on StopParticle me, fName
  pActiveEffects[fName].effect.StopParticle()
end

on StopParticleImmediately me, fName
  if not voidp(pActiveEffects[fName]) then
    pActiveEffects[fName].effect.ImmediateStop()
  end if
end

on GetRegisteredTextureNumber me
  return pParticlesTextureList.count
end

on GetRegisteredEmittersNumber me
  return pEmitterPropertiesList.count
end

on ChangeTimeFactor me, kTimeFactor
  repeat with li = 1 to pActiveEffects.count
    lEffect = pActiveEffects[li]
    lEffect.effect.SetTimeFactor(kTimeFactor)
  end repeat
end

on StopAllParticles me
  repeat with li = 1 to pActiveEffects.count
    lEffect = pActiveEffects[li]
    lEffect.effect.StopParticle()
  end repeat
end

on GetActiveEffect me, fName
  lIdx = pActiveEffects.findPos(fName)
  if not voidp(lIdx) then
    return pActiveEffects[fName].effect
  else
    return VOID
  end if
end
