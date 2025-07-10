property p3DMember, pPointList, pNumPointInPolyline, pName, pLastPointInsertionTime, pCurrentTextureU, pCurrentTextureV, pMinTimeBetweenPoint, pMinDistanceBetweenPoint, pTextureMapK, pPolyLineModelResource, pPolyLineModel, pFirstFaceToChangeCounter, pLastInvisiblePoint, pIsShown, pTailEffectEnabled, pTailCoordinate
global gTimeManager, gGame

on new me, f3DMember, fName, fLength
  p3DMember = f3DMember
  pPointList = []
  pLastInvisiblePoint = VOID
  if fLength = VOID then
    pNumPointInPolyline = 1
  else
    pNumPointInPolyline = fLength
  end if
  me.pName = fName
  pLastPointInsertionTime = 0
  pCurrentTextureU = 0
  pCurrentTextureV = 0.29999999999999999
  pTextureMapK = 1.0
  pFirstFaceToChangeCounter = 0
  pIsShown = 1
  pMinTimeBetweenPoint = VOID
  pMinDistanceBetweenPoint = VOID
  pTailEffectEnabled = 0
  pTailCoordinate = 0.29999999999999999
  return me
end

on HidePolyline me
  if pIsShown = 0 then
    return 
  end if
  pPolyLineModel.removeFromWorld()
  pIsShown = 0
end

on ShowPolyline me
  if pIsShown then
    return 
  end if
  pPolyLineModel.addToWorld()
  pIsShown = 1
end

on SetStartPoint me, fPoint
  pPointList = []
  repeat with i = 1 to pNumPointInPolyline
    pPointList.add(fPoint)
  end repeat
  if pPolyLineModel <> VOID then
    pPolyLineModel.removeFromWorld()
    p3DMember.deleteModelResource(pName)
    p3DMember.deleteModel(pName & "_model")
    pPolyLineModel = VOID
  end if
end

on SetPointList me, fPointList
  if fPointList <> VOID then
    pPointList = fPointList
    pNumPointInPolyline = fPointList.count
    if pPolyLineModel <> VOID then
      pPolyLineModel.removeFromWorld()
      p3DMember.deleteModelResource(pName)
      p3DMember.deleteModel(pName & "_model")
      pPolyLineModel = VOID
    end if
  end if
  me.SetShader(fPointList[1].shader)
end

on SetShader me, fShader
  lNumPoints = pPointList.count
  lNumFaces = lNumPoints - 1
  lTriangleIdx = 1
  repeat with li = 1 to lNumFaces
    pPolyLineModelResource.face[lTriangleIdx].shader = fShader
    pPolyLineModelResource.face[lTriangleIdx + 1].shader = fShader
    lTriangleIdx = lTriangleIdx + 2
  end repeat
end

on GetBlendValue me
  return pPolyLineModel.shaderList[1].blend
end

on SetBlendValue me, lVal
  me.ApplyBlendToModel(pPolyLineModel, lVal)
end

on UpdateTransparency me, lBlendTarget, lSpeed
  lCurrentBlend = pPolyLineModel.shaderList[1].blend
  if lSpeed = VOID then
    lSpeed = 0.10000000000000001
  end if
  lDiff = Sign(lBlendTarget - lCurrentBlend)
  lB = lCurrentBlend + (lDiff * lSpeed * gGame.GetTimeManager().GetDeltaTime())
  lBlend = Clamp(lB, 0, 100)
  me.ApplyBlendToModel(pPolyLineModel, lBlend)
end

on ApplyBlendToModel me, kMdl, kBlend
  repeat with li = 1 to kMdl.shaderList.count
    kMdl.shaderList[li].blend = kBlend
  end repeat
end

on VerifyNewPointConditions me, fNewPoint
  if pMinTimeBetweenPoint <> VOID then
    lNow = gGame.GetTimeManager().GetTime()
    if (lNow - pLastPointInsertionTime) < pMinTimeBetweenPoint then
      return 0
    end if
  end if
  if pMinDistanceBetweenPoint <> VOID then
    lPoint1 = pPointList[pPointList.count].point
    lDist = Calculate3dDistanceV(lPoint1, fNewPoint)
    if lDist < pMinDistanceBetweenPoint then
      return 0
    end if
  end if
  return 1
