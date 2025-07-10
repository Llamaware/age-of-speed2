property pInGame, pSymbolList, pValueList, pIsDecimal, pNumbers, pType, pPrefix, pShowZeros, pVisible
global gGame

on new me, kInGame, kIsDecimal, kType, kNumbers, kPrefix
  pInGame = kInGame
  pSymbolList = [:]
  pValueList = []
  pIsDecimal = kIsDecimal
  if voidp(kPrefix) then
    pPrefix = EMPTY
  else
    pPrefix = kPrefix
  end if
  if voidp(kType) then
    pType = #time
  else
    pType = kType
  end if
  if not voidp(kNumbers) then
    pNumbers = kNumbers
  end if
  me.Initialize()
  return me
end

on Initialize
  if pType = #time then
    pValueList = [0, 0, 0, 0, 0, 0]
  else
    repeat with li = 1 to pNumbers
      pValueList.add(0)
    end repeat
  end if
  pShowZeros = 0
  pVisible = 0
end

on SetShowZeros me, kFlag
  pShowZeros = kFlag
end

on AddSymbol me, kId, kImage, kWidth
  lTextureRef = pInGame.CreateTexture(kImage, kImage)
  pSymbolList.addProp(kId, [#textureRef: lTextureRef, #width: kWidth])
end

on AddExistingSymbol me, kId, kImage, kWidth
  lTextureRef = gGame.Get3D().texture(kImage)
  pSymbolList.addProp(kId, [#textureRef: lTextureRef, #width: kWidth])
end

on create me, kStartValue, kStartPosition, kSpacing
  if pType = #time then
    if kStartValue = -1 then
      pInGame.AddGfxItem(pPrefix & "Min1", pSymbolList["dash"].textureRef, kStartPosition)
      pValueList[1] = -1
      lNextPosition = point(kStartPosition.locH + pSymbolList["dash"].width + kSpacing, kStartPosition.locV)
      pInGame.AddGfxItem(pPrefix & "Min2", pSymbolList["dash"].textureRef, lNextPosition)
      pValueList[2] = -1
      lNextPosition.locH = lNextPosition.locH + pSymbolList["dash"].width + kSpacing
      pInGame.AddGfxItem(pPrefix & "Separator1", pSymbolList["separator"].textureRef, lNextPosition)
      lNextPosition.locH = lNextPosition.locH + pSymbolList["separator"].width + kSpacing
      pInGame.AddGfxItem(pPrefix & "Sec1", pSymbolList["dash"].textureRef, lNextPosition)
      pValueList[3] = -1
      lNextPosition.locH = lNextPosition.locH + pSymbolList["dash"].width + kSpacing
      pInGame.AddGfxItem(pPrefix & "Sec2", pSymbolList["dash"].textureRef, lNextPosition)
      pValueList[4] = -1
      if pIsDecimal then
        lNextPosition.locH = lNextPosition.locH + pSymbolList["dash"].width + kSpacing
        pInGame.AddGfxItem(pPrefix & "Separator2", pSymbolList["separator"].textureRef, lNextPosition)
        lNextPosition.locH = lNextPosition.locH + pSymbolList["separator"].width + kSpacing
        pInGame.AddGfxItem(pPrefix & "Dec1", pSymbolList["dash"].textureRef, lNextPosition)
        pValueList[5] = -1
        lNextPosition.locH = lNextPosition.locH + pSymbolList["dash"].width + kSpacing
        pInGame.AddGfxItem(pPrefix & "Dec2", pSymbolList["dash"].textureRef, lNextPosition)
        pValueList[6] = -1
      end if
    else
      lTimeString = string(MillisecondsToTime(kStartValue, pIsDecimal))
      pInGame.AddGfxItem(pPrefix & "Min1", pSymbolList[lTimeString.char[1]].textureRef, kStartPosition)
      pValueList[1] = lTimeString.char[1]
      lNextPosition = point(kStartPosition.locH + pSymbolList[lTimeString.char[1]].width + kSpacing, kStartPosition.locV)
      pInGame.AddGfxItem(pPrefix & "Min2", pSymbolList[lTimeString.char[2]].textureRef, lNextPosition)
      pValueList[2] = lTimeString.char[2]
      lNextPosition.locH = lNextPosition.locH + pSymbolList[lTimeString.char[2]].width + kSpacing
      pInGame.AddGfxItem(pPrefix & "Separator1", pSymbolList["separator"].textureRef, lNextPosition)
      lNextPosition.locH = lNextPosition.locH + pSymbolList["separator"].width + kSpacing
      pInGame.AddGfxItem(pPrefix & "Sec1", pSymbolList[lTimeString.char[4]].textureRef, lNextPosition)
      pValueList[3] = lTimeString.char[4]
      lNextPosition.locH = lNextPosition.locH + pSymbolList[lTimeString.char[4]].width + kSpacing
      pInGame.AddGfxItem(pPrefix & "Sec2", pSymbolList[lTimeString.char[5]].textureRef, lNextPosition)
      pValueList[4] = lTimeString.char[5]
      if pIsDecimal then
        lNextPosition.locH = lNextPosition.locH + pSymbolList[lTimeString.char[5]].width + kSpacing
        pInGame.AddGfxItem(pPrefix & "Separator2", pSymbolList["separator"].textureRef, lNextPosition)
        lNextPosition.locH = lNextPosition.locH + pSymbolList["separator"].width + kSpacing
        pInGame.AddGfxItem(pPrefix & "Dec1", pSymbolList[lTimeString.char[7]].textureRef, lNextPosition)
        pValueList[5] = lTimeString.char[7]
        lNextPosition.locH = lNextPosition.locH + pSymbolList[lTimeString.char[7]].width + kSpacing
        pInGame.AddGfxItem(pPrefix & "Dec2", pSymbolList[lTimeString.char[8]].textureRef, lNextPosition)
        pValueList[6] = lTimeString.char[8]
      end if
    end if
  else
    lScoreString = string(kStartValue)
    lNextPosition = kStartPosition
    repeat with li = 1 to pNumbers
      pInGame.AddGfxItem(pPrefix & li, pSymbolList["0"].textureRef, lNextPosition)
      lNextPosition.locH = lNextPosition.locH + pSymbolList["2"].width + kSpacing
    end repeat
    repeat with li = 1 to lScoreString.length
      lSlot = pNumbers - lScoreString.length + li
      gGame.GetOverlayManager().Modify(pPrefix & lSlot, pSymbolList[lScoreString.char[li]].textureRef, VOID, VOID, VOID, VOID)
    end repeat
  end if
  pVisible = 1
end

on setPosition me, kStartPosition, kSpacing
  if pType = #time then
    assert(0, "SetPosition implemented only on Overlay Bitmap Time of Type = #score")
  else
    lNextPosition = kStartPosition
    repeat with li = 1 to pNumbers
      gGame.GetOverlayManager().Modify(pPrefix & li, VOID, lNextPosition, VOID, VOID, VOID)
      lNextPosition.locH = lNextPosition.locH + pSymbolList["2"].width + kSpacing
    end repeat
  end if
end

on SetVisible me, kFlag
  if kFlag <> pVisible then
    pVisible = kFlag
    lOverlaysList = []
    if pType = #time then
      lOverlaysList.append(pPrefix & "Min1")
      lOverlaysList.append(pPrefix & "Min2")
      lOverlaysList.append(pPrefix & "Separator1")
      lOverlaysList.append(pPrefix & "Sec1")
      lOverlaysList.append(pPrefix & "Sec2")
      if pIsDecimal then
        lOverlaysList.append(pPrefix & "Separator2")
        lOverlaysList.append(pPrefix & "Dec1")
        lOverlaysList.append(pPrefix & "Dec2")
      end if
    else
      repeat with li = 1 to pNumbers
        lOverlaysList.append(pPrefix & li)
      end repeat
    end if
    if pVisible then
      repeat with lOverlayId in lOverlaysList
        gGame.GetOverlayManager().Modify(lOverlayId, VOID, VOID, VOID, 100.0)
      end repeat
    else
      repeat with lOverlayId in lOverlaysList
        gGame.GetOverlayManager().Modify(lOverlayId, VOID, VOID, VOID, 0.0)
      end repeat
    end if
  end if
end

on IsVisible me
  return pVisible
end

on update me, kValue
  if pType = #time then
    lTimeString = string(MillisecondsToTime(kValue, pIsDecimal))
    if pValueList[1] <> lTimeString.char[1] then
      gGame.GetOverlayManager().Modify(pPrefix & "Min1", pSymbolList[lTimeString.char[1]].textureRef, VOID, VOID, VOID, VOID)
      pValueList[1] = lTimeString.char[1]
    end if
    if pValueList[2] <> lTimeString.char[2] then
      gGame.GetOverlayManager().Modify(pPrefix & "Min2", pSymbolList[lTimeString.char[2]].textureRef, VOID, VOID, VOID, VOID)
      pValueList[2] = lTimeString.char[2]
    end if
    if pValueList[3] <> lTimeString.char[4] then
      gGame.GetOverlayManager().Modify(pPrefix & "Sec1", pSymbolList[lTimeString.char[4]].textureRef, VOID, VOID, VOID, VOID)
      pValueList[3] = lTimeString.char[4]
    end if
    if pValueList[4] <> lTimeString.char[5] then
      gGame.GetOverlayManager().Modify(pPrefix & "Sec2", pSymbolList[lTimeString.char[5]].textureRef, VOID, VOID, VOID, VOID)
      pValueList[4] = lTimeString.char[5]
    end if
    if pIsDecimal then
      if pValueList[5] <> lTimeString.char[7] then
        gGame.GetOverlayManager().Modify(pPrefix & "Dec1", pSymbolList[lTimeString.char[7]].textureRef, VOID, VOID, VOID, VOID)
        pValueList[5] = lTimeString.char[7]
      end if
      if pValueList[6] <> lTimeString.char[8] then
        gGame.GetOverlayManager().Modify(pPrefix & "Dec2", pSymbolList[lTimeString.char[8]].textureRef, VOID, VOID, VOID, VOID)
        pValueList[6] = lTimeString.char[8]
      end if
    end if
  else
    if voidp(kValue) then
      repeat with li = 1 to pNumbers
        gGame.GetOverlayManager().Modify(pPrefix & li, VOID, VOID, VOID, 0.0, VOID)
      end repeat
      return 
    end if
    lScoreString = string(kValue)
    lLastNotUsed = pNumbers - lScoreString.length
    repeat with li = 1 to lLastNotUsed
      if not pShowZeros then
        gGame.GetOverlayManager().Modify(pPrefix & li, VOID, VOID, VOID, 0.0, VOID)
        next repeat
      end if
      gGame.GetOverlayManager().Modify(pPrefix & li, pSymbolList["0"].textureRef)
    end repeat
    repeat with li = 1 to lScoreString.length
      lChar = lScoreString.char[li]
      if lChar = "-" then
        lChar = "minus"
      end if
      lSlot = pNumbers - lScoreString.length + li
      gGame.GetOverlayManager().Modify(pPrefix & lSlot, pSymbolList[lChar].textureRef, VOID, VOID, 100, VOID)
    end repeat
  end if
end

on ForceSlot me, kIdx, kTexture
  gGame.GetOverlayManager().Modify(pPrefix & kIdx, kTexture, VOID, VOID, 100, VOID)
end
