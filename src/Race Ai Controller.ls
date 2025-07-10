property ancestor, pPlayerRef, pAIType, pActive, pAcceleration, pSteering, pCPUMinLookahead, pCPUSpeedLookaheadFactor, pDistanceForBestTrasversal, pCurrentToken, pBestTrasversal, pTargetTrasversal, pTargetPosition, pBrakeFactor, pTargetTrasversalStep, pBestTrasversalSmoothCoeff, pMinTargetTrasversal, pMaxTargetTrasversal, pAccelerationCircleRatio, pTargetModel, pTakeRightSideMinTrasversalLimit, pTakeRightSideMaxTrasversalLimit
global gGame

on new me, kPlayerRef, kAIType, kAiConfsetsDriveData
  lMyFSM = script("FSM").new()
  lMyFSM.AddState(#VoidState, #VoidEnter, #VoidExec, #VoidExit, script("Void state"))
  lMyFSM.AddState(#AiSimple, #AiSimpleEnter, #AiSimpleExec, #AiSimpleExit, me)
  lMyFSM.AddState(#CheckOthers, #CheckOthersEnter, #CheckOthersExec, #CheckOthersExit, me)
  lMyFSM.AddState(#HighWay, #HighWayEnter, #HighWayExec, #HighWayExit, me)
  me.ancestor = script("FSM object").new(lMyFSM, #VoidState)
  pPlayerRef = kPlayerRef
  pAIType = kAIType
  pCPUMinLookahead = kAiConfsetsDriveData.CPUMinLookahead
  pCPUSpeedLookaheadFactor = kAiConfsetsDriveData.CPUSpeedLookaheadFactor
  pActive = 0
  pDistanceForBestTrasversal = -1
  if not (kAiConfsetsDriveData.findPos("DistanceForBestTrasversal") = VOID) then
    pDistanceForBestTrasversal = kAiConfsetsDriveData.DistanceForBestTrasversal
  end if
  me.Initialize()
  return me
end

on Initialize me
  pAcceleration = 0.0
  pSteering = 0.0
  pBrakeFactor = 0.0
  pBestTrasversal = 0.0
  pTargetTrasversal = 0.0
  pTargetTrasversalStep = 1.30000000000000004
  pBestTrasversalSmoothCoeff = 8.0
  pMinTargetTrasversal = -0.80000000000000004
  pMaxTargetTrasversal = 0.80000000000000004
  pAccelerationCircleRatio = 1.0
  pTakeRightSideMaxTrasversalLimit = 0.75
  pTakeRightSideMinTrasversalLimit = -0.75
  if pAIType = #AiSimple then
    me.ChangeState(#AiSimple, gGame.GetTimeManager().GetTime())
  else
    if pAIType = #CheckOthers then
      me.ChangeState(#CheckOthers, gGame.GetTimeManager().GetTime())
    else
      if pAIType = #HighWay then
        me.ChangeState(#HighWay, gGame.GetTimeManager().GetTime())
      end if
    end if
  end if
end

on GetRacePlayer me
  return pPlayerRef
end

on GetAcceleration me
  return pAcceleration
end

on GetSteering me
  return pSteering
end

on GetTargetTrasversal me
  return pTargetTrasversal
end

on GetCPUMinLookahead me
  return pCPUMinLookahead
end

on GetCPUSpeedLookaheadFactor me
  return pCPUSpeedLookaheadFactor
end

on GetAccelerationCircleRatio me
  return pAccelerationCircleRatio
end

on GetTargetPosition me
  return pTargetPosition
end

on GetBestTrasversal me
  return pBestTrasversal
end

on GetBrakeFactor me
  return pBrakeFactor
end

on SetAcceleration me, kAcceleration
  pAcceleration = kAcceleration
end

on SetSteering me, kSteering
  pSteering = kSteering
end

on SetActive me, kValue
  pActive = kValue
end

on SetTargetTrasversal me, kTrasversal
  pTargetTrasversal = kTrasversal
end

on SetTargetPosition me, kPosition
  pTargetPosition = kPosition
end

on SetPlayerRef me, kPlayerRef
  pPlayerRef = kPlayerRef
end

on SetTargetTrasversalStep me, kTargetTrasversalStep
  pTargetTrasversalStep = kTargetTrasversalStep
end

on SetBestTrasversalSmoothCoeff me, kBestTrasversalSmoothCoeff
  pBestTrasversalSmoothCoeff = kBestTrasversalSmoothCoeff
end

on SetDistanceForBestTrasversal me, kDistanceForBestTrasversal
  pDistanceForBestTrasversal = kDistanceForBestTrasversal
end

on SetMinTargetTrasversal me, kMinTargetTrasversal
  pMinTargetTrasversal = kMinTargetTrasversal
end

on SetMaxTargetTrasversal me, kMaxTargetTrasversal
  pMaxTargetTrasversal = kMaxTargetTrasversal
end

on SetBrakeFactor me, kBrakeFactor
  pBrakeFactor = kBrakeFactor
end

on SetAccelerationCircleRatio me, kAccelerationCircleRatio
  pAccelerationCircleRatio = kAccelerationCircleRatio
end

on SetTakeRightSideMinTrasversalLimit me, kValue
  pTakeRightSideMinTrasversalLimit = kValue
end

on SetTakeRightSideMaxTrasversalLimit me, kValue
  pTakeRightSideMaxTrasversalLimit = kValue
end

on SetBestTrasversal me, kValue
  pBestTrasversal = kValue
end

on IsActive me
  return pActive
end

on AiSimpleEnter me, kEntity, kTime
end

on AiSimpleExec me, kEntity, kTime
  lLateralFactor = 1.0
  pCurrentToken = pPlayerRef.GetCurrentToken()
  lLongitudinal = pPlayerRef.GetLongitudinal()
  lTrasversal = pPlayerRef.GetTrasversal()
  lSpeedKmh = pPlayerRef.GetSpeedKmh()
  if (not (pBestTrasversal < 0) or (pBestTrasversal = -1000)) and (lTrasversal < -0.80000000000000004) then
    lCorrectLateralFactor = 1
  end if
  if not (pBestTrasversal > 0) and (lTrasversal > 0.80000000000000004) then
    lCorrectLateralFactor = 1
  end if
  if lCorrectLateralFactor then
    lTrasversalAbs = abs(lTrasversal)
    lLateralFactor = ((0.20000000000000001 - (lTrasversalAbs - 0.80000000000000004)) / 0.20000000000000001) + 0.10000000000000001
    lLateralFactor = Clamp(lLateralFactor, 0.20000000000000001, 1.0)
  end if
  lLookaheadDistance = (pCPUMinLookahead + (abs(lSpeedKmh) * pCPUSpeedLookaheadFactor)) * lLateralFactor
  if pDistanceForBestTrasversal = -1 then
    pBestTrasversal = 0
  else
    pBestTrasversal = gGame.GetTokenManager().GetBestTrasversal(pCurrentToken, lLongitudinal, pDistanceForBestTrasversal)
  end if
  pTargetPosition = gGame.GetTokenManager().GetTargetPosition(pCurrentToken, lLongitudinal, lLookaheadDistance, pBestTrasversal)
end

on AiSimpleExit me, kEntity, kTime
end

on CheckOthersEnter me, kEntity, kTime
end

on CheckOthersExec me, kEntity, kTime
  pCurrentToken = pPlayerRef.GetCurrentToken()
  lLongitudinal = pPlayerRef.GetLongitudinal()
  lTrasversal = pPlayerRef.GetTrasversal()
  if pTargetTrasversal = -1000 then
    pTargetTrasversal = lTrasversal
    pBestTrasversal = lTrasversal
  end if
  lSpeedKmh = pPlayerRef.GetSpeedKmh()
  lLateralFactor = 1.0
  lCorrectLateralFactor = 0
  if not pPlayerRef.GetVehicle().IsOutTrack() then
    lLookaheadDistance = pCPUMinLookahead + (abs(lSpeedKmh) * pCPUSpeedLookaheadFactor)
    lBrakeFactor = 0.0
    lCarOnHeadDiffTrasv = 0
    lCarOnHead = [0.0, 0.0, 0.0]
    lCarOnSides = [0.0, 0.0]
    lMyOBB = pPlayerRef.GetVehicle().GetOBB()
    if voidp(lMyOBB) then
      return 
    end if
    if pDistanceForBestTrasversal = -1 then
      pBestTrasversal = 0
    else
      pBestTrasversal = gGame.GetTokenManager().GetBestTrasversal(pCurrentToken, lLongitudinal, pDistanceForBestTrasversal)
    end if
    if pBestTrasversal = -1000 then
      pBestTrasversal = 0.0
      lLateralFactor = 0.75
    end if
    lCPUTrackPos = pPlayerRef.GetTrackPos()
    lCPULength = lMyOBB.e[2]
    lPlayers = gGame.GetPlayers()
    repeat with lCarRef in lPlayers
      if lCarRef = pPlayerRef then
        next repeat
      end if
      lCollision = 0
      lCarTrackPos = lCarRef.GetTrackPos()
      lCarTrasversal = lCarRef.GetTrasversal()
      lCarSpeed = lCarRef.GetSpeed()
      lCarOBB = lCarRef.GetVehicle().GetOBB()
      if voidp(lCarOBB) then
        next repeat
      end if
      lCarLength = lCarOBB.e[2]
      lToCarOffset = integer(lCPUTrackPos - lCarTrackPos)
      lToCarDistance = abs(lToCarOffset)
      lToCarTrasversal = lTrasversal - lCarTrasversal
      lSpeedDiff = pPlayerRef.GetSpeed() - lCarSpeed
      if lToCarDistance <= (lCPULength + lCarLength) then
        if abs(lToCarTrasversal) < 0.90000000000000002 then
          if lToCarTrasversal >= 0.0 then
            if lCarOnSides[1] <> 0 then
              lCarOnSides[1] = min(lCarOnSides[1], abs(lToCarTrasversal))
            else
              lCarOnSides[1] = abs(lToCarTrasversal)
            end if
          else
            if lCarOnSides[2] <> 0 then
              lCarOnSides[2] = min(lCarOnSides[2], abs(lToCarTrasversal))
            else
              lCarOnSides[2] = abs(lToCarTrasversal)
            end if
          end if
          if (abs(lToCarTrasversal) < 0.28999999999999998) and (lCarSpeed > 50.0) then
            lCollision = 1
          end if
        end if
      end if
      lDistanceFactor = 1.0
      if (lToCarOffset < -(lCPULength + lCarLength)) and (lToCarOffset > (-4500 * lDistanceFactor)) then
        if abs(lToCarTrasversal) <= 0.40000000000000002 then
          if (lSpeedDiff > 5.0) or (lToCarOffset > -1200.0) then
            if lCarOnHead[1] <> 0 then
              if (lToCarOffset - lCarLength) > lCarOnHead[1] then
                lCarOnHead[1] = lToCarOffset - lCarLength
                lCarOnHeadDiffTrasv = lToCarTrasversal
              end if
            else
              lCarOnHead[1] = lToCarOffset - lCarLength
              lCarOnHeadDiffTrasv = lToCarTrasversal
            end if
            if lToCarOffset > -1000 then
              lBrakeFactor = -0.17999999999999999
            end if
          end if
          next repeat
        end if
        if (lToCarTrasversal > 0.40000000000000002) and (lToCarTrasversal < 0.94999999999999996) then
          if lSpeedDiff > 0 then
            if lCarOnHead[2] <> 0 then
              lCarOnHead[2] = max(lCarOnHead[2], lToCarOffset - lCarLength)
            else
              lCarOnHead[2] = lToCarOffset - lCarLength
            end if
          end if
          next repeat
        end if
        if (lToCarTrasversal < -0.40000000000000002) and (lToCarTrasversal > -0.94999999999999996) then
          if lSpeedDiff > 0 then
            if lCarOnHead[3] <> 0 then
              lCarOnHead[3] = max(lCarOnHead[3], lToCarOffset - lCarLength)
              next repeat
            end if
            lCarOnHead[3] = lToCarOffset - lCarLength
          end if
        end if
      end if
    end repeat
    lTakeRightSide = not ((lCarOnSides[2] <> 0.0) and (lCarOnSides[2] < 0.45000000000000001)) and (lTrasversal < pTakeRightSideMaxTrasversalLimit) and (((lCarOnSides[1] <> 0.0) and (lCarOnSides[1] < 0.45000000000000001)) or ((lCarOnHead[1] <> 0.0) and (((lCarOnHead[3] <> 0.0) and (lCarOnHead[3] < lCarOnHead[1])) or (lCarOnHead[3] = 0.0))))
    lTakeLeftSide = not ((lCarOnSides[1] <> 0.0) and (lCarOnSides[1] < 0.45000000000000001)) and (lTrasversal > pTakeRightSideMinTrasversalLimit) and (((lCarOnSides[2] <> 0.0) and (lCarOnSides[2] < 0.45000000000000001)) or ((lCarOnHead[1] <> 0.0) and (((lCarOnHead[2] <> 0.0) and (lCarOnHead[2] < lCarOnHead[1])) or (lCarOnHead[2] = 0.0))))
    if lTakeRightSide and lTakeLeftSide then
      if ((lCarOnHead[3] <> 0.0) and (lCarOnHead[2] <> 0.0) and (lCarOnHead[3] < lCarOnHead[2])) or ((lCarOnHead[3] = 0.0) and (lCarOnHeadDiffTrasv >= 0)) then
        pTargetTrasversal = pTargetTrasversal + (gGame.GetHavokPhysics().GetTimeStep() * pTargetTrasversalStep)
      else
        pTargetTrasversal = pTargetTrasversal - (gGame.GetHavokPhysics().GetTimeStep() * pTargetTrasversalStep)
      end if
    else
      if lTakeRightSide then
        pTargetTrasversal = pTargetTrasversal + (gGame.GetHavokPhysics().GetTimeStep() * pTargetTrasversalStep)
      else
        if lTakeLeftSide then
          pTargetTrasversal = pTargetTrasversal - (gGame.GetHavokPhysics().GetTimeStep() * pTargetTrasversalStep)
        else
          if lCarOnHead[1] <> 0.0 then
            lBrakeFactor = -0.17999999999999999
          else
            if (lCarOnSides[1] = 0.0) and (lCarOnSides[2] = 0.0) and (lCarOnHead[1] = 0.0) and (lCarOnHead[3] = 0.0) and (lCarOnHead[2] = 0.0) then
              pTargetTrasversal = pTargetTrasversal + ((pBestTrasversal - pTargetTrasversal) * gGame.GetHavokPhysics().GetTimeStep() * pBestTrasversalSmoothCoeff)
            end if
          end if
        end if
      end if
    end if
    if lLateralFactor = 1.0 then
      if (not (pBestTrasversal < 0) or (pBestTrasversal = -1000)) and (lTrasversal < -0.80000000000000004) then
        lCorrectLateralFactor = 1
      end if
      if not (pBestTrasversal > 0) and (lTrasversal > 0.80000000000000004) then
        lCorrectLateralFactor = 1
      end if
      if lCorrectLateralFactor then
        lTrasversalAbs = abs(lTrasversal)
        lLateralFactor = ((0.20000000000000001 - (lTrasversalAbs - 0.80000000000000004)) / 0.20000000000000001) + 0.10000000000000001
        lLateralFactor = Clamp(lLateralFactor, 0.20000000000000001, 1.0)
      end if
    end if
    pTargetTrasversal = Clamp(pTargetTrasversal, pMinTargetTrasversal, pMaxTargetTrasversal)
  else
    pTargetTrasversal = 0.0
  end if
  lLookaheadDistance = (pCPUMinLookahead + (abs(lSpeedKmh) * pCPUSpeedLookaheadFactor)) * lLateralFactor
  pTargetPosition = gGame.GetTokenManager().GetTargetPosition(pCurrentToken, lLongitudinal, lLookaheadDistance, pTargetTrasversal)
end

on CheckOthersExit me, kEntity, kTime
end

on HighWayEnter me, kEntity, kTime
end

on HighWayExec me, kEntity, kTime
  pCurrentToken = pPlayerRef.GetCurrentToken()
  lLongitudinal = pPlayerRef.GetLongitudinal()
  lTrasversal = pPlayerRef.GetTrasversal()
  if pTargetTrasversal = -1000 then
    pTargetTrasversal = lTrasversal
    pBestTrasversal = lTrasversal
  end if
  lSpeedKmh = pPlayerRef.GetSpeedKmh()
  lLateralFactor = 1.0
  lCorrectLateralFactor = 0
  if not pPlayerRef.GetVehicle().IsOutTrack() then
    lLookaheadDistance = pCPUMinLookahead + (abs(lSpeedKmh) * pCPUSpeedLookaheadFactor)
    lSpeedForCheckFactor = lSpeedKmh / 150.0
    lSpeedForCheckFactor = Clamp(lSpeedForCheckFactor, 0.84999999999999998, 1.5)
    lTrackPos = pPlayerRef.GetVehicle().GetTrackPos()
    lWallOnHead = 0
    lWallOnSides = [0, 0]
    lCarOnHead = [0, 0, 0]
    lCarOnSides = [0, 0]
    lWalls = gGame.GetTrackGrid().GetCellByPos(lTrackPos).GetWalls()
    repeat with li = 1 to lWalls.count
      lWallStartPos = lWalls[li].startPos
      lWallEndPos = lWalls[li].endPos
      lDist = lWallStartPos - lTrackPos
      if (lDist < (1000.0 * lSpeedForCheckFactor)) and (lDist > 0.0) and (abs(lTrasversal) < 0.10000000000000001) then
        lWallOnHead = 1
      end if
      if ((lTrackPos + 1800.0) > lWallStartPos) and (lTrackPos < lWallEndPos) then
        if lTrasversal > 0.0 then
          lWallOnSides[2] = 1
          next repeat
        end if
        lWallOnSides[1] = 1
      end if
    end repeat
    lMyOBB = pPlayerRef.GetVehicle().GetOBB()
    if voidp(lMyOBB) then
      return 
    end if
    lDistanceToCheck = 3200.0 * lSpeedForCheckFactor
    if lTrasversal < -0.10000000000000001 then
      lDistanceToCheck = lDistanceToCheck * 1.44999999999999996
      lSpeedForCheckFactor = lSpeedForCheckFactor * 1.19999999999999996
    end if
    lCars = gGame.GetTrackGrid().Query(lTrackPos, pPlayerRef.GetVehicle().getPosition(), lDistanceToCheck)
    lCPUTrackPos = pPlayerRef.GetVehicle().GetTrackPos()
    lCPULength = lMyOBB.e[2]
    lTrasvList = [[-0.75, -0.34999999999999998, 0.0], [-0.34999999999999998, 0.34999999999999998, -0.75], [0.34999999999999998, 0.75, -0.34999999999999998], [0.75, 0.0, 0.34999999999999998]]
    lTrasvIdx = 0
    lMinTrasvDiff = 2.0
    repeat with lk = 1 to lTrasvList.count
      lDiff = abs(lTrasvList[lk][1] - lTrasversal)
      if lDiff < lMinTrasvDiff then
        lMinTrasvDiff = lDiff
        lTrasvIdx = lk
      end if
    end repeat
    if lTrasvIdx <> 0 then
      lDiscreteTrasversal = lTrasvList[lTrasvIdx][1]
      repeat with li = 1 to lCars.count
        lCarRef = lCars[li]
        lCarTrackPos = lCarRef.GetTrackPos()
        lCarTrasversal = lCarRef.GetTrasversal()
        lCarOBB = lCarRef.GetOBB()
        lCarLength = lCarOBB.e[2]
        lToCarOffset = lCPUTrackPos - lCarTrackPos
        lToCarDistance = abs(lToCarOffset)
        lToCarTrasversal = lTrasversal - lCarTrasversal
        lToCarTrasversalDiscrete = lDiscreteTrasversal - lCarTrasversal
        if lToCarDistance < ((lCPULength + lCarLength) * 1.10000000000000009) then
          if (abs(lToCarTrasversalDiscrete) > 0.34999999999999998) and (abs(lToCarTrasversalDiscrete) < 0.75) then
            if lToCarTrasversal > 0.0 then
              lCarOnSides[2] = 1
            else
              lCarOnSides[1] = 1
            end if
          end if
        end if
        lDistanceFactor = 1.0
        if lCarTrasversal < 0.0 then
          lDistanceFactor = 2.0
        end if
        if (lToCarOffset < -200.0) and (lToCarOffset > (-3000 * lDistanceFactor)) then
          if abs(lToCarTrasversalDiscrete) <= 0.34999999999999998 then
            if lCarOnHead[1] <> 0 then
              lCarOnHead[1] = max(lCarOnHead[1], lToCarOffset - lCarLength)
            else
              lCarOnHead[1] = lToCarOffset - lCarLength
            end if
            next repeat
          end if
          if (lToCarTrasversalDiscrete > 0.34999999999999998) and (lToCarTrasversalDiscrete < 0.75) then
            if lCarOnHead[2] <> 0 then
              lCarOnHead[2] = max(lCarOnHead[2], lToCarOffset - lCarLength)
            else
              lCarOnHead[2] = lToCarOffset - lCarLength
            end if
            next repeat
          end if
          if (lToCarTrasversalDiscrete < -0.34999999999999998) and (lToCarTrasversalDiscrete > -0.75) then
            if lCarOnHead[3] <> 0 then
              lCarOnHead[3] = max(lCarOnHead[3], lToCarOffset - lCarLength)
              next repeat
            end if
            lCarOnHead[3] = lToCarOffset - lCarLength
          end if
        end if
      end repeat
      lBrakeFactor = 0.0
      if (lWallOnHead or lCarOnHead[1]) and (lTrasvIdx <> 0) then
        lTakeRightSide = not lCarOnSides[1] and not (lWallOnSides[1] and (lTrasvIdx = 2)) and (lTrasvIdx <> 4) and (lCarOnHead[1] and (lCarOnHead[3] > lCarOnHead[1]))
        lTakeLeftSide = not lCarOnSides[2] and not (lWallOnSides[2] and (lTrasvIdx = 3)) and (lTrasvIdx <> 1) and (lCarOnHead[1] and (lCarOnHead[2] > lCarOnHead[1]))
        if lTakeRightSide and lTakeLeftSide then
          if not lCarOnHead[3] then
            pTargetTrasversal = lTrasvList[lTrasvIdx][2]
            lLookaheadDistance = lLookaheadDistance * 0.59999999999999998
          else
            if not lCarOnHead[2] then
              pTargetTrasversal = lTrasvList[lTrasvIdx][3]
              lLookaheadDistance = lLookaheadDistance * 0.59999999999999998
            end if
          end if
        else
          if lTakeRightSide then
            pTargetTrasversal = lTrasvList[lTrasvIdx][2]
            lLookaheadDistance = lLookaheadDistance * 0.59999999999999998
          else
            if lTakeLeftSide then
              pTargetTrasversal = lTrasvList[lTrasvIdx][3]
              lLookaheadDistance = lLookaheadDistance * 0.59999999999999998
            else
              lBrakeFactor = -0.40000000000000002
            end if
          end if
        end if
      else
        if lTrasvIdx <> 0 then
          pTargetTrasversal = lTrasvList[lTrasvIdx][1]
        end if
      end if
    end if
    pTargetPosition = gGame.GetTokenManager().GetTargetPosition(pCurrentToken, lLongitudinal, lLookaheadDistance, pTargetTrasversal)
  end if
end

on HighWayExit me, kEntity, kTime
end

on UpdateDrive me, kVehiclePosition, kTargetPosition, kBrakeFactor
  lTargetPos = kTargetPosition
  lVehiclePosition = kVehiclePosition
  lBrakeFactor = kBrakeFactor
  if voidp(lBrakeFactor) then
    lBrakeFactor = 0.0
  end if
  lWorldForward = pPlayerRef.GetWorldForward()
  if voidp(lWorldForward) then
    return 
  end if
  pAcceleration = 1.0
  if not voidp(lTargetPos) then
    lTargetPosition = lTargetPos.duplicate()
    lTargetPosition.z = lVehiclePosition.z
    lWorldForward2D = lWorldForward.duplicate()
    lWorldForward2D.z = 0.0
    lWorldForward2D.normalize()
    lTargetDirection = lTargetPos - lVehiclePosition
    lTargetDirection.z = 0.0
    lTargetDirection.normalize()
    lAngleToTarget = lTargetDirection.angleBetween(lWorldForward2D)
    lVersusToTarget = lTargetDirection.crossProduct(lWorldForward2D)
    lSign = Sign(lVersusToTarget.z)
    pSteering = lSign * lAngleToTarget / 8.0
    pSteering = Clamp(pSteering, -1.0, 1.0)
  end if
  if not voidp(lTargetPos) then
    lCurrVel = pPlayerRef.GetVelocity()
    lPreviousVelocity = pPlayerRef.GetPreviousVelocity()
    lCurrSpeed = pPlayerRef.GetSpeed()
    lNormalizedCurrentVelocity = lCurrVel.duplicate()
    lNormalizedCurrentVelocity.normalize()
    lNormalizedCurrentVelocity.z = lNormalizedCurrentVelocity.x
    lNormalizedCurrentVelocity.x = lNormalizedCurrentVelocity.y
    lNormalizedCurrentVelocity.y = -lNormalizedCurrentVelocity.z
    lNormalizedCurrentVelocity.z = 0.0
    lAcceleration = (lCurrVel - lPreviousVelocity) / gGame.GetHavokPhysics().GetTimeStep()
    lVersus = lCurrVel.crossProduct(lAcceleration)
    if lVersus.z > 0.0 then
      lNormalizedCurrentVelocity = -lNormalizedCurrentVelocity
    end if
    lAccelerationModule = lAcceleration.magnitude
    if lAccelerationModule <> 0.0 then
      lAccelerationCircleRadius = lCurrSpeed * lCurrSpeed / lAccelerationModule
      lAccelerationCircleCenter = lVehiclePosition + (lNormalizedCurrentVelocity * lAccelerationCircleRadius)
      lAccelerationCircleCenter.z = 0.0
      lTargetPosition = lTargetPos.duplicate()
      lTargetPosition.z = 0.0
      lCircleTargetDistance = (lTargetPosition - lAccelerationCircleCenter).magnitude
      lGoingBackward = 0
      lGoingForward = 0
      if lCircleTargetDistance < (lAccelerationCircleRadius * pAccelerationCircleRatio) then
        lGoingBackward = 1
        lGoingForward = 0
      else
        lGoingForward = 1
        lGoingBackward = 0
      end if
      if lGoingForward and (lBrakeFactor = 0.0) then
        pAcceleration = 1.0
      end if
      if lBrakeFactor <> 0.0 then
        pAcceleration = lBrakeFactor
      end if
      if lGoingBackward then
        pAcceleration = -1.0
      end if
    end if
  end if
end

on update me, kTime
  if not pActive then
    return 
  end if
  me.ancestor.update(kTime)
  lPlayerPosition = pPlayerRef.getPosition()
  me.UpdateDrive(lPlayerPosition, pTargetPosition, pBrakeFactor)
end
