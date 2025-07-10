property ancestor, pDepthMin, pDepthMax, pZRange

on new me, kIdx, kSprite, kMember
  lDefaultTextureImg = image(8, 8, 32)
  lDefaultTextureImg.useAlpha = 1
  lDefaultTextureImg.setAlpha(0)
  lDefaultTexture = kMember.newTexture("overlay_default_texture_" & kIdx, #fromImageObject, lDefaultTextureImg)
  ancestor = script("Overlays Layer Base").new(kIdx, kSprite, kMember, lDefaultTexture, me)
  me.SetDepthRanges(0, 1000, 100000.0)
  return me
end

on _DepthToZ me, kValue
  assert(kValue.ilk = #integer, "OverlaysLayerSimple._DepthToZ: invalid depth value")
  lDepthRange = pDepthMax - pDepthMin
  return -1.0 - (Clamp(kValue - pDepthMin, 0, lDepthRange) * pZRange / lDepthRange)
end

on SetDepthRanges me, kMin, kMax, kZRange
  assert((kMin.ilk = #integer) and (kMax.ilk = #integer), "OverlayLayerSimple.SetDepthRanges: invalid ranges")
  pDepthMin = kMin
  pDepthMax = kMax
  pZRange = kZRange
  ancestor.pcamera.hither = 1.0
  ancestor.pcamera.yon = 1.0 + pZRange + 1.0
end

on GetDepthMin me
  return pDepthMin
end

on GetDepthMax me
  return pDepthMax
end
