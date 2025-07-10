property pPlayersData
global gGame

on new me
  pPlayersData = []
  return me
end

on RegisterPlayer me, kPlayerRef, kBalanceData
  pPlayersData.add([#player: kPlayerRef, #AISamplingTime: kBalanceData.AISamplingTime, #AISample: kBalanceData.AISample, #AISampleTime: kBalanceData.AISampleTime, #AIRefFactor: kBalanceData.AIRefFactor, #AIRefDistanceMax: kBalanceData.AIRefDistanceMax, #AIRefDistanceMin: kBalanceData.AIRefDistanceMin, #AIMaxSkill: kBalanceData.AIMaxSkill, #AIMinSkill: kBalanceData.AIMinSkill, #AISkillDelta: kBalanceData.AISkillDelta, #AISkillRelax: kBalanceData.AISkillRelax, #AISkillNearDelta: kBalanceData.AISkillNearDelta, #AINearDistanceMax: kBalanceData.AINearDistanceMax, #AINearDistanceMin: kBalanceData.AINearDistanceMin, #AIToAdvantageDistance: kBalanceData.AIToAdvantageDistance, #AIToDrawbackDistance: kBalanceData.AIToDrawbackDistance])
end

on update me, kTime
  lPlayerRacePosition = gGame.GetPlayerVehicle().GetRaceTrackPos()
  repeat with li = 1 to pPlayersData.count
    lPlayerDataRef = pPlayersData[li]
    lPlayerRef = lPlayerDataRef.player
    lVehicleControllerRef = lPlayerRef.GetVehicle()
    lDistanceFromPlayer = lPlayerRacePosition - lPlayerRef.GetRaceTrackPos()
    if (lPlayerDataRef.AISamplingTime = -1) or ((lPlayerDataRef.AISamplingTime <> -1) and (kTime > lPlayerDataRef.AISamplingTime)) then
      lPlayerDataRef.AISamplingTime = kTime + lPlayerDataRef.AISampleTime
      lDeltaDistance = lDistanceFromPlayer - lPlayerDataRef.AISample
      lRefDistance = lDistanceFromPlayer / lPlayerDataRef.AIRefFactor
      if (lRefDistance > lPlayerDataRef.AIRefDistanceMin) and (lRefDistance < lPlayerDataRef.AIRefDistanceMax) then
        if lRefDistance > 0 then
          lRefDistance = lPlayerDataRef.AIRefDistanceMax
        else
          lRefDistance = lPlayerDataRef.AIRefDistanceMin
        end if
      end if
      if lDistanceFromPlayer > lPlayerDataRef.AIToAdvantageDistance then
        if lDeltaDistance < lRefDistance then
          lVehicleControllerRef.SetSkill(lVehicleControllerRef.GetSkill() + lPlayerDataRef.AISkillDelta)
        else
          if lDeltaDistance > (lRefDistance * 4.0) then
            lVehicleControllerRef.SetSkill(lVehicleControllerRef.GetSkill() - lPlayerDataRef.AISkillRelax)
          end if
        end if
      else
        if lDistanceFromPlayer < lPlayerDataRef.AIToDrawbackDistance then
          if lDeltaDistance > lRefDistance then
            lVehicleControllerRef.SetSkill(lVehicleControllerRef.GetSkill() - lPlayerDataRef.AISkillDelta)
          else
            if lDeltaDistance < (lRefDistance * 4.0) then
              lVehicleControllerRef.SetSkill(lVehicleControllerRef.GetSkill() + lPlayerDataRef.AISkillRelax)
            end if
          end if
        else
          if lDistanceFromPlayer > lPlayerDataRef.AINearDistanceMax then
            lVehicleControllerRef.SetSkill(lVehicleControllerRef.GetSkill() + lPlayerDataRef.AISkillNearDelta)
          else
            if lDistanceFromPlayer < lPlayerDataRef.AINearDistanceMin then
              lVehicleControllerRef.SetSkill(lVehicleControllerRef.GetSkill() - lPlayerDataRef.AISkillNearDelta)
            end if
          end if
        end if
      end if
      lVehicleControllerRef.SetSkill(Clamp(lVehicleControllerRef.GetSkill(), lPlayerDataRef.AIMinSkill, lPlayerDataRef.AIMaxSkill))
      lPlayerDataRef.AISample = lDistanceFromPlayer
    end if
  end repeat
end
