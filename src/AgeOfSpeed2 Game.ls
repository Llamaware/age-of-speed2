property ancestor, pObjects3D, pPlayer3D, pHavokMember, pTextureMember, pGameSounds, pTokenDefinition, pAiBalancer, pVehicleStartPosition, pPlayers, pPlayerId, pPlayerScore, pConfSets, pLevelId, pBillboardManager, pLastPlayerVehicleCollisionTime, pTrackLength, pBestTime, pRecordOnBestTime, pFastTime, pBestSessionScore, pHowManyPlayers, pDynamycFovEnabled, pDifficult, pFinalPlacement, pFrameCounter, pRotationShader, pElectricShader, pElectricShaderTimer, pElectricOn, pElektroShader, pSetId, pAllId, pSky3D, pMissileManager, pExplosionManager, pBonusCheckPointManager

on new me
  pObjects3D = member(11)
  pPlayer3D = member(5)
  pSky3D = member(14)
  pHavokMember = member(180)
  me.ancestor = script("Game").new()
  me.ancestor.Initialize("AgeOfSpeed2 Gameplay", "AgeOfSpeed2 Ingame", "AgeOfSpeed2 Offgame", "AgeOfSpeed2 Camera")
  me.SetVersionId("Ver 0.58")
  return me
end

on GetMissileManager me
  return pMissileManager
end

on GetExplosionManager me
  return pExplosionManager
end

on GetSky3D me
  return pSky3D
end

on GetSetId me
  return pSetId
end

on GetAllId me
  return pAllId
end

on GetFinalPlacement me
  return pFinalPlacement
end

on GetFrameCounter me
  return pFrameCounter
end

on GetDifficult me
  return pDifficult
end

on GetHowManyPlayers me
  return pHowManyPlayers
end

on GetBestTime me
  return pBestTime
end

on GetFastTime me
  return pFastTime
end

on GetAIBalancer me
  return pAiBalancer
end

on GetPlayerId me
  return pPlayerId
end

on GetGameSoundManager me
  return pGameSounds
end

on GetPlayers me
  return pPlayers
end

on GetPlayerVehicle me
  return pPlayers[1]
end

on GetObjects3D me
  return pObjects3D
end

on GetPlayer3D me
  return pPlayer3D
end

on GetTextureMember me
  return pTextureMember
end

on GetLevelId me
  return pLevelId
end

on GetPlayerScore me
  return pPlayerScore
end

on GetConfSets me
  return pConfSets
end

on GetTrackLength me
  return pTrackLength
end

on GetPositionInRace me, kPlayer
  lPosition = 1
  lPlayerRaceTrackPos = kPlayer.GetRaceTrackPos()
  lPlayers = me.GetPlayers()
  repeat with li = 1 to lPlayers.count
    lVehicleRef = lPlayers[li]
    if lVehicleRef <> kPlayer then
      if ((lVehicleRef.GetRaceTrackPos() >= lPlayerRaceTrackPos) and (kPlayer.GetRaceTime() = -1)) or ((lVehicleRef.GetRaceTime() < kPlayer.GetRaceTime()) and (kPlayer.GetRaceTime() <> -1) and (lVehicleRef.GetRaceTime() <> -1)) then
        lPosition = lPosition + 1
      end if
    end if
  end repeat
  return lPosition
end

on GetBestSessionScore me
  return pBestSessionScore
end

on GetTokenDefinition me
  return pTokenDefinition
end

on GetBillboardManager me
  return pBillboardManager
end

on SetSetId me, kSetId
  pSetId = kSetId
end

on SetAllId me, kAllId
  pAllId = kAllId
end

on SetFinalPlacement me, kValue
  pFinalPlacement = kValue
end

on SetDifficult me, kDifficult
  pDifficult = kDifficult
end

on SetFastTime me, kFastTime
  pFastTime = kFastTime
end

on SetRecordOnBestTime me, kRecordOnBestTime
  pRecordOnBestTime = kRecordOnBestTime
end

on SetBestTime me, kBestTime
  pBestTime = kBestTime
end

on SetTrackLength me, kTrackLength
  pTrackLength = kTrackLength
end

on SetPlayerId me, kPlayerId
  pPlayerId = kPlayerId
end

on SetPlayerScore me, kPlayerScore
  pPlayerScore = kPlayerScore
end

on SetLevelId me, kLevelId
  pLevelId = kLevelId
end

on SetPlayerVehiclePosition me, kPosition
  pPlayers[1].setPosition(kPosition)
end

on HaveDoneRecordOnBestTime me
  return pRecordOnBestTime
end

on SetBestSessionScore me, kBestSessionScore
  pBestSessionScore = kBestSessionScore
end

on SetTokenDefinition me, kTokenDefinition
  pTokenDefinition = kTokenDefinition
end

on SetHowManyPlayers me, kHowManyPlayers
  pHowManyPlayers = kHowManyPlayers
end

