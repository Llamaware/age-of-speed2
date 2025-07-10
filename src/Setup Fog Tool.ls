property pFogParameters, pSwitchFogEnabled, pFogKeyPressedTime, pFogParamSelected, pKeypressSwitchL, pKeypressSwitchT
global gGame

on new me
  pFogParameters = [:]
  pFogParameters.addProp(#enabled, 0)
  pFogParameters.addProp(#farplane, 0)
  pFogParameters.addProp(#nearplane, 0)
  pFogParameters.addProp(#decayMode, #linear)
  pFogParameters.addProp(#colorR, 150)
  pFogParameters.addProp(#colorG, 150)
  pFogParameters.addProp(#colorB, 150)
  pSwitchFogEnabled = 0
  pFogKeyPressedTime = 0
  pFogParamSelected = 1
  return me
end

on ToolSetupFog me
  return 
  lSwitchEnableFog = keyPressed("5")
  if lSwitchEnableFog and not pSwitchFogEnabled then
    pFogParameters.enabled = not pFogParameters.enabled
    me.UpdateFogParameters()
  end if
  pSwitchFogEnabled = lSwitchEnableFog
  if keyPressed("6") then
    if (gGame.GetTimeManager().GetTime() - pFogKeyPressedTime) > 500 then
      pFogKeyPressedTime = gGame.GetTimeManager().GetTime()
      if pFogParamSelected > 5 then
        pFogParamSelected = 1
      else
        pFogParamSelected = pFogParamSelected + 1
      end if
      case pFogParamSelected of
        1:
          put "[FOG: R]"
        2:
          put "[FOG: G]"
        3:
          put "[FOG: B]"
        4:
          put "[FOG: NEARPLANE]"
        5:
          put "[FOG: FARPLANE]"
      end case
    end if
  end if
  if keyPressed("7") then
    case pFogParamSelected of
      1:
        pFogParameters.colorR = pFogParameters.colorR + 1
        me.PrintFogProps()
      2:
        pFogParameters.colorG = pFogParameters.colorG + 1
        me.PrintFogProps()
      3:
        pFogParameters.colorB = pFogParameters.colorB + 1
        me.PrintFogProps()
      4:
        pFogParameters.nearplane = pFogParameters.nearplane + 100
        me.PrintFogProps()
      5:
        pFogParameters.farplane = pFogParameters.farplane + 100
        me.PrintFogProps()
    end case
  end if
  if keyPressed("8") then
    case pFogParamSelected of
      1:
        pFogParameters.colorR = pFogParameters.colorR - 1
        me.PrintFogProps()
      2:
        pFogParameters.colorG = pFogParameters.colorG - 1
        me.PrintFogProps()
      3:
        pFogParameters.colorB = pFogParameters.colorB - 1
        me.PrintFogProps()
      4:
        pFogParameters.nearplane = pFogParameters.nearplane - 100
        me.PrintFogProps()
      5:
        pFogParameters.farplane = pFogParameters.farplane - 100
        me.PrintFogProps()
    end case
  end if
  me.UpdateFogParameters()
end

on PrintFogProps me
  put "FOG:[R: " & pFogParameters.colorR & " G: " & pFogParameters.colorG & " B: " & pFogParameters.colorB & " Near: " & pFogParameters.nearplane & " Far: " & pFogParameters.farplane & " ]"
end

on SetupFog me, fFogParameters
  pFogParameters.enabled = fFogParameters.enabled
  pFogParameters.farplane = fFogParameters.farplane
  pFogParameters.nearplane = fFogParameters.nearplane
  pFogParameters.decayMode = fFogParameters.decayMode
  pFogParameters.colorR = fFogParameters.colorR
  pFogParameters.colorG = fFogParameters.colorG
  pFogParameters.colorB = fFogParameters.colorB
  me.UpdateFogParameters()
end

on UpdateFogParameters me
  lCamNode = me.GetCameraNode()
  if pFogParameters.enabled = 1 then
    lCamNode.fog.enabled = 1
    lCamNode.fog.far = pFogParameters.farplane
    lCamNode.fog.near = pFogParameters.nearplane
    lCamNode.fog.decayMode = pFogParameters.decayMode
    lCamNode.fog.color = color(#rgb, pFogParameters.colorR, pFogParameters.colorG, pFogParameters.colorB)
  else
    lCamNode.fog.enabled = 0
  end if
end
