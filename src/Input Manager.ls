property pKeys, pMouse, pActive, pPauseKeys
global gGame

on new me
  pKeys = VOID
  pMouse = VOID
  pActive = 1
  pPauseKeys = VOID
  return me
end

on IsActive me
  return pActive
end

on SetActive me, kActive
  pActive = kActive
end

on IsKeyPressed me, kKey
  if gGame.GetConfiguration() = #debug then
    if gGame.GetResourceTool() <> VOID then
      return keyPressed(kKey) and pActive and gGame.GetResourceTool().IsFocusEnabled()
    else
      return keyPressed(kKey) and pActive
    end if
  else
    return keyPressed(kKey) and pActive
  end if
end

on Initialize me
  pKeys = [:]
  pMouse = [:]
  pActive = 1
  pPauseKeys = ["p", "P"]
  _player.emulateMultibuttonMouse = 1
end

on SetPauseKeys me, kPauseKeys
  pPauseKeys = kPauseKeys
end

on AddKeyEvent me, kSymbol, kListener, kKey, kType
  lSymbol = symbol(kKey & "_" & kType)
  lListener = [#object: kListener, #symbol: kSymbol]
  if voidp(pKeys[lSymbol]) then
    pKeys.addProp(lSymbol, [#keyCode: kKey, #type: kType, #state: #up, #listeners: [lListener]])
  else
    pKeys[lSymbol].listeners.append(lListener)
  end if
end

on RemoveKeyEvent me, kSymbol, kListener, kKey, kType
  lSymbol = symbol(kKey & "_" & kType)
  if not voidp(pKeys[lSymbol]) then
    lListeners = pKeys[lSymbol].listeners
    repeat with li = lListeners.count down to 1
      lListener = lListeners[li]
      if (lListener.symbol = kSymbol) and (lListener.object = kListener) then
        lListeners.deleteAt(li)
        exit repeat
      end if
    end repeat
  end if
end

on AddMouseEvent me, kSymbol, kListener, kButton, kType, kActiveInPause
  if voidp(kActiveInPause) then
    kActiveInPause = 0
  end if
  lSymbol = symbol(kButton & kType)
  lListener = [#object: kListener, #symbol: kSymbol, #ActiveInPause: kActiveInPause]
  if voidp(pMouse[lSymbol]) then
    pMouse.addProp(lSymbol, [#mouseButton: kButton, #type: kType, #state: #up, #listeners: [lListener]])
  else
    pMouse[lSymbol].listeners.append(lListener)
  end if
end

on RemoveMouseEvent me, kSymbol, kListener, kButton, kType
  lSymbol = symbol(kButton & kType)
  if not voidp(pMouse[lSymbol]) then
    lListeners = pMouse[lSymbol].listeners
    repeat with li = lListeners.count down to 1
      lListener = lListeners[li]
      if (lListener.symbol = kSymbol) and (lListener.object = kListener) then
        lListeners.deleteAt(li)
        exit repeat
      end if
    end repeat
  end if
end

on update me
  if not pActive then
    return 
  end if
  if not gGame.GetTimeManager().IsInPauseTransition() then
    repeat with li = 1 to pMouse.count
      lMouseEvt = pMouse[li]
      lMouseBtn = lMouseEvt.mouseButton
      lSendEvent = 0
      lNewState = VOID
      if _mouse.mouseDown and (lMouseBtn = #left) then
        lNewState = #down
      else
        if _mouse.mouseUp and (lMouseBtn = #left) then
          lNewState = #up
        else
          if _mouse.rightMouseDown and (lMouseBtn = #right) then
            lNewState = #down
          else
            if _mouse.rightMouseUp and (lMouseBtn = #right) then
              lNewState = #up
            end if
          end if
        end if
      end if
      case lMouseEvt.type of
        #OnDown:
          lSendEvent = lNewState = #down
        #OnUp:
          lSendEvent = lNewState = #up
        #OnReleased:
          lSendEvent = (lMouseEvt.state = #down) and (lNewState = #up)
        #OnPressed:
          lSendEvent = (lMouseEvt.state = #up) and (lNewState = #down)
      end case
      lMouseEvt.state = lNewState
      if not lSendEvent then
        next repeat
      end if
      lListeners = lMouseEvt.listeners
      repeat with lj = 1 to lListeners.count
        lListener = lListeners[lj]
        if not gGame.IsPaused() or lListener.ActiveInPause then
          lListener.object.SendKeyEvent(lListener.symbol)
        end if
      end repeat
    end repeat
  end if
  repeat with li = 1 to pKeys.count
    lKey = pKeys[li]
    lKeyCode = lKey.keyCode
    lSendEvent = 0
    if gGame.IsPaused() or gGame.GetTimeManager().IsInPauseTransition() then
      lIsAPauseKey = 0
      repeat with lPauseKey in pPauseKeys
        if lKeyCode = lPauseKey then
          lIsAPauseKey = 1
          exit repeat
        end if
      end repeat
      if not lIsAPauseKey then
        next repeat
      end if
    end if
    lNewState = VOID
    if me.IsKeyPressed(lKeyCode) then
      lNewState = #down
    else
      lNewState = #up
    end if
    case lKey.type of
      #OnDown:
        lSendEvent = lNewState = #down
      #OnUp:
        lSendEvent = lNewState = #up
      #OnRelease:
        lSendEvent = (lKey.state = #down) and (lNewState = #up)
      #OnPressed:
        lSendEvent = (lKey.state = #up) and (lNewState = #down)
    end case
    lKey.state = lNewState
    if not lSendEvent then
      next repeat
    end if
    lListeners = lKey.listeners
    repeat with lj = 1 to lListeners.count
      lListener = lListeners[lj]
      lListener.object.SendKeyEvent(lListener.symbol)
    end repeat
  end repeat
end
