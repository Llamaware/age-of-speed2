property pLabel, pA, pB, pTokenId, pcenter, pdiameter, pPlaneNormal, pPlaneDistance, pFrontAction, pBackAction, pFrontActionData, pBackActionData, pObjRef, pType

on new me, fTokenId, fLabel, fA, fB, fFrontAction, fBackAction, fFrontActionData, fBackActionData, fObjRef, fType
  pLabel = fLabel
  pA = fA
  pB = fB
  pcenter = (pA + pB) * 0.5
  pdiameter = (pA - pB).magnitude
  lResult = me.Initialize(pA, pB)
  pPlaneNormal = lResult[1]
  pPlaneDistance = lResult[2]
  pFrontAction = fFrontAction
  pBackAction = fBackAction
  pFrontActionData = fFrontActionData
  pBackActionData = fBackActionData
  pObjRef = fObjRef
  pType = fType
  return me
end

on Initialize me, fA, fB
  lMiddle = (fA + fB) * 0.5
  lMiddle.z = lMiddle.z + 1.0
  fA.z = 0.0
  fB.z = 0.0
  lu = fA
  lV = lMiddle
  lw = fB
  lPlaneNormal = (lu - lw).crossProduct(lV - lw)
  lPlaneNormal.normalize()
  lPlaneDistance = -lPlaneNormal.dotProduct(lu)
  return [lPlaneNormal, lPlaneDistance]
end

on Check me, fPosition, fPreviousPosition
  lv1 = vector(fPreviousPosition.x, fPreviousPosition.y, 0.0)
  lv2 = vector(fPosition.x, fPosition.y, 0.0)
  if not (((pA - lv1).magnitude > pdiameter) or ((pA - lv2).magnitude > pdiameter) or ((pB - lv1).magnitude > pdiameter) or ((pB - lv2).magnitude > pdiameter)) then
    lFrontTest = me.TestCheckLine(lv2)
    lBackTest = me.TestCheckLine(lv1)
    if lBackTest <> lFrontTest then
      if lFrontTest = 1 then
        if pType = #generic then
          return [pFrontAction, pFrontActionData]
        else
          if pType = #object then
            return [pObjRef, pFrontActionData, #front]
          end if
        end if
      else
        if pType = #generic then
          return [pBackAction, pBackActionData]
        else
          if pType = #object then
            return [pObjRef, pBackActionData, #back]
          end if
        end if
      end if
    end if
  end if
  return [#none, -1]
end

on TestCheckLine me, fPosition
  l_Result = (fPosition.x * pPlaneNormal.x) + (fPosition.y * pPlaneNormal.y) + (fPosition.z * pPlaneNormal.z) + pPlaneDistance
  if l_Result >= 0.0 then
    return 1
  end if
  return 0
end

on CheckUnOptimized me, fPosition, fPreviousPosition
  lv1 = vector(fPreviousPosition.x, fPreviousPosition.y, 0.0)
  lv2 = vector(fPosition.x, fPosition.y, 0.0)
  lFrontTest = me.TestCheckLine(lv2)
  lBackTest = me.TestCheckLine(lv1)
  if lBackTest <> lFrontTest then
    if lFrontTest = 1 then
      return [pFrontAction, pFrontActionData]
    else
      return [pBackAction, pBackActionData]
    end if
  end if
  return [#none, -1]
end
