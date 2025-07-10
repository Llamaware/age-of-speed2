property pGameplay, pChecklineList

on new me, kTimeSource, kGameplay
  pChecklineList = []
  pTimeSource = kTimeSource
  pGameplay = kGameplay
  return me
end

on add me, fTokenArray, fTokenId, fLabel, fA, fB, fFrontAction, fBackAction, fFrontActionData, fBackActionData
  lCheckline = script("Checkline").new(fTokenId, fLabel, fA, fB, fFrontAction, fBackAction, fFrontActionData, fBackActionData, VOID, #generic)
  pChecklineList.add(lCheckline)
  if fTokenId <> 0 then
    fTokenArray[fTokenId].CheckLineList.add(lCheckline)
  end if
end

on AddWithObject me, fTokenArray, fTokenId, fLabel, fA, fB, fObjRef, fFrontActionData, fBackActionData
  lCheckline = script("Checkline").new(fTokenId, fLabel, fA, fB, VOID, VOID, fFrontActionData, fBackActionData, fObjRef, #object)
  pChecklineList.add(lCheckline)
  if fTokenId <> 0 then
    fTokenArray[fTokenId].CheckLineList.add(lCheckline)
  end if
end

on GetIndex me, fLabel
  repeat with li = 1 to pChecklineList.count
    if pChecklineList[li].pLabel = fLabel then
      return li
    end if
  end repeat
  return #notInList
end

on DeleteByLabel me, fLabel
  lIndex = me.GetIndex(fLabel)
  if lIndex = #notInList then
    return 
  end if
  pChecklineList.deleteAt(lIndex)
end

on SetParameters me, fLabel, fFrontAction, fBackAction, fFrontActionData, fBackActionData, fObjRef, fType
  lIndex = me.GetIndex(fLabel)
  pChecklineList[lIndex].pFrontAction = fFrontAction
  pChecklineList[lIndex].pBackAction = fBackAction
  pChecklineList[lIndex].pFrontActionData = fFrontActionData
  pChecklineList[lIndex].pBackActionData = fBackActionData
  pChecklineList[lIndex].pObjRef = fObjRef
  if fType <> VOID then
    pChecklineList[lIndex].pType = fType
  end if
end

on TestAllCkechline me, fPosition, fPreviousPosition
  if not voidp(fPreviousPosition) then
    repeat with li = 1 to pChecklineList.count
      lResult = pChecklineList[li].Check(fPosition, fPreviousPosition)
      if lResult[1] <> #none then
        me.ExecuteCheckLineActions(lResult, pChecklineList[li])
      end if
    end repeat
  end if
end

on TestTokenChecklines me, fTokenRef, fPosition, fPreviousPosition
  lTokenChecklines = fTokenRef.CheckLineList
  repeat with li = 1 to lTokenChecklines.count
    lResult = lTokenChecklines[li].Check(fPosition, fPreviousPosition)
    if lResult[1] <> #none then
      me.ExecuteCheckLineActions(lResult, lTokenChecklines[li])
    end if
  end repeat
end

on update me, fTokenArray, fCurrentToken, fPreviousToken, fPosition, fPreviousPosition
  if fTokenArray.count = 0 then
    me.TestAllCkechline(fPosition, fPreviousPosition)
  else
    if fCurrentToken <> 0 then
      if fPreviousToken <> fCurrentToken then
        if fPreviousToken <> 0 then
          me.TestTokenChecklines(fTokenArray[fPreviousToken], fPosition, fPreviousPosition)
          me.TestTokenChecklines(fTokenArray[fCurrentToken], fPosition, fPreviousPosition)
        else
          me.TestAllCkechline(fPosition, fPreviousPosition)
        end if
      else
        me.TestTokenChecklines(fTokenArray[fCurrentToken], fPosition, fPreviousPosition)
      end if
    else
      me.TestAllCkechline(fPosition, fPreviousPosition)
    end if
  end if
end

on ExecuteCheckLineActions me, fResult, fCheckLine
  pGameplay.ChecklineManagementCallback(fResult, fCheckLine)
end
