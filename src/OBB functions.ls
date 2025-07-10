on CreateOBBPack kPoint3D, kAngle, kWidth, kHeight
  lC = vector(kPoint3D.x, kPoint3D.y, 0.0)
  lXAxis = vector(cos(kAngle), sin(kAngle), 0.0)
  lYAxis = vector(-lXAxis.y, lXAxis.x, 0.0)
  lE1 = kWidth * 0.5
  lE2 = kHeight * 0.5
  lPoints = [-(lXAxis * lE1) - (lYAxis * lE2), (lXAxis * lE1) - (lYAxis * lE2), (lXAxis * lE1) + (lYAxis * lE2), -(lXAxis * lE1) + (lYAxis * lE2)]
  return [#c: lC, #u: [lXAxis, lYAxis], #e: [lE1, lE2], #points: lPoints]
end

on SAT kAxis, kPoints, kMaxDist
  lMin = 10000000.0
  lMax = -10000000.0
  lMinPtIdx = -1
  lMaxPtIdx = -1
  repeat with li = 1 to kPoints.count
    lDist = kPoints[li].dot(kAxis)
    if lDist < lMin then
      lMin = lDist
      lMinPtIdx = li
    end if
    if lDist > lMax then
      lMax = lDist
      lMaxPtIdx = li
    end if
  end repeat
  lD0 = -kMaxDist - lMax
  lD1 = -kMaxDist + lMin
  if (lD0 > 0.0) or (lD1 > 0.0) then
    return [0, 0.0, 0.0]
  else
    if lD0 > lD1 then
      lSign = -1.0
      lDepth = -lD0
      lPtIdx = lMaxPtIdx
    else
      lSign = 1.0
      lDepth = -lD1
      lPtIdx = lMinPtIdx
    end if
    return [1, lDepth, lSign, lPtIdx]
  end if
end

on OBBOBBTest kOBBPack1, kOBBPack2
  lNormal = #none
  lDepth = 10000000.0
  lCollPt = [#none, #none]
  lC = kOBBPack2.c - kOBBPack1.c
  lPoints = [lC + kOBBPack2.points[1], lC + kOBBPack2.points[2], lC + kOBBPack2.points[3], lC + kOBBPack2.points[4]]
  lRet = SAT(kOBBPack1.u[1], lPoints, kOBBPack1.e[1])
  if not lRet[1] then
    return [0, lNormal, lDepth]
  end if
  if lRet[2] < lDepth then
    lDepth = lRet[2]
    lNormal = kOBBPack1.u[1] * lRet[3]
    lCollPt[2] = kOBBPack2.points[lRet[4]]
    lCollPt[1] = lCollPt[2] + (lNormal * lDepth) + lC
  end if
  lRet = SAT(kOBBPack1.u[2], lPoints, kOBBPack1.e[2])
  if not lRet[1] then
    return [0, lNormal, lDepth]
  end if
  if lRet[2] < lDepth then
    lDepth = lRet[2]
    lNormal = kOBBPack1.u[2] * lRet[3]
    lCollPt[2] = kOBBPack2.points[lRet[4]]
    lCollPt[1] = lCollPt[2] + (lNormal * lDepth) + lC
  end if
  lC = kOBBPack1.c - kOBBPack2.c
  lPoints = [lC + kOBBPack1.points[1], lC + kOBBPack1.points[2], lC + kOBBPack1.points[3], lC + kOBBPack1.points[4]]
  lRet = SAT(kOBBPack2.u[1], lPoints, kOBBPack2.e[1])
  if not lRet[1] then
    return [0, lNormal, lDepth]
  end if
  if lRet[2] < lDepth then
    lDepth = lRet[2]
    lNormal = -kOBBPack2.u[1] * lRet[3]
    lCollPt[1] = kOBBPack1.points[lRet[4]]
    lCollPt[2] = lCollPt[1] - (lNormal * lDepth) + lC
  end if
  lRet = SAT(kOBBPack2.u[2], lPoints, kOBBPack2.e[2])
  if not lRet[1] then
    return [0, lNormal, lDepth]
  end if
  if lRet[2] < lDepth then
    lDepth = lRet[2]
    lNormal = -kOBBPack2.u[2] * lRet[3]
    lCollPt[1] = kOBBPack1.points[lRet[4]]
    lCollPt[2] = lCollPt[1] - (lNormal * lDepth) + lC
  end if
  return [1, lNormal, lDepth, lCollPt]
end
