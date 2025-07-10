property pBillboardArray
global gGame

on new me
  pBillboardArray = []
  return me
end

on AddBillboardElement me, fElement
  pBillboardArray.add(fElement)
end

on update me, fCamera
  repeat with li = 1 to pBillboardArray.count
    lBillboardModel = pBillboardArray[li].model
    if lBillboardModel <> VOID then
      if lBillboardModel.isInWorld() then
        if pBillboardArray[li].type = 1 then
          me.AlignModelToScreen(fCamera, pBillboardArray[li].model)
          next repeat
        end if
        if pBillboardArray[li].type = 2 then
          me.AlignModelToCameraCenter(fCamera, pBillboardArray[li].model)
          next repeat
        end if
        if pBillboardArray[li].type = 3 then
          me.AlignToCameraCenterFree(fCamera, pBillboardArray[li].model)
        end if
      end if
    end if
  end repeat
end

on AlignModelToScreen me, fCamera, fModel
  lTempCameraTransf = fCamera.transform.duplicate()
  lTempCameraTransf.rotation.x = 0.0
  lTempCameraTransf.rotation.y = 0.0
  lCameraVector = (lTempCameraTransf * vector(0, -1, 0)) - lTempCameraTransf.position
  lCameraVector.normalize()
  lPoint = fModel.transform.position + lCameraVector
  fModel.pointAt(lPoint, vector(0, 0, 1))
  fModel.transform.rotation.x = 0.0
  fModel.transform.rotation.y = 0.0
end

on AlignModelToCameraCenter me, fCamera, fModel
  fModel.pointAt(fCamera.transform.position, vector(0, 0, 1))
  fModel.transform.rotation.x = 0.0
  fModel.transform.rotation.y = 0.0
end

on AlignToCameraCenterFree me, fCamera, fModel
  fModel.pointAt(fCamera.transform.position, vector(0, 0, 1))
end
