property pGrid, pBlockWidth, pBlockHeight, pWorldMin, pWorldMax, pCheckpointList, pHorizontalBlockNum, pVerticalBlockNum, pPlayersNum, pCheckOutList
global gGame

on new me, fWorldMin, fWorldMax, fHorizontalBlockNum, fVerticalBlockNum, kPlayersNum
  pCheckpointList = [:]
  if voidp(kPlayersNum) then
    kPlayersNum = 1
  end if
  pPlayersNum = kPlayersNum
  pCheckOutList = []
  repeat with li = 1 to pPlayersNum
    pCheckOutList.add([])
  end repeat
  pWorldMin = fWorldMin
  pWorldMax = fWorldMax
  pHorizontalBlockNum = fHorizontalBlockNum
  pVerticalBlockNum = fVerticalBlockNum
  pBlockWidth = (fWorldMax.x - fWorldMin.x) / pHorizontalBlockNum
  pBlockHeight = (fWorldMax.y - fWorldMin.y) / pVerticalBlockNum
  pGrid = []
  repeat with lX = 1 to pHorizontalBlockNum
    repeat with lY = 1 to pVerticalBlockNum
      pGrid.add([])
    end repeat
  end repeat
  return me
end

on AddIntoGrid me, fCheckpoint
  lPosition = fCheckpoint.pPosition
  lRadius = fCheckpoint.pRadius
  lMinXIndex = floor((lPosition.x - lRadius - pWorldMin.x) / pBlockWidth) + 1
  lMaxXIndex = floor((lPosition.x + lRadius - pWorldMin.x) / pBlockWidth) + 1
  lMinYIndex = floor((lPosition.y - lRadius - pWorldMin.y) / pBlockHeight) + 1
  lMaxYIndex = floor((lPosition.y + lRadius - pWorldMin.y) / pBlockHeight) + 1
  if lMinXIndex < 1 then
    lMinXIndex = 1
  end if
  if lMaxXIndex < 1 then
    lMaxXIndex = 1
  end if
  if lMinYIndex < 1 then
    lMinYIndex = 1
  end if
  if lMaxYIndex < 1 then
    lMaxYIndex = 1
  end if
  if lMinXIndex > pHorizontalBlockNum then
    lMinXIndex = pHorizontalBlockNum
  end if
  if lMaxXIndex > pHorizontalBlockNum then
    lMaxXIndex = pHorizontalBlockNum
  end if
  if lMinYIndex > pVerticalBlockNum then
    lMinYIndex = pVerticalBlockNum
  end if
  if lMaxYIndex > pVerticalBlockNum then
    lMaxYIndex = pVerticalBlockNum
  end if
  repeat with lX = lMinXIndex to lMaxXIndex
    repeat with lY = lMinYIndex to lMaxYIndex
      lMin = pWorldMin + vector(pBlockWidth * (lX - 1), pBlockHeight * (lY - 1), 0.0)
      lMax = pWorldMin + vector(pBlockWidth * lX, pBlockHeight * lY, 0.0)
      lResult = BoxOverlapsSphere(lMax, lMin, lRadius, lPosition, 2)
      if lResult then
        lBlockIndex = ((lY - 1) * pHorizontalBlockNum) + (lX - 1) + 1
        pGrid[lBlockIndex].add(fCheckpoint)
      end if
    end repeat
  end repeat
end

on add me, fLabel, fPosition, fRadius, fIsActive, fInAction, fOutAction, fInActionData, fOutActionData, fCollisionTest
  lTempCheckpoint = script("Checkpoint").new(fPosition, fRadius, fIsActive, fInAction, fOutAction, fInActionData, fOutActionData, #generic, VOID, VOID, VOID, VOID, fCollisionTest, pPlayersNum)
  if pCheckpointList.findPos(fLabel) = 0 then
    pCheckpointList.addProp(fLabel, lTempCheckpoint)
    me.AddIntoGrid(lTempCheckpoint)
    return pCheckpointList.count
  end if
  return -1
end

on AddWithObject me, fLabel, fPosition, fRadius, fIsActive, fObjRef, fInFunctionData, fOutFunctionData, fUserData, fCollisionTest
  if pCheckpointList.findPos(fLabel) = 0 then
    lTempCheckpoint = script("Checkpoint").new(fPosition, fRadius, fIsActive, VOID, VOID, fInFunctionData, fOutFunctionData, #object, fObjRef, VOID, VOID, fUserData, fCollisionTest, pPlayersNum)
    pCheckpointList.addProp(fLabel, lTempCheckpoint)
    me.AddIntoGrid(lTempCheckpoint)
    return pCheckpointList.count
  end if
  return -1
end

on AddIntoCheckOutList me, fCheckpointHit, fPlayerId
  pCheckOutList[fPlayerId].add(fCheckpointHit)
end

on CheckOutList me, fPosition, fPlayerId
  lCheckOutList = pCheckOutList[fPlayerId]
  repeat with li = lCheckOutList.count down to 1
    lCheckpointHit = lCheckOutList[li]
    lResult = lCheckpointHit.CheckIfOut(fPosition, fPlayerId)
    if lResult[1] <> #none then
      call(#CheckpointManagementCallback, gGame.GetGameplay(), lCheckpointHit, lResult, fPlayerId)
      lCheckOutList.deleteAt(li)
    end if
  end repeat
end

on update me, fPosition, fPlayerId
  me.CheckOutList(fPosition, fPlayerId)
  lXIndex = floor((fPosition.x - pWorldMin.x) / pBlockWidth) + 1
  lYIndex = floor((fPosition.y - pWorldMin.y) / pBlockHeight) + 1
  if lXIndex < 1 then
    lXIndex = 1
  end if
  if lYIndex < 1 then
    lYIndex = 1
  end if
  if lXIndex > pHorizontalBlockNum then
    lXIndex = pHorizontalBlockNum
  end if
  if lYIndex > pVerticalBlockNum then
    lYIndex = pVerticalBlockNum
  end if
  lIndex = ((lYIndex - 1) * pHorizontalBlockNum) + (lXIndex - 1) + 1
  repeat with li = 1 to pGrid[lIndex].count
    lResult = pGrid[lIndex][li].Check(fPosition, fPlayerId)
    if lResult[1] <> #none then
      lCheckpointHit = pGrid[lIndex][li]
      call(#CheckpointManagementCallback, gGame.GetGameplay(), lCheckpointHit, lResult, fPlayerId)
    end if
  end repeat
  return #none
end

on Activate me, fIndex
  me.pCheckpointList[fIndex].pIsActive = 1
end

on Deactivate me, fIndex
  me.pCheckpointList[fIndex].pIsActive = 0
end

on DeactivateByLabel me, kLabel
  if not voidp(me.pCheckpointList.findPos(kLabel)) then
    me.pCheckpointList[kLabel].pIsActive = 0
  end if
end

on Remove me, fIndex
  if me.pCheckpointList.count >= fIndex then
    me.pCheckpointList.deleteAt(fIndex)
  end if
end

on DeleteByLabel me, fLabel
  if not voidp(me.pCheckpointList.findPos(fLabel)) then
    pCheckpointList.deleteProp(fLabel)
  end if
end
