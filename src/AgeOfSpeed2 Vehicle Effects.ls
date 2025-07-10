property ancestor, pWheelRadius, pCollisionSide, pSparkesSxMdl, pSparkesDxMdl, pSparkesSxBlend, pSparkesDxBlend, pGodModeMdl, pGodModeShader, pGodModeTimer, pElektroMdl, pElektroShader, pElektroTimer, pElektroRandomRotTimer, pElektroRandomRot, pSparkesDownMdl, pSparkesDownTimer, pSpeedMdl, pSpeedBlend
global gGame

on new me, kPlayer, kVehicle, kVehicleGfx, kConfSet
  me.ancestor = script("Vehicle Effects").new(kPlayer, kVehicle, kVehicleGfx, kConfSet)
  pWheelRadius = kConfSet.WheelRadius
  return me
end

on Initialize me
  me.SetEffectsActive(1)
  me.SetPolylineActive(1)
  me.SetPolyTextureName("as2_trail0" & me.GetPlayer().GetVehicleId())
  me.SetPolylineTextureMapK(0.10000000000000001)
  me.SetPolylineWidth(24.0)
  me.SetPowderActive(0)
  if me.GetPlayer().GetPlayerId() = 1 then
    me.InitializeSparkes()
    me.InitializeSpeedEffect()
  end if
  me.InitializeSparkesDown()
  me.InitializeGodMode()
  me.InitializeElektro()
  me.ancestor.Initialize()
end

on UpdatePolylineActivity me
  lSpeedKmh = me.GetVehicle().GetSpeedKmh()
  lWheelPolylineActivity = 0
  lOnTrack = me.GetVehicle().GetShadowVisible()
  if lOnTrack and (lSpeedKmh > 100.0) and (abs(me.GetVehicle().GetSlideSpeed()) > 1300.0) and (me.GetVehicle().GetGroundDistance() < 95) then
    lWheelPolylineActivity = 1
  end if
  me.SetPolylineActivity([0, 0, lWheelPolylineActivity, lWheelPolylineActivity])
end

on GamePaused me
end

on GameResumed me
end

on InitializeSparkes me
  pSparkesSxMdl = gGame.Get3D().model("veh_coll_sx_dyn_cam")
  pSparkesSxBlend = 0
  pSparkesDxMdl = gGame.Get3D().model("veh_coll_dx_dyn_cam")
  pSparkesDxBlend = 0
  pCollisionSide = #none
end

on SetCollisionSide me, kSide
  pCollisionSide = kSide
end

on UpdateSparkes me
  lAlphaSx = 0.0
  lAlphaDx = 0.0
  if pCollisionSide = #left then
    lAlphaSx = 100.0
  else
    if pCollisionSide = #right then
      lAlphaDx = 100.0
    end if
  end if
  if lAlphaDx = 0.0 then
    if pSparkesDxBlend <> 0 then
      pSparkesDxMdl.shader.blend = 0
      pSparkesDxBlend = 0
    end if
  else
    if pSparkesDxBlend = 0 then
      pSparkesDxBlend = 100
    end if
  end if
  if lAlphaSx = 0.0 then
    if pSparkesSxBlend <> 0 then
      pSparkesSxMdl.shader.blend = 0
      pSparkesSxBlend = 0
    end if
  else
    if pSparkesSxBlend = 0 then
      pSparkesSxBlend = 100
    end if
  end if
  if pSparkesSxBlend <> 0 then
    pSparkesSxMdl.transform = me.GetPlayer().GetVehicleGfx().GetGfxChassis().transform
    pSparkesSxMdl.shader.blend = pSparkesSxBlend
  end if
  if pSparkesDxBlend <> 0 then
    pSparkesDxMdl.transform = me.GetPlayer().GetVehicleGfx().GetGfxChassis().transform
    pSparkesDxMdl.shader.blend = pSparkesDxBlend
  end if
  pCollisionSide = #none
