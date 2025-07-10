global gTestBeginTime, gGame

on beginSprite me
  if gTestBeginTime <> VOID then
    put "TEMPO COMPLESSIVO CARICAMENTO: " & the milliSeconds - gTestBeginTime
    gTestBeginTime = VOID
  end if
end

on exitFrame me
  cursor(-1)
  if gGame.GetExitCode() = 0 then
    go(the frame)
  else
    gGame.OnEnd()
    go(gGame.GetOffGame().GetFlashFrame())
  end if
end