end

on AddInvisiblePoint me, fPoint
  pLastInvisiblePoint = fPoint
  lNewPoint = pPointList[pPointList.count].duplicate()
  me.AddPoint(lNewPoint, 1, 1)
end

on EnshortStrip me, fDeltaLen
  if GetLastPointDistance() < fDeltaLen then
    lNewPoint = pPointList[pPointList.count]
    lNewPoint.point = lNewPoint.point + vector(0.001, 0.001, 0.001)
    me.AddPoint(lNewPoint, 1)
  else
    lLastPointV = pPointList[1].point
    lDir = pPointList[2].point - lLastPointV
    lDir.normalize()
    ModifyFirstPoint(lLastPointV + (fDeltaLen * lDir))
  end if
end

on AddPoint me, fPoint, fForce, fVisibleFlag
  lSuccess = 1
  if (fForce = VOID) or (fForce = 0) then
    if fPoint.point = pPointList[pPointList.count].point then
      return 0
    end if
    if me.VerifyNewPointConditions(fPoint.point) = 0 then
      return 0
    end if
  end if
  pLastPointInsertionTime = gGame.GetTimeManager().GetTime()
  if fVisibleFlag = VOID then
    if pLastInvisiblePoint <> VOID then
      me.AddQuad(pLastInvisiblePoint, fPoint)
      pLastInvisiblePoint = VOID
      return 
    end if
  end if
  pPointList.deleteAt(1)
  pPointList.add(fPoint)
  lStartPoint = pPointList[pPointList.count - 1]
  lLastPoint = pPointList[pPointList.count]
  lStartPointNormal = lStartPoint.normal
  lStartPointTangent = lStartPoint.tangent
  lStartPointWidth = lStartPoint.width
  lEndPointNormal = lLastPoint.normal
  lEndPointTangent = lLastPoint.tangent
  lEndPointWidth = lLastPoint.width
  lStartVertexDir = lStartPointTangent.cross(lStartPointNormal)
  lStartVertexDir.normalize()
  lEndVertexDir = lEndPointTangent.cross(lEndPointNormal)
  lEndVertexDir.normalize()
  lG1 = lStartPoint.point + (lStartPointWidth * lStartVertexDir)
  lH1 = lStartPoint.point - (lStartPointWidth * lStartVertexDir)
  lG2 = lLastPoint.point + (lEndPointWidth * lEndVertexDir)
  lH2 = lLastPoint.point - (lEndPointWidth * lEndVertexDir)
  lStartIndexOfVertexToChange = (pFirstFaceToChangeCounter * 4) + 1
  pPolyLineModel.meshDeform.mesh[1].vertexList[lStartIndexOfVertexToChange] = lG1
  pPolyLineModel.meshDeform.mesh[1].vertexList[lStartIndexOfVertexToChange + 1] = lH1
  pPolyLineModel.meshDeform.mesh[1].vertexList[lStartIndexOfVertexToChange + 2] = lG2
  pPolyLineModel.meshDeform.mesh[1].vertexList[lStartIndexOfVertexToChange + 3] = lH2
  lElementLength = Calculate3dDistanceV(lStartPoint.point, lLastPoint.point)
  lNextV2 = pCurrentTextureV + (pTextureMapK * lElementLength)
  lNextV = lNextV2
  if pTailEffectEnabled then
    if lNextV2 > 0.94999999999999996 then
      lNextV = 0.94999999999999996
    end if
  end if
  lTextCoordList = [[0, pCurrentTextureV], [1, pCurrentTextureV], [0, lNextV], [1, lNextV]]
  pCurrentTextureV = lNextV
  if pCurrentTextureV >= 0.94999999999999996 then
    if pTailEffectEnabled then
      pCurrentTextureV = pTailCoordinate
    else
      pCurrentTextureV = 0
    end if
  end if
  pPolyLineModel.meshDeform.mesh[1].textureCoordinateList[lStartIndexOfVertexToChange] = lTextCoordList[1]
  pPolyLineModel.meshDeform.mesh[1].textureCoordinateList[lStartIndexOfVertexToChange + 1] = lTextCoordList[2]
  pPolyLineModel.meshDeform.mesh[1].textureCoordinateList[lStartIndexOfVertexToChange + 2] = lTextCoordList[3]
  pPolyLineModel.meshDeform.mesh[1].textureCoordinateList[lStartIndexOfVertexToChange + 3] = lTextCoordList[4]
  pFirstFaceToChangeCounter = pFirstFaceToChangeCounter + 1
  if pFirstFaceToChangeCounter >= (pNumPointInPolyline - 1) then
    pFirstFaceToChangeCounter = 0
  end if
  if pTailEffectEnabled then
    LastFaceIndex = pFirstFaceToChangeCounter
    lTailTextCoordList = [[0, 0], [1, 0], [0, 0.29999999999999999], [1, 0.29999999999999999]]
    lTailIndexOfVertexToChange = (LastFaceIndex * 4) + 1
    pPolyLineModel.meshDeform.mesh[1].textureCoordinateList[lTailIndexOfVertexToChange] = lTailTextCoordList[1]
    pPolyLineModel.meshDeform.mesh[1].textureCoordinateList[lTailIndexOfVertexToChange + 1] = lTailTextCoordList[2]
    pPolyLineModel.meshDeform.mesh[1].textureCoordinateList[lTailIndexOfVertexToChange + 2] = lTailTextCoordList[3]
    pPolyLineModel.meshDeform.mesh[1].textureCoordinateList[lTailIndexOfVertexToChange + 3] = lTailTextCoordList[4]
  end if
  return lSuccess
