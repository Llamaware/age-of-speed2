property pStartTime, pExplosionModel, pExplosionMdlIndex, pScaleFactor, plifetime
global gGame

on new me, kExplosionPosition, kExplosionMdlData, kScaleFactor
  pStartTime = gGame.GetTimeManager().GetTime()
  pExplosionModel = kExplosionMdlData.mdl
  pExplosionMdlIndex = kExplosionMdlData.index
  pExplosionModel.transform.position = kExplosionPosition
  pExplosionModel.visibility = #front
  pExplosionModel.pointAtOrientation = [vector(0, 1, 0), vector(0, 0, 1)]
  pExplosionModel.addToWorld()
  pScaleFactor = kScaleFactor
  plifetime = 2000.0
  return me
end

on SetLifeTime me, kLifeTime
  plifetime = kLifeTime
end

on update me, kTime
  lExplosionIsOver = 0
  lExplosionTime = kTime - pStartTime
  if voidp(pExplosionModel) or (lExplosionTime > plifetime) then
    lExplosionIsOver = 1
    pExplosionModel.shader.blend = 0
    gGame.GetExplosionManager().FreeExplosionMdl(pExplosionMdlIndex)
  else
    lScaleFactor = lExplosionTime / plifetime
    lScaleFactor = (0.20000000000000001 + lScaleFactor) * pScaleFactor
    pExplosionModel.transform.scale = vector(lScaleFactor, lScaleFactor, lScaleFactor)
    lBlendFactor = 100 - (lExplosionTime * (1.0 / (plifetime * 0.01)))
    pExplosionModel.shader.blend = lBlendFactor
  end if
  return lExplosionIsOver
end
