property ancestor
global gGame

on new me
  me.ancestor = script("Token Manager").new()
  return me
end

on InitializeTrackTokens me
  l3D = gGame.Get3D()
  repeat with i = 1 to me.ancestor.pTrackTokens.count
    l_TrackToken = me.ancestor.pTrackTokens[i]
    lMdl = l3D.model(l_TrackToken.ModelName)
    l_TrackToken.addProp(#model, lMdl)
    l_TrackToken.addProp(#Position3D, lMdl.transform.position)
  end repeat
  repeat with i = 1 to me.ancestor.pTrackTokens.count
    l_TrackToken = me.ancestor.pTrackTokens[i]
    l_NextTrackToken = me.ancestor.pTrackTokens[l_TrackToken.next[1]]
    l_EndPosition3D = l_NextTrackToken.Position3D
    l_TrackToken.addProp(#EndPosition3D, l_EndPosition3D)
    l_Direction = l_EndPosition3D - l_TrackToken.Position3D
    l_Direction.normalize()
    l_TrackToken.addProp(#Direction3D, l_Direction)
    l_TokenType = me.ancestor.pTokensTypesStruct[l_TrackToken.token]
    lUp = l_TrackToken.model.transform.zAxis
    if l_TokenType.type <> #loop then
      lUp = l_TrackToken.model.transform.xAxis.cross(l_Direction)
      lUp.normalize()
    end if
    l_TrackToken2DPosition = l_TrackToken.Position3D.duplicate()
    l_TrackToken2DPosition.z = 0.0
    l_TrackToken2DEndPosition = l_TrackToken.EndPosition3D.duplicate()
    l_TrackToken2DEndPosition.z = 0.0
    l_TrackToken.addProp(#position, l_TrackToken2DPosition)
    l_TrackToken.addProp(#index, symbol("t" & i))
    l_TrackToken.addProp(#normal, lUp)
    if l_TokenType.type = #loop then
      l_TrackToken.addProp(#EndPosition, l_TrackToken2DEndPosition)
      l_TrackToken.addProp(#length, (l_TrackToken2DEndPosition - l_TrackToken2DPosition).magnitude)
    else
      if l_TokenType.type = #rect then
        l_TrackToken.addProp(#EndPosition, l_TrackToken2DEndPosition)
        l_TrackToken.addProp(#length, (l_TrackToken2DEndPosition - l_TrackToken2DPosition).magnitude)
      else
        if l_TokenType.type = #curve then
          l_CenterPosition = vector(-l_TokenType.radius * l_TokenType.Ver, 0.0, 0.0)
          l_TrackTokenTrans = l_TrackToken.model.transform.duplicate()
          l_TrackTokenTrans.position = vector(0.0, 0.0, 0.0)
          l_TrackTokenTrans.scale = vector(1.0, 1.0, 1.0)
          l_CenterPosition = vector(l_TrackToken.position.x, l_TrackToken.position.y, l_TrackToken.position.z) + (l_TrackTokenTrans * l_CenterPosition)
          l_TrackToken.addProp(#center, l_CenterPosition)
        else
          if l_TokenType.type = #rotary then
            l_CenterPosition = vector(0.0, l_TokenType.radius, 0.0)
            l_TrackTokenTrans = l_TrackToken.model.transform.duplicate()
            l_TrackTokenTrans.position = vector(0.0, 0.0, 0.0)
            l_TrackTokenTrans.scale = vector(1.0, 1.0, 1.0)
            l_CenterPosition = vector(l_TrackToken.position.x, l_TrackToken.position.y, l_TrackToken.position.z) + (l_TrackTokenTrans * l_CenterPosition)
            l_TrackToken.addProp(#center, l_CenterPosition)
          else
            if l_TokenType.type = #cross then
              l_EndPosition = vector(0.0, l_TokenType.Len, 0.0)
              l_TrackTokenTrans = l_TrackToken.model.transform.duplicate()
              l_TrackTokenTrans.position = vector(0.0, 0.0, 0.0)
              l_TrackTokenTrans.scale = vector(1.0, 1.0, 1.0)
              l_EndPosition = vector(l_TrackToken.position.x, l_TrackToken.position.y, l_TrackToken.position.z) + (l_TrackTokenTrans * l_EndPosition)
              l_TrackToken.addProp(#EndPosition, l_EndPosition)
              l_TrackToken.addProp(#length, (l_TrackToken.EndPosition - l_TrackToken.position).magnitude)
            end if
          end if
        end if
      end if
    end if
    if (l_TokenType.type = #rect) or (l_TokenType.type = #loop) then
      l_TrackToken.addProp(#RoadLength, l_TokenType.Len)
    else
      if l_TokenType.type = #curve then
        lArcLen = l_TokenType.Arc * l_TokenType.radius
        l_TrackToken.addProp(#RoadLength, lArcLen)
      end if
    end if
    if (l_TrackToken.token = "d2jump") or (l_TrackToken.token = "d3jump") then
      l_TrackToken.model.shader.blend = 0
    end if
  end repeat
  repeat with i = 1 to me.ancestor.pTrackTokens.count
    l_TrackToken = me.ancestor.pTrackTokens[i]
    l_NextTrackToken = me.ancestor.pTrackTokens[l_TrackToken.next[1]]
    lEndTokenUp = l_NextTrackToken.normal
    if l_TrackToken.token = "twist" then
      lMiddleTokenUp = -l_TrackToken.model.transform.xAxis
    else
      lMiddleTokenUp = (l_TrackToken.normal + lEndTokenUp) * 0.5
    end if
    lMiddleTokenUp.normalize()
    l_TrackToken.addProp(#MiddleNormal, lMiddleTokenUp)
    l_TrackToken.addProp(#EndNormal, lEndTokenUp)
    l_TrackToken.addProp(#CheckLineList, [:])
  end repeat
end

on SetTokenTypes me, fTokenTypes, fTokenTypeSetupCallback
  me.ancestor.pTokensTypesStruct = fTokenTypes
  repeat with i = 1 to me.ancestor.pTokensTypesStruct.count
    lTokenType = me.ancestor.pTokensTypesStruct[i]
    me.SetupTokenType(lTokenType)
  end repeat
end

on SetupTokenType me, fTokenType
  lRightLimit = 1.0
  lLeftLimit = -1.0
  l_TokenType = fTokenType
  if voidp(l_TokenType.findPos(#LeftLimit)) then
    l_TokenType.addProp(#LeftLimit, lLeftLimit)
  end if
  if voidp(l_TokenType.findPos(#RightLimit)) then
    l_TokenType.addProp(#RightLimit, lRightLimit)
  end if
  if voidp(l_TokenType.findPos(#ConstantWidth)) then
    l_TokenType.addProp(#ConstantWidth, 1)
  end if
end

on SetTrackTokens me, kTrackTokens
  me.ancestor.pTrackTokens = kTrackTokens
  repeat with i = 1 to me.ancestor.pTrackTokens.count
    lTrackToken = me.ancestor.pTrackTokens[i]
    me.SetupToken(lTrackToken)
  end repeat
end

on SetupToken me, fToken
end

on GetTokenUp me, kTokenId, kLongitudinal
  l_TrackToken = me.ancestor.pTrackTokens[kTokenId]
  if kLongitudinal < 0.5 then
    lStartTokenUp = l_TrackToken.normal
    lMiddleTokenUp = l_TrackToken.MiddleNormal
    lTokenUp = lStartTokenUp + ((lMiddleTokenUp - lStartTokenUp) * kLongitudinal * 2.0)
  else
    lMiddleTokenUp = l_TrackToken.MiddleNormal
    lEndTokenUp = l_TrackToken.EndNormal
    lTokenUp = lMiddleTokenUp + ((lEndTokenUp - lMiddleTokenUp) * (kLongitudinal - 0.5) * 2.0)
  end if
  lTokenUp.normalize()
  return lTokenUp
end

on GetTokenRoadLength me, fCurrentToken
  return me.ancestor.pTrackTokens[fCurrentToken].RoadLength
end

on CheckToken me, tokenindex, px, py, kWorldPos, p_WidthOffset, p_LongitudinalGap, fCrossRoadStruct
  l_TrackToken = me.ancestor.pTrackTokens[tokenindex]
  return me.CheckTokenByRef(l_TrackToken, px, py, kWorldPos, p_WidthOffset, p_LongitudinalGap, fCrossRoadStruct)
end

on GetTokenUnOptimized me, CurrentToken, px, py, kWorldPos, p_WidthOffset, p_LongitudinalGap, fWithTokenLimit
  if voidp(fWithTokenLimit) then
    fWithTokenLimit = 0
  end if
  if CurrentToken > 0 then
    CheckResult = me.CheckToken(CurrentToken, px, py, kWorldPos, p_WidthOffset, p_LongitudinalGap, fWithTokenLimit)
    if CheckResult[1] <> 0 then
      return CheckResult
    end if
    l_TrackToken = me.GetTokenRef(CurrentToken)
    lTotLinks = l_TrackToken.next.count
    repeat with i = 1 to lTotLinks
      if not fWithTokenLimit then
        CheckResult = me.CheckTokenByRef(me.GetTokenRef(l_TrackToken.next[i]), px, py, kWorldPos, p_WidthOffset, p_LongitudinalGap, fWithTokenLimit)
        if CheckResult[1] <> 0 then
          return CheckResult
        end if
      end if
    end repeat
    lTotLinks = l_TrackToken.Prev.count
    repeat with i = 1 to lTotLinks
      if not fWithTokenLimit then
        CheckResult = me.CheckTokenByRef(me.GetTokenRef(l_TrackToken.Prev[i]), px, py, kWorldPos, p_WidthOffset, p_LongitudinalGap, fWithTokenLimit)
        if CheckResult[1] <> 0 then
          return CheckResult
        end if
      end if
    end repeat
  end if
  repeat with i = 1 to me.ancestor.pTrackTokens.count
    CheckResult = me.CheckTokenByRef(me.GetTokenRef(i), px, py, kWorldPos, p_WidthOffset, p_LongitudinalGap, fWithTokenLimit)
    if CheckResult[1] <> 0 then
      return CheckResult
    end if
  end repeat
  return [0, 0.0, 0.0, 0.0, 0.0]
end

on GetDistanceFromStart me, fCurrentToken
  return me.GetTokenRef(fCurrentToken).DistanceFromStart
end

on GetBestTrasversal me, fCurrentToken, fLongitudinal, fDistancePoint
  lInitialDistance = fDistancePoint
  lDistance = fDistancePoint
  lTokenId = fCurrentToken
  lLongitudinal = fLongitudinal
  lCurve = 0
  lVersus = 0
  repeat while lDistance > 0
    lTrackTokenRef = me.GetTokenRef(lTokenId)
    lPercent = 1.0 - lLongitudinal
    lTokenLenght = lTrackTokenRef.RoadLength * lPercent
    lIndexTokenType = lTrackTokenRef.token
    lTokensTypesStructRef = me.ancestor.pTokensTypesStruct[lIndexTokenType]
    if lTokensTypesStructRef.type = #curve then
      lVersus = lTokensTypesStructRef.Ver
      if (lInitialDistance - lDistance) > 2000 then
        return 0.59999999999999998 * lVersus
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

on GetTargetPosition me, kCurrentToken, kLongitudinal, kDistancePoint, kTrasversal, kNextTokenIdx
  lDistance = kDistancePoint
  lTokenId = kCurrentToken
  lLongitudinal = kLongitudinal
  repeat while lDistance > 0
    lTrackTokenRef = me.GetTokenRef(lTokenId)
    lPercent = 1.0 - lLongitudinal
    lTokenLenght = lTrackTokenRef.RoadLength * lPercent
    if lTokenLenght > lDistance then
      lLongitudinal = lLongitudinal + (lDistance / lTokenLenght * lPercent)
      lTargetPosition = me.TokenToWorld3D(lTokenId, lLongitudinal, kTrasversal)
      return lTargetPosition
    else
      lLongitudinal = 0.0
    end if
    lDistance = lDistance - lTokenLenght
    if not voidp(kNextTokenIdx) then
      if lTrackTokenRef.next.count < kNextTokenIdx then
        lTokenId = lTrackTokenRef.next[lTrackTokenRef.next.count]
      else
        lTokenId = lTrackTokenRef.next[kNextTokenIdx]
      end if
      next repeat
    end if
    lTokenId = lTrackTokenRef.next[1]
  end repeat
end

on TokenToWorld3D me, p_TokenIndex, p_Longitudinal, p_Trasversal
  l_TrackToken = me.ancestor.pTrackTokens[p_TokenIndex]
  return me.TokenToWorld3DByRef(l_TrackToken, p_Longitudinal, p_Trasversal)
end

on TokenToWorld3DByRef me, p_TrackToken, p_Longitudinal, p_Trasversal
  l_TokenType = me.ancestor.pTokensTypesStruct[p_TrackToken.token]
  if (l_TokenType.type = #rect) or (l_TokenType.type = #cross) or (l_TokenType.type = #loop) then
    l_TokenForward = p_TrackToken.EndPosition3D - p_TrackToken.Position3D
    l_Position = p_TrackToken.Position3D + (l_TokenForward * p_Longitudinal)
    l_TokenForwardNorm = p_TrackToken.Direction3D
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
    l_Position.z = p_TrackToken.Position3D.z + ((p_TrackToken.EndPosition3D.z - p_TrackToken.Position3D.z) * p_Longitudinal)
    return l_Position
  end if
  return vector(0.0, 0.0, 0.0)
end

on TokenToWorldByRef me, p_TrackToken, p_Longitudinal, p_Trasversal
  l_TokenType = me.ancestor.pTokensTypesStruct[p_TrackToken.token]
  if (l_TokenType.type = #rect) or (l_TokenType.type = #cross) or (l_TokenType.type = #loop) then
    l_TokenForward = p_TrackToken.EndPosition - p_TrackToken.position
    l_Position = p_TrackToken.position + (l_TokenForward * p_Longitudinal)
    l_TokenForwardNorm = l_TokenForward
    l_TokenForwardNorm.normalize()
    l_TokenLateralNorm = vector(-l_TokenForwardNorm.y, l_TokenForwardNorm.x, 0.0)
    lWidth = l_TokenType.width
    if not l_TokenType.ConstantWidth then
      lWidth = lWidth + ((l_TokenType.EndWidth - lWidth) * p_Longitudinal)
    end if
    l_Position = l_Position - (l_TokenLateralNorm * lWidth * 0.5 * p_Trasversal)
    return l_Position
  end if
  if l_TokenType.type = #curve then
    lWidth = l_TokenType.width
    if not l_TokenType.ConstantWidth then
      lWidth = lWidth + ((l_TokenType.EndWidth - lWidth) * p_Longitudinal)
    end if
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

on CheckTokenByRef me, l_TrackToken, px, py, pWorldPos, p_WidthOffset, p_LongitudinalGap, fCrossRoadStruct
  l_TokenType = me.ancestor.pTokensTypesStruct[l_TrackToken.token]
  l_QueryResult = [0, 0.0, 0.0, 0.0, 0.0]
  if (l_TokenType.type = #rect) or (l_TokenType.type = #loop) or (l_TokenType.type = #cross) then
    l_Position = vector(px, py, 0.0)
    if l_TokenType.type = #loop then
      lStartPos3d = l_TrackToken.Position3D
      lEndPosition3d = l_TrackToken.EndPosition3D
      lPlaneNormal = l_TrackToken.model.transform.xAxis
      lPlane = me.GetPlane(lPlaneNormal, lStartPos3d)
      lEndPointProj = me.GetSignedPointPlaneProjection(lEndPosition3d, lPlane)
      lStartSegment = lStartPos3d.duplicate()
      lStartSegment.z = 0
      lEndSegment = lEndPointProj.duplicate()
      lEndSegment.z = 0
      l_Result = GetNearestPointOnLineSeg(lStartSegment, lEndSegment, l_Position)
      lDist = (l_Result - lStartSegment).magnitude
      ltokenlength = (lEndSegment - lStartSegment).magnitude
      lPerc = lDist / ltokenlength
      lSkewedTokenEnd = l_TrackToken.EndPosition3D.duplicate()
      lSkewedTokenEnd.z = 0
      l_Result = lStartSegment + ((lSkewedTokenEnd - lStartSegment) * lPerc)
    else
      l_Result = GetNearestPointOnLineSeg(l_TrackToken.position, l_TrackToken.EndPosition, l_Position)
    end if
    if not voidp(l_Result) then
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
    lTrackTokenRef = me.ancestor.pTrackTokens[l_QueryResult[1]]
    lLongitudinal = l_QueryResult[4]
    lZ = lTrackTokenRef.Position3D.z + ((lTrackTokenRef.EndPosition3D.z - lTrackTokenRef.Position3D.z) * lLongitudinal)
    if abs(lZ - pWorldPos.z) > 30000 then
      return [0, 0.0, 0.0, 0.0, 0.0]
    end if
  end if
  return l_QueryResult
end

on GetMinZDistance me, kTrackToken, kPos
  return integer(min(abs(kTrackToken.Position3D.z - kPos.z), abs(kTrackToken.EndPosition3D.z - kPos.z)))
end

on GetProjection me, kTrackToken, kPos
  lProjection = GetNearestPointOnLineSeg(kTrackToken.Position3D, kTrackToken.EndPosition3D, kPos)
end

on getToken me, CurrentToken, px, py, kWorldPos, p_WidthOffset, p_LongitudinalGap, fWithTokenLimit
  if CurrentToken > 0 then
    lCheckResult = []
    l_TrackToken = me.ancestor.pTrackTokens[CurrentToken]
    lNextTokenId = l_TrackToken.next[1]
    lPrevTokenId = l_TrackToken.Prev[1]
    lNextToken = me.ancestor.pTrackTokens[lNextTokenId]
    lPrevToken = me.ancestor.pTrackTokens[lPrevTokenId]
    lTokenList = [l_TrackToken, lNextToken, lPrevToken]
    repeat with i = 1 to lTokenList.count
      lToken = lTokenList[i]
      CheckResult = me.CheckToken(lTokenList[i].index, px, py, kWorldPos, p_WidthOffset, p_LongitudinalGap)
      if CheckResult[1] <> 0 then
        lCheckResult.add([#tokenIdx: lTokenList[i].index, #token: lToken, #CheckResult: CheckResult])
      end if
    end repeat
    if lCheckResult.count = 0 then
      return [0, 0.0, 0.0, 0.0, 0.0]
    end if
    if lCheckResult.count = 1 then
      return lCheckResult[1].CheckResult
    end if
    l3dCheckResultsList = []
    repeat with i = 1 to lCheckResult.count
      lToken = lCheckResult[i].token
      l_Position = kWorldPos
      lStartPos = lToken.Position3D
      lEndPos = lToken.EndPosition3D
      lLengh3D = (lEndPos - lStartPos).magnitude
      lLongitudinal = lCheckResult[i].CheckResult[4]
      lPointOnToken = lStartPos + (lToken.Direction3D * lLongitudinal * lLengh3D)
      l3dCheckResultsList.add([#CheckResult: lCheckResult[i].CheckResult, #ProjectedPoint: lPointOnToken])
    end repeat
    if l3dCheckResultsList.count = 1 then
      return l3dCheckResultsList[1].CheckResult
    end if
    lProjPoint = l3dCheckResultsList[1].ProjectedPoint
    lProjPointZPlayer = lProjPoint.duplicate()
    lProjPointZPlayer.z = kWorldPos.z
    lMinDistance = (lProjPoint - lProjPointZPlayer).magnitude
    lFinalResult = [#tokenCheckRes: l3dCheckResultsList[1].CheckResult, #distance: lMinDistance]
    repeat with residx = 2 to l3dCheckResultsList.count
      lProjPoint = l3dCheckResultsList[residx].ProjectedPoint
      lProjPointZPlayer = lProjPoint.duplicate()
      lProjPointZPlayer.z = kWorldPos.z
      lDistance = (lProjPoint - lProjPointZPlayer).magnitude
      if lDistance < lFinalResult.distance then
        lFinalResult = [#tokenCheckRes: l3dCheckResultsList[residx].CheckResult, #distance: lDistance]
      end if
    end repeat
    return lFinalResult.tokenCheckRes
  end if
  return [0, 0.0, 0.0, 0.0, 0.0]
  if CurrentToken > 0 then
    l_TrackToken = me.ancestor.pTrackTokens[CurrentToken]
    lNextTokenId = l_TrackToken.next[1]
    lPrevTokenId = l_TrackToken.Prev[1]
    lNextToken = me.ancestor.pTrackTokens[lNextTokenId]
    lPrevToken = me.ancestor.pTrackTokens[lPrevTokenId]
    l_TrackTokenProj = me.GetProjection(l_TrackToken, kWorldPos)
    if not voidp(l_TrackTokenProj) then
      l_TrackTokenProjDistance = (kWorldPos - l_TrackTokenProj).magnitude
    else
      l_TrackTokenProj = kWorldPos
      l_TrackTokenProjDistance = 100000000.0
    end if
    lNextTokenZProj = me.GetProjection(lNextToken, kWorldPos)
    if not voidp(lNextTokenZProj) then
      lNextTokenZProjDistance = (kWorldPos - lNextTokenZProj).magnitude
    else
      lNextTokenZProj = kWorldPos
      lNextTokenZProjDistance = 100000000.0
    end if
    lPrevTokenZProj = me.GetProjection(lPrevToken, kWorldPos)
    if not voidp(lPrevTokenZProj) then
      lPrevTokenZProjDistance = (kWorldPos - lPrevTokenZProj).magnitude
    else
      lPrevTokenZProj = kWorldPos
      lPrevTokenZProjDistance = 100000000.0
    end if
    lTokenList = [:]
    lTokenList.addProp(lNextTokenZProj, [l_TrackTokenProj, lNextTokenId])
    lTokenList.addProp(l_TrackTokenProj, [lNextTokenZProj, CurrentToken])
    lTokenList.addProp(lPrevTokenZProj, [lPrevTokenZProj, lPrevTokenId])
    lTokenList.sort()
    repeat with lTokenRef in lTokenList
      lPos = lTokenRef[1]
      CheckResult = me.CheckToken(lTokenRef[2], lPos.x, lPos.y, lPos, p_WidthOffset, p_LongitudinalGap, fWithTokenLimit)
      if CheckResult[1] <> 0 then
        return CheckResult
      end if
    end repeat
  end if
  return [0, 0.0, 0.0, 0.0, 0.0]
end

on GetTokenWithExpansion me, CurrentToken, px, py, kWorldPos
  lLongitudinalGap = me.ancestor.pLongitudinalGap
  lTrasversalGap = me.ancestor.pExpansionWidth
  l_TrackToken = me.ancestor.pTrackTokens[CurrentToken]
  lResult = me.CheckTokenByRef(l_TrackToken, px, py, kWorldPos, lTrasversalGap, lLongitudinalGap)
  if lResult[1] <> 0 then
    return lResult
  else
    lCurrentTrackToken = l_TrackToken
    lNextList = lCurrentTrackToken.next
    repeat with lj = 1 to lNextList.count
      lTokenToCheck = lNextList[lj]
      l_TrackToken = me.pTrackTokens[lTokenToCheck]
      lResult = me.CheckTokenByRef(l_TrackToken, px, py, kWorldPos, lTrasversalGap, lLongitudinalGap)
      if lResult[1] <> 0 then
        return lResult
      end if
    end repeat
    lPrevList = lCurrentTrackToken.Prev
    repeat with lj = 1 to lPrevList.count
      lTokenToCheck = lPrevList[lj]
      l_TrackToken = me.ancestor.pTrackTokens[lTokenToCheck]
      lResult = me.CheckTokenByRef(l_TrackToken, px, py, kWorldPos, lTrasversalGap, lLongitudinalGap)
      if lResult[1] <> 0 then
        return lResult
      end if
    end repeat
  end if
  return [0, 0.0, 0.0, 0.0, 0.0]
end

on GetTrackPos me, kWorldPos
  lRes = me.GetTokenUnOptimized(0, kWorldPos.x, kWorldPos.y, kWorldPos, 0.0, 0.0)
  lTokenId = lRes[1]
  lLongitudinal = lRes[4]
  lTrackPos = me.GetDistanceFromStart(lTokenId) + (me.GetTokenRoadLength(lTokenId) * lLongitudinal)
  if lTrackPos >= gGame.GetTrackLength() then
    lTrackPos = lTrackPos - gGame.GetTrackLength()
  end if
  return lTrackPos
end

on GetPlane me, n, P
  N_norm = n.duplicate()
  N_norm.normalize()
  return [#normal: N_norm, #point: P]
end

on GetPlaneByPoints me, v0, v1, v2
  l_a = v1 - v0
  l_b = v2 - v0
  l_cross = l_a.cross(l_b)
  l_cross.normalize()
  return [#normal: l_cross, #point: v0]
end

on GetSignedDistancePointPlane me, q, fPlane
  d = -fPlane.point.dot(fPlane.normal)
  l_Distance = q.dot(fPlane.normal) + d
  return l_Distance
end

on GetSignedPointPlaneProjection me, P, fPlane
  l_dist = me.GetSignedDistancePointPlane(P, fPlane)
  if l_dist = 0 then
    return P
  end if
  P_Proj = P - (fPlane.normal * l_dist)
  return P_Proj
end
