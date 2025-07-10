global gGame

on exitFrame me
  HideHighScore()
  gGame.GetOffGame().GetSprite().UnhideButtons()
end
