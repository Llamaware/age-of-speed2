on GetFace kDestFace, kSrcModel, kDestVerticies, kSrcVerticies, kVertexDelta
  lVertices = []
  repeat with li = 1 to kDestFace.count
    lVertices.add(kDestVerticies[kDestFace[li]])
  end repeat
  repeat with li = 1 to kSrcModel.meshDeform.mesh[1].face.count
    lFace = kSrcModel.meshDeform.mesh[1].face[li]
    lMatchCount = 0
    repeat with lj = 1 to lFace.count
      if lVertices.getOne(kSrcVerticies[lFace[lj]]) then
        lMatchCount = lMatchCount + 1
        next repeat
      end if
      exit repeat
    end repeat
    if lMatchCount >= lFace.count then
      return li
    end if
  end repeat
  repeat with li = 1 to kSrcModel.meshDeform.mesh[1].face.count
    lFace = kSrcModel.meshDeform.mesh[1].face[li]
    lMatchCount = 0
    repeat with lj = 1 to lFace.count
      lVertex = lVertices[lj]
      if (lVertex - kSrcVerticies[lFace[lj]]).magnitude < kVertexDelta then
        lMatchCount = lMatchCount + 1
        next repeat
      end if
      exit repeat
    end repeat
    if lMatchCount >= lFace.count then
      return li
    end if
  end repeat
  put "face not found 2"
  return 0
end

