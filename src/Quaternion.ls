property v, w

on new me, kV, kW
  if voidp(kV) or voidp(kW) then
    v = vector(0.0, 0.0, 0.0)
    w = 1.0
  else
    v = kV.duplicate()
    w = kW
  end if
  return me
end

on MulByScalar me, kScalar
  v = v * kScalar
  w = w * kScalar
end

on DivByScalar me, kScalar
  me.MulByScalar(1.0 / kScalar)
end

on SquareMagnitude me
  return v.dot(v) + (w * w)
end

on magnitude me
  return sqrt(me.SquareMagnitude())
end

on normalize me
  lMag = me.magnitude()
  if lMag > 0.0000001 then
    me.DivByScalar(lMag)
  end if
end

on invert me
  v = vector(-v.x, -v.y, -v.z)
end

on inverse me
  return script("Quaternion").new(vector(-v.x, -v.y, -v.z), w)
end

on Sum me, kQuat
  v = v + kQuat.v
  w = w + kQuat.w
end

on Sub me, kQuat
  v = v - kQuat.v
  w = w - kQuat.w
end

on MulByQuat me, kQuat
  newV = (v * kQuat.w) + (kQuat.v * w) + v.cross(kQuat.v)
  newW = (w * kQuat.w) - v.dot(kQuat.v)
  v = newV
  w = newW
end

on ToMatrix me
  xx = v.x * v.x
  xy = v.x * v.y
  xz = v.x * v.z
  xw = v.x * w
  yy = v.y * v.y
  yz = v.y * v.z
  yw = v.y * w
  zz = v.z * v.z
  zw = v.z * w
  lC0 = vector(0, 0, 0)
  lC1 = vector(0, 0, 0)
  lC2 = vector(0, 0, 0)
  lC0.x = 1.0 - (2.0 * (yy + zz))
  lC1.x = 2.0 * (xy - zw)
  lC2.x = 2.0 * (xz + yw)
  lC0.y = 2.0 * (xy + zw)
  lC1.y = 1.0 - (2.0 * (xx + zz))
  lC2.y = 2.0 * (yz - xw)
  lC0.z = 2.0 * (xz - yw)
  lC1.z = 2.0 * (yz + xw)
  lC2.z = 1.0 - (2.0 * (xx + yy))
  return script("Matrix33").new(lC0, lC1, lC2)
end

on ToSW3dMatrix me, kPosition
  xx = v.x * v.x
  xy = v.x * v.y
  xz = v.x * v.z
  xw = v.x * w
  yy = v.y * v.y
  yz = v.y * v.z
  yw = v.y * w
  zz = v.z * v.z
  zw = v.z * w
  t = transform()
  t[1] = 1.0 - (2.0 * (yy + zz))
  t[2] = 2.0 * (xy - zw)
  t[3] = 2.0 * (xz + yw)
  t[5] = 2.0 * (xy + zw)
  t[6] = 1.0 - (2.0 * (xx + zz))
  t[7] = 2.0 * (yz - xw)
  t[9] = 2.0 * (xz - yw)
  t[10] = 2.0 * (yz + xw)
  t[11] = 1.0 - (2.0 * (xx + yy))
  if not voidp(kPosition) then
    case kPosition.ilk of
      #vector:
        t[13] = kPosition.x
        t[14] = kPosition.y
        t[15] = kPosition.z
      #list:
        t[13] = kPosition[1]
        t[14] = kPosition[2]
        t[15] = kPosition[3]
    end case
  end if
  return t
end

on Slerp me, q, t
  t = max(min(t, 1.0), 0.0)
  invt = 1.0 - t
  cosom = v.dot(q.v) + (w * q.w)
  dest = [0.0, 0.0, 0.0, 0.0]
  if cosom < 0.0 then
    cosom = -cosom
    dest[1] = -q.v.x
    dest[2] = -q.v.y
    dest[3] = -q.v.z
    dest[4] = -q.w
  else
    dest[1] = q.v.x
    dest[2] = q.v.y
    dest[3] = q.v.z
    dest[4] = q.w
  end if
  if (1.0 - cosom) > 0.000001 then
    sinom = sqrt(1.0 - (cosom * cosom))
    if cosom > 0.000001 then
      omega = atan(sinom / cosom)
    else
      omega = PI * 0.5
    end if
    s0 = sin(invt * omega) / sinom
    s1 = sin(t * omega) / sinom
  else
    s0 = invt
    s1 = t
  end if
  v.x = (s0 * v.x) + (s1 * dest[1])
  v.y = (s0 * v.y) + (s1 * dest[2])
  v.z = (s0 * v.z) + (s1 * dest[3])
  w = (s0 * w) + (s1 * dest[4])
end
