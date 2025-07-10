property pInGame, pLastUpdateTime, pUpdateOnce, pTicks, pLastFPSString, pPreviousSample, pTextMember, pColor, pEnabled
global gGame

on new me, kInGame, kUpdateOnce, kTextMember, kPosition, kColor
  pInGame = kInGame
  pUpdateOnce = kUpdateOnce
  pTextMember = kTextMember
  pColor = kColor
  pEnabled = 1
  pTicks = 0
  pPreviousSample = -1
  pPreviousUpdate = -1
  pLastFPSString = EMPTY
  pInGame.CreateTextItem("tf_fps", pTextMember, "tf_fps", kPosition, 64, 16, "--", 12, pColor)
  return me
end

on GetEnabled me
  return pEnabled
end

on SetEnabled me, kEnabled
  pEnabled = kEnabled
end

on update me, kTime
  if not pEnabled then
    return 
  end if
  if 0 then
    if pPreviousSample <> -1 then
      lDt = float(kTime - pPreviousSample) * 0.001
      if lDt > 0.0 then
        lFPSString = string(integer(1.0 / lDt))
      else
        lFPSString = "--"
      end if
      if (kTime >= (pLastUpdateTime + pUpdateOnce)) and (lFPSString <> pLastFPSString) then
        pInGame.UpdateTextItem(pTextMember, "tf_fps", 64, 16, lFPSString, 12, pColor)
        pLastFPSString = lFPSString
        pLastUpdateTime = kTime
      end if
    end if
    pPreviousSample = kTime
  else
    if pPreviousSample <> -1 then
      pTicks = pTicks + 1
      if kTime >= (pPreviousSample + pUpdateOnce) then
        lDt = float(kTime - pPreviousSample) * 0.001
        if lDt > 0.0 then
          lFPSString = string(integer(float(pTicks) / lDt))
        else
          lFPSString = "--"
        end if
        if lFPSString <> pLastFPSString then
          pInGame.UpdateTextItem(pTextMember, "tf_fps", 64, 16, lFPSString, 12, pColor)
          pLastFPSString = lFPSString
          pLastUpdateTime = kTime
        end if
        pPreviousSample = kTime
        pTicks = 0
      end if
    else
      pPreviousSample = kTime
    end if
  end if
end
