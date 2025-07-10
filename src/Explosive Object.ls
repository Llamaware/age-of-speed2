property pIndex, pModelRef, pModelName, pPosition, pRadius, pRotation, pParticleList, pOneShoot, pSoundList, pCheckpointListIndex, pRespawnTime, pDestructionTime, pZPos, pZOffset, pUp, pExplosiveCallback, pExplosiveCallbackScriptName, pRespawnCallback, pRespawnCallbackScriptName, pRemoveModel, pIsKeyFramed, pKeyFramedObject, pStartKeyFrame, pEndKeyFrame, pRemoveChild, pKeyFramePlayRate, pType
global gGame

on new me, fIndex, fPosition, fRadius, fRotation, fProperties, fOneShoot, fRespawnTime, fUserData
  pOneShoot = fOneShoot
  pIndex = fIndex
  pType = VOID
  if not voidp(fProperties) then
    pModelName = fProperties.model
    pParticleList = fProperties.particles
    pSoundList = fProperties.sounds
    if fProperties.findPos(#NoClone) <> VOID then
      if fUserData.findPos(#ModelRef) <> VOID then
        pModelName = fUserData.ModelRef
      end if
    end if
  else
    pModelName = VOID
    pParticleList = VOID
    pSoundList = VOID
  end if
  pPosition = fPosition
  pRadius = fRadius
  pRotation = fRotation
  if fRespawnTime <> VOID then
    me.pRespawnTime = fRespawnTime
  end if
  me.pDestructionTime = -1
  pRemoveModel = 1
  pExplosiveCallback = VOID
  pExplosiveCallbackScriptName = VOID
  pRespawnCallback = VOID
  pRespawnCallbackScriptName = VOID
  if not voidp(fUserData) then
    if fUserData.findPos("move") <> VOID then
      if fUserData.move = 1 then
        me.pZPos = fPosition.z
        me.pZOffset = fUserData.ZOffset
        me.pUp = 1
      end if
    end if
    if fUserData.findPos("explosiveCallbackData") <> VOID then
      pExplosiveCallback = fUserData.explosiveCallbackData.callback
      pExplosiveCallbackScriptName = fUserData.explosiveCallbackData.CallbackScriptName
    end if
    if fUserData.findPos("RespawnCallbackData") <> VOID then
      pRespawnCallback = fUserData.RespawnCallbackData.callback
      pRespawnCallbackScriptName = fUserData.RespawnCallbackData.CallbackScriptName
    end if
    if fUserData.findPos("removeModel") <> VOID then
      pRemoveModel = fUserData.removeModel
    end if
    if fUserData.findPos("IsKeyFramed") <> VOID then
      pIsKeyFramed = 1
      pStartKeyFrame = fUserData.IsKeyFramed.startFrame
      pEndKeyFrame = fUserData.IsKeyFramed.endFrame
      pRemoveChild = fUserData.IsKeyFramed.removeChild
      if fUserData.IsKeyFramed.findPos("playRate") <> VOID then
        pKeyFramePlayRate = fUserData.IsKeyFramed.playRate
      else
        pKeyFramePlayRate = 2.0
      end if
    end if
  end if
  lName = "explobj" & string(gGame.GetCheckpointManager().pCheckpointList.count)
  pCheckpointListIndex = gGame.GetCheckpointManager().AddWithObject(lName, pPosition, pRadius, 1, me, VOID, VOID, fUserData, #spheric)
  if fProperties.findPos(#NoClone) <> VOID then
    me.pModelRef = me.pModelName
    me.pModelRef.visibility = #both
    if pIsKeyFramed then
      me.pKeyFramedObject = script("KeyFramed Hierarched Object").new(me.pModelRef)
      me.pKeyFramedObject.SetCurrentAnimTime(1)
      me.pKeyFramedObject.PauseAnimations()
    end if
  else
    me.Place(pIndex)
  end if
  return me
end

on GetIndex me
  return pIndex
end

on Place me, lIndex
  lName = "expl_" & string(lIndex)
  me.pModelRef = me.pModelName.clone(lName & "_float_cam")
  me.pModelRef.addToWorld()
  me.pModelRef.transform.rotation = me.pRotation
  me.pModelRef.transform.position = me.pPosition
  me.pModelRef.visibility = #both
  if pIsKeyFramed then
    me.pKeyFramedObject = script("KeyFramed Hierarched Object").new(me.pModelRef)
    me.pKeyFramedObject.SetCurrentAnimTime(1)
    me.pKeyFramedObject.PauseAnimations()
  end if
end

on Respawn me
  gGame.GetCheckpointManager().pCheckpointList[pCheckpointListIndex].pIsActive = 1
  me.pModelRef.visibility = #front
  repeat with li = 1 to me.pModelRef.child.count
    me.pModelRef.child[li].visibility = #front
  end repeat
  me.pDestructionTime = -1
  if pIsKeyFramed then
    me.pKeyFramedObject.SetCurrentAnimTime(1)
    me.pKeyFramedObject.PauseAnimations()
  end if
  if not voidp(pRespawnCallback) then
    call(pRespawnCallback, pRespawnCallbackScriptName, pPosition, pModelRef, me)
  end if
end

on MoveExplosive me, top, bottom, Middle, Steps, VelBegin
  lDt = gGame.GetTimeManager().GetDeltaTime() * 0.001
  if (me.pModelRef.transform.position.z >= top) and (me.pUp = 1) then
    me.pUp = 0
  else
    if (me.pModelRef.transform.position.z <= bottom) and (me.pUp = 0) then
      me.pUp = 1
    end if
  end if
  if me.pModelRef.transform.position.z <= Middle then
    l_vel = ((me.pModelRef.transform.position.z - bottom) * (lDt * Steps)) + VelBegin
  else
    l_vel = ((top - bottom - (me.pModelRef.transform.position.z - bottom)) * (lDt * Steps)) + VelBegin
  end if
  if me.pUp then
    me.pModelRef.transform.position.z = me.pModelRef.transform.position.z + l_vel
  else
    me.pModelRef.transform.position.z = me.pModelRef.transform.position.z - l_vel
  end if
end

on move me
  me.pModelRef.rotate(0.0, 0.0, 1.80000000000000004)
  me.MoveExplosive(me.pZPos + me.pZOffset, me.pZPos, me.pZPos + (me.pZOffset / 2.0), 5.0, 1.0)
  me.pPosition = me.pModelRef.transform.position
end

on GetDestructionTime me
  return me.pDestructionTime
end

on GetRespawnTime me
  return me.pRespawnTime
end

on ExecuteInAction me, kDatas, kPlayerRef
  if not voidp(pExplosiveCallback) then
    call(pExplosiveCallback, pExplosiveCallbackScriptName, pPosition, pModelRef, kPlayerRef, me)
  end if
  repeat with li = 1 to me.pParticleList.count
    lName = "expl_" & li & "_" & string(the milliSeconds)
    lParticleProp = me.pParticleList[li]
    if lParticleProp.attachedToCam then
      lTrans = gGame.GetCamera().GetCameraNode().getWorldTransform().inverse()
      lTrans2 = lTrans.duplicate()
      lTrans2.position = vector(0, 0, 0)
      lVehicleVel = lTrans2 * gGame.GetPlayerVehicle().GetVelocity()
      lPos = lTrans * me.pModelRef.getWorldTransform().position
      lPos = lPos + (lVehicleVel * 0.10000000000000001)
      lEmitterRegion = [lPos]
      lParticle = script("Particles").new(gGame.Get3D(), lName, lParticleProp.texture, lEmitterRegion, lParticleProp.direction, lParticleProp.properties)
      gGame.GetParticlesManager().AddParticles(lName, lParticle, gGame.GetCamera().GetCameraNode(), lParticleProp.lifeTime, lParticleProp.deletetime)
    else
      lParticle = script("Particles").new(gGame.Get3D(), lName, lParticleProp.texture, lParticleProp.emitterregion, lParticleProp.direction, lParticleProp.properties)
      gGame.GetParticlesManager().AddParticles(lName, lParticle, me.pModelRef, lParticleProp.lifeTime, lParticleProp.deletetime)
    end if
    gGame.GetParticlesManager().StartParticle(lName)
    if not voidp(pSoundList) then
      gGame.GetSoundManager().PlaySound(pSoundList, 6)
    end if
  end repeat
  if pIsKeyFramed then
    pKeyFramedObject.ResetAnimations()
    pKeyFramedObject.startAnimation(pStartKeyFrame, pEndKeyFrame, pKeyFramePlayRate)
  end if
  if pOneShoot then
    gGame.GetCheckpointManager().pCheckpointList[pCheckpointListIndex].pIsActive = 0
    if pRemoveModel then
      me.pModelRef.visibility = #none
      repeat with li = 1 to me.pModelRef.child.count
        me.pModelRef.child[li].visibility = #none
      end repeat
    end if
  else
    if (pRespawnTime <> VOID) and (pDestructionTime = -1) then
      gGame.GetCheckpointManager().pCheckpointList[pCheckpointListIndex].pIsActive = 0
      if pRemoveModel then
        me.pModelRef.visibility = #none
        repeat with li = 1 to me.pModelRef.child.count
          if voidp(pRemoveChild) or pRemoveChild then
            me.pModelRef.child[li].visibility = #none
          end if
        end repeat
      end if
      pDestructionTime = gGame.GetTimeManager().GetTime()
      if pRespawnTime <> -1 then
        gGame.GetExplosiveObjectManager().AddToRespawnableList(me)
      end if
    end if
  end if
end

on ExecuteOutAction me
end
