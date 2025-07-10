property ancestor
global gGame

on new me, kPlayerRef, kDriveData
  ancestor = script("Human Input Controller").new(kPlayerRef, kDriveData)
  me.Initialize()
  return me
end

on Initialize me
  lInputManager = gGame.GetInputManager()
  lInputManager.AddKeyEvent(#WeaponRequest, me, "x", #OnPressed)
  lInputManager.AddKeyEvent(#RestoreRequest, me, "z", #OnPressed)
end

on UpdateKeyEvents me
  me.SetGoingLeft(0)
  me.SetGoingRight(0)
  me.SetGoingForward(0)
  me.SetGoingBackward(0)
  lEvent = me.GetNextKeyEvent()
  repeat while not voidp(lEvent)
    case lEvent of
      #LeftDown:
        me.SetGoingLeft(1)
      #RightDown:
        me.SetGoingRight(1)
      #ForwardDown:
        me.SetGoingForward(1)
      #BackwardDown:
        me.SetGoingBackward(1)
      #WeaponRequest:
        if not me.GetRacePlayer().IsUnderWeaponEffect() then
          lCurrentWeapon = me.GetRacePlayer().GetCurrentWeapon()
          if not voidp(lCurrentWeapon) then
            me.GetRacePlayer().UseWeapon()
          end if
        end if
      #RestoreRequest:
        lVehicle = me.GetRacePlayer().GetVehicle()
        if (abs(lVehicle.GetTrasversal()) > 1.01000000000000001) or abs(lVehicle.GetGroundDistance() > 1000) then
          if not lVehicle.HaveToResetToTrack() then
            call(#ResetToTrackWithFade, gGame.GetGameplay())
          end if
        end if
    end case
    lEvent = me.GetNextKeyEvent()
  end repeat
end
