property pOverlayID, pInitTime, pOnTime, pOffTime, pVisible
global gOverlayManager

on new me, fOverlayID, fInitTime, fOnTime, fOffTime
  pOverlayID = fOverlayID
  pInitTime = fInitTime
  pOnTime = fOnTime
  pOffTime = fOffTime
  pVisible = 0
  return me
end

on StartBlink me, kTime, kOverlayManager
  lCurrentTime = kTime
  if pVisible = 1 then
    if (lCurrentTime - pInitTime) > pOnTime then
      kOverlayManager.Modify(pOverlayID, VOID, VOID, 0, VOID)
      pVisible = 0
      pInitTime = lCurrentTime
    end if
  else
    if (lCurrentTime - pInitTime) > pOffTime then
      kOverlayManager.Modify(pOverlayID, VOID, VOID, 1, VOID)
      pVisible = 1
      pInitTime = lCurrentTime
    end if
  end if
end

on EndBlink me, kOverlayManager
  kOverlayManager.Modify(pOverlayID, VOID, VOID, 1, VOID)
  pVisible = 1
end
