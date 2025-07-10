property pPlayer, pVehicle, pVehicleGfx, pEffectsActive, pEnablePolyline, pPolyTextureName, pPolylineWheels, pPolylineActivity, pPolylineShader, pPolylineBlend, pPolylineWidth, pPolylineSegments, pPolylineTextureMapK, pPolylineMinTimeBetweenPoint, pPolylineMinDistanceBetweenPoint, pEnablePowder, pPowderTextureName, pPowderParticles, pPowderActivity, pPowderTimer, pPowderEmitterRegion, pBrakeLightsEnabled, pBrakeLightsOn, pBrakeLightsShader, pBrakeLightsTimer, pRetroLightsEnabled, pRetroLightsOn, pRetroLightsShader, pRetroLightsTimer
global gGame

on new me, kPlayer, kVehicle, kVehicleGfx, kConfSet
  pPlayer = kPlayer
  pVehicle = kVehicle
  pVehicleGfx = kVehicleGfx
  pEffectsActive = 0
  pEnablePolyline = 0
  pPolylineWidth = 10
  pPolylineSegments = 15
  pPolylineTextureMapK = 0.33000000000000002
  pPolylineMinTimeBetweenPoint = 100.0
  pPolylineMinDistanceBetweenPoint = VOID
  pPolylineBlend = 100.0
  pPolyTextureName = "fx_trails"
  pEnablePowder = 0
  pPowderTextureName = "fx_fumo_bianco_dyn"
  pPowderEmitterRegion = [vector(0.0, 0.0, 0.0), vector(0.0, 0.0, 0.0), vector(0.0, 0.0, 0.0), vector(0.0, 0.0, 0.0)]
  pBrakeLightsEnabled = 0
  pBrakeLightsOn = 0
  pRetroLightsEnabled = 0
  pRetroLightsOn = 0
  return me
end

on GetPlayer me
  return pPlayer
end

on GetVehicle me
  return pVehicle
end

on GetVehicleGfx me
  return pVehicleGfx
end

on GetEffectsActive me
  return pEffectsActive
end

on GetPolylineWidth me
  return pPolylineWidth
end

on GetPolylineSegments me
  return pPolylineSegments
end

on GetPolylineBlend me
  return pPolylineBlend
end

on GetBrakeLightsOn me
  return pBrakeLightsOn
end

on GetRetroLightsOn me
  return pRetroLightsOn
end

on GetPowderActivity me
  return pPowderActivity
end

on SetEffectsActive me, kValue
  pEffectsActive = kValue
end

on SetPolylineActive me, kValue
  pEnablePolyline = kValue
end

on SetPolyTextureName me, kPolyTextureName
  pPolyTextureName = kPolyTextureName
end

on SetPolylineActivity me, kPolylineActivity
  pPolylineActivity = kPolylineActivity
end

on SetPolylineTextureMapK me, kPolylineTextureMapK
  pPolylineTextureMapK = kPolylineTextureMapK
end

on SetPolylineMinDistanceBetweenPoint me, kPolylineMinDistanceBetweenPoint
  pPolylineMinDistanceBetweenPoint = kPolylineMinDistanceBetweenPoint
end

on SetPolylineMinTimeBetweenPoint me, kPolylineMinTimeBetweenPoint
  pPolylineMinTimeBetweenPoint = kPolylineMinTimeBetweenPoint
end

on SetPolylineWidth me, kPolylineWidth
  pPolylineWidth = kPolylineWidth
end

on SetPolylineSegments me, kPolylineSegments
  pPolylineSegments = kPolylineSegments
end

on SetPolylineBlend me, kValue
  pPolylineBlend = kValue
  pPolylineShader.blend = pPolylineBlend
end

on SetPowderActive me, kValue
  pEnablePowder = kValue
end

on SetPowderTextureName me, kPowderTextureName
  pPowderTextureName = kPowderTextureName
end

on SetPowderActivity me, kPowderActivity
  pPowderActivity = kPowderActivity
end

on SetPowderEmitterRegion me, kPowderEmitterRegion
  pPowderEmitterRegion = kPowderEmitterRegion
end

on SetBrakeLightsEnabled me, kValue
  pBrakeLightsEnabled = kValue
end

on SetRetroLightsEnabled me, kValue
  pRetroLightsEnabled = kValue
end

on EffectsActive me
  return pEffectsActive
end

on Initialize me
  if pEnablePolyline then
    me.InitPolylineEffects()
  end if
  if pEnablePowder then
    me.InitPowder()
  end if
end

