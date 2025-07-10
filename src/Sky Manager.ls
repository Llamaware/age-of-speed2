property pSkyModelRef, pSkyModelOffsetFromTarget, pSkyBlendRefList, pZFixed
global gGame

on new me, kZFixed
  pSkyModelRef = VOID
  pSkyModelOffsetFromTarget = vector(0.0, 0.0, 0.0)
  pSkyBlendRefList = []
  if voidp(kZFixed) then
    pZFixed = 1
  else
    pZFixed = kZFixed
  end if
  return me
end

on Initialize me, kSkyModelRef, kSkyModelOffsetFromTarget
  pSkyModelRef = kSkyModelRef
  pSkyModelOffsetFromTarget = kSkyModelOffsetFromTarget
end

on SetNewTextureLayer me, kMeshID, kTextureLayerId, kShaderName, kTextureName
  pSkyModelRef.resource.lod.auto = 0
  pSkyModelRef.resource.lod.level = 100
  pSkyModelRef.addModifier(#meshDeform)
  if pSkyModelRef.meshDeform.mesh[kMeshID].textureLayer.count = 1 then
    pSkyModelRef.meshDeform.mesh[kMeshID].textureLayer.add()
    pSkyModelRef.meshDeform.mesh[kMeshID].textureLayer[kTextureLayerId].textureCoordinateList = pSkyModelRef.meshDeform.mesh[1].textureLayer[1].textureCoordinateList
  end if
  repeat with lj = 1 to pSkyModelRef.shaderList.count
    lShaderRef = pSkyModelRef.shaderList[lj]
    if lShaderRef.name starts kShaderName then
      lShaderRef.textureList[kTextureLayerId] = gGame.Get3D().texture(kTextureName)
      lShaderRef.blendFunctionList[kTextureLayerId] = #blend
      lShaderRef.blendConstantList[kTextureLayerId] = 0
      pSkyBlendRefList.add(lShaderRef)
    end if
  end repeat
  pSkyModelRef.removeModifier(#meshDeform)
  return pSkyBlendRefList.count
end

on SetTextureLayerBlend me, kIdx, kTextureLayerId, kBlend
  pSkyBlendRefList[kIdx].blendConstantList[kTextureLayerId] = kBlend
end

on update me, kTargetRef
  if pSkyModelRef <> VOID then
    lOffset = kTargetRef.getPosition().duplicate()
    if pZFixed then
      lOffset.z = 0.0
    end if
    pSkyModelRef.transform.position = lOffset + pSkyModelOffsetFromTarget
  end if
end
