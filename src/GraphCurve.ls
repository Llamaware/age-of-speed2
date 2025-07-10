property pXAxisName, pYAxisName, pXSteps, pYSteps, pXMin, pXMax, pYMin, pYMax, pCurvePoints

on new me, kCurvePoints, kXSteps, kYSteps, kXMin, kXMax, kYMin, kYMax, kXAxisName, kYAxisName
  pCurvePoints = kCurvePoints
  pXSteps = kXSteps
  pYSteps = kYSteps
  pXMin = kXMin
  pXMax = kXMax
  pYMin = kYMin
  pYMax = kYMax
  pXAxisName = kXAxisName
  pYAxisName = kYAxisName
  return me
end

on GetCurvePoints me
  return pCurvePoints
end

on GetXAxisName me
  return pXAxisName
end

on GetYAxisName me
  return pYAxisName
end

on SetCurvePoints me, kCurvePoints
  pCurvePoints = kCurvePoints
end

on SetXAxisName me, kXAxisName
  pXAxisName = kXAxisName
end

on SetYAxisName me, kYAxisName
  pYAxisName = kYAxisName
end

on FindRightPointIdx me, Kx
  repeat with li = 1 to pCurvePoints.count
    if pCurvePoints[li].x > Kx then
      return li
    end if
  end repeat
  return pCurvePoints.count + 1
end

on GetValue me, Kx
  if pCurvePoints.count = 0 then
    return 0.0
  end if
  lRightPointIdx = me.FindRightPointIdx(Kx)
  if lRightPointIdx = 1 then
    return pCurvePoints[1].y
  else
    if lRightPointIdx > pCurvePoints.count then
      return pCurvePoints[pCurvePoints.count].y
    end if
  end if
  lRightPoint = pCurvePoints[lRightPointIdx]
  lLeftPoint = pCurvePoints[lRightPointIdx - 1]
  ldX = lRightPoint.x - lLeftPoint.x
  ldY = lRightPoint.y - lLeftPoint.y
  lValue = lLeftPoint.y + ((Kx - lLeftPoint.x) * ldY / ldX)
  return lValue
end