on InitializeBrakeLights me, kShaderRef
  pBrakeLightsShader = kShaderRef
  pBrakeLightsTimer = -1
  pBrakeLightsOn = 1
end

on InitializeRetroLights me, kShaderRef
  pRetroLightsShader = kShaderRef
  pRetroLightsTimer = -1
  pRetroLightsOn = 1
end

on InitPolylineEffects me
  pPolylineWheels = []
  pPolylineActivity = []
  lId = pPlayer.GetPlayerId()
  if voidp(gGame.Get3D().texture(pPolyTextureName)) then
    lShader = CreateShaderFromCast(gGame.Get3D(), lId & "polyShader", pPolyTextureName)
  else
    lShader = CreateShader(gGame.Get3D(), lId & "polyShader", pPolyTextureName)
  end if
  pPolylineShader = lShader
  lWheelList = pPlayer.GetVehicleGfx().GetWheelList()
  repeat with li = 1 to lWheelList.count
    if not voidp(lWheelList[li]) then
      lPolylineScript = script("PolyLine").new(gGame.Get3D(), "poly_" & lId & "_" & li & "_dyn_cam", pPolylineSegments)
      pPolylineWheels.add([#polyline: lPolylineScript, #Active: 0])
    else
      pPolylineWheels.add(VOID)
    end if
    pPolylineActivity.add(0)
  end repeat
  pPlayer.GetVehicleGfx().CalculateWheelContactPoints()
  lWheelContactPointList = pPlayer.GetVehicleGfx().GetWheelContactPointList()
  repeat with li = 1 to pPolylineWheels.count
    if not voidp(pPolylineWheels[li]) then
      lPoly = pPolylineWheels[li].polyline
      lPoly.SetTextureMapK(pPolylineTextureMapK)
      lPoly.SetMinTimeBetweenPoint(pPolylineMinTimeBetweenPoint)
      lPoly.SetMinDistanceBetweenPoint(pPolylineMinDistanceBetweenPoint)
      lPolyPosition = lWheelContactPointList[li]
      lStartPoint = [#point: lPolyPosition, #width: pPolylineWidth, #normal: vector(0, 1, 0), #tangent: vector(0, 0, 1), #shader: lShader]
      lPoly.SetStartPoint(lStartPoint)
      lPoly.BuildStrip(lShader)
      lPoly.HidePolyline()
    end if
  end repeat
end

on PrepareWheelPolyline me, kPolylineIndex
  lPoly = pPolylineWheels[kPolylineIndex].polyline
  lWheelGroundNormal = me.GetVehicle().GetHoverGroundNormal()
  lWheelContactPointList = pPlayer.GetVehicleGfx().GetWheelContactPointList()
  lPolyPosition = lWheelContactPointList[kPolylineIndex]
  lTang = pVehicle.GetDirection()
  lNewPoint = [#point: lPolyPosition, #width: pPolylineWidth, #normal: lWheelGroundNormal[kPolylineIndex], #tangent: lTang, #shader: pPolylineShader]
  lPoly.AddQuad(lNewPoint, lNewPoint)
end

on StartPolylineEffectOnWheel me, kIndex
  lPolylineWheels = pPolylineWheels[kIndex]
  if not lPolylineWheels.Active then
    me.PrepareWheelPolyline(kIndex)
    lPolylineWheels.Active = 1
    lPolylineWheels.polyline.ShowPolyline()
  end if
end

on StopPolylineEffectOnWheel me, fIndex
  if pPolylineWheels[fIndex].Active = 1 then
    pPolylineWheels[fIndex].Active = 0
  end if
end

on UpdatePolylineEffects me
  repeat with li = 1 to pPolylineWheels.count
    if voidp(pPolylineWheels[li]) then
      next repeat
    end if
    if pPolylineActivity[li] and not pPolylineWheels[li].Active then
      me.StartPolylineEffectOnWheel(li)
    end if
    if not pPolylineActivity[li] and pPolylineWheels[li].Active then
      me.StopPolylineEffectOnWheel(li)
    end if
  end repeat
  lWheelGroundNormal = me.GetVehicle().GetHoverGroundNormal()
  lWheelContactPointList = pPlayer.GetVehicleGfx().GetWheelContactPointList()
  repeat with li = 1 to pPolylineWheels.count
    if voidp(pPolylineWheels[li]) then
      next repeat
    end if
    if pPolylineWheels[li].Active then
      lPoly = pPolylineWheels[li].polyline
      lPolyPosition = lWheelContactPointList[li]
      lTang = pVehicle.GetDirection()
      lNewPoint = [#point: lPolyPosition, #width: pPolylineWidth, #normal: lWheelGroundNormal[li], #tangent: lTang, #shader: pPolylineShader]
      if lPoly.AddPoint(lNewPoint) then
        next repeat
      end if
      lPoly.ModifyLastPoint(lPolyPosition)
    end if
  end repeat
end

on InitPowder me
  pPowderTimer = [-1, -1, -1, -1]
  pPowderParticles = []
  pPowderActivity = []
  lWheelList = pPlayer.GetVehicleGfx().GetWheelList()
  repeat with li = 1 to lWheelList.count
    if not voidp(lWheelList[li]) then
      lEmitterRegion = pPowderEmitterRegion[li]
      lPowderName = "wheel_powder_" & pPlayer.GetPlayerId() & "_" & li & "_dyn"
      me.CreatePowderParticles(lPowderName, lEmitterRegion, li)
      pPowderParticles.add([#smoke: lPowderName, #Active: 0])
    else
      pPowderParticles.add(VOID)
    end if
    pPowderActivity.add(0)
  end repeat
end

on CreatePowderParticles me, kName, kEmitterRegion, kWheelId
  lWheelParticleProperties = gGame.GetParticlesManager().GetEmitter(#PowderEffect)
  lWheelParticleTexture = gGame.GetParticlesManager().GetTexture(pPowderTextureName)
  lDir = vector(0.0, 1.0, 0.0)
  lWheelParticleEffect = script("Particles").new(gGame.Get3D(), kName, lWheelParticleTexture, kEmitterRegion, lDir, lWheelParticleProperties)
  gGame.GetParticlesManager().AddParticles(kName, lWheelParticleEffect, pPlayer.GetVehicleGfx().GetGfxChassis(), -1, -1)
end

on UpdatePowderParticles me
  lTime = gGame.GetTimeManager().GetTime()
  repeat with li = 1 to pPowderParticles.count
    lPowderParticles = pPowderParticles[li]
    if voidp(lPowderParticles) then
      next repeat
    end if
    if pPowderActivity[li] then
      me.StartPowder(li)
      pPowderTimer[li] = lTime
      next repeat
    end if
    if (lTime - pPowderTimer[li]) > 350 then
      me.StopPowder(li)
    end if
  end repeat
end

on StartPowder me, kIndex
  if not pPowderParticles[kIndex].Active then
    pPowderParticles[kIndex].Active = 1
    gGame.GetParticlesManager().StartParticle(pPowderParticles[kIndex].smoke)
  end if
end

on StopPowder me, kIndex
  if pPowderParticles[kIndex].Active then
    gGame.GetParticlesManager().StopParticle(pPowderParticles[kIndex].smoke)
    pPowderParticles[kIndex].Active = 0
    pPowderTimer[kIndex] = -1
  end if
end

on GetPowderParticlesEffect me
  return pPowderParticles
end

on UpdateBrakeLights me, kTime
  lAcceleration = pPlayer.GetInputController().GetAcceleration()
  lSpeedKmh = pVehicle.GetSpeedKmh()
  if pBrakeLightsOn then
    if ((lSpeedKmh < 0) or (lAcceleration >= 0)) and ((kTime - pBrakeLightsTimer) > 250) then
      pBrakeLightsOn = 0
      pBrakeLightsShader.blend = 0
    end if
  else
    if (lSpeedKmh >= 0) and (lAcceleration < 0) then
      pBrakeLightsOn = 1
      pBrakeLightsShader.blend = 100
      pBrakeLightsTimer = kTime
    end if
  end if
end

on UpdateRetroLights me, kTime
  lAcceleration = pPlayer.GetInputController().GetAcceleration()
  lSpeedKmh = pVehicle.GetSpeedKmh()
  if pRetroLightsOn then
    if ((lSpeedKmh >= 0) or (lAcceleration >= 0)) and ((kTime - pRetroLightsTimer) > 250) then
      pRetroLightsOn = 0
      pRetroLightsShader.blend = 0
    end if
  else
    if (lSpeedKmh < 0) and (lAcceleration < 0) then
      pRetroLightsOn = 1
      pRetroLightsShader.blend = 100
      pRetroLightsTimer = kTime
    end if
  end if
end

on update me, kTime
  if not pEffectsActive then
    return 
  end if
  if pEnablePolyline then
    me.UpdatePolylineEffects()
  end if
  if pEnablePowder then
    me.UpdatePowderParticles()
  end if
  if pBrakeLightsEnabled then
    me.UpdateBrakeLights(kTime)
  end if
  if pRetroLightsEnabled then
    me.UpdateRetroLights(kTime)
  end if
end
