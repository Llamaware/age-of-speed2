property pType, pPosition, pRadius, pInAction, pOutAction, pInActionData, pOutActionData, pObjRef, pInFunctionData, pOutFunctionData, pIsActive, pIsIn, pUserData, pDistanceFromObject, pCollisionTestType
global gGame

on new me, fPosition, fRadius, fIsActive, fInAction, fOutAction, fInActionData, fOutActionData, fType, fObjRef, fInFunctionData, fOutFunctionData, fUserData, fCollisionTestType, kPlayersNum
  pPosition = fPosition
  pRadius = fRadius
  pType = fType
  pInAction = fInAction
  pOutAction = fOutAction
  pInActionData = fInActionData
  pOutActionData = fOutActionData
  pIsActive = fIsActive
  pCollisionTestType = fCollisionTestType
  pObjRef = fObjRef
  if voidp(kPlayersNum) then
    kPlayersNum = 1
  end if
  pIsIn = []
  repeat with li = 1 to kPlayersNum
    pIsIn.add(0)
  end repeat
  pUserData = fUserData
  pDistanceFromObject = VOID
  if not voidp(pUserData) then
    if pUserData.findPos(#DistanceFromObject) <> VOID then
      pDistanceFromObject = float(pUserData.DistanceFromObject)
    end if
  end if
  return me
end

on CheckIfOut me, fPosition, fPlayerId
  if pIsIn[fPlayerId] then
    if pIsActive then
      if me.pCollisionTestType = #spheric then
        lDistance = Calculate3dSquaredDistanceV(fPosition, pPosition)
      else
        if me.pCollisionTestType = #cylindric then
          lDistance = Calculate2dSquaredDistance(fPosition.x, fPosition.y, pPosition.x, pPosition.y)
        else
          put " Errore"
        end if
      end if
      if lDistance > (pRadius * pRadius) then
        pIsIn[fPlayerId] = 0
        if pType = #generic then
          return [pOutAction, pOutActionData]
        else
          if pType = #object then
            return [pObjRef, pOutActionData, #out]
          end if
        end if
      end if
    end if
  end if
  return [#none, -1]
end

on Check me, fPosition, fPlayerId
  if pIsActive then
    if me.pCollisionTestType = #spheric then
      lDistance = Calculate3dSquaredDistanceV(fPosition, pPosition)
    else
      if me.pCollisionTestType = #cylindric then
        lDistance = Calculate2dSquaredDistance(fPosition.x, fPosition.y, pPosition.x, pPosition.y)
      else
        put "Errore - Checkpoint - on Check"
      end if
    end if
    if pIsIn[fPlayerId] = 0 then
      lSetIn = 0
      if lDistance < (pRadius * pRadius) then
        if voidp(pDistanceFromObject) then
          lSetIn = 1
        else
          lObjectPosition = pObjRef.pModelRef.transform.position
          lDirection = (pObjRef.pModelRef.transform * vector(1.0, 0.0, 0.0)) - pObjRef.pModelRef.transform.position
          lRadius = pRadius
          lEndPosition = lObjectPosition + (lRadius * lDirection)
          lStartPosition = lObjectPosition - (lRadius * lDirection)
          lNearestPoint = GetNearestPointOnLineSeg(lEndPosition, lStartPosition, fPosition)
          fPosition.x = fPosition.x - lNearestPoint.x
          fPosition.y = fPosition.y - lNearestPoint.y
          lDistanceFromObject = sqrt((fPosition.x * fPosition.x) + (fPosition.y * fPosition.y))
          if lDistanceFromObject < pDistanceFromObject then
            lSetIn = 1
          end if
        end if
      end if
      if lSetIn then
        pIsIn[fPlayerId] = 1
        if pType = #generic then
          gGame.GetCheckpointManager().AddIntoCheckOutList(me, fPlayerId)
          return [pInAction, pInActionData]
        else
          if pType = #object then
            gGame.GetCheckpointManager().AddIntoCheckOutList(me, fPlayerId)
            return [pObjRef, pInActionData, #in]
          end if
        end if
      end if
    end if
  end if
  return [#none, -1]
end
