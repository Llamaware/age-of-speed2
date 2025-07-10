property pDynamicRbList, pShaderIdList, pInitData
global gGame

on new me
  return me
end

on Initialize me, kInitData
  pInitData = kInitData
  pDynamicRbList = []
  pShaderIdList = []
end

on AssignNewShader me, kMdl, kId
  repeat with li = 1 to kMdl.shaderList.count
    lShader = kMdl.shaderList[li]
    lNewShaderName = lShader.name & "_destruct_" & kId
    lNewShader = gGame.Get3D().shader(lNewShaderName)
    if voidp(lNewShader) then
      kMdl.shaderList[li] = DuplicateShader(gGame.Get3D(), lShader, lNewShaderName)
      next repeat
    end if
    lNewShader.blend = 100
    kMdl.shaderList[li] = lNewShader
  end repeat
end

on GetShaderForDestrucion me
  lShaderId = -1
  repeat with li = 1 to pShaderIdList.count
    if pShaderIdList[li] >= lShaderId then
      lShaderId = pShaderIdList[li] + 1
    end if
  end repeat
  if lShaderId = -1 then
    lShaderId = 0
  end if
  pShaderIdList.add(lShaderId)
  return lShaderId
end

on FreeShaderId me, kShaderId
  repeat with li = 1 to pShaderIdList.count
    if pShaderIdList[li] = kShaderId then
      pShaderIdList.deleteAt(li)
      exit repeat
    end if
  end repeat
end

on SetMdlBlend me, kMdl, kBlend
  repeat with li = 1 to kMdl.shaderList.count
    kMdl.shaderList[li].blend = kBlend
  end repeat
end

on OnRbCollision me, kMdlName, kCollisionIntensity
  lFixed2Movable = 0
  lRBData = VOID
  repeat with li = 1 to pInitData.count
    lInitData = pInitData[li]
    if kMdlName starts lInitData.Prefix then
      lRBData = lInitData
      exit repeat
    end if
  end repeat
  if not voidp(lRBData) then
    if lRBData.threshold < kCollisionIntensity then
      lModel = gGame.Get3D().model(kMdlName)
      if voidp(lModel.userData.findPos(#Fixed2Movable)) then
        lModel.userData.addProp(#Fixed2Movable, 1)
        lShaderId = me.GetShaderForDestrucion()
        me.AssignNewShader(lModel, lShaderId)
        lHavokRef = gGame.GetHavokPhysics().GetHavok()
        lModelRB = lHavokRef.rigidBody(kMdlName)
        if not voidp(lModelRB) then
          lHavokRef.deleteRigidBody(kMdlName)
        end if
        lModel.addModifier(#meshDeform)
        lConvexType = VOID
        if lRBData.findPos(#type) <> VOID then
          lConvexType = lRBData.type
          lRBCreationResults = lHavokRef.makeMovableRigidBody(kMdlName, lRBData.mass, lRBData.isConvex, lConvexType)
        else
          lRBCreationResults = lHavokRef.makeMovableRigidBody(kMdlName, lRBData.mass, lRBData.isConvex)
        end if
        lRBCreationResults.friction = lRBData.friction
        lRBCreationResults.restitution = lRBData.restitution
        lModel.removeModifier(#meshDeform)
        lLifeTime = 9000
        if lRBData.findPos(#lifeTime) <> VOID then
          lLifeTime = lRBData.lifeTime
        end if
        lFadeTime = 3000
        if lRBData.findPos(#FadeTime) <> VOID then
          lFadeTime = lRBData.FadeTime
        end if
        pDynamicRbList.add([lModel, gGame.GetTimeManager().GetTime(), 0, lShaderId, lLifeTime, lFadeTime])
        gGame.GetCullingManager().removeModel(lModel)
        lFixed2Movable = 1
      end if
    end if
  end if
  return lFixed2Movable
end

on update me, kTime
  repeat with li = pDynamicRbList.count down to 1
    lDynamicRbRef = pDynamicRbList[li]
    lMdlName = lDynamicRbRef[1].name
    lTime = kTime - lDynamicRbRef[2]
    lLifeTime = lDynamicRbRef[5]
    lFadeTime = lDynamicRbRef[6]
    if lTime < lLifeTime then
      if lTime > (lLifeTime - lFadeTime) then
        if not lDynamicRbRef[3] then
          lDynamicRbRef[3] = 1
          lHavokRef = gGame.GetHavokPhysics().GetHavok()
          lModelRB = lHavokRef.rigidBody(lMdlName)
          if not voidp(lModelRB) then
            lHavokRef.deleteRigidBody(lMdlName)
          end if
        end if
        lBlend = 100.0 - ((lTime - (lLifeTime - lFadeTime)) * 100.0 / lFadeTime)
        me.SetMdlBlend(lDynamicRbRef[1], lBlend)
      end if
      next repeat
    end if
    lDynamicRbRef[1].removeFromWorld()
    gGame.Get3D().deleteModel(lMdlName)
    pDynamicRbList.deleteAt(li)
    lShaderId = lDynamicRbRef[4]
    me.FreeShaderId(lShaderId)
  end repeat
end