on SetupVehicleConfigs me
  lVehicleResistance = 0.69999999999999996
  lAccGain = 0.0815
  lMaxSpeed = 15500.0
  lLimitSpeed = 15000.0
  lBrakeGain = 0.23999999999999999
  lCpuBrakeGain = 0.29999999999999999
  lEngineBrakeGain = 0.098
  lDrag = 0.025
  lGrip = 0.59999999999999998
  lLowGrip = 0.59999999999999998
  lLowGripSpeed = 50
  lHoverDistance = 85.0
  lStrength = 110.0
  lDamping = 0.17999999999999999
  lTurnGain = 2.5
  pConfSets = [#human: [#ChassisMass: 100.0, #ChassisFriction: 0.0, #ChassisRestitution: 0.01, #ChassisWidth: 230.0, #WheelLongitudinal: 295.30399999999997362, #WheelRadius: 84.85699999999999932, #strength: lStrength, #damping: lDamping, #HoverDist: lHoverDistance, #maxSpeed: lMaxSpeed, #LimitSpeed: lLimitSpeed, #MaxWheelTurn: 60.0, #WheelSpinCoeff: 0.0, #AccGain: lAccGain, #DecGain: 0.10000000000000001, #BrakeGain: lBrakeGain, #MaxTurnSpeed: 4.0, #TurnGain: lTurnGain, #RestPositionSteeringResistence: 0.0, #OppositeSteeringResistence: 0.0, #Grip: lGrip, #LowGrip: lLowGrip, #LowGripSpeed: lLowGripSpeed, #drag: lDrag, #EngineBrakeGain: lEngineBrakeGain, #CPUMinLookahead: 500.0, #CPUSpeedLookaheadFactor: 12.0, #AccGainFactor: 1.0, #BrakeGainFactor: 1.39999999999999991, #LowVelocityTurnGain: 7.5, #MinPowerCoeff: 0.25, #MinAccelerationOnAir: -0.25, #MaxAccelerationOnAir: 0.90000000000000002, #VehicleResistance: lVehicleResistance, #WheelOffset: vector(0.0, 5.24399999999999977, 0.0)], #cpu: [#ChassisMass: 100.0, #ChassisFriction: 0.0, #ChassisRestitution: 0.01, #ChassisWidth: 230.0, #WheelLongitudinal: 295.30399999999997362, #WheelRadius: 84.85699999999999932, #strength: lStrength, #damping: lDamping, #HoverDist: lHoverDistance, #maxSpeed: lMaxSpeed, #LimitSpeed: lLimitSpeed, #MaxWheelTurn: 60.0, #WheelSpinCoeff: 0.0, #AccGain: lAccGain, #DecGain: 0.10000000000000001, #BrakeGain: lCpuBrakeGain, #MaxTurnSpeed: 4.0, #TurnGain: lTurnGain * 1.55000000000000004, #RestPositionSteeringResistence: 0.0, #OppositeSteeringResistence: 0.0, #Grip: lGrip, #LowGrip: lLowGrip, #LowGripSpeed: lLowGripSpeed, #drag: lDrag, #EngineBrakeGain: lEngineBrakeGain, #CPUMinLookahead: 500.0, #CPUSpeedLookaheadFactor: 12.0, #AccGainFactor: 1.0, #BrakeGainFactor: 1.39999999999999991, #LowVelocityTurnGain: 7.5, #MinPowerCoeff: 0.25, #MinAccelerationOnAir: -0.25, #MaxAccelerationOnAir: 0.90000000000000002, #VehicleResistance: lVehicleResistance, #WheelOffset: vector(0.0, 5.24399999999999977, 0.0)]]
end

on InitializeTextureShifting me
  lNow = me.GetTimeManager().GetTime()
  me.GetTextureShifter().AddShader("as2_enstripe_mat", 1000.0, 0.0, 0.25, lNow, 1)
  me.GetTextureShifter().AddShader("as2_turbotext_mat", 500.0, 0.0, 0.5, lNow, 1)
  me.GetTextureShifter().AddShader("as2_sky_lighting3_mat", 1000.0, 0.10000000000000001, 0.0, lNow, 1)
  me.GetTextureShifter().AddShader(me.Get3D().model("veh_coll_sx_dyn_cam").shader.name, 10, -0.68000000000000005, 0.0, lNow, 1)
  me.GetTextureShifter().AddShader(me.Get3D().model("veh_coll_dx_dyn_cam").shader.name, 10, -0.68000000000000005, 0.0, lNow, 1)
  me.GetTextureShifter().AddShader("as2_sparkles_mat", 10, -0.68000000000000005, 0.0, lNow, 1)
  me.GetTextureShifter().AddShader("spc_fx_turbo_mat", 400.0, 0.0, 0.5, lNow, 1)
end

on SetupEffects me
  me.GetParticlesManager().CreateTextureFromModel(me.Get3D(), "fx_fumo_bianco_dyn")
  lEmitterMissileWhiteSmoke = [#numParticles: 15, #angle: 20, #lifeTime: 800, #StartSize: 100.0, #EndSize: 350.0, #StartColor: rgb(255, 255, 255), #endColor: rgb(255, 255, 255), #gravity: vector(0, 0, 4), #wind: vector(0, 0, 0), #distribution: #linear, #mode: #stream, #maxSpeed: 300.0, #minSpeed: 200.0, #StartBlend: 50, #EndBlend: 10, #loop: 1, #tweenMode: #age]
  me.GetParticlesManager().AddEffect(#MissileWhiteSmoke, lEmitterMissileWhiteSmoke)
end

on InitializeBonus me
  me.SetBonusManager(script("AgeOfSpeed2 Bonus Manager").new(me.GetCamera().GetCameraNode()))
  lBonusTypes = [#bon_money: [#model: me.Get3D().model("bon_money_cam"), #effect: #money, #ModelResourceRef: me.Get3D().modelResource("bon_money"), #ModelShaderRef: [me.Get3D().shader("as2_money_mat")], #ShadowResourceRef: VOID, #ShadowShaderRef: VOID, #isBillboard: 0], #bon_shield: [#model: me.Get3D().model("bon_shield_cam"), #effect: #shield, #ModelResourceRef: me.Get3D().modelResource("bon_shield"), #ModelShaderRef: [me.Get3D().shader("as2_bon_shield_mat")], #ShadowResourceRef: VOID, #ShadowShaderRef: VOID, #isBillboard: 0], #bon_missile: [#model: me.Get3D().model("bon_missile_cam"), #effect: #missile, #ModelResourceRef: me.Get3D().modelResource("bon_missile"), #ModelShaderRef: [me.Get3D().shader("as2_bon_missile_mat")], #ShadowResourceRef: VOID, #ShadowShaderRef: VOID, #isBillboard: 0], #bon_bolt: [#model: me.Get3D().model("bon_bolt_cam"), #effect: #bolt, #ModelResourceRef: me.Get3D().modelResource("bon_bolt"), #ModelShaderRef: [me.Get3D().shader("as2_bon_bolt_mat")], #ShadowResourceRef: VOID, #ShadowShaderRef: VOID, #isBillboard: 0]]
  me.GetBonusManager().InitBonusTypes(lBonusTypes)
end

on InitializeTokenManager me, kTrackBuilderResult
  lTokenDefinition = script("AgeOfSpeed2 Automatic Token Definition").new()
  lTokenTypes = lTokenDefinition.GetTokensTypes()
  lTrackTokens = lTokenDefinition.GetTrackTokens()
  lHowManyTokens = lTrackTokens.count
  lTokenManager = script("AgeOfSpeed2 Token Manager").new()
  lTokenManager.SetExpansionWidth(2000.0, 0.0)
  lTokenManager.SetTokenTypes(lTokenTypes)
  lTokenManager.SetTrackTokens(lTrackTokens)
  lTokenManager.InitializeTrackTokens()
  me.SetTokenManager(lTokenManager)
  me.GetCullingManager().BuildTokenGrid(lTrackTokens)
  return lHowManyTokens
end

on InitializeCamera me
  lBackCarAngleCoeff = 15000.0
  lBackCarCamera = [#CameraSourceOffset: vector(0.0, -585.0, 125.0), #TargetOffset: vector(0.0, 50.0, 90.0), #CameraUp: vector(0.0, 0.0, 1.0), #AngleCoeff: lBackCarAngleCoeff, #SourceSteps: 7, #TargetSteps: 10, #SpeedBase: 0.97999999999999998, #SpeedCoeff: 750.0]
  lStartCamera = [#CameraSourceOffset: vector(0.0, -5000.0, 540.0), #TargetOffset: vector(0.0, 50.0, 60.0), #CameraUp: vector(0.0, 0.0, 1.0), #SourceSteps: 7, #TargetSteps: 10]
  lCameraData = [:]
  lCameraData.addProp(#BackCar, lBackCarCamera)
  lCameraData.addProp(#ThirthPersonSpotStart, lStartCamera)
  me.GetCamera().Initialize(me.Get3D().model("veh_chassis_1"), lCameraData)
end

on InitializeSequences me
  lSequenceManager = me.GetSequenceManager()
  lLevelStart = [[#function: #StopVehicles, #object: me.GetGameplay(), #time: 1], [#function: #SetStartCamera, #object: me.GetGameplay(), #time: 1], [#function: #ShowInitialBriefing, #object: me.GetGameplay(), #time: 2000], [#function: #PopupSound, #object: me.GetGameplay(), #time: 2200], [#function: #Three, #object: me.GetGameplay(), #time: 7000], [#function: #ReadySound, #object: me.GetGameplay(), #time: 7200], [#function: #Two, #object: me.GetGameplay(), #time: 8000], [#function: #ReadySound, #object: me.GetGameplay(), #time: 8200], [#function: #One, #object: me.GetGameplay(), #time: 9000], [#function: #ReadySound, #object: me.GetGameplay(), #time: 9200], [#function: #go, #object: me.GetGameplay(), #time: 10000], [#function: #GoSound, #object: me.GetGameplay(), #time: 10100], [#function: #AiActivation, #object: me.GetGameplay(), #time: 10300], [#function: #StartVehicles, #object: me.GetGameplay(), #time: 10300], [#function: #StartGameplay, #object: me.GetGameplay(), #time: 10300], [#function: #StartInputControl, #object: me.GetGameplay(), #time: 10300]]
  lSequenceManager.RegisterSequence("LevelStart", lLevelStart)
  lLevelStart = [[#function: #StopVehicles, #object: me.GetGameplay(), #time: 1], [#function: #SetStartCamera, #object: me.GetGameplay(), #time: 1], [#function: #PopupTutorial, #object: me.GetGameplay(), #time: 2000], [#function: #PopupSound, #object: me.GetGameplay(), #time: 2200], [#function: #ShowInitialBriefing, #object: me.GetGameplay(), #time: 7000], [#function: #PopupSound, #object: me.GetGameplay(), #time: 7200], [#function: #Three, #object: me.GetGameplay(), #time: 12000], [#function: #ReadySound, #object: me.GetGameplay(), #time: 12200], [#function: #Two, #object: me.GetGameplay(), #time: 13000], [#function: #ReadySound, #object: me.GetGameplay(), #time: 13200], [#function: #One, #object: me.GetGameplay(), #time: 14000], [#function: #ReadySound, #object: me.GetGameplay(), #time: 14200], [#function: #go, #object: me.GetGameplay(), #time: 15000], [#function: #GoSound, #object: me.GetGameplay(), #time: 15100], [#function: #AiActivation, #object: me.GetGameplay(), #time: 15300], [#function: #StartVehicles, #object: me.GetGameplay(), #time: 15300], [#function: #StartGameplay, #object: me.GetGameplay(), #time: 15300], [#function: #StartInputControl, #object: me.GetGameplay(), #time: 15300]]
  lSequenceManager.RegisterSequence("LevelStartWithHelp", lLevelStart)
  lLevelEndNormal = [[#function: #HumanToCpuControl, #object: me.GetGameplay(), #time: 100], [#function: #SetHudFinishTime, #object: me.GetGameplay(), #time: 200], [#function: #SetFinishCamera, #object: me.GetGameplay(), #time: 500], [#function: #StopAllSounds, #object: me.GetGameplay(), #time: 100], [#function: #PlaySoundLevelEndGood, #object: me.GetGameplay(), #time: 150], [#function: #CalculateAvgSpeed, #object: me.GetGameplay(), #time: 1], [#function: #ShowFinalOverlay, #object: me.GetInGame(), #time: 1500], [#function: #StartFadeEndLevel, #object: me.GetGameplay(), #time: 4500], [#function: #SetLevelCompleted, #object: me.GetGameplay(), #time: 1]]
  lSequenceManager.RegisterSequence("LevelEndNormal", lLevelEndNormal)
end

on Scan3DWorld me
  l3D = me.Get3D()
  lSkyMdlCount = 0
  lSafePoints = []
  lSetToLoad = pSetId
  lGates = []
  lMdlsToDelete = []
  repeat with li = 1 to l3D.model.count
    lModel = l3D.model[li]
    lName = lModel.name
    if (lName contains "_2side") or (lName starts "l_t") or (lName starts "border") then
      lModel.visibility = #both
      if lName starts "l_t" then
        lModel.resource.lod.auto = 0
        lModel.resource.lod.level = 100
        lModel.addModifier(#meshDeform)
        repeat with lj = 1 to lModel.shaderList.count
          lShaderRef = lModel.shaderList[lj]
          lNewShader = VOID
          if not voidp(lShaderRef) then
            if lShaderRef.name starts "as2_str4_mat" then
              lNewShader = l3D.shader("as2_str" & pAllId & "_mat")
            else
              if lShaderRef.name starts "as2_str4_side_mat" then
                lNewShader = l3D.shader("as2_str" & pAllId & "_side_mat")
              end if
            end if
          end if
          if not voidp(lNewShader) then
            lModel.shaderList[lj] = lNewShader
          end if
        end repeat
      end if
      if pAllId <> 1 then
        if lName starts "border" then
          lMdlsToDelete.add(lModel)
        end if
      end if
    end if
    if lName starts "all1_gate" then
      lGates.add(lModel.transform.position)
    end if
    if lName starts "l_t" then
      lSafePoints.add(lModel.transform.position)
    end if
    if lName starts "set" then
      lStartIdxPos = offset("_", lName)
      lSetId = integer(chars(lName, 4, lStartIdxPos - 1))
      if lSetId <> lSetToLoad then
        lMdlsToDelete.add(lModel)
      end if
    end if
    if lName = "finish_cam" then
      lStartPos = lModel.transform.position
    end if
  end repeat
  lMdlsToDelete.add(l3D.model("text"))
  lHavokRef = me.GetHavokPhysics().GetHavok()
  repeat with li = 1 to lMdlsToDelete.count
    lName = lMdlsToDelete[li].name
    lModelRB = lHavokRef.rigidBody(lName)
    if not voidp(lModelRB) then
      lHavokRef.deleteRigidBody(lName)
    end if
    l3D.model(lName).removeFromWorld()
    l3D.deleteModel(lName)
  end repeat
  InitializeDistanceFromStart(lStartPos)
  me.GetGameplay().InitializeSafePointsInfo(lSafePoints)
  me.GetGameplay().InitializeGates(lGates)
end

on CreateModels me, lHowManyPlayers
  l3D = me.Get3D()
  l3D.cloneModelFromCastmember("bon_money_cam", "bon_money", me.GetObjects3D())
  l3D.model("bon_money_cam").visibility = #none
  l3D.model("bon_money_cam").removeFromWorld()
  l3D.cloneModelFromCastmember("bon_shield_cam", "bon_shield", me.GetObjects3D())
  l3D.model("bon_shield_cam").visibility = #none
  l3D.model("bon_shield_cam").removeFromWorld()
  l3D.cloneModelFromCastmember("bon_bolt_cam", "bon_bolt", me.GetObjects3D())
  l3D.model("bon_bolt_cam").visibility = #none
  l3D.model("bon_bolt_cam").removeFromWorld()
  l3D.cloneModelFromCastmember("bon_missile_cam", "bon_missile", me.GetObjects3D())
  l3D.model("bon_missile_cam").visibility = #none
  l3D.model("bon_missile_cam").removeFromWorld()
  l3D.cloneModelFromCastmember("shield_dyn", "shield", me.GetObjects3D())
  l3D.model("shield_dyn").visibility = #none
  l3D.model("shield_dyn").removeFromWorld()
  l3D.cloneModelFromCastmember("missile_dyn", "fx_missile", me.GetObjects3D())
  l3D.model("missile_dyn").visibility = #none
  l3D.model("missile_dyn").removeFromWorld()
  l3D.cloneModelFromCastmember("brake01_fx", "brake01_fx", me.GetObjects3D())
  l3D.model("brake01_fx").visibility = #none
  l3D.model("brake01_fx").removeFromWorld()
  l3D.cloneModelFromCastmember("brake02_fx", "brake02_fx", me.GetObjects3D())
  l3D.model("brake01_fx").visibility = #none
  l3D.model("brake01_fx").removeFromWorld()
  l3D.cloneModelFromCastmember("brake03_fx", "brake03_fx", me.GetObjects3D())
  l3D.model("brake01_fx").visibility = #none
  l3D.model("brake01_fx").removeFromWorld()
  l3D.cloneModelFromCastmember("brake04_fx", "brake04_fx", me.GetObjects3D())
  l3D.model("brake01_fx").visibility = #none
  l3D.model("brake01_fx").removeFromWorld()
  l3D.cloneModelFromCastmember("fx_fumo_bianco_dyn", "fx_fumobianco", me.GetObjects3D())
  l3D.model("fx_fumo_bianco_dyn").visibility = #none
  l3D.model("fx_fumo_bianco_dyn").removeFromWorld()
  l3D.cloneModelFromCastmember("fx_fumo_nero_dyn", "fx_fumonero", me.GetObjects3D())
  l3D.model("fx_fumo_nero_dyn").visibility = #none
  l3D.model("fx_fumo_nero_dyn").removeFromWorld()
  lCollMdlSx = l3D.cloneModelFromCastmember("veh_coll_sx_dyn_cam", "fx_left", me.GetPlayer3D())
  lCollMdlSx.shader.blend = 0
  lCollMdlDx = l3D.cloneModelFromCastmember("veh_coll_dx_dyn_cam", "fx_right", me.GetPlayer3D())
  l3D.deleteShader(lCollMdlDx.shader.name)
  lShaderDx = DuplicateShader(me.Get3D(), lCollMdlSx.shaderList[1], "s3m_veh_coll_mat_dx")
  lCollMdlDx.shaderList = [lShaderDx]
  l3D.cloneModelFromCastmember("fx_exp_dyn", "fx_exp", me.GetObjects3D())
  l3D.model("fx_exp_dyn").visibility = #none
  l3D.model("fx_exp_dyn").removeFromWorld()
  l3D.cloneModelFromCastmember("fx_bolts_dyn", "fx_bolts", me.GetObjects3D())
  l3D.model("fx_bolts_dyn").visibility = #none
  l3D.model("fx_bolts_dyn").removeFromWorld()
  l3D.cloneModelFromCastmember("fx_turbo_dyn", "spc_fx_turbo", me.GetObjects3D())
end

on OnPreload me
  if me.GetConfiguration() = #debug then
    pObjects3D.importFileInto("data\objects.w3d")
    pPlayer3D.importFileInto("data\player.w3d")
    pHavokMember = member(180 + me.GetLevelId() - 1)
    pHavokMember.importFileInto("data\hke\level_" & me.GetLevelId() & ".hke")
  end if
  pObjects3D.preload()
  pPlayer3D.preload()
  if me.GetConfiguration() = #release_web then
    me.Get3D().loadFile("level_" & me.GetLevelId() & ".w3d")
    me.GetSky3D().loadFile("sky_all" & me.GetAllId() & ".w3d")
  else
    me.Get3D().loadFile("dswmedia\level_" & me.GetLevelId() & ".w3d")
    me.GetSky3D().loadFile("dswmedia\sky_all" & me.GetAllId() & ".w3d")
    if me.GetPreilluminationCalculate() then
      lPreilluminationFileToLoad = "data/lm/lm_level_" & me.GetLevelId() & ".w3d"
      me.GetPreilluminationDataMember().resetWorld()
      me.GetPreilluminationDataMember().loadFile(lPreilluminationFileToLoad)
    end if
  end if
  me.GetOffGame().GoToLoadScreen()
end

on IsLoaded me
  if me.GetPreilluminationCalculate() then
    lPreilluminationCheck = me.GetPreilluminationDataMember().state = 4
  else
    lPreilluminationCheck = 1
  end if
  return (me.Get3D().state = 4) and lPreilluminationCheck and (me.GetSky3D().state = 4)
end

on OnLoaded me
  put "On Loaded"
  l3D = me.Get3D()
  l3D.cloneModelFromCastmember("sky", "sky", me.GetSky3D())
  l3D.cloneModelFromCastmember("player_text", "text", me.GetPlayer3D())
  repeat with li = 1 to pHowManyPlayers
    lHumanPlayerId = me.GetPlayerId() - 1
    lTextureId = lHumanPlayerId + li
    if lTextureId > 4 then
      lTextureId = lTextureId - 4
    end if
    lGfxChassis = l3D.cloneModelFromCastmember("veh_chassis_" & li & "_gfx_cam", "car1_chassis", me.GetPlayer3D())
    lShadowMdl = l3D.cloneModelFromCastmember("veh_shadow_" & li, "car1_shadow", me.GetPlayer3D())
    lWheelfr = l3D.cloneModelFromCastmember("veh_wheel_fr_" & li, "car1_wheel_fr", me.GetPlayer3D())
    lWheelbr = l3D.cloneModelFromCastmember("veh_wheel_br_" & li, "car1_wheel_br", me.GetPlayer3D())
    lWheelfl = l3D.cloneModelFromCastmember("veh_wheel_fl_" & li, "car1_wheel_fl", me.GetPlayer3D())
    lWheelbl = l3D.cloneModelFromCastmember("veh_wheel_bl_" & li, "car1_wheel_bl", me.GetPlayer3D())
    repeat with lj = 1 to lGfxChassis.shaderList.count
      lShaderRef = lGfxChassis.shaderList[lj]
      lNewShader = VOID
      if not voidp(lShaderRef) then
        if lShaderRef.name starts "as2_car01_mat" then
          lNewShader = l3D.shader("as2_car0" & lTextureId & "_mat")
          SetEnvmapEffectShader(lNewShader)
        end if
      end if
      if not voidp(lNewShader) then
        lGfxChassis.shaderList[lj] = lNewShader
      end if
    end repeat
    repeat with lj = 1 to lShadowMdl.shaderList.count
      lShaderRef = lShadowMdl.shaderList[lj]
      lNewShader = VOID
      if not voidp(lShaderRef) then
        if lShaderRef.name starts "as2_car01shadow_mat" then
          lNewShader = l3D.shader("as2_car0" & lTextureId & "shadow_mat")
        end if
      end if
      if not voidp(lNewShader) then
        lShadowMdl.shaderList[lj] = lNewShader
      end if
    end repeat
    me.SetupWheelTexture(lWheelfr, lTextureId)
    me.SetupWheelTexture(lWheelbr, lTextureId)
    me.SetupWheelTexture(lWheelfl, lTextureId)
    me.SetupWheelTexture(lWheelbl, lTextureId)
    lAddOn = l3D.cloneModelFromCastmember("car" & lTextureId & "_wings", "car" & lTextureId & "_wings", me.GetPlayer3D())
    SetEnvmapEffectShader(lAddOn.shader)
    lGfxChassis.addChild(lAddOn)
    lSparksDown = l3D.cloneModelFromCastmember("fx_under_" & lTextureId, "fx_under", me.GetPlayer3D())
    lSparksDown.shader = l3D.shader("as2_sparkles_mat")
    lGfxChassis.addChild(lSparksDown)
  end repeat
  me.CreateModels(pHowManyPlayers)
  l3D.deleteModel("player_text")
end

on SetupWheelTexture me, kWheelMdl, kTextureId
  l3D = me.Get3D()
  repeat with lj = 1 to kWheelMdl.shaderList.count
    lShaderRef = kWheelMdl.shaderList[lj]
    lNewShader = VOID
    if not voidp(lShaderRef) then
      if lShaderRef.name starts "as2_wheels1_mat" then
        lNewShader = l3D.shader("as2_wheels" & kTextureId & "_mat")
      end if
    end if
    if not voidp(lNewShader) then
      kWheelMdl.shaderList[lj] = lNewShader
    end if
  end repeat
end

on OnBegin me, kSprite
  the randomSeed = the ticks
  pFinalPlacement = -1
  pRecordOnBestTime = 0
  pFastTime = 0
  me.GetGameplay().Initialize()
  me.SetGameStatus(#Init)
  me.SetCameraUpdatePlace(#PrepareFrameEnd)
  pPlayers = VOID
  pLastPlayerVehicleCollisionTime = -1
  lHavokPhysicsData = [#hkeFile: 1, #havokMember: member(180 + me.GetLevelId() - 1), #dragParameters: [10.0, 30000.0], #deactivationParameters: [0.0, 0.0], #gravity: vector(0.0, 0.0, 0.0), #timeStepClamping: 0.06, #subSteps: 8]
  lHavokPhysics = script("Havok Physics").new(me.Get3D(), lHavokPhysicsData)
  lHavokPhysics.Initialize()
  me.SetHavokPhysics(lHavokPhysics)
  me.SetupVehicleConfigs()
  case me.GetLevelId() of
    1:
      lWorldMin = vector(-128152.0, -85157.30499999999301508, 0.0)
      lWorldMax = vector(18997.54699999999866122, 50969.36699999999837019, 0.0)
    2:
      lWorldMin = vector(-50535.78500000000349246, -41297.11699999999837019, 0.0)
      lWorldMax = vector(96613.76600000000325963, 133761.78099999998812564, 0.0)
    3:
      lWorldMin = vector(-61578.05900000000110595, -62177.375, 0.0)
      lWorldMax = vector(84210.875, 146061.28099999998812564, 0.0)
    4:
      lWorldMin = vector(-46309.98799999999755528, -58864.16000000000349246, 0.0)
      lWorldMax = vector(62445.47299999999813735, 109477.67200000000593718, 0.0)
  end case
  lCullingData = [#ViewDistance: 25000.0, #blockSize: 5000.0, #WorldMin: lWorldMin, #WorldMax: lWorldMax, #CullDistance: 18000.0, #CullDistanceBig: 240000.0]
  lCullingManager = script("Culling Manager").new(lCullingData, kSprite.camera, me.GetTimeManager())
  lHorizontalCullingBlocks = lCullingManager.GetHorizontalBlockNum()
  lVerticalCullingBlocks = lCullingManager.GetVerticalBlockNum()
  me.SetCullingManager(lCullingManager)
  me.SetCheckpointManager(script("Checkpoint Manager").new(lCullingData.WorldMin, lCullingData.WorldMax, lHorizontalCullingBlocks, lVerticalCullingBlocks, pHowManyPlayers))
  pBonusCheckPointManager = script("Checkpoint Manager").new(lCullingData.WorldMin, lCullingData.WorldMax, lHorizontalCullingBlocks, lVerticalCullingBlocks, 1)
  lHowManyTokens = me.InitializeTokenManager()
  me.SetSkyManager(script("Sky Manager").new(0))
  me.ancestor.OnBegin(kSprite)
  set the floatPrecision to 4
  me.SetupEffects()
  me.InitializeBonus()
  me.Scan3DWorld()
  lResourceManager = script("AgeOfSpeed2 Resources Manager").new()
  lResourceFileName = "resources_" & me.GetLevelId()
  lResourceManager.LoadResources(lResourceFileName, me.GetConfiguration())
  me.GetBonusManager().PlaceBonus()
  lBonusArray = me.GetBonusManager().GetBonusArray()
  repeat with li = 1 to lBonusArray.count
    lBonusRef = lBonusArray[li]
    lCkpData = [#bonus: lBonusRef, #mdl: lBonusRef.pModelRef]
    lBonusRef.pModelRef.removeFromWorld()
    pBonusCheckPointManager.add("Bonus_" & li, lBonusRef.pPosition, 30000.0, 1, #Bonus_in, #Bonus_out, lCkpData, lCkpData, #spheric)
  end repeat
  me.InitializePlayers(lCullingData)
  lSkyRef = me.Get3D().model("sky")
  lSkyRef.transform.position = me.GetPlayerVehicle().getPosition()
  lOffset = lSkyRef.transform.position - me.GetPlayerVehicle().getPosition()
  me.GetSkyManager().Initialize(lSkyRef, lOffset)
  me.InitializeSequences()
  me.InitializeIngame()
  me.InitializeCamera()
  if me.GetConfiguration() = #debug then
    me.GetInputManager().AddKeyEvent(#TopCameraMode, me.GetCamera(), "t", #OnPressed)
    me.GetInputManager().AddKeyEvent(#TopHeightUp, me.GetCamera(), "a", #OnDown)
    me.GetInputManager().AddKeyEvent(#TopHeightDown, me.GetCamera(), "z", #OnDown)
    me.GetInputManager().AddKeyEvent(#LateralCameraMode, me.GetCamera(), "l", #OnPressed)
  end if
  me.GetInputManager().AddKeyEvent(#PausePressed, me, "p", #OnPressed)
  me.InitializeTextureShifting()
  me.InitializeTextureRotation()
  me.InitializeElectricShader()
  me.GetGameplay().ChangeState(#preRender, me.GetTimeManager().GetTime())
  me.GetCamera().ChangeState(#preRender, me.GetTimeManager().GetTime())
  if me.GetConfiguration() = #debug then
    pVehicleStartPosition = me.GetPlayerVehicle().getPosition()
  end if
  me.SetMaterialEnv()
  me.SetNoMipmap()
  me.GetHavokPhysics().GetHavok().registerInterest(me.GetPlayerVehicle().GetVehicle().GetChassisMdl().name, #all, 0.0, 0.0, #OnPlayerVehicleCollision, me)
  pGameSounds = script("AgeOfSpeed2 Sounds").new()
  pGameSounds.Initialize()
  lEngineSoundManager = script("AgeOfSpeed2 Engine Sound Fixed Samples").new(me.GetPlayerVehicle().GetVehicle(), 2, me.GetTimeManager())
  lEngineSoundManager.SetSpeedRanges([0.0, 30.0, 190.0, 250.0, 350.0, 1000.0])
  lEngineSoundManager.SetVolume(50, 120)
  lEngineSoundManager.SetEnabled(0)
  me.SetEngineSoundManager(lEngineSoundManager)
  me.InitializeMissileManager()
  lCullingManager.SetRayRules(me.GetRayRules())
  lExcludeFromCullingList = me.GetExcludeFromCullingList()
  lCullingManager.Initialize(lExcludeFromCullingList)
  pExplosionManager = script("AgeOfSpeed2 Explosion Manager").new("fx_exp_dyn", 4)
  me.GetAnimationManager().Initialize(me.Get3D())
  SetTextureRenderFormat(me.Get3D(), #rgba8888)
  if me.GetConfiguration() <> #release_web then
    pFrameCounter = script("Overlay FPS Counter").new(me.GetInGame(), 1000, member("tfFrameRate"), point(320, 15), color(255, 255, 0))
  end if
end

on GetRayRules me
  lRayRules = [[#condition: #starts, #value: "l_t"]]
  return lRayRules
end

on GetExcludeFromCullingList me
  lExcludeFromCullingList = [[#condition: #starts, #value: "Overlay"], [#condition: #contains, #value: "sky"], [#condition: #contains, #value: "_dyn"], [#condition: #starts, #value: "veh_"]]
  return lExcludeFromCullingList
end

on SetMaterialEnv me
  SetEnvmapEffectShader(me.Get3D().shader("as2_money_mat"))
  SetEnvmapEffectShader(me.Get3D().shader("as2_bon_shield_mat"))
  SetEnvmapEffectShader(me.Get3D().shader("as2_bon_missile_mat"))
  SetEnvmapEffectShader(me.Get3D().shader("as2_bon_bolt_mat"))
end

on SetNoMipmap me
  SetNoMipmapToShader(me.Get3D().shader("as2_sky_lev1_mat"))
end

on InitializePlayers me, kCullingData
  lStartPositionList = []
  pPlayers = []
  lOBBData = [#OBBWidth: 200.0, #OBBHeight: 300.0]
  lDriveData = [#AccelerationEpsilon: 0.10000000000000001, #AccelerationFactor: 0.001, #SteeringEpsilon: 0.10000000000000001, #SteeringFactor: 0.05]
  pAiBalancer = script("AgeOfSpeed2 AI BAlancer").new()
  repeat with li = 1 to pHowManyPlayers
    lCpuControl = 1
    lPlayerPrefix = #cpu
    lAiType = #AiSimple
    if li = 1 then
      lCpuControl = 0
      lPlayerPrefix = #human
    end if
    lHumanPlayerId = me.GetPlayerId() - 1
    lTextureId = lHumanPlayerId + li
    if lTextureId > 4 then
      lTextureId = lTextureId - 4
    end if
    lConfSets = me.GetConfSets()[lPlayerPrefix]
    lHavokRef = me.GetHavokPhysics().GetHavok()
    lChassisName = "veh_chassis_" & li
    lModelRB = lHavokRef.rigidBody(lChassisName)
    if not voidp(lModelRB) then
      lHavokRef.deleteRigidBody(lChassisName)
    end if
    lChassisMdl = me.Get3D().model(lChassisName)
    lChassisMdl.addModifier(#meshDeform)
    lChassisMdl.transform.scale = vector(0.80000000000000004, 0.59999999999999998, 1.0)
    lRBCreationResults = lHavokRef.makeMovableRigidBody(lChassisName, 100.0, 0)
    lChassisMdl.removeModifier(#meshDeform)
    lRacePlayer = script("AgeOfSpeed2 Player").new("playerName" & li, li, lTextureId, lCpuControl, lAiType, lOBBData, lDriveData, lConfSets)
    pPlayers.append(lRacePlayer)
    if lCpuControl then
      case me.GetDifficult() of
        1:
          lAIMaxSkill = 1.02000000000000002 + (li * 0.025)
          lAIMinSkill = 0.78000000000000003 + (li * 0.025)
        2:
          lAIMaxSkill = 1.03000000000000003 + (li * 0.025)
          lAIMinSkill = 0.81999999999999995 + (li * 0.025)
        3:
          lAIMaxSkill = 1.04000000000000004 + (li * 0.025)
          lAIMinSkill = 0.85999999999999999 + (li * 0.025)
        4:
          lAIMaxSkill = 1.05000000000000004 + (li * 0.025)
          lAIMinSkill = 0.89000000000000001 + (li * 0.025)
      end case
      lDynamism = RandomInRange(-0.016, 0.005, 20.0)
      lAIMaxSkill = lAIMaxSkill + lDynamism
      lAIMinSkill = lAIMinSkill + lDynamism
      lAIRefFactor = 33.29999999999999716 + (lDynamism * 100.0)
      lAIRefDistanceMax = 600.0 - (lDynamism * 4000.0)
      lAIRefDistanceMin = -200.0 + (lDynamism * 2000.0)
      lAISkillDelta = 0.07000000000000001 - (lDynamism * 0.5)
      lAISkillRelax = 0.04 - (lDynamism * 0.5)
      lAISampleTime = 300.0 + (lDynamism * 3000.0)
      lBalanceData = [#AISamplingTime: -1, #AISample: 0.0, #AISampleTime: 300.0, #AIRefFactor: lAIRefFactor, #AIRefDistanceMax: lAIRefDistanceMax, #AIRefDistanceMin: lAIRefDistanceMin, #AIMaxSkill: lAIMaxSkill, #AIMinSkill: lAIMinSkill, #AISkillDelta: lAISkillDelta, #AISkillRelax: lAISkillRelax, #AISkillNearDelta: 0.015, #AINearDistanceMax: 900.0, #AINearDistanceMin: -600.0, #AIToAdvantageDistance: 1000.0, #AIToDrawbackDistance: -1000.0]
      pAiBalancer.RegisterPlayer(lRacePlayer, lBalanceData)
    end if
    lStartPos = me.Get3D().model("veh_chassis_" & li).transform.position
    lStartPositionList.add([lStartPos, [vector(0.0, 0.0, 1.0), me.Get3D().model("veh_chassis_" & li).transform.rotation.z]])
  end repeat
  me.GetGameplay().SetStartPositionList(lStartPositionList)
  lHavokPhys = me.GetHavokPhysics()
  if not lHavokPhys.GetSubstepCallbackActive() then
    lHavokPhys.SetSubstepCallbackActive(1)
  end if
  lHavokPhys.AddSubstepCallback(#BlockOnStartPos, me.GetGameplay())
  lHavokRef = me.GetHavokPhysics().GetHavok()
  repeat with li = pHowManyPlayers + 1 to 4
    lChassisRbName = "veh_chassis_" & li
    lModelRB = lHavokRef.rigidBody(lChassisRbName)
    if not voidp(lModelRB) then
      lHavokRef.deleteRigidBody(lChassisRbName)
    end if
    me.Get3D().deleteModel(lChassisRbName)
  end repeat
  lHavokPhys = me.GetHavokPhysics()
  if not lHavokPhys.GetSubstepCallbackActive() then
    lHavokPhys.SetSubstepCallbackActive(1)
  end if
  lHavokPhys.AddSubstepCallback(#UpdateGravity, me)
  me.Get3D().deleteModel("fx_bolts_dyn")
end

on OnPlayerVehicleCollision me, kCollisionDetails
  lContactNormal = kCollisionDetails[4]
  lImpactDir = lContactNormal.dot(me.GetPlayerVehicle().GetVehicle().GetWorldRight())
  if lImpactDir > 0.80000000000000004 then
    me.GetPlayerVehicle().GetVehicleEffects().SetCollisionSide(#right)
  else
    if lImpactDir < -0.80000000000000004 then
      me.GetPlayerVehicle().GetVehicleEffects().SetCollisionSide(#left)
    end if
  end if
  lName = kCollisionDetails[2]
  lCurrentTime = me.GetTimeManager().GetTime()
  if lCurrentTime < (pLastPlayerVehicleCollisionTime + 500.0) then
    return 
  end if
  lCollisionResult = me.GetPlayerVehicle().GetVehicle().OnCollision(kCollisionDetails)
  if lCollisionResult then
    pLastPlayerVehicleCollisionTime = lCurrentTime
  end if
end

on VehicleCollision me, kRelativeVelocityOfImpact, kCollisionNormal
  if me.GetGameStatus() = #play then
    me.GetGameSoundManager().PlayHitSound()
  end if
end

on OnEnd me
  me.ancestor.OnEnd()
end

on GamePaused me
  me.ancestor.GamePaused()
  lEngineSoundManager = me.GetEngineSoundManager()
  if not voidp(me.GetEngineSoundManager()) then
    lEngineSoundManager.pause()
  end if
  me.GetInGame().GamePaused()
  lPlayers = me.GetPlayers()
  repeat with li = 1 to lPlayers.count
    lPlayers[li].GamePaused()
  end repeat
end

on GameResumed me
  me.ancestor.GameResumed()
  lEngineSoundManager = me.GetEngineSoundManager()
  if not voidp(me.GetEngineSoundManager()) then
    lEngineSoundManager.UnPause()
  end if
  me.GetInGame().GameResumed()
  lPlayers = me.GetPlayers()
  repeat with li = 1 to lPlayers.count
    lPlayers[li].GameResumed()
  end repeat
end

on QuitRequested me
  me.ancestor.QuitRequested()
  if not me.GetInGame().GetPausePopupShown() then
    me.ancestor.GamePaused()
  end if
  me.GetInGame().QuitRequested()
  me.GetPlayerVehicle().GamePaused()
end

on ResumedFromQuit me
  me.GetInGame().ResumedFromQuit()
  me.ancestor.ResumedFromQuit()
  if not me.GetInGame().GetPausePopupShown() then
    me.ancestor.GameResumed()
  end if
  me.GetPlayerVehicle().GameResumed()
end

on InitializeExplosiveObjects me
  lVector = vector(0, 0, 0)
  lEmitterRegion = [lVector]
  lEmitterCassa = me.GetParticlesManager().GetEmitter(#Cassa)
  lExplosionParticleTextureCassa = me.GetParticlesManager().GetTexture("spc_fx_cassa_dyn")
  lEmitterPropCassa = [#properties: lEmitterCassa, #texture: lExplosionParticleTextureCassa, #emitterregion: lEmitterRegion, #direction: vector(0, 1, -1), #lifeTime: 3000, #deletetime: 3000, #attachedToCam: 1]
  lExplosionPropCassa = [#model: VOID, #NoClone: 1, #particles: [lEmitterPropCassa], #sounds: VOID]
  lExplosiveObjectsProperty = [#Cassa: lExplosionPropCassa]
  me.GetExplosiveObjectManager().SetExplosiveObjectProperties(lExplosiveObjectsProperty)
end

on EnableDynamycFov me
  pDynamycFovEnabled = 1
end

on DisableDynamycFov me
  pDynamycFovEnabled = 0
end

on UpdateFov me
  if not pDynamycFovEnabled then
    return 
  end if
  lDt = me.GetTimeManager().GetDeltaTime() * 0.001
  lFovTo = 45.0
  lActualFov = me.GetCamera().GetFOV()
  lVehicle = me.GetPlayerVehicle().GetVehicle()
  lSpeed = lVehicle.GetSpeed()
  lSpeedFactor = (lSpeed - 1500.0) * 0.0001
  if lSpeedFactor > 0 then
    lFovTo = 45.0 + (lSpeedFactor * 35.0)
    lFovTo = Clamp(lFovTo, 45.0, 85.0)
  end if
  if lActualFov < lFovTo then
    lSmoothCoeff = lDt * 9.0
  else
    lSmoothCoeff = lDt * 6.0
  end if
  lFov = lActualFov + ((lFovTo - lActualFov) * lSmoothCoeff)
  me.GetCamera().SetFOV(lFov)
end

on HandleCheats me
  if me.GetInputManager().IsKeyPressed("s") then
    if me.GetGameStatus() = #Init then
      if me.GetCamera().GetState() = #FadeEnter then
        me.GetCamera().ChangeState(#ThirdPersonSpot, me.GetTimeManager().GetTime())
      end if
      lActiveSeq = me.GetSequenceManager().GetActiveSequence()
      if (lActiveSeq starts "LevelStart") or (lActiveSeq starts "LevelStartWithHelp") then
        me.GetSequenceManager().ResetElements()
        me.GetGameplay().Ready()
        me.GetGameplay().go()
        me.GetGameplay().AiActivation()
        me.GetGameplay().StartVehicles()
        me.GetGameplay().StartGameplay()
        me.GetGameplay().StartInputControl()
      end if
    end if
  end if
  if me.GetInputManager().IsKeyPressed("g") then
    me.GetPlayerVehicle().GetVehicle().setPosition(pVehicleStartPosition)
  end if
  if me.GetInputManager().IsKeyPressed("v") then
    put "SPEED: " & me.GetPlayerVehicle().GetSpeedKmh() & " -- " & me.GetPlayerVehicle().GetVelocity().magnitude
  end if
  if me.GetInputManager().IsKeyPressed("a") then
    me.GetPlayerVehicle().SwapCpuControl()
    if me.GetPlayerVehicle().IsCPUControlled() then
      me.GetPlayerVehicle().GetInputController().SetActive(1)
    end if
  end if
  if me.GetInputManager().IsKeyPressed("z") then
    lHCDetails = me.GetPlayerVehicle().GetVehicle().GetHoverCollisionDetails()
    repeat with li = 1 to lHCDetails.count
      put "lHCDetails: " & lHCDetails
    end repeat
  end if
  if me.GetInputManager().IsKeyPressed("1") then
    lVehContrRef = me.GetPlayerVehicle().GetVehicle()
    lTrackToken = me.GetTokenManager().GetTrackTokens()
    put "T: " & lVehContrRef.GetCurrentToken() & " L: " & lVehContrRef.GetLongitudinal() & " T: " & lVehContrRef.GetTrasversal() & " name: " & lTrackToken[lVehContrRef.GetCurrentToken()].ModelName
  end if
  if me.GetInputManager().IsKeyPressed("2") then
    me.GetGameplay().SetStartRaceTime(me.GetGameplay().GetStartRaceTime() - 10000)
  end if
  if me.GetInputManager().IsKeyPressed("3") then
    me.GetGameplay().SetStartRaceTime(me.GetGameplay().GetStartRaceTime() + 10000)
  end if
  if me.GetInputManager().IsKeyPressed("4") then
    me.GetInGame().ShowRecordPopup(5000, "5000", "6000", 0)
  end if
  if me.GetInputManager().IsKeyPressed("5") then
    lVehContrRef = me.GetPlayerVehicle().GetVehicle()
    put "DistanceFromStart: " & me.GetTokenManager().GetDistanceFromStart(lVehContrRef.pCurrentToken)
  end if
  if me.GetInputManager().IsKeyPressed("o") then
    lVehContrRef = me.GetPlayerVehicle().GetVehicle()
    if lVehContrRef.pChassisMDL.visibility = #none then
      lVehContrRef.pChassisMDL.visibility = #front
    else
      lVehContrRef.pChassisMDL.visibility = #none
    end if
  end if
  if me.GetInputManager().IsKeyPressed("k") then
    repeat with li = 1 to 4
      lPlayerRef = me.GetPlayers()[li]
      lPlayerRef.GetVehicle().pRaceTime = 60000 - ((3 - li) * 5000.0)
    end repeat
    me.GetSequenceManager().StartSequence("LevelEndNormal")
  end if
  if me.GetInputManager().IsKeyPressed("e") then
    lHCDetails = me.GetPlayerVehicle().GetVehicle().GetHoverCollisionDetails()
    repeat with li = 1 to lHCDetails.count
      put "lHCDetails: " & lHCDetails
    end repeat
  end if
  if me.GetInputManager().IsKeyPressed("c") then
    me.GetPlayerVehicle().GetVehicle().SetTurboBoost(1400, 1.25)
  end if
  if me.GetInputManager().IsKeyPressed("7") then
    me.GetPlayerVehicle().SetCurrentWeapon(#electric)
  end if
  if me.GetInputManager().IsKeyPressed("8") then
    me.GetPlayerVehicle().SetCurrentWeapon(#missile)
  end if
  if me.GetInputManager().IsKeyPressed("9") then
    me.GetPlayerVehicle().SetCurrentWeapon(#god)
  end if
end

on UpdateGravity me
  lDt = me.GetTimeManager().GetDeltaTime() * 0.001
  repeat with lPlayer in me.GetPlayers()
    lVehicle = lPlayer.GetVehicle()
    lGravity = lVehicle.getGravity()
    lVehicle.GetChassisRB().applyImpulse(lGravity)
  end repeat
end

on InitializeTextureRotation me
  pRotationShader = me.Get3D().shader("as2_sky_swirl2_mat")
end

on UpdateTextureRotation me
  if not voidp(pRotationShader) then
    lDelta = me.GetTimeManager().GetDeltaTime() * 0.025
    pRotationShader.textureTransform.translate(-0.5, -0.5, 0.0)
    pRotationShader.textureTransform.rotate(0.0, 0.0, lDelta)
    pRotationShader.textureTransform.translate(0.5, 0.5, 0.0)
  end if
end

on InitializeElectricShader me
  if me.GetAllId() = 3 then
    pElectricShader = me.Get3D().shader("as2_sky_lighting3_mat")
    pElectricShaderTimer = -1
    pElectricOn = 0
  else
    pElectricShader = VOID
  end if
end

on UpdateElectricShader me
  if not voidp(pElectricShader) then
    lTime = me.GetTimeManager().GetTime()
    if (lTime - pElectricShaderTimer) > 600 then
      lRandom = random(1000)
      if lRandom < 220 then
        lBlend = 100.0
        pElectricOn = 1
        me.GetGameSoundManager().PlayElectricSound()
      else
        lBlend = 0.0
        pElectricOn = 0
      end if
      pElectricShaderTimer = lTime
      pElectricShader.blend = lBlend
    else
      if pElectricOn then
        pElectricShader.blend = 50 + random(50)
      end if
    end if
  end if
end

on InitializeElektroShader me
  pElektroShader = me.Get3D().shader("as2_fx_bolts_mat")
end

on UpdateElektroShader me
  pElektroShader.blend = 50 + random(50)
end

on InitializeMissileManager me
  pMissileManager = script("AgeOfSpeed2 Missile Manager").new()
  pMissileManager.SetMissileBaseMdlName("missile_dyn")
end

on onUpdate me
  lCurrentTime = me.GetTimeManager().GetTime()
  if not me.IsPaused() then
    me.GetSkyManager().update(me.GetPlayerVehicle())
    pAiBalancer.update(lCurrentTime)
    repeat with li = 1 to pPlayers.count
      lPlayerRef = pPlayers[li]
      lPlayerRef.update(lCurrentTime)
      me.GetCheckpointManager().update(lPlayerRef.getPosition(), li)
      if li = 1 then
        pBonusCheckPointManager.update(lPlayerRef.getPosition(), li)
      end if
    end repeat
    me.GetBonusManager().UpdateBonus()
    me.UpdateFov()
    me.UpdateTextureRotation()
    me.UpdateElectricShader()
    if me.GetConfiguration() = #debug then
      me.HandleCheats()
    end if
    pMissileManager.update(lCurrentTime)
    pExplosionManager.update(lCurrentTime)
  end if
  lEngineSoundManager = me.GetEngineSoundManager()
  if not voidp(lEngineSoundManager) then
    lEngineSoundManager.update(me.GetSoundManager().GetAudioState(), 1)
  end if
  me.GetGameSoundManager().update(lCurrentTime)
  lEvent = me.GetNextKeyEvent()
  repeat while not voidp(lEvent)
    case lEvent of
      #PausePressed:
        if not me.GetInGame().GetQuitPopupShown() and not me.GetInGame().GetHelpActive() then
          if not me.IsPaused() then
            me.GetInGame().OnPauseClick()
          else
            me.GetInGame().OnPlayClick()
          end if
        end if
    end case
    lEvent = me.GetNextKeyEvent()
  end repeat
  if not me.IsPaused() then
    repeat with lPlayerRef in pPlayers
      lPlayerRef.ExitFrameUpdate(lCurrentTime)
    end repeat
  end if
  me.FlushKeyEvents()
end
