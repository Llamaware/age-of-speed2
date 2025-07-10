property pcamera, pTimeSource, pBlocks, pTokenBlocks, pBlocksBig, pBlocksTot, pBlocksInfo, pRayBlocks, pRayRules, pHorizontalBlockNum, pVerticalBlockNum, pWorldMin, pWorldMax, pCurrentTick, pBlockWidth, pBlockHeight, pCurrentIndex, pCullingList, pViewDistance, pCullDistance, pCullDistanceBig, pCheck, pCheckSteps, pUpdateCycles, pFovRatio, pCullingModelList, pverbosemode, pBigThreshold
global gGame

on new me, fCullingData, fCamera, fTimeSource
  pcamera = fCamera
  pTimeSource = fTimeSource
  pViewDistance = fCullingData.ViewDistance
  lBlocksNum = me.GetBlockNumbers(fCullingData)
  pHorizontalBlockNum = lBlocksNum.horizontal
  pVerticalBlockNum = lBlocksNum.vertical
  put "Culling manager set at horizontal blocks: " & pHorizontalBlockNum & " vertical blocks: " & pVerticalBlockNum
  pWorldMin = fCullingData.WorldMin
  pWorldMax = fCullingData.WorldMax
  pCullDistance = fCullingData.CullDistance
  pCullDistanceBig = fCullingData.CullDistanceBig
  pBlocks = []
  pBlocksBig = []
  pBlocksTot = []
  pBlocksInfo = []
  pTokenBlocks = []
  pRayBlocks = []
  pRayRules = []
  pCurrentTick = 0
  pBlockSize = vector(0.0, 0.0, 0.0)
  pBlockWidth = fCullingData.blockSize
  pBlockHeight = fCullingData.blockSize
  pCurrentIndex = 1
  pCullingList = []
  pCheck = 0
  pCheckSteps = 6
  pUpdateCycles = -1
  pMassiveCullingActive = 0
  pUpdateCycleBackupValue = -1
  pCullDistance = pCullDistance * pCullDistance
  pCullDistanceBig = pCullDistanceBig * pCullDistanceBig
  pFovRatio = 1.55000000000000004
  pverbosemode = 1
  pBigThreshold = 1400.0
  return me
end

on getWorldMin me
  return pWorldMin
end

on getWorldMax me
  return pWorldMax
end

on GetHorizontalBlockNum me
  return pHorizontalBlockNum
end

on GetVerticalBlockNum me
  return pVerticalBlockNum
end

on GetFovRatio me
  return pFovRatio
end

on SetFovRatio me, kValue
  pFovRatio = kValue
end

on SetVerboseMode me, kValue
  pverbosemode = kValue
end

on SetRayRules me, kRayRules
  pRayRules = kRayRules
end

on SetBigThreshold me, kValue
  pBigThreshold = kValue
end

on CheckIfExcludeFromCullingList me, kExcludeFromCullingList, kModelRefName
  lTest = 0
  repeat with li = 1 to kExcludeFromCullingList.count
    lItem = kExcludeFromCullingList[li]
    lCondition = lItem.condition
    lValue = lItem.value
    lTest = 0
    case lCondition of
      #starts:
        lTest = kModelRefName starts lValue
      #equal:
        lTest = kModelRefName = lValue
      #contains:
        lTest = kModelRefName contains lValue
      #not_contains:
        lTest = not (kModelRefName contains lValue)
    end case
    if lTest then
      exit repeat
    end if
  end repeat
  return lTest
end

on CheckIfIncludeIntoRayBlocks me, kModelRefName
  lTest = 0
  repeat with li = 1 to pRayRules.count
    lItem = pRayRules[li]
    lCondition = lItem.condition
    lValue = lItem.value
    lTest = 0
    case lCondition of
      #starts:
        lTest = kModelRefName starts lValue
      #equal:
        lTest = kModelRefName = lValue
      #contains:
        lTest = kModelRefName contains lValue
      #not_contains:
        lTest = not (kModelRefName contains lValue)
    end case
    if lTest then
      exit repeat
    end if
  end repeat
  return lTest
