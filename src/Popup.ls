property pShown, pRefPosition, pPrevMouseState, pHadButtons, pItems, pItemsProps, pExpirationTime, pPauseTime

on new me, kPopupData, kItemsProps
  pShown = 0
  pHadButtons = 0
  pItems = kPopupData.items
  pRefPosition = kPopupData.refPos
  pItemsProps = kItemsProps
  pExpirationTime = -1
  pPauseTime = 0
  repeat with li = 1 to pItems.count
    lItem = pItems[li]
    lItem.addProp(#overlay_name, VOID)
    if lItem.type = #button then
      pHadButtons = 1
    end if
  end repeat
  return me
end

on GetExpirationTime me
  return pExpirationTime
end

on UpdateExpiration me, kCurrentTime
  if pPauseTime <> 0 then
    if pExpirationTime <> -1 then
      pExpirationTime = pExpirationTime + (kCurrentTime - pPauseTime)
      pPauseTime = 0
    end if
  end if
end

on ShowItems me, kItemProps, k3D, kOverlayManager, kPosition
  repeat with li = 1 to pItems.count
    lItem = pItems[li]
    lUpdated = 0
    lVisible = 1
    lRotation = 0.0
    if lItem.findPos("rotation") <> VOID then
      if not voidp(lItem.rotation) then
        lRotation = float(lItem.rotation)
      end if
    end if
    if lItem.findPos("element_id") <> VOID then
      lItemPropPos = kItemProps.findPos(lItem.element_id)
      if lItemPropPos <> VOID then
        lItemProperties = kItemProps[lItemPropPos]
        if lItemProperties <> VOID then
          if lItemProperties.findPos("visible") <> VOID then
            if not voidp(lItemProperties.visible) then
              lVisible = lItemProperties.visible
            end if
          end if
          if (lItem.type = #text) and lVisible then
            lFontSize = 18
            if lItemProperties.findPos("size") <> VOID then
              if not voidp(lItemProperties.size) then
                lFontSize = lItemProperties.size
              end if
            end if
            lColor = color(255, 255, 255)
            if lItemProperties.findPos("color") <> VOID then
              if not voidp(lItemProperties.color) then
                lColor = lItemProperties.color
              end if
            end if
            lText = EMPTY
            if lItemProperties.findPos("text") <> VOID then
              if not voidp(lItemProperties.text) then
                lText = lItemProperties.text
              end if
            end if
            if ilk(lItem.member) = #string then
              lInGame = lItem.InGame
              lIsFlashTextVarName = lItem.isVarName
              lItem.texture = utiCreateTextureFromFlashText(k3D, lInGame.pFlashSprite, lInGame.pFlashTextRendererMovie, lItem.member, lItem.element_id, lItem.w, lItem.h, lText, lFontSize, lColor, lIsFlashTextVarName)
            else
              lItem.texture = utiCreateTextureFromText(k3D, lItem.member, lItem.element_id, lItem.w, lItem.h, lText, lFontSize, lColor)
            end if
            lUpdated = 1
          else
            lUpdated = 1
          end if
        end if
      else
        lUpdated = 1
      end if
    else
      lUpdated = 1
    end if
    if (lItem.texture <> VOID) and lUpdated and lVisible then
      lOverlayName = lItem.texture.name & string(the milliSeconds) & string(random(1000))
      lItem.overlay_name = lOverlayName
      kOverlayManager.add(lOverlayName, lItem.texture, pRefPosition + point(lItem.x, lItem.y) + kPosition)
      if lRotation <> 0.0 then
        kOverlayManager.Modify(lItem.overlay_name, VOID, VOID, VOID, VOID, lRotation)
      end if
    end if
  end repeat
end

on HideItems me, kOverlayManager
  repeat with li = pItems.count down to 1
    lItem = pItems[li]
    if lItem.overlay_name <> VOID then
      kOverlayManager.Remove(lItem.overlay_name)
      lItem.overlay_name = VOID
    end if
  end repeat
end

on show me, k3D, kOverlayManager, kPosition
  me.ShowItems(pItemsProps, k3D, kOverlayManager, kPosition)
  pShown = 1
  pPrevMouseState = 1
end

on hide me, kOverlayManager
  me.HideItems(kOverlayManager)
  pShown = 0
end

on UpdateButtons me, kOverlayManager
  if pHadButtons and pShown then
    repeat with li = 1 to pItems.count
      lItem = pItems[li]
      if lItem.type = #button then
        lMouseLocalX = _mouse.mouseH - pRefPosition.locH
        lMouseLocalY = _mouse.mouseV - pRefPosition.locV
        if not voidp(lItem.findPos("texture_dn")) then
          if (lMouseLocalX > lItem.x) and (lMouseLocalX < (lItem.x + lItem.w)) and (lMouseLocalY > lItem.y) and (lMouseLocalY < (lItem.y + lItem.h)) then
            kOverlayManager.Modify(lItem.overlay_name, lItem.texture_dn, VOID, VOID, VOID, VOID)
            next repeat
          end if
          kOverlayManager.Modify(lItem.overlay_name, lItem.texture, VOID, VOID, VOID, VOID)
        end if
      end if
    end repeat
  end if
end

on GetButtonPressed me
  lResult = #none
  if pHadButtons and pShown then
    lMouseState = _mouse.mouseDown
    if lMouseState and not pPrevMouseState then
      repeat with li = 1 to pItems.count
        lItem = pItems[li]
        if lItem.type = #button then
          lMouseLocalX = _mouse.mouseH - pRefPosition.locH
          lMouseLocalY = _mouse.mouseV - pRefPosition.locV
          if (lMouseLocalX > lItem.x) and (lMouseLocalX < (lItem.x + lItem.w)) and (lMouseLocalY > lItem.y) and (lMouseLocalY < (lItem.y + lItem.h)) then
            lResult = lItem.button_id
            exit repeat
          end if
        end if
      end repeat
    end if
    pPrevMouseState = lMouseState
  end if
  return lResult
end
