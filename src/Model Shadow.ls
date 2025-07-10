property pmodel, pShadowModel, pMember, pExcludePrefixes, pIntersectionModel, pIntersectionPosition, pIntersectionNormal

on new me, kModel, kShadowModel, kMember, kExcludePrefixes, kBlendingValue
  pmodel = kModel
  pShadowModel = kShadowModel
  pMember = kMember
  pExcludePrefixes = kExcludePrefixes
  pShadowModel.pointAtOrientation = [vector(0.0, 0.0, 1.0), vector(0.0, 1.0, 0.0)]
  lShadowModelShader = pShadowModel.shader
  if not voidp(lShadowModelShader) then
    lShadowModelShader.texture.renderFormat = #rgba8888
    lShadowModelShader.texture.quality = #low
    lShadowModelShader.blend = kBlendingValue
  end if
  return me
end

on GetIntersectionNormal me
  return pIntersectionNormal
end

on GetIntersectionPosition me
  return pIntersectionPosition
end

on GetIntersectionModel me
  return pIntersectionModel
end

on update me, kModelList, kRotation, kOffset
  if voidp(pmodel) then
    return 
  end if
  if voidp(kOffset) then
    kOffset = 0.0
  end if
  if voidp(kModelList) then
    lArguments = [#maxNumberOfModels: 3, #levelOfDetail: #detailed]
  else
    lArguments = [#maxNumberOfModels: 3, #levelOfDetail: #detailed, #modelList: kModelList]
  end if
  lIntersections = pMember.modelsUnderRay(pmodel.worldPosition, vector(0.0, 0.0, -1.0), lArguments)
  repeat with lIntersection in lIntersections
    lGoodInt = 1
    repeat with li = 1 to pExcludePrefixes.count
      if lIntersection.model.name starts pExcludePrefixes[li] then
        lGoodInt = 0
        exit repeat
      end if
    end repeat
    if lGoodInt then
      pIntersectionModel = lIntersection.model
      pIntersectionPosition = lIntersection.isectPosition
      pIntersectionNormal = lIntersection.isectNormal
      pIntersectionPosition = pIntersectionPosition + (pIntersectionNormal * kOffset)
      pShadowModel.transform.position = pIntersectionPosition + (pIntersectionNormal * 1.0)
      pShadowModel.pointAt(pIntersectionPosition + (pIntersectionNormal * 2.0), vector(0.0, 1.0, 0.0))
      if not voidp(kRotation) then
        pShadowModel.rotate(0, 0, kRotation)
      end if
      exit repeat
    end if
  end repeat
  return lIntersections
end
