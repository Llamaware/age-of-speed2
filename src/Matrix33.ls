property pColumns

on new me, kC1, kC2, kC3
  if not voidp(kC1) and not voidp(kC2) and not voidp(kC3) then
    pColumns = [kC1, kC2, kC3]
  else
    pColumns = [vector(1.0, 0.0, 0.0), vector(0.0, 1.0, 0.0), vector(0.0, 0.0, 1.0)]
  end if
  return me
end

on GetColumn me, kIdx
  return pColumns[kIdx]
end

on SetColumn me, kIdx, kVector
  pColumns[kIdx] = kVector
end

on Transpose me
  lTmp = pColumns[1].y
  pColumns[1].y = pColumns[2].x
  pColumns[2].x = lTmp
  lTmp = pColumns[1].z
  pColumns[1].z = pColumns[3].x
  pColumns[3].x = lTmp
  lTmp = pColumns[2].z
  pColumns[2].z = pColumns[3].y
  pColumns[3].y = lTmp
end

on Det me
  return pColumns[1].cross(pColumns[2]).dot(pColumns[3])
end

on invert me
  lDet = me.Det()
  assert(abs(lDet) > 0.00001, "Matrix33.invert: determinant = 0")
  lOldC = [pColumns[1].duplicate(), pColumns[2].duplicate(), pColumns[3].duplicate()]
  me.SetColumn(1, lOldC[2].cross(lOldC[3]))
  me.SetColumn(2, lOldC[3].cross(lOldC[1]))
  me.SetColumn(3, lOldC[1].cross(lOldC[2]))
  me.DivByScalar(lDet)
  me.Transpose()
end

on inverse me
  lDet = me.Det()
  assert(abs(lDet) > 0.00001, "Matrix33.invert: determinant = 0")
  lRet = script("Matrix33").new()
  lRet.SetColumn(1, pColumns[2].cross(pColumns[3]))
  lRet.SetColumn(2, pColumns[3].cross(pColumns[1]))
  lRet.SetColumn(3, pColumns[1].cross(pColumns[2]))
  lRet.DivByScalar(lDet)
  lRet.Transpose()
  return lRet
end

on MulByScalar me, kScalar
  pColumns[1] = pColumns[1] * kScalar
  pColumns[2] = pColumns[2] * kScalar
  pColumns[3] = pColumns[3] * kScalar
end

on DivByScalar me, kScalar
  me.MulByScalar(1.0 / kScalar)
end

on MulByMatrix me, kMatrix
  lOldC = [pColumns[1].duplicate(), pColumns[2].duplicate(), pColumns[3].duplicate()]
  pColumns[1] = (lOldC[1] * kMatrix.GetColumn(1).x) + (lOldC[2] * kMatrix.GetColumn(1).y) + (lOldC[3] * kMatrix.GetColumn(1).z)
  pColumns[2] = (lOldC[1] * kMatrix.GetColumn(2).x) + (lOldC[2] * kMatrix.GetColumn(2).y) + (lOldC[3] * kMatrix.GetColumn(2).z)
  pColumns[3] = (lOldC[1] * kMatrix.GetColumn(3).x) + (lOldC[2] * kMatrix.GetColumn(3).y) + (lOldC[3] * kMatrix.GetColumn(3).z)
end

on MulByVector me, kVector
  return vector(pColumns[1].dot(kVector), pColumns[2].dot(kVector), pColumns[3].dot(kVector))
end