end

on BuildCullingList me, lExcludeFromCullingList
  pCullingModelList = []
  repeat with li = gGame.Get3D().model.count down to 1
    lModelRef = gGame.Get3D().model[li]
    lModelRefName = lModelRef.name
    if lModelRefName starts "x_" then
      lModelRef.removeFromWorld()
      next repeat
    end if
    if not me.CheckIfExcludeFromCullingList(lExcludeFromCullingList, lModelRefName) then
      if lModelRef.parent <> gGame.Get3D().group("world") then
        next repeat
      end if
      pCullingModelList.add(lModelRef)
    end if
  end repeat
  return pCullingModelList
end

on BuildCullingListFast me, lExcludeFromCullingList, kModelList
  pCullingModelList = []
  repeat with li = kModelList.count down to 1
    lModelRef = kModelList[li]
    if voidp(lModelRef) then
      next repeat
    end if
    lModelRefName = lModelRef.name
    if lModelRefName starts "x_" then
      lModelRef.removeFromWorld()
      next repeat
    end if
    if not me.CheckIfExcludeFromCullingList(lExcludeFromCullingList, lModelRefName) then
      if lModelRef.parent <> gGame.Get3D().group("world") then
        next repeat
      end if
      pCullingModelList.add(lModelRef)
    end if
  end repeat
  return pCullingModelList
end

