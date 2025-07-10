on playAnimation ModelRef, AnimationDataRef, AnimationName, pIsLooping, pEmptyList
  repeat with i = 1 to ModelRef.child.count
    playAnimation(ModelRef.child[i], AnimationDataRef, AnimationName, pIsLooping, pEmptyList)
  end repeat
  if voidp(AnimationDataRef) then
    return 
  end if
  modifierPresent = 0
  keyframePlayerRef = VOID
  repeat with i = 1 to ModelRef.modifier.count
    if ModelRef.modifier[i] = #keyframePlayer then
      modifierPresent = #keyframePlayer
    end if
  end repeat
  if modifierPresent = #keyframePlayer then
    ModelRef.keyframePlayer.loop = pIsLooping
    ModelRef.keyframePlayer.rootLock = 0
    ModelRef.keyframePlayer.blendTime = 0.0
    ModelRef.keyframePlayer.play(ModelRef.name & "-Key", pIsLooping, AnimationDataRef[AnimationName].startTime, AnimationDataRef[AnimationName].endTime, 1)
  end if
end

on Set3DObjectVisibility fModel, fState
  repeat with li = 1 to fModel.child.count
    Set3DObjectVisibility(fModel.child[li], fState)
  end repeat
  fModel.visibility = fState
end

on SetTextureRenderFormat kMember, kFormat
  repeat with li = 1 to member(kMember).shader.count
    lShaderRef = member(kMember).shader[li]
    repeat with lj = 1 to lShaderRef.textureList.count
      lTexture = lShaderRef.textureList[lj]
      if not voidp(lTexture) then
        lTexture.renderFormat = kFormat
        if lTexture.name contains "st_" then
          lTexture.nearFiltering = 1
          lTexture.quality = #lowFiltered
          next repeat
        end if
        lTexture.nearFiltering = 1
        lTexture.quality = #high
      end if
    end repeat
  end repeat
end

on SetRenderFormat ModelRef
  repeat with j = 1 to ModelRef.shaderList.count
    repeat with k = 1 to ModelRef.shaderList[j].textureList.count
      if not voidp(ModelRef.shaderList[j].textureList[k]) then
        ModelRef.shaderList[j].textureList[k].renderFormat = #rgba8888
        ModelRef.shaderList[j].textureList[k].nearFiltering = 1
        ModelRef.shaderList[j].textureList[k].quality = #high
      end if
    end repeat
  end repeat
end

on SetHierarchyVisibility fModelRef, fVisibilityState
  repeat with i = 1 to fModelRef.child.count
    SetHierarchyVisibility(fModelRef.child[i], fVisibilityState)
  end repeat
  if fModelRef.ilk = #model then
    fModelRef.visibility = fVisibilityState
  end if
end

on PrintHierarchy fModelRef, fDepth
  repeat with i = 1 to fModelRef.child.count
    PrintHierarchy(fModelRef.child[i], fDepth + 1)
  end repeat
  put "Hierarchy[" & fDepth & "]: " & fModelRef.name
end

on SetEnvmapEffectHierarchy fModelRef
  repeat with i = 1 to fModelRef.child.count
    SetEnvmapEffectHierarchy(fModelRef.child[i])
  end repeat
  SetEnvmapEffect(fModelRef)
end

on SetEnvmapEffect fModelRef
  repeat with lCount = 1 to fModelRef.shaderList.count
    repeat with lCurrentFunc = 1 to fModelRef.shaderList[lCount].blendFunctionList.count
      if fModelRef.shaderList[lCount].blendFunctionList[lCurrentFunc] = #blend then
        fModelRef.shaderList[lCount].blendFunctionList[lCurrentFunc] = #add
      end if
    end repeat
  end repeat
end

on SetEnvmapEffectShader fShaderRef
  if not voidp(fShaderRef) then
    repeat with lCurrentFunc = 1 to fShaderRef.blendFunctionList.count
      if fShaderRef.blendFunctionList[lCurrentFunc] = #blend then
        fShaderRef.blendFunctionList[lCurrentFunc] = #add
      end if
    end repeat
  end if
