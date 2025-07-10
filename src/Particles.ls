property p3DMember, pParticleResource, pParticleModel, pParticleTexture, pEmitterRegion, pEmitterDirection, pnumparticles, pangle, plifetime, pstartsize, pendsize, pstartcolor, pendcolor, pGravity, pwind, pdistribution, pmode, pMaxSpeed, pminspeed, pstartblend, pendblend, ploop, pTweenMode, pIsRunning, pTimeFactor, pPath, pPathStrength

on new me, f3DMember, fParticleName, fParticleTexture, fEmitterRegion, fEmitterDirection, fEmitterParameters
  p3DMember = f3DMember
  pParticleResource = p3DMember.newModelResource(fParticleName & "Res", #particle)
  pParticleTexture = fParticleTexture
  pParticleResource.texture = pParticleTexture
  pParticleModel = p3DMember.newModel(fParticleName & "Mod", pParticleResource)
  pEmitterRegion = fEmitterRegion
  pEmitterDirection = fEmitterDirection
  me.SetParticleParameters(fEmitterParameters)
  me.pTimeFactor = 1.0
  pIsRunning = 0
  me.BeginParticle()
  me.ImmediateStop()
  return me
end

on clone me, fNewName
  lEmitterParameters = [:]
  lEmitterParameters.addProp(#numParticles, pnumparticles)
  lEmitterParameters.addProp(#angle, pangle)
  lEmitterParameters.addProp(#lifeTime, plifetime)
  lEmitterParameters.addProp(#StartSize, pstartsize)
  lEmitterParameters.addProp(#EndSize, pendsize)
  lEmitterParameters.addProp(#StartColor, pstartcolor)
  lEmitterParameters.addProp(#endColor, pendcolor)
  lEmitterParameters.addProp(#gravity, pGravity)
  lEmitterParameters.addProp(#wind, pwind)
  lEmitterParameters.addProp(#distribution, pdistribution)
  lEmitterParameters.addProp(#mode, pmode)
  lEmitterParameters.addProp(#maxSpeed, pMaxSpeed)
  lEmitterParameters.addProp(#minSpeed, pminspeed)
  lEmitterParameters.addProp(#StartBlend, pstartblend)
  lEmitterParameters.addProp(#EndBlend, pendblend)
  lEmitterParameters.addProp(#loop, ploop)
  lEmitterParameters.addProp(#tweenMode, pTweenMode)
  lEmitterParameters.addProp(#path, pPath)
  lEmitterParameters.addProp(#pathStrength, pPathStrength)
  return script("Particles").new(p3DMember, fNewName, pParticleTexture, pEmitterRegion, pEmitterDirection, lEmitterParameters)
end

on TestParameters me, fEmitterParameters, fPropertyToTest, fDefaultValue
  if findPos(fEmitterParameters, fPropertyToTest) then
    return fEmitterParameters[fPropertyToTest]
  else
    return fDefaultValue
  end if
end

on SetParticleParameters me, fEmitterParameters
  pnumparticles = me.TestParameters(fEmitterParameters, #numParticles, 0)
  pangle = me.TestParameters(fEmitterParameters, #angle, 0)
  plifetime = me.TestParameters(fEmitterParameters, #lifeTime, 1)
  pstartsize = me.TestParameters(fEmitterParameters, #StartSize, 0)
  pendsize = me.TestParameters(fEmitterParameters, #EndSize, 0)
  pstartcolor = me.TestParameters(fEmitterParameters, #StartColor, rgb(0, 0, 0))
  pendcolor = me.TestParameters(fEmitterParameters, #endColor, rgb(0, 0, 0))
  pGravity = me.TestParameters(fEmitterParameters, #gravity, vector(0, 0, 0))
  pwind = me.TestParameters(fEmitterParameters, #wind, vector(0, 0, 0))
  pdistribution = me.TestParameters(fEmitterParameters, #distribution, #linear)
  pmode = me.TestParameters(fEmitterParameters, #mode, #stream)
  pMaxSpeed = me.TestParameters(fEmitterParameters, #maxSpeed, 0)
  pminspeed = me.TestParameters(fEmitterParameters, #minSpeed, 0)
  pstartblend = me.TestParameters(fEmitterParameters, #StartBlend, 0)
  pendblend = me.TestParameters(fEmitterParameters, #EndBlend, 0)
  ploop = me.TestParameters(fEmitterParameters, #loop, 1)
  pTweenMode = me.TestParameters(fEmitterParameters, #tweenMode, #age)
  pPath = me.TestParameters(fEmitterParameters, #path, VOID)
  pPathStrength = me.TestParameters(fEmitterParameters, #pathStrength, VOID)
end

on SetNumParticles me, fNumParticle
  pnumparticles = fNumParticle
  pParticleResource.emitter.numParticles = pnumparticles
end

on SetLifeTime me, fLifeTime
  plifetime = fLifeTime
  pParticleResource.lifeTime = plifetime / pTimeFactor
end

on SetGravity me, fGravity
  pGravity = fGravity
  pParticleResource.gravity = pGravity * pTimeFactor * pTimeFactor
end

on SetWind me, fVector
  pwind = fVector
  pParticleResource.wind = pwind * pTimeFactor * pTimeFactor
end

on SetDirection me, fDirection
  pEmitterDirection = fDirection
  pParticleResource.emitter.direction = pEmitterDirection * pTimeFactor
end

on SetTexture me, fTexture
  pParticleTexture = fTexture
  pParticleTexture.renderFormat = #rgba4444
  pParticleResource.texture = pParticleTexture
end

on SetTextureSize me, fStartSize, fEndSize
  pstartsize = fStartSize
  pendsize = fEndSize
  pParticleResource.sizeRange.start = pstartsize
  pParticleResource.sizeRange.end = pendsize
end

on SetTextureSpeed me, lMinSpeed, lMaxSpeed
  pMaxSpeed = lMaxSpeed
  pminspeed = lMinSpeed
  pParticleResource.emitter.maxSpeed = pMaxSpeed * pTimeFactor
  pParticleResource.emitter.minSpeed = pminspeed * pTimeFactor
end

on SetEmitterRegion me, kEmitterRegion
  pEmitterRegion = kEmitterRegion
end

on BeginParticle me
  if not pIsRunning then
    me.StartParticle()
    pParticleResource.emitter.region = pEmitterRegion
    pParticleResource.emitter.direction = pEmitterDirection * pTimeFactor
    pIsRunning = 1
  end if
end

on UpdateParticle me, fTransf
  if not voidp(fTransf) then
    lTransf = fTransf
    lTransfPos = lTransf.position.duplicate()
    lTransf.position = vector(0.0, 0.0, 0.0)
    lEmitterRegion = pEmitterRegion.duplicate()
    repeat with li = 1 to pEmitterRegion.count
      lEmitterRegion[li] = lTransfPos + (lTransf * pEmitterRegion[li])
    end repeat
    pParticleResource.emitter.region = lEmitterRegion
    if pPath <> VOID then
      lPath = pPath.duplicate()
      repeat with li = 1 to pPath.count
        lPath[li] = lTransf * pPath[li]
      end repeat
      pParticleResource.emitter.path = lPath
    end if
    pParticleResource.emitter.direction = lTransf * pEmitterDirection * pTimeFactor
  end if
end

on StartParticle me, kTransf
  if not pIsRunning then
    pParticleResource.emitter.numParticles = pnumparticles
    pParticleResource.emitter.angle = pangle
    if pTimeFactor <> 0 then
      pParticleResource.lifeTime = plifetime / pTimeFactor
    else
      pParticleResource.lifeTime = plifetime
    end if
    pParticleResource.sizeRange.start = pstartsize
    pParticleResource.sizeRange.end = pendsize
    pParticleResource.colorRange.start = pstartcolor
    pParticleResource.colorRange.end = pendcolor
    pParticleResource.gravity = pGravity * pTimeFactor * pTimeFactor
    pParticleResource.wind = pwind * pTimeFactor
    pParticleResource.emitter.distribution = pdistribution
    pParticleResource.emitter.mode = pmode
    pParticleResource.blendRange.start = pstartblend
    pParticleResource.blendRange.end = pendblend
    pParticleResource.emitter.maxSpeed = pMaxSpeed * pTimeFactor
    pParticleResource.emitter.minSpeed = pminspeed * pTimeFactor
    pParticleResource.emitter.tweenMode = pTweenMode
    pParticleResource.emitter.loop = ploop
    if pPath <> VOID then
      pParticleResource.emitter.path = pPath
      pParticleResource.emitter.pathStrength = pPathStrength
    end if
    if not voidp(kTransf) then
      lTransf = kTransf
      lEmitterRegion = pEmitterRegion.duplicate()
      repeat with li = 1 to pEmitterRegion.count
        lEmitterRegion[li] = lTransf * pEmitterRegion[li]
      end repeat
      pParticleResource.emitter.region = lEmitterRegion
    end if
    pIsRunning = 1
  end if
end

on StopParticle me
  pParticleResource.emitter.loop = 0
  pIsRunning = 0
end

on ImmediateStop me
  if pIsRunning then
    pParticleResource.emitter.numParticles = 0
    pIsRunning = 0
  end if
end

on Fade me, fFadeTime, fCurrentTime
  if pIsRunning then
    lFadeTime = fFadeTime - fCurrentTime
    lBlend = pstartblend * lFadeTime / fFadeTime
    if lBlend < 0 then
      lBlend = 0
    end if
    if pmode = #stream then
      pParticleResource.blendRange.start = lBlend
    end if
    if lFadeTime < 0 then
      ImmediateStop()
      return #end
    end if
  end if
  return #fading
end

on delete me
  p3DMember.deleteModelResource(pParticleResource.name)
  p3DMember.deleteModel(pParticleModel.name)
  me = VOID
end

on SetTimeFactor me, kTimeFactor
  me.pTimeFactor = kTimeFactor
  me.pParticleResource.gravity = pGravity * me.pTimeFactor * me.pTimeFactor
  me.pParticleResource.wind = pwind * me.pTimeFactor
  if (pMaxSpeed > 0) and (pminspeed > 0) then
    me.pParticleResource.emitter.maxSpeed = pMaxSpeed * me.pTimeFactor
    me.pParticleResource.emitter.minSpeed = pminspeed * me.pTimeFactor
  end if
end
