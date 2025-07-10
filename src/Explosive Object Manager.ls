property pExplosiveObjectList, pExplosiveObjectCounter, pMember, ExplosiveObjectsPropertiesDescriptor, pExploseObjectToRespawn, pMovebleExplosiveObjectList
global gGame

on new me, fMember
  pExplosiveObjectList = []
  pExploseObjectToRespawn = []
  pMovebleExplosiveObjectList = []
  pExplosiveObjectCounter = 0
  pMember = fMember
  ExplosiveObjectsPropertiesDescriptor = VOID
  return me
end

on SetExplosiveObjectProperties me, fExplosiveObjectsProperties
  me.ExplosiveObjectsPropertiesDescriptor = fExplosiveObjectsProperties
end

on add me, fPosition, fRadius, fRotation, fProperty, fOneShoot, fRespawn, fUserData
  ExplosionProperties = me.ExplosiveObjectsPropertiesDescriptor[fProperty]
  lBoundingSphereOffset = 0
  if not voidp(fUserData) then
    if fUserData.findPos("BoundingSphereOffset") <> VOID then
      lBoundingSphereOffset = fUserData.BoundingSphereOffset
    end if
    if fUserData.findPos("ObjProperty") <> VOID then
      ExplosionProperties = me.ExplosiveObjectsPropertiesDescriptor[fUserData.ObjProperty]
      ExplosionProperties.model = fUserData.model
    end if
  end if
  lRadius = fRadius
  if ExplosionProperties.findPos(#model) <> VOID then
    if not voidp(ExplosionProperties.model) then
      lRadius = ExplosionProperties.model.boundingSphere[2] + lBoundingSphereOffset
    end if
  end if
  lExplosiveObj = new(script("Explosive Object"), pExplosiveObjectCounter, fPosition, lRadius, fRotation, ExplosionProperties, fOneShoot, fRespawn, fUserData)
  me.pExplosiveObjectList.add(lExplosiveObj)
  if not voidp(fUserData) then
    if fUserData.findPos("move") <> VOID then
      if fUserData.move = 1 then
        me.pMovebleExplosiveObjectList.add(lExplosiveObj)
      end if
    end if
  end if
  pExplosiveObjectCounter = pExplosiveObjectCounter + 1
  return lExplosiveObj
end

on Remove me, fObjectName
  li = pExplosiveObjectList.getOne(fObjectName)
  if li > 0 then
    me.pExplosiveObjectList.deleteAt(li)
    return #Ok
  else
    return #name_not_found
  end if
end

on AddToRespawnableList me, fExplosiveObj
  me.pExploseObjectToRespawn.add(fExplosiveObj)
end

on update me
  if me.pExploseObjectToRespawn.count > 0 then
    repeat with li = pExploseObjectToRespawn.count down to 1
      lExplosiveObj = pExploseObjectToRespawn[li]
      lDestructionTime = lExplosiveObj.GetDestructionTime()
      if (gGame.GetTimeManager().GetTime() - lDestructionTime) > lExplosiveObj.GetRespawnTime() then
        lExplosiveObj.Respawn()
        pExploseObjectToRespawn.deleteAt(li)
      end if
    end repeat
  end if
  repeat with li = 1 to pMovebleExplosiveObjectList.count
    pMovebleExplosiveObjectList[li].move()
  end repeat
end

on GetIndex me, fObjectName
  li = pExplosiveObjectList.getOne(fObjectName)
  if li > 0 then
    return li
  else
    return #name_not_found
  end if
end

on GetObjectNum
  return pExplosiveObjectList.count
end

on RespawnAll me
  if me.pExploseObjectToRespawn.count > 0 then
    repeat with li = pExploseObjectToRespawn.count down to 1
      lExplosiveObj = pExploseObjectToRespawn[li]
      lExplosiveObj.Respawn()
      pExploseObjectToRespawn.deleteAt(li)
    end repeat
  end if
end

on RespawnAllMovable me
  if me.pMovebleExplosiveObjectList.count > 0 then
    repeat with li = pMovebleExplosiveObjectList.count down to 1
      lExplosiveObj = pMovebleExplosiveObjectList[li]
      lExplosiveObj.Respawn()
    end repeat
  end if
end
