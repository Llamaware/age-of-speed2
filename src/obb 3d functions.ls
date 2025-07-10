on CreateOBB3d kTransform, kHalfSize, kOffset
  lX = vector(kTransform[1], kTransform[2], kTransform[3])
  lY = vector(kTransform[5], kTransform[6], kTransform[7])
  lZ = vector(kTransform[9], kTransform[10], kTransform[11])
  lPos = vector(kTransform[13], kTransform[14], kTransform[15])
  return [#Axes: [lX, lY, lZ], #HalfSize: kHalfSize, #center: lPos + kOffset]
end

on ProjectOBB3d kOBBPack, kAxis
  lOBBAxes = kOBBPack.Axes
  lV = vector(abs(lOBBAxes[1].dot(kAxis)), abs(lOBBAxes[2].dot(kAxis)), abs(lOBBAxes[3].dot(kAxis)))
  lA = kOBBPack.center.dot(kAxis)
  lB = lV.dot(kOBBPack.HalfSize)
  return [#min: lA - lB, #max: lA + lB]
end

on GetSupportPointsOBB3d kOBB, kAxis
  lFaceThreshold = 0.99990000000000001
  lEdgeThreshold = 0.0026
  lOBBCenter = kOBB.center
  lOBBAxes = kOBB.Axes
  lOBBHalfSize = kOBB.HalfSize
  lVertices = [vector(1, 1, 1), vector(1, 1, -1), vector(-1, 1, -1), vector(-1, 1, 1), vector(1, -1, 1), vector(1, -1, -1), vector(-1, -1, -1), vector(-1, -1, 1)]
  lFaces = [[[2, 1, 5, 6], [4, 3, 7, 8]], [[4, 1, 2, 3], [5, 8, 7, 6]], [[1, 4, 8, 5], [3, 2, 6, 7]]]
  lProjs = []
  lAxisIdx = 1
  repeat with lAxis in lOBBAxes
    lProj = lAxis.dot(kAxis)
    if abs(lProj) > lFaceThreshold then
      if lProj < 0.0 then
        lSign = 2
      else
        lSign = 1
      end if
      lFace = lFaces[lAxisIdx][lSign]
      lWorldVertices = []
      repeat with lVtxIdx in lFace
        lV = lVertices[lVtxIdx]
        lV = lOBBCenter + (lV.x * lOBBHalfSize.x * lOBBAxes[1]) + (lV.y * lOBBHalfSize.y * lOBBAxes[2]) + (lV.z * lOBBHalfSize.z * lOBBAxes[3])
        lWorldVertices.append(lV)
      end repeat
      return [#face, lWorldVertices]
    end if
    lAxisIdx = lAxisIdx + 1
    lProjs.append(lProj)
  end repeat
  lProjIdx = 1
  repeat with lProj in lProjs
    if abs(lProj) < lEdgeThreshold then
      lIdx1 = (lProjIdx mod 3) + 1
      lIdx2 = ((lProjIdx + 1) mod 3) + 1
      lOrthoAxis1 = lOBBAxes[lIdx1]
      lOrthoAxis2 = lOBBAxes[lIdx2]
      lOrthoProj1 = lProjs[lIdx1]
      lOrthoProj2 = lProjs[lIdx2]
      lC = lOBBCenter + (Sign(lOrthoProj1) * lOBBHalfSize[lIdx1] * lOrthoAxis1) + (Sign(lOrthoProj2) * lOBBHalfSize[lIdx2] * lOrthoAxis2)
      lWorldVertices = [lC - (lOBBAxes[lProjIdx] * lOBBHalfSize[lProjIdx]), lC + (lOBBAxes[lProjIdx] * lOBBHalfSize[lProjIdx])]
      return [#Edge, lWorldVertices]
    end if
    lProjIdx = lProjIdx + 1
  end repeat
  lWorldVertex = [lOBBCenter + (Sign(lProjs[1]) * lOBBHalfSize[1] * lOBBAxes[1]) + (Sign(lProjs[2]) * lOBBHalfSize[2] * lOBBAxes[2]) + (Sign(lProjs[3]) * lOBBHalfSize[3] * lOBBAxes[3])]
  return [#vertex, lWorldVertex]
end

on SphereOBB3dInt kOBB, kSpherePos, kSphereRad
  lHalfSize = kOBB.HalfSize
  lAxes = kOBB.Axes
  lV = kSpherePos - kOBB.center
  lProj = vector(lV.dot(lAxes[1]), lV.dot(lAxes[2]), lV.dot(lAxes[3]))
  lAbsProj = vector(abs(lProj.x), abs(lProj.y), abs(lProj.z))
  lDepths = vector(kSphereRad + lHalfSize.x - lAbsProj.x, kSphereRad + lHalfSize.y - lAbsProj.y, kSphereRad + lHalfSize.z - lAbsProj.z)
  lFace = [0, 0, 0]
  repeat with li = 1 to 3
    if lDepths[li] < 0.0 then
      return [0, VOID, VOID, []]
    end if
    if (lProj[li] < 0.0) and (lProj[li] < -lHalfSize[li]) then
      lFace[li] = -1
      next repeat
    end if
    if (lProj[li] >= 0.0) and (lProj[li] > lHalfSize[li]) then
      lFace[li] = 1
    end if
  end repeat
  lSum = abs(lFace[1]) + abs(lFace[2]) + abs(lFace[3])
  case lSum of
    0:
      lMinDepth = 1
      repeat with li = 2 to 3
        if lDepths[li] < lDepths[lMinDepth] then
          lMinDepth = li
        end if
      end repeat
      lNormal = kOBB.Axes[lMinDepth] * Sign(lProj[lMinDepth])
      lDepth = lDepths[lMinDepth]
    1, 2, 3:
      repeat with li = 1 to 3
        if lFace[li] <> 0 then
          lNormal = lNormal + (kOBB.Axes[li] * (lAbsProj[li] - lHalfSize[li]) * lFace[li])
        end if
      end repeat
      lNormalMag = lNormal.magnitude
      if lNormalMag > kSphereRad then
        return [0, VOID, VOID, []]
      end if
      lDepth = kSphereRad - lNormalMag
  end case
  lNormal.normalize()
  if lNormal.dot(lV) < 0.0 then
    lNormal = lNormal * -1.0
  end if
  lSpherePt = kSpherePos - (lNormal * kSphereRad)
  lOBBPt = kSpherePos - (lNormal * (kSphereRad - lDepth))
  return [1, lNormal, lDepth, [[lOBBPt], [lSpherePt]]]
end

on OBBOBB3dSAT kOBB1, kOBB2
  lOBBAxes1 = kOBB1.Axes
  lOBBAxes2 = kOBB2.Axes
  lSATAxes = [lOBBAxes1[1], lOBBAxes1[2], lOBBAxes1[3], lOBBAxes2[1], lOBBAxes2[2], lOBBAxes2[3], lOBBAxes1[1].cross(lOBBAxes2[1]), lOBBAxes1[1].cross(lOBBAxes2[2]), lOBBAxes1[1].cross(lOBBAxes2[3]), lOBBAxes1[2].cross(lOBBAxes2[1]), lOBBAxes1[2].cross(lOBBAxes2[2]), lOBBAxes1[2].cross(lOBBAxes2[3]), lOBBAxes1[3].cross(lOBBAxes2[1]), lOBBAxes1[3].cross(lOBBAxes2[2]), lOBBAxes1[3].cross(lOBBAxes2[3])]
  lMinDepth = 10000000.0
  lMinAxis = VOID
  repeat with lAxis in lSATAxes
    lProj1 = ProjectOBB3d(kOBB1, lAxis)
    lProj2 = ProjectOBB3d(kOBB2, lAxis)
    if (lProj1.min > lProj2.max) or (lProj2.min > lProj1.max) then
      return [0, VOID, VOID]
    end if
    lAxisMag = lAxis.magnitude
    if lAxisMag > 0.0 then
      lInvAxisMag = 1.0 / lAxisMag
      if ((lProj1.max - lProj2.max) * (lProj1.min - lProj2.min)) >= 0.0 then
        lD = min(lProj1.max, lProj2.max) - max(lProj1.min, lProj2.min)
      else
        lD = min(abs(lProj1.max - lProj2.min), abs(lProj2.max - lProj1.min))
      end if
      lD = lD * lInvAxisMag
      if lD < lMinDepth then
        lMinDepth = lD
        lMinAxis = lAxis * lInvAxisMag
      end if
      next repeat
    end if
  end repeat
  return [1, lMinDepth, lMinAxis]
end

on OBBOBB3dInt kOBB1, kOBB2, kIntType
  lSATData = OBBOBB3dSAT(kOBB1, kOBB2)
  if not lSATData[1] then
    return [0, VOID, VOID, [[], []]]
  end if
  if voidp(kIntType) or (kIntType = #normal) then
    return [1, VOID, VOID, [[], []]]
  end if
  lDepth = lSATData[2]
  lAxis = lSATData[3]
  lNormal = lAxis.duplicate()
  lNormal.normalize()
  lC = kOBB2.center - kOBB1.center
  if lC.dot(lNormal) > 0.0 then
    lNormal = lNormal * -1.0
  end if
  lPtsA = GetSupportPointsOBB3d(kOBB1, -lNormal)
  lPtsB = GetSupportPointsOBB3d(kOBB2, lNormal)
  case lPtsA[1] of
    #face:
      case lPtsB[1] of
        #face, #Edge:
          lCollPts = PolyPolyContact(lPtsA[2], lPtsB[2])
          lCollPtsA = lCollPts[1]
          lCollPtsB = lCollPts[2]
        #vertex:
          lCollPtsB = lPtsB[2]
          lCollPtsA = lCollPtsB - (lNormal * lDepth)
      end case
    #Edge:
      lEdge = lPtsA[2]
      case lPtsB[1] of
        #face:
          lCollPts = PolyPolyContact(lPtsB[2], lPtsA[2])
          lCollPtsB = lCollPts[1]
          lCollPtsA = lCollPts[2]
        #Edge:
          lCollPts = EdgeEdgeContact(lPtsA[2], lPtsB[2])
          lCollPtsA = lCollPts[1]
          lCollPtsB = lCollPts[2]
        #vertex:
          lCollPtsB = lPtsB[2]
          lCollPtsA = [PointEdgeContact(lCollPtsB[1], lPtsA[2])]
      end case
    #vertex:
      case lPtsB[1] of
        #face:
          lCollPtsA = lPtsA[2]
          lCollPtsB = lCollPtsA + (lNormal * lDepth)
        #Edge:
          lCollPtsA = lPtsA[2]
          lCollPtsB = [PointEdgeContact(lCollPtsA[1], lPtsB[2])]
        #vertex:
          lCollPtsA = lPtsA[2]
          lCollPtsB = lPtsB[2]
      end case
  end case
  return [1, lNormal, lDepth, [lCollPtsA, lCollPtsB]]
end

on PointEdgeContact kPt, kEdge
  lV = kPt - kEdge[1]
  lD = kEdge[2] - kEdge[1]
  lRatio = lV.dot(lD) / lD.dot(lD)
  lRatio = Clamp(lRatio, 0.0, 1.0)
  return kEdge[1] + (lRatio * lD)
end

on EdgeEdgeContact kEdge1, kEdge2
  lDA = kEdge1[2] - kEdge1[1]
  lDB = kEdge2[2] - kEdge2[1]
  lN = lDA.cross(lDB)
  lN = lN.cross(lDB)
  lDist = lN.dot(kEdge2[1])
  lRatio = (lDist - lN.dot(kEdge1[1])) / lDA.dot(lN)
  lRatio = Clamp(lRatio, 0.0, 1.0)
  lCollPtA = kEdge1[1] + (lDA * lRatio)
  return [[lCollPtA], [PointEdgeContact(lCollPtA, kEdge2)]]
end

on ClipPolyOnPlane kPoly, kPlaneNormal, kPlaneDist
  assert(kPoly.count >= 2, "Bad poly")
  lInOutFlags = []
  lDists = []
  lAllIn = 1
  lAllOut = 1
  repeat with lPt in kPoly
    lDist = kPlaneNormal.dot(lPt) + kPlaneDist
    lIn = lDist < 0.0
    if not lIn then
      lAllIn = 0
    else
      lAllOut = 0
    end if
    lInOutFlags.append(lIn)
    lDists.append(lDist)
  end repeat
  if lAllIn then
    return kPoly.duplicate()
  end if
  if lAllOut then
    return []
  end if
  lNewShape = []
  repeat with lPtIdx = 1 to kPoly.count
    lNextPtIdx = (lPtIdx mod kPoly.count) + 1
    lPt = kPoly[lPtIdx]
    if lInOutFlags[lPtIdx] then
      lNewShape.append(lPt)
      if not lInOutFlags[lNextPtIdx] then
        lNextPt = kPoly[lNextPtIdx]
        lRatio = lDists[lPtIdx] / (lDists[lPtIdx] - lDists[lNextPtIdx])
        lNewShape.append(lPt + ((lNextPt - lPt) * lRatio))
      end if
      next repeat
    end if
    if lInOutFlags[lNextPtIdx] then
      lNextPt = kPoly[lNextPtIdx]
      lRatio = -lDists[lPtIdx] / (lDists[lNextPtIdx] - lDists[lPtIdx])
      lNewShape.append(lPt + ((lNextPt - lPt) * lRatio))
    end if
  end repeat
  return lNewShape
end

on ClipPolyOnPoly kClipPoly, kPoly, kClipPolyNormal
  assert(kClipPoly.count >= 3, "Bad clip poly")
  lNewPoly = kPoly.duplicate()
  repeat with lPtIdx = 1 to kClipPoly.count
    lNextPtIdx = (lPtIdx mod kClipPoly.count) + 1
    lPt = kClipPoly[lPtIdx]
    lNextPt = kClipPoly[lNextPtIdx]
    lPlaneNormal = (lNextPt - lPt).cross(kClipPolyNormal)
    lPlaneNormal.normalize()
    lPlaneDist = -lPlaneNormal.dot(lPt)
    lNewPoly = ClipPolyOnPlane(lNewPoly, lPlaneNormal, lPlaneDist)
    if lNewPoly.count = 0 then
      exit repeat
    end if
  end repeat
  return lNewPoly
end

on PolyPolyContact kPoly1, kPoly2
  lClipPolyNormal = (kPoly1[2] - kPoly1[1]).cross(kPoly1[3] - kPoly1[1])
  lClipPolyNormal.normalize()
  lClipPolyDist = -kPoly1[1].dot(lClipPolyNormal)
  lNewPolyB = ClipPolyOnPoly(kPoly1, kPoly2, lClipPolyNormal)
  lNewPolyA = []
  repeat with lPt in lNewPolyB
    lDist = lPt.dot(lClipPolyNormal) + lClipPolyDist
    lNewPolyA.append(lPt - (lClipPolyNormal * lDist))
  end repeat
  return [lNewPolyA, lNewPolyB]
end