end

on AddQuad me, fStartPoint, fEndPoint
  lSuccess = 1
  pPointList.deleteAt(1)
  pPointList.deleteAt(2)
  pPointList.add(fStartPoint)
  pPointList.add(fEndPoint)
  lStartPoint = fStartPoint.point
  lLastPoint = fEndPoint.point
  lStartPointNormal = fStartPoint.normal
  lStartPointTangent = fStartPoint.tangent
  lStartPointWidth = fStartPoint.width
  lEndPointNormal = fEndPoint.normal
  lEndPointTangent = fEndPoint.tangent
  lEndPointWidth = fEndPoint.width
  lStartVertexDir = lStartPointTangent.cross(lStartPointNormal)
  lStartVertexDir.normalize()
  lEndVertexDir = lEndPointTangent.cross(lEndPointNormal)
  lEndVertexDir.normalize()
  lG1 = lStartPoint + (lStartPointWidth * lStartVertexDir)
  lH1 = lStartPoint - (lStartPointWidth * lStartVertexDir)
  lG2 = lLastPoint + (lEndPointWidth * lEndVertexDir)
  lH2 = lLastPoint - (lEndPointWidth * lEndVertexDir)
  lVertexList = [lG1, lH1, lG2, lH2]
  lIndexOfFirstVertexToChange = (pFirstFaceToChangeCounter * 4) + 1
  pPolyLineModel.meshDeform.mesh[1].vertexList[lIndexOfFirstVertexToChange] = lG1
  pPolyLineModel.meshDeform.mesh[1].vertexList[lIndexOfFirstVertexToChange + 1] = lH1
  pPolyLineModel.meshDeform.mesh[1].vertexList[lIndexOfFirstVertexToChange + 2] = lG2
  pPolyLineModel.meshDeform.mesh[1].vertexList[lIndexOfFirstVertexToChange + 3] = lH2
  pFirstFaceToChangeCounter = pFirstFaceToChangeCounter + 1
  if pFirstFaceToChangeCounter >= (pNumPointInPolyline - 1) then
    pFirstFaceToChangeCounter = 0
  end if
end