end

on InitializeGodMode me
  pGodModeMdl = gGame.Get3D().model("shield_dyn").cloneDeep("shield_dyn_" & me.GetPlayer().GetPlayerId())
  pGodModeShader = pGodModeMdl.shader
  pGodModeMdl.transform.scale = vector(1, 1, 1)
  pGodModeMdl.pointAtOrientation = [vector(0.0, 1.0, 0.0), vector(0.0, 0.0, 1.0)]
  pGodModeMdl.visibility = #none
  pGodModeMdl.removeFromWorld()
  pGodModeTimer = -1
  gGame.GetTextureShifter().AddShader(pGodModeShader.name, 1000.0, 0.0, -0.25, gGame.GetTimeManager().GetTime(), 1)
end

on StartGodMode me
  if pGodModeTimer <> -1 then
    pGodModeTimer = gGame.GetTimeManager().GetTime() - 1000.0
  else
    pGodModeTimer = gGame.GetTimeManager().GetTime()
  end if
  pGodModeShader.blend = 0
  pGodModeMdl.visibility = #both
  pGodModeMdl.addToWorld()
end

on UpdateGodMode me, kTime
  if pGodModeTimer <> -1 then
    lNow = kTime
    lT = lNow - pGodModeTimer
    if lT > 10000.0 then
      pGodModeTimer = -1
      me.GetPlayer().SetGodMode(0)
      pGodModeMdl.visibility = #none
      pGodModeMdl.removeFromWorld()
    else
      if lT < 1000.0 then
        me.PlayGodModeEffect(lT * 0.10000000000000001)
      else
        if lT <= 7000.0 then
          me.PlayGodModeEffect(100.0)
        else
          if (lT > 7000.0) and (lT <= 7500.0) then
            me.PlayGodModeEffect((1.0 - ((lT - 7000.0) / 500.0)) * 100.0)
          else
            if (lT > 7500.0) and (lT <= 8000.0) then
              me.PlayGodModeEffect((lT - 7500.0) / 500.0 * 100.0)
            else
              if (lT > 8000.0) and (lT <= 8500.0) then
                me.PlayGodModeEffect((1.0 - ((lT - 8000.0) / 500.0)) * 100.0)
              else
                if (lT > 8500.0) and (lT <= 9000.0) then
                  me.PlayGodModeEffect((lT - 8500.0) / 500.0 * 100.0)
                else
                  if (lT > 9000.0) and (lT <= 9500.0) then
                    me.PlayGodModeEffect((1.0 - ((lT - 9000.0) / 500.0)) * 100.0)
                  else
                    if (lT > 9500.0) and (lT < 9500.0) then
                      me.PlayGodModeEffect(0.0)
                    end if
                  end if
                end if
              end if
            end if
          end if
        end if
      end if
    end if
    pGodModeMdl.transform = me.GetPlayer().GetVehicleGfx().GetGfxChassis().transform
  end if
end

on PlayGodModeEffect me, kGodValue
  pGodModeShader.blend = kGodValue
end

on InitializeElektro me
  pElektroMdl = gGame.Get3D().model("fx_bolts_dyn").cloneDeep("fx_bolts_dyn_" & me.GetPlayer().GetPlayerId())
  pElektroShader = pElektroMdl.shader
  pElektroMdl.transform.scale = vector(1, 1, 1)
  pElektroMdl.pointAtOrientation = [vector(0.0, 1.0, 0.0), vector(0.0, 0.0, 1.0)]
  pElektroMdl.visibility = #none
  pElektroMdl.removeFromWorld()
  pElektroTimer = -1
  gGame.GetTextureShifter().AddShader(pElektroShader.name, 80.0, 0.0, 0.5, gGame.GetTimeManager().GetTime(), 0)
end

