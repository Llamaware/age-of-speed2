property pVars, pConfFile, pConfMember
global gGame

on new me, kConfFile, kConfMember
  pVars = [:]
  pConfFile = kConfFile
  pConfMember = kConfMember
  return me
end

on LoadConfiguration me
  if gGame.GetConfiguration() = #debug then
    pConfMember.importFileInto(pConfFile)
  end if
  lConfText = pConfMember.text
  if lConfText = EMPTY then
    return 
  end if
  repeat with lLineIdx = 1 to lConfText.line.count
    lLine = lConfText.line[lLineIdx]
    if lLine.length = 0 then
      next repeat
    end if
    lVarName = lLine.word[1]
    lEqual = lLine.word[2]
    assert(not (lVarName contains "'") and not (lVarName contains ";") and not (lVarName contains ","), "Configuration file bad PUNCTUATION syntax")
    assert(lEqual = "=", "Configuration file bad EQUAL syntax")
    lVarValueString = lLine.word[3..lLine.word.count]
    lVarValue = value(lVarValueString)
    assert(not voidp(lVarValue), "Configuration file bad VALUE syntax")
    pVars.addProp(symbol(lVarName), lVarValue)
  end repeat
end

on GetVar me, kSymName
  return pVars[kSymName]
end
