property pSprite, pStartW, pStartH, pW, pH, pOrigW, pOrigH, pWto, pHto, pInter, pActiveInt, pInterData, pInterTime, pOverlaysData, pOverlaysButtonData
global gGame

on new me, kW, kH, kSpriteName
  pW = kW
  pH = kH
  pStartW = float(pW)
  pStartH = float(pH)
  pOrigW = pStartW
  pOrigH = pStartH
  pInter = -1
  pActiveInt = #none
  pInterData = [:]
  pOverlaysData = [:]
  pOverlaysButtonData = [:]
  pSprite = sprite(kSpriteName)
  return me
end

on GetScreenFactor me
  return [pW / float(pOrigW), pH / float(pOrigH)]
end

on GetRealScreenFactor me
  return [pW / float(pStartW), pH / float(pStartH)]
end

on update me, kTime
  if pInter <> -1 then
    lProgress = (kTime - pInter) / pInterTime
    if lProgress >= 1 then
      pInter = -1
      lProgress = 1
      pActiveInt = #none
    end if
    pW = pW + ((pWto - pW) * lProgress)
    pH = pH + ((pHto - pH) * lProgress)
    lXScaleFactor = pW / float(pOrigW)
    lYScaleFactor = pH / float(pOrigH)
    pSprite.width = pW
    pSprite.height = pH
    lOverlayToAdd = [:]
    lOverlayList = gGame.GetOverlayManager().GetOverlayList()
    lCamNode = gGame.GetCamera().GetCameraNode()
    repeat with li = 1 to lOverlayList.count
      if pOverlaysData.findPos(lOverlayList[li]) = VOID then
        lPoint = lCamNode.overlay[gGame.GetOverlayManager().GetIndex(lOverlayList[li])].loc
        lH = integer(lPoint.locH * lXScaleFactor)
        lV = integer(lPoint.locV * lYScaleFactor)
        lCalcPoint = point(lH, lV)
        lOverlayToAdd.addProp(lOverlayList[li], lCalcPoint)
        next repeat
      end if
      lLabel = pOverlaysData.getPropAt(li)
      lCalcPoint = point(integer(pOverlaysData[li].locH * lXScaleFactor), integer(pOverlaysData[li].locV * lYScaleFactor))
      gGame.GetOverlayManager().Modify(lLabel, VOID, lCalcPoint)
    end repeat
    repeat with li = 1 to lOverlayToAdd.count
      lLabel = lOverlayToAdd.getPropAt(li)
      pOverlaysData.addProp(lLabel, lOverlayToAdd[lLabel])
    end repeat
    lOverlayButtonToAdd = [:]
    lOverlayButtonList = gGame.GetInGame().GetOverlayButtons()
    repeat with li = 1 to lOverlayButtonList.count
      lOverlayButton = lOverlayButtonList[li]
      lOverlayButtonName = lOverlayButton.GetOverlayName()
      if pOverlaysButtonData.findPos(lOverlayButtonName) = VOID then
        lPoint = lOverlayButton.getPosition()
        lH = integer(lPoint.locH * lXScaleFactor)
        lV = integer(lPoint.locV * lYScaleFactor)
        lCalcPoint = point(lH, lV)
        lOverlayButtonToAdd.addProp(lOverlayButtonName, lCalcPoint)
        next repeat
      end if
      lCalcPoint = point(integer(pOverlaysButtonData[li].locH * lXScaleFactor), integer(pOverlaysButtonData[li].locV * lYScaleFactor))
      lOverlayButton.setPosition(lCalcPoint)
    end repeat
    repeat with li = 1 to lOverlayButtonToAdd.count
      lLabel = lOverlayButtonToAdd.getPropAt(li)
      pOverlaysButtonData.addProp(lLabel, lOverlayButtonToAdd[lLabel])
    end repeat
  end if
end

on RegisterScreenInterpolation me, kInterName, kData
  pInterData.addProp(kInterName, kData)
end

on LoadScreenInterpolation me, kInterName, kTime
  if pInterData.findPos(kInterName) = VOID then
    put kInterName & " interpolation not found"
    return 
  end if
  if pInter <> -1 then
    put "already interpolating"
    return 
  end if
  lData = pInterData[kInterName]
  if (lData.w = pW) and (lData.h = pH) then
    return 
  end if
  pWto = lData.w
  pHto = lData.h
  pActiveInt = kInterName
  pInterTime = lData.t
  pInter = kTime
  pOrigW = pW
  pOrigH = pH
  lCamNode = gGame.GetCamera().GetCameraNode()
  pOverlaysData = [:]
  lOverlayList = gGame.GetOverlayManager().GetOverlayList()
  repeat with li = 1 to lOverlayList.count
    lIdx = gGame.GetOverlayManager().GetIndex(lOverlayList[li])
    pOverlaysData.addProp(lOverlayList[li], lCamNode.overlay[lIdx].loc)
  end repeat
  pOverlaysButtonData = [:]
  lOverlaysButtons = gGame.GetInGame().GetOverlayButtons()
  repeat with li = 1 to lOverlaysButtons.count
    lOverlaysButton = lOverlaysButtons[li]
    lActualPoint = lOverlaysButton.getPosition()
    lPoint = point(lActualPoint.locH, lActualPoint.locV)
    pOverlaysButtonData.addProp(lOverlaysButton.GetOverlayName(), lPoint)
  end repeat
end