on GetBlockNumbers me, fCullingData
  lRes = [#horizontal: -1, #vertical: -1]
  lBoxHeight = fCullingData.WorldMax.y - fCullingData.WorldMin.y
  lBoxWidth = fCullingData.WorldMax.x - fCullingData.WorldMin.x
  lNumHorizontalBlocks = lBoxWidth / fCullingData.blockSize
  lNumVerticalBlocks = lBoxHeight / fCullingData.blockSize
  lRes.horizontal = integer(lNumHorizontalBlocks + 0.5)
  lRes.vertical = integer(lNumVerticalBlocks + 0.5)
  return lRes
end

on Initialize me, lExcludeFromCullingList, kModelList
  if voidp(kModelList) then
    fCullingModelList = me.BuildCullingList(lExcludeFromCullingList)
  else
    fCullingModelList = me.BuildCullingListFast(lExcludeFromCullingList, kModelList)
  end if
  repeat with lX = 1 to pHorizontalBlockNum
    repeat with lY = 1 to pVerticalBlockNum
      pBlocks.add([])
      pBlocksBig.add([])
      pBlocksTot.add([])
      pRayBlocks.add([])
      pBlocksInfo.add([:])
    end repeat
  end repeat
  repeat with lX = 1 to pHorizontalBlockNum
    repeat with lY = 1 to pVerticalBlockNum
      CurrentBlockInfo = pBlocksInfo[((lY - 1) * pHorizontalBlockNum) + (lX - 1) + 1]
      CurrentBlockInfo.addProp(#CullingTime, 0)
      CurrentBlockInfo.addProp(#CullingTimeBig, 0)
    end repeat
  end repeat
  repeat with lk = 1 to fCullingModelList.count
    lCurrentModel = fCullingModelList[lk]
    lBSphereCenter = lCurrentModel.boundingSphere[1]
    lBSphereRadius = lCurrentModel.boundingSphere[2]
    lMinXIndex = floor((lBSphereCenter.x - lBSphereRadius - pWorldMin.x) / pBlockWidth) + 1
    lMaxXIndex = floor((lBSphereCenter.x + lBSphereRadius - pWorldMin.x) / pBlockWidth) + 1
    lMinYIndex = floor((lBSphereCenter.y - lBSphereRadius - pWorldMin.y) / pBlockHeight) + 1
    lMaxYIndex = floor((lBSphereCenter.y + lBSphereRadius - pWorldMin.y) / pBlockHeight) + 1
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
    lCurrentModel.userData.addProp(#IsBig, 0)
    if lCurrentModel.boundingSphere[2] > pBigThreshold then
      lCurrentModel.userData.IsBig = 1
    end if
    lHowManyCellX = lMaxXIndex - lMinXIndex + 1
    lHowManyCellY = lMaxYIndex - lMinYIndex + 1
    if ((lHowManyCellX > 5) or (lHowManyCellY > 5)) and pverbosemode then
      put "CullingManagerInitializing - pay attention: " & lCurrentModel.name & " CellX: " & lHowManyCellX & " CellY: " & lHowManyCellY
    end if
    repeat with lX = lMinXIndex to lMaxXIndex
      repeat with lY = lMinYIndex to lMaxYIndex
        lMin = pWorldMin + vector(pBlockWidth * (lX - 1), pBlockHeight * (lY - 1), 0.0)
        lMax = pWorldMin + vector(pBlockWidth * lX, pBlockHeight * lY, 0.0)
        lResult = BoxOverlapsSphere(lMax, lMin, lCurrentModel.boundingSphere[2], lCurrentModel.boundingSphere[1], 2)
        if lResult then
          lBlockIndex = ((lY - 1) * pHorizontalBlockNum) + (lX - 1) + 1
          if lCurrentModel.userData.IsBig then
            pBlocksBig[lBlockIndex].add(lCurrentModel)
          else
            pBlocks[lBlockIndex].add(lCurrentModel)
          end if
          pBlocksTot[lBlockIndex].add(lCurrentModel)
          if me.CheckIfIncludeIntoRayBlocks(lCurrentModel.name) then
            pRayBlocks[lBlockIndex].add(lCurrentModel)
          end if
          if findPos(lCurrentModel.userData, #BlockList) = VOID then
            lCurrentModel.userData.addProp(#BlockList, [])
          end if
          lCurrentModel.userData.BlockList.add(lBlockIndex)
        end if
      end repeat
    end repeat
  end repeat
  repeat with li = 1 to fCullingModelList.count
    lCurrentModel = fCullingModelList[li]
    pCullingList.add(lCurrentModel)
    lCurrentModel.userData.addProp(#Culled, 0)
    lCurrentModel.userData.setaProp(#parent, lCurrentModel.parent)
    if findPos(lCurrentModel.userData, #BlockList) = VOID then
      lCurrentModel.userData.addProp(#BlockList, [])
    end if
  end repeat
end

on BuildTokenGrid me, fTrackToken
  repeat with lX = 1 to pHorizontalBlockNum
    repeat with lY = 1 to pVerticalBlockNum
      pTokenBlocks.add([])
    end repeat
  end repeat
  repeat with lk = 1 to fTrackToken.count
    lCurrentModel = fTrackToken[lk].model
    lBSphereCenter = lCurrentModel.boundingSphere[1]
    lBSphereRadius = lCurrentModel.boundingSphere[2]
    lMinXIndex = floor((lBSphereCenter.x - lBSphereRadius - pWorldMin.x) / pBlockWidth) + 1
    lMaxXIndex = floor((lBSphereCenter.x + lBSphereRadius - pWorldMin.x) / pBlockWidth) + 1
    lMinYIndex = floor((lBSphereCenter.y - lBSphereRadius - pWorldMin.y) / pBlockHeight) + 1
    lMaxYIndex = floor((lBSphereCenter.y + lBSphereRadius - pWorldMin.y) / pBlockHeight) + 1
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
        lResult = BoxOverlapsSphere(lMax, lMin, lCurrentModel.boundingSphere[2], lCurrentModel.boundingSphere[1], 2)
        if lResult then
          lBlockIndex = ((lY - 1) * pHorizontalBlockNum) + (lX - 1) + 1
          pTokenBlocks[lBlockIndex].add(fTrackToken[lk])
        end if
      end repeat
    end repeat
  end repeat
end

on GetCullerBlockModels me, kPosition
  lBlockX = floor((kPosition.x - pWorldMin.x) / pBlockWidth)
  lBlockY = floor((kPosition.y - pWorldMin.y) / pBlockHeight)
  lBlockIndex = (lBlockY * pHorizontalBlockNum) + lBlockX + 1
  if (lBlockIndex >= 1) and (lBlockIndex <= pBlocksTot.count) then
    lModelList = pBlocksTot[lBlockIndex]
  else
    lModelList = []
  end if
  return lModelList
end

on GetCullerRayBlockModels me, kPosition
  lBlockX = floor((kPosition.x - pWorldMin.x) / pBlockWidth)
  lBlockY = floor((kPosition.y - pWorldMin.y) / pBlockHeight)
  lBlockIndex = (lBlockY * pHorizontalBlockNum) + lBlockX + 1
  if (lBlockIndex >= 1) and (lBlockIndex <= pRayBlocks.count) then
    lModelList = pRayBlocks[lBlockIndex]
  else
    lModelList = []
  end if
  return lModelList
end

on GetCullerBlockTokens me, kPosition
  lBlockX = floor((kPosition.x - pWorldMin.x) / pBlockWidth)
  lBlockY = floor((kPosition.y - pWorldMin.y) / pBlockHeight)
  lBlockIndex = (lBlockY * pHorizontalBlockNum) + lBlockX + 1
  if (lBlockIndex >= 1) and (lBlockIndex <= pTokenBlocks.count) then
    lModelList = pTokenBlocks[lBlockIndex]
  else
    lModelList = []
  end if
  return lModelList
end

on CheckCulling me, kPosition, kSphereRadius
  if (pCheck = 0) or (pUpdateCycles = -1) then
    pCurrentTick = pCurrentTick + 1
    lBSphereCenter = kPosition
    if kSphereRadius = VOID then
      lBSphereRadius = pViewDistance
    else
      lBSphereRadius = kSphereRadius
    end if
    lMinXIndex = floor((lBSphereCenter.x - lBSphereRadius - pWorldMin.x) / pBlockWidth) + 1
    lMaxXIndex = floor((lBSphereCenter.x + lBSphereRadius - pWorldMin.x) / pBlockWidth) + 1
    lMinYIndex = floor((lBSphereCenter.y - lBSphereRadius - pWorldMin.y) / pBlockHeight) + 1
    lMaxYIndex = floor((lBSphereCenter.y + lBSphereRadius - pWorldMin.y) / pBlockHeight) + 1
    lMyXIndex = floor((lBSphereCenter.x - pWorldMin.x) / pBlockWidth) + 1
    lMyYIndex = floor((lBSphereCenter.y - pWorldMin.y) / pBlockHeight) + 1
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
    if lMyXIndex < 1 then
      lMyXIndex = 1
    end if
    if lMyYIndex < 1 then
      lMyYIndex = 1
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
    if lMyXIndex > pHorizontalBlockNum then
      lMyXIndex = pHorizontalBlockNum
    end if
    if lMyYIndex > pVerticalBlockNum then
      lMyYIndex = pVerticalBlockNum
    end if
    lBlockCount = 0
    lu = pcamera.transform.position.duplicate()
    lu.z = 0.0
    lw = pcamera.transform * vector(1.0, pFovRatio, 0.0)
    lw.z = 0.0
    lV = (lu + lw) * 0.5
    lV.z = lV.z + 1.0
    lPlaneNormalA = (lu - lw).crossProduct(lV - lw)
    lPlaneNormalA.normalize()
    lPlaneDistanceA = -lPlaneNormalA.dotProduct(lu)
    lw = pcamera.transform * vector(-1.0, pFovRatio, 0.0)
    lw.z = 0.0
    lV = (lu + lw) * 0.5
    lV.z = lV.z + 1.0
    lPlaneNormalB = (lu - lw).crossProduct(lV - lw)
    lPlaneNormalB.normalize()
    lPlaneDistanceB = -lPlaneNormalB.dotProduct(lu)
    lw = pcamera.transform * vector(-1.0, 0.0, 0.0)
    lw.z = 0.0
    lV = (lu + lw) * 0.5
    lV.z = lV.z + 1.0
    lPlaneNormalC = (lu - lw).crossProduct(lV - lw)
    lPlaneNormalC.normalize()
    lPlaneDistanceC = -lPlaneNormalC.dotProduct(lu)
    repeat with x = lMinXIndex to lMaxXIndex
      repeat with y = lMinYIndex to lMaxYIndex
        lBlockIndex = ((y - 1) * pHorizontalBlockNum) + (x - 1) + 1
        lInclude = 1
        if lInclude then
          lTL = vector(pWorldMin.x + (pBlockWidth * (x - 1)), pWorldMin.y + (pBlockHeight * (y - 1)), 0.0)
          lTR = vector(lTL.x + pBlockWidth, lTL.y, 0.0)
          lBL = vector(lTL.x, lTL.y + pBlockHeight, 0.0)
          lBR = vector(lTL.x + pBlockWidth, lTL.y + pBlockHeight, 0.0)
          lCP = vector(lTL.x + (pBlockWidth * 0.5), lTL.y + (pBlockHeight * 0.5), 0.0)
          lResultA = (lTL.x * lPlaneNormalA.x) + (lTL.y * lPlaneNormalA.y) + (lTL.z * lPlaneNormalA.z) + lPlaneDistanceA
          lResultB = (lTR.x * lPlaneNormalA.x) + (lTR.y * lPlaneNormalA.y) + (lTR.z * lPlaneNormalA.z) + lPlaneDistanceA
          lResultC = (lBL.x * lPlaneNormalA.x) + (lBL.y * lPlaneNormalA.y) + (lBL.z * lPlaneNormalA.z) + lPlaneDistanceA
          lResultD = (lBR.x * lPlaneNormalA.x) + (lBR.y * lPlaneNormalA.y) + (lBR.z * lPlaneNormalA.z) + lPlaneDistanceA
          if (lResultA < 0) and (lResultB < 0) and (lResultC < 0) and (lResultD < 0) then
            lInclude = 0
          end if
          if lInclude then
            lResultA = (lTL.x * lPlaneNormalB.x) + (lTL.y * lPlaneNormalB.y) + (lTL.z * lPlaneNormalB.z) + lPlaneDistanceB
            lResultB = (lTR.x * lPlaneNormalB.x) + (lTR.y * lPlaneNormalB.y) + (lTR.z * lPlaneNormalB.z) + lPlaneDistanceB
            lResultC = (lBL.x * lPlaneNormalB.x) + (lBL.y * lPlaneNormalB.y) + (lBL.z * lPlaneNormalB.z) + lPlaneDistanceB
            lResultD = (lBR.x * lPlaneNormalB.x) + (lBR.y * lPlaneNormalB.y) + (lBR.z * lPlaneNormalB.z) + lPlaneDistanceB
            if (lResultA > 0) and (lResultB > 0) and (lResultC > 0) and (lResultD > 0) then
              lInclude = 0
            end if
          end if
          if lInclude then
            lResultA = (lTL.x * lPlaneNormalC.x) + (lTL.y * lPlaneNormalC.y) + (lTL.z * lPlaneNormalC.z) + lPlaneDistanceC
            lResultB = (lTR.x * lPlaneNormalC.x) + (lTR.y * lPlaneNormalC.y) + (lTR.z * lPlaneNormalC.z) + lPlaneDistanceC
            lResultC = (lBL.x * lPlaneNormalC.x) + (lBL.y * lPlaneNormalC.y) + (lBL.z * lPlaneNormalC.z) + lPlaneDistanceC
            lResultD = (lBR.x * lPlaneNormalC.x) + (lBR.y * lPlaneNormalC.y) + (lBR.z * lPlaneNormalC.z) + lPlaneDistanceC
            if (lResultA > 0) and (lResultB > 0) and (lResultC > 0) and (lResultD > 0) then
              lInclude = 0
            end if
          end if
        end if
        if lInclude then
          CurrentBlockInfo = pBlocksInfo[lBlockIndex]
          lLimitDistanceVector = (lBSphereCenter - lCP) * 0.01
          lLimitDistance = (lLimitDistanceVector.x * lLimitDistanceVector.x) + (lLimitDistanceVector.y * lLimitDistanceVector.y)
          if lLimitDistance < pCullDistance then
            if CurrentBlockInfo.CullingTime < (pCurrentTick - 1) then
              CurrentBlock = pBlocks[lBlockIndex]
              repeat with k = 1 to CurrentBlock.count
                CurrentModel = CurrentBlock[k]
                if CurrentModel.userData.Culled <> pCurrentTick then
                  if not CurrentModel.isInWorld() then
                    CurrentModel.parent = CurrentModel.userData.parent
                  end if
                end if
                CurrentModel.userData.Culled = pCurrentTick
              end repeat
            end if
            CurrentBlockInfo.CullingTime = pCurrentTick
          end if
          if lLimitDistance < pCullDistanceBig then
            if CurrentBlockInfo.CullingTimeBig < (pCurrentTick - 1) then
              CurrentBlock = pBlocksBig[lBlockIndex]
              repeat with k = 1 to CurrentBlock.count
                CurrentModel = CurrentBlock[k]
                if CurrentModel.userData.Culled <> pCurrentTick then
                  if not CurrentModel.isInWorld() then
                    CurrentModel.parent = CurrentModel.userData.parent
                  end if
                end if
                CurrentModel.userData.Culled = pCurrentTick
              end repeat
            end if
            CurrentBlockInfo.CullingTimeBig = pCurrentTick
          end if
          lBlockCount = lBlockCount + 1
        end if
      end repeat
    end repeat
  end if
  pCheck = pCheck + 1
  if pCheck > pCheckSteps then
    pCheck = 0
  end if
  lModelsToRemove = pUpdateCycles
  if lModelsToRemove = -1 then
    lModelsToRemove = pCullingList.count
  end if
  lModelsRemoved = 0
  repeat with i = 1 to lModelsToRemove
    CurrentModel = pCullingList[pCurrentIndex]
    if CurrentModel.isInWorld() then
      if CurrentModel.userData.IsBig = 0 then
        k = 0
        lBlockList = CurrentModel.userData.BlockList
        repeat with j = 1 to lBlockList.count
          if pBlocksInfo[lBlockList[j]].CullingTime < (pCurrentTick - 1) then
            k = k + 1
          end if
        end repeat
        if k >= lBlockList.count then
          CurrentModel.removeFromWorld()
          lModelsRemoved = lModelsRemoved + 1
        end if
      else
        k = 0
        lBlockList = CurrentModel.userData.BlockList
        repeat with j = 1 to lBlockList.count
          if pBlocksInfo[lBlockList[j]].CullingTimeBig < (pCurrentTick - 1) then
            k = k + 1
          end if
        end repeat
        if k >= lBlockList.count then
          CurrentModel.removeFromWorld()
          lModelsRemoved = lModelsRemoved + 1
        end if
      end if
    end if
    pCurrentIndex = pCurrentIndex + 1
    if pCurrentIndex > pCullingList.count then
      pCurrentIndex = 1
    end if
  end repeat
  if (lModelsRemoved > 0) and (pUpdateCycles = -1) then
    pUpdateCycles = 12
  end if
end

on removeModel me, kMdl
  lBlockList = kMdl.userData.getaProp(#BlockList)
  if voidp(lBlockList) then
    return 
  end if
  lRemoveFromRayBlocks = me.CheckIfIncludeIntoRayBlocks(kMdl.name)
  repeat with lBlockIndex in lBlockList
    if kMdl.userData.IsBig then
      pBlocksBig[lBlockIndex].deleteOne(kMdl)
    else
      pBlocks[lBlockIndex].deleteOne(kMdl)
    end if
    pBlocksTot[lBlockIndex].deleteOne(kMdl)
    if lRemoveFromRayBlocks then
      pRayBlocks[lBlockIndex].deleteOne(kMdl)
    end if
  end repeat
  lIdx = 1
  lFound = 0
  repeat with lMdl in pCullingList
    if lMdl = kMdl then
      lFound = 1
      exit repeat
    end if
    lIdx = lIdx + 1
  end repeat
  if lFound then
    pCullingList.deleteAt(lIdx)
    if (lIdx <= pCurrentIndex) and (lIdx > 1) then
      pCurrentIndex = pCurrentIndex - 1
    end if
  end if
end

on RefreshModel me, kModel, kBoundingSphere
  lBlocksRef = kModel.userData.getaProp(#BlockList)
  if voidp(lBlocksRef) then
    put "CullingManager.RefreshModel - model '" & kModel.name & "' is not in culling list"
    return 
  end if
  lOldBlocks = lBlocksRef.duplicate()
  lInRayBlocks = me.CheckIfIncludeIntoRayBlocks(kModel.name)
  lBSphereCenter = kBoundingSphere[1]
  lBSphereRadius = kBoundingSphere[2]
  lMinXIndex = floor((lBSphereCenter.x - lBSphereRadius - pWorldMin.x) / pBlockWidth) + 1
  lMaxXIndex = floor((lBSphereCenter.x + lBSphereRadius - pWorldMin.x) / pBlockWidth) + 1
  lMinYIndex = floor((lBSphereCenter.y - lBSphereRadius - pWorldMin.y) / pBlockHeight) + 1
  lMaxYIndex = floor((lBSphereCenter.y + lBSphereRadius - pWorldMin.y) / pBlockHeight) + 1
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
  lNewBlocks = [:]
  repeat with lX = lMinXIndex to lMaxXIndex
    repeat with lY = lMinYIndex to lMaxYIndex
      lMin = pWorldMin + vector(pBlockWidth * (lX - 1), pBlockHeight * (lY - 1), 0.0)
      lMax = pWorldMin + vector(pBlockWidth * lX, pBlockHeight * lY, 0.0)
      lResult = BoxOverlapsSphere(lMax, lMin, kBoundingSphere[2], kBoundingSphere[1], 2)
      if lResult then
        lBlockIndex = ((lY - 1) * pHorizontalBlockNum) + (lX - 1) + 1
        lNewBlocks.addProp(lBlockIndex, lBlockIndex)
      end if
    end repeat
  end repeat
  lNewBlocks.sort()
  lCounter = 0
  repeat with lBlockIdx in lOldBlocks
    lFound = not voidp(lNewBlocks.getaProp(lBlockIdx))
    if not lFound then
      if kModel.userData.IsBig then
        pBlocksBig[lBlockIdx].deleteOne(kModel)
      else
        pBlocks[lBlockIdx].deleteOne(kModel)
      end if
      pBlocksTot[lBlockIdx].deleteOne(kModel)
      if lInRayBlocks then
        pRayBlocks[lBlockIdx].deleteOne(kModel)
      end if
      lBlocksRef.deleteOne(lBlockIdx)
      next repeat
    end if
    lCounter = lCounter + 1
  end repeat
  if lCounter <> lNewBlocks.count then
    repeat with lBlockIdx in lNewBlocks
      lAlreadyInList = 0
      repeat with lOtherIdx in lBlocksRef
        if lOtherIdx = lBlockIdx then
          lAlreadyInList = 1
          exit repeat
        end if
      end repeat
      if not lAlreadyInList then
        if kModel.userData.IsBig then
          pBlocksBig[lBlockIdx].add(kModel)
        else
          pBlocks[lBlockIdx].add(kModel)
        end if
        pBlocksTot[lBlockIdx].add(kModel)
        if lInRayBlocks then
          pRayBlocks[lBlockIdx].add(kModel)
        end if
        lBlocksRef.add(lBlockIdx)
      end if
    end repeat
  end if
end

on InsertModel me, kModel, kBoundingSphere
  if voidp(kBoundingSphere) then
    lBoundingSphere = kModel.boundingSphere
  else
    lBoundingSphere = kBoundingSphere
  end if
  lBSphereCenter = lBoundingSphere[1]
  lBSphereRadius = lBoundingSphere[2]
  lMinXIndex = floor((lBSphereCenter.x - lBSphereRadius - pWorldMin.x) / pBlockWidth) + 1
  lMaxXIndex = floor((lBSphereCenter.x + lBSphereRadius - pWorldMin.x) / pBlockWidth) + 1
  lMinYIndex = floor((lBSphereCenter.y - lBSphereRadius - pWorldMin.y) / pBlockHeight) + 1
  lMaxYIndex = floor((lBSphereCenter.y + lBSphereRadius - pWorldMin.y) / pBlockHeight) + 1
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
  kModel.userData.setaProp(#IsBig, 0)
  if lBoundingSphere[2] > pBigThreshold then
    kModel.userData.IsBig = 1
  end if
  lHowManyCellX = lMaxXIndex - lMinXIndex + 1
  lHowManyCellY = lMaxYIndex - lMinYIndex + 1
  if ((lHowManyCellX > 5) or (lHowManyCellY > 5)) and pverbosemode then
    put "CullingManager.InsertModel - pay attention: " & kModel.name & " CellX: " & lHowManyCellX & " CellY: " & lHowManyCellY
  end if
  lInsertInRayBlocks = me.CheckIfIncludeIntoRayBlocks(kModel.name)
  repeat with lX = lMinXIndex to lMaxXIndex
    repeat with lY = lMinYIndex to lMaxYIndex
      lMin = pWorldMin + vector(pBlockWidth * (lX - 1), pBlockHeight * (lY - 1), 0.0)
      lMax = pWorldMin + vector(pBlockWidth * lX, pBlockHeight * lY, 0.0)
      lResult = BoxOverlapsSphere(lMax, lMin, lBoundingSphere[2], lBoundingSphere[1], 2)
      if lResult then
        lBlockIndex = ((lY - 1) * pHorizontalBlockNum) + (lX - 1) + 1
        if kModel.userData.IsBig then
          pBlocksBig[lBlockIndex].add(kModel)
        else
          pBlocks[lBlockIndex].add(kModel)
        end if
        pBlocksTot[lBlockIndex].add(kModel)
        if lInsertInRayBlocks then
          pRayBlocks[lBlockIndex].add(kModel)
        end if
        if findPos(kModel.userData, #BlockList) = VOID then
          kModel.userData.addProp(#BlockList, [])
        end if
        kModel.userData.BlockList.add(lBlockIndex)
      end if
    end repeat
  end repeat
  pCullingList.add(kModel)
  kModel.userData.setaProp(#Culled, 0)
  kModel.userData.setaProp(#parent, kModel.parent)
end

on ResetCulling me
  if pBlocks = [] then
    return 
  end if
  pCurrentTick = pTimeSource.GetTime()
  repeat with x = 1 to pHorizontalBlockNum
    repeat with y = 1 to pVerticalBlockNum
      lCurrentBlock = pBlocksTot[((y - 1) * pHorizontalBlockNum) + (x - 1) + 1]
      repeat with k = 1 to lCurrentBlock.count
        lCurrentModel = lCurrentBlock[k]
        if not lCurrentModel.isInWorld() then
          lCurrentModel.parent = lCurrentModel.userData.parent
        end if
        lCurrentModel.userData.Culled = pCurrentTick
      end repeat
    end repeat
  end repeat
end

on RemoveAllModels me
  if pBlocks = [] then
    return 
  end if
  pCurrentTick = pTimeSource.GetTime()
  repeat with x = 1 to pHorizontalBlockNum
    repeat with y = 1 to pVerticalBlockNum
      lCurrentBlock = pBlocksTot[((y - 1) * pHorizontalBlockNum) + (x - 1) + 1]
      repeat with k = 1 to lCurrentBlock.count
        lCurrentModel = lCurrentBlock[k]
        if lCurrentModel.isInWorld() then
          lCurrentModel.removeFromWorld()
        end if
        lCurrentModel.userData.Culled = pCurrentTick
      end repeat
    end repeat
  end repeat
end
