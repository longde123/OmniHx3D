package com.omnihx3d.materials;

/**
 * ...
 * @author Krtolica Vujadin
 */
@:expose('BABYLON.IncludesShadersStore') class IncludesShadersStore {

	public static var Shaders:Map<String, String> = [
		"bonesDeclaration" => "#if NUM_BONE_INFLUENCERS>0\nuniform mat4 mBones[BonesPerMesh];\nattribute vec4 matricesIndices;\nattribute vec4 matricesWeights;\n#if NUM_BONE_INFLUENCERS>4\nattribute vec4 matricesIndicesExtra;\nattribute vec4 matricesWeightsExtra;\n#endif\n#endif",
		"bonesVertex" => "#if NUM_BONE_INFLUENCERS>0\nmat4 influence;\ninfluence=mBones[int(matricesIndices[0])]*matricesWeights[0];\n#if NUM_BONE_INFLUENCERS>1\ninfluence+=mBones[int(matricesIndices[1])]*matricesWeights[1];\n#endif \n#if NUM_BONE_INFLUENCERS>2\ninfluence+=mBones[int(matricesIndices[2])]*matricesWeights[2];\n#endif \n#if NUM_BONE_INFLUENCERS>3\ninfluence+=mBones[int(matricesIndices[3])]*matricesWeights[3];\n#endif \n#if NUM_BONE_INFLUENCERS>4\ninfluence+=mBones[int(matricesIndicesExtra[0])]*matricesWeightsExtra[0];\n#endif \n#if NUM_BONE_INFLUENCERS>5\ninfluence+=mBones[int(matricesIndicesExtra[1])]*matricesWeightsExtra[1];\n#endif \n#if NUM_BONE_INFLUENCERS>6\ninfluence+=mBones[int(matricesIndicesExtra[2])]*matricesWeightsExtra[2];\n#endif \n#if NUM_BONE_INFLUENCERS>7\ninfluence+=mBones[int(matricesIndicesExtra[3])]*matricesWeightsExtra[3];\n#endif \nfinalWorld=finalWorld*influence;\n#endif",
		"bumpFragment" => "#ifdef BUMP\nvec2 bumpUV=vBumpUV;\n#endif\n#if defined(BUMP) || defined(PARALLAX)\nmat3 TBN=cotangent_frame(normalW*vBumpInfos.y,-viewDirectionW,bumpUV);\n#endif\n#ifdef PARALLAX\nmat3 invTBN=transposeMat3(TBN);\n#ifdef PARALLAXOCCLUSION\nvec2 uvOffset=parallaxOcclusion(invTBN*-viewDirectionW,invTBN*normalW,bumpUV,vBumpInfos.z);\n#else\nvec2 uvOffset=parallaxOffset(invTBN*viewDirectionW,vBumpInfos.z);\n#endif\ndiffuseUV+=uvOffset;\nbumpUV+=uvOffset;\n#endif\n#ifdef BUMP\nnormalW=perturbNormal(viewDirectionW,TBN,bumpUV);\n#endif",
		"bumpFragmentFunctions" => "#ifdef BUMP\nvarying vec2 vBumpUV;\nuniform vec3 vBumpInfos;\nuniform sampler2D bumpSampler;\n\nmat3 cotangent_frame(vec3 normal,vec3 p,vec2 uv)\n{\n\nvec3 dp1=dFdx(p);\nvec3 dp2=dFdy(p);\nvec2 duv1=dFdx(uv);\nvec2 duv2=dFdy(uv);\n\nvec3 dp2perp=cross(dp2,normal);\nvec3 dp1perp=cross(normal,dp1);\nvec3 tangent=dp2perp*duv1.x+dp1perp*duv2.x;\nvec3 binormal=dp2perp*duv1.y+dp1perp*duv2.y;\n\nfloat invmax=inversesqrt(max(dot(tangent,tangent),dot(binormal,binormal)));\nreturn mat3(tangent*invmax,binormal*invmax,normal);\n}\nvec3 perturbNormal(vec3 viewDir,mat3 cotangentFrame,vec2 uv)\n{\nvec3 map=texture2D(bumpSampler,uv).xyz;\nmap=map*255./127.-128./127.;\nreturn normalize(cotangentFrame*map);\n}\n#ifdef PARALLAX\nconst float minSamples=4.;\nconst float maxSamples=15.;\nconst int iMaxSamples=15;\n\nvec2 parallaxOcclusion(vec3 vViewDirCoT,vec3 vNormalCoT,vec2 texCoord,float parallaxScale) {\nfloat parallaxLimit=length(vViewDirCoT.xy)/vViewDirCoT.z;\nparallaxLimit*=parallaxScale;\nvec2 vOffsetDir=normalize(vViewDirCoT.xy);\nvec2 vMaxOffset=vOffsetDir*parallaxLimit;\nfloat numSamples=maxSamples+(dot(vViewDirCoT,vNormalCoT)*(minSamples-maxSamples));\nfloat stepSize=1.0/numSamples;\n\nfloat currRayHeight=1.0;\nvec2 vCurrOffset=vec2(0,0);\nvec2 vLastOffset=vec2(0,0);\nfloat lastSampledHeight=1.0;\nfloat currSampledHeight=1.0;\nfor (int i=0; i<iMaxSamples; i++)\n{\ncurrSampledHeight=texture2D(bumpSampler,vBumpUV+vCurrOffset).w;\n\nif (currSampledHeight>currRayHeight)\n{\nfloat delta1=currSampledHeight-currRayHeight;\nfloat delta2=(currRayHeight+stepSize)-lastSampledHeight;\nfloat ratio=delta1/(delta1+delta2);\nvCurrOffset=(ratio)* vLastOffset+(1.0-ratio)*vCurrOffset;\n\nbreak;\n}\nelse\n{\ncurrRayHeight-=stepSize;\nvLastOffset=vCurrOffset;\nvCurrOffset+=stepSize*vMaxOffset;\nlastSampledHeight=currSampledHeight;\n}\n}\nreturn vCurrOffset;\n}\nvec2 parallaxOffset(vec3 viewDir,float heightScale)\n{\n\nfloat height=texture2D(bumpSampler,vBumpUV).w;\nvec2 texCoordOffset=heightScale*viewDir.xy*height;\nreturn -texCoordOffset;\n}\n#endif\n#endif",
		"clipPlaneFragment" => "#ifdef CLIPPLANE\nif (fClipDistance>0.0)\n{\ndiscard;\n}\n#endif",
		"clipPlaneFragmentDeclaration" => "#ifdef CLIPPLANE\nvarying float fClipDistance;\n#endif",
		"clipPlaneVertex" => "#ifdef CLIPPLANE\nfClipDistance=dot(worldPos,vClipPlane);\n#endif",
		"clipPlaneVertexDeclaration" => "#ifdef CLIPPLANE\nuniform vec4 vClipPlane;\nvarying float fClipDistance;\n#endif",
		"fogFragment" => "#ifdef FOG\nfloat fog=CalcFogFactor();\ncolor.rgb=fog*color.rgb+(1.0-fog)*vFogColor;\n#endif",
		"fogFragmentDeclaration" => "#ifdef FOG\n#define FOGMODE_NONE 0.\n#define FOGMODE_EXP 1.\n#define FOGMODE_EXP2 2.\n#define FOGMODE_LINEAR 3.\n#define E 2.71828\nuniform vec4 vFogInfos;\nuniform vec3 vFogColor;\nvarying float fFogDistance;\nfloat CalcFogFactor()\n{\nfloat fogCoeff=1.0;\nfloat fogStart=vFogInfos.y;\nfloat fogEnd=vFogInfos.z;\nfloat fogDensity=vFogInfos.w;\nif (FOGMODE_LINEAR == vFogInfos.x)\n{\nfogCoeff=(fogEnd-fFogDistance)/(fogEnd-fogStart);\n}\nelse if (FOGMODE_EXP == vFogInfos.x)\n{\nfogCoeff=1.0/pow(E,fFogDistance*fogDensity);\n}\nelse if (FOGMODE_EXP2 == vFogInfos.x)\n{\nfogCoeff=1.0/pow(E,fFogDistance*fFogDistance*fogDensity*fogDensity);\n}\nreturn clamp(fogCoeff,0.0,1.0);\n}\n#endif",
		"fogVertex" => "#ifdef FOG\nfFogDistance=(view*worldPos).z;\n#endif",
		"fogVertexDeclaration" => "#ifdef FOG\nvarying float fFogDistance;\n#endif",
		"fresnelFunction" => "#ifdef FRESNEL\nfloat computeFresnelTerm(vec3 viewDirection,vec3 worldNormal,float bias,float power)\n{\nfloat fresnelTerm=pow(bias+abs(dot(viewDirection,worldNormal)),power);\nreturn clamp(fresnelTerm,0.,1.);\n}\n#endif",
		"helperFunctions" => "mat3 transposeMat3(mat3 inMatrix) {\nvec3 i0=inMatrix[0];\nvec3 i1=inMatrix[1];\nvec3 i2=inMatrix[2];\nmat3 outMatrix=mat3(\nvec3(i0.x,i1.x,i2.x),\nvec3(i0.y,i1.y,i2.y),\nvec3(i0.z,i1.z,i2.z)\n);\nreturn outMatrix;\n}",
		"instancesDeclaration" => "#ifdef INSTANCES\nattribute vec4 world0;\nattribute vec4 world1;\nattribute vec4 world2;\nattribute vec4 world3;\n#else\nuniform mat4 world;\n#endif",
		"instancesVertex" => "#ifdef INSTANCES\nmat4 finalWorld=mat4(world0,world1,world2,world3);\n#else\nmat4 finalWorld=world;\n#endif",
		"lightFragment" => "#ifdef LIGHT{X}\n#ifndef SPECULARTERM\nvec3 vLightSpecular{X}=vec3(0.);\n#endif\n#ifdef SPOTLIGHT{X}\ninfo=computeSpotLighting(viewDirectionW,normalW,vLightData{X},vLightDirection{X},vLightDiffuse{X}.rgb,vLightSpecular{X},vLightDiffuse{X}.a,glossiness);\n#endif\n#ifdef HEMILIGHT{X}\ninfo=computeHemisphericLighting(viewDirectionW,normalW,vLightData{X},vLightDiffuse{X}.rgb,vLightSpecular{X},vLightGround{X},glossiness);\n#endif\n#if defined(POINTLIGHT{X}) || defined(DIRLIGHT{X})\ninfo=computeLighting(viewDirectionW,normalW,vLightData{X},vLightDiffuse{X}.rgb,vLightSpecular{X},vLightDiffuse{X}.a,glossiness);\n#endif\n#ifdef SHADOW{X}\n#ifdef SHADOWVSM{X}\nshadow=computeShadowWithVSM(vPositionFromLight{X},shadowSampler{X},shadowsInfo{X}.z,shadowsInfo{X}.x);\n#else\n#ifdef SHADOWPCF{X}\n#if defined(POINTLIGHT{X})\nshadow=computeShadowWithPCFCube(vLightData{X}.xyz,shadowSampler{X},shadowsInfo{X}.y,shadowsInfo{X}.z,shadowsInfo{X}.x);\n#else\nshadow=computeShadowWithPCF(vPositionFromLight{X},shadowSampler{X},shadowsInfo{X}.y,shadowsInfo{X}.z,shadowsInfo{X}.x);\n#endif\n#else\n#if defined(POINTLIGHT{X})\nshadow=computeShadowCube(vLightData{X}.xyz,shadowSampler{X},shadowsInfo{X}.x,shadowsInfo{X}.z);\n#else\nshadow=computeShadow(vPositionFromLight{X},shadowSampler{X},shadowsInfo{X}.x,shadowsInfo{X}.z);\n#endif\n#endif\n#endif\n#else\nshadow=1.;\n#endif\ndiffuseBase+=info.diffuse*shadow;\n#ifdef SPECULARTERM\nspecularBase+=info.specular*shadow;\n#endif\n#endif",
		"lightFragmentDeclaration" => "#ifdef LIGHT{X}\nuniform vec4 vLightData{X};\nuniform vec4 vLightDiffuse{X};\n#ifdef SPECULARTERM\nuniform vec3 vLightSpecular{X};\n#endif\n#ifdef SHADOW{X}\n#if defined(SPOTLIGHT{X}) || defined(DIRLIGHT{X})\nvarying vec4 vPositionFromLight{X};\nuniform sampler2D shadowSampler{X};\n#else\nuniform samplerCube shadowSampler{X};\n#endif\nuniform vec3 shadowsInfo{X};\n#endif\n#ifdef SPOTLIGHT{X}\nuniform vec4 vLightDirection{X};\n#endif\n#ifdef HEMILIGHT{X}\nuniform vec3 vLightGround{X};\n#endif\n#endif",
		"lightsFragmentFunctions" => "\nstruct lightingInfo\n{\nvec3 diffuse;\n#ifdef SPECULARTERM\nvec3 specular;\n#endif\n};\nlightingInfo computeLighting(vec3 viewDirectionW,vec3 vNormal,vec4 lightData,vec3 diffuseColor,vec3 specularColor,float range,float glossiness) {\nlightingInfo result;\nvec3 lightVectorW;\nfloat attenuation=1.0;\nif (lightData.w == 0.)\n{\nvec3 direction=lightData.xyz-vPositionW;\nattenuation=max(0.,1.0-length(direction)/range);\nlightVectorW=normalize(direction);\n}\nelse\n{\nlightVectorW=normalize(-lightData.xyz);\n}\n\nfloat ndl=max(0.,dot(vNormal,lightVectorW));\nresult.diffuse=ndl*diffuseColor*attenuation;\n#ifdef SPECULARTERM\n\nvec3 angleW=normalize(viewDirectionW+lightVectorW);\nfloat specComp=max(0.,dot(vNormal,angleW));\nspecComp=pow(specComp,max(1.,glossiness));\nresult.specular=specComp*specularColor*attenuation;\n#endif\nreturn result;\n}\nlightingInfo computeSpotLighting(vec3 viewDirectionW,vec3 vNormal,vec4 lightData,vec4 lightDirection,vec3 diffuseColor,vec3 specularColor,float range,float glossiness) {\nlightingInfo result;\nvec3 direction=lightData.xyz-vPositionW;\nvec3 lightVectorW=normalize(direction);\nfloat attenuation=max(0.,1.0-length(direction)/range);\n\nfloat cosAngle=max(0.,dot(-lightDirection.xyz,lightVectorW));\nif (cosAngle>=lightDirection.w)\n{\ncosAngle=max(0.,pow(cosAngle,lightData.w));\nattenuation*=cosAngle;\n\nfloat ndl=max(0.,dot(vNormal,-lightDirection.xyz));\nresult.diffuse=ndl*diffuseColor*attenuation;\n#ifdef SPECULARTERM\n\nvec3 angleW=normalize(viewDirectionW-lightDirection.xyz);\nfloat specComp=max(0.,dot(vNormal,angleW));\nspecComp=pow(specComp,max(1.,glossiness));\nresult.specular=specComp*specularColor*attenuation;\n#endif\nreturn result;\n}\nresult.diffuse=vec3(0.);\n#ifdef SPECULARTERM\nresult.specular=vec3(0.);\n#endif\nreturn result;\n}\nlightingInfo computeHemisphericLighting(vec3 viewDirectionW,vec3 vNormal,vec4 lightData,vec3 diffuseColor,vec3 specularColor,vec3 groundColor,float glossiness) {\nlightingInfo result;\n\nfloat ndl=dot(vNormal,lightData.xyz)*0.5+0.5;\nresult.diffuse=mix(groundColor,diffuseColor,ndl);\n#ifdef SPECULARTERM\n\nvec3 angleW=normalize(viewDirectionW+lightData.xyz);\nfloat specComp=max(0.,dot(vNormal,angleW));\nspecComp=pow(specComp,max(1.,glossiness));\nresult.specular=specComp*specularColor;\n#endif\nreturn result;\n}\n",
		"logDepthDeclaration" => "#ifdef LOGARITHMICDEPTH\nuniform float logarithmicDepthConstant;\nvarying float vFragmentDepth;\n#endif",
		"logDepthFragment" => "#ifdef LOGARITHMICDEPTH\ngl_FragDepthEXT=log2(vFragmentDepth)*logarithmicDepthConstant*0.5;\n#endif",
		"logDepthVertex" => "#ifdef LOGARITHMICDEPTH\nvFragmentDepth=1.0+gl_Position.w;\ngl_Position.z=log2(max(0.000001,vFragmentDepth))*logarithmicDepthConstant;\n#endif",
		"pointCloudVertex" => "#ifdef POINTSIZE\ngl_PointSize=pointSize;\n#endif",
		"pointCloudVertexDeclaration" => "#ifdef POINTSIZE\nuniform float pointSize;\n#endif",
		"reflectionFunction" => "vec3 computeReflectionCoords(vec4 worldPos,vec3 worldNormal)\n{\n#ifdef REFLECTIONMAP_EQUIRECTANGULAR_FIXED\nvec3 direction=normalize(vDirectionW);\nfloat t=clamp(direction.y*-0.5+0.5,0.,1.0);\nfloat s=atan(direction.z,direction.x)*RECIPROCAL_PI2+0.5;\nreturn vec3(s,t,0);\n#endif\n#ifdef REFLECTIONMAP_EQUIRECTANGULAR\nvec3 cameraToVertex=normalize(worldPos.xyz-vEyePosition);\nvec3 r=reflect(cameraToVertex,worldNormal);\nfloat t=clamp(r.y*-0.5+0.5,0.,1.0);\nfloat s=atan(r.z,r.x)*RECIPROCAL_PI2+0.5;\nreturn vec3(s,t,0);\n#endif\n#ifdef REFLECTIONMAP_SPHERICAL\nvec3 viewDir=normalize(vec3(view*worldPos));\nvec3 viewNormal=normalize(vec3(view*vec4(worldNormal,0.0)));\nvec3 r=reflect(viewDir,viewNormal);\nr.z=r.z-1.0;\nfloat m=2.0*length(r);\nreturn vec3(r.x/m+0.5,1.0-r.y/m-0.5,0);\n#endif\n#ifdef REFLECTIONMAP_PLANAR\nvec3 viewDir=worldPos.xyz-vEyePosition;\nvec3 coords=normalize(reflect(viewDir,worldNormal));\nreturn vec3(reflectionMatrix*vec4(coords,1));\n#endif\n#ifdef REFLECTIONMAP_CUBIC\nvec3 viewDir=worldPos.xyz-vEyePosition;\nvec3 coords=reflect(viewDir,worldNormal);\n#ifdef INVERTCUBICMAP\ncoords.y=1.0-coords.y;\n#endif\nreturn vec3(reflectionMatrix*vec4(coords,0));\n#endif\n#ifdef REFLECTIONMAP_PROJECTION\nreturn vec3(reflectionMatrix*(view*worldPos));\n#endif\n#ifdef REFLECTIONMAP_SKYBOX\nreturn vPositionUVW;\n#endif\n#ifdef REFLECTIONMAP_EXPLICIT\nreturn vec3(0,0,0);\n#endif\n}",
		"shadowsFragmentFunctions" => "#ifdef SHADOWS\nfloat unpack(vec4 color)\n{\nconst vec4 bit_shift=vec4(1.0/(255.0*255.0*255.0),1.0/(255.0*255.0),1.0/255.0,1.0);\nreturn dot(color,bit_shift);\n}\n#if defined(POINTLIGHT0) || defined(POINTLIGHT1) || defined(POINTLIGHT2) || defined(POINTLIGHT3)\nuniform vec2 depthValues;\nfloat computeShadowCube(vec3 lightPosition,samplerCube shadowSampler,float darkness,float bias)\n{\nvec3 directionToLight=vPositionW-lightPosition;\nfloat depth=length(directionToLight);\ndepth=(depth-depthValues.x)/(depthValues.y-depthValues.x);\ndepth=clamp(depth,0.,1.0);\ndirectionToLight=normalize(directionToLight);\ndirectionToLight.y=-directionToLight.y;\nfloat shadow=unpack(textureCube(shadowSampler,directionToLight))+bias;\nif (depth>shadow)\n{\nreturn darkness;\n}\nreturn 1.0;\n}\nfloat computeShadowWithPCFCube(vec3 lightPosition,samplerCube shadowSampler,float mapSize,float bias,float darkness)\n{\nvec3 directionToLight=vPositionW-lightPosition;\nfloat depth=length(directionToLight);\ndepth=(depth-depthValues.x)/(depthValues.y-depthValues.x);\ndepth=clamp(depth,0.,1.0);\ndirectionToLight=normalize(directionToLight);\ndirectionToLight.y=-directionToLight.y;\nfloat visibility=1.;\nvec3 poissonDisk[4];\npoissonDisk[0]=vec3(-1.0,1.0,-1.0);\npoissonDisk[1]=vec3(1.0,-1.0,-1.0);\npoissonDisk[2]=vec3(-1.0,-1.0,-1.0);\npoissonDisk[3]=vec3(1.0,-1.0,1.0);\n\nfloat biasedDepth=depth-bias;\nif (unpack(textureCube(shadowSampler,directionToLight+poissonDisk[0]*mapSize))<biasedDepth) visibility-=0.25;\nif (unpack(textureCube(shadowSampler,directionToLight+poissonDisk[1]*mapSize))<biasedDepth) visibility-=0.25;\nif (unpack(textureCube(shadowSampler,directionToLight+poissonDisk[2]*mapSize))<biasedDepth) visibility-=0.25;\nif (unpack(textureCube(shadowSampler,directionToLight+poissonDisk[3]*mapSize))<biasedDepth) visibility-=0.25;\nreturn min(1.0,visibility+darkness);\n}\n#endif\n#if defined(SPOTLIGHT0) || defined(SPOTLIGHT1) || defined(SPOTLIGHT2) || defined(SPOTLIGHT3) || defined(DIRLIGHT0) || defined(DIRLIGHT1) || defined(DIRLIGHT2) || defined(DIRLIGHT3)\nfloat computeShadow(vec4 vPositionFromLight,sampler2D shadowSampler,float darkness,float bias)\n{\nvec3 depth=vPositionFromLight.xyz/vPositionFromLight.w;\ndepth=0.5*depth+vec3(0.5);\nvec2 uv=depth.xy;\nif (uv.x<0. || uv.x>1.0 || uv.y<0. || uv.y>1.0)\n{\nreturn 1.0;\n}\nfloat shadow=unpack(texture2D(shadowSampler,uv))+bias;\nif (depth.z>shadow)\n{\nreturn darkness;\n}\nreturn 1.;\n}\nfloat computeShadowWithPCF(vec4 vPositionFromLight,sampler2D shadowSampler,float mapSize,float bias,float darkness)\n{\nvec3 depth=vPositionFromLight.xyz/vPositionFromLight.w;\ndepth=0.5*depth+vec3(0.5);\nvec2 uv=depth.xy;\nif (uv.x<0. || uv.x>1.0 || uv.y<0. || uv.y>1.0)\n{\nreturn 1.0;\n}\nfloat visibility=1.;\nvec2 poissonDisk[4];\npoissonDisk[0]=vec2(-0.94201624,-0.39906216);\npoissonDisk[1]=vec2(0.94558609,-0.76890725);\npoissonDisk[2]=vec2(-0.094184101,-0.92938870);\npoissonDisk[3]=vec2(0.34495938,0.29387760);\n\nfloat biasedDepth=depth.z-bias;\nif (unpack(texture2D(shadowSampler,uv+poissonDisk[0]*mapSize))<biasedDepth) visibility-=0.25;\nif (unpack(texture2D(shadowSampler,uv+poissonDisk[1]*mapSize))<biasedDepth) visibility-=0.25;\nif (unpack(texture2D(shadowSampler,uv+poissonDisk[2]*mapSize))<biasedDepth) visibility-=0.25;\nif (unpack(texture2D(shadowSampler,uv+poissonDisk[3]*mapSize))<biasedDepth) visibility-=0.25;\nreturn min(1.0,visibility+darkness);\n}\n\nfloat unpackHalf(vec2 color)\n{\nreturn color.x+(color.y/255.0);\n}\nfloat linstep(float low,float high,float v) {\nreturn clamp((v-low)/(high-low),0.0,1.0);\n}\nfloat ChebychevInequality(vec2 moments,float compare,float bias)\n{\nfloat p=smoothstep(compare-bias,compare,moments.x);\nfloat variance=max(moments.y-moments.x*moments.x,0.02);\nfloat d=compare-moments.x;\nfloat p_max=linstep(0.2,1.0,variance/(variance+d*d));\nreturn clamp(max(p,p_max),0.0,1.0);\n}\nfloat computeShadowWithVSM(vec4 vPositionFromLight,sampler2D shadowSampler,float bias,float darkness)\n{\nvec3 depth=vPositionFromLight.xyz/vPositionFromLight.w;\ndepth=0.5*depth+vec3(0.5);\nvec2 uv=depth.xy;\nif (uv.x<0. || uv.x>1.0 || uv.y<0. || uv.y>1.0 || depth.z>=1.0)\n{\nreturn 1.0;\n}\nvec4 texel=texture2D(shadowSampler,uv);\nvec2 moments=vec2(unpackHalf(texel.xy),unpackHalf(texel.zw));\nreturn min(1.0,1.0-ChebychevInequality(moments,depth.z,bias)+darkness);\n}\n#endif\n#endif",
		"shadowsVertex" => "#ifdef SHADOWS\n#if defined(SPOTLIGHT0) || defined(DIRLIGHT0)\nvPositionFromLight0=lightMatrix0*worldPos;\n#endif\n#if defined(SPOTLIGHT1) || defined(DIRLIGHT1)\nvPositionFromLight1=lightMatrix1*worldPos;\n#endif\n#if defined(SPOTLIGHT2) || defined(DIRLIGHT2)\nvPositionFromLight2=lightMatrix2*worldPos;\n#endif\n#if defined(SPOTLIGHT3) || defined(DIRLIGHT3)\nvPositionFromLight3=lightMatrix3*worldPos;\n#endif\n#endif",
		"shadowsVertexDeclaration" => "#ifdef SHADOWS\n#if defined(SPOTLIGHT0) || defined(DIRLIGHT0)\nuniform mat4 lightMatrix0;\nvarying vec4 vPositionFromLight0;\n#endif\n#if defined(SPOTLIGHT1) || defined(DIRLIGHT1)\nuniform mat4 lightMatrix1;\nvarying vec4 vPositionFromLight1;\n#endif\n#if defined(SPOTLIGHT2) || defined(DIRLIGHT2)\nuniform mat4 lightMatrix2;\nvarying vec4 vPositionFromLight2;\n#endif\n#if defined(SPOTLIGHT3) || defined(DIRLIGHT3)\nuniform mat4 lightMatrix3;\nvarying vec4 vPositionFromLight3;\n#endif\n#endif"
	];
	
}
