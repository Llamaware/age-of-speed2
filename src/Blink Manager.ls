property pOverlayManager, pBlinkingObjectList, pMaxTimeBlinking, pInitTimes

on new me, kOverlayManager
  pOverlayManager = kOverlayManager
  pBlinkingObjectList = []
  pMaxTimeBlinking = []
  pInitTimes = []
  return me
end

on AddElement me, fOverlayID, fInitTime, fOnTime, fOffTime, fMaxTimeBlinking
  lBlinkingElement = new(script("Blinker Object"), fOverlayID, fInitTime, fOnTime, fOffTime)
  pBlinkingObjectList.add(lBlinkingElement)
  pMaxTimeBlinking.add(fMaxTimeBlinking)
  pInitTimes.add(fInitTime)
end

on RemoveElement me, fOverlayID
  repeat with li = 1 to pBlinkingObjectList.count
    if pBlinkingObjectList[li].pOverlayID = fOverlayID then
      pBlinkingObjectList[li].EndBlink(pOverlayManager)
      pBlinkingObjectList.deleteAt(li)
      pMaxTimeBlinking.deleteAt(li)
      pInitTimes.deleteAt(li)
      exit repeat
    end if
  end repeat
end

on GetElement me, fOverlayID
  repeat with li = 1 to pBlinkingObjectList.count
    if pBlinkingObjectList[li].pOverlayID = fOverlayID then
      return pBlinkingObjectList[li]
    end if
  end repeat
  return VOID
end

on update me, kTime
  repeat with li = 1 to pBlinkingObjectList.count
    pBlinkingObjectList[li].StartBlink(kTime, pOverlayManager)
    if pMaxTimeBlinking[li] <> -1 then
      if (kTime - pInitTimes[li]) > pMaxTimeBlinking[li] then
        me.RemoveElement(me.pBlinkingObjectList[li].pOverlayID)
      end if
    end if
  end repeat
end