on GetPreilluminationData kSrcModel, kDestModel
  kSrcModel.resource.lod.auto = 0
  kSrcModel.resource.lod.level = 100
  kDestModel.resource.lod.auto = 0
  kDestModel.resource.lod.level = 100
  kSrcModel.addModifier(#meshDeform)
  kDestModel.addModifier(#meshDeform)
  if not kSrcModel.modifier[1] = #meshDeform then
    oo = 3
  end if
  lSrcVerticies = kSrcModel.meshDeform.mesh[1].vertexList
  lSrcTextureCoordinates = kSrcModel.meshDeform.mesh[1].textureCoordinateList
  if kSrcModel.meshDeform.mesh.count > 1 then
    y = 19
  end if
  if lSrcTextureCoordinates.count = 0 then
    return VOID
  end if
  lPreilluminationData = []
  repeat with li = 1 to kDestModel.meshDeform.mesh.count
    lMeshTextureCoordinates = []
    lDestVerticies = kDestModel.meshDeform.mesh[li].vertexList
    repeat with lj = 1 to kDestModel.meshDeform.mesh[li].face.count
      lDestFace = kDestModel.meshDeform.mesh[li].face[lj]
      lSrcFaceIndex = GetFace(lDestFace, kSrcModel, lDestVerticies, lSrcVerticies, 1.0)
      if lSrcFaceIndex = 0 then
        next repeat
      end if
      lSrcFace = kSrcModel.meshDeform.mesh[1].face[lSrcFaceIndex]
      repeat with lk = 1 to lDestFace.count
        lMeshTextureCoordinates[lDestFace[lk]] = lSrcTextureCoordinates[lSrcFace[lk]]
      end repeat
    end repeat
    repeat with lj = 1 to lMeshTextureCoordinates.count
      if lMeshTextureCoordinates[lj].ilk <> #list then
        lMeshTextureCoordinates[lj] = [0.0, 0.0]
      end if
    end repeat
    lPreilluminationData.add(lMeshTextureCoordinates)
  end repeat
  kSrcModel.removeModifier(#meshDeform)
  kDestModel.removeModifier(#meshDeform)
  return lPreilluminationData
end

on DuplicateShader kMember, kSrcShader, kDestShaderName
  lShader = kMember.newShader(kDestShaderName, #standard)
  CopyShader(lShader, kSrcShader, 0)
  return lShader
end

on CopyShader kDestShader, kSrcShader, kExcludeTexture
  kDestShader.ambient = kSrcShader.ambient
  kDestShader.diffuse = kSrcShader.diffuse
  kDestShader.specular = kSrcShader.specular
  kDestShader.shininess = kSrcShader.shininess
  kDestShader.emissive = kSrcShader.emissive
  kDestShader.blend = kSrcShader.blend
  kDestShader.transparent = kSrcShader.transparent
  kDestShader.ambient = kSrcShader.ambient
  repeat with li = 1 to kSrcShader.blendConstantList.count
    kDestShader.blendConstantList[li] = kSrcShader.blendConstantList[li]
  end repeat
  repeat with li = 1 to kSrcShader.blendFunctionList.count
    kDestShader.blendSourceList[li] = kSrcShader.blendSourceList[li]
  end repeat
  repeat with li = 1 to kSrcShader.blendFunctionList.count
    kDestShader.blendFunctionList[li] = kSrcShader.blendFunctionList[li]
  end repeat
  kDestShader.diffuse = kSrcShader.diffuse
  kDestShader.specular = kSrcShader.specular
  if not kExcludeTexture then
    repeat with li = 1 to kSrcShader.textureList.count
      kDestShader.textureList[li] = kSrcShader.textureList[li]
    end repeat
  end if
  repeat with li = 1 to kSrcShader.textureList.count
    kDestShader.textureModeList[li] = kSrcShader.textureModeList[li]
  end repeat
  repeat with li = 1 to kSrcShader.textureList.count
    kDestShader.wrapTransformList[li] = kSrcShader.wrapTransformList[li]
  end repeat
  repeat with li = 1 to kSrcShader.textureList.count
    kDestShader.textureTransformList[li] = kSrcShader.textureTransformList[li]
  end repeat
  repeat with li = 1 to kSrcShader.textureList.count
    kDestShader.textureRepeatList[li] = kSrcShader.textureRepeatList[li]
  end repeat
  kDestShader.texture = kSrcShader.texture
  kDestShader.reflectionMap = kSrcShader.reflectionMap
  kDestShader.useDiffuseWithTexture = kSrcShader.useDiffuseWithTexture
  kDestShader.textureTransform = kSrcShader.textureTransform
  return kDestShader
end

on PrecalculatePreillimination kMember, kLightMapModelPrefix, kLightmapW3dMember
  lLevelPreilluminationData = []
  repeat with li = kLightmapW3dMember.model.count down to 1
    lModelRef = kLightmapW3dMember.model[li]
    lModelName = lModelRef.name
    if lModelName starts kLightMapModelPrefix then
      lDestModelName = chars(lModelName, 4, length(lModelName))
      lDestModelRef = kMember.model(lDestModelName)
      if not voidp(lDestModelRef) then
        lPreilluminationData = GetPreilluminationData(lModelRef, lDestModelRef)
        lLevelPreilluminationData.add([#ModelName: lDestModelName, #texturetoapply: lModelRef.shaderList[1].texture.name, #data: lPreilluminationData])
      end if
    end if
  end repeat
  return lLevelPreilluminationData
end

on PrecalculateAndSavePreillumination kMember, kLightMapModelPrefix, kTextDataMember, kLightmapW3dMember
  lData = PrecalculatePreillimination(kMember, kLightMapModelPrefix, kLightmapW3dMember)
  kTextDataMember.text = string(lData)
end

on ApplyPreilluminationFromCast kMember, kTextDataMember, kBlendType
  lLevelPreilluminationData = value(kTextDataMember.text)
  if not voidp(lLevelPreilluminationData) then
    ApplyPreillumination(kMember, lLevelPreilluminationData, kBlendType)
  end if
end

on ForcePreilluminationTexture kLevelPreilluminationData, kTextureToApplyName
  repeat with li = 1 to kLevelPreilluminationData.count
    lPreilluminationData = kLevelPreilluminationData[li].data
    if not voidp(lPreilluminationData) then
      kLevelPreilluminationData[li].texturetoapply = kTextureToApplyName
    end if
  end repeat
end

on ForcePreilluminationTextureFromCast kTextDataMember, kTextureToApplyName
  lLevelPreilluminationData = value(kTextDataMember.text)
  repeat with li = 1 to lLevelPreilluminationData.count
    lPreilluminationData = lLevelPreilluminationData[li].data
    if not voidp(lPreilluminationData) then
      lLevelPreilluminationData[li].texturetoapply = kTextureToApplyName
    end if
  end repeat
  kTextDataMember.text = string(lLevelPreilluminationData)
end

on ApplyPreillumination kMember, kLevelPreilluminationData, kBlendType
  repeat with li = 1 to kLevelPreilluminationData.count
    lDestModelName = kLevelPreilluminationData[li].ModelName
    lDestModelRef = kMember.model(lDestModelName)
    if not voidp(lDestModelRef) then
      lPreilluminationData = kLevelPreilluminationData[li].data
      if not voidp(lPreilluminationData) then
        lTextureToApplyName = kLevelPreilluminationData[li].texturetoapply
        ApplyPreilluminationToModel(kMember, lDestModelRef, lPreilluminationData, lTextureToApplyName, kBlendType)
      end if
    end if
  end repeat
end

on ApplyPreilluminationToModel kMember, kDestModel, kPreilluminationData, kTextureToApplyName, kBlendType
  kDestModel.resource.lod.auto = 0
  kDestModel.resource.lod.level = 100
  kDestModel.addModifier(#meshDeform)
  repeat with li = 1 to kPreilluminationData.count
    if kDestModel.meshDeform.mesh[li].textureCoordinateList.count = 0 then
      put "PREILLUMINATION - textureCoordinateList VUOTA per modello: " & kDestModel.name, " mesh(" & li & ")"
    end if
    kDestModel.meshDeform.mesh[li].textureLayer.add()
    lLightMapTextureLayerIndex = kDestModel.meshDeform.mesh[li].textureLayer.count
    kDestModel.meshDeform.mesh[li].textureLayer[lLightMapTextureLayerIndex].textureCoordinateList = kPreilluminationData[li]
  end repeat
  lTextureRef = kMember.texture(kTextureToApplyName)
  if not voidp(lTextureRef) then
    repeat with li = 1 to kDestModel.shaderList.count
      lShader = kMember.shader(kDestModel.name & "_lm_" & li)
      if voidp(lShader) then
        lShader = DuplicateShader(kMember, kDestModel.shaderList[li], kDestModel.name & "_lm_" & li)
      end if
      kDestModel.shaderList[li] = lShader
      lTlIdx = 2
      lShader.textureList[lTlIdx] = lTextureRef
      lShader.blendFunctionList[lTlIdx] = kBlendType
    end repeat
  else
    put "PREILLUMINATION - TEXTURE NON TROVATA: " & kTextureToApplyName
  end if
  kDestModel.removeModifier(#meshDeform)
end
