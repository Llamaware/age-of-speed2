global gGame

on InitializeDistanceFromStart kStartPos
  lGetTokenResult = gGame.GetTokenManager().GetTokenUnOptimized(0, kStartPos.x, kStartPos.y, vector(kStartPos.x, kStartPos.y, 0.0), 0.0, 0.0)
  lStartToken = lGetTokenResult[1]
  lTokenTangent = lGetTokenResult[3]
  lLong = lGetTokenResult[4]
  lTrackTokens = gGame.GetTokenManager().GetTrackTokens()
  lStartTrackToken = lTrackTokens[lStartToken]
  lStartOffset = -lLong * lStartTrackToken.RoadLength
  lStartTrackToken.addProp(#DistanceFromStart, lStartOffset)
  CalculateDistanceFromStart(lTrackTokens, lStartTrackToken, lStartToken, 1, 1, 1)
  lPrevStartToken = lTrackTokens[lStartTrackToken.Prev[1]]
  lDistanceFromStart = lPrevStartToken.DistanceFromStart + lPrevStartToken.RoadLength
  lStartTrackToken.DistanceFromStart = lDistanceFromStart
  gGame.SetTrackLength(lDistanceFromStart - lStartOffset)
  lOrthoDir = vector(-lTokenTangent.y, lTokenTangent.x, 0)
  lPosA = kStartPos + (lOrthoDir * 5000)
  lPosB = kStartPos - (lOrthoDir * 5000)
  gGame.GetGameplay().InitializeFinishLine(lPosA, lPosB)
end

on CalculateDistanceFromStart fTrackTokens, fTrackToken, fStartTokenId, fInitialBranch, fBranch, fMaxBranch
  lDistanceFromStart = fTrackToken.DistanceFromStart + fTrackToken.RoadLength
  lLinksCount = fTrackToken.next.count
  if lLinksCount > 1 then
    lTokenIndex = fTrackToken.index
    lNewMaxBranch = fMaxBranch + lLinksCount
    repeat with li = 1 to lLinksCount
      lBranch = fMaxBranch + li
      lCurrentToken = fTrackTokens[fTrackToken.next[li]]
      lCurrentToken.addProp(#DistanceFromStart, lDistanceFromStart)
      lNewMaxBranch = CalculateDistanceFromStart(fTrackTokens, lCurrentToken, fStartTokenId, fBranch, lBranch, lNewMaxBranch)
    end repeat
    return lNewMaxBranch
  else
    lIndexCurrentToken = fTrackToken.next[1]
    if lIndexCurrentToken <> fStartTokenId then
      lCurrentToken = fTrackTokens[lIndexCurrentToken]
      if lCurrentToken.findPos(#Rejoin) <> VOID then
        lCurrentToken.Rejoin = lCurrentToken.Rejoin - 1
        if lCurrentToken.findPos(#DistanceFromStart) = VOID then
          lCurrentToken.addProp(#DistanceFromStart, lDistanceFromStart)
        else
          if lCurrentToken.DistanceFromStart < lDistanceFromStart then
            lCurrentToken.DistanceFromStart = lDistanceFromStart
          end if
        end if
        if lCurrentToken.Rejoin = 0 then
          return CalculateDistanceFromStart(fTrackTokens, lCurrentToken, fStartTokenId, fInitialBranch, fInitialBranch, fMaxBranch)
        else
          return fMaxBranch
        end if
      else
        lCurrentToken.addProp(#DistanceFromStart, lDistanceFromStart)
      end if
      return CalculateDistanceFromStart(fTrackTokens, lCurrentToken, fStartTokenId, fInitialBranch, fBranch, fMaxBranch)
    else
      return fMaxBranch
    end if
  end if
end

on PutDistancesFromStart
  lTrackToken = gGame.GetTokenManager().GetTrackTokens()
  put "------------------------------"
  repeat with li = 1 to lTrackToken.count
    put li & " Length: " & lTrackToken[li].RoadLength & " - DistanceFromStart: " & lTrackToken[li].DistanceFromStart
  end repeat
  put "------------------------------"
end
