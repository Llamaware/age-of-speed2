property pResourceToolSprite, ResourceManagerFlash, pNewResourceSwitch, pResource3dSphere, pResource3dSphereLow, pShaderSelected, pResource3dPlane, pResource3dBox, pShader, pShaderSaved, pShaderBox1, pShaderBox2, pShaderBonusActiv, pSelectedResource, pResourceVisualized, pResourcesFileName, pShaderPathPoint, pShaderPathPointSelected, pResource3dPathPoint, pResourceEdge, pResourceVertex, pGetPathPoint, pPrecedentToken, pPathPoint3DId, pLongitudinalRotatory, pRotatoryIndex, pResourceCursor, pCursorSnap, pRotatingCursorTimer, pGoingForward, pGoingBackward, pGoingRight, pGoingLeft, pRotatingDx, pRotatingSx, pMoveStepTopCam, pZoomStepTopCam, pSnapCursorTimer, pUpVector, pCamFov, pCamNearPlane, pCamFarPlane, pPos, pOldPos, pTarget, pFreeLookStep, pFreeMoveStep, pBasePos, pBaseDir, pOldDir, pText, p_dt, pLastTime, pkeyb_zoom, pkeyb_dx, pkeyb_dy, pCongifFileLoaded, pkeyb_vertStrafe, pkeyb_strafe, pToolConfigData, pFileConfiguration, pFaceVertexMode, pFaceEdgeMode, pFacePositionId, pFaceLabel, pSnap, pLabel, pPolyline, pEdgeShader, pPositionPlayerShadow
global gGame, gResource3dList, gResourceToolVars, gResourceFileMode

