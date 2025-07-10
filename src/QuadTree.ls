property pMaxDepth, pSize, pScaleX, pScaleY, pNodes, pOffset

on BitShiftLeft me, n, s
  return integer(n * integer(power(2, s)))
end

on BitShiftRight me, n, s
  return integer(n / integer(power(2, s)))
end

on new me, kMaxDepth, kWorldMin, kWorldMax
  pMaxDepth = kMaxDepth
  lWorldWidth = kWorldMax.x - kWorldMin.x
  lWorldHeight = kWorldMax.y - kWorldMin.y
  pSize = me.BitShiftLeft(1, pMaxDepth - 1)
  pScaleX = float(pSize) / lWorldWidth
  pScaleY = float(pSize) / lWorldHeight
  pNodes = []
  repeat with li = 0 to pMaxDepth - 1
    pNodes.append([])
    lChildren = pNodes[li + 1]
    lNumChildren = me.BitShiftLeft(1, 2 * li)
    repeat with lj = 1 to lNumChildren
      lChildren.append([])
    end repeat
  end repeat
  pOffset = kWorldMin
  put "quadtree info: (" & lWorldWidth & ", " & lWorldHeight & ") (" & pScaleX & ", " & pScaleY & ") " & pSize & " offset: " & pOffset
  return me
end

on GetCell me, kPos, kRadius
  lLeft = kPos.x - kRadius - pOffset.x
  lRight = kPos.x + kRadius - pOffset.x
  lTop = kPos.y - kRadius - pOffset.y
  lBottom = kPos.y + kRadius - pOffset.y
  lX1 = integer(lLeft * pScaleX)
  lY1 = integer(lTop * pScaleY)
  if lX1 < 0 then
    lX1 = 0
  end if
  if lY1 < 0 then
    lY1 = 0
  end if
  if lX1 >= pSize then
    lX1 = pSize - 1
  end if
  if lY1 >= pSize then
    lY1 = pSize - 1
  end if
  lX2 = integer(lRight * pScaleX)
  lY2 = integer(lBottom * pScaleY)
  if lX2 < 0 then
    lX2 = 0
  end if
  if lY2 < 0 then
    lY2 = 0
  end if
  if lX2 >= pSize then
    lX2 = pSize - 1
  end if
  if lY2 >= pSize then
    lY2 = pSize - 1
  end if
  lResX = bitXor(lX1, lX2)
  lResY = bitXor(lY1, lY2)
  lShiftCount = 0
  lDepth = pMaxDepth
  repeat while (lResX + lResY) > 0
    lResX = integer(lResX / 2)
    lResY = integer(lResY / 2)
    lDepth = lDepth - 1
    lShiftCount = lShiftCount + 1
  end repeat
  return [#x: lX1, #y: lY1, #depth: lDepth, #shiftCount: lShiftCount]
end

on GetNode me, kCell
  lChildren = pNodes[kCell.depth]
  lA = me.BitShiftRight(kCell.y, kCell.shiftCount)
  lA = me.BitShiftLeft(lA, kCell.depth - 1)
  lB = me.BitShiftRight(kCell.x, kCell.shiftCount)
  return lChildren[lA + lB + 1]
end
