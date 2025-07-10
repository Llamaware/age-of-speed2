property pMissileBaseMdlName, pActiveMissiles
global gGame

on new me
  pActiveMissiles = []
  pMissileMdlBaseName = "missile_cam"
  return me
end

on GetActiveMissiles me
  return pActiveMissiles
end

on SetMissileBaseMdlName me, kMissileBaseMdlName
  pMissileBaseMdlName = kMissileBaseMdlName
end

on ShootMissile me, kPlayerRef
  lMissile = script("AgeOfSpeed2 Missile").new(kPlayerRef, pMissileBaseMdlName)
  pActiveMissiles.add(lMissile)
  return lMissile
end

on update me, kTime
  repeat with li = pActiveMissiles.count down to 1
    lDone = pActiveMissiles[li].update(kTime)
    if lDone then
      pActiveMissiles.deleteAt(li)
    end if
  end repeat
end
