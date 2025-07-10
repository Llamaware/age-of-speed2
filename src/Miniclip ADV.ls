property spriteNum
global MiniclipGameManager

on beginSprite me
  sprite(spriteNum).visible = 0
  if objectp(MiniclipGameManager) then
    MiniclipGameManager.services.advertContainer(spriteNum, 2011, 160, 90)
  end if
end
