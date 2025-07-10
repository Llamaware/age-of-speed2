property pTransform, pModifiers, pCurrentModifierIdx, pEnabled, pInputSource, pKeys, pTranslateSpeed, pRotateSpeed

on new me, kInputSource, kKeys
  pModifiers = [#translate_x, #translate_y, #translate_z, #rotate_x, #rotate_y, #rotate_z]
  pKeys = [#decrement: "3", #increment: "4", #print: "5"]
  pCurrentModifierIdx = 1
  pEnabled = 1
  pInputSource = kInputSource
  pTranslateSpeed = 1.0
  pRotateSpeed = 1.0
  if not voidp(kKeys) then
    pKeys = kKeys
  end if
  return me
end

on GetEnabled me
  return pEnabled
end

on GetTransform me
  return pTransform
end

on GetTranslateSpeed me
  return pTranslateSpeed
end

on GetRotateSpeed me
  return pRotateSpeed
end

on SetEnabled me, kEnabled
  pEnabled = kEnabled
end

on SetTransform me, kTransform
  pTransform = kTransform
end

on SetTranslateSpeed me, kTranslateSpeed
  pTranslateSpeed = kTranslateSpeed
end

on SetRotateSpeed me, kRotateSpeed
  pRotateSpeed = kRotateSpeed
end

on PreviousModifier me
  pCurrentModifierIdx = pCurrentModifierIdx - 1
  if pCurrentModifierIdx < 1 then
    pCurrentModifierIdx = pModifiers.count
  end if
  put "Modifier setted: " & string(pModifiers[pCurrentModifierIdx])
end

on NextModifier me
  pCurrentModifierIdx = pCurrentModifierIdx + 1
  if pCurrentModifierIdx > pModifiers.count then
    pCurrentModifierIdx = 1
  end if
  put "Modifier setted: " & string(pModifiers[pCurrentModifierIdx])
end

on update me
  if not pEnabled or voidp(pTransform) then
    return 
  end if
  if pInputSource.IsKeyPressed(pKeys.increment) then
    case pModifiers[pCurrentModifierIdx] of
      #translate_x:
        pTransform.position.x = pTransform.position.x + pTranslateSpeed
        put "translate_x: " & pTransform.position.x
      #translate_y:
        pTransform.position.y = pTransform.position.y + pTranslateSpeed
        put "translate_y: " & pTransform.position.y
      #translate_z:
        pTransform.position.z = pTransform.position.z + pTranslateSpeed
        put "translate_z: " & pTransform.position.z
      #rotate_x:
        pTransform.rotation.x = pTransform.rotation.x + pRotateSpeed
        put "rotate_x: " & pTransform.rotation.x
      #rotate_y:
        pTransform.rotation.y = pTransform.rotation.y + pRotateSpeed
        put "rotate_y: " & pTransform.rotation.y
      #rotate_z:
        pTransform.rotation.z = pTransform.rotation.z + pRotateSpeed
        put "rotate_z: " & pTransform.rotation.z
    end case
  end if
  if pInputSource.IsKeyPressed(pKeys.decrement) then
    case pModifiers[pCurrentModifierIdx] of
      #translate_x:
        pTransform.position.x = pTransform.position.x - pTranslateSpeed
        put "translate_x: " & pTransform.position.x
      #translate_y:
        pTransform.position.y = pTransform.position.y - pTranslateSpeed
        put "translate_y: " & pTransform.position.y
      #translate_z:
        pTransform.position.z = pTransform.position.z - pTranslateSpeed
        put "translate_z: " & pTransform.position.z
      #rotate_x:
        pTransform.rotation.x = pTransform.rotation.x - pRotateSpeed
        put "rotate_x: " & pTransform.rotation.x
      #rotate_y:
        pTransform.rotation.y = pTransform.rotation.y - pRotateSpeed
        put "rotate_y: " & pTransform.rotation.y
      #rotate_z:
        pTransform.rotation.z = pTransform.rotation.z - pRotateSpeed
        put "rotate_z: " & pTransform.rotation.z
    end case
  end if
  if pInputSource.IsKeyPressed(pKeys.print) then
    put "Transform: " & pTransform
    put "Transform.position: " & pTransform.position
    put "Transform.rotation: " & pTransform.rotation
  end if
end