end

on UnSetEnvmapEffectShader fShaderRef
  if not voidp(fShaderRef) then
    repeat with lCurrentFunc = 1 to fShaderRef.blendFunctionList.count
      if fShaderRef.blendFunctionList[lCurrentFunc] = #add then
        fShaderRef.blendFunctionList[lCurrentFunc] = #multiply
      end if
    end repeat
  end if
end

on RemoveEnvmapEffectShader fShaderRef
  if not voidp(fShaderRef) then
    repeat with lCurrentFunc = 1 to fShaderRef.textureModeList.count
      if fShaderRef.textureModeList[lCurrentFunc] = #reflection then
        fShaderRef.textureModeList[lCurrentFunc] = #none
      end if
      if not voidp(fShaderRef.reflectionMap) then
        fShaderRef.reflectionMap = VOID
      end if
    end repeat
  end if
end

on PrintModelList kMember
  put "*********** MODEL LIST ***********" & RETURN
  repeat with li = 1 to kMember.model.count
    lCurrentModel = kMember.model[li]
    put "MODEL: " & lCurrentModel.name
  end repeat
  put "********************************************" & RETURN
end

on PrintTextureList kMember
  put "*********** TEXTURE LIST ***********" & RETURN
  repeat with li = 1 to kMember.texture.count
    lTextureObj = kMember.texture[li]
    put "lTextureObj.name: " & lTextureObj.name
  end repeat
  put "********************************************" & RETURN
end

on PrintShaderList kMember
  put "*************** SHADER LIST ***************" & RETURN
  repeat with li = 1 to kMember.shader.count
    lShaderObj = kMember.shader[li]
    put "lShaderObj.name: " & lShaderObj.name
  end repeat
  put "********************************************" & RETURN
end

on PrintModelResourceList kMember
  put "*********** MODEL RESOURCE LIST ************" & RETURN
  repeat with li = 1 to kMember.modelResource.count
    lModelResourceRef = kMember.modelResource[li]
    put "Model resource name: " & lModelResourceRef.name
  end repeat
  put "********************************************" & RETURN
end

on PrintMotionList kMember
  put "*************** MOTION LIST ***************" & RETURN
  repeat with li = 1 to kMember.motion.count
    lMotionRef = kMember.motion[li]
    put "lMotionRef.name: " & lMotionRef.name
  end repeat
  put "********************************************" & RETURN
end

on SetNoMipmapToShader kShaderRef
  if kShaderRef = VOID then
    return 
  end if
  repeat with li = 1 to kShaderRef.textureList.count
    if kShaderRef.textureList[li] = VOID then
      next repeat
    end if
    kShaderRef.textureList[li].quality = #lowFiltered
  end repeat
end

