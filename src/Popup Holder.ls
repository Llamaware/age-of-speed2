property pMember, pOverlayManager, pTimeSource, pPopupStack, pRefPosition, pInfraTime, pInfraDuration

on new me, kMember, kOverlayManager, kTimeSource
  pMember = kMember
  pOverlayManager = kOverlayManager
  pTimeSource = kTimeSource
  pPopupStack = []
  pRefPosition = point(0, 0)
  pInfraTime = -1
  pInfraDuration = 250
  return me
end

on GetRefPosition me
  return pRefPosition
end

on GetFrontPopup me
  if not IsPopupListEmpty() then
    return pPopupStack[PopupListCount()]
  end if
  return VOID
end

on SetRefPosition me, kPosition
  pRefPosition = kPosition
end

on SetInfraDuration me, kDuration
  pInfraDuration = kDuration
end

on AddToFront me, kPopup, kDuration, kSound, kChannel, kPosition
  lPopupExpiration = -1
  if kDuration <> -1 then
    lPopupExpiration = kDuration + pTimeSource.GetRealTime()
  end if
  kPopup.pExpirationTime = lPopupExpiration
  pPopupStack.add(kPopup)
  if GetFrontPopup().pExpirationTime = -1 then
    HidePopups()
    ShowFrontPopup()
  else
    UpdateInfraTime()
  end if
end

on AddToBack me, kPopup, kDuration, kPopupProperties, kSound, kChannel, kPosition
  lPopupExpiration = -1
  if kDuration <> -1 then
    lPopupExpiration = kDuration + pTimeSource.GetRealTime()
  end if
  kPopup.pExpirationTime = lPopupExpiration
  pPopupStack.addAt(1, kPopup)
  UpdateInfraTime()
end

on RemoveFromFront me
  if not IsPopupListEmpty() then
    lFrontPopup = GetFrontPopup()
    lFrontPopup.hide(pOverlayManager)
    pPopupStack.deleteAt(PopupListCount())
  end if
  if not IsPopupListEmpty() then
    lFrontPopup = GetFrontPopup()
    if lFrontPopup.GetExpirationTime() = -1 then
      ShowFrontPopup()
    else
      UpdateInfraTime()
    end if
  end if
end

on IsPopupListEmpty me
  return pPopupStack.count <= 0
end

on PopupListCount me
  return pPopupStack.count
end

on HidePopups me
  repeat with li = 1 to PopupListCount()
    pPopupStack[li].hide(pOverlayManager)
  end repeat
end

on RemovePopups me
  HidePopups()
  pInfraTime = -1
  repeat with li = PopupListCount() down to 1
    pPopupStack.deleteAt(li)
  end repeat
end

on UpdateInfraTime me
  pInfraTime = pTimeSource.GetRealTime() + pInfraDuration
end

on PausePopups me
  repeat with li = 1 to PopupListCount()
    pPopupStack[li].pause(pTimeSource.GetRealTime())
  end repeat
end

on UnPausePopups me
  repeat with li = 1 to PopupListCount()
    pPopupStack[li].UnPause(pTimeSource.GetRealTime())
  end repeat
end

on UpdateExpirations me, kCurrentTime
  repeat with li = 1 to PopupListCount() - 1
    pPopupStack[li].UpdateExpiration(kCurrentTime)
  end repeat
end

on ShowFrontPopup me
  if IsPopupListEmpty() then
    return 
  end if
  lFrontPopup = GetFrontPopup()
  lFrontPopup.UpdateExpiration(pTimeSource.GetRealTime())
  HidePopups()
  UpdateExpirations(pTimeSource.GetRealTime())
  lFrontPopup.show(pMember, pOverlayManager, pRefPosition)
end

on update me
  if (pInfraTime <> -1) and (pTimeSource.GetRealTime() > pInfraTime) then
    pInfraTime = -1
    ShowFrontPopup()
  end if
  if pInfraTime = -1 then
    lFrontPopup = GetFrontPopup()
    if lFrontPopup <> VOID then
      if (lFrontPopup.GetExpirationTime() <> -1) and (pTimeSource.GetRealTime() > (lFrontPopup.GetExpirationTime() + pInfraDuration)) then
        RemoveFromFront()
      end if
    end if
  end if
end