on ModifyLastPoint me, fNewLastPoint
  if pPointList.count < 2 then
    return 
  end if
  lStartPoint = pPointList[pPointList.count - 1]
  lLastPoint = pPointList[pPointList.count]
  lStartPointNormal = lStartPoint.normal
  lStartPointTangent = lStartPoint.tangent
  lStartPointWidth = lStartPoint.width
  lEndPointNormal = lLastPoint.normal
  lEndPointTangent = lLastPoint.tangent
  lEndPointWidth = lLastPoint.width
  lStartVertexDir = lStartPointTangent.cross(lStartPointNormal)
  lStartVertexDir.normalize()
  lEndVertexDir = lEndPointTangent.cross(lEndPointNormal)
  lEndVertexDir.normalize()
  lG1 = lStartPoint.point + (lStartPointWidth * lStartVertexDir)
  lH1 = lStartPoint.point - (lStartPointWidth * lStartVertexDir)
  lG2 = fNewLastPoint + (lEndPointWidth * lEndVertexDir)
  lH2 = fNewLastPoint - (lEndPointWidth * lEndVertexDir)
  lVertexList = [lG1, lH1, lG2, lH2]
  lFaceIndex = pFirstFaceToChangeCounter
  if pFirstFaceToChangeCounter = 0 then
    lFaceIndex = pPointList.count - 1
  end if
  lIndexOfFirstVertexToChange = ((lFaceIndex - 1) * 4) + 1
  pPolyLineModel.meshDeform.mesh[1].vertexList[lIndexOfFirstVertexToChange + 2] = lG2
  pPolyLineModel.meshDeform.mesh[1].vertexList[lIndexOfFirstVertexToChange + 3] = lH2
  pPointList[pPointList.count].point = fNewLastPoint
end

on ModifyFirstPoint me, fNewFirstPoint
  if pPointList.count < 2 then
    return 
  end if
  lStartPoint = pPointList[1]
  lLastPoint = pPointList[2]
  lStartPointNormal = lStartPoint.normal
  lStartPointTangent = lStartPoint.tangent
  lStartPointWidth = lStartPoint.width
  lEndPointNormal = lLastPoint.normal
  lEndPointTangent = lLastPoint.tangent
  lEndPointWidth = lLastPoint.width
  lStartVertexDir = lStartPointTangent.cross(lStartPointNormal)
  lStartVertexDir.normalize()
  lEndVertexDir = lEndPointTangent.cross(lEndPointNormal)
  lEndVertexDir.normalize()
  lG1 = fNewFirstPoint + (lStartPointWidth * lStartVertexDir)
  lH1 = fNewFirstPoint - (lStartPointWidth * lStartVertexDir)
  lG2 = lLastPoint + (lEndPointWidth * lEndVertexDir)
  lH2 = lLastPoint - (lEndPointWidth * lEndVertexDir)
  lVertexList = [lG1, lH1, lG2, lH2]
  lIndexOfFirstVertexToChange = (pFirstFaceToChangeCounter * 4) + 1
  pPolyLineModel.meshDeform.mesh[1].vertexList[lIndexOfFirstVertexToChange] = lG1
  pPolyLineModel.meshDeform.mesh[1].vertexList[lIndexOfFirstVertexToChange + 1] = lH1
  pPointList[1].point = fNewFirstPoint
end

on ComputeTangent me, fPoint1, fPoint2
  lDiff = fPoint2 - fPoint1
  lDiffM = lDiff.magnitude
  lTangent = lDiff / lDiffM
  return lTangent
end