on CreateShaderFromCast k3D, kShaderName, kCastTexture
  lShader = k3D.newShader(kShaderName, #standard)
  k3D.newTexture(kShaderName & "_texture", #fromCastMember, member(kCastTexture))
  lShader.texture = k3D.texture(kShaderName & "_texture")
  lShader.emissive = rgb(255, 255, 255)
  lShader.texture.renderFormat = #rgba8888
  return lShader
end

on CreateShader k3D, kShaderName, kTextureName
  lShader = k3D.newShader(kShaderName, #standard)
  lShader.texture = k3D.texture(kTextureName)
  lShader.emissive = rgb(255, 255, 255)
  lShader.texture.renderFormat = #rgba8888
  return lShader
end

on DeleteModelRecursive k3D, kMdl
  repeat with li = 1 to kMdl.child.count
    DeleteModelRecursive(k3D, kMdl.child[li])
  end repeat
  k3D.deleteModel(kMdl.name)
end

on DeleteModelDeep k3D, kMdl, kExcludeModelResource
  repeat with li = 1 to kMdl.shaderList.count
    lShader = kMdl.shaderList[li]
    if not voidp(lShader) then
      kMdl.shaderList[li] = k3D.shader("DefaultShader")
      repeat with lj = 1 to lShader.textureList.count
        lTexture = lShader.textureList[lj]
        lShader.textureList[lj] = VOID
        if not voidp(lTexture) then
          k3D.deleteTexture(lTexture.name)
        end if
      end repeat
      k3D.deleteShader(lShader.name)
    end if
  end repeat
  lExcludeModelResource = 0
  if not voidp(kExcludeModelResource) then
    if kExcludeModelResource then
      lExcludeModelResource = 1
    end if
  end if
  if not lExcludeModelResource then
    if not voidp(kMdl.resource) then
      k3D.deleteModelResource(kMdl.resource.name)
    end if
  end if
  k3D.deleteModel(kMdl.name)
end

on ComposeShader kShader, kImageDims, kColorRGB, kShadowImageName, kLightImageName, kTextureListIdx
  if voidp(kShader) then
    return VOID
  end if
  if voidp(kImageDims) then
    lDimsRefImage = VOID
    if not voidp(kShadowImageName) then
      lDimsRefImage = member(kShadowImageName).image
    end if
    if not voidp(kLightImageName) then
      lDimsRefImage = member(kLightImageName).image
    end if
    if voidp(lDimsRefImage) then
      kImageDims = [#width: 32, #height: 32]
    else
      kImageDims = [#width: lDimsRefImage.width, #height: lDimsRefImage.height]
    end if
  end if
  lBaseImage = image(kImageDims.width, kImageDims.height, 32)
  lBaseImage.fill(lBaseImage.rect, [#color: kColorRGB, #shapeType: #rect])
  if not voidp(kShadowImageName) then
    lLayerImage = member(kShadowImageName).image
    lBaseImage.copyPixels(lLayerImage, lBaseImage.rect, lLayerImage.rect)
  end if
  if not voidp(kLightImageName) then
    lLayerImage = member(kLightImageName).image
    lBaseImage.copyPixels(lLayerImage, lBaseImage.rect, lLayerImage.rect)
  end if
  if voidp(kTextureListIdx) then
    kShader.texture.image = lBaseImage
  else
    kShader.textureList[kTextureListIdx].image = lBaseImage
  end if
  return lBaseImage
end

on GetShaderByNamePrefix kMdl, kBaseName
  repeat with li = 1 to kMdl.shaderList.count
    lShdName = kMdl.shaderList[li].name
    if lShdName starts kBaseName then
      return kMdl.shaderList[li]
    end if
  end repeat
  repeat with li = 1 to kMdl.child.count
    lResult = GetShaderByNamePrefix(kMdl.child[li], kBaseName)
    if not voidp(lResult) then
      return lResult
    end if
  end repeat
  return VOID
end

on GetTextureMemory kMember
  lVRamUsed = 0
  repeat with lTexIdx = 1 to kMember.texture.count
    lTextureRef = kMember.texture[lTexIdx]
    case lTextureRef.renderFormat of
      #rgba8888:
        lPixelSize = 4
      #rgba8880:
        lPixelSize = 4
      #rgba5650:
        lPixelSize = 2
      #rgba5550:
        lPixelSize = 2
      #rgba5551:
        lPixelSize = 2
      #rgba4444:
        lPixelSize = 2
    end case
    case lTextureRef.quality of
      #low:
        lMipmaps = []
      #medium, #high:
        lTextureWidth = lTextureRef.width / 2
        lTextureHeight = lTextureRef.height / 2
        lMipmaps = []
        repeat while (lTextureWidth >= 1) and (lTextureHeight >= 1)
          lMipmaps.append([lTextureWidth, lTextureHeight])
          lTextureWidth = lTextureWidth / 2
          lTextureHeight = lTextureHeight / 2
        end repeat
    end case
    if lMipmaps.count > 0 then
      repeat with lMipmapSize in lMipmaps
        lVRamUsed = lVRamUsed + (lMipmapSize[1] * lMipmapSize[2] * lPixelSize)
      end repeat
    end if
    lVRamUsed = lVRamUsed + (lTextureRef.width * lTextureRef.height * lPixelSize)
  end repeat
  return lVRamUsed
end
