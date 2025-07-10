global gGame

on beginSprite me
  lSprite = sprite(me.spriteNum)
  lSprite.visible = 1
  lSprite.member = gGame.Get3D()
  if gGame.GetProfilerActive() then
    gGame.InitProfiler()
  else
    gGame.DeactivateProfiler()
  end if
  gGame.OnBegin(lSprite)
end

on prepareFrame
  STARTPROFILE(#ROOT)
  gGame.update()
  STARTPROFILE(#Render)
end

on exitFrame
  ENDPROFILE()
  gGame.ExitFrameUpdate()
  ENDPROFILE()
end

on endSprite me
  if gGame.GetProfilerActive() then
    gGame.GetProfiler().Output()
  end if
end
