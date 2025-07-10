property pTokensTypesStruct, pTrackTokens, pTokenLimit, pExpansionWidth, pLongitudinalGap, pBestTrasversal, pLimitDistanceForBestTrasversal, pReverseMode
global gGame

on new me
  pTokensTypesStruct = []
  pTrackTokens = []
  pExpansionWidth = 0.0
  pLongitudinalGap = 0.0
  pReverseMode = 0
  pBestTrasversal = 0.80000000000000004
  pLimitDistanceForBestTrasversal = 2000
  return me
end

on GetTrackTokens me
  return pTrackTokens
end

on GetTokensTypesStruct me
  return pTokensTypesStruct
end

on GetTrackTokensFromCullingManager me, fPosition
  lTokenList = gGame.GetCullingManager().GetCullerBlockTokens(fPosition)
  return lTokenList
end

on getTokenType me, kTokenIndex
  lTrackTokenRef = me.pTrackTokens[kTokenIndex]
  lIndexTokenType = lTrackTokenRef.token
  return me.pTokensTypesStruct[lIndexTokenType]
end

on GetTokenRef me, kTokenIndex
  if kTokenIndex <> 0 then
    return pTrackTokens[kTokenIndex]
  end if
  return VOID
end

on GetOrientationInToken me, tokenindex, px, py
  if tokenindex <> 0 then
    l_n1 = vector(px, py, 0.0) - pTrackTokens[tokenindex].center
    l_n1.normalize()
    l_n2 = vector(pTrackTokens[tokenindex].Ver, 0.0, 0.0)
    l_AngleBtw = l_n1.angleBetween(l_n2)
    l_Signp = l_n1.crossProduct(l_n2)
    if l_Signp.z >= 0.0 then
      return -l_AngleBtw
    else
      return l_AngleBtw
    end if
  end if
  return 0.0
end

on ReverseMode me
  return pReverseMode
end

on SetExpansionWidth me, kExpansionWidth, kLongitudinalGap
  pExpansionWidth = kExpansionWidth
  if not voidp(kLongitudinalGap) then
    pLongitudinalGap = kLongitudinalGap
  end if
end

on SetReverseMode me, kIsReverse
  pReverseMode = kIsReverse
end

on SetBestTrasversal me, kBestTrasversal
  pBestTrasversal = kBestTrasversal
end

on SetLimitDistanceForBestTrasversal me, kLimitDistanceForBestTrasversal
  pLimitDistanceForBestTrasversal = kLimitDistanceForBestTrasversal
end

