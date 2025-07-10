property pDescendant, pMember, pcamera, pRootNode, pQuadResource, pDefaultParams

on new me, kIdx, kSprite, kMember, kDefaultTexture, kDescendant
  pDescendant = kDescendant
  pMember = kMember
  pcamera = pMember.newCamera("overlay_camera_" & kIdx)
  pRootNode = pMember.newGroup("overlay_group_" & kIdx)
  lSpriteWidth = kSprite.rect.right - kSprite.rect.left
  lSpriteHeight = kSprite.rect.bottom - kSprite.rect.top
  pRootNode.transform = transform()
  pRootNode.transform.position = vector(-lSpriteWidth * 0.5, -lSpriteHeight * 0.5, 0.0)
  pcamera.rootNode = pRootNode
  pcamera.colorBuffer.clearAtRender = 0
  pcamera.rect = kSprite.rect
  pcamera.projection = #orthographic
  pcamera.orthoHeight = lSpriteHeight
  pcamera.transform = transform()
  kSprite.addCamera(pcamera)
  pQuadResource = pMember.modelResource("overlay_res")
  if voidp(pQuadResource) then
    lDefaultShader = pMember.shader[1]
    pQuadResource = pMember.newMesh("overlay_res", 2, 4, 1, 0, 4)
    pQuadResource.vertexList = [vector(0.0, 0.0, 0.0), vector(1.0, 0.0, 0.0), vector(1.0, -1.0, 0.0), vector(0.0, -1.0, 0.0)]
    pQuadResource.normalList = [vector(0.0, 0.0, 1.0)]
    pQuadResource.textureCoordinateList = [[0.0, 0.0], [1.0, 0.0], [1.0, -1.0], [0.0, -1.0]]
    pQuadResource.face[1].vertices = [1, 4, 3]
    pQuadResource.face[1].normals = [1, 1, 1]
    pQuadResource.face[1].textureCoordinates = [1, 4, 3]
    pQuadResource.face[1].shader = lDefaultShader
    pQuadResource.face[2].vertices = [3, 2, 1]
    pQuadResource.face[2].normals = [1, 1, 1]
    pQuadResource.face[2].textureCoordinates = [3, 2, 1]
    pQuadResource.face[2].shader = lDefaultShader
    pQuadResource.build()
  end if
  pDefaultParams = [#Pivot: point(0, 0), #position: point(0, 0), #rotation: 0.0, #texture: kDefaultTexture, #color: rgb(255, 255, 255), #scale: [1.0, 1.0], #blend: 100.0]
  return me
end

on _OverlayReference me, kNameOrRef
  case kNameOrRef.ilk of
    #string:
      lGroup = pMember.group(kNameOrRef)
      return lGroup
    #group:
      return kNameOrRef
    otherwise:
      assert(0, "OverlaysLayerBase._OverlayReference: Invalid name of reference")
      return VOID
  end case
end

on _DepthToZ me, kValue
  assert(0, "OverlaysLayerBase._DepthToZ pure virtual")
end

on _ApplyParamToOverlay me, kOverlayRef, kParamSymbol, kParamValue
  case kParamSymbol of
    #Pivot:
      lMdl = kOverlayRef.child[1]
      lScale = lMdl.userData.getaProp(#OverlayParams).getaProp(#scale).duplicate()
      lMinScale = 0.001
      lMaxScale = 1000000.0
      lScale[1] = Clamp(lScale[1], lMinScale, lMaxScale)
      lScale[2] = Clamp(lScale[2], lMinScale, lMaxScale)
      lMdl.transform.position = vector(-kParamValue.locH / lScale[1], kParamValue.locV / lScale[2], 0.0)
    #position:
      lOverlayTr = kOverlayRef.transform
      lZ = lOverlayTr.position.z
      lOverlayTr.position = vector(kParamValue.locH, pcamera.orthoHeight - kParamValue.locV, lZ)
    #rotation:
      kOverlayRef.transform.rotation.z = kParamValue
    #texture:
      lMdl = kOverlayRef.child[1]
      lMdl.shader.texture = kParamValue
      lTextureWidth = kParamValue.width
      lTextureHeight = kParamValue.height
      lMdl.transform.scale = vector(lTextureWidth, lTextureHeight, 1.0)
    #color:
      kOverlayRef.child[1].shader.emissive = kParamValue
    #scale:
      lMinScale = 0.001
      lMaxScale = 1000000.0
      kOverlayRef.transform.scale = vector(Clamp(kParamValue[1], lMinScale, lMaxScale), Clamp(kParamValue[2], lMinScale, lMaxScale), 1.0)
    #blend:
      kOverlayRef.child[1].shader.blend = kParamValue
  end case
end

on UpdateDefaultParams me, kParams
  repeat with lIdx = 1 to kParams.count
    lPropSymbol = kParams.getPropAt(lIdx)
    lPropValue = kParams[lIdx]
    if voidp(lPropValue) then
      next repeat
    end if
    pDefaultParams.setaProp(lPropSymbol, lPropValue)
  end repeat
end

on addOverlay me, kName, kDepth, kParams
  lGroup = pMember.newGroup(kName)
  lGroup.parent = pRootNode
  lGroup.transform = transform()
  lMdl = pMember.newModel(kName & "_mdl", pQuadResource)
  lMdl.parent = lGroup
  lMdl.transform = transform()
  lShd = pMember.newShader(kName & "_shd", #standard)
  lShd.useDiffuseWithTexture = 0
  lShd.diffuse = rgb(0, 0, 0)
  lShd.specular = rgb(0, 0, 0)
  lMdl.shader = lShd
  lOverlayParams = pDefaultParams.duplicate()
  repeat with lIdx = 1 to kParams.count
    lPropSymbol = kParams.getPropAt(lIdx)
    lPropValue = kParams[lIdx]
    if voidp(lPropValue) then
      next repeat
    end if
    lOverlayParams.setaProp(lPropSymbol, lPropValue)
  end repeat
  lMdl.userData.addProp(#OverlayParams, lOverlayParams)
  lMdl.userData.addProp(#OverlayDepth, VOID)
  lTextureRef = lOverlayParams[#texture]
  lTextureWidth = lTextureRef.width
  lTextureHeight = lTextureRef.height
  lMdl.transform.scale = vector(lTextureWidth, lTextureHeight, 1.0)
  repeat with lIdx = 1 to lOverlayParams.count
    lPropSymbol = lOverlayParams.getPropAt(lIdx)
    lPropValue = lOverlayParams[lIdx]
    pDescendant._ApplyParamToOverlay(lGroup, lPropSymbol, lPropValue)
  end repeat
  me.SetOverlayDepth(lGroup, kDepth)
end

on removeOverlay me, kNameOrRef
  lRef = me._OverlayReference(kNameOrRef)
  if not voidp(lRef) then
    lShdName = lRef.child[1].shader.name
    pMember.deleteModel(lRef.child[1].name)
    pMember.deleteGroup(lRef.name)
    pMember.deleteShader(lShdName)
  end if
end

on SetOverlayVisible me, kNameOrRef, kFlag
  lRef = me._OverlayReference(kNameOrRef)
  if not voidp(lRef) then
    if kFlag then
      lRef.parent = pRootNode
    else
      lRef.parent = VOID
    end if
  end if
end

on GetOverlayReference me, kName
  return me._OverlayReference(kName)
end

on GetOverlayParams me, kNameOrRef
  lRef = me._OverlayReference(kNameOrRef)
  if not voidp(lRef) then
    lMdl = lRef.child[1]
    return lMdl.userData.getaProp(#OverlayParams)
  else
    return VOID
  end if
end

on UpdateOverlayParams me, kNameOrRef, kNewParams
  lOverlayRef = me._OverlayReference(kNameOrRef)
  if voidp(lOverlayRef) then
    return 
  end if
  lOverlayParams = lOverlayRef.child[1].userData.getaProp(#OverlayParams)
  repeat with lIdx = 1 to kNewParams.count
    lPropSymbol = kNewParams.getPropAt(lIdx)
    lPropValue = kNewParams[lIdx]
    if voidp(lPropValue) then
      next repeat
    end if
    lOverlayParams.setaProp(lPropSymbol, lPropValue)
    pDescendant._ApplyParamToOverlay(lOverlayRef, lPropSymbol, lPropValue)
  end repeat
end

on GetOverlayDepth me, kNameOrRef
  lRef = me._OverlayReference(kNameOrRef)
  if not voidp(lRef) then
    lMdl = lRef.child[1]
    return lMdl.userData.getaProp(#OverlayDepth)
  end if
end

on SetOverlayDepth me, kNameOrRef, kDepth
  lRef = me._OverlayReference(kNameOrRef)
  if not voidp(lRef) then
    lMdl = lRef.child[1]
    lMdl.userData.setaProp(#OverlayDepth, kDepth)
    lRef.transform.position.z = pDescendant._DepthToZ(kDepth)
  end if
end