on BuildStrip me, fShader
  if pPointList.count < 2 then
    return 
  end if
  lNumPoints = pPointList.count
  lNumFaces = lNumPoints - 1
  lNumTriangles = lNumFaces * 2
  lNumNormals = lNumFaces
  lNumVertices = lNumFaces * 4
  lNumTexCoordinates = lNumVertices
  pPolyLineModelResource = p3DMember.newMesh(pName, lNumTriangles, lNumVertices, lNumNormals, 0, lNumTexCoordinates)
  lPolylineVertexList = []
  lPolylineTextureCoordList = []
  repeat with i = 1 to lNumFaces
    lStartPoint = pPointList[i].point
    lStartPointTangent = pPointList[i].tangent
    lStartPointWidth = pPointList[i].width
    lEndPoint = pPointList[i + 1].point
    lEndPointTangent = pPointList[i + 1].tangent
    lEndPointWidth = pPointList[i].width
    lNormalStartPoint = pPointList[i].normal
    lNormalEndPoint = pPointList[i + 1].normal
    lPolylineFaceList = me.GetStripVertexTextureBuffers(lStartPoint, lStartPointTangent, lNormalStartPoint, lStartPointWidth, lEndPoint, lEndPointTangent, lNormalEndPoint, lEndPointWidth, pPointList[i].shader)
    repeat with li = 1 to lPolylineFaceList.vertexList.count
      lPolylineVertexList.add(lPolylineFaceList.vertexList[li])
    end repeat
    repeat with li = 1 to lPolylineFaceList.TextCoordList.count
      lPolylineTextureCoordList.add(lPolylineFaceList.TextCoordList[li])
    end repeat
  end repeat
  pPolyLineModelResource.vertexList = lPolylineVertexList
  pPolyLineModelResource.textureCoordinateList = lPolylineTextureCoordList
  lTriangleIdx = 1
  repeat with li = 1 to lNumFaces
    lShifter = 4 * (li - 1)
    lDebug = pPolyLineModelResource.face[lTriangleIdx].vertices
    pPolyLineModelResource.face[lTriangleIdx].vertices = [lShifter + 1, lShifter + 3, lShifter + 4]
    pPolyLineModelResource.face[lTriangleIdx + 1].vertices = [lShifter + 1, lShifter + 4, lShifter + 2]
    pPolyLineModelResource.face[lTriangleIdx].textureCoordinates = [lShifter + 1, lShifter + 2, lShifter + 3]
    pPolyLineModelResource.face[lTriangleIdx + 1].textureCoordinates = [lShifter + 1, lShifter + 3, lShifter + 4]
    pPolyLineModelResource.face[lTriangleIdx].shader = fShader
    pPolyLineModelResource.face[lTriangleIdx + 1].shader = fShader
    lTriangleIdx = lTriangleIdx + 2
  end repeat
  pPolyLineModelResource.build()
  pPolyLineModel = p3DMember.newModel(pName & "_model", p3DMember.modelResource(pName))
  pPolyLineModel.visibility = #both
  pPolyLineModel.addModifier(#meshDeform)
end

on GetStripVertexTextureBuffers me, fStartPoint, fTangent1, fNormal1, fStartWidth, fEndPoint, fTangent2, fNormal2, fEndWidth, fShader
  lStartVertexDir = fTangent1.cross(fNormal1)
  lStartVertexDir.normalize()
  lEndVertexDir = fTangent2.cross(fNormal2)
  lEndVertexDir.normalize()
  lG1 = fStartPoint + (fStartWidth * lStartVertexDir)
  lH1 = fStartPoint - (fStartWidth * lStartVertexDir)
  lG2 = fEndPoint + (fEndWidth * lEndVertexDir)
  lH2 = fEndPoint - (fEndWidth * lEndVertexDir)
  lVertexList = [lG1, lH1, lG2, lH2]
  lElementLength = Calculate3dDistanceV(fStartPoint, fEndPoint)
  lNextV2 = pCurrentTextureV + (pTextureMapK * lElementLength)
  lNextV = lNextV2
  if lNextV2 > 1 then
    lNextV = 1
  end if
  lTextCoordList = [[0, pCurrentTextureV], [0, lNextV], [1, lNextV], [1, pCurrentTextureV]]
  pCurrentTextureV = lNextV
  if pCurrentTextureV >= 0.94999999999999996 then
    if pTailEffectEnabled then
      pCurrentTextureV = pTailCoordinate
    else
      pCurrentTextureV = 0
    end if
  end if
  return [#vertexList: lVertexList, #TextCoordList: lTextCoordList]
end

on SetLength me, fLength
  pNumPointInPolyline = fLength
end

on getLength me
  return pNumPointInPolyline
end

on GetTextureMapK me
  return pTextureMapK
end

on SetTextureMapK me, fK
  pTextureMapK = fK
end

on SetMinTimeBetweenPoint me, fTimeMs
  pMinTimeBetweenPoint = fTimeMs
end

on GetMinTimeBetweenPoint me
  return pMinTimeBetweenPoint
end

on SetMinDistanceBetweenPoint me, fMinDistance
  pMinDistanceBetweenPoint = fMinDistance
end

on GetMinDistanceBetweenPoint me
  return pMinDistanceBetweenPoint
end

on GetLastPoint me
  return pPointList[pPointList.count]
end

on GetFirstPoint me
  return pPointList[1]
end

on GetPoint me, fIndex
  return pPointList[fIndex]
end

on GetLastPointDistance me
  lPoint1 = pPointList[pPointList.count - 1].point
  lPoint2 = pPointList[pPointList.count].point
  return = Calculate3dDistance(lPoint1.x, lPoint1.y, lPoint1.z, lPoint2.x, lPoint2.y, lPoint2.z)
end
