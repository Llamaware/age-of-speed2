property pTokensTypes, pTrackTokens
global gGame

on new me
  me.SetTokenTypes()
  me.SetTrackTokenAutomatic()
  me.SetupTokenProperties()
  return me
end

on GetTokensTypes me
  return pTokensTypes
end

on GetTrackTokens me
  return pTrackTokens
end

on SetTokenTypes me
  lWidth = 4000.0
  pTokensTypes = [#d1: [#Len: 3500.0, #width: lWidth, #type: #rect, #OneWay: 0], #d2: [#Len: 7000.0, #width: lWidth, #type: #rect, #OneWay: 0], #d2turbo: [#Len: 7000.0, #width: lWidth, #type: #rect, #OneWay: 0], #d2jump: [#Len: 7000.0, #width: lWidth, #type: #rect, #OneWay: 0], #d3: [#Len: 10500.0, #width: lWidth, #type: #rect, #OneWay: 0], #d3jump: [#Len: 10500.0, #width: lWidth, #type: #rect, #OneWay: 0], #d4: [#Len: 14000.0, #width: lWidth, #type: #rect, #OneWay: 0], #twist: [#Len: 24500.00200000000040745, #width: lWidth, #type: #rect, #OneWay: 0], #loop: [#Len: 6684.51000000000021828, #width: lWidth, #type: #loop, #OneWay: 0], #c90r3d: [#Len: 16493.38000000000101863, #width: lWidth, #radius: 10500.0, #Ver: -1.0, #Arc: PI / 2.0, #type: #curve, #OneWay: 0], #c90r3s: [#Len: 16493.38000000000101863, #width: lWidth, #radius: 10500.0, #Ver: 1.0, #Arc: PI / 2.0, #type: #curve, #OneWay: 0], #c90r4d: [#Len: 19242.25999999999839929, #width: lWidth, #radius: 12250.0, #Ver: -1.0, #Arc: PI / 2.0, #type: #curve, #OneWay: 0], #c90r4s: [#Len: 19242.25999999999839929, #width: lWidth, #radius: 12250.0, #Ver: 1.0, #Arc: PI / 2.0, #type: #curve, #OneWay: 0]]
end

on SetupTokenProperties me
  repeat with li = 1 to pTrackTokens.count
    lTokenRef = pTrackTokens[li]
    lTokenType = lTokenRef.token
    lNextTokenType = pTrackTokens[lTokenRef.next[1]].token
    lTurbo = 0
    lAiTest = (pTokensTypes[lTokenType].type = #rect) and not (pTokensTypes[lNextTokenType].type = #curve)
    if lAiTest then
      lAiType = #CheckOthers
    else
      lAiType = #AiSimple
    end if
    if lTokenType = "d2turbo" then
      lTurbo = 1
    end if
    lTokenRef.addProp(#AiType, lAiType)
    lTokenRef.addProp(#turbo, lTurbo)
  end repeat
end

on SetTrackTokenAutomatic me
  l3D = gGame.Get3D()
  pTrackTokens = [:]
  lTokenMdlList = []
  repeat with li = 1 to l3D.model.count
    lMdl = l3D.model[li]
    if lMdl.name starts "l_t" then
      lTokenMdlList.add(lMdl.name)
      pTrackTokens.addProp(symbol("t" & lTokenMdlList.count), VOID)
    end if
  end repeat
  repeat with li = 1 to lTokenMdlList.count
    lTokenName = lTokenMdlList[li]
    lTokenData = chars(lTokenName, 5, lTokenName.length)
    lStartIdxPos = offset("_", lTokenData)
    if lStartIdxPos = 0 then
      put "error on token name, missing underscore in " & lTokenName
    end if
    lTokenType = chars(lTokenName, 5, 3 + lStartIdxPos)
    lTokenIdx = integer(chars(lTokenName, 5 + lStartIdxPos, lTokenName.length))
    if lTokenIdx = 1 then
      lPrevIdx = symbol("t" & lTokenMdlList.count)
    else
      lPrevIdx = symbol("t" & lTokenIdx - 1)
    end if
    if lTokenIdx = lTokenMdlList.count then
      lNextIdx = #t1
    else
      lNextIdx = symbol("t" & lTokenIdx + 1)
    end if
    lTokenInfo = [#ModelName: lTokenName, #token: lTokenType, #Prev: [lPrevIdx], #next: [lNextIdx]]
    pTrackTokens["t" & lTokenIdx] = lTokenInfo
  end repeat
  return pTrackTokens
end
