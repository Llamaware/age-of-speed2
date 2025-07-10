property player, pLayerId, pLayersList, pDepthCountersList, pStack
global gGame

on new me, fWorldRef, fCameraRef
  player = script("Overlays Layer Simple").new(0, gGame.Get3DSprite(), gGame.Get3D())
  pLayerId = 0
  pDepthCountersList = [player.GetDepthMax()]
  pLayersList = [player]
  pStack = []
  return me
end

on AddLayer me
  lId = pLayersList.count
  lLayer = script("Overlays Layer Simple").new(lId, gGame.Get3DSprite(), gGame.Get3D())
  pLayersList.append(lLayer)
  pDepthCountersList.append(lLayer.GetDepthMax())
  return lId
end

on SetLayer me, kLayerId
  lIdx = min(max(kLayerId + 1, 1), pLayersList.count)
  pLayerId = lIdx - 1
  player = pLayersList[lIdx]
end

on HideLayer me
  player.pcamera.rootNode = VOID
end

on ShowLayer me
  player.pcamera.rootNode = player.pRootNode
end

on PushLayer me, kLayerId
  pStack.append(pLayerId)
  me.SetLayer(kLayerId)
end

on PopLayer me
  lStackCount = pStack.count
  if lStackCount > 0 then
    lPrevLayerId = pStack[lStackCount]
    pStack.deleteAt(lStackCount)
    me.SetLayer(lPrevLayerId)
  end if
end

on add me, fObjectName, fTexture, fPosition, fScale, fBlend, fRot
  if voidp(fScale) then
    lScale = VOID
  else
    lScale = [fScale, fScale]
  end if
  player.addOverlay(fObjectName, pDepthCountersList[pLayerId + 1], [#texture: fTexture, #position: fPosition, #scale: lScale, #blend: fBlend, #rotation: fRot])
  pDepthCountersList[pLayerId + 1] = Clamp(pDepthCountersList[pLayerId + 1] - 1, player.GetDepthMin(), player.GetDepthMax())
end

on Modify me, fObjectName, fTexture, fPosition, fScale, fBlend, fRot
  if voidp(fScale) then
    lScale = VOID
  else
    lScale = [fScale, fScale]
  end if
  player.UpdateOverlayParams(fObjectName, [#texture: fTexture, #position: fPosition, #scale: lScale, #blend: fBlend, #rotation: fRot])
end

on Remove me, fObjectName
  player.removeOverlay(fObjectName)
end

on GetIndex me, fObjectName
  return 1
end

on GetOverlayCount
  return 0
end

on GetOverlayList
  return []
end

on GetOverlayData me, kObjectName
  return VOID
end
