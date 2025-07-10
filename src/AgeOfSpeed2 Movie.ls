global gGame

on flash_start_after_intro me
  go(2)
end

on respondToSubmit me
  lflashScoreUrl = sprite(2).getVariable("flashScoreUrl", 0)
  gotoNetPage(lflashScoreUrl)
end
