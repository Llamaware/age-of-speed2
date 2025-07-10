property p3DMember, pPointList, pPolyLineModelsList, pFaceIndex

on new me, f3DMember
  p3DMember = f3DMember
  pPointList = []
  pPolyLineModelsList = []
  pFaceIndex = 0
  return me
end

on SetPointList me, fPointList
  if not voidp(fPointList) then
    pPointList = fPointList
  end if
end

on InsertPoint me, fPoint
  pPointList.add(fPoint)
  if fPoint.findPos(#tangent) = VOID then
    lTangent = me.ComputeTangent(pPointList[pPointList.count - 1].point, pPointList[pPointList.count].point)
    pPointList[pPointList.count].addProp(#tangent, lTangent)
  end if
  lPolylinePoint = pPointList[pPointList.count - 1]
  lStartPoint = lPolylinePoint.point
  lStartPointTangent = lPolylinePoint.tangent
  lStartPointWidth = lPolylinePoint.width
  lPolylinePoint = pPointList[pPointList.count]
  lEndPoint = lPolylinePoint.point
  lEndPointTangent = lPolylinePoint.tangent
  lEndPointWidth = lPolylinePoint.width
  lNormal = pPointList[pPointList.count].normal
  lPolylineFace = me.BuildStripElement(lStartPoint, lStartPointTangent, lStartPointWidth, lEndPoint, lEndPointTangent, lEndPointWidth, lNormal, fPoint.shader)
  me.pPolyLineModelsList.add(lPolylineFace)
end

on AddPoint me, fPoint
  if fPoint.point = pPointList[pPointList.count].point then
    return 
  end if
  p3DMember.model(pPolyLineModelsList[1].name).removeFromWorld()
  pPolyLineModelsList.deleteAt(1)
  me.InsertPoint(fPoint)
end

on Destroy me
  repeat with li = pPolyLineModelsList.count down to 1
    p3DMember.model(pPolyLineModelsList[li].name).removeFromWorld()
    pPolyLineModelsList.deleteAt(li)
  end repeat
  pPointList = []
end

on ComputeTangent me, fPoint1, fPoint2
  lDiff = fPoint2 - fPoint1
  lDiffM = lDiff.magnitude
  lTangent = lDiff / lDiffM
  return lTangent
end

on BuildStrip me
  repeat with i = 1 to pPointList.count
    if i = 1 then
      lTangent = me.ComputeTangent(me.pPointList[1].point, me.pPointList[2].point)
      pPointList[i].addProp(#tangent, lTangent)
      next repeat
    end if
    if i = pPointList.count then
      lTangent = me.ComputeTangent(pPointList[pPointList.count - 1].point, pPointList[pPointList.count].point)
      pPointList[i].addProp(#tangent, lTangent)
      next repeat
    end if
    lTangent = me.ComputeTangent(pPointList[i - 1].point, pPointList[i + 1].point)
    pPointList[i].addProp(#tangent, lTangent)
  end repeat
  repeat with i = 1 to pPointList.count - 1
    lStartPoint = pPointList[i].point
    lStartPointTangent = pPointList[i].tangent
    lStartPointWidth = pPointList[i].width
    lEndPoint = pPointList[i + 1].point
    lEndPointTangent = pPointList[i + 1].tangent
    lEndPointWidth = pPointList[i].width
    lNormal = pPointList[i].normal
    lPolylineFace = me.BuildStripElement(lStartPoint, lStartPointTangent, lStartPointWidth, lEndPoint, lEndPointTangent, lEndPointWidth, lNormal, pPointList[i].shader)
    me.pPolyLineModelsList.add(lPolylineFace)
  end repeat
end

on BuildStripElement me, fStartPoint, fTangent1, fStartWidth, fEndPoint, fTangent2, fEndWidth, fNormal, fShader
  lStartVertexDir = fTangent1.cross(fNormal)
  lStartVertexDir.normalize()
  lEndVertexDir = fTangent2.cross(fNormal)
  lEndVertexDir.normalize()
  lG1 = fStartPoint + (fStartWidth * lStartVertexDir)
  lH1 = fStartPoint - (fStartWidth * lStartVertexDir)
  lG2 = fEndPoint + (fEndWidth * lEndVertexDir)
  lH2 = fEndPoint - (fEndWidth * lEndVertexDir)
  lVertexList = [lG1, lH1, lG2, lH2]
  lTextCoordList = [[0, 0], [0, 1], [1, 1], [1, 0]]
  lFaceName = "pName_" & "polyline_" & pFaceIndex
  pFaceIndex = pFaceIndex + 1
  lFaceMesh = p3DMember.newMesh(lFaceName, 2, 4, 0, 0, 4)
  lFaceMesh.vertexList = lVertexList
  lFaceMesh.textureCoordinateList = lTextCoordList
  lFaceMesh.face[1].vertices = [1, 3, 4]
  lFaceMesh.face[2].vertices = [1, 4, 2]
  lFaceMesh.face[1].textureCoordinates = [1, 2, 3]
  lFaceMesh.face[2].textureCoordinates = [1, 3, 4]
  lFaceMesh.face[1].shader = fShader
  lFaceMesh.face[2].shader = fShader
  lFaceMesh.generateNormals(#smooth)
  lFaceMesh.build()
  lElementName = lFaceName & "_model"
  lPolyLineModel = p3DMember.newModel(lElementName, p3DMember.modelResource(lFaceName))
  lPolyLineModel.visibility = #both
  return [#name: lElementName, #model: p3DMember.model(lElementName)]
end
