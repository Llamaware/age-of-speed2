property pForcedBonusActDist, pForcedBonusRespawnTime
global gGame

on new me
  return me
end

on SetForcedBonusActDist me, kActivationDistance
  pForcedBonusActDist = kActivationDistance
end

on SetForcedBonusRespawnTime me, kRespawnTime
  pForcedBonusRespawnTime = kRespawnTime
end

on LoadResources me, kResourceFileName, kConfiguration, kForceImportMethod
  lMethod = #fromCastMember
  if kConfiguration = #debug then
    lMethod = #readFile
  end if
  if not voidp(kForceImportMethod) then
    if kForceImportMethod = #readFile then
      lMethod = #readFile
    else
      if kForceImportMethod = #importFileInto then
        lMethod = #importFileInto
      else
        lMethod = #fromCastMember
      end if
    end if
  end if
  if lMethod = #fromCastMember then
    lString = member(kResourceFileName).text
  else
    if lMethod = #importFileInto then
      kResourceFileName = "data/" & kResourceFileName & ".txt"
      lResourceFileMember = member(99).importFileInto(kResourceFileName)
      lString = member(99).text
    else
      if lMethod = #readFile then
        kResourceFileName = "data/" & kResourceFileName & ".txt"
        lFileIoObj = new xtra("fileio")
        lFileIoObj.openfile(kResourceFileName, 1)
        lErrorCode = lFileIoObj.status()
        if lErrorCode <> 0 then
          lFileIoObj.createFile(kResourceFileName)
          lFileIoObj.openfile(kResourceFileName, 1)
          lString = EMPTY
        else
          lString = lFileIoObj.readFile()
        end if
      end if
    end if
  end if
  lTempExplosiveObject = 0
  lPathPoint3DId = 0
  lLabel = VOID
  gCarPaths = [:]
  lIndex = 0
  repeat while 1
    lWordResult = me.readWord(lString, lIndex + 1)
    lstrToken = lWordResult[1]
    lIndex = lWordResult[2]
    lCode = lWordResult[3]
    if lCode = #endstring then
      exit repeat
    end if
    case lstrToken of
      "--":
        lCheckEndLine = 1
        repeat while lCheckEndLine
          lWordResult = me.readWord(lString, lIndex + 1)
          lIndex = lWordResult[2]
          lCode = lWordResult[3]
          if lCode = #newline then
            lCheckEndLine = 0
          end if
        end repeat
      "fac", "facePosition":
        lCheckEndLine = 1
        repeat while lCheckEndLine
          lWordResult = me.readWord(lString, lIndex + 1)
          lIndex = lWordResult[2]
          lCode = lWordResult[3]
          if lCode = #newline then
            lCheckEndLine = 0
          end if
        end repeat
      "ckl":
        lWordResult = me.readWord(lString, lIndex + 1)
        lIndex = lWordResult[2]
        lLabelLowCase = lWordResult[1]
        lWordResult = me.readWord(lString, lIndex + 1)
        lIndex = lWordResult[2]
        lNameResource = lWordResult[1]
        lWordResult = me.readWord(lString, lIndex + 1)
        lIndex = lWordResult[2]
        lXa = float(lWordResult[1])
        lWordResult = me.readWord(lString, lIndex + 1)
        lIndex = lWordResult[2]
        lYa = float(lWordResult[1])
        lWordResult = me.readWord(lString, lIndex + 1)
        lIndex = lWordResult[2]
        lXb = float(lWordResult[1])
        lWordResult = me.readWord(lString, lIndex + 1)
        lIndex = lWordResult[2]
        lYb = float(lWordResult[1])
        lWordResult = me.readWord(lString, lIndex + 1)
        lIndex = lWordResult[2]
        lActionFront = lWordResult[1]
        lWordResult = me.readWord(lString, lIndex + 1)
        lIndex = lWordResult[2]
        lActionBack = lWordResult[1]
        lWordResult = me.readWord(lString, lIndex + 1)
        lIndex = lWordResult[2]
        lWidthIncrement = float(lWordResult[1])
        lWordResult = me.readWord(lString, lIndex + 1)
        lIndex = lWordResult[2]
        lTokenId = lWordResult[1]
        lActionFront = symbol(lActionFront)
        lActionBack = symbol(lActionBack)
        gGame.GetChecklineManager().add(gGame.GetTokenManager().GetTrackTokens(), lTokenId, lLabelLowCase, vector(lXa, lYa, 0.0), vector(lXb, lYb, 0.0), lActionFront, lActionBack, VOID, VOID)
      "ckp":
        lWordResult = me.readWord(lString, lIndex + 1)
        lIndex = lWordResult[2]
        lLabelLowCase = lWordResult[1]
        lWordResult = me.readWord(lString, lIndex + 1)
        lIndex = lWordResult[2]
        lNameResource = lWordResult[1]
        lWordResult = me.readWord(lString, lIndex + 1)
        lIndex = lWordResult[2]
        lX = float(lWordResult[1])
        lWordResult = me.readWord(lString, lIndex + 1)
        lIndex = lWordResult[2]
        lY = float(lWordResult[1])
        lWordResult = me.readWord(lString, lIndex + 1)
        lIndex = lWordResult[2]
        lZ = float(lWordResult[1])
        lWordResult = me.readWord(lString, lIndex + 1)
        lIndex = lWordResult[2]
        lRadius = float(lWordResult[1])
        lWordResult = me.readWord(lString, lIndex + 1)
        lIndex = lWordResult[2]
        lActive = lWordResult[1]
        lWordResult = me.readWord(lString, lIndex + 1)
        lIndex = lWordResult[2]
        lActionIn = lWordResult[1]
        lWordResult = me.readWord(lString, lIndex + 1)
        lIndex = lWordResult[2]
        lActionOut = lWordResult[1]
        lWordResult = me.readWord(lString, lIndex + 1)
        lIndex = lWordResult[2]
        lTokenId = lWordResult[1]
        lActionIn = ConvertCheckpointActions(lActionIn)
        lActionOut = ConvertCheckpointActions(lActionOut)
        gGame.GetCheckpointManager().add(lNameResource, vector(lX, lY, lZ), lRadius, 1, lActionIn, lActionOut, VOID, VOID, VOID, #cylindric)
      "posit":
        lWordResult = me.readWord(lString, lIndex + 1)
        lIndex = lWordResult[2]
        lLabelLowCase = lWordResult[1]
        lWordResult = me.readWord(lString, lIndex + 1)
        lIndex = lWordResult[2]
        lNameResource = lWordResult[1]
        lWordResult = me.readWord(lString, lIndex + 1)
        lIndex = lWordResult[2]
        lX = float(lWordResult[1])
        lWordResult = me.readWord(lString, lIndex + 1)
        lIndex = lWordResult[2]
        lY = float(lWordResult[1])
        lWordResult = me.readWord(lString, lIndex + 1)
        lIndex = lWordResult[2]
        lZ = float(lWordResult[1])
        lWordResult = me.readWord(lString, lIndex + 1)
        lIndex = lWordResult[2]
        lTokenId = lWordResult[1]
        lUserDataStr = EMPTY
        lUserDataToRead = 1
        repeat while lUserDataToRead
          lWordResult = me.readWord(lString, lIndex + 1)
          lIndex = lWordResult[2]
          lCode = lWordResult[3]
          lUserDataStr = lUserDataStr & lWordResult[1]
          if (lCode = #newline) or (lCode = #endstring) then
            lUserDataToRead = 0
            if lCode = #endstring then
              lIndex = lIndex - 1
            end if
          end if
        end repeat
        lPosUserData = [:]
        if lUserDataStr <> "#NoUserData" then
          lPosUserData = ParseUserData(lUserDataStr)
        end if
      "bon":
        lInitialIndex = lIndex
        lWordResult = me.readWord(lString, lIndex + 1)
        lNumWords = 1
        lCode = lWordResult[3]
        repeat while (lCode <> #newline) and (lCode <> #endstring)
          lWordResult = me.readWord(lString, lIndex + 1)
          lCode = lWordResult[3]
          lIndex = lWordResult[2]
          lNumWords = lNumWords + 1
        end repeat
        lIndex = lInitialIndex
        lWordResult = me.readWord(lString, lIndex + 1)
        lIndex = lWordResult[2]
        lLabelLowCase = lWordResult[1]
        lWordResult = me.readWord(lString, lIndex + 1)
        lIndex = lWordResult[2]
        lNameResource = lWordResult[1]
        lWordResult = me.readWord(lString, lIndex + 1)
        lIndex = lWordResult[2]
        lBonusModel = lWordResult[1]
        lWordResult = me.readWord(lString, lIndex + 1)
        lIndex = lWordResult[2]
        lX = float(lWordResult[1])
        lWordResult = me.readWord(lString, lIndex + 1)
        lIndex = lWordResult[2]
        lY = float(lWordResult[1])
        lWordResult = me.readWord(lString, lIndex + 1)
        lIndex = lWordResult[2]
        lZ = float(lWordResult[1])
        lWordResult = me.readWord(lString, lIndex + 1)
        lIndex = lWordResult[2]
        lActDistance = float(lWordResult[1])
        lWordResult = me.readWord(lString, lIndex + 1)
        lIndex = lWordResult[2]
        lRespawn = integer(lWordResult[1])
        lWordResult = me.readWord(lString, lIndex + 1)
        lIndex = lWordResult[2]
        lZpos = float(lWordResult[1])
        lWordResult = me.readWord(lString, lIndex + 1)
        lIndex = lWordResult[2]
        lZoffset = float(lWordResult[1])
        lWordResult = me.readWord(lString, lIndex + 1)
        lIndex = lWordResult[2]
        lMove = lWordResult[1]
        lWordResult = me.readWord(lString, lIndex + 1)
        lIndex = lWordResult[2]
        lOrient = lWordResult[1]
        lWordResult = me.readWord(lString, lIndex + 1)
        lIndex = lWordResult[2]
        lOrientation = lWordResult[1]
        lWordResult = me.readWord(lString, lIndex + 1)
        lIndex = lWordResult[2]
        lRemove = lWordResult[1]
        lWordResult = me.readWord(lString, lIndex + 1)
        lIndex = lWordResult[2]
        lShadowZ = float(lWordResult[1])
        if lNumWords = 18 then
          lWordResult = me.readWord(lString, lIndex + 1)
          lIndex = lWordResult[2]
          lCustomRotation = float(lWordResult[1])
        else
          lCustomRotation = 0.0
        end if
        lWordResult = me.readWord(lString, lIndex + 1)
        lIndex = lWordResult[2]
        lTokenIndex = lWordResult[1]
        if lMove = "true" then
          lMove = 1
        else
          lMove = 0
        end if
        if lOrient = "true" then
          lOrient = 1
        else
          lOrient = 0
        end if
        if lRemove = "true" then
          lRemove = 1
        else
          lRemove = 0
        end if
        if not voidp(pForcedBonusActDist) then
          lActDistance = pForcedBonusActDist
        end if
        if not voidp(pForcedBonusRespawnTime) then
          lRespawn = pForcedBonusRespawnTime
        end if
        gGame.GetBonusManager().AddBonus(vector(lX, lY, lZ), lTokenIndex, lBonusModel, lActDistance, lRespawn, lZpos, lZoffset, lMove, lOrient, lOrientation, lRemove, lShadowZ, lCustomRotation, [:])
      "obj":
        lWordResult = me.readWord(lString, lIndex + 1)
        lIndex = lWordResult[2]
        lLabelLowCase = lWordResult[1]
        lWordResult = me.readWord(lString, lIndex + 1)
        lIndex = lWordResult[2]
        lNameResource = lWordResult[1]
        lWordResult = me.readWord(lString, lIndex + 1)
        lIndex = lWordResult[2]
        lX = float(lWordResult[1])
        lWordResult = me.readWord(lString, lIndex + 1)
        lIndex = lWordResult[2]
        lY = float(lWordResult[1])
        lWordResult = me.readWord(lString, lIndex + 1)
        lIndex = lWordResult[2]
        lZ = float(lWordResult[1])
        lWordResult = me.readWord(lString, lIndex + 1)
        lIndex = lWordResult[2]
        lModel = lWordResult[1]
        lWordResult = me.readWord(lString, lIndex + 1)
        lIndex = lWordResult[2]
        lRotation = float(lWordResult[1])
        lWordResult = me.readWord(lString, lIndex + 1)
        lIndex = lWordResult[2]
        lRemove = lWordResult[1]
        if lRemove = "true" then
          lRemove = 1
        else
          lRemove = 0
        end if
        lWordResult = me.readWord(lString, lIndex + 1)
        lIndex = lWordResult[2]
        lTokenId = lWordResult[1]
        lTempExplosiveObject = lTempExplosiveObject + 1
        lExplosiveObjectPosition = vector(lX, lY, lZ)
        lRadius = 600
        lRotationVector = vector(0.0, 0.0, lRotation)
        lOneShoot = 0
        lUserData = VOID
        call(#AddExplosiveObject, gGame.GetGameplay(), lExplosiveObjectPosition, lRadius, lRotationVector, lModel, lOneShoot, 30000, lUserData)
      "pat":
        lWordResult = me.readWord(lString, lIndex + 1)
        lIndex = lWordResult[2]
        lLabelLowCase = lWordResult[1]
        lWordResult = me.readWord(lString, lIndex + 1)
        lIndex = lWordResult[2]
        lNameResource = lWordResult[1]
        lWordResult = me.readWord(lString, lIndex + 1)
        lIndex = lWordResult[2]
        lLoop = lWordResult[1]
        lWordResult = me.readWord(lString, lIndex + 1)
        lIndex = lWordResult[2]
        lSnap = lWordResult[1]
        lLabel = lNameResource
        lPathName = lLabelLowCase
        gCarPaths.addProp(lPathName, [])
      "pointPath":
        lPathId = lLabelLowCase
        lPathPoint3DId = lPathPoint3DId + 1
        lWordResult = me.readWord(lString, lIndex + 1)
        lIndex = lWordResult[2]
        lTokenId = integer(lWordResult[1])
        lWordResult = me.readWord(lString, lIndex + 1)
        lIndex = lWordResult[2]
        lLongitudinalA = float(lWordResult[1])
        lWordResult = me.readWord(lString, lIndex + 1)
        lIndex = lWordResult[2]
        lLongitudinalB = float(lWordResult[1])
        lWordResult = me.readWord(lString, lIndex + 1)
        lIndex = lWordResult[2]
        lTrasversal = float(lWordResult[1])
        lPathName = lLabel
        lPathElem = [#t: lTokenId, #a: lLongitudinalA, #b: lLongitudinalB, #L: lTrasversal]
        gCarPaths[lPathName].add(lPathElem)
    end case
  end repeat
  if lMethod = #readFile then
    lFileIoObj.closeFile()
  end if
end

on readWord me, fString, fI
  li = fI
  lReturnString = EMPTY
  lReturnCode = #none
  repeat while 1
    lChar = chars(fString, li, li)
    if li > fString.length then
      lReturnCode = #endstring
    else
      if lChar = RETURN then
        lReturnCode = #newline
        if li < fString.length then
          if chars(fString, li + 1, li + 1) = numToChar(10) then
            li = li + 1
          end if
        end if
      else
        if lChar = " " then
          lReturnCode = #space
        end if
      end if
    end if
    if lReturnCode <> #none then
      exit repeat
    end if
    lReturnString = lReturnString & lChar
    li = li + 1
  end repeat
  return [lReturnString, li, lReturnCode]
end