on InitializeTrackTokens me
  repeat with i = 1 to pTrackTokens.count
    l_TrackToken = pTrackTokens[i]
    l_TrackToken.addProp(#model, gGame.Get3D().model(l_TrackToken.ModelName))
    l_TokenType = pTokensTypesStruct[l_TrackToken.token]
    l_TrackTokenModelPosition = l_TrackToken.model.transform.position
    l_TrackTokenPosition = vector(l_TrackTokenModelPosition.x, l_TrackTokenModelPosition.y, l_TrackTokenModelPosition.z)
    l_TrackTokenPosition.z = 0.0
    l_TrackToken.addProp(#position, l_TrackTokenPosition)
    l_TrackToken.addProp(#index, symbol("t" & chars(l_TrackToken.ModelName, 4, l_TrackToken.ModelName.length)))
    if l_TokenType.type = #rect then
      l_EndPosition = vector(0.0, l_TokenType.Len, 0.0)
      l_TrackTokenTrans = l_TrackToken.model.transform.duplicate()
      l_TrackTokenTrans.position = vector(0, 0, 0)
      l_TrackTokenTrans.scale = vector(1, 1, 1)
      l_EndPosition = vector(l_TrackToken.position.x, l_TrackToken.position.y, l_TrackToken.position.z) + (l_TrackTokenTrans * l_EndPosition)
      l_TrackToken.addProp(#EndPosition, l_EndPosition)
      l_TrackToken.addProp(#length, (l_TrackToken.EndPosition - l_TrackToken.position).magnitude)
    end if
    if l_TokenType.type = #curve then
      l_CenterPosition = vector(-l_TokenType.radius * l_TokenType.Ver, 0.0, 0.0)
      l_TrackTokenTrans = l_TrackToken.model.transform.duplicate()
      l_TrackTokenTrans.position = vector(0, 0, 0)
      l_TrackTokenTrans.scale = vector(1, 1, 1)
      l_CenterPosition = vector(l_TrackToken.position.x, l_TrackToken.position.y, l_TrackToken.position.z) + (l_TrackTokenTrans * l_CenterPosition)
      l_TrackToken.addProp(#center, l_CenterPosition)
    end if
    if l_TokenType.type = #rotary then
      l_CenterPosition = vector(0.0, l_TokenType.radius, 0.0)
      l_TrackTokenTrans = l_TrackToken.model.transform.duplicate()
      l_TrackTokenTrans.position = vector(0, 0, 0)
      l_TrackTokenTrans.scale = vector(1, 1, 1)
      l_CenterPosition = vector(l_TrackToken.position.x, l_TrackToken.position.y, l_TrackToken.position.z) + (l_TrackTokenTrans * l_CenterPosition)
      l_TrackToken.addProp(#center, l_CenterPosition)
    end if
    if l_TokenType.type = #cross then
      l_EndPosition = vector(0.0, l_TokenType.Len, 0.0)
      l_TrackTokenTrans = l_TrackToken.model.transform.duplicate()
      l_TrackTokenTrans.position = vector(0, 0, 0)
      l_TrackTokenTrans.scale = vector(1, 1, 1)
      l_EndPosition = vector(l_TrackToken.position.x, l_TrackToken.position.y, l_TrackToken.position.z) + (l_TrackTokenTrans * l_EndPosition)
      l_TrackToken.addProp(#EndPosition, l_EndPosition)
      l_TrackToken.addProp(#length, (l_TrackToken.EndPosition - l_TrackToken.position).magnitude)
    end if
    l_TrackToken.addProp(#CheckLineList, [])
    if l_TokenType.type = #rect then
      l_TrackToken.addProp(#RoadLength, l_TokenType.Len)
    else
      if l_TokenType.type = #curve then
        lArcLen = l_TokenType.Arc * l_TokenType.radius
        l_TrackToken.addProp(#RoadLength, lArcLen)
      end if
    end if
    if l_TrackToken.Prev.count > 1 then
      l_TrackToken.addProp(#Rejoin, l_TrackToken.Prev.count)
    end if
  end repeat
end

on TokenToWorld me, p_TokenIndex, p_Longitudinal, p_Trasversal
  l_TrackToken = pTrackTokens[p_TokenIndex]
  return me.TokenToWorldByRef(l_TrackToken, p_Longitudinal, p_Trasversal)
end

on TokenToWorldByRef me, p_TrackToken, p_Longitudinal, p_Trasversal
  l_TokenType = pTokensTypesStruct[p_TrackToken.token]
  if (l_TokenType.type = #rect) or (l_TokenType.type = #cross) then
    l_TokenForward = p_TrackToken.EndPosition - p_TrackToken.position
    l_Position = p_TrackToken.position + (l_TokenForward * p_Longitudinal)
    l_TokenForwardNorm = l_TokenForward
    l_TokenForwardNorm.normalize()
    l_TokenLateralNorm = vector(-l_TokenForwardNorm.y, l_TokenForwardNorm.x, 0.0)
    lWidth = l_TokenType.width
    l_Position = l_Position - (l_TokenLateralNorm * lWidth * 0.5 * p_Trasversal)
    return l_Position
  end if
  if l_TokenType.type = #curve then
    lWidth = l_TokenType.width
    l_Radius = l_TokenType.radius + (p_Trasversal * lWidth * 0.5 * l_TokenType.Ver)
    l_n1 = p_TrackToken.position - p_TrackToken.center
    l_n1.normalize()
    l_Transform = transform()
    l_Transform.rotate(0.0, 0.0, p_Longitudinal * l_TokenType.Arc * l_TokenType.Ver * 360.0 / (2 * PI))
    l_n1 = l_n1 * l_Radius
    l_n1 = l_Transform * l_n1
    l_Position = p_TrackToken.center + l_n1
    return l_Position
  end if
  if l_TokenType.type = #rotary then
    l_Radius = (p_Trasversal * ((l_TokenType.OuterRadius - l_TokenType.InnerRadius) * 0.5)) + ((l_TokenType.OuterRadius + l_TokenType.InnerRadius) * 0.5)
    l_n1 = p_TrackToken.position - p_TrackToken.center
    l_n1.normalize()
    l_Transform = transform()
    l_Transform.rotate(0.0, 0.0, p_Longitudinal * 2 * PI * 360.0 / (2 * PI))
    l_n1 = l_n1 * l_Radius
    l_n1 = l_Transform * l_n1
    l_Position = p_TrackToken.center + l_n1
    return l_Position
  end if
  return vector(0.0, 0.0, 0.0)
end

on CheckToken me, tokenindex, px, py, p_WidthOffset, p_LongitudinalGap, fWithTokenLimit
  l_TrackToken = me.pTrackTokens[tokenindex]
  return me.CheckTokenByRef(l_TrackToken, px, py, p_WidthOffset, p_LongitudinalGap, fWithTokenLimit)
end

on GetTokenWithExpansion me, CurrentToken, px, py, fWithTokenLimit
  lLongitudinalGap = pLongitudinalGap
  l_TrackToken = me.pTrackTokens[CurrentToken]
  lResult = me.CheckTokenByRef(l_TrackToken, px, py, pExpansionWidth, lLongitudinalGap, fWithTokenLimit)
  if lResult[1] <> 0 then
    return lResult
  else
    lCurrentTrackToken = l_TrackToken
    lNextList = lCurrentTrackToken.next
    if fWithTokenLimit then
      lNextList = [lNextList[1]]
    end if
    repeat with lj = 1 to lNextList.count
      lTokenToCheck = lNextList[lj]
      l_TrackToken = me.pTrackTokens[lTokenToCheck]
      lResult = me.CheckTokenByRef(l_TrackToken, px, py, pExpansionWidth, lLongitudinalGap, fWithTokenLimit)
      if lResult[1] <> 0 then
        return lResult
      end if
    end repeat
    lPrevList = lCurrentTrackToken.Prev
    if fWithTokenLimit then
      lPrevList = [lPrevList[1]]
    end if
    repeat with lj = 1 to lPrevList.count
      lTokenToCheck = lPrevList[lj]
      l_TrackToken = me.pTrackTokens[lTokenToCheck]
      lResult = me.CheckTokenByRef(l_TrackToken, px, py, pExpansionWidth, lLongitudinalGap, fWithTokenLimit)
      if lResult[1] <> 0 then
        return lResult
      end if
    end repeat
  end if
  return [0, 0.0, 0.0, 0.0, 0.0]
end

on CheckTokenByRef me, l_TrackToken, px, py, p_WidthOffset, p_LongitudinalGap, fWithTokenLimit
  fWithTokenLimit = 0
  l_TokenType = pTokensTypesStruct[l_TrackToken.token]
  l_QueryResult = [0, 0.0, 0.0, 0.0, 0.0]
  if (l_TokenType.type = #rect) or (l_TokenType.type = #cross) then
    l_Position = vector(px, py, 0.0)
    l_TokenDir = l_TrackToken.EndPosition - l_TrackToken.position
    l_TokenDir.normalize()
    lGapLength = l_TokenType.Len * p_LongitudinalGap
    l_endPos = l_TrackToken.EndPosition + (l_TokenDir * lGapLength)
    l_startPos = l_TrackToken.position - (l_TokenDir * lGapLength)
    l_Result = GetNearestPointOnLineSeg(l_startPos, l_endPos, l_Position)
    if l_Result <> VOID then
      l_Position.x = l_Position.x - l_Result.x
      l_Position.y = l_Position.y - l_Result.y
      l_Distance = sqrt((l_Position.x * l_Position.x) + (l_Position.y * l_Position.y))
      l_Longitudinal = (l_Result - l_TrackToken.position).magnitude / l_TrackToken.length
      lTokenWidth = l_TokenType.width
      if not l_TokenType.ConstantWidth then
        lTokenWidth = lTokenWidth + ((l_TokenType.EndWidth - lTokenWidth) * l_Longitudinal)
      end if
      if l_TokenType.type = #cross then
        l_Width = lTokenWidth * 0.5
      else
        l_Width = (lTokenWidth * 0.5) + p_WidthOffset
      end if
      if l_Distance <= l_Width then
        l_Tangent = l_TrackToken.EndPosition - l_TrackToken.position
        l_Tangent.normalize()
        l_Result.z = 0.0
        l_Versor = l_Position.crossProduct(l_Tangent)
        l_Trasversal = l_Distance / l_Width
        if l_Versor.z < 0 then
          l_Trasversal = -l_Trasversal
        end if
        if (l_Trasversal < l_TokenType.LeftLimit) or (l_Trasversal > l_TokenType.RightLimit) then
          l_QueryResult = [0.0, float(0.0), 0.0, 0.0, 0.0]
        else
          l_Trasversal = l_Distance / (l_Width - p_WidthOffset)
          if l_Versor.z < 0 then
            l_Trasversal = -l_Trasversal
          end if
          l_QueryResult = [l_TrackToken.index, float(0.0), l_Tangent, l_Longitudinal, l_Trasversal]
        end if
      end if
    end if
  else
    if l_TokenType.type = #curve then
      l_Radius = float((vector(px, py, 0.0) - l_TrackToken.center).magnitude)
      l_n1 = l_TrackToken.position - l_TrackToken.center
      l_n1.normalize()
      l_n2 = vector(px, py, 0.0) - l_TrackToken.center
      l_n2.normalize()
      angleBtw = l_n1.angleBetween(l_n2)
      angleBtw = 2.0 * PI / 360.0 * angleBtw
      l_Longitudinal = angleBtw / l_TokenType.Arc
      lTokenWidth = l_TokenType.width
      if not l_TokenType.ConstantWidth then
        lTokenWidth = lTokenWidth + ((l_TokenType.EndWidth - lTokenWidth) * l_Longitudinal)
      end if
      if abs(l_Radius - l_TokenType.radius) < ((lTokenWidth * 0.5) + p_WidthOffset) then
        Signp = l_n1.crossProduct(l_n2)
        if ((Sign(Signp.z) = l_TokenType.Ver) and (angleBtw < (l_TokenType.Arc + (l_TokenType.Arc * 0.01) + (l_TokenType.Arc * p_LongitudinalGap)))) or ((Sign(Signp.z) = l_TokenType.Ver) and (angleBtw < ((l_TokenType.Arc * p_LongitudinalGap) + (l_TokenType.Arc * 0.01)))) then
          l_Tangent = l_TokenType.Ver * vector(-l_n2.y, l_n2.x, 0.0)
          l_Tangent.normalize()
          l_Trasversal = abs(l_Radius - l_TokenType.radius) / (lTokenWidth / 2.0) * l_TokenType.Ver
          if l_Radius < l_TokenType.radius then
            l_Trasversal = -l_Trasversal
          end if
          l_QueryResult = [l_TrackToken.index, float(angleBtw), l_Tangent, l_Longitudinal, l_Trasversal]
        end if
      end if
    else
      if l_TokenType.type = #rotary then
        l_Radius = float((vector(px, py, 0.0) - l_TrackToken.center).magnitude)
        if (l_Radius >= l_TokenType.InnerRadius) and (l_Radius <= (l_TokenType.OuterRadius + p_WidthOffset)) then
          l_n1 = l_TrackToken.position - l_TrackToken.center
          l_n1.normalize()
          l_n2 = vector(px, py, 0.0) - l_TrackToken.center
          l_n2.normalize()
          Signp = l_n1.crossProduct(l_n2)
          angleBtw = l_n1.angleBetween(l_n2)
          if Signp.z < 0 then
            angleBtw = 360.0 - angleBtw
          end if
          l_Tangent = vector(-l_n2.y, l_n2.x, 0.0)
          l_Tangent.normalize()
          l_Longitudinal = angleBtw / 360.0
          l_Trasversal = (l_Radius - ((l_TokenType.OuterRadius + l_TokenType.InnerRadius) * 0.5)) / ((l_TokenType.OuterRadius - l_TokenType.InnerRadius) * 0.5)
          l_QueryResult = [l_TrackToken.index, float(angleBtw), l_Tangent, l_Longitudinal, l_Trasversal]
        end if
      end if
    end if
  end if
  if l_QueryResult[1] <> 0 then
    if fWithTokenLimit then
      if l_QueryResult[1] > me.pTokenLimit then
        l_QueryResult = [0, 0.0, 0.0, 0.0, 0.0]
      end if
    end if
  end if
  return l_QueryResult
end

on getToken me, CurrentToken, px, py, p_PlayerDirection, p_WidthOffset, p_LongitudinalGap, fWithTokenLimit
  if voidp(fWithTokenLimit) then
    fWithTokenLimit = 0
  end if
  if CurrentToken > 0 then
    CheckResult = me.CheckToken(CurrentToken, px, py, p_WidthOffset, p_LongitudinalGap, fWithTokenLimit)
    if CheckResult[1] <> 0 then
      return CheckResult
    end if
    l_TrackToken = pTrackTokens[CurrentToken]
    lTotLinks = l_TrackToken.next.count
    repeat with i = 1 to lTotLinks
      if not fWithTokenLimit then
        CheckResult = me.CheckTokenByRef(pTrackTokens[l_TrackToken.next[i]], px, py, p_WidthOffset, p_LongitudinalGap, fWithTokenLimit)
        if CheckResult[1] <> 0 then
          return CheckResult
        end if
      end if
    end repeat
    lTotLinks = l_TrackToken.Prev.count
    repeat with i = 1 to lTotLinks
      if not fWithTokenLimit then
        CheckResult = me.CheckTokenByRef(pTrackTokens[l_TrackToken.Prev[i]], px, py, p_WidthOffset, p_LongitudinalGap, fWithTokenLimit)
        if CheckResult[1] <> 0 then
          return CheckResult
        end if
      end if
    end repeat
  end if
  CheckResult = me.CheckTokenFromCullingManager(px, py, p_PlayerDirection, p_WidthOffset, p_LongitudinalGap, fWithTokenLimit)
  if CheckResult[1] <> 0 then
    return CheckResult
  end if
  return [0, 0.0, 0.0, 0.0, 0.0]
end

on CheckTokenFromCullingManager me, px, py, p_PlayerDirection, p_WidthOffset, p_LongitudinalGap, fWithTokenLimit
  lTokenList = gGame.GetCullingManager().GetCullerBlockTokens(vector(px, py, 0))
  repeat with i = 1 to lTokenList.count
    CheckResult = me.CheckToken(lTokenList[i].index, px, py, p_WidthOffset, p_LongitudinalGap, fWithTokenLimit)
    if CheckResult[1] <> 0 then
      return CheckResult
    end if
  end repeat
  return [0, 0.0, 0.0, 0.0, 0.0]
end

on GetTargetPosition me, fCurrentToken, fLongitudinal, fDistance, fTrasversal
  if me.ReverseMode() then
    return me.GetTargetPositionReverseMode(fCurrentToken, fLongitudinal, fDistance, fTrasversal)
  end if
  lDistance = fDistance
  lTokenId = fCurrentToken
  lLongitudinal = fLongitudinal
  repeat while lDistance > 0
    lTrackTokenRef = me.GetTokenRef(lTokenId)
    lPercent = 1.0 - lLongitudinal
    lSign = 1
    lTokenLenght = lTrackTokenRef.RoadLength * lPercent
    if lTokenLenght > lDistance then
      lLongitudinal = lLongitudinal + (lSign * (lDistance / lTokenLenght) * lPercent)
      lTargetPosition = me.TokenToWorld(lTokenId, lLongitudinal, fTrasversal)
      return lTargetPosition
    else
      lLongitudinal = 0.0
    end if
    lDistance = lDistance - lTokenLenght
    lTokenId = lTrackTokenRef.next[1]
  end repeat
end

on GetTargetPositionReverseMode me, fCurrentToken, fLongitudinal, fDistance, fTrasversal
  lDistance = fDistance
  lTokenId = fCurrentToken
  lLongitudinal = fLongitudinal
  repeat while lDistance > 0
    lTrackTokenRef = me.GetTokenRef(lTokenId)
    lPercent = lLongitudinal
    lSign = 1
    lTokenLenght = lTrackTokenRef.RoadLength * lPercent
    if lTokenLenght > lDistance then
      lLongitudinal = lLongitudinal - (lSign * (lDistance / lTokenLenght) * lPercent)
      lTargetPosition = me.TokenToWorld(lTokenId, lLongitudinal, fTrasversal)
      return lTargetPosition
    else
      lLongitudinal = 1.0
    end if
    lDistance = lDistance - lTokenLenght
    lTokenId = lTrackTokenRef.Prev[1]
  end repeat
end

on GetBestTrasversal me, fCurrentToken, fLongitudinal, fDistance
  if me.ReverseMode() then
    return me.GetBestTrasversalReverseMode(fCurrentToken, fLongitudinal, fDistance)
  end if
  lInitialDistance = fDistance
  lDistance = fDistance
  lTokenId = fCurrentToken
  lLongitudinal = fLongitudinal
  lVersus = 0
  repeat while lDistance > 0
    lTrackTokenRef = me.GetTokenRef(lTokenId)
    lPercent = 1.0 - lLongitudinal
    lTokenLenght = lTrackTokenRef.RoadLength * lPercent
    lIndexTokenType = lTrackTokenRef.token
    lTokensTypesStructRef = pTokensTypesStruct[lIndexTokenType]
    if lTokensTypesStructRef.type = #curve then
      if (lInitialDistance - lDistance) > pLimitDistanceForBestTrasversal then
        lVersus = lTokensTypesStructRef.Ver
        return pBestTrasversal * lVersus
      else
        return 0.0
      end if
    end if
    lDistance = lDistance - lTokenLenght
    lTokenId = lTrackTokenRef.next[1]
    lLongitudinal = 0.0
  end repeat
  return 0.0
end

on GetBestTrasversalReverseMode me, fCurrentToken, fLongitudinal, fDistance
  lInitialDistance = fDistance
  lDistance = fDistance
  lTokenId = fCurrentToken
  lLongitudinal = fLongitudinal
  lVersus = 0
  repeat while lDistance > 0
    lTrackTokenRef = me.GetTokenRef(lTokenId)
    lPercent = lLongitudinal
    lTokenLenght = lTrackTokenRef.RoadLength * lPercent
    lIndexTokenType = lTrackTokenRef.token
    lTokensTypesStructRef = pTokensTypesStruct[lIndexTokenType]
    if lTokensTypesStructRef.type = #curve then
      if (lInitialDistance - lDistance) > pLimitDistanceForBestTrasversal then
        lVersus = lTokensTypesStructRef.Ver
        return pBestTrasversal * lVersus
      else
        return 0.0
      end if
    end if
    lDistance = lDistance - lTokenLenght
    lTokenId = lTrackTokenRef.Prev[1]
    lLongitudinal = 1.0
  end repeat
  return 0.0
end
