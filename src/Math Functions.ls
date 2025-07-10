on Ceil x
  return bitOr(x, 0) + (x > 0)
end

on floor x
  return bitOr(x, 0) - (x < 0)
end

on Clamp fValue, fMin, fMax
  if fValue >= fMax then
    fValue = fMax
  end if
  if fValue <= fMin then
    fValue = fMin
  end if
  return fValue
end

on Module kNum
  if kNum < 0 then
    return -kNum
  end if
  return kNum
end

on IsNaN Kx
  INF = power(999, 999)
  if Kx >= -INF then
    return 0
  end if
  return -Kx < -INF
end

on FtoA f, w
  fp = the floatPrecision
  set the floatPrecision to w
  intg = Trunc(f)
  decm = Fract(f)
  if length(decm) < w then
    decm = padout(decm, 0, w, #right)
  end if
  return intg & "." & decm
end

on Trunc f
  ID = the itemDelimiter
  the itemDelimiter = "."
  intg = item 1 of string(f)
  the itemDelimiter = ID
  return value(intg)
end

on Fract f
  ID = the itemDelimiter
  the itemDelimiter = "."
  decm = item 2 of string(f)
  the itemDelimiter = ID
  return value(decm)
end

on Calculate2dSquaredDistance fX1, fY1, fX2, fY2
  return ((fX1 - fX2) * (fX1 - fX2)) + ((fY1 - fY2) * (fY1 - fY2))
end

on Calculate2dSquaredDistanceV fV1, fV2
  return Calculate2dSquaredDistance(fV1.x, fV1.y, fV2.x, fV2.y)
end

on Calculate3dSquaredDistance fX1, fY1, fZ1, fX2, fY2, fZ2
  return ((fX1 - fX2) * (fX1 - fX2)) + ((fY1 - fY2) * (fY1 - fY2)) + ((fZ1 - fZ2) * (fZ1 - fZ2))
end

on Calculate3dSquaredDistanceV fV1, fV2
  return ((fV1.x - fV2.x) * (fV1.x - fV2.x)) + ((fV1.y - fV2.y) * (fV1.y - fV2.y)) + ((fV1.z - fV2.z) * (fV1.z - fV2.z))
end

on Calculate2dDistance fX1, fY1, fX2, fY2
  return sqrt(Calculate2dSquaredDistance(fX1, fY1, fX2, fY2))
end

on Calculate3dDistance fX1, fY1, fZ1, fX2, fY2, fZ2
  return sqrt(Calculate3dSquaredDistance(fX1, fY1, fZ1, fX2, fY2, fZ2))
end

on Calculate3dDistanceV fV1, fV2
  return sqrt(Calculate3dSquaredDistanceV(fV1, fV2))
end

on GetOrientedAngle fV1, fV2
  lAngleBtw = fV1.angleBetween(fV2)
  if fV1.crossProduct(fV2).z >= 0.0 then
    return -lAngleBtw
  end if
  return lAngleBtw
end

on BoxOverlapsSphere kMax, kMin, fRadius, kCenter, dimensions
  s = 0
  d = 0
  repeat with i = 1 to dimensions
    if kCenter[i] < kMin[i] then
      s = kCenter[i] - kMin[i]
      d = d + (s * s)
      next repeat
    end if
    if kCenter[i] > kMax[i] then
      s = kCenter[i] - kMax[i]
      d = d + (s * s)
    end if
  end repeat
  if d <= (fRadius * fRadius) then
    return 1
  end if
  return 0
end

on TestCheckLine p_CheckLine, p_Position
  l_Result = (p_Position.x * p_CheckLine.PlaneNormal.x) + (p_Position.y * p_CheckLine.PlaneNormal.y) + (p_Position.z * p_CheckLine.PlaneNormal.z) + p_CheckLine.PlaneDistance
  if l_Result >= 0.0 then
    return 1
  end if
  return 0
end

on Sign num
  if num > 0.0 then
    return 1
  else
    return -1
  end if
end

on Sqr num
  return num * num
end

on Cube num
  return num * num * num
end

on GetNearestPointOnLineSeg a, b, c
  DotA = ((c.x - a.x) * (b.x - a.x)) + ((c.y - a.y) * (b.y - a.y))
  if DotA < 0 then
    return VOID
  end if
  DotB = ((c.x - b.x) * (a.x - b.x)) + ((c.y - b.y) * (a.y - b.y))
  if DotB < 0 then
    return VOID
  end if
  l_Result = vector(a.x + ((b.x - a.x) * DotA / (DotA + DotB)), a.y + ((b.y - a.y) * DotA / (DotA + DotB)), 0.0)
  return l_Result
end

on CalculatePlaneNormal me, fA, fB
  fA.z = 0.0
  fB.z = 0.0
  fC = (fA + fB) * 0.5
  fC.z = 1.0
  lNormal = (fB - fA).crossProduct(fC - fA)
  lNormal.normalize()
  return lNormal
end

on GetMatrix3x3 fA, fB, fC, fD, fE, fF, fG, fH, fI
  lMatrix3x3 = [#_11: fA, #_12: fB, #_13: fC, #_21: fD, #_22: fE, #_23: fF, #_31: fG, #_32: fH, #_33: fI]
  return lMatrix3x3
end

on GetIdentity3x3
  lMatrix3x3 = [#_11: 1, #_12: 0, #_13: 0, #_21: 0, #_22: 1, #_23: 0, #_31: 0, #_32: 0, #_33: 1]
  return lMatrix3x3
end

on MultiplyMatrix3x3 fM, fN
  l_11 = (fM._11 * fN._11) + (fM._12 * fN._21) + (fM._13 * fN._31)
  l_12 = (fM._11 * fN._12) + (fM._12 * fN._22) + (fM._13 * fN._32)
  l_13 = (fM._11 * fN._13) + (fM._12 * fN._23) + (fM._13 * fN._33)
  l_21 = (fM._21 * fN._11) + (fM._22 * fN._21) + (fM._23 * fN._31)
  l_22 = (fM._21 * fN._12) + (fM._22 * fN._22) + (fM._23 * fN._32)
  l_23 = (fM._21 * fN._13) + (fM._22 * fN._23) + (fM._23 * fN._33)
  l_31 = (fM._31 * fN._11) + (fM._32 * fN._21) + (fM._33 * fN._31)
  l_32 = (fM._31 * fN._12) + (fM._32 * fN._22) + (fM._33 * fN._32)
  l_33 = (fM._31 * fN._13) + (fM._32 * fN._23) + (fM._33 * fN._33)
  lMatrix3x3 = [#_11: l_11, #_12: l_12, #_13: l_13, #_21: l_21, #_22: l_22, #_23: l_23, #_31: l_31, #_32: l_32, #_33: l_33]
  return lMatrix3x3
end

on MultiplyMatrix3x3Scalar fM, fScalar
  l_11 = fM._11 * fScalar
  l_12 = fM._12 * fScalar
  l_13 = fM._13 * fScalar
  l_21 = fM._21 * fScalar
  l_22 = fM._22 * fScalar
  l_23 = fM._23 * fScalar
  l_31 = fM._31 * fScalar
  l_32 = fM._32 * fScalar
  l_33 = fM._33 * fScalar
  lMatrix3x3 = [#_11: l_11, #_12: l_12, #_13: l_13, #_21: l_21, #_22: l_22, #_23: l_23, #_31: l_31, #_32: l_32, #_33: l_33]
  return lMatrix3x3
end

on AddMatrix3x3 fM, fN
  l_11 = fM._11 + fN._11
  l_12 = fM._12 + fN._12
  l_13 = fM._13 + fN._13
  l_21 = fM._21 + fN._21
  l_22 = fM._22 + fN._22
  l_23 = fM._23 + fN._23
  l_31 = fM._31 + fN._31
  l_32 = fM._32 + fN._32
  l_33 = fM._33 + fN._33
  lMatrix3x3 = [#_11: l_11, #_12: l_12, #_13: l_13, #_21: l_21, #_22: l_22, #_23: l_23, #_31: l_31, #_32: l_32, #_33: l_33]
  return lMatrix3x3
end

on MultiplyVectorMatrix3x3 fM, fVector
  l_x = (fM._11 * fVector.x) + (fM._12 * fVector.y) + (fM._13 * fVector.z)
  l_y = (fM._21 * fVector.x) + (fM._22 * fVector.y) + (fM._23 * fVector.z)
  l_z = (fM._31 * fVector.x) + (fM._32 * fVector.y) + (fM._33 * fVector.z)
  return vector(l_x, l_y, l_z)
end

on GetRotatedVectorX fVector, fTheta
  lCosT = cos(fTheta)
  lSinT = sin(fTheta)
  lRotationMatrix = GetMatrix3x3(1.0, 0.0, 0.0, 0.0, lCosT, -lSinT, 0.0, lSinT, lCosT)
  lRotated = MultiplyVectorMatrix3x3(lRotationMatrix, fVector)
  return lRotated
end

on GetRotatedVectorY fVector, fTheta
  lCosT = cos(fTheta)
  lSinT = sin(fTheta)
  lRotationMatrix = GetMatrix3x3(lCosT, 0.0, lSinT, 0.0, 1.0, 0.0, -lSinT, 0.0, lCosT)
  lRotated = MultiplyVectorMatrix3x3(lRotationMatrix, fVector)
  return lRotated
end

on GetRotatedVectorZ fVector, fTheta
  lCosT = cos(fTheta)
  lSinT = sin(fTheta)
  lRotationMatrix = GetMatrix3x3(lCosT, -lSinT, 0.0, lSinT, lCosT, 0.0, 0.0, 0.0, 1.0)
  lRotated = MultiplyVectorMatrix3x3(lRotationMatrix, fVector)
  return lRotated
end

on PrintMatrix fM
  put "-----------------------------------------"
  put "[ " & fM._11 & "  " & fM._12 & "  " & fM._13 & " ]"
  put "[ " & fM._21 & "  " & fM._22 & "  " & fM._23 & " ]"
  put "[ " & fM._31 & "  " & fM._32 & "  " & fM._33 & " ]"
  put "----------------------------------------"
end

on InterpConstant t
  return t
end

on InterpLinear t, b, c, d
  return (c * t / d) + b
end

on InterpInQuad t, b, c, d
  t = t / d
  return (c * t * t) + b
end

on InterpOutQuad t, b, c, d
  t = t / d
  return (-c * t * (t - 2)) + b
end

on InterpInOutQuad t, b, c, d
  t = t / (d * 0.5)
  if t < 1 then
    return (c / 2 * t * t) + b
  end if
  t = t - 1.0
  return (-c / 2 * ((t * (t - 2)) - 1)) + b
end

on InterpInCubic t, b, c, d
  t = t / d
  return (c * t * t * t) + b
end

on InterpOutCubic t, b, c, d
  t = (t / d) - 1
  return (c * ((t * t * t) + 1.0)) + b
end

on InterpInOutCubic t, b, c, d
  t = t / (d * 0.5)
  if t < 1 then
    return (c / 2 * t * t * t) + b
  end if
  t = t - 2
  return (c / 2 * ((t * t * t) + 2)) + b
end

on InterpInQuart t, b, c, d
  t = t / d
  return (c * t * t * t * t) + b
end

on InterpOutQuart t, b, c, d
  t = (t / d) - 1
  return (-c * ((t * t * t * t) - 1.0)) + b
end

on InterpInOutQuart t, b, c, d
  t = t / (d * 0.5)
  if t < 1 then
    return (c / 2 * t * t * t * t) + b
  end if
  t = t - 2
  return (-c / 2 * ((t * t * t * t) - 2)) + b
end

on InterpInQuint t, b, c, d
  t = t / d
  return (c * t * t * t * t * t) + b
end

on InterpOutQuint t, b, c, d
  t = (t / d) - 1
  return (c * ((t * t * t * t * t) + 1.0)) + b
end

on InterpInOutQuint t, b, c, d
  t = t / (d * 0.5)
  if t < 1 then
    return (c / 2 * t * t * t * t * t) + b
  end if
  t = t - 2
  return (c / 2 * ((t * t * t * t * t) + 2)) + b
end

on degrees kRadians
  return kRadians * 57.29577957859999771
end

on radians kDegrees
  return kDegrees / 57.29577957859999771
end

on PointInAABB kAABB, kPoint, kTestAxes
  if voidp(kTestAxes) then
    kTestAxes = 2
  end if
  if ((kPoint.x < kAABB.min.x) or (kPoint.x > kAABB.max.x)) and (kTestAxes >= 1) then
    return 0
  end if
  if ((kPoint.y < kAABB.min.y) or (kPoint.y > kAABB.max.y)) and (kTestAxes >= 2) then
    return 0
  end if
  if ((kPoint.z < kAABB.min.z) or (kPoint.z > kAABB.max.z)) and (kTestAxes >= 3) then
    return 0
  end if
  return 1
end

on PlaneLineIntersection kPlane, kLine
  lP1 = kLine[1]
  lP2 = kLine[2]
  lDir = lP2 - lP1
  lDenom = -lDir.dot(kPlane.normal)
  if abs(lDenom) < 0.00001 then
    return VOID
  end if
  lT = kPlane.normal.dot(lP1) + kPlane.distance
  lT = lT / lDenom
  return lP1 + (lDir * lT)
end

on PlaneLineIntersectionRatio kNormal, kDist, kLine, kWantedDist
  lP1 = kLine[1]
  lP2 = kLine[2]
  lDir = lP2 - lP1
  lDenom = -lDir.dot(kNormal)
  if abs(lDenom) < 0.00001 then
    return VOID
  end if
  lT1 = kNormal.dot(lP1) + kDist + kWantedDist
  lT2 = kNormal.dot(lP1) + kDist - kWantedDist
  lT1 = lT1 / lDenom
  lT2 = lT2 / lDenom
  return min(lT1, lT2)
end

on PlaneIntersectLine kNormal, kDist, kPt1, kPt2, kWantedDist
  lineDir = kPt2 - kPt1
  denom = -lineDir.dot(kNormal)
  if abs(denom) < 0.00001 then
    return [0, VOID, VOID]
  end if
  ood = 1.0 / denom
  if not voidp(kWantedDist) then
    t1 = (kNormal.dot(kPt1) + kDist + kWantedDist) * ood
    t2 = (kNormal.dot(kPt1) + kDist - kWantedDist) * ood
    if t1 > t2 then
      tmp = t2
      t2 = t1
      t1 = tmp
    end if
    coll = (t1 >= 0.0) and (t1 <= 1.0)
    return [coll, [t1, t2], [kPt1 + (lineDir * t1), kPt1 + (lineDir * t2)]]
  else
    t = (kNormal.dot(kPt1) + kDist) * ood
    coll = (t >= 0.0) and (t <= 1.0)
    return [coll, t, kPt1 + (lineDir * t)]
  end if
end

on ClosestPtOnTri kA, kB, kC, kP
  lAB = kB - kA
  lAC = kC - kA
  lAP = kP - kA
  d1 = lAB.dot(lAP)
  d2 = lAC.dot(lAP)
  if (d1 <= 0.0) and (d2 <= 0.0) then
    return kA.duplicate()
  end if
  lBP = kP - kB
  d3 = lAB.dot(lBP)
  d4 = lAC.dot(lBP)
  if (d3 >= 0.0) and (d4 <= d3) then
    return kB.duplicate()
  end if
  vc = (d1 * d4) - (d3 * d2)
  if (vc <= 0.0) and (d1 >= 0.0) and (d3 <= 0.0) and (abs(d1 - d3) > 0.0) then
    v = d1 / (d1 - d3)
    return kA + (lAB * v)
  end if
  lCP = kP - kC
  d5 = lAB.dot(lCP)
  d6 = lAC.dot(lCP)
  if (d6 >= 0.0) and (d5 <= d6) then
    return kC.duplicate()
  end if
  vb = (d5 * d2) - (d1 * d6)
  if (vb <= 0.0) and (d2 >= 0.0) and (d6 <= 0.0) then
    w = d2 / (d2 - d6)
    return kA + (lAC * w)
  end if
  va = (d3 * d6) - (d5 * d4)
  d7 = d4 - d3
  d8 = d5 - d6
  if (va <= 0.0) and (d7 >= 0.0) and (d8 >= 0.0) then
    w = d7 / (d7 + d8)
    return kB + ((kC - kB) * w)
  end if
  denom = 1.0 / (va + vb + vc)
  v = vb * denom
  w = vc * denom
  return kA + (lAB * v) + (lAC * w)
end

on IntersectSegmentTriangle kP0, kP1, kTri
  lu = kTri.p2 - kTri.p1
  lV = kTri.p3 - kTri.p1
  lN = lu.cross(lV)
  if lN = vector(0.0, 0.0, 0.0) then
    return [-1]
  end if
  lDir = kP1 - kP0
  lW0 = kP0 - kTri.p1
  lA = -lN.dot(lW0)
  lB = lN.dot(lDir)
  if abs(lB) < 0.0000000000001 then
    if lA = 0.0 then
      return [2]
    else
      return [0]
    end if
  end if
  lR = lA / lB
  if (lR < 0.0) or (lR > 1.0) then
    return [0]
  end if
  li = kP0 + (lR * lDir)
  lUU = lu.dot(lu)
  lUV = lu.dot(lV)
  lVV = lV.dot(lV)
  lw = li - kTri.p1
  lWU = lw.dot(lu)
  lWV = lw.dot(lV)
  lD = (lUV * lUV) - (lUU * lVV)
  lS = ((lUV * lWV) - (lVV * lWU)) / lD
  if (lS < -0.001) or (lS > 1.00099999999999989) then
    return [0]
  end if
  lT = ((lUV * lWU) - (lUU * lWV)) / lD
  if (lT < -0.001) or ((lS + lT) > 1.00099999999999989) then
    return [0]
  end if
  return [1, li, lN]
end

on IntersectSegmentTriangleOLD kP0, kP1, kTri
  lE1 = kTri.p2 - kTri.p1
  lE2 = kTri.p3 - kTri.p1
  lD = kP1 - kP0
  lH = lD.cross(lE2)
  lA = lE1.dot(lH)
  if (lA > -0.0001) and (lA < 0.00001) then
    return [0]
  end if
  lF = 1 / lA
  lS = kP0 - kTri.p1
  lu = lF * lS.dot(lH)
  if (lu < -0.01) or (lu > 1.01000000000000001) then
    return [0]
  end if
  lQ = lS.cross(lE1)
  lV = lF * lD.dot(lQ)
  if (lV < -0.001) or ((lu + lV) > 1.00099999999999989) then
    return [0]
  end if
  lT = lF * lE2.dot(lQ)
  if (lT >= -0.02) and (lT <= 1.0) then
    return [1, kP0 + (lT * lD), lE1.cross(lE2)]
  end if
  return [0]
end

on VectorIsLessEq kV1, kV2
  return (kV1.x <= kV2.x) and (kV1.y <= kV2.y) and (kV1.z <= kV2.z)
end

on VectorIsGreaterEq kV1, kV2
  return (kV1.x >= kV2.x) and (kV1.y >= kV2.y) and (kV1.z >= kV2.z)
end

on SphereIntersectLine kPos, kRad, kP1, kP2
  lineDir = kP2 - kP1
  a_2 = 2.0 * lineDir.dot(lineDir)
  b = 2.0 * lineDir.dot(kP1 - kPos)
  c = kPos.dot(kPos) + kP1.dot(kP1) - (2.0 * kPos.dot(kP1)) - (kRad * kRad)
  delta = (b * b) - (2.0 * a_2 * c)
  if delta < 0.0 then
    return [0, [], []]
  else
    if delta < 0.0000001 then
      t1 = -b / a_2
      return [1, [t1], [kP1 + (lineDir * t1)]]
    else
      ooa_2 = 1.0 / a_2
      sqrt_delta = sqrt(delta)
      t1 = (-b + sqrt_delta) * ooa_2
      t2 = (-b - sqrt_delta) * ooa_2
      if t1 > t2 then
        tmp = t2
        t2 = t1
        t1 = tmp
      end if
      return [1, [t1, t2], [kP1 + (lineDir * t1), kP1 + (lineDir * t2)]]
    end if
  end if
end

on RayIntersectAABB kOrigin, kDirection, kMin, kMax
  tmin = 0.0
  tmax = 10000000000.0
  repeat with i = 1 to 3
    P = kOrigin[i]
    d = kDirection[i]
    if abs(d) < 0.00001 then
      if (P < kMin[i]) or (P > kMax[i]) then
        return [0, VOID]
      end if
      next repeat
    end if
    ood = 1.0 / d
    t1 = (kMin[i] - P) * ood
    t2 = (kMax[i] - P) * ood
    if t1 > t2 then
      tmp = t2
      t2 = t1
      t1 = tmp
    end if
    tmin = max(tmin, t1)
    tmax = min(tmax, t2)
    if tmin > tmax then
      return [0, VOID]
    end if
  end repeat
  return [1, tmin]
end

on RayIntersectSphere kOrigin, kDirection, kCenter, kRadius
  return SphereIntersectLine(kCenter, kRadius, kOrigin, kOrigin + kDirection)
end

on RayIntersectElipsoid kOrigin, kDirection, kCenter, kRadius
  lInvRadius = vector(1.0 / kRadius.x, 1.0 / kRadius.y, 1.0 / kRadius.z)
  lNewOrigin = kOrigin - kCenter
  lNewOrigin = vector(lNewOrigin.x * lInvRadius.x, lNewOrigin.y * lInvRadius.y, lNewOrigin.z * lInvRadius.z)
  lNewDirection = vector(kDirection.x * lInvRadius.x, kDirection.y * lInvRadius.y, kDirection.z * lInvRadius.z)
  lRet = RayIntersectSphere(lNewOrigin, lNewDirection, vector(0.0, 0.0, 0.0), 1.0)
  if lRet[1] then
    lPts = lRet[3]
    lNewPts = []
    lNewTs = []
    repeat with lPt in lPts
      lCollPt = kCenter + vector(lPt.x * kRadius.x, lPt.y * kRadius.y, lPt.z * kRadius.z)
      lNewPts.append(lCollPt)
      lNewTs.append((lCollPt - kOrigin).dot(kDirection))
    end repeat
    lRet[2] = lNewTs
    lRet[3] = lNewPts
    return lRet
  else
    return [0, [], []]
  end if
end

on PlaneIntersectAABB kNormal, kDist, kCenter, kExtents
  lAbsNormal = vector(abs(kNormal.x), abs(kNormal.y), abs(kNormal.z))
  lProjCenter = kNormal.dot(kCenter)
  lProjExtents = lAbsNormal.dot(kExtents)
  lDistMin = lProjCenter - lProjExtents + kDist
  lDistMax = lProjCenter + lProjExtents + kDist
  if (lDistMin <= 0.0) and (lDistMax >= 0.0) then
    return #intersect
  else
    if lDistMin < 0.0 then
      return #left
    else
      return #right
    end if
  end if
end

on AABBIntersectAABB kC1, kE1, kC2, kE2, kThreshold
  if voidp(kThreshold) then
    kThreshold = 0.0
  end if
  lP = kC2 - kC1
  lS = kE2 + kE1
  return ((lS.x - abs(lP.x)) >= kThreshold) and ((lS.y - abs(lP.y)) >= kThreshold) and ((lS.z - abs(lP.z)) >= kThreshold)
end

on AABBInAABB kC1, kE1, kC2, kE2, kThreshold
  if voidp(kThreshold) then
    kThreshold = 0.0
  end if
  lP = kC2 - kC1
  lS = kE1 - kE2
  return ((lS.x - abs(lP.x)) >= kThreshold) and ((lS.y - abs(lP.y)) >= kThreshold) and ((lS.z - abs(lP.z)) >= kThreshold)
end

on SphereInAABB kC, kE, kP, kR
  lV = kP - kC
  return (lV.x >= (-kE.x + kR)) and (lV.x <= (kE.x - kR)) and (lV.y >= (-kE.y + kR)) and (lV.y <= (kE.y - kR)) and (lV.z >= (-kE.z + kR)) and (lV.z <= (kE.z - kR))
end

on ElipsoidInAABB kC, kE, kP, kR
  lInvR = vector(1.0 / kR.x, 1.0 / kR.y, 1.0 / kR.z)
  lV = kP - kC
  lC = kP + vector(lV.x * lInvR.x, lV.y * lInvR.y, lV.z * lInvR.z)
  lE = vector(kE.x * lInvR.x, kE.y * lInvR.y, kE.z * lInvR.z)
  return SphereInAABB(lC, lE, kP, 1.0)
end

on CreatePlaneFromTri kA, kB, kC
  kV1 = kB - kA
  kV2 = kC - kA
  lNormal = kV1.cross(kV2).getNormalized()
  lDist = -lNormal.dot(kA)
  return [lNormal, lDist]
end

on MatrixInterpolate a, b, t
  aa = radians(a.axisAngle[2]) * 0.5
  sa = sin(aa)
  ca = cos(aa)
  q1 = script("Quaternion").new(-a.axisAngle[1] * sa, ca)
  ab = radians(b.axisAngle[2]) * 0.5
  sb = sin(ab)
  cb = cos(ab)
  q2 = script("Quaternion").new(-b.axisAngle[1] * sb, cb)
  q1.Slerp(q2, t)
  v = 1.0 - t
  P = (a.position * v) + (b.position * t)
  s = (a.scale * v) + (b.scale * t)
  m = q1.ToSW3dMatrix(P)
  m.scale = s
  return m
end

on LineIntersectLine me, p1, q1, p2, q2
  d1 = q1 - p1
  d2 = q2 - p2
  R = p1 - p2
  a = d1.dot(d1)
  e = d2.dot(d2)
  f = d2.dot(R)
  if (a <= 0.001) and (e <= 0.001) then
    return [0.0, 0.0, p1, p2]
  end if
  if a <= 0.001 then
    s = 0.0
    t = f / e
    t = min(max(t, 0.0), 1.0)
  else
    c = d1.dot(R)
    if e <= 0.001 then
      t = 0.0
      s = -c / a
      s = min(max(s, 0.0), 1.0)
    else
      b = d1.dot(d2)
      denom = (a * e) - (b * b)
      if abs(denom) > 0.00001 then
        s = ((b * f) - (c * e)) / denom
        s = min(max(s, 0.0), 1.0)
      else
        s = 0.0
      end if
      t = ((b * s) + f) / e
      if t < 0.0 then
        t = 0.0
        s = -c / a
        s = min(max(s, 0.0), 1.0)
      else
        if t > 1.0 then
          t = 1.0
          s = (b - c) / a
          s = min(max(s, 0.0), 1.0)
        end if
      end if
    end if
  end if
  return [s, t, p1 + (d1 * s), p2 + (d2 * t)]
end
