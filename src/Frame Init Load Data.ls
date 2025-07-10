global gTestBeginTime

on beginSprite me
  gTestBeginTime = the milliSeconds
end

on prepareFrame me
end

on exitFrame me
  go(14)
end
