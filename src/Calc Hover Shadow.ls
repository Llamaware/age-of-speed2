property pVehicle, pShadowMdl, pFrontOrientation, pRightOrientation, pIntersectionPosition, pIntersectionNormal, pShadowPos, pGroundDistance, pShadowVisibility, pShadowInclinationLimit, pShadowZOffset
global gGame

on new me, kShadowData
  pShadowMdl = gGame.Get3D().model(kShadowData.ShadowMdlName)
  if voidp(pShadowMdl) then
    if kShadowData.findPos(#ShadowGroupName) <> VOID then
      if not voidp(kShadowData.ShadowGroupName) then
        pShadowMdl = gGame.Get3D().group(kShadowData.ShadowGroupName)
      end if
    end if
  end if
  if not voidp(pShadowMdl) then
    pShadowMdl.pointAtOrientation = [vector(0, 1, 0), vector(0, 0, 1)]
    pShadowMdl.transform.scale = vector(1.0, 1.0, 1.0)
  end if
  pShadowVisibility = #front
  if not kShadowData.visible then
    if not voidp(pShadowMdl) then
      SetHierarchyVisibility(pShadowMdl, #none)
      pShadowVisibility = #none
    end if
  end if
  pShadowInclinationLimit = 0.40000000000000002
  if kShadowData.findPos(#ShadowInclinationLimit) <> VOID then
    pShadowInclinationLimit = kShadowData.ShadowInclinationLimit
  end if
  pShadowZOffset = 5.0
  return me
end

on Initialize me, kVehicle
  pVehicle = kVehicle
  pFrontOrientation = pVehicle.GetTransform() * vector(0.0, 1.0, 0.0)
  pRightOrientation = pVehicle.GetTransform() * vector(1.0, 0.0, 0.0)
end

on GetIntersectionPosition me
  return pIntersectionPosition
end

on GetGroundDistance me
  return pGroundDistance
end

on GetIntersectionNormal me
  return pIntersectionNormal
end

on GetShadowMdl me
  return pShadowMdl
end

on SetShadowVisibility me, kValue
  pShadowVisibility = kValue
end

on SetShadowZOffset me, kValue
  pShadowZOffset = kValue
end

on SetShadowMdl me, kMdl
  pShadowMdl = kMdl
end

on update me
  lDt = gGame.GetTimeManager().GetDeltaTime() * 0.001
  lHoverContactPoint = pVehicle.GetHoverContactPoint()
  if lHoverContactPoint = [] then
    return 
  end if
  lInvalidIntersections = 0
  if lHoverContactPoint.count < 4 then
    lInvalidIntersections = 1
  else
    repeat with li = 1 to lHoverContactPoint.count
      if voidp(lHoverContactPoint[li]) or (lHoverContactPoint[li] = 0) then
        lInvalidIntersections = 1
        exit repeat
      end if
    end repeat
  end if
  if lInvalidIntersections then
    return 
  end if
  lFront = lHoverContactPoint[1] - lHoverContactPoint[3]
  lFront.normalize()
  pFrontOrientation = lFront
  lRight = lHoverContactPoint[4] - lHoverContactPoint[3]
  lRight.normalize()
  pRightOrientation = lRight
  pIntersectionNormal = -pFrontOrientation.cross(pRightOrientation)
  pIntersectionNormal.normalize()
  lZ = lHoverContactPoint[1].z + lHoverContactPoint[2].z + lHoverContactPoint[3].z + lHoverContactPoint[4].z
  lShadowZ = (lZ * 0.25) + pShadowZOffset
  lVehiclePos = pVehicle.getPosition().duplicate()
  pShadowPos = lVehiclePos
  pShadowPos.z = lShadowZ
  pIntersectionPosition = pShadowPos
  pGroundDistance = pVehicle.getPosition().z - lShadowZ
  if not voidp(pShadowMdl) then
    pShadowMdl.transform.position = pShadowPos
    pShadowMdl.pointAt(pShadowPos + (pFrontOrientation * 20.0), pIntersectionNormal)
    lAngleToUp = pVehicle.GetWorldUp().dot(vector(0, 0, 1))
    if lAngleToUp < pShadowInclinationLimit then
      SetHierarchyVisibility(pShadowMdl, #none)
    else
      SetHierarchyVisibility(pShadowMdl, pShadowVisibility)
    end if
  end if
end
