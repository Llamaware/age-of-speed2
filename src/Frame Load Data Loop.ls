global gGame

on exitFrame me
  if gGame.IsLoaded() then
    gGame.OnLoaded()
    go(45)
  else
    gGame.GetOffGame().SetLoadPercent(gGame.GetLoadPercent())
    go(the frame)
  end if
end