on InitializeResourceTool me, kResourceToolSprite
  pResourceToolSprite = kResourceToolSprite
  InitializeResourceToolVars()
  InitResourceManager()
  pCongifFileLoaded = #NotConfigured
  gResourceToolVars.addProp(#CameraType, #Game)
  gResourceToolVars.addProp(#CameraSubType, #top)
  gResourceToolVars.addProp(#PositionType, #player)
  gResourceToolVars.addProp(#ZoomZCam, 800.0)
  gResourceToolVars.addProp(#FreeMouseCapture, 0)
  gResourceToolVars.addProp(#ZFix, #none)
  gResourceToolVars.addProp(#ZOffset, #none)
  pGetPathPoint = -1
  pPrecedentToken = 0
  pPathPoint3DId = 0
  pRotatoryIndex = -1
  pNewResourceSwitch = 0
  pCursorSnap = -1
  pRotatingCursorTimer = gGame.GetTimeManager().GetTime()
  pMoveStepTopCam = 10.0
  pZoomStepTopCam = 5.0
  pSnapCursorTimer = 400.0
  pZoomStep = 20.0
  pRotationStep = 0.10000000000000001
  pFreeLookStep = 0.10000000000000001
  pFreeMoveStep = 2.0
  pBasePos = vector(0.0, 500.0, 100.0)
  pBaseDir = vector(0.0, -1.0, 0.0)
  pUpVector = vector(0.0, 0.0, 1.0)
  pOldDir = pBaseDir
  pOldPos = pBasePos
  pPos = pBasePos
  pToolConfigData = ["bonustype": ["bonus_money", "bonus_time", "bonus_turbo", "checkpoint_dyn"], "objectmodel": ["cassa", "cartone", "posta", "idrante"], "camsetting": [#CamType: 0, #CamSubType: 0, #FreeCam: [#CamFreeLookStep: 0.10000000000000001, #CamFreeMoveStep: 100.0, #CamFov: 60.0, #CamNearPlane: 10.0, #CamFarPlane: 10000.0, #CamFreeStartPos: vector(0.0, 2000.0, 2000.0), #CamFreeStartDir: vector(0.0, -1.0, -0.5)], #TopCam: [#MoveStepTopCam: 10.0, #ZoomStepTopCam: 5.0]], "newresource": [#label: "none", #AutoIncr: 0, #PositionType: 0, #CursorModel: 0, #Snap: 0, #SnapValue: -1, #ZFix: 0, #ZfixValue: 0.0, #ZOffset: 0, #ZoffsetValue: 0.0], "ckl": [#length: 500.0, #WidthIncr: 500.0, #ActionFront: "none", #ActionBack: "none"], "ckp": [#radius: 200.0, #ActionIn: "#none", #ActionOut: "#none", #Active: 1], "bon": [#BonusModel: "bonus_money", #ActDistance: 200.0, #Respawn: -1, #zPos: "none", #ZOffset: 50.0, #move: 1, #Orient: 0, #orientation: "#normal", #Remove: 1, #ShadowZ: 10.0], "obj": [#model: "cartone", #Snap: 15.0, #Remove: 1], "pat": [#loop: 0, #Snap: 0.5, #CheckSnap: 1], "cursor": [#SnapCursorTimer: 400.0]]
  pFaceVertexMode = 0
  pFaceEdgeMode = 0
  pFacePositionId = 0
  pPositionPlayerShadow = #player
  return me
end

on InitializeResourceToolVars me
  gResourceToolVars = [:]
  gResourceToolVars.addProp(#Switch, 0)
  gResourceToolVars.addProp(#ActiveTool, 0)
  gResourceToolVars.addProp(#TopLeftFocus, vector(0.0, 0.0, 0.0))
  gResourceToolVars.addProp(#DownRightFocus, vector(0.0, 0.0, 0.0))
  gResourceToolVars.addProp(#FocusEnabled, 1)
  gResourceToolVars.addProp(#KeysConfig, [:])
  gResourceToolVars.KeysConfig.addProp(#NewResource, "u")
  gResourceToolVars.KeysConfig.addProp(#ResoureToolSwitch, "r")
  gResourceToolVars.KeysConfig.addProp(#LessZoomZ, "a")
  gResourceToolVars.KeysConfig.addProp(#MoreZoomZ, "z")
  gResourceToolVars.KeysConfig.addProp(#RotatingSx, "n")
  gResourceToolVars.KeysConfig.addProp(#RotatingDx, "m")
  gResourceToolVars.KeysConfig.addProp(#FreeForward, "w")
  gResourceToolVars.KeysConfig.addProp(#FreeBackWard, "s")
  gResourceToolVars.KeysConfig.addProp(#FreeRight, "d")
  gResourceToolVars.KeysConfig.addProp(#FreeLeft, "a")
  gResourceToolVars.KeysConfig.addProp(#FreeZoom, "z")
  gResourceToolVars.KeysConfig.addProp(#FreeUnZoom, "x")
  gResourceToolVars.KeysConfig.addProp(#CursorRotatingSx, ".")
  gResourceToolVars.KeysConfig.addProp(#CursorRotatingDx, ",")
end

on ConfigResourceTool me
  if loadText(pFileConfiguration) then
    me.parseConfigFile()
  else
    put "error loading config file"
  end if
end

on SetResourcesFileName me, fName
  pResourcesFileName = fName
end

on SetConfigFileName me, fName
  pFileConfiguration = fName
end

on IsFocusEnabled me
  return gResourceToolVars.FocusEnabled
end

on SetFocusEnabled me, kValue
  gResourceToolVars.FocusEnabled = kValue
end

on SetFreeMouseCapture me, kValue
  gResourceToolVars.FreeMouseCapture = kValue
end

on GetFreeMouseCapture me
  return gResourceToolVars.FreeMouseCapture
end

on GetResourceToolVars me
  return gResourceToolVars
end

on GetResourceToolSprite me
  return pResourceToolSprite
end

on exitFrame me
  lResourceToolCheat = gGame.GetInputManager().IsKeyPressed(gResourceToolVars.KeysConfig.ResoureToolSwitch)
  if lResourceToolCheat and not gResourceToolVars.Switch then
    ResourceTool()
  end if
  gResourceToolVars.Switch = lResourceToolCheat
  if pGetPathPoint <> -1 then
    GetPathPoint(pGetPathPoint)
  end if
  lNewResourceCheat = keyPressed(gResourceToolVars.KeysConfig.NewResource) and gResourceToolVars.FocusEnabled
  if lNewResourceCheat and not pNewResourceSwitch then
    if not voidp(ResourceManagerFlash.NewByKeyword) then
      ResourceManagerFlash.NewByKeyword()
    end if
  end if
  pNewResourceSwitch = lNewResourceCheat
  if pLastTime = VOID then
    pLastTime = the milliSeconds
  end if
  p_dt = (the milliSeconds - pLastTime) / 100.0
  pLastTime = the milliSeconds
end

on ResourceTool
  if not gResourceToolVars.ActiveTool and (pCongifFileLoaded = #Configured) then
    ResourceManagerFlash = getVariable(sprite(pResourceToolSprite), "_level0", 0)
    sprite(pResourceToolSprite).visible = 1
    lTopLeftX = sprite(pResourceToolSprite).locH - (sprite(pResourceToolSprite).width * 0.5)
    lTopLeftY = sprite(pResourceToolSprite).locV - (sprite(pResourceToolSprite).height * 0.5)
    lDownRightX = sprite(pResourceToolSprite).locH + (sprite(pResourceToolSprite).width * 0.5)
    lDownRightY = sprite(pResourceToolSprite).locV + (sprite(pResourceToolSprite).height * 0.5)
    gResourceToolVars.TopLeftFocus = vector(lTopLeftX, lTopLeftY, 0.0)
    gResourceToolVars.DownRightFocus = vector(lDownRightX, lDownRightY, 0.0)
    if gResourceToolVars.PositionType = #Mouse then
      pResourceCursor.visibility = #both
    end if
    gResourceToolVars.ActiveTool = 1
  else
    sprite(pResourceToolSprite).visible = 0
    gResourceToolVars.TopLeftFocus = vector(0.0, 0.0, 0.0)
    gResourceToolVars.DownRightFocus = vector(0.0, 0.0, 0.0)
    flash_StopPathPointList()
    if pResourceCursor <> VOID then
      pResourceCursor.visibility = #none
    end if
    gResourceToolVars.ActiveTool = 0
  end if
end

on InitResourceManager me
  put "Initializing ResourceManager"
  pPolyline = script("PolylineResourceTool").new(gGame.Get3D())
  pResource3dSphere = gGame.Get3D().newModelResource("sphere_3dresource", #sphere)
  gGame.Get3D().modelResource("sphere_3dresource").radius = 1.0
  pResource3dSphereLow = gGame.Get3D().newModelResource("sphere_3dresource_low", #sphere)
  gGame.Get3D().modelResource("sphere_3dresource_low").resolution = 6
  gGame.Get3D().modelResource("sphere_3dresource_low").radius = 1.0
  pResource3dPlane = gGame.Get3D().newModelResource("plane_3dresource", #plane)
  pResource3dBox = gGame.Get3D().newModelResource("resource_3dred_box", #box)
  pResource3dBox.length = 50.0
  pResource3dBox.width = 50.0
  pResource3dBox.height = 50.0
  pResource3dPathPoint = gGame.Get3D().newModelResource("resource_pathpoint", #cylinder)
  pResource3dPathPoint.topRadius = 0.0
  pResource3dPathPoint.bottomRadius = 25.0
  pResource3dPathPoint.resolution = 4
  pResource3dPathPoint.bottomCap = 1
  pResource3dPathPoint.topCap = 1
  pShader = gGame.Get3D().newShader("shader_resource", #standard)
  pShader.diffuse = rgb(250, 250, 250)
  pShader.texture = VOID
  pShader.blend = 30
  pShaderPathPoint = gGame.Get3D().newShader("shader_pathpoint", #standard)
  pShaderPathPoint.diffuse = rgb(200, 0, 0)
  pShaderPathPoint.texture = VOID
  pShaderPathPoint.blend = 50
  pShaderPathPointSelected = gGame.Get3D().newShader("shader_pathpoint_selected", #standard)
  pShaderPathPointSelected.diffuse = rgb(250, 250, 0)
  pShaderPathPointSelected.texture = VOID
  pShaderPathPointSelected.blend = 90
  pShaderBonusActiv = gGame.Get3D().newShader("shader_bonus_active", #standard)
  pShaderBonusActiv.diffuse = rgb(50, 150, 50)
  pShaderBonusActiv.texture = VOID
  pShaderBonusActiv.blend = 40
  pShaderSelected = gGame.Get3D().newShader("shader_selected", #standard)
  pShaderSelected.diffuse = rgb(255, 0, 0)
  pShaderSelected.texture = VOID
  pShaderSelected.blend = 90
  pShaderBox1 = gGame.Get3D().newShader("box1_3dshader", #standard)
  pShaderBox1.diffuse = rgb(225, 0, 0)
  pShaderBox1.texture = VOID
  pShaderBox1.blend = 45
  pShaderBox2 = gGame.Get3D().newShader("box2_3dshader", #standard)
  pShaderBox2.diffuse = rgb(0, 225, 0)
  pShaderBox2.texture = VOID
  pShaderBox2.blend = 45
  pSelectedResource = -1
  gResource3dList = propList()
  pResourceVisualized = []
  lResourceCursorModel = gGame.Get3D().newModelResource("resource_cursor_model", #cylinder)
  lResourceCursorModel.topRadius = 0.0
  lResourceCursorModel.bottomRadius = 40.0
  lResourceCursorModel.height = 100.0
  lResourceCursorModel.resolution = 4
  lResourceCursorModel.bottomCap = 1
  lResourceCursorModel.topCap = 1
  pResourceCursor = gGame.Get3D().newModel("resource_cursor_cam", lResourceCursorModel)
  pResourceCursor.shaderList = pShaderPathPoint
  pResourceCursor.transform.position = vector(0.0, 0.0, 0.0)
  pResourceCursor.visibility = #both
  pResourceCursor.pointAtOrientation = [vector(1.0, 0.0, 0.0), vector(0.0, 0.0, 1.0)]
  pResourceCursor.pointAt(vector(1.0, 0.0, 0.0), vector(0.0, 0.0, 1.0))
  lResourceVertexModel = gGame.Get3D().newModelResource("resource_vertex", #box)
  lResourceVertexModel.length = 10.0
  lResourceVertexModel.width = 10.0
  lResourceVertexModel.height = 10.0
  pResourceVertex = gGame.Get3D().newModel("resource_vertex", lResourceVertexModel)
  lResourceEdgeModel = gGame.Get3D().newModelResource("resource_edge", #cylinder)
  lResourceEdgeModel.topRadius = 20.0
  lResourceEdgeModel.bottomRadius = 20.0
  lResourceEdgeModel.resolution = 4
  lResourceEdgeModel.bottomCap = 1
  lResourceEdgeModel.topCap = 1
  pResourceEdge = gGame.Get3D().newModel("resource_edge", lResourceEdgeModel)
end

on CreateCheckLineData fLength, fWidthIncr
  lPlaneLength = integer(fLength)
  lWidthIncr = integer(fWidthIncr)
  lPosition = GetPositionVector()
  lCurrentToken = GetCurrentToken()
  if lCurrentToken <> 0 then
    lTrackToken = gGame.GetTokenManager().GetTokenRef(lCurrentToken)
    lTokenStruct = gGame.GetTokenManager().GetTokensTypesStruct()
    lToken = lTokenStruct[lTrackToken.token]
    lTokenRotation = lTrackToken.model.transform.rotation
    lVehicleDirection = GetDirection()
    lVehicleDirection.z = 0.0
    lPlaneWidth = lToken.width + lWidthIncr
    lGetToken = gGame.GetTokenManager().getToken(lCurrentToken, lPosition.x, lPosition.y, lPosition, lVehicleDirection, 0.0, 0.0)
    lTokenId = lGetToken[1]
    lTangent = lGetToken[3]
    lAngleBetween = lVehicleDirection.angleBetween(lTangent)
    lRotation = 0.0
    if lAngleBetween > 90.0 then
      lRotation = 180.0
    end if
    lTokenRotation.y = lTokenRotation.y + lRotation
    lLongitudinal = lGetToken[4]
    lPositionCorrect = gGame.GetTokenManager().TokenToWorld3DByRef(lTrackToken, lLongitudinal, 0.0)
    lAngleRotationRad = PI / 180.0 * lTokenRotation.z
    lAngleDirectionRad = PI / 180.0 * lTokenRotation.y
    lTangent.z = 0.0
    lTangentOrtho = vector(0.0, 0.0, 0.0)
    lTangentOrtho.x = lTangent.y
    lTangentOrtho.y = -lTangent.x
    lDistance = cos(lAngleDirectionRad) * lPlaneWidth / 2
    lIncr = lPlaneWidth * 0.5
    lP1 = lPositionCorrect - (lIncr * lTangentOrtho)
    lP2 = lPositionCorrect + (lIncr * lTangentOrtho)
    lReturnData = [#p1: lP1, #p2: lP2, #TokenId: lTokenId, #PlaneLength: lPlaneLength, #PlaneWidth: lPlaneWidth]
  else
    lDirection = GetDirection()
    lTangentVector = vector(lDirection.y, -lDirection.x, 0.0)
    lTangentVector.normalize()
    lP1 = lPosition - (lWidthIncr * lTangentVector)
    lP2 = lPosition + (lWidthIncr * lTangentVector)
    lPlaneWidth = lWidthIncr * 2.0
    lReturnData = [#p1: lP1, #p2: lP2, #TokenId: lCurrentToken, #PlaneLength: lPlaneLength, #PlaneWidth: lPlaneWidth]
  end if
  return lReturnData
end

on CreateCheckLine3D fNamePlane, fLengthPlane, fWidthPlane, fP1, fP2
  lPlanePosition = (fP1 + fP2) / 2
  lPlaneZRotation = (fP1 - fP2).angleBetween(vector(1.0, 0.0, 0.0))
  l_Signp = (fP1 - fP2).crossProduct(vector(1.0, 0.0, 0.0))
  if l_Signp.z >= 0.0 then
    lPlaneZRotation = -lPlaneZRotation
  end if
  lObject3dBox1 = gGame.Get3D().newModel(fNamePlane & "_Box1", pResource3dBox)
  lObject3dBox1.shaderList = pShaderBox1
  lObject3dBox1.transform.position = fP1
  lObject3dBox1.visibility = #both
  lObject3dBox2 = gGame.Get3D().newModel(fNamePlane & "_Box2", pResource3dBox)
  lObject3dBox2.shaderList = pShaderBox2
  lObject3dBox2.transform.position = fP2
  lObject3dBox2.visibility = #both
  lObject3d = gGame.Get3D().newModel(fNamePlane, pResource3dPlane)
  lObject3d.shaderList = pShader
  lObject3d.transform.position = lPlanePosition
  lObject3d.transform.scale = vector(fWidthPlane, fLengthPlane, 1.0)
  lObject3d.transform.rotation = vector(90.0, 0.0, lPlaneZRotation)
  lObject3d.addChild(lObject3dBox1)
  lObject3d.addChild(lObject3dBox2)
  lObject3d.visibility = #both
  return lObject3d
end

on RemoveCheckLine3d fLabelName
  lName = fLabelName
  lNameFirstChild = gGame.Get3D().model(fLabelName).child[1].name
  lNameSecondChild = gGame.Get3D().model(fLabelName).child[2].name
  gGame.Get3D().deleteModel(lNameFirstChild)
  gGame.Get3D().deleteModel(lNameSecondChild)
  gGame.Get3D().deleteModel(lName)
end

on flash_CreateNewCheckLine me, fLabelLowCase, fLabelName, fLength, fWidthIncr, fActFront, fActBack
  lReturnData = CreateCheckLineData(fLength, fWidthIncr)
  if lReturnData <> -1 then
    lCheckLineRef = CreateCheckLine3D(fLabelLowCase, lReturnData.PlaneLength, lReturnData.PlaneWidth, lReturnData.p1, lReturnData.p2)
    lPropList = propList()
    lPropList.addProp("modelRef", lCheckLineRef)
    lPropList.addProp("type", "ckl")
    gResource3dList.addProp(fLabelLowCase, lPropList)
    ResourceManagerFlash.SetupNewCheckLine(fLabelLowCase, fLabelName, lReturnData.p1.x, lReturnData.p1.y, lReturnData.p2.x, lReturnData.p2.y, fActFront, fActBack, lReturnData.TokenId, fWidthIncr)
  end if
end

on flash_ModifyResourceCKL me, fLabelLowCase, fLabelName, fLength, fWidthIncr, fActFront, fActBack
  l3dModelRef = gResource3dList[fLabelLowCase]["modelRef"]
  lReturnData = CreateCheckLineData(fLength, fWidthIncr)
  if lReturnData <> -1 then
    RemoveCheckLine3d(fLabelLowCase)
    lCheckLineRef = CreateCheckLine3D(fLabelLowCase, lReturnData.PlaneLength, lReturnData.PlaneWidth, lReturnData.p1, lReturnData.p2)
    gResource3dList[fLabelLowCase]["modelRef"] = lCheckLineRef
    pSelectedResource = -1
    flash_SelectResource(VOID, fLabelLowCase)
    ResourceManagerFlash.SetupModifiedCheckLine(fLabelName, lReturnData.p1.x, lReturnData.p1.y, lReturnData.p2.x, lReturnData.p2.y, fActFront, fActBack, lReturnData.TokenId)
  end if
end

on UpdateCKL fLabelName, fNewLabelName, fWidthIncrement
  lNamePlane = fNewLabelName
  lOldModel = gGame.Get3D().model(fLabelName)
  lObject3d = gGame.Get3D().newModel(fNewLabelName, pResource3dPlane)
  lObject3d.shaderList = pShader
  lObject3d.transform = lOldModel.transform.duplicate()
  lObject3dBox1 = gGame.Get3D().newModel(fNewLabelName & "_Box1", pResource3dBox)
  lObject3dBox1.shaderList = pShaderBox1
  lObject3dBox2 = gGame.Get3D().newModel(fNewLabelName & "_Box2", pResource3dBox)
  lObject3dBox2.shaderList = pShaderBox2
  lObject3d.addChild(lObject3dBox1)
  lObject3d.addChild(lObject3dBox2)
  lObject3dBox1.transform = lOldModel.child[1].transform.duplicate()
  lObject3dBox2.transform = lOldModel.child[2].transform.duplicate()
  return lObject3d
end

on UpdateCKLWidthIncr fLabelName, fWidthIncrement
  lModelRef = gResource3dList[fLabelName]["modelRef"]
  lP1 = lModelRef.child[1].worldPosition
  lP2 = lModelRef.child[2].worldPosition
  lCenterPosition = (lP1 + lP2) / 2
  lResult = gGame.GetTokenManager().getToken(0, lCenterPosition.x, lCenterPosition.y, lCenterPosition, vector(0.0, 0.0, 0.0), 0.0, 0.0)
  lToken = lResult[1]
  lVersor = lP1 - lP2
  lVersor.normalize()
  lTrackToken = gGame.GetTokenManager().GetTokenRef(lToken)
  lTokenStruct = gGame.GetTokenManager().GetTokensTypesStruct()
  lToken = lTokenStruct[lTrackToken]
  lTokenWidth = lToken.width
  lWidthPlane = lTokenWidth + fWidthIncrement
  lModelRef.transform.scale.x = lWidthPlane
  lPointA = lCenterPosition + (lWidthPlane * 0.5 * lVersor)
  lPointB = lCenterPosition - (lWidthPlane * 0.5 * lVersor)
  lModelRef.child[1].worldPosition = lPointA
  lModelRef.child[2].worldPosition = lPointB
  lReturn = [#pointA: lPointA, #pointB: lPointB]
  return lReturn
end

on flash_UpdateResourceCKL me, fLabelName, fNewLabelName, fLabelFlash, fWidthIncrement
  fWidthIncrement = integer(fWidthIncrement)
  if fLabelName <> fNewLabelName then
    lPropList = gResource3dList[fLabelName]
    lNewCheckLineRef = UpdateCKL(fLabelName, fNewLabelName)
    lNewCheckLineRef.shader = pShader
    flash_RemoveResource(VOID, fLabelName)
    lPropList["modelRef"] = lNewCheckLineRef
    gResource3dList.addProp(fNewLabelName, lPropList)
    pSelectedResource = -1
    flash_SelectResource(VOID, fNewLabelName)
  end if
  if fWidthIncrement <> -1 then
    lReturn = UpdateCKLWidthIncr(fNewLabelName, fWidthIncrement)
    ResourceManagerFlash.SetupNewWidthIncrement(fLabelFlash, lReturn.pointA.x, lReturn.pointA.y, lReturn.pointB.x, lReturn.pointB.y)
  end if
end

on CreatePositionData
  lPosition = GetPositionVector()
  lCurrentToken = GetCurrentToken()
  if lCurrentToken <> 0 then
    lGetToken = gGame.GetTokenManager().getToken(lCurrentToken, lPosition.x, lPosition.y, lPosition, vector(1.0, 0.0, 0.0), 0.0, 0.0)
    lTokenId = lGetToken[1]
  else
    lTokenId = 0
  end if
  lReturnData = [#position: lPosition, #TokenId: lTokenId]
  return lReturnData
end

on CreatePosition3D fNameResource, fPosition
  lObject3d = gGame.Get3D().newModel(fNameResource, pResource3dSphereLow)
  lObject3d.shaderList = pShader
  lObject3d.transform.position = fPosition
  lObject3d.visibility = #front
  lObject3d.transform.scale = vector(20.0, 20.0, 20.0)
  return lObject3d
end

on RemovePosition3d fLabelName
  lName = fLabelName
  gGame.Get3D().deleteModel(lName)
end

on flash_CreateNewPosition me, fLabelLowCase, fLabelName
  lReturnData = CreatePositionData()
  lPositionRef = CreatePosition3D(fLabelLowCase, lReturnData.position)
  lPropList = propList()
  lPropList.addProp("modelRef", lPositionRef)
  lPropList.addProp("type", "posit")
  gResource3dList.addProp(fLabelLowCase, lPropList)
  ResourceManagerFlash.SetupNewPosition(fLabelLowCase, fLabelName, lReturnData.position.x, lReturnData.position.y, lReturnData.position.z, lReturnData.TokenId, "#NoUserData")
end

on flash_ModifyResourcePOS me, fLabelLowCase, fLabelName, fUserData
  l3dModelRef = gResource3dList[fLabelLowCase]["modelRef"]
  RemovePosition3d(fLabelLowCase)
  lReturnData = CreatePositionData()
  lPositionRef = CreatePosition3D(fLabelLowCase, lReturnData.position)
  gResource3dList[fLabelLowCase]["modelRef"] = lPositionRef
  pSelectedResource = -1
  flash_SelectResource(VOID, fLabelLowCase)
  ResourceManagerFlash.SetupModifiedPosition(fLabelName, lReturnData.position.x, lReturnData.position.y, lReturnData.position.z, lReturnData.TokenId, fUserData)
end

on flash_UpdateResourcePOS me, fLabelName, fNewLabelName
  if fLabelName <> fNewLabelName then
    lPropList = gResource3dList[fLabelName]
    lX = lPropList["modelRef"].transform.position.x
    lY = lPropList["modelRef"].transform.position.y
    lZ = lPropList["modelRef"].transform.position.z
    flash_RemoveResource(VOID, fLabelName)
    lNewPositionRef = CreatePosition3D(fNewLabelName, vector(lX, lY, lZ))
    lPropList["modelRef"] = lNewPositionRef
    gResource3dList.addProp(fNewLabelName, lPropList)
    pSelectedResource = -1
    flash_SelectResource(VOID, fNewLabelName)
  end if
end

on CreateCheckPointData fRadius
  lPosition = GetPositionVector()
  lCurrentToken = GetCurrentToken()
  lGetToken = gGame.GetTokenManager().getToken(lCurrentToken, lPosition.x, lPosition.y, lPosition, vector(1.0, 0.0, 0.0), 0.0, 0.0)
  if lCurrentToken <> 0 then
    lTokenId = lGetToken[1]
  else
    lTokenId = 0
  end if
  lReturnData = [#position: lPosition, #TokenId: lTokenId, #radius: fRadius]
  return lReturnData
end

on CreateCheckPoint3D fNameCKP, fPosition, fRadius
  lObject3d = gGame.Get3D().newModel(fNameCKP, pResource3dSphere)
  lObject3d.shaderList = pShader
  lObject3d.transform.position = fPosition
  lObject3d.transform.scale = vector(fRadius, fRadius, fRadius)
  lObject3d.visibility = #both
  return lObject3d
end

on RemoveCheckPoint3d fLabelName
  lName = fLabelName
  gGame.Get3D().deleteModel(lName)
end

on flash_CreateNewCheckPoint me, fLabelLowCase, fLabelName, fRadius, fActive, fActionIn, fActionOut
  fRadius = float(fRadius)
  lReturnData = CreateCheckPointData(fRadius)
  lCheckPointRef = CreateCheckPoint3D(fLabelLowCase, lReturnData.position, lReturnData.radius)
  lPropList = propList()
  lPropList.addProp("modelRef", lCheckPointRef)
  lPropList.addProp("type", "ckp")
  gResource3dList.addProp(fLabelLowCase, lPropList)
  ResourceManagerFlash.SetupNewCheckPoint(fLabelLowCase, fLabelName, lReturnData.position.x, lReturnData.position.y, lReturnData.position.z, lReturnData.radius, fActive, fActionIn, fActionOut, lReturnData.TokenId)
end

on flash_ModifyResourceCKP me, fLabelLowCase, fLabelName, fRadius, fActive, fActionIn, fActionOut
  fRadius = float(fRadius)
  l3dModelRef = gResource3dList[fLabelLowCase]["modelRef"]
  RemoveCheckPoint3d(fLabelLowCase)
  lReturnData = CreateCheckPointData(fRadius)
  lCheckPointRef = CreateCheckPoint3D(fLabelLowCase, lReturnData.position, lReturnData.radius)
  gResource3dList[fLabelLowCase]["modelRef"] = lCheckPointRef
  pSelectedResource = -1
  flash_SelectResource(VOID, fLabelLowCase)
  ResourceManagerFlash.SetupModifiedCheckPoint(fLabelName, lReturnData.position.x, lReturnData.position.y, lReturnData.position.z, lReturnData.radius, fActive, fActionIn, fActionOut, lReturnData.TokenId)
end

on flash_UpdateResourceCKP me, fLabelName, fNewLabelName, fRadius
  fRadius = integer(fRadius)
  if fLabelName <> fNewLabelName then
    lPropList = gResource3dList[fLabelName]
    lX = lPropList["modelRef"].transform.position.x
    lY = lPropList["modelRef"].transform.position.y
    lZ = lPropList["modelRef"].transform.position.z
    lRadius = fRadius
    flash_RemoveResource(VOID, fLabelName)
    lNewCheckPointRef = CreateCheckPoint3D(fNewLabelName, vector(lX, lY, lZ), lRadius)
    lPropList["modelRef"] = lNewCheckPointRef
    gResource3dList.addProp(fNewLabelName, lPropList)
    fLabelName = fNewLabelName
    pSelectedResource = -1
    flash_SelectResource(VOID, fNewLabelName)
  end if
  l3dModelRef = gResource3dList[fLabelName]["modelRef"]
  l3dModelRef.transform.scale = vector(fRadius, fRadius, fRadius)
end

on CreateBonusData fOrientation
  lPosition = GetPositionVector()
  lCurrentToken = GetCurrentToken()
  if lCurrentToken <> 0 then
    lTrackToken = gGame.GetTokenManager().GetTokenRef(lCurrentToken)
    lDirection = GetDirection("Gradi")
    lVehicleDirection = vector(1.0, 0.0, 0.0)
    if fOrientation <> "#custom" then
      lDirection = 0
    end if
    lVehicleDirection.z = 0.0
    lGetToken = gGame.GetTokenManager().getToken(lCurrentToken, lPosition.x, lPosition.y, lPosition, lDirection, 0.0, 0.0)
    lTokenId = lGetToken[1]
  else
    lTokenId = 0
    lDirection = GetDirection("Gradi")
  end if
  lReturnData = [#position: lPosition, #TokenId: lTokenId, #direction: lDirection]
  return lReturnData
end

on CreateBonus3D fNameBonus, fPosition, fBonusModel, fActDistance, fRespawn, fZPos, fZOffset, fMove, fOrient, fOrientation, fRemove, fShadowZ, fDirection, fTokenId
  if fZPos <> "none" then
    fPosition.z = float(fZPos)
  end if
  if fOrient then
    if fOrientation = "#custom" then
      fDirection = float(fDirection)
      lRotation = vector(0.0, 0.0, fDirection)
    else
      lTrackTokens = gGame.GetTokenManager().GetTrackTokens()
      lTransform = lTrackTokens[fTokenId].model.transform.duplicate()
      if fOrientation = "#reverse" then
        lTransform.rotate(0.0, 0.0, 180.0)
      end if
      lRotation = lTransform.rotation
    end if
  else
    lRotation = vector(0.0, 0.0, 0.0)
  end if
  fActDistance = integer(fActDistance)
  lBonusModel = gGame.GetBonusManager().pBonusTypes[fBonusModel].model
  lBonusRef = lBonusModel.cloneDeep(fNameBonus)
  lBonusRef.addToWorld()
  lBonusRef.transform.position = fPosition
  lBonusRef.transform.rotation = lRotation
  lBonusRef.visibility = #both
  lActiv = gGame.Get3D().newModel("activ_" & fNameBonus, pResource3dSphereLow)
  lActiv.shaderList = pShaderBonusActiv
  lActiv.transform.position = fPosition
  lActiv.transform.scale = vector(fActDistance, fActDistance, fActDistance)
  lActiv.visibility = #none
  lBonusRef.addChild(lActiv)
  return lBonusRef
end

on RemoveBonus3d fLabelName
  lName = fLabelName & "_cam"
  lNameActiv = "Activ_" & lName
  gGame.Get3D().deleteModel(lNameActiv)
  gGame.Get3D().deleteModel(lName)
end

on flash_CreateNewBonus me, fLabelLowCase, fLabelName, fBonusModel, fActDistance, fRespawn, fZPos, fZOffset, fMove, fOrient, fOrientation, fRemove, fShadowZ
  lReturnData = CreateBonusData(fOrientation)
  lMove = 1
  if fMove = "0" then
    lMove = 0
  end if
  fMove = lMove
  lOrient = 1
  if fOrient = "0" then
    lOrient = 0
  end if
  fOrient = lOrient
  lRemove = 1
  if fRemove = "0" then
    lRemove = 0
  end if
  fRemove = lRemove
  lBonusRef = CreateBonus3D(fLabelLowCase & "_cam", lReturnData.position, fBonusModel, fActDistance, fRespawn, fZPos, fZOffset, fMove, fOrient, fOrientation, fRemove, fShadowZ, lReturnData.direction, lReturnData.TokenId)
  lPropList = propList()
  lPropList.addProp("modelRef", lBonusRef)
  lPropList.addProp("type", "bon")
  gResource3dList.addProp(fLabelLowCase, lPropList)
  ResourceManagerFlash.SetupNewBonus(fLabelLowCase, fLabelName, lReturnData.position.x, lReturnData.position.y, lReturnData.position.z, fBonusModel, fActDistance, fRespawn, fZPos, fZOffset, fMove, fOrient, fOrientation, fRemove, fShadowZ, lReturnData.direction, lReturnData.TokenId)
end

on flash_ModifyResourceBON me, fLabelLowCase, fLabelName, fBonusModel, fActDistance, fRespawn, fZPos, fZOffset, fMove, fOrient, fOrientation, fRemove, fShadowZ, fDirection
  lMove = 1
  if fMove = "0" then
    lMove = 0
  end if
  fMove = lMove
  lOrient = 1
  if fOrient = "0" then
    lOrient = 0
  end if
  fOrient = lOrient
  lRemove = 1
  if fRemove = "0" then
    lRemove = 0
  end if
  fRemove = lRemove
  fActDistance = float(fActDistance)
  RemoveBonus3d(fLabelLowCase)
  lReturnData = CreateBonusData(fOrientation)
  lBonusRef = CreateBonus3D(fLabelLowCase & "_cam", lReturnData.position, fBonusModel, fActDistance, fRespawn, fZPos, fZOffset, fMove, fOrient, fOrientation, fRemove, fShadowZ, fDirection, lReturnData.TokenId)
  gResource3dList[fLabelLowCase]["modelRef"] = lBonusRef
  pSelectedResource = -1
  flash_SelectResource(VOID, fLabelLowCase)
  ResourceManagerFlash.SetupModifiedBonus(fLabelName, lReturnData.position.x, lReturnData.position.y, lReturnData.position.z, fBonusModel, fActDistance, fRespawn, fZPos, fZOffset, fMove, fOrient, fOrientation, fRemove, fShadowZ, fDirection, lReturnData.TokenId)
end

on flash_UpdateResourceBON me, fLabelName, fNewLabelName, fActDistance
  fActDistance = integer(fActDistance)
  if fLabelName <> fNewLabelName then
    lPropList = gResource3dList[fLabelName]
    lNewBonusRef = gGame.Get3D().model(fLabelName & "_cam").clone(fNewLabelName & "_cam")
    lNewBonusRef.shader = pShaderSaved
    flash_RemoveResource(VOID, fLabelName)
    lPropList["modelRef"] = lNewBonusRef
    gResource3dList.addProp(fNewLabelName, lPropList)
    pSelectedResource = -1
    flash_SelectResource(VOID, fNewLabelName)
  end if
  l3dModelRef = gResource3dList[fNewLabelName]["modelRef"].child[1]
  l3dModelRef.transform.scale = vector(fActDistance, fActDistance, fActDistance)
  ResourceManagerFlash.BonusModified(fNewLabelName)
end

on CreatePlacedObject3D fLabelLowCase, fModel, fPosition, fRotation
  lModelObject3d = gGame.Get3D().model(fModel)
  if lModelObject3d = VOID then
    lModelObject3d = gGame.Get3D().model(fModel & "_dyn")
  end if
  lObject3d = lModelObject3d.clone(fLabelLowCase)
  lObject3d.addToWorld()
  lObject3d.transform.position = fPosition
  lObject3d.visibility = #both
  lObject3d.transform.rotation.z = fRotation
  return lObject3d
end

on CreatePlacedObjectData fSnap
  lPosition = GetPositionVector()
  lCurrentToken = GetCurrentToken()
  if lCurrentToken <> 0 then
    lTokenId = lCurrentToken
  else
    lTokenId = 0
  end if
  lVehicleDirection = GetDirection()
  lPlayerDirection = lVehicleDirection.duplicate()
  lPlayerDirection.z = 0.0
  lVector = vector(1.0, 0.0, 0.0)
  lRotation = lVector.angleBetween(lPlayerDirection)
  lRotation = GetSnappedRotation(lRotation, fSnap)
  lCross = lVector.crossProduct(lPlayerDirection)
  if lCross.z < 0.0 then
    lRotation = 360.0 - lRotation
  end if
  lReturn = [#position: lPosition, #TokenId: lTokenId, #rotation: lRotation]
  return lReturn
end

on flash_CreateNewPlacedObject me, fNewId, fLabelName, fModel, fRemove, fSnap
  fSnap = float(fSnap)
  lReturnData = CreatePlacedObjectData(fSnap)
  lPlacedObjectRef = CreatePlacedObject3D(fNewId, fModel, lReturnData.position, lReturnData.rotation)
  lPropList = propList()
  lPropList.addProp("modelRef", lPlacedObjectRef)
  lPropList.addProp("type", "obj")
  gResource3dList.addProp(fNewId, lPropList)
  ResourceManagerFlash.SetupNewPlacedObject(fNewId, fLabelName, lReturnData.position.x, lReturnData.position.y, lReturnData.position.z, fModel, lReturnData.rotation, fRemove, lReturnData.TokenId)
end

on flash_UpdateResourceOBJ me, fLabelName, fNewLabelName, fModel, fRotation
  fRotation = float(fRotation)
  lPropList = gResource3dList[fLabelName]
  lX = lPropList["modelRef"].transform.position.x
  lY = lPropList["modelRef"].transform.position.y
  lZ = lPropList["modelRef"].transform.position.z
  flash_RemoveResource(VOID, fLabelName)
  lNewPlacedObjectRef = CreatePlacedObject3D(fNewLabelName, fModel, vector(lX, lY, lZ), fRotation)
  lPropList["modelRef"] = lNewPlacedObjectRef
  gResource3dList.addProp(fNewLabelName, lPropList)
  pSelectedResource = -1
  flash_SelectResource(VOID, fNewLabelName)
end

on RemovePlacedObject3d fLabelLowCase
  gGame.Get3D().deleteModel(fLabelLowCase)
end

on flash_ModifyResourceOBJ me, fLabelLowCase, fLabel, fModel, fRemove, fSnap
  fSnap = float(fSnap)
  me.flash_RemoveResource(fLabelLowCase)
  lReturnData = CreatePlacedObjectData(fSnap)
  lPlacedObjectRef = CreatePlacedObject3D(fLabelLowCase, fModel, lReturnData.position, lReturnData.rotation)
  lPropList = propList()
  lPropList.addProp("modelRef", lPlacedObjectRef)
  lPropList.addProp("type", "obj")
  gResource3dList.addProp(fLabelLowCase, lPropList)
  ResourceManagerFlash.SetupModifiedPlacedObject(fLabel, lReturnData.position.x, lReturnData.position.y, lReturnData.position.z, fModel, lReturnData.rotation, fRemove, lReturnData.TokenId)
end

on flash_CreateNewFace me, fLabelLowCase, fLabelName
  lPropList = propList()
  lPropList.addProp("type", "fac")
  lPropList.addProp("posList", [:])
  gResource3dList.addProp(fLabelLowCase, lPropList)
  ResourceManagerFlash.SetupNewFace(fLabelLowCase, fLabelName)
end

on flash_AddFacePosition me, fFaceId, fLabel
  lReturnData = CreatePositionData()
  pFacePositionId = pFacePositionId + 1
  lPositionListRef = gResource3dList[fFaceId].posList
  lPositionListRef.addProp(string(pFacePositionId), lReturnData.position)
  ResourceManagerFlash.SetupNewFacePosition(fFaceId, fLabel, pFacePositionId, lReturnData.position.x, lReturnData.position.y, lReturnData.position.z)
  VisualizeFace(fFaceId)
end

on flash_RemovePositionFace me, fFaceId, fPosId
  DeselectResource(fFaceId)
  gResource3dList[fFaceId].posList.deleteProp(fPosId)
  VisualizeFace(fFaceId)
end

on flash_SetFaceVisualMode me, fMode, fValue
  lValue = 1
  if fValue = "false" then
    lValue = 0
  end if
  case fMode of
    "edge":
      pFaceEdgeMode = lValue
      if lValue then
        VisualizeFace(pSelectedResource)
      else
        HideFaceEdges()
      end if
    "vertex":
      pFaceVertexMode = lValue
      if lValue then
        VisualizeFace(pSelectedResource)
      else
        HideFacePositions(pSelectedResource)
      end if
  end case
end

on VisualizeFace fLabelName
  lPositionList = gResource3dList[fLabelName].posList
  repeat with li = 1 to lPositionList.count
    lPosition = lPositionList[li]
    VisualizeFacePosition(lPosition, li)
  end repeat
  VisualizeFaceEdges(fLabelName)
end

on VisualizeFaceEdges fLabelName
  HideFaceEdges()
  if pFaceEdgeMode then
    lZoffset = 100.0
    lPositionList = gResource3dList[fLabelName].posList
    repeat with li = 1 to lPositionList.count
      lPosition = lPositionList[li].duplicate()
      lPosition.z = lPosition.z + lZoffset
      if li = 1 then
        lItem = [#point: lPosition, #width: 30.0, #tangent: vector(0.0, 0.0, 1.0), #normal: vector(0.0, 1.0, 0.0), #shader: pShader]
        pPolyline.SetPointList([lItem])
      else
        lItem = [#point: lPosition, #width: 30.0, #tangent: vector(0.0, 0.0, 1.0), #normal: vector(0.0, 1.0, 0.0), #shader: pShader]
        pPolyline.InsertPoint(lItem)
      end if
      if li = lPositionList.count then
        lPosition = lPositionList[1].duplicate()
        lPosition.z = lPosition.z + lZoffset
        lItem = [#point: lPosition, #width: 30.0, #tangent: vector(0.0, 0.0, 1.0), #normal: vector(0.0, 1.0, 0.0), #shader: pShader]
        pPolyline.InsertPoint(lItem)
      end if
    end repeat
  end if
end

on VisualizeFacePosition fPosition, fIdentifier
  if pFaceVertexMode then
    if voidp(gGame.Get3D().model("face_vertex" & fIdentifier)) then
      lVertexRef = pResourceVertex.cloneDeep("face_vertex" & fIdentifier)
    else
      lVertexRef = gGame.Get3D().model("face_vertex" & fIdentifier)
    end if
    lVertexRef.transform.position = fPosition
    lVertexRef.visibility = #front
    lVertexRef.transform.scale = vector(1.0, 1.0, 1.0)
  end if
end

on HideFacePosition fIdentifier
  if not voidp(gGame.Get3D().model("face_vertex" & fIdentifier)) then
    lVertexRef = gGame.Get3D().model("face_vertex" & fIdentifier)
    lVertexRef.visibility = #none
  end if
end

on HideFaceEdges
  pPolyline.Destroy()
end

on HideFacePositions fLabelName
  lPositionList = gResource3dList[fLabelName].posList
  repeat with li = 1 to lPositionList.count
    lPosition = lPositionList[li]
    HideFacePosition(li)
  end repeat
end

on flash_SelectFaceVertex me, fFaceId, fPosId
  lPositionList = gResource3dList[fFaceId].posList
  if pFaceVertexMode then
    repeat with li = 1 to lPositionList.count
      lVertexRef = gGame.Get3D().model("face_vertex" & li)
      lPosId = lPositionList.getPropAt(li)
      if lPosId = fPosId then
        lVertexRef.shader = pShaderPathPointSelected
        lVertexRef.transform.scale = 5.0 * vector(1.0, 1.0, 1.0)
        next repeat
      end if
      lVertexRef.shader = pShaderPathPoint
      lVertexRef.transform.scale = vector(1.0, 1.0, 1.0)
    end repeat
  end if
end

on flash_CreateNewPath me, fLabelLowCase, fLabelName, fSnap, fLoop
  lPropList = propList()
  lPropList.addProp("type", "pat")
  lPropList.addProp("pathList", [:])
  gResource3dList.addProp(fLabelLowCase, lPropList)
  ResourceManagerFlash.SetupNewPath(fLabelLowCase, fLabelName, fSnap, fLoop)
end

on flash_AddPathPointList me, fPathId, fLabel, fSnap
  put "flash_AddPathPointList " & fPathId
  pGetPathPoint = fPathId
  pSnap = fSnap
  pLabel = fLabel
end

on flash_StopPathPointList me
  pGetPathPoint = -1
end

on GetPathPoint fPathId
  lActualToken = GetCurrentToken()
  if lActualToken <> 0 then
    if pPrecedentToken <> lActualToken then
      if pPrecedentToken <> 0 then
        lTrackToken = gGame.GetTokenManager().GetTokenRef(lActualToken)
        lTokenType = lTrackToken.token
        lTokenStruct = gGame.GetTokenManager().GetTokensTypesStruct()
        lTokensData = lTokenStruct[lTrackToken.token]
        if lTokensData.type <> #cross then
          pPathPoint3DId = pPathPoint3DId + 1
          if pRotatoryIndex <> -1 then
            ResourceManagerFlash.SetRotatoryLongB(pLabel, pPathPoint3DId - 1, pLongitudinalRotatory)
            pRotatoryIndex = -1
          end if
          lVehicleDirection = GetDirection()
          lVehicleDirection.z = 0.0
          lPosition = GetPositionVector()
          lGetToken = gGame.GetTokenManager().getToken(lActualToken, lPosition.x, lPosition.y, lPosition, lVehicleDirection, 0.0, 0.0)
          lTokenId = lGetToken[1]
          lTokenDirection = lGetToken[3]
          lLongitudinal = lGetToken[4]
          if lLongitudinal < 0.5 then
            lLongitudinalA = 0.0
            lLongitudinalB = 1.0
          else
            lLongitudinalA = 1.0
            lLongitudinalB = 0.0
          end if
          lTrasversal = lGetToken[5]
          if pSnap <> "false" then
            lSnap = float(pSnap)
            if (lTokenType = "d3c3_pa") or (lTokenType = "d3c3_pm") or (lTokenType = "d3c3_b") or (lTokenType = "d3c3_a") or (lTokenType = "d3c3_m") then
              lSnap = lSnap * 0.5
            else
              if lTokensData.OneWay then
                lSnap = 0.0
              end if
            end if
            lAngleBetw = lVehicleDirection.angleBetween(lTokenDirection)
            if lAngleBetw < 80.0 then
              lTrasversal = lSnap
            else
              lTrasversal = -lSnap
            end if
            if lTokensData.type = #rotary then
              pRotatoryIndex = pPathPoint3DId
              lTrasversal = 0.0
              lLongitudinalA = lLongitudinal
              lLongitudinalB = 0.0
            end if
          end if
          lPathPointRef = Create3DPathPoint("pathPoint_" & pPathPoint3DId, lTokenId, lLongitudinalA, lTrasversal)
          lPathList = gResource3dList[fPathId].pathList
          lPathList.addProp(string(pPathPoint3DId), lPathPointRef)
          ResourceManagerFlash.AddNewPathPoint(fPathId, pLabel, pPathPoint3DId, lTokenId, lLongitudinalA, lLongitudinalB, lTrasversal, lPathPointRef.transform.position.x, lPathPointRef.transform.position.y)
        end if
      else
        if pRotatoryIndex <> -1 then
          lPosition = GetPositionVector()
          lGetToken = gGame.GetTokenManager().getToken(lActualToken, lPosition.x, lPosition.y, lPosition, lVehicleDirection, 0.0, 0.0)
          pLongitudinalRotatory = lGetToken[4]
        end if
      end if
    end if
  end if
  pPrecedentToken = lActualToken
end

on Create3DPathPoint fName, fTokenId, fLongitudinal, fTrasversal
  lPosition = gGame.GetTokenManager().TokenToWorld(fTokenId, fLongitudinal, fTrasversal)
  lTrackToken = gGame.GetTokenManager().GetTokenRef(fTokenId)
  lTokenType = lTrackToken.token
  lTokenStruct = gGame.GetTokenManager().GetTokensTypesStruct()
  lTokensData = lTokenStruct[lTokenType]
  if (fLongitudinal < 0.5) or (lTokensData.type = #rotary) then
    lPositionPointAt = gGame.GetTokenManager().TokenToWorld(fTokenId, fLongitudinal + 0.10000000000000001, fTrasversal)
  else
    lPositionPointAt = gGame.GetTokenManager().TokenToWorld(fTokenId, fLongitudinal - 0.10000000000000001, fTrasversal)
  end if
  lObject3d = gGame.Get3D().newModel(fName, pResource3dPathPoint)
  lObject3d.shaderList = pShaderPathPoint
  lObject3d.transform.position = lPosition
  lObject3d.visibility = #both
  lObject3d.pointAtOrientation = [vector(0.0, 1.0, 0.0), vector(0.0, 0.0, 1.0)]
  lObject3d.pointAt(lPositionPointAt, vector(0.0, 0.0, 1.0))
  return lObject3d
end

on flash_UpdateResourcePAT me, fLabelName, fNewLabelName
  if fLabelName <> fNewLabelName then
    lPropList = gResource3dList[fLabelName]
    gResource3dList.addProp(fNewLabelName, lPropList)
    gResource3dList.deleteProp(fLabelName)
  end if
end

on RemovePositionPath3D lModelRef
  gGame.Get3D().deleteModel(lModelRef.name)
end

on flash_DeletePathPoint me, fLabelLowCase, fPointId
  lPathPointListRef = gResource3dList[fLabelLowCase].pathList
  RemovePositionPath3D(lPathPointListRef[fPointId])
  lPathPointListRef.deleteProp(fPointId)
end

on flash_SelectResource me, fLabelName
  if pSelectedResource <> fLabelName then
    if pSelectedResource <> -1 then
      DeselectResource(pSelectedResource)
    end if
    pSelectedResource = fLabelName
    SelectResource(pSelectedResource)
  end if
end

on flash_RemoveResource me, fLabelName
  if pSelectedResource = fLabelName then
    pSelectedResource = -1
  end if
  l3dModelRef = gResource3dList[fLabelName]["modelRef"]
  lType = gResource3dList[fLabelName].type
  if lType = "ckl" then
    RemoveCheckLine3d(fLabelName)
  end if
  if lType = "ckp" then
    RemoveCheckPoint3d(fLabelName)
  end if
  if lType = "bon" then
    RemoveBonus3d(fLabelName)
  end if
  if lType = "posit" then
    RemovePosition3d(fLabelName)
  end if
  if lType = "obj" then
    RemovePlacedObject3d(fLabelName)
  end if
  if lType = "pat" then
    lPathList = gResource3dList[fLabelName].pathList
    repeat with li = 1 to lPathList.count
      RemovePositionPath3D(lPathList[li])
    end repeat
  end if
  if lType = "fac" then
    HideFacePositions(fLabelName)
    HideFaceEdges(fLabelName)
  end if
  gResource3dList.deleteProp(fLabelName)
end

on SelectResource fLabelName
  lType = gResource3dList[fLabelName].type
  case lType of
    "pat":
      lPathListRef = gResource3dList[fLabelName].pathList
      repeat with lj = 1 to lPathListRef.count
        lPathListRef[lj].visibility = #both
        lPathListRef[lj].shader = pShaderPathPoint
      end repeat
    "fac":
      VisualizeFace(fLabelName)
    "posit", "ckl", "ckp", "bon", "obj":
      l3dModelRef = gResource3dList[fLabelName]["modelRef"]
      l3dModelRef.transform.scale = vector(1.10000000000000009, 1.10000000000000009, 1.10000000000000009)
      pShaderSaved = l3dModelRef.shader
      l3dModelRef.shader = pShaderSelected
      if lType = "bon" then
        l3dModelRef.child[1].visibility = #front
      end if
  end case
end

on DeselectResource fLabelName
  if fLabelName <> -1 then
    lType = gResource3dList[fLabelName].type
    case lType of
      "pat":
        lPathListRef = gResource3dList[fLabelName].pathList
        repeat with lj = 1 to lPathListRef.count
          lPathListRef[lj].shader = pShader
        end repeat
      "fac":
        lPositionList = gResource3dList[fLabelName].posList
        repeat with li = 1 to lPositionList.count
          lPosition = lPositionList[li]
          if pFaceVertexMode then
            HideFacePosition(li)
          end if
        end repeat
        HideFaceEdges()
      "posit", "ckl", "ckp", "bon", "obj":
        l3dModelRef = gResource3dList[fLabelName]["modelRef"]
        l3dModelRef.transform.scale = vector(1.0, 1.0, 1.0)
        l3dModelRef.shader = pShaderSaved
        if lType = "bon" then
          l3dModelRef.child[1].visibility = #none
        end if
    end case
  end if
end

on flash_InitializeVisualize3DResource me
  pResourceVisualized = []
end

on flash_Visualize3DResource me, fLabelName
  pResourceVisualized.add(fLabelName)
end

on flash_CheckVisualization me
  repeat with li = 1 to gResource3dList.count
    lModelRef = gResource3dList[li]["modelRef"]
    lType = gResource3dList[li].type
    if lType <> "pat" then
      SetHierarchyVisibility(lModelRef, #none)
      next repeat
    end if
    lResource = gResource3dList[li]
    repeat with lj = 1 to lResource.pathList.count
      lResource.pathList[lj].visibility = #none
    end repeat
  end repeat
  repeat with li = 1 to pResourceVisualized.count
    fLabelName = pResourceVisualized[li]
    lType = gResource3dList[fLabelName].type
    if lType <> "pat" then
      lModelRef = gResource3dList[fLabelName]["modelRef"]
      if lType = "bon" then
        lModelRef.visibility = #front
      else
        SetHierarchyVisibility(lModelRef, #both)
      end if
      next repeat
    end if
    lResource = gResource3dList[fLabelName]
    repeat with lj = 1 to lResource.pathList.count
      lResource.pathList[lj].visibility = #both
    end repeat
  end repeat
end

on flash_Get3DPosition me
  lPosition = GetPositionVector()
  ResourceManagerFlash.Setup3DPosition(lPosition.x, lPosition.y, lPosition.z)
end

on flash_Sincronize me
  SetFlashPreferences()
  if (gResourceFileMode = #fileInto) or (gResourceFileMode = #fromCastMember) then
    pResourceFileMember = member(99).importFileInto(pResourcesFileName)
    lText = member(99).text
    if lText <> EMPTY then
      me.ParseFileInto(lText)
    end if
  else
    me.ParseExternalFile()
  end if
end

on flash_SaveFileResource me
  put "saving ResourcesFile"
  objFileio = new xtra("fileio")
  objFileio.openfile(pResourcesFileName, 0)
  delete objFileio
  objFileio.createFile(pResourcesFileName)
  objFileio.openfile(pResourcesFileName, 0)
  lCommentControl = [#ckl: [#ID: "ckl", #inserted: 0, #comment: "-- CheckLine: ckl labelLowCase label Xa Ya Xb Yb ActionFront ActionBack WidthIncrement TokenId"], #ckp: [#ID: "ckp", #inserted: 0, #comment: "-- CheckPoint: ckp labelLowCase label X Y Z Radius Active ActionIn ActionOut TokenId"], #posit: [#ID: "posit", #inserted: 0, #comment: "-- Position: pos labelLowCase label X Y Z TokenId UserData"], #bon: [#ID: "bon", #inserted: 0, #comment: "-- Bonus: bon labelLowCase label bonusModel X Y Z ActivationDistance Respawn zPos zOffset Move Orient Orientation Remove ShadowZ CustomDirection TokenId"], #obj: [#ID: "obj", #inserted: 0, #comment: "-- PlacedObject: obj labelLowCase label X Y Z Model Rotation Remove TokenId"], #pat: [#ID: "pat", #inserted: 0, #comment: "-- Path: pat labelLowCase label Loop Snap"], #fac: [#ID: "fac", #inserted: 0, #comment: "-- Face: fac labelLowCase label"]]
  repeat with li = 1 to gResource3dList.count
    lRLref = gResource3dList[li]
    lType = lRLref.type
    if lType <> VOID then
      lUserData = lRLref.userData
      lCommentControlRef = lCommentControl[lType]
      if lCommentControlRef.inserted = 0 then
        lPositionFile = objFileio.getPosition()
        if lPositionFile > 1 then
          objFileio.writeString(RETURN & numToChar(10))
        end if
        objFileio.writeString(lCommentControlRef.comment)
        lCommentControlRef.inserted = 1
      end if
      case lType of
        "ckl":
          lId = lUserData.ID
          lNameResource = lUserData.label
          lXa = lUserData.Xa
          lYa = lUserData.Ya
          lXb = lUserData.Xb
          lYb = lUserData.Yb
          lActionFront = lUserData.ActionFront
          lActionBack = lUserData.ActionBack
          if lActionFront = EMPTY then
            lActionFront = "none"
          end if
          if lActionBack = EMPTY then
            lActionBack = "none"
          end if
          lTokenId = lUserData.TokenId
          lWidthIncrement = lUserData.WidthIncrement
          objFileio.writeString(RETURN & numToChar(10))
          objFileio.writeString("ckl " & lId & " " & lNameResource & " " & lXa & " " & lYa & " " & lXb & " " & lYb & " " & lActionFront & " " & lActionBack & " " & lWidthIncrement & " " & lTokenId)
        "ckp":
          lId = lUserData.ID
          lNameResource = lUserData.label
          lX = lUserData.x
          lY = lUserData.y
          lZ = lUserData.z
          lRadius = lUserData.radius
          lActive = lUserData.Active
          lActionIn = lUserData.ActionIn
          lActionOut = lUserData.ActionOut
          lTokenId = lUserData.TokenId
          objFileio.writeString(RETURN & numToChar(10))
          objFileio.writeString("ckp " & lId & " " & lNameResource & " " & lX & " " & lY & " " & lZ & " " & lRadius & " " & lActive & " " & lActionIn & " " & lActionOut & " " & lTokenId)
        "posit":
          lId = lUserData.ID
          lNameResource = lUserData.label
          lX = lUserData.x
          lY = lUserData.y
          lZ = lUserData.z
          lTokenId = lUserData.TokenId
          lUserData = lUserData.userData
          if lUserData = EMPTY then
            lUserData = "#NoUserData"
          end if
          objFileio.writeString(RETURN & numToChar(10))
          objFileio.writeString("posit " & lId & " " & lNameResource & " " & lX & " " & lY & " " & lZ & " " & lTokenId & " " & lUserData)
        "bon":
          lId = lUserData.ID
          lNameResource = lUserData.label
          lBonusModel = lUserData.BonusModel
          lX = lUserData.x
          lY = lUserData.y
          lZ = lUserData.z
          lActDistance = lUserData.ActDistance
          lRespawn = lUserData.Respawn
          lZpos = lUserData.zPos
          lZoffset = lUserData.ZOffset
          lMove = lUserData.move
          lOrient = lUserData.Orient
          lOrientation = lUserData.orientation
          lRemove = lUserData.Remove
          lShadowZ = lUserData.ShadowZ
          lDirection = lUserData.direction
          lTokenId = lUserData.TokenId
          objFileio.writeString(RETURN & numToChar(10))
          objFileio.writeString("bon " & lId & " " & lNameResource & " " & lBonusModel & " " & lX & " " & lY & " " & lZ & " " & lActDistance & " " & lRespawn)
          objFileio.writeString(" " & lZpos & " " & lZoffset & " " & lMove & " " & lOrient & " " & lOrientation & " " & lRemove & " " & lShadowZ & " " & lDirection & " " & lTokenId)
        "obj":
          lId = lUserData.ID
          lNameResource = lUserData.label
          lX = lUserData.x
          lY = lUserData.y
          lZ = lUserData.z
          lModel = lUserData.model
          lRotation = lUserData.rotation
          lRemove = lUserData.Remove
          if lRemove = "true" then
            lRemove = 1
          else
            lRemove = 0
          end if
          lTokenId = lUserData.TokenId
          objFileio.writeString(RETURN & numToChar(10))
          objFileio.writeString("obj " & lId & " " & lNameResource & " " & lX & " " & lY & " " & lZ & " " & lModel & " " & lRotation & " " & lRemove & " " & lTokenId)
        "pat":
          lId = lUserData.ID
          lNameResource = lUserData.label
          lLoop = lUserData.loop
          lSnap = lUserData.Snap
          objFileio.writeString(RETURN & numToChar(10))
          objFileio.writeString("pat " & lId & " " & lNameResource & " " & lLoop & " " & lSnap)
          lPathPointListRef = gResource3dList[lId].pathList
          repeat with lj = 1 to lPathPointListRef.count
            lPointRef = lPathPointListRef[lj]
            objFileio.writeString(RETURN & numToChar(10))
            objFileio.writeString("pointPath " & lPointRef.userData.userData.token & " " & lPointRef.userData.userData.a & " " & lPointRef.userData.userData.b & " " & lPointRef.userData.userData.L)
          end repeat
        "fac":
          lId = lUserData.ID
          lNameResource = lUserData.label
          objFileio.writeString(RETURN & numToChar(10))
          objFileio.writeString("fac " & lId & " " & lNameResource)
          lPositionListRef = gResource3dList[lId].posList
          repeat with lj = 1 to lPositionListRef.count
            lPositioRef = lPositionListRef[lj]
            objFileio.writeString(RETURN & numToChar(10))
            objFileio.writeString("facePosition " & lPositioRef.x & " " & lPositioRef.y & " " & lPositioRef.z)
          end repeat
      end case
    end if
  end repeat
  objFileio.closeFile()
  put "ResourceFile saved"
  put "Saving PreferencesFile"
  flash_SaveFilePreferences()
  put "Preferences saved"
  ResourceManagerFlash.FileSaved()
end

on flash_SetDataResourceToSaveCKL me, fLabelLowCase, fLabel, fXa, fYa, fXb, fYb, fActionFront, fActionBack, fTokenId, fWidthIncr
  lRLref = gResource3dList[fLabelLowCase]
  lUserData = [#ID: fLabelLowCase, #label: fLabel, #Xa: fXa, #Ya: fYa, #Xb: fXb, #Yb: fYb, #ActionFront: fActionFront, #ActionBack: fActionBack, #TokenId: fTokenId, #WidthIncrement: fWidthIncr]
  if lRLref.findPos(#userData) <> VOID then
    lRLref.deleteProp(#userData)
  end if
  lRLref.addProp(#userData, lUserData)
end

on flash_SetDataResourceToSaveCKP me, fLabelLowCase, fLabel, Fx, Fy, fZ, fRadius, fActive, fActionIn, fActionOut, fTokenId
  lRLref = gResource3dList[fLabelLowCase]
  lUserData = [#ID: fLabelLowCase, #label: fLabel, #x: Fx, #y: Fy, #z: fZ, #radius: fRadius, #Active: fActive, #ActionIn: fActionIn, #ActionOut: fActionOut, #TokenId: fTokenId]
  if lRLref.findPos(#userData) <> VOID then
    lRLref.deleteProp(#userData)
  end if
  lRLref.addProp(#userData, lUserData)
end

on flash_SetDataResourceToSavePOS me, fLabelLowCase, fLabel, Fx, Fy, fZ, fTokenId, fUserData
  lRLref = gResource3dList[fLabelLowCase]
  lUserData = [#ID: fLabelLowCase, #label: fLabel, #x: Fx, #y: Fy, #z: fZ, #TokenId: fTokenId, #userData: fUserData]
  if lRLref.findPos(#userData) <> VOID then
    lRLref.deleteProp(#userData)
  end if
  lRLref.addProp(#userData, lUserData)
end

on flash_SetDataResourceToSaveBON me, fLabelLowCase, fLabel, fBonusModel, Fx, Fy, fZ, fActDistance, fRespawn, fZPos, fZOffset, fMove, fOrient, fOrientation, fRemove, fShadowZ, fDirection, fTokenId
  lRLref = gResource3dList[fLabelLowCase]
  lUserData = [#ID: fLabelLowCase, #label: fLabel, #BonusModel: fBonusModel, #x: Fx, #y: Fy, #z: fZ, #ActDistance: fActDistance, #Respawn: fRespawn, #zPos: fZPos, #ZOffset: fZOffset, #move: fMove, #Orient: fOrient, #orientation: fOrientation, #Remove: fRemove, #ShadowZ: fShadowZ, #direction: fDirection, #TokenId: fTokenId]
  if lRLref.findPos(#userData) <> VOID then
    lRLref.deleteProp(#userData)
  end if
  lRLref.addProp(#userData, lUserData)
end

on flash_SetDataResourceToSaveOBJ me, fLabelLowCase, fLabel, fModel, Fx, Fy, fZ, fRotation, fRemove, fTokenId
  lRLref = gResource3dList[fLabelLowCase]
  lUserData = [#ID: fLabelLowCase, #label: fLabel, #x: Fx, #y: Fy, #z: fZ, #model: fModel, #rotation: fRotation, #Remove: fRemove, #TokenId: fTokenId]
  if lRLref.findPos(#userData) <> VOID then
    lRLref.deleteProp(#userData)
  end if
  lRLref.addProp(#userData, lUserData)
end

on flash_SetDataResourceToSavePAT me, fLabelLowCase, fLabel, fLoop, fSnap
  lRLref = gResource3dList[fLabelLowCase]
  lUserData = [#ID: fLabelLowCase, #label: fLabel, #loop: fLoop, #Snap: fSnap]
  if lRLref.findPos(#userData) <> VOID then
    lRLref.deleteProp(#userData)
  end if
  lRLref.addProp(#userData, lUserData)
end

on flash_SetDataResourceToSavePATPoint me, fLabelLowCase, fToken, fA, fB, fL, fPosId
  lPathPointRef = gResource3dList[fLabelLowCase].pathList[fPosId]
  lUserData = [#token: fToken, #a: fA, #b: fB, #L: fL]
  if lPathPointRef.userData.findPos(#userData) <> VOID then
    lPathPointRef.userData.deleteProp(#userData)
  end if
  lPathPointRef.userData.addProp(#userData, lUserData)
end

on flash_SetDataResourceToSaveFAC me, fLabelLowCase, fLabel
  lRLref = gResource3dList[fLabelLowCase]
  lUserData = [#ID: fLabelLowCase, #label: fLabel]
  if lRLref.findPos(#userData) <> VOID then
    lRLref.deleteProp(#userData)
  end if
  lRLref.addProp(#userData, lUserData)
end

on flash_ModifyPathPoint me, fPathFlash, fPath, fPointId, fTokenId, fA, fB, fL
  fTokenId = integer(fTokenId)
  fA = float(fA)
  fB = float(fB)
  fL = float(fL)
  lPathPointRef = gResource3dList[fPath].pathList[fPointId]
  lPosition = gGame.GetTokenManager().TokenToWorld(fTokenId, fA, fL)
  lPathPointRef.transform.position = lPosition
  ResourceManagerFlash.UpdatePathPointPosition(fPathFlash, pPathPoint3DId, lPathPointRef.transform.position.x, lPathPointRef.transform.position.y)
end

on flash_SelectPathPoint me, fPath, fPointId
  lPathListRef = gResource3dList[fPath].pathList
  repeat with li = 1 to lPathListRef.count
    lPathListRef[li].shader = pShaderPathPoint
  end repeat
  lPathListRef[fPointId].shader = pShaderPathPointSelected
end

on RemoveBeginReturn me, fString
  lString = fString
  if charToNum(chars(fString, 1, 1)) = 10 then
    lString = chars(fString, 2, lString.length)
  end if
  return lString
end

on ParseExternalFile me
  objFileio = new xtra("fileio")
  objFileio.openfile(pResourcesFileName, 1)
  lErrorCode = objFileio.status()
  if lErrorCode <> 0 then
    objFileio.createFile(pResourcesFileName)
    objFileio.openfile(pResourcesFileName, 1)
  end if
  lstrToken = objFileio.readToken(" ", " ")
  repeat while objFileio.getPosition() < objFileio.getLength()
    case lstrToken of
      "--":
        lstrToken = objFileio.readLine()
      "ckl":
        lLabelLowCase = objFileio.readWord()
        lNameResource = objFileio.readWord()
        lXa = float(objFileio.readWord())
        lYa = float(objFileio.readWord())
        lXb = float(objFileio.readWord())
        lYb = float(objFileio.readWord())
        lActionFront = objFileio.readWord()
        lActionBack = objFileio.readWord()
        lWidthIncrement = float(objFileio.readWord())
        lTokenId = objFileio.readToken(" ", " " & RETURN & numToChar(10))
        lPointA = vector(lXa, lYa, 0.0)
        lPointB = vector(lXb, lYb, 0.0)
        lWidthPlane = (lPointA - lPointB).magnitude
        lCheckLineRef = CreateCheckLine3D(lLabelLowCase, 500.0, lWidthPlane, lPointA, lPointB)
        lPropList = propList()
        lPropList.addProp("modelRef", lCheckLineRef)
        lPropList.addProp("type", "ckl")
        gResource3dList.addProp(lLabelLowCase, lPropList)
        ResourceManagerFlash.SetupNewCheckLine(lLabelLowCase, lNameResource, lXa, lYa, lXb, lYb, lActionFront, lActionBack, lTokenId, lWidthIncrement)
      "ckp":
        lLabelLowCase = objFileio.readWord()
        lNameResource = objFileio.readWord()
        lX = float(objFileio.readWord())
        lY = float(objFileio.readWord())
        lZ = float(objFileio.readWord())
        lRadius = float(objFileio.readWord())
        lActive = objFileio.readWord()
        lActionIn = objFileio.readWord()
        lActionOut = objFileio.readWord()
        lTokenId = objFileio.readToken(" ", " " & RETURN & numToChar(10))
        lCheckPointRef = CreateCheckPoint3D(lLabelLowCase, vector(lX, lY, lZ), lRadius)
        lPropList = propList()
        lPropList.addProp("modelRef", lCheckPointRef)
        lPropList.addProp("type", "ckp")
        gResource3dList.addProp(lLabelLowCase, lPropList)
        ResourceManagerFlash.SetupNewCheckPoint(lLabelLowCase, lNameResource, lX, lY, lZ, lRadius, lActive, lActionIn, lActionOut, lTokenId)
      "posit":
        lLabelLowCase = objFileio.readWord()
        lNameResource = objFileio.readWord()
        lX = float(objFileio.readWord())
        lY = float(objFileio.readWord())
        lZ = float(objFileio.readWord())
        lTokenId = objFileio.readWord()
        lPosUserData = objFileio.readToken(" ", RETURN & numToChar(10))
        lPositionRef = CreatePosition3D(lLabelLowCase, vector(lX, lY, lZ))
        lPropList = propList()
        lPropList.addProp("modelRef", lPositionRef)
        lPropList.addProp("type", "posit")
        gResource3dList.addProp(lLabelLowCase, lPropList)
        ResourceManagerFlash.SetupNewPosition(lLabelLowCase, lNameResource, lX, lY, lZ, lTokenId, lPosUserData)
      "bon":
        lFilePosition = objFileio.getPosition()
        objFileio.setPosition(lFilePosition + 1)
        lBonusString = objFileio.readLine()
        objFileio.setPosition(lFilePosition)
        lInitialIndex = 0
        lNumWords = 0
        lCode = #initcode
        repeat while (lCode <> #newline) and (lCode <> #endstring)
          lWordResult = me.readWord(lBonusString, lInitialIndex + 1)
          lCode = lWordResult[3]
          lInitialIndex = lWordResult[2]
          lNumWords = lNumWords + 1
        end repeat
        lLabelLowCase = objFileio.readWord()
        lNameResource = objFileio.readWord()
        lBonusModel = objFileio.readWord()
        lX = float(objFileio.readWord())
        lY = float(objFileio.readWord())
        lZ = float(objFileio.readWord())
        lActDistance = float(objFileio.readWord())
        lRespawn = float(objFileio.readWord())
        lZpos = float(objFileio.readWord())
        lZoffset = float(objFileio.readWord())
        lMove = objFileio.readWord()
        if lMove = "true" then
          lMove = 1
        else
          lMove = 0
        end if
        lOrient = objFileio.readWord()
        if lOrient = "true" then
          lOrient = 1
        else
          lOrient = 0
        end if
        lOrientation = float(objFileio.readWord())
        lRemove = float(objFileio.readWord())
        if lRemove = "true" then
          lRemove = 1
        else
          lRemove = 0
        end if
        lShadowZ = float(objFileio.readWord())
        if lNumWords = 17 then
          lCustomRotation = float(objFileio.readWord())
        else
          lCustomRotation = 0.0
        end if
        lTokenId = objFileio.readToken(" ", " " & RETURN & numToChar(10))
        lBonusRef = CreateBonus3D(lLabelLowCase & "_cam", vector(lX, lY, lZ), lBonusModel, lActDistance, lRespawn, lZpos, lZoffset, lMove, lOrient, lOrientation, lRemove, lShadowZ, lCustomRotation, lTokenId)
        lPropList = propList()
        lPropList.addProp("modelRef", lBonusRef)
        lPropList.addProp("type", "bon")
        gResource3dList.addProp(lLabelLowCase, lPropList)
        ResourceManagerFlash.SetupNewBonus(lLabelLowCase, lNameResource, lX, lY, lZ, lBonusModel, lActDistance, lRespawn, lZpos, lZoffset, lMove, lOrient, lOrientation, lRemove, lShadowZ, lCustomRotation, lTokenId)
      "obj":
        lLabelLowCase = objFileio.readWord()
        lNameResource = objFileio.readWord()
        lX = float(objFileio.readWord())
        lY = float(objFileio.readWord())
        lZ = float(objFileio.readWord())
        lModel = objFileio.readWord()
        lRotation = float(objFileio.readWord())
        lRemove = objFileio.readWord()
        lTokenId = objFileio.readToken(" ", " " & RETURN & numToChar(10))
        lPlacedObjectRef = CreatePlacedObject3D(lLabelLowCase, lModel, vector(lX, lY, lZ), lRotation)
        lPropList = propList()
        lPropList.addProp("modelRef", lPlacedObjectRef)
        lPropList.addProp("type", "obj")
        gResource3dList.addProp(lLabelLowCase, lPropList)
        ResourceManagerFlash.SetupNewPlacedObject(lLabelLowCase, lNameResource, lX, lY, lZ, lModel, lRotation, lRemove, lTokenId)
      "pat":
        lLabelLowCase = objFileio.readWord()
        lNameResource = objFileio.readWord()
        lLoop = objFileio.readWord()
        lSnap = objFileio.readToken(" ", " " & RETURN & numToChar(10))
        lPropList = propList()
        lPropList.addProp("type", "pat")
        lPropList.addProp("pathList", [:])
        gResource3dList.addProp(lLabelLowCase, lPropList)
        ResourceManagerFlash.SetupNewPath(lLabelLowCase, lNameResource, lSnap, lLoop)
        pLabel = lNameResource
      "pointPath":
        lPathId = lLabelLowCase
        lLabel = pLabel
        pPathPoint3DId = pPathPoint3DId + 1
        lTokenId = integer(objFileio.readWord())
        lLongitudinalA = float(objFileio.readWord())
        lLongitudinalB = float(objFileio.readWord())
        lTrasversal = float(objFileio.readToken(" ", " " & RETURN & numToChar(10)))
        lPathPointRef = Create3DPathPoint("pathPoint_" & pPathPoint3DId, lTokenId, lLongitudinalA, lTrasversal)
        lPathList = gResource3dList[lPathId].pathList
        lPathList.addProp(string(pPathPoint3DId), lPathPointRef)
        ResourceManagerFlash.AddNewPathPoint(lPathId, lLabel, pPathPoint3DId, lTokenId, lLongitudinalA, lLongitudinalB, lTrasversal, lPathPointRef.transform.position.x, lPathPointRef.transform.position.y)
      "fac":
        lLabelLowCase = objFileio.readWord()
        lNameResource = objFileio.readToken(" ", " " & RETURN & numToChar(10))
        lPropList = propList()
        lPropList.addProp("type", "fac")
        lPropList.addProp("posList", [:])
        gResource3dList.addProp(lLabelLowCase, lPropList)
        ResourceManagerFlash.SetupNewFace(lLabelLowCase, lNameResource)
        pFaceLabel = lNameResource
      "facePosition":
        pFacePositionId = pFacePositionId + 1
        lX = float(objFileio.readWord())
        lY = float(objFileio.readWord())
        lZ = float(objFileio.readToken(" ", " " & RETURN & numToChar(10)))
        lPositionListRef = gResource3dList[pFaceLabel].posList
        lPositionListRef.addProp(string(pFacePositionId), vector(lX, lY, lZ))
        ResourceManagerFlash.SetupNewFacePosition(lLabelLowCase, pFaceLabel, pFacePositionId, lX, lY, lZ)
    end case
    lstrToken = objFileio.readToken(RETURN & " " & numToChar(10), " ")
  end repeat
  objFileio.closeFile()
end

on ParseFileInto me, fString
  lIndex = 0
  repeat while 1
    lWordResult = me.readWord(fString, lIndex + 1)
    lstrToken = lWordResult[1]
    lIndex = lWordResult[2]
    lCode = lWordResult[3]
    if lCode = #endstring then
      exit repeat
    end if
    case lstrToken of
      "--":
        lCheckEndLine = 1
        repeat while lCheckEndLine
          lWordResult = me.readWord(fString, lIndex + 1)
          lIndex = lWordResult[2]
          lCode = lWordResult[3]
          if lCode = #newline then
            lCheckEndLine = 0
          end if
        end repeat
      "ckl":
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lLabelLowCase = lWordResult[1]
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lNameResource = lWordResult[1]
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lXa = float(lWordResult[1])
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lYa = float(lWordResult[1])
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lXb = float(lWordResult[1])
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lYb = float(lWordResult[1])
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lActionFront = lWordResult[1]
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lActionBack = lWordResult[1]
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lWidthIncrement = float(lWordResult[1])
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lTokenId = lWordResult[1]
        lPointA = vector(lXa, lYa, 0.0)
        lPointB = vector(lXb, lYb, 0.0)
        lWidthPlane = (lPointA - lPointB).magnitude
        lCheckLineRef = CreateCheckLine3D(lLabelLowCase, 500.0, lWidthPlane, lPointA, lPointB)
        lPropList = propList()
        lPropList.addProp("modelRef", lCheckLineRef)
        lPropList.addProp("type", "ckl")
        gResource3dList.addProp(lLabelLowCase, lPropList)
        ResourceManagerFlash.SetupNewCheckLine(lLabelLowCase, lNameResource, lXa, lYa, lXb, lYb, lActionFront, lActionBack, lTokenId, lWidthIncrement)
      "ckp":
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lLabelLowCase = lWordResult[1]
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lNameResource = lWordResult[1]
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lX = float(lWordResult[1])
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lY = float(lWordResult[1])
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lZ = float(lWordResult[1])
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lRadius = float(lWordResult[1])
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lActive = lWordResult[1]
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lActionIn = lWordResult[1]
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lActionOut = lWordResult[1]
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lTokenId = lWordResult[1]
        lCheckPointRef = CreateCheckPoint3D(lLabelLowCase, vector(lX, lY, lZ), lRadius)
        lPropList = propList()
        lPropList.addProp("modelRef", lCheckPointRef)
        lPropList.addProp("type", "ckp")
        gResource3dList.addProp(lLabelLowCase, lPropList)
        ResourceManagerFlash.SetupNewCheckPoint(lLabelLowCase, lNameResource, lX, lY, lZ, lRadius, lActive, lActionIn, lActionOut, lTokenId)
      "posit":
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lLabelLowCase = lWordResult[1]
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lNameResource = lWordResult[1]
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lX = float(lWordResult[1])
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lY = float(lWordResult[1])
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lZ = float(lWordResult[1])
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lTokenId = lWordResult[1]
        lPosUserData = EMPTY
        lUserDataToRead = 1
        repeat while lUserDataToRead
          lWordResult = me.readWord(fString, lIndex + 1)
          lIndex = lWordResult[2]
          lCode = lWordResult[3]
          lPosUserData = lPosUserData & lWordResult[1]
          if (lCode = #newline) or (lCode = #endstring) then
            lUserDataToRead = 0
            if lCode = #endstring then
              lIndex = lIndex - 1
            end if
          end if
        end repeat
        lPositionRef = CreatePosition3D(lLabelLowCase, vector(lX, lY, lZ))
        lPropList = propList()
        lPropList.addProp("modelRef", lPositionRef)
        lPropList.addProp("type", "posit")
        gResource3dList.addProp(lLabelLowCase, lPropList)
        ResourceManagerFlash.SetupNewPosition(lLabelLowCase, lNameResource, lX, lY, lZ, lTokenId, lPosUserData)
      "bon":
        lInitialIndex = lIndex
        lWordResult = me.readWord(fString, lIndex + 1)
        lNumWords = 1
        lCode = lWordResult[3]
        repeat while (lCode <> #newline) and (lCode <> #endstring)
          lWordResult = me.readWord(fString, lIndex + 1)
          lCode = lWordResult[3]
          lIndex = lWordResult[2]
          lNumWords = lNumWords + 1
        end repeat
        lIndex = lInitialIndex
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lLabelLowCase = lWordResult[1]
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lNameResource = lWordResult[1]
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lBonusModel = lWordResult[1]
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lX = float(lWordResult[1])
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lY = float(lWordResult[1])
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lZ = float(lWordResult[1])
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lActDistance = float(lWordResult[1])
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lRespawn = float(lWordResult[1])
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lZpos = float(lWordResult[1])
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lZoffset = float(lWordResult[1])
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lMove = lWordResult[1]
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lOrient = lWordResult[1]
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lOrientation = lWordResult[1]
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lRemove = lWordResult[1]
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lShadowZ = float(lWordResult[1])
        if lNumWords = 18 then
          lWordResult = me.readWord(fString, lIndex + 1)
          lIndex = lWordResult[2]
          lCustomRotation = float(lWordResult[1])
        else
          lCustomRotation = 0.0
        end if
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lTokenId = lWordResult[1]
        if lMove = "true" then
          lMove = 1
        else
          lMove = 0
        end if
        if lOrient = "true" then
          lOrient = 1
        else
          lOrient = 0
        end if
        if lRemove = "true" then
          lRemove = 1
        else
          lRemove = 0
        end if
        lBonusRef = CreateBonus3D(lLabelLowCase & "_cam", vector(lX, lY, lZ), lBonusModel, lActDistance, lRespawn, lZpos, lZoffset, lMove, lOrient, lOrientation, lRemove, lShadowZ, lCustomRotation, lTokenId)
        lPropList = propList()
        lPropList.addProp("modelRef", lBonusRef)
        lPropList.addProp("type", "bon")
        gResource3dList.addProp(lLabelLowCase, lPropList)
        ResourceManagerFlash.SetupNewBonus(lLabelLowCase, lNameResource, lX, lY, lZ, lBonusModel, lActDistance, lRespawn, lZpos, lZoffset, lMove, lOrient, lOrientation, lRemove, lShadowZ, lCustomRotation, lTokenId)
      "obj":
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lLabelLowCase = lWordResult[1]
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lNameResource = lWordResult[1]
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lX = float(lWordResult[1])
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lY = float(lWordResult[1])
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lZ = float(lWordResult[1])
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lModel = lWordResult[1]
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lRotation = float(lWordResult[1])
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lRemove = lWordResult[1]
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lTokenId = lWordResult[1]
        lPlacedObjectRef = CreatePlacedObject3D(lLabelLowCase, lModel, vector(lX, lY, lZ), lRotation)
        lPropList = propList()
        lPropList.addProp("modelRef", lPlacedObjectRef)
        lPropList.addProp("type", "obj")
        gResource3dList.addProp(lLabelLowCase, lPropList)
        ResourceManagerFlash.SetupNewPlacedObject(lLabelLowCase, lNameResource, lX, lY, lZ, lModel, lRotation, lRemove, lTokenId)
      "pat":
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lLabelLowCase = lWordResult[1]
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lNameResource = lWordResult[1]
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lLoop = lWordResult[1]
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lSnap = lWordResult[1]
        lPropList = propList()
        lPropList.addProp("type", "pat")
        lPropList.addProp("pathList", [:])
        gResource3dList.addProp(lLabelLowCase, lPropList)
        ResourceManagerFlash.SetupNewPath(lLabelLowCase, lNameResource, lSnap, lLoop)
        pLabel = lNameResource
      "pointPath":
        lPathId = lLabelLowCase
        lLabel = pLabel
        pPathPoint3DId = pPathPoint3DId + 1
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lTokenId = integer(lWordResult[1])
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lLongitudinalA = float(lWordResult[1])
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lLongitudinalB = float(lWordResult[1])
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lTrasversal = float(lWordResult[1])
        lPathPointRef = Create3DPathPoint("pathPoint_" & pPathPoint3DId, lTokenId, lLongitudinalA, lTrasversal)
        lPathList = gResource3dList[lPathId].pathList
        lPathList.addProp(string(pPathPoint3DId), lPathPointRef)
        ResourceManagerFlash.AddNewPathPoint(lPathId, lLabel, pPathPoint3DId, lTokenId, lLongitudinalA, lLongitudinalB, lTrasversal, lPathPointRef.transform.position.x, lPathPointRef.transform.position.y)
      "fac":
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lLabelLowCase = lWordResult[1]
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lNameResource = lWordResult[1]
        lPropList = propList()
        lPropList.addProp("type", "fac")
        lPropList.addProp("posList", [:])
        gResource3dList.addProp(lLabelLowCase, lPropList)
        ResourceManagerFlash.SetupNewFace(lLabelLowCase, lNameResource)
        pFaceLabel = lNameResource
      "facePosition":
        pPathPoint3DId = pPathPoint3DId + 1
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lX = float(lWordResult[1])
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lY = float(lWordResult[1])
        lWordResult = me.readWord(fString, lIndex + 1)
        lIndex = lWordResult[2]
        lZ = float(lWordResult[1])
        pFacePositionId = pFacePositionId + 1
        lPositionListRef = gResource3dList[pFaceLabel].posList
        lPositionListRef.addProp(string(pFacePositionId), vector(lX, lY, lZ))
        ResourceManagerFlash.SetupNewFacePosition(lLabelLowCase, pFaceLabel, pFacePositionId, lX, lY, lZ)
    end case
  end repeat
end

on readWord me, fString, fI
  li = fI
  lReturnString = EMPTY
  lReturnCode = #none
  repeat while 1
    lChar = chars(fString, li, li)
    if li > fString.length then
      lReturnCode = #endstring
    else
      if lChar = RETURN then
        lReturnCode = #newline
      else
        if lChar = " " then
          lReturnCode = #space
        end if
      end if
    end if
    if lReturnCode <> #none then
      exit repeat
    end if
    lReturnString = lReturnString & lChar
    li = li + 1
  end repeat
  return [lReturnString, li, lReturnCode]
end

on flash_SetCameraType me, fCameraType
  put "flash_SetCameraType : " & fCameraType
  fCameraType = integer(fCameraType)
  lCameraType = #Game
  case fCameraType of
    0:
      lCameraType = #Game
      gGame.GetPlayerVehicle().GetVehicleController().SetForceToBrake(0)
    1:
      lCameraType = #tool
      gGame.GetPlayerVehicle().GetVehicleController().SetForceToBrake(1)
  end case
  pToolConfigData["camsetting"].CamType = fCameraType
  gResourceToolVars.CameraType = lCameraType
end

on flash_SetCameraSubType me, fCameraSubType
  put "flash_SetCaptureType : " & fCameraSubType
  fCameraSubType = integer(fCameraSubType)
  lSubType = #top
  case fCameraSubType of
    0:
      lSubType = #top
      lZCamera = gGame.GetCamera().GetCameraNode().transform.position.z
      if lZCamera < gResourceToolVars.ZoomZCam then
        lZCamera = lZCamera + gResourceToolVars.ZoomZCam
      end if
      gGame.GetCamera().GetCameraNode().transform.position.z = lZCamera
      lPositionTarget = gGame.GetCamera().GetCameraNode().transform.position.duplicate()
      lPositionTarget.z = 0.0
      gGame.GetCamera().GetCameraNode().pointAt(lPositionTarget, vector(0.0, 1.0, 0.0))
    1:
      lSubType = #free
      pPos = gGame.GetCamera().GetCameraNode().transform.position
      pTarget = pPos + (pOldDir * 20)
      gGame.GetCamera().GetCameraNode().transform.position = pPos
      gGame.GetCamera().GetCameraNode().pointAt(pTarget, pUpVector)
  end case
  gResourceToolVars.CameraSubType = lSubType
  pToolConfigData["camsetting"].CamSubType = fCameraSubType
end

on flash_SetPositionType me, fPositionType
  put "flash_SetPositionType : " & fPositionType
  fPositionType = integer(fPositionType)
  lPositionType = #player
  case fPositionType of
    0:
      lPositionType = #player
      pResourceCursor.visibility = #none
    1:
      lPositionType = #Mouse
      pResourceCursor.visibility = #both
    2:
      lPositionType = #camera
      pResourceCursor.visibility = #none
  end case
  gResourceToolVars.PositionType = lPositionType
end

on UpdateCamera me
  me.GetKeys()
  case gResourceToolVars.CameraSubType of
    #top:
      lCameraRotation = gGame.GetCamera().GetCameraNode().transform.rotation
      lAngleRadiant = 2.0 * PI * lCameraRotation.y / 360.0
      lTransformVectorX = vector(-sin(lAngleRadiant), cos(lAngleRadiant), 0.0)
      lTransformVectorY = vector(cos(lAngleRadiant), sin(lAngleRadiant), 0.0)
      lCameraPosition = gGame.GetCamera().GetCameraNode().transform.position
      if pGoingForward then
        lCameraPosition = lCameraPosition + (pMoveStepTopCam * lTransformVectorX)
      end if
      if pGoingBackward then
        lCameraPosition = lCameraPosition - (pMoveStepTopCam * lTransformVectorX)
      end if
      if pRotatingDx then
        lCameraPosition = lCameraPosition - (pMoveStepTopCam * lTransformVectorY)
      end if
      if pRotatingSx then
        lCameraPosition = lCameraPosition + (pMoveStepTopCam * lTransformVectorY)
      end if
      gGame.GetCamera().GetCameraNode().transform.position = lCameraPosition
      lPositionTarget = lCameraPosition
      lPositionTarget.z = 0
      gGame.GetCamera().GetCameraNode().transform.position = vector(lPositionTarget.x, lPositionTarget.y, lPositionTarget.z + gResourceToolVars.ZoomZCam)
      gGame.GetCamera().GetCameraNode().pointAt(lPositionTarget)
    #free:
      lNewDir = gGame.GetCamera().GetCameraNode().transform * vector(pkeyb_dx * pFreeLookStep * p_dt, pkeyb_dy * pFreeLookStep * p_dt, -1.0)
      lNewDir = lNewDir - gGame.GetCamera().GetCameraNode().transform.position
      lNewDir.normalize()
      pPos = pPos + (lNewDir * pkeyb_zoom * pFreeMoveStep * p_dt)
      lStrafe = pUpVector.cross(lNewDir)
      lUp = lNewDir.cross(lStrafe)
      lStrafe = lStrafe * pkeyb_strafe * pFreeMoveStep * p_dt
      lUp = lUp * pkeyb_vertStrafe * pFreeMoveStep * p_dt
      pPos = pPos - lStrafe
      pPos = pPos - lUp
      pTarget = pPos + (lNewDir * 20)
      lV = pTarget - pPos
      lV = lV.cross(pUpVector)
      if lV.dot(lV) < 0.00001 then
        return 
      end if
      gGame.GetCamera().GetCameraNode().transform.position = pPos
      gGame.GetCamera().GetCameraNode().pointAt(pTarget, pUpVector)
      pOldPos = pPos
      pOldDir = pTarget - pPos
      pOldDir.normalize()
  end case
end

on GetKeys me
  if gResourceToolVars.CameraSubType = #top then
    pGoingForward = gGame.GetInputManager().IsKeyPressed(126)
    pGoingBackward = gGame.GetInputManager().IsKeyPressed(125)
    pRotatingDx = gGame.GetInputManager().IsKeyPressed(123)
    pRotatingSx = gGame.GetInputManager().IsKeyPressed(124)
    lZoomZKeypress = gGame.GetInputManager().IsKeyPressed(gResourceToolVars.KeysConfig.LessZoomZ)
    if lZoomZKeypress then
      gResourceToolVars.ZoomZCam = gResourceToolVars.ZoomZCam - pZoomStepTopCam
    end if
    lZoomZKeypress = gGame.GetInputManager().IsKeyPressed(gResourceToolVars.KeysConfig.MoreZoomZ)
    if lZoomZKeypress then
      gResourceToolVars.ZoomZCam = gResourceToolVars.ZoomZCam + pZoomStepTopCam
    end if
  end if
  if gResourceToolVars.CameraSubType = #free then
    pkeyb_zoom = 0
    pkeyb_dx = 0
    pkeyb_dy = 0
    pkeyb_strafe = 0
    pkeyb_vertStrafe = 0
    if gGame.GetInputManager().IsKeyPressed(gResourceToolVars.KeysConfig.FreeForward) then
      pkeyb_zoom = pkeyb_zoom + 1
    end if
    if gGame.GetInputManager().IsKeyPressed(gResourceToolVars.KeysConfig.FreeBackWard) then
      pkeyb_zoom = pkeyb_zoom - 1
    end if
    if gGame.GetInputManager().IsKeyPressed(gResourceToolVars.KeysConfig.FreeRight) then
      pkeyb_strafe = pkeyb_strafe + 1
    end if
    if gGame.GetInputManager().IsKeyPressed(gResourceToolVars.KeysConfig.FreeLeft) then
      pkeyb_strafe = pkeyb_strafe - 1
    end if
    if gGame.GetInputManager().IsKeyPressed(gResourceToolVars.KeysConfig.FreeUnZoom) then
      pkeyb_vertStrafe = pkeyb_vertStrafe - 1
    end if
    if gGame.GetInputManager().IsKeyPressed(gResourceToolVars.KeysConfig.FreeZoom) then
      pkeyb_vertStrafe = pkeyb_vertStrafe + 1
    end if
    if gGame.GetInputManager().IsKeyPressed(126) then
      pkeyb_dy = pkeyb_dy + 1
    end if
    if gGame.GetInputManager().IsKeyPressed(125) then
      pkeyb_dy = pkeyb_dy - 1
    end if
    if gGame.GetInputManager().IsKeyPressed(123) then
      pkeyb_dx = pkeyb_dx - 1
    end if
    if gGame.GetInputManager().IsKeyPressed(124) then
      pkeyb_dx = pkeyb_dx + 1
    end if
  end if
  if gResourceToolVars.PositionType = #Mouse then
    if keyPressed(gResourceToolVars.KeysConfig.CursorRotatingSx) or keyPressed(gResourceToolVars.KeysConfig.CursorRotatingDx) then
      lTime = gGame.GetTimeManager().GetTime()
      if ((lTime - pRotatingCursorTimer) > pSnapCursorTimer) or (pCursorSnap = -1) then
        lRotateStep = 2.5
        if pCursorSnap <> -1 then
          lRotateStep = pCursorSnap
        end if
        if keyPressed(gResourceToolVars.KeysConfig.CursorRotatingSx) then
          lRotateStep = -lRotateStep
        end if
        pResourceCursor.transform.rotation.z = GetSnappedRotation(pResourceCursor.transform.rotation.z + lRotateStep, pCursorSnap)
        pRotatingCursorTimer = lTime
      end if
    end if
    if gResourceToolVars.ActiveTool and not gResourceToolVars.FreeMouseCapture and gResourceToolVars.FocusEnabled then
      lMousePt = the mouseLoc - point(sprite("3D").left, sprite("3D").top)
      lModelList = []
      lModelList = sprite("3D").camera.modelsUnderLoc(lMousePt, 3, #detailed)
      if lModelList.count > 0 then
        repeat with li = 1 to lModelList.count
          if lModelList[li].model <> pResourceCursor then
            lPosition = lModelList[li].isectPosition
            pResourceCursor.transform.position = lPosition
            exit repeat
          end if
        end repeat
      end if
    end if
  end if
end

on GetPositionVector
  if gResourceToolVars.PositionType = #player then
    if pPositionPlayerShadow = #player then
      return gGame.GetPlayerVehicle().getPosition()
    else
      lShadow = gGame.GetPlayerVehicle().GetVehicle().GetShadow()
      if not voidp(lShadow) then
        lPosVector = gGame.GetPlayerVehicle().GetVehicle().GetShadow().GetIntersectionPosition()
      else
        lPosVector = gGame.GetPlayerVehicle().GetVehicle().GetShadowPosition()
      end if
      return lPosVector
    end if
  end if
  if gResourceToolVars.PositionType = #Mouse then
    lPosition = pResourceCursor.transform.position
    if gResourceToolVars.ZFix <> #none then
      lPosition.z = gResourceToolVars.ZFix
    else
      if gResourceToolVars.ZOffset <> #none then
        lPosition.z = lPosition.z + gResourceToolVars.ZOffset
      end if
    end if
    return lPosition
  end if
  if gResourceToolVars.PositionType = #camera then
    lPosition = gGame.GetCamera().GetCameraNode().transform.position
    return lPosition
  end if
end

on GetCurrentToken
  if gResourceToolVars.PositionType = #player then
    return gGame.GetPlayerVehicle().GetVehicle().pCurrentToken
  end if
  if gResourceToolVars.PositionType = #Mouse then
    lPosition = pResourceCursor.transform.position
    lGetToken = gGame.GetTokenManager().getToken(0, lPosition.x, lPosition.y, lPosition, vector(1.0, 0.0, 0.0), 0.0, 0.0)
    lTokenId = lGetToken[1]
    return lTokenId
  end if
end

on GetDirection fAngle
  if gResourceToolVars.PositionType = #player then
    put "DIRECTION: " & gGame.GetPlayerVehicle().GetDirection()
    if fAngle = VOID then
      return gGame.GetPlayerVehicle().GetDirection()
    end if
    lDirectionVector = vector(0.0, 1.0, 0.0)
    lAngle = lDirectionVector.angleBetween(gGame.GetPlayerVehicle().GetDirection())
    lCross = lDirectionVector.cross(gGame.GetPlayerVehicle().GetDirection())
    if lCross.z < 0.0 then
      lAngle = 360.0 - lAngle
    end if
    return lAngle
  end if
  if gResourceToolVars.PositionType = #Mouse then
    lAngle = pResourceCursor.transform.rotation.z
    if fAngle <> VOID then
      return lAngle
    end if
    lAngleRadiant = 2.0 * PI * lAngle / 360.0
    lDirection = vector(cos(lAngleRadiant), sin(lAngleRadiant), 0.0)
    lDirection.normalize()
    return lDirection
  end if
  if gResourceToolVars.PositionType = #camera then
    return vector(1.0, 0.0, 0.0)
  end if
end

on flash_SetZMouseCapture me, fZFix, fZOffset
  if fZFix <> "none" then
    gResourceToolVars.ZFix = float(fZFix)
  else
    gResourceToolVars.ZFix = #none
  end if
  if fZOffset <> "none" then
    gResourceToolVars.ZOffset = float(fZOffset)
  else
    gResourceToolVars.ZOffset = #none
  end if
end

on GetSnappedRotation fRotation, fSnap
  lRotation = fRotation
  if fSnap <> -1 then
    lSnapAngle = floor(fRotation / fSnap)
    if (fRotation - (lSnapAngle * fSnap)) > (fSnap * 0.5) then
      lSnapAngle = lSnapAngle + 1
    end if
    lRotation = lSnapAngle * fSnap
  end if
  return lRotation
end

on flash_SetCursorModel me, fModel, fType
  if gResourceToolVars.PositionType = #Mouse then
    case fType of
      "bon":
        lBonusModel = gGame.GetBonusManager().pBonusTypes[fModel].model
        if voidp(gGame.Get3D().model("cursor_" & lBonusModel.name)) then
          lModelRef = gGame.Get3D().model(lBonusModel.name).clone("cursor_" & lBonusModel.name)
          lModelRef.addToWorld()
        else
          lModelRef = gGame.Get3D().model("cursor_" & lBonusModel.name)
        end if
      "obj":
        lModelName = fModel
        if voidp(gGame.Get3D().model("cursor_" & lModelName)) then
          lModelRef = gGame.Get3D().model(lModelName).clone("cursor_" & lModelName)
          lModelRef.addToWorld()
        else
          lModelRef = gGame.Get3D().model("cursor_" & lModelName)
        end if
      "cursor":
        lModelRef = gGame.Get3D().model("resource_cursor_cam")
    end case
    pResourceCursor.visibility = #none
    lPosition = pResourceCursor.transform.position
    lRotation = pResourceCursor.transform.rotation
    pResourceCursor = lModelRef
    pResourceCursor.transform.position = lPosition
    pResourceCursor.transform.rotation = lRotation
    pResourceCursor.visibility = #both
  end if
end

on flash_SetCursorSnap me, fCursorSnap
  pCursorSnap = integer(fCursorSnap)
end

on loadText kFileName
  lNetID = getNetText(kFileName)
  repeat while not netDone(lNetID)
  end repeat
  if netError(lNetID) = "OK" then
    pText = netTextResult(lNetID)
    lNetID = VOID
    return 1
  end if
  return 0
end

on parseError kLine, kError
  put "parse error (" & kLine & "): " & kError
end

on parseConfigFile me
  pCongifFileLoaded = #Configurating
  repeat with li = 1 to pText.line.count
    lLine = pText.line[li]
    lType = lLine.word[1]
    case lType of
      "--":
      EMPTY:
      "camType:":
        lCamType = lLine.word[2]
        case lCamType of
          "0":
            gResourceToolVars.CameraType = #Game
          "1":
            gResourceToolVars.CameraType = #tool
          otherwise:
            parseError(li, "camType syntax error")
        end case
        pToolConfigData["camsetting"].CamType = integer(lCamType)
      "camSubType:":
        lCamSubType = lLine.word[2]
        case lCamSubType of
          "0":
            gResourceToolVars.CameraSubType = #top
          "1":
            gResourceToolVars.CameraSubType = #free
          otherwise:
            parseError(li, "camType syntax error")
        end case
        pToolConfigData["camsetting"].CamSubType = integer(lCamSubType)
      "camFreeLookStep:":
        pFreeLookStep = float(lLine.word[2])
        pToolConfigData["camsetting"].FreeCam.CamFreeLookStep = pFreeLookStep
      "camFreeMoveStep:":
        pFreeMoveStep = float(lLine.word[2])
        pToolConfigData["camsetting"].FreeCam.CamFreeMoveStep = pFreeMoveStep
      "topCam:":
        pMoveStepTopCam = float(lLine.word[2])
        pZoomStepTopCam = float(lLine.word[3])
        pToolConfigData["camsetting"].TopCam.MoveStepTopCam = pMoveStepTopCam
        pToolConfigData["camsetting"].TopCam.ZoomStepTopCam = pZoomStepTopCam
      "camFreeStartPos:":
        if lLine.word.count <> 4 then
          parseError(li, "syntax error")
        end if
        lX = float(lLine.word[2])
        lY = float(lLine.word[3])
        lZ = float(lLine.word[4])
        pBasePos = vector(lX, lY, lZ)
        pToolConfigData["camsetting"].FreeCam.CamFreeStartPos = pBasePos
      "camFreeStartDir:":
        if lLine.word.count <> 4 then
          parseError(li, "syntax error")
        end if
        lX = float(lLine.word[2])
        lY = float(lLine.word[3])
        lZ = float(lLine.word[4])
        pBaseDir = vector(lX, lY, lZ)
        pBaseDir.normalize()
        pToolConfigData["camsetting"].FreeCam.CamFreeStartDir = pBaseDir
      "camFov:":
        pCamFov = float(lLine.word[2])
        pToolConfigData["camsetting"].FreeCam.CamFov = pCamFov
      "camNearPlane:":
        pCamNearPlane = float(lLine.word[2])
        pToolConfigData["camsetting"].FreeCam.CamNearPlane = pCamNearPlane
      "camFarPlane:":
        pCamFarPlane = float(lLine.word[2])
        pToolConfigData["camsetting"].FreeCam.CamFarPlane = pCamFarPlane
      "objectmodel:":
        lConfSetting = []
        repeat with lj = 2 to lLine.word.count
          lConfSetting.add(lLine.word[lj])
        end repeat
        pToolConfigData["objectmodel"] = lConfSetting
      "bonustype:":
        lConfSetting = []
        repeat with lj = 2 to lLine.word.count
          lConfSetting.add(lLine.word[lj])
        end repeat
        pToolConfigData["bonustype"] = lConfSetting
      "ckl:":
        lConfSetting = pToolConfigData["ckl"]
        lConfSetting.length = lLine.word[2]
        lConfSetting.WidthIncr = lLine.word[3]
        lConfSetting.ActionFront = lLine.word[4]
        lConfSetting.ActionBack = lLine.word[5]
      "ckp:":
        lConfSetting = pToolConfigData["ckp"]
        lConfSetting.radius = lLine.word[2]
        lConfSetting.ActionIn = lLine.word[3]
        lConfSetting.ActionOut = lLine.word[4]
        lConfSetting.Active = lLine.word[5]
      "bon:":
        lConfSetting = pToolConfigData["bon"]
        lConfSetting.BonusModel = lLine.word[2]
        lConfSetting.ActDistance = lLine.word[3]
        lConfSetting.Respawn = lLine.word[4]
        lConfSetting.zPos = lLine.word[5]
        lConfSetting.ZOffset = lLine.word[6]
        lConfSetting.move = lLine.word[7]
        lConfSetting.Orient = lLine.word[8]
        lConfSetting.orientation = lLine.word[9]
        lConfSetting.Remove = lLine.word[10]
        lConfSetting.ShadowZ = lLine.word[11]
      "obj:":
        lConfSetting = pToolConfigData["obj"]
        lConfSetting.model = lLine.word[2]
        lConfSetting.Snap = lLine.word[3]
        lConfSetting.Remove = lLine.word[4]
      "pat:":
        lConfSetting = pToolConfigData["pat"]
        lConfSetting.loop = lLine.word[2]
        lConfSetting.Snap = lLine.word[3]
        lConfSetting.CheckSnap = lLine.word[4]
      "newresource:":
        lConfSetting = pToolConfigData["newresource"]
        lConfSetting.label = lLine.word[2]
        lConfSetting.AutoIncr = lLine.word[3]
        lConfSetting.PositionType = lLine.word[4]
        lConfSetting.CursorModel = lLine.word[5]
        lConfSetting.Snap = lLine.word[6]
        lConfSetting.SnapValue = lLine.word[7]
        lConfSetting.ZFix = lLine.word[8]
        lConfSetting.ZfixValue = lLine.word[9]
        lConfSetting.ZOffset = lLine.word[10]
        lConfSetting.ZoffsetValue = lLine.word[11]
      "cursor:":
        pSnapCursorTimer = float(lLine.word[2])
        pToolConfigData["cursor"].SnapCursorTimer = pSnapCursorTimer
      otherwise:
        parseError(li, "syntax error")
    end case
  end repeat
  pCongifFileLoaded = #Configured
end

on SetFlashPreferences
  lObjectModelList = pToolConfigData["objectmodel"]
  ResourceManagerFlash.SetPrefObjectModels(EMPTY)
  repeat with lj = 1 to lObjectModelList.count
    ResourceManagerFlash.SetPrefObjectModels(lObjectModelList[lj])
  end repeat
  lBonusModelList = pToolConfigData["bonustype"]
  ResourceManagerFlash.SetPrefBonusModels(EMPTY)
  repeat with lj = 1 to lBonusModelList.count
    ResourceManagerFlash.SetPrefBonusModels(lBonusModelList[lj])
  end repeat
  lConfSetting = pToolConfigData["ckl"]
  ResourceManagerFlash.SetPrefCklPanel(lConfSetting.length, lConfSetting.WidthIncr, lConfSetting.ActionFront, lConfSetting.ActionBack)
  lConfSetting = pToolConfigData["ckp"]
  ResourceManagerFlash.SetPrefCkpPanel(lConfSetting.radius, lConfSetting.ActionIn, lConfSetting.ActionOut, lConfSetting.Active)
  lConfSetting = pToolConfigData["bon"]
  ResourceManagerFlash.SetPrefBonPanel(lConfSetting.BonusModel, lConfSetting.ActDistance, lConfSetting.Respawn, lConfSetting.zPos, lConfSetting.ZOffset, lConfSetting.move, lConfSetting.Orient, lConfSetting.orientation, lConfSetting.Remove, lConfSetting.ShadowZ)
  lConfSetting = pToolConfigData["obj"]
  ResourceManagerFlash.SetPrefObjPanel(lConfSetting.model, lConfSetting.Snap, lConfSetting.Remove)
  lConfSetting = pToolConfigData["pat"]
  ResourceManagerFlash.SetPrefPatPanel(lConfSetting.loop, lConfSetting.Snap, lConfSetting.CheckSnap)
  lConfSetting = pToolConfigData["newresource"]
  ResourceManagerFlash.SetPrefNewResourcePanel(lConfSetting.label, lConfSetting.AutoIncr, lConfSetting.PositionType, lConfSetting.CursorModel, lConfSetting.Snap, lConfSetting.SnapValue, lConfSetting.ZFix, lConfSetting.ZfixValue, lConfSetting.ZOffset, lConfSetting.ZoffsetValue)
  lConfSetting = pToolConfigData["camsetting"]
  ResourceManagerFlash.SetPrefCamSetting(lConfSetting.CamType, lConfSetting.CamSubType)
end

on getPrefNewResourcePanel me, fLabel, fAutoIncr, fPositionType, fCursorModel, fSnap, fSnapValue, fZFix, fZfixValue, fZOffset, fZoffsetValue
  pToolConfigData["newresource"] = [#label: fLabel, #AutoIncr: fAutoIncr, #PositionType: fPositionType, #CursorModel: fCursorModel, #Snap: fSnap, #SnapValue: fSnapValue, #ZFix: fZFix, #ZfixValue: fZfixValue, #ZOffset: fZOffset, #ZoffsetValue: fZoffsetValue]
end

on flash_SaveFilePreferences me
  objFileio = new xtra("fileio")
  objFileio.openfile(pFileConfiguration, 0)
  delete objFileio
  objFileio.createFile(pFileConfiguration)
  objFileio.openfile(pFileConfiguration, 0)
  objFileio.writeString("-- cursor: <SnapTimer>")
  objFileio.writeString("-- <SnapTimer> (in millisecondi) detemina velocita' rotazione cursore con snap")
  objFileio.writeString(RETURN & numToChar(10))
  objFileio.writeString("cursor: " & pToolConfigData["cursor"].SnapCursorTimer)
  objFileio.writeString(RETURN & numToChar(10))
  objFileio.writeString("-- objectmodel: lista dei modelli PlacedObject" & RETURN & numToChar(10))
  objFileio.writeString("objectmodel:")
  lModelList = pToolConfigData["objectmodel"]
  repeat with li = 1 to lModelList.count
    objFileio.writeString(" ")
    objFileio.writeString(lModelList[li])
  end repeat
  objFileio.writeString(RETURN & numToChar(10))
  objFileio.writeString("-- bonustype: lista dei modelli Bonus" & RETURN & numToChar(10))
  objFileio.writeString("bonustype:")
  lModelList = pToolConfigData["bonustype"]
  repeat with li = 1 to lModelList.count
    objFileio.writeString(" ")
    objFileio.writeString(lModelList[li])
  end repeat
  objFileio.writeString(RETURN & numToChar(10))
  objFileio.writeString("-- cameras settings" & RETURN & numToChar(10))
  objFileio.writeString("-- camType: 0 #game  -  1 #tool")
  objFileio.writeString(RETURN & numToChar(10))
  objFileio.writeString("camType: 0")
  objFileio.writeString(RETURN & numToChar(10))
  objFileio.writeString("-- camSubType: 0 #top  -  1 #free")
  objFileio.writeString("camSubType: " & pToolConfigData["camsetting"].CamSubType)
  objFileio.writeString(RETURN & numToChar(10))
  objFileio.writeString("-- cam top mode: <MoveStep> <ZoomStep>")
  objFileio.writeString(RETURN & numToChar(10))
  objFileio.writeString("topCam: " & pToolConfigData["camsetting"].TopCam.MoveStepTopCam & " " & pToolConfigData["camsetting"].TopCam.ZoomStepTopCam)
  objFileio.writeString(RETURN & numToChar(10))
  objFileio.writeString("-- cam free mode")
  objFileio.writeString(RETURN & numToChar(10))
  objFileio.writeString("camFreeLookStep: " & pToolConfigData["camsetting"].FreeCam.CamFreeLookStep)
  objFileio.writeString(RETURN & numToChar(10))
  objFileio.writeString("camFreeMoveStep: " & pToolConfigData["camsetting"].FreeCam.CamFreeMoveStep)
  objFileio.writeString(RETURN & numToChar(10))
  objFileio.writeString("camFov: " & pToolConfigData["camsetting"].FreeCam.CamFov)
  objFileio.writeString(RETURN & numToChar(10))
  objFileio.writeString("camNearPlane: " & pToolConfigData["camsetting"].FreeCam.CamNearPlane)
  objFileio.writeString(RETURN & numToChar(10))
  objFileio.writeString("camFarPlane: " & pToolConfigData["camsetting"].FreeCam.CamFarPlane)
  objFileio.writeString(RETURN & numToChar(10))
  objFileio.writeString("-- camFreeStartPos: <x> <y> <z>")
  objFileio.writeString(RETURN & numToChar(10))
  lVector = pToolConfigData["camsetting"].FreeCam.CamFreeStartPos
  objFileio.writeString("CamFreeStartPos: " & lVector.x & " " & lVector.y & " " & lVector.z)
  objFileio.writeString(RETURN & numToChar(10))
  objFileio.writeString("-- camFreeStartDir: <x> <y> <z>")
  objFileio.writeString(RETURN & numToChar(10))
  lVector = pToolConfigData["camsetting"].FreeCam.CamFreeStartDir
  objFileio.writeString("camFreeStartDir: " & lVector.x & " " & lVector.y & " " & lVector.z)
  objFileio.writeString(RETURN & numToChar(10))
  lConfData = ResourceManagerFlash.configure
  lConfNewResource = lConfData["new"]
  objFileio.writeString("-- New Resource Panel: <Label> <AutoIncr> <PositionType> <CursorModel> <Snap> <SnapValue> <Zfix> <ZfixValue> <Zoffset> <ZoffsetValue>")
  objFileio.writeString(RETURN & numToChar(10))
  lLabel = lConfNewResource.label
  if (lLabel = VOID) or (lLabel = EMPTY) then
    lLabel = "none"
  end if
  lZoffsetValue = lConfNewResource.ZoffsetValue
  if lZoffsetValue = EMPTY then
    lZoffsetValue = "none"
  end if
  lZfixValue = lConfNewResource.ZfixValue
  if lZfixValue = EMPTY then
    lZfixValue = "none"
  end if
  objFileio.writeString("newresource: " & lLabel & " " & lConfNewResource.AutoIncr & " " & integer(lConfNewResource.PositionType) & " " & lConfNewResource.CursorModel & " " & lConfNewResource.Snap & " " & lConfNewResource.SnapValue & " " & lConfNewResource.ZFix & " " & lZfixValue & " " & lConfNewResource.ZOffset & " " & lZoffsetValue)
  objFileio.writeString(RETURN & numToChar(10))
  lConfPanel = lConfData["ckl"]
  objFileio.writeString("-- ckl Panel: <Length> <WidthIncr> <ActionFront> <ActionBack>")
  objFileio.writeString(RETURN & numToChar(10))
  objFileio.writeString("ckl: " & lConfPanel.length & " " & lConfPanel.WidthIncr & " " & lConfPanel.ActionFront & " " & lConfPanel.ActionBack)
  objFileio.writeString(RETURN & numToChar(10))
  lConfPanel = lConfData["ckp"]
  objFileio.writeString("-- ckp Panel: <Radius> <ActionIn> <ActionOut> <Active>")
  objFileio.writeString(RETURN & numToChar(10))
  objFileio.writeString("ckp: " & lConfPanel.radius & " " & lConfPanel.ActionIn & " " & lConfPanel.ActionOut & " " & lConfPanel.Active)
  objFileio.writeString(RETURN & numToChar(10))
  lConfPanel = lConfData["bon"]
  objFileio.writeString("-- bon Panel: <BonusModel> <ActDistance> <Respawn> <Zpos> <Zoffset> <Move> <Orient> <Orientation> <Remove> <ShadowZ>")
  objFileio.writeString(RETURN & numToChar(10))
  objFileio.writeString("bon: " & lConfPanel.BonusModel & " " & lConfPanel.ActDistance & " " & lConfPanel.Respawn & " " & lConfPanel.zPos & " " & lConfPanel.ZOffset & " " & lConfPanel.move & " " & lConfPanel.Orient & " " & lConfPanel.orientation & " " & lConfPanel.Remove & " " & lConfPanel.ShadowZ)
  objFileio.writeString(RETURN & numToChar(10))
  lConfPanel = lConfData["obj"]
  objFileio.writeString("-- ckp Panel: <Model> <Snap> <Remove>")
  objFileio.writeString(RETURN & numToChar(10))
  objFileio.writeString("obj: " & lConfPanel.model & " " & lConfPanel.Snap & " " & lConfPanel.Remove)
  objFileio.writeString(RETURN & numToChar(10))
  lConfPanel = lConfData["pat"]
  objFileio.writeString("-- pat Panel: <Loop> <Snap> <CheckSnap>")
  objFileio.writeString(RETURN & numToChar(10))
  objFileio.writeString("pat: " & lConfPanel.loop & " " & lConfPanel.Snap & " " & lConfPanel.CheckSnap)
  objFileio.writeString(RETURN & numToChar(10))
  objFileio.closeFile()
end

on flash_SetPositionPlayerShadow me, fValue
  if fValue = "0" then
    pPositionPlayerShadow = #player
  else
    pPositionPlayerShadow = #shadow
  end if
end
