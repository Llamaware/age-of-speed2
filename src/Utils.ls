global gGame

on assert kValue, kString
  if gGame.GetConfiguration() = #release_web then
    return 
  end if
  if not kValue then
    alert("assertion failed:" & RETURN & kString)
    put "assert break point: " & kString
  end if
end

on ToUppercase str
  repeat with i = 1 to str.length
    str_num = charToNum(str.char[i])
    upper_num = charToNum(str.char[i]) - 32
    if numToChar(str_num) = numToChar(upper_num) then
      uppered = uppered & numToChar(upper_num)
      next repeat
    end if
    uppered = uppered & numToChar(str_num)
  end repeat
  return uppered
end

on ToLowercase str
  repeat with i = 1 to str.length
    str_num = charToNum(str.char[i])
    lower_num = charToNum(str.char[i]) + 32
    if numToChar(str_num) = numToChar(lower_num) then
      lowered = lowered & numToChar(lower_num)
      next repeat
    end if
    lowered = lowered & numToChar(str_num)
  end repeat
  return lowered
end

on SearchAndReplace input, stringToFind, stringToInsert
  Output = EMPTY
  findLen = stringToFind.length - 1
  repeat while input contains stringToFind
    currOffset = offset(stringToFind, input)
    Output = Output & input.char[1..currOffset - 1] & stringToInsert
    delete input.char[1..currOffset + findLen]
  end repeat
  Output = Output & input
  return Output
end

on Split kString, kDelimiter
  lOldDelimeter = _player.itemDelimiter
  _player.itemDelimiter = kDelimiter
  lItemList = []
  repeat with li = 1 to kString.item.count
    lItemList.add(kString.item[li])
  end repeat
  _player.itemDelimiter = lOldDelimeter
  return lItemList
end

on urlDecode encodedString
  if not stringp(encodedString) then
    return EMPTY
  end if
  reservedListASCII = [32, 123, 125, 124, 92, 94, 126, 91, 93, 39, 35, 37, 60, 62, 34, 59, 44, 47, 63, 58, 64, 61, 38, 13]
  UrlCodeList = ["%20", "%7B", "%7D", "%7C", "%5C", "%5E", "%7E", "%5B", "%5D", "%27", "%23", "%25", "%3C", "%3E", "%22", "%3B", "%2C", "%2F", "%3F", "%3A", "%40", "%3D", "%26", "%0D"]
  decodedString = EMPTY
  the itemDelimiter = "%"
  encodedStringLength = the number of items in encodedString
  decodedString = item 1 of encodedString
  repeat with i = 2 to encodedStringLength
    encodedText = item i of encodedString
    UrlCode = "%" & char 1 to 2 of encodedText
    if encodedText.length > 2 then
      delete char 1 to 2 of encodedText
    else
      encodedText = EMPTY
    end if
    codePosition = getOne(UrlCodeList, UrlCode)
    AsciiNum = reservedListASCII[codePosition]
    decodedChar = numToChar(AsciiNum)
    put decodedChar & encodedText after decodedString
  end repeat
  the itemDelimiter = ","
  return decodedString
end

on GetAngleFromDirectionYFacing kDir
  if abs(kDir.y) < 0.0001 then
    lAngle = -kDir.x * PI * 0.5
  else
    lAngle = (-kDir.x / kDir.y).atan
    if kDir.y < 0.0 then
      lAngle = PI + lAngle
    end if
  end if
  return lAngle
end

on GetAngleFromDirectionXFacing kDir
  if abs(kDir.x) < 0.0001 then
    lAngle = kDir.y * PI * 0.5
  else
    lAngle = (kDir.y / kDir.x).atan
    if kDir.x < 0.0 then
      lAngle = PI + lAngle
    end if
  end if
  return lAngle
end

on NormalizeAngle kAngle
  repeat while abs(kAngle) > PI
    if kAngle > 0.0 then
      kAngle = kAngle - (2.0 * PI)
      next repeat
    end if
    kAngle = kAngle + (2.0 * PI)
  end repeat
  return kAngle
end

