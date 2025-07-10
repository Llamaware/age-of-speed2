global gIntroFrameCounter

on beginSprite me
  gIntroFrameCounter = 0
end

on exitFrame me
  cursor(-1)
  gIntroFrameCounter = gIntroFrameCounter + 1
  if gIntroFrameCounter > 105 then
    go(8)
  else
    go(the frame)
  end if
end
