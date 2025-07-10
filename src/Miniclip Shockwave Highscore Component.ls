property spriteNum, P, hsTitle, hsCookie, hsSave, hsVariable, hsValue, hsTime, hsReverse, hsNegative, hsMultiple, hsSuffix

on getPropertyDescriptionList me
  PDL = [:]
  PDL.addProp(#hsTitle, [#comment: "a1) Highscore chart title:", #format: #string, #default: "---"])
  PDL.addProp(#hsSave, [#comment: "a2) Post scores to chart?", #format: #boolean, #default: 1])
  PDL.addProp(#hsVariable, [#comment: "a3) Global score var name:", #format: #string, #default: "gScore"])
  PDL.addProp(#hsTime, [#comment: "b1) Is the score a time?", #format: #boolean, #default: 0])
  PDL.addProp(#hsReverse, [#comment: "b2) Reverse the chart order?", #format: #boolean, #default: 0])
  PDL.addProp(#hsNegative, [#comment: "b3) Allow scores below zero?", #format: #boolean, #default: 0])
  PDL.addProp(#hsMultiple, [#comment: "c1) Multiple highscore charts?", #format: #boolean, #default: 0])
  PDL.addProp(#hsSuffix, [#comment: "c2) Global suffix var name:", #format: #string, #default: "---"])
  return PDL
end

on getBehaviorDescription me
  return "Miniclip Shockwave Highscore Behavior" & RETURN & RETURN & "See code comments for details."
end

on getBehaviorTooltip me
  return "Controls the Miniclip Flash Highscore Component"
end

on beginSprite me
  P = [:]
  if hsMultiple then
    hsTitle = hsTitle & "_" & value("_global." & hsSuffix)
  end if
  tDCRval = value("_global." & hsVariable)
  P.addProp(#_Value, tDCRval)
  P.addProp(#_FrameCount, 1)
  hsCookie = EMPTY
end

on enterFrame me
  if P._FrameCount <> 0 then
    if P._FrameCount = 2 then
      init_flash_component(me)
      P._FrameCount = 0
    else
      P._FrameCount = P._FrameCount + 1
    end if
  end if
end

on init_flash_component me
  tFC = getVariable(sprite(spriteNum), "_level0", 0)
  tFC.dcr_to_swf_HS(P._Value, hsTitle, hsCookie, hsTime, hsReverse, hsNegative, hsSave)
end
