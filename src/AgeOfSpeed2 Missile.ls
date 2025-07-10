property pStartTime, pPlayerRef, pTarget, pCurrentToken, pLongitudinal, pTrasversal, pTokenTangent, pTrackPos, pMissileMdl, pMdlPos, pDirection, pVel, pMaxVel, pRigidity, pDistanceForExplosion, plifetime, pMissileHeight, pWhiteSmokeName
global gGame

on new me, kPlayerRef, kMissileBaseMdlName
  pPlayerRef = kPlayerRef
  pStartTime = gGame.GetTimeManager().GetTime()
  pCurrentToken = pPlayerRef.GetCurrentToken()
  pLongitudinal = pPlayerRef.GetLongitudinal()
  pTrasversal = pPlayerRef.GetTrasversal()
  l_TrackToken = gGame.GetTokenManager().GetTokenRef(pCurrentToken)
  lStartTokenPos3d = l_TrackToken.Position3D
  lEndTokenPos3d = l_TrackToken.EndPosition3D
  lDir = lEndTokenPos3d - lStartTokenPos3d
  lDir.normalize()
  pDirection = lDir
  lTokenUp = gGame.GetTokenManager().GetTokenUp(pCurrentToken, pLongitudinal)
  lMdlBase = gGame.Get3D().model(kMissileBaseMdlName)
  lPlayerId = pPlayerRef.GetPlayerId()
  pMissileMdl = gGame.Get3D().newModel("missile_" & lPlayerId & "_" & the milliSeconds & "_dyn", gGame.Get3D().modelResource(lMdlBase.resource.name))
  pMissileMdl.shaderList = lMdlBase.shaderList
  pMdlPos = pPlayerRef.getPosition() + (lTokenUp * 200.0)
  pMissileMdl.transform.position = pMdlPos
  pMissileMdl.visibility = #front
  pMissileMdl.pointAtOrientation = [vector(0.0, 1.0, 0.0), vector(0.0, 0.0, 1.0)]
  pMissileMdl.addToWorld()
  pVel = 10000.0
  pMaxVel = 14000.0
  pDistanceForExplosion = 300.0
  pRigidity = 8.0
  plifetime = 15000.0
  pMissileHeight = 220.0
  pWhiteSmokeName = "missile_" & pPlayerRef.GetPlayerId() & "_" & the milliSeconds & "_Smoke_dyn"
  call(#MissileStartCallBack, gGame.GetGameplay(), pPlayerRef, pWhiteSmokeName, pMissileMdl)
  return me
end

on SetVel me, kVel
  pVel = kVel
end

on SetMaxVel me, kMaxVel
  pMaxVel = kMaxVel
end

on SetDistanceForExplosion me, kDistanceForExplosion
  pDistanceForExplosion = kDistanceForExplosion
end

on SetRigidity me, kRigidity
  pRigidity = kRigidity
end

on SetLifeTime me, kLifeTime
  plifetime = kLifeTime
end

on SetMissileHeight me, kMissileHeight
  pMissileHeight = kMissileHeight
end

on FindTarget me
  lPlayers = gGame.GetPlayers()
  repeat with li = 1 to lPlayers.count
    lPlayerRef = lPlayers[li]
    if lPlayerRef <> pPlayerRef then
      lPlayerTrackPos = lPlayerRef.GetTrackPos()
      lTrackPosDiff = lPlayerTrackPos - pTrackPos
      if (lTrackPosDiff > 0) and (lTrackPosDiff < 8000) then
        pTarget = lPlayerRef
        pTarget.SetUnderMissileTarget(1)
        exit repeat
      end if
    end if
  end repeat
end

on CheckTargetCollision me
  lPlayerTrackPos = pTarget.GetTrackPos()
  lTrackPosDiff = lPlayerTrackPos - pTrackPos
  if not ((lTrackPosDiff > 0) and (lTrackPosDiff < 4000)) then
    pTarget.SetUnderMissileTarget(0)
    pTarget = VOID
  else
    lTargetPos = pTarget.getPosition()
    lDistanceFromTarget = (lTargetPos - pMdlPos).magnitude
    pTarget.SetMissileDistance(lDistanceFromTarget)
    if lDistanceFromTarget < pDistanceForExplosion then
      me.ExplosionAction(pTarget)
      pTarget.SetUnderMissileTarget(0)
    end if
  end if
end

on UpdateTrackInfo me
  lResult = gGame.GetTokenManager().getToken(pCurrentToken, pMdlPos.x, pMdlPos.y, pMdlPos, 4000.0, 0.0)
  if lResult[1] <> 0 then
    pCurrentToken = lResult[1]
    pTokenTangent = lResult[3]
    pLongitudinal = lResult[4]
    pTrasversal = lResult[5]
    lTokenRef = gGame.GetTokenManager().GetTokenRef(pCurrentToken)
    lDistanceFromStart = lTokenRef.DistanceFromStart
    lRoadLength = lTokenRef.RoadLength
    lTokenTrackPos = pLongitudinal * lRoadLength
    pTrackPos = lDistanceFromStart + lTokenTrackPos
  end if
end

on UpdateDrive me
  if voidp(pTarget) then
    pTargetPos = gGame.GetTokenManager().GetTargetPosition(pCurrentToken, pLongitudinal, 1000.0, 0.0)
    lResult = gGame.GetTokenManager().getToken(pCurrentToken, pTargetPos.x, pTargetPos.y, pTargetPos, 4000.0, 0.0)
    lTokenId = lResult[1]
    lLongitudinal = lResult[4]
    l_TrackToken = gGame.GetTokenManager().GetTokenRef(lTokenId)
    lTokenUp = gGame.GetTokenManager().GetTokenUp(lTokenId, lLongitudinal)
    lStartTokenPos3d = l_TrackToken.Position3D
    lEndTokenPos3d = l_TrackToken.EndPosition3D
    pTargetPos = lStartTokenPos3d + ((lEndTokenPos3d - lStartTokenPos3d) * lLongitudinal)
    pTargetPos = pTargetPos + (lTokenUp * 650.0)
  else
    pTargetPos = pTarget.getPosition()
  end if
  lDt = gGame.GetTimeManager().GetDeltaTime() * 0.001
  lWantedDirection = pTargetPos - pMdlPos
  lWantedDirection.normalize()
  pDirection = pDirection + ((lWantedDirection - pDirection) * pRigidity * lDt)
  if pVel < pMaxVel then
    pVel = pVel + (200.0 * lDt)
    if pVel > pMaxVel then
      pVel = pMaxVel
    end if
  end if
  lNewPos = pMdlPos + (pVel * pDirection * lDt)
  lPos = lNewPos
  lOrient = lPos - pMdlPos
  lOrient.normalize()
  pMissileMdl.transform.position = lPos
  pMissileMdl.pointAt(lPos + (lOrient * 20.0), vector(0, 0, 1))
  pMdlPos = lNewPos
end

on update me, kTime
  lExploded = 0
  if voidp(pMissileMdl) then
    lExploded = 1
  else
    me.UpdateTrackInfo()
    if voidp(pTarget) then
      me.FindTarget()
    end if
    me.UpdateDrive()
    if not voidp(pTarget) then
      me.CheckTargetCollision()
    end if
    if (kTime - pStartTime) > plifetime then
      me.ExplosionAction()
      lExploded = 1
      if not voidp(pTarget) then
        pTarget.SetUnderMissileTarget(0)
      end if
    end if
  end if
  return lExploded
end

on ExplosionAction me, kTarget
  gGame.Get3D().deleteModel(pMissileMdl.name)
  if not voidp(kTarget) then
    lExplosionPos = kTarget.getPosition()
  else
    lExplosionPos = pMdlPos
  end if
  call(#MissileExplosionCallBack, gGame.GetGameplay(), kTarget, lExplosionPos, pWhiteSmokeName)
end