on RandomInRange kMin, kMax, kSteps
  lRange = kMax - kMin
  lValue = float(random(kSteps + 1) - 1)
  return kMin + (lRange * lValue / (kSteps + 1))
end

on MetersTo3d kValue
  return kValue * 100.0
end

on _3dToMeters kValue
  return kValue * 0.01
end

on YardsTo3d kValue
  return kValue * 91.43999999999999773
end

on _3dToYards kValue
  return kValue / 91.43999999999999773
end

on _3dToFt kValue
  return kValue * 0.0328
end

on GetBool kValue
  if kValue = "true" then
    return 1
  end if
  return 0
end

on CreateTextureFromMember p3D, kMemberName, kTextureName
  lImage = member(kMemberName).image
  if voidp(kTextureName) then
    lTextureName = kMemberName & "_texture"
  else
    lTextureName = kTextureName
  end if
  lTexture = p3D.texture(lTextureName)
  if lTexture = VOID then
    lTexture = p3D.newTexture(lTextureName, #fromImageObject, lImage)
  end if
  lTexture.renderFormat = #rgba8888
  lTexture.nearFiltering = 0
  lTexture.quality = #low
  return lTexture
end

on SetupIngameTexture kTexture
  kTexture.renderFormat = #rgba8888
  kTexture.nearFiltering = 0
  kTexture.quality = #low
end

on utiCreateTextureFromText kMember3d, kMemberTxt, kTexName, kTexWidth, kTexHeight, kText, kFontSize, kColor, kBackgroundImg
  kMemberTxt.text = string(kText)
  kMemberTxt.fontSize = kFontSize
  kMemberTxt.color = kColor
  lTxtImg = kMemberTxt.image
  lDstRect = rect(lTxtImg.rect.left, lTxtImg.rect.top, lTxtImg.rect.right, lTxtImg.rect.bottom)
  lImg = image(kTexWidth, kTexHeight, 32)
  lImg.setAlpha(1)
  lImg.useAlpha = 1
  lImg.copyPixels(lTxtImg, lDstRect, lTxtImg.rect)
  lTexture = kMember3d.texture(kTexName)
  if lTexture = VOID then
    lTexture = kMember3d.newTexture(kTexName, #fromImageObject, lImg)
    lTexture.renderFormat = #rgba8888
    lTexture.nearFiltering = 0
    lTexture.quality = #high
    lTexture.compressed = 0
  else
    lTexture.image = lImg
  end if
  return lTexture
end

on utiCreateTextureFromFlashText kMember3d, kFlashSprite, kTextRendererMovieclip, kFlashMovieclipName, kTexName, kTexWidth, kTexHeight, kText, kFontSize, kColor, kIsFlashTextVarName
  lImg = image(kTexWidth, kTexHeight, 32)
  lImg.setAlpha(1)
  lImg.useAlpha = 1
  lSwfSprite = kFlashSprite
  lBmFrameObj = lSwfSprite.newObject("flash.display.BitmapData", kTexWidth, kTexHeight, 32, 0)
  lMatrixObj = lSwfSprite.newObject("flash.geom.Matrix")
  lTextRendererMC = kTextRendererMovieclip & "." & kFlashMovieclipName
  lTextFormatObj = lSwfSprite.newObject("TextFormat")
  lTextFormatObj.size = kFontSize
  lTextfieldObj = lSwfSprite.getVariable(lTextRendererMC & ".tfText", 0)
  if kIsFlashTextVarName then
    lOffGameSprite = sprite(gGame.GetOffGame().pFlashSprite)
    lOffGameRoot = getVariable(lOffGameSprite, "_level0", 0)
    lOffGameRoot.SetTextfieldText(lTextfieldObj, kText)
  else
    lTextfieldObj.text = kText
  end if
  lHexColor = kColor.hexString()
  lTextfieldObj.textColor = "0x" & chars(lHexColor, 2, length(lHexColor))
  lTextfieldObj.setTextFormat(lTextFormatObj)
  lBmFrameObj.draw(lTextRendererMC, lMatrixObj)
  lImg = lSwfSprite.convert(#image, lBmFrameObj)
  lTexture = kMember3d.texture(kTexName)
  if lTexture = VOID then
    lTexture = kMember3d.newTexture(kTexName, #fromImageObject, lImg)
    lTexture.renderFormat = #rgba8888
    lTexture.nearFiltering = 0
    lTexture.quality = #high
    lTexture.compressed = 0
  else
    lTexture.image = lImg
  end if
  return lTexture
end

on GetDottedNumber kValue
  lStringValue = string(kValue)
  lStringLength = lStringValue.length
  lNumDots = integer(floor(lStringLength / 3))
  if lNumDots > 0 then
    lDottedString = EMPTY
    idx = lStringLength
    repeat with li = 1 to lNumDots
      if li = 1 then
        lDottedString = lStringValue.char[idx - 2..idx] & lDottedString
      else
        lDottedString = lStringValue.char[idx - 2..idx] & "." & lDottedString
      end if
      idx = idx - 3
    end repeat
    if idx > 0 then
      lDottedString = lStringValue.char[1..idx] & "." & lDottedString
    end if
    return lDottedString
  else
    return lStringValue
  end if
end

on PrintDottedNumber kTxtMember, kValue
  lStringValue = GetDottedNumber(kValue)
  if kTxtMember <> VOID then
    kTxtMember.text = lStringValue
  end if
end

on MillisecondsToTime fTime, fPrintCents, fNoZeroOnTens
  if fTime < 0 then
    fTime = 0
  end if
  lCents = floor(fTime / 10.0) mod 100
  fTime = fTime / 1000.0
  lSeconds = floor(fTime) mod 60
  lMinutes = floor(fTime / 60.0)
  if lCents < 10 then
    lCentsString = string("0" & lCents)
  else
    lCentsString = string(lCents)
  end if
  if lSeconds < 10 then
    lSecondsString = string("0" & lSeconds)
  else
    lSecondsString = string(lSeconds)
  end if
  if lMinutes < 10 then
    if not voidp(fNoZeroOnTens) and (fNoZeroOnTens = 1) then
      lMinutesString = string(lMinutes)
    else
      lMinutesString = string("0" & lMinutes)
    end if
  else
    lMinutesString = string(lMinutes)
  end if
  if (fPrintCents = VOID) or (fPrintCents = 0) then
    return string(lMinutesString & ":" & lSecondsString)
  else
    if fPrintCents = 1 then
      return string(lMinutesString & ":" & lSecondsString & ":" & lCentsString)
    end if
  end if
end

on MillisecondsToTimeWithMillisecond fTime, fNoZeroOnTens
  if fTime < 0 then
    fTime = 0
  end if
  lMilliSecs = fTime mod 1000
  if lMilliSecs < 10 then
    lMilliSecsString = string("00" & lMilliSecs)
  else
    if lMilliSecs < 100 then
      lMilliSecsString = string("0" & lMilliSecs)
    else
      lMilliSecsString = string(lMilliSecs)
    end if
  end if
  fTime = fTime / 1000.0
  lSeconds = floor(fTime) mod 60
  lMinutes = floor(fTime / 60.0)
  if lSeconds < 10 then
    lSecondsString = string("0" & lSeconds)
  else
    lSecondsString = string(lSeconds)
  end if
  if lMinutes < 10 then
    if not voidp(fNoZeroOnTens) and (fNoZeroOnTens = 1) then
      lMinutesString = string(lMinutes)
    else
      lMinutesString = string("0" & lMinutes)
    end if
  else
    lMinutesString = string(lMinutes)
  end if
  return string(lMinutesString & ":" & lSecondsString & ":" & lMilliSecsString)
end

on PrintTime fMember, fTime, fPrintCents
  lStringTime = MillisecondsToTime(fTime, fPrintCents)
  fMember.text = lStringTime
end

on FindPosLinearList fLinearList, fItem
  repeat with li = 1 to fLinearList.count
    if fLinearList[li] = fItem then
      return li
    end if
  end repeat
  return VOID
end

on SwapTextures kMemberSrc, kMemberDst
  lClonedModels = []
  lTexturesToDelete = []
  repeat with li = 1 to kMemberSrc.model.count
    lMdlName = kMemberSrc.model[li].name
    lClonedModels.append(lMdlName)
    kMemberDst.cloneModelFromCastmember(lMdlName, lMdlName, kMemberSrc)
  end repeat
  repeat with li = 1 to kMemberDst.texture.count
    lOldTexName = kMemberDst.texture[li].name
    lEndSubstring = chars(lOldTexName, lOldTexName.length - 3, lOldTexName.length)
    if lEndSubstring <> "_set" then
      lNewTexName = lOldTexName & "_set"
      lTex = kMemberDst.texture(lNewTexName)
      if not voidp(lTex) then
        repeat with lj = 1 to kMemberDst.shader.count
          lShader = kMemberDst.shader[lj]
          repeat with lk = 1 to lShader.textureList.count
            if lShader.textureList[lk] = VOID then
              next repeat
            end if
            if lShader.textureList[lk].name = lOldTexName then
              lShader.textureList[lk] = lTex
            end if
          end repeat
        end repeat
        lTexturesToDelete.append(lOldTexName)
        put "Swapped texture " & lNewTexName
        next repeat
      end if
      put "cannot find texture " & lNewTexName
    end if
  end repeat
  repeat with li = 1 to lTexturesToDelete.count
    lTexure = kMemberDst.texture(lTexturesToDelete[li])
    if lTexure <> VOID then
      kMemberDst.deleteTexture(lTexturesToDelete[li])
    end if
  end repeat
  repeat with li = 1 to lClonedModels.count
    kMemberDst.deleteModel(lClonedModels[li])
  end repeat
end

on SwapTexture me, kOldSuffix, kNewSuffix
  lTexturesToDelete = []
  repeat with li = 1 to gGame.Get3D().texture.count
    lOldTexName = gGame.Get3D().texture[li].name
    if lOldTexName.length > kOldSuffix.length then
      lTextureSuffix = chars(lOldTexName, lOldTexName.length - (kOldSuffix.length - 1), lOldTexName.length)
      if lTextureSuffix = kOldSuffix then
        lTexturePrefix = chars(lOldTexName, 1, lOldTexName.length - kOldSuffix.length)
        lNewTextureName = lTexturePrefix & kNewSuffix
        lTex = gGame.Get3D().texture(lNewTextureName)
        if not voidp(lTex) then
          repeat with lj = 1 to gGame.Get3D().shader.count
            lShader = gGame.Get3D().shader[lj]
            repeat with lk = 1 to lShader.textureList.count
              if lShader.textureList[lk] = VOID then
                next repeat
              end if
              if lShader.textureList[lk].name = lOldTexName then
                lShader.textureList[lk] = lTex
              end if
            end repeat
          end repeat
          lTexturesToDelete.append(lOldTexName)
          next repeat
        end if
        put "cannot find texture " & lNewTextureName
      end if
    end if
  end repeat
  repeat with li = 1 to lTexturesToDelete.count
    lTexure = gGame.Get3D().texture(lTexturesToDelete[li])
    if not voidp(lTexure) then
      gGame.Get3D().deleteTexture(lTexturesToDelete[li])
    end if
  end repeat
end

on CatmullRom p1, p2, p3, p4, t
  return 0.5 * (((-p1 + (3.0 * p2) - (3.0 * p3) + p4) * t * t * t) + (((2.0 * p1) - (5.0 * p2) + (4.0 * p3) - p4) * t * t) + ((-p1 + p3) * t) + (2.0 * p2))
end

on IsPowerOfTwo num
  n = num.integer
  return bitAnd(n, n - 1) = 0
end

on NextPowerOfTwo num
  n = num.integer
  n = n - 1
  n = bitOr(n, n / 2)
  n = bitOr(n, n / 4)
  n = bitOr(n, n / 16)
  n = bitOr(n, n / 256)
  n = bitOr(n, n / 65536)
  n = n + 1
  return n
end