on StartElektro me
  pElektroMdl.addToWorld()
  pElektroTimer = gGame.GetTimeManager().GetTime()
  pElektroRandomRotTimer = pElektroTimer
  pElektroRandomRot = 0.0
  pElektroMdl.visibility = #both
end

on UpdateElektro me, kTime
  if pElektroTimer <> -1 then
    pElektroMdl.transform = me.GetPlayer().GetVehicleGfx().GetGfxChassis().transform
    lDt = gGame.GetTimeManager().GetDeltaTime() * 0.001
    lTR = transform()
    if (kTime - pElektroRandomRotTimer) > 100 then
      pElektroRandomRotTimer = kTime
      pElektroRandomRot = random(360)
    end if
    lTR.rotation.z = pElektroRandomRot
    pElektroMdl.transform = pElektroMdl.transform * lTR
    lNow = kTime
    lT = lNow - pElektroTimer
    if lT > 8000.0 then
      pElektroTimer = -1
      pElektroMdl.visibility = #none
      pElektroMdl.removeFromWorld()
    else
      if lT < 1000.0 then
        me.PlayElectricEffect(lT * 0.001 * 40)
      else
        if lT < 7000.0 then
          me.PlayElectricEffect(75)
        else
          if lT > 7000.0 then
            me.PlayElectricEffect((1.0 - ((lT - 7000.0) * 0.001)) * 40)
          end if
        end if
      end if
    end if
    repeat with lPlayerRef in gGame.GetPlayers()
      if lPlayerRef <> me.GetPlayer() then
        if not lPlayerRef.GetUnderElektro() and not lPlayerRef.GodMode() then
          lDistanceFromTarget = (lPlayerRef.getPosition() - me.GetPlayer().getPosition()).magnitude
          if lDistanceFromTarget < 1000 then
            lPlayerRef.SetUnderElektro(1)
          end if
        end if
      end if
    end repeat
  end if
end

on PlayElectricEffect me, kValue
  pElektroShader.blend = kValue + random(25)
end

on InitializeSparkesDown me
  pSparkesDownMdl = me.GetPlayer().GetVehicleGfx().GetGfxChassis().child[2]
  pSparkesDownMdl.visibility = #none
  pSparkesDownTimer = -1
end

on StartSparkesDown me, kTime
  pSparkesDownTimer = kTime
  pSparkesDownMdl.visibility = #front
end

on UpdateSparkesDown me, kTime
  if pSparkesDownTimer <> -1 then
    if ((kTime - pSparkesDownTimer) > 750) or (abs(me.GetVehicle().GetGroundDistance()) > 90.0) then
      pSparkesDownTimer = -1
      pSparkesDownMdl.visibility = #none
    end if
  end if
end

on InitializeSpeedEffect me
  pSpeedMdl = gGame.Get3D().model("fx_turbo_dyn")
  pSpeedBlend = 0.0
end

on UpdateSpeedEffect me
  pSpeedMdl.transform = me.GetPlayer().GetVehicleGfx().GetGfxChassis().transform
  lSpeedCoeff = me.GetPlayer().GetVehicle().GetSpeedKmh() * 0.22
  if lSpeedCoeff < 70 then
    lBlend = 0.0
  else
    if lSpeedCoeff > 100 then
      lSpeedCoeff = 100
    end if
    lBlend = lSpeedCoeff
  end if
  lDt = gGame.GetTimeManager().GetDeltaTime() * 0.001
  pSpeedBlend = pSpeedBlend + ((lBlend - pSpeedBlend) * lDt * 2.0)
  pSpeedMdl.shader.blend = pSpeedBlend
end

on update me, kTime
  me.UpdatePolylineActivity()
  if me.GetPlayer().GetPlayerId() = 1 then
    me.UpdateSparkes()
    me.UpdateSpeedEffect()
  end if
  me.UpdateSparkesDown(kTime)
  me.UpdateGodMode(kTime)
  me.UpdateElektro(kTime)
  me.ancestor.update(kTime)
end
