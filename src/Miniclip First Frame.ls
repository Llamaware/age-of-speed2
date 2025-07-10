global MiniclipGameManager, gConfiguration

on exitFrame me
  gConfiguration = #release_web
  if ((the environment).runMode <> "author") and (gConfiguration = #release_web) then
    if validDomainSBS() then
      return 
    end if
    if not objectp(MiniclipGameManager) then
      go(85)
      return 
    end if
    MiniclipGameManager.services.validateLocation(the moviePath, externalParamValue("src"))
  end if
end
