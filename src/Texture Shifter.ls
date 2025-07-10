property pScene, pShadersList

on new me, kScene
  pScene = kScene
  pShadersList = []
  return me
end

on AddShader me, kShaderName, kDeltaT, kShiftX, kShiftY, kTime, kSmooth, kLayers
  if voidp(kTime) then
    kTime = 0
  end if
  if voidp(kSmooth) then
    kSmooth = 0
  end if
  lShader = pScene.shader(kShaderName)
  if voidp(lShader) then
    return 0
  end if
  lNew = [#shaderName: kShaderName, #deltaT: kDeltaT, #lastUpdate: kTime, #shiftX: kShiftX, #shiftY: kShiftY, #smooth: kSmooth, #layers: kLayers]
  pShadersList.append(lNew)
  return 1
end

on RemoveShader me, kShaderName
  repeat with li = 1 to pShadersList.count
    if pShadersList[li].shaderName = kShaderName then
      exit repeat
    end if
  end repeat
  if li <= pShadersList.count then
    pShadersList.deleteAt(li)
  end if
end

on ChangeShaderProps me, kShaderName, kDeltaT, kShiftX, kShiftY
  repeat with li = 1 to pShadersList.count
    lShaderProps = pShadersList[li]
    if lShaderProps.shaderName = kShaderName then
      lShaderProps.deltaT = kDeltaT
      lShaderProps.shiftX = kShiftX
      lShaderProps.shiftY = kShiftY
      return 
    end if
  end repeat
end

on ResetTextureTransform me, kShaderRef
  repeat with lj = 1 to kShaderRef.textureTransformList.count
    lTextureTransformListRef = kShaderRef.textureTransformList[lj]
    if voidp(lTextureTransformListRef) then
      next repeat
    end if
    lTextureTransformListRef.position = vector(0, 0, 0)
  end repeat
end

on UpdateShaderLayer me, kShaderRef, kLayerIdx, kDx, kDy
  if voidp(kShaderRef.textureList[kLayerIdx]) then
    return 
  end if
  lTransPos = kShaderRef.textureTransformList[kLayerIdx].position
  lTransPos.x = lTransPos.x + kDx
  lTransPos.y = lTransPos.y + kDy
  kShaderRef.textureTransformList[kLayerIdx].position = lTransPos
end

on update me, kTime
  repeat with li = 1 to pShadersList.count
    lShaderProps = pShadersList[li]
    if lShaderProps.lastUpdate = 0 then
      lShaderProps.lastUpdate = kTime
      next repeat
    end if
    lDt = kTime - lShaderProps.lastUpdate
    if (lDt >= lShaderProps.deltaT) and not lShaderProps.smooth then
      lErr = lDt - lShaderProps.deltaT
      lShaderProps.lastUpdate = kTime - lErr
      lShader = pScene.shader(lShaderProps.shaderName)
      if voidp(lShader) then
        put "texture shifter error: shader not found"
        next repeat
      end if
      repeat with lj = 1 to lShader.textureTransformList.count
        me.UpdateShaderLayer(lShader, lj, lShaderProps.shiftX, lShaderProps.shiftY)
      end repeat
      next repeat
    end if
    if not lShaderProps.smooth then
      next repeat
    end if
    lShader = pScene.shader(lShaderProps.shaderName)
    if voidp(lShader) then
      put "texture shifter error: shader not found"
      next repeat
    end if
    lMult = lDt / lShaderProps.deltaT
    lShiftX = lShaderProps.shiftX * lMult
    lShiftY = lShaderProps.shiftY * lMult
    lShaderProps.lastUpdate = kTime
    if not voidp(lShaderProps.layers) then
      repeat with lj = 1 to lShaderProps.layers.count
        me.UpdateShaderLayer(lShader, lShaderProps.layers[lj], lShiftX, lShiftY)
      end repeat
      next repeat
    end if
    repeat with lj = 1 to lShader.textureTransformList.count
      me.UpdateShaderLayer(lShader, lj, lShiftX, lShiftY)
    end repeat
  end repeat
end
