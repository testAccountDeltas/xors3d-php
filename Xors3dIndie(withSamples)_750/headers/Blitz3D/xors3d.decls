; *****************************************************************
; *                                                               *
; * Xors3d Engine declaration file for Blitz3D, (c) 2012 XorsTeam *
; * www:    http://xors3d.com                                     *
; * e-mail: support@xors3d.com                                    *
; *                                                               *
; *****************************************************************

.lib "xors3d.dll"

; 3dlines commands
xCreateLine3D_%(fromX#, fromY#, fromZ#, toX#, toY#, toZ#, red%, green%, blue%, alpha%, useZBuffer%):"_xCreateLine3D@44"
xCreateLine3D%(fromX#, fromY#, fromZ#, toX#, toY#, toZ#, red%, green%, blue%, alpha%, useZBuffer%)
xLine3DOrigin_(line3d%, x#, y#, z#, isGlobal%):"_xLine3DOrigin@20"
xLine3DOrigin(line3d%, x#, y#, z#, isGlobal%)
xLine3DAddNode_(line3d%, x#, y#, z#, isGlobal%):"_xLine3DAddNode@20"
xLine3DAddNode(line3d%, x#, y#, z#, isGlobal%)
xLine3DColor(line3d%, red%, green%, blue%, alpha%):"_xLine3DColor@20"
xLine3DUseZBuffer(line3d%, state%):"_xLine3DUseZBuffer@8"
xLine3DOriginX_#(line3d%, isGlobal%):"_xLine3DOriginX@8"
xLine3DOriginX#(line3d%, isGlobal%)
xLine3DOriginY_#(line3d%, isGlobal%):"_xLine3DOriginY@8"
xLine3DOriginY#(line3d%, isGlobal%)
xLine3DOriginZ_#(line3d%, isGlobal%):"_xLine3DOriginZ@8"
xLine3DOriginZ#(line3d%, isGlobal%)
xLine3DNodesCount%(line3d%):"_xLine3DNodesCount@4"
xLine3DNodePosition_(line3d%, index%, x#, y#, z#, isGlobal%):"_xLine3DNodePosition@24"
xLine3DNodePosition(line3d%, index%, x#, y#, z#, isGlobal%)
xLine3DNodeX_#(line3d%, index%, isGlobal%):"_xLine3DNodeX@12"
xLine3DNodeX#(line3d%, index%, isGlobal%)
xLine3DNodeY_#(line3d%, index%, isGlobal%):"_xLine3DNodeY@12"
xLine3DNodeY#(line3d%, index%, isGlobal%)
xLine3DNodeZ_#(line3d%, index%, isGlobal%):"_xLine3DNodeZ@12"
xLine3DNodeZ#(line3d%, index%, isGlobal%)
xLine3DRed%(line3d%):"_xLine3DRed@4"
xLine3DGreen%(line3d%):"_xLine3DGreen@4"
xLine3DBlue%(line3d%):"_xLine3DBlue@4"
xLine3DAlpha%(line3d%):"_xLine3DAlpha@4"
xGetLine3DUseZBuffer%(line3d%):"_xGetLine3DUseZBuffer@4"
xDeleteLine3DNode(line3d%, index%):"_xDeleteLine3DNode@8"
xClearLine3D(line3d%):"_xClearLine3D@4"

; brushes commands
xLoadBrush_%(path$, flags%, xScale#, yScale#):"_xLoadBrush@16"
xLoadBrush%(path$, flags%, xScale#, yScale#)
xCreateBrush_%(red#, green#, blue#):"_xCreateBrush@12"
xCreateBrush%(red#, green#, blue#)
xFreeBrush(brush%):"_xFreeBrush@4"
xGetBrushTexture_%(brush%, index%):"_xGetBrushTexture@8"
xGetBrushTexture%(brush%, index%)
xBrushColor(brush%, red%, green%, blue%):"_xBrushColor@16"
xBrushAlpha(brush%, alpha#):"_xBrushAlpha@8"
xBrushShininess(brush%, shininess#):"_xBrushShininess@8"
xBrushBlend(brush%, blend%):"_xBrushBlend@8"
xBrushFX(brush%, FX%):"_xBrushFX@8"
xBrushTexture_(brush%, texture%, frame%, index%):"_xBrushTexture@16"
xBrushTexture(brush%, texture%, frame%, index%)
xGetBrushName$(brush%):"_xGetBrushName@4"
xBrushName(brush%, name$):"_xBrushName@8"
xGetBrushAlpha#(brush%):"_xGetBrushAlpha@4"
xGetBrushBlend%(brush%):"_xGetBrushBlend@4"
xGetBrushRed%(brush%):"_xGetBrushRed@4"
xGetBrushGreen%(brush%):"_xGetBrushGreen@4"
xGetBrushBlue%(brush%):"_xGetBrushBlue@4"
xGetBrushFX%(brush%):"_xGetBrushFX@4"
xGetBrushShininess#(brush%):"_xGetBrushShininess@4"

; cameras commands
xCameraFogMode(camera%, mode%):"_xCameraFogMode@8"
xCameraFogColor(camera%, red%, green%, blue%):"_xCameraFogColor@16"
xCameraFogRange(camera%, nearRange#, farRange#):"_xCameraFogRange@12"
xCameraClsColor_(camera%, red%, green%, blue%, alpha%):"_xCameraClsColor@20"
xCameraClsColor(camera%, red%, green%, blue%, alpha%)
xCameraProjMode(camera%, mode%):"_xCameraProjMode@8"
xCameraClsMode(camera%, clearColor%, clearZBuffer%):"_xCameraClsMode@12"
xSphereInFrustum%(camera%, x#, y#, z#, radii#):"_xSphereInFrustum@20"
xCameraClipPlane(camera%, index%, enabled%, a#, b#, c#, d#):"_xCameraClipPlane@28"
xCameraRange(camera%, nearRange#, farRange#):"_xCameraRange@12"
xCameraViewport(camera%, x%, y%, width%, height%):"_xCameraViewport@20"
xCameraCropViewport(camera%, x%, y%, width%, height%):"_xCameraCropViewport@20"
xCreateCamera_%(parent%):"_xCreateCamera@4"
xCreateCamera%(parent%)
xCameraProject(camera%, x#, y#, z#):"_xCameraProject@16"
xCameraProject2D(camera%, x%, y%, zDistance#):"_xCameraProject2D@16"
xProjectedX#():"_xProjectedX@0"
xProjectedY#():"_xProjectedY@0"
xProjectedZ#():"_xProjectedZ@0"
xGetViewMatrix%(camera%):"_xGetViewMatrix@4"
xGetProjectionMatrix%(camera%):"_xGetProjectionMatrix@4"
xCameraZoom(camera%, zoom#):"_xCameraZoom@8"
xGetViewProjMatrix%(camera%):"_xGetViewProjMatrix@4"

; collisions commands
xCollisions(srcType%, destType%, collideMethod%, response%):"_xCollisions@16"
xClearCollisions():"_xClearCollisions@0"
xResetEntity(entity%):"_xResetEntity@4"
xEntityRadius_(entity%, xRadius#, yRadius#):"_xEntityRadius@12"
xEntityRadius(entity%, xRadius#, yRadius#)
xEntityBox(entity%, x#, y#, z#, width#, height#, depth#):"_xEntityBox@28"
xEntityType_(entity%, typeID%, recurse%):"_xEntityType@12"
xEntityType(entity%, typeID%, recurse%)
xEntityCollided%(entity%, typeID%):"_xEntityCollided@8"
xCountCollisions%(entity%):"_xCountCollisions@4"
xCollisionX#(entity%, index%):"_xCollisionX@8"
xCollisionY#(entity%, index%):"_xCollisionY@8"
xCollisionZ#(entity%, index%):"_xCollisionZ@8"
xCollisionNX#(entity%, index%):"_xCollisionNX@8"
xCollisionNY#(entity%, index%):"_xCollisionNY@8"
xCollisionNZ#(entity%, index%):"_xCollisionNZ@8"
xCollisionTime#(entity%, index%):"_xCollisionTime@8"
xCollisionEntity%(entity%, index%):"_xCollisionEntity@8"
xCollisionSurface%(entity%, index%):"_xCollisionSurface@8"
xCollisionTriangle%(entity%, index%):"_xCollisionTriangle@8"
xGetEntityType%(entity%):"_xGetEntityType@4"

; constants commands
xRenderPostEffect(poly%):"_xRenderPostEffect@4"
xCreatePostEffectPoly%(camera%, mode%):"_xCreatePostEffectPoly@8"
xGetFunctionAddress%(name$):"_xGetFunctionAddress@4"

; effects commands
xLoadFXFile%(path$):"_xLoadFXFile@4"
xFreeEffect(effect%):"_xFreeEffect@4"
xSetEntityEffect_(entity%, effect%, index%):"_xSetEntityEffect@12"
xSetEntityEffect(entity%, effect%, index%)
xSetSurfaceEffect_(surface%, effect%, index%):"_xSetSurfaceEffect@12"
xSetSurfaceEffect(surface%, effect%, index%)
xSetBonesArrayName_(entity%, arrayName$, layer%):"_xSetBonesArrayName@12"
xSetBonesArrayName(entity%, arrayName$, layer%)
xSurfaceBonesArrayName_(surface%, arrayName$, layer%):"_xSurfaceBonesArrayName@12"
xSurfaceBonesArrayName(surface%, arrayName$, layer%)
xSetEffectInt_(entity%, name$, value%, layer%):"_xSetEffectInt@16"
xSetEffectInt(entity%, name$, value%, layer%)
xSurfaceEffectInt_(surface%, name$, value%, layer%):"_xSurfaceEffectInt@16"
xSurfaceEffectInt(surface%, name$, value%, layer%)
xSetEffectFloat_(entity%, name$, value#, layer%):"_xSetEffectFloat@16"
xSetEffectFloat(entity%, name$, value#, layer%)
xSurfaceEffectFloat_(surface%, name$, value#, layer%):"_xSurfaceEffectFloat@16"
xSurfaceEffectFloat(surface%, name$, value#, layer%)
xSetEffectBool_(entity%, name$, value%, layer%):"_xSetEffectBool@16"
xSetEffectBool(entity%, name$, value%, layer%)
xSurfaceEffectBool_(surface%, name$, value%, layer%):"_xSurfaceEffectBool@16"
xSurfaceEffectBool(surface%, name$, value%, layer%)
xSetEffectVector_(entity%, name$, x#, y#, z#, w#, layer%):"_xSetEffectVector@28"
xSetEffectVector(entity%, name$, x#, y#, z#, w#, layer%)
xSurfaceEffectVector_(surface%, name$, x#, y#, z#, w#, layer%):"_xSurfaceEffectVector@28"
xSurfaceEffectVector(surface%, name$, x#, y#, z#, w#, layer%)
xSetEffectVectorArray_(entity%, name$, value%, count%, layer%):"_xSetEffectVectorArray@20"
xSetEffectVectorArray(entity%, name$, value%, count%, layer%)
xSurfaceEffectVectorArray_(surface%, name$, value%, count%, layer%):"_xSurfaceEffectVectorArray@20"
xSurfaceEffectVectorArray(surface%, name$, value%, count%, layer%)
xSurfaceEffectMatrixArray_(surface%, name$, value%, count%, layer%):"_xSurfaceEffectMatrixArray@20"
xSurfaceEffectMatrixArray(surface%, name$, value%, count%, layer%)
xSurfaceEffectFloatArray_(surface%, name$, value%, count%, layer%):"_xSurfaceEffectFloatArray@20"
xSurfaceEffectFloatArray(surface%, name$, value%, count%, layer%)
xSurfaceEffectIntArray_(surface%, name$, value%, count%, layer%):"_xSurfaceEffectIntArray@20"
xSurfaceEffectIntArray(surface%, name$, value%, count%, layer%)
xSetEffectMatrixArray_(entity%, name$, value%, count%, layer%):"_xSetEffectMatrixArray@20"
xSetEffectMatrixArray(entity%, name$, value%, count%, layer%)
xSetEffectFloatArray_(entity%, name$, value%, count%, layer%):"_xSetEffectFloatArray@20"
xSetEffectFloatArray(entity%, name$, value%, count%, layer%)
xSetEffectIntArray_(entity%, name$, value%, count%, layer%):"_xSetEffectIntArray@20"
xSetEffectIntArray(entity%, name$, value%, count%, layer%)
xCreateBufferVectors%(count%):"_xCreateBufferVectors@4"
xBufferVectorsSetElement(buffer%, number%, x#, y#, z#, w#):"_xBufferVectorsSetElement@24"
xCreateBufferMatrix%(count%):"_xCreateBufferMatrix@4"
xBufferMatrixSetElement(buffer%, number%, matrix%):"_xBufferMatrixSetElement@12"
xBufferMatrixGetElement%(buffer%, number%):"_xBufferMatrixGetElement@8"
xCreateBufferFloats%(count%):"_xCreateBufferFloats@4"
xBufferFloatsSetElement(buffer%, number%, value#):"_xBufferFloatsSetElement@12"
xBufferFloatsGetElement#(buffer%, number%):"_xBufferFloatsGetElement@8"
xBufferDelete(buffer%):"_xBufferDelete@4"
xSetEffectMatrixWithElements_(entity%, name$, m11#, m12#, m13#, m14#, m21#, m22#, m23#, m24#, m31#, m32#, m33#, m34#, m41#, m42#, m43#, m44#, layer%):"_xSetEffectMatrixWithElements@76"
xSetEffectMatrixWithElements(entity%, name$, m11#, m12#, m13#, m14#, m21#, m22#, m23#, m24#, m31#, m32#, m33#, m34#, m41#, m42#, m43#, m44#, layer%)
xSetEffectMatrix_(entity%, name$, matrix%, layer%):"_xSetEffectMatrix@16"
xSetEffectMatrix(entity%, name$, matrix%, layer%)
xSurfaceEffectMatrix_(surface%, name$, matrix%, layer%):"_xSurfaceEffectMatrix@16"
xSurfaceEffectMatrix(surface%, name$, matrix%, layer%)
xSurfaceEffectMatrixWithElements_(surface%, name$, m11#, m12#, m13#, m14#, m21#, m22#, m23#, m24#, m31#, m32#, m33#, m34#, m41#, m42#, m43#, m44#, layer%):"_xSurfaceEffectMatrixWithElements@76"
xSurfaceEffectMatrixWithElements(surface%, name$, m11#, m12#, m13#, m14#, m21#, m22#, m23#, m24#, m31#, m32#, m33#, m34#, m41#, m42#, m43#, m44#, layer%)
xSetEffectEntityTexture_(entity%, name$, index%, layer%):"_xSetEffectEntityTexture@16"
xSetEffectEntityTexture(entity%, name$, index%, layer%)
xSetEffectTexture_(entity%, name$, texture%, frame%, layer%, isRecursive%):"_xSetEffectTexture@24"
xSetEffectTexture(entity%, name$, texture%, frame%, layer%, isRecursive%)
xSurfaceEffectTexture_(surface%, name$, texture%, frame%, layer%):"_xSurfaceEffectTexture@20"
xSurfaceEffectTexture(surface%, name$, texture%, frame%, layer%)
xSurfaceEffectMatrixSemantic_(surface%, name$, value%, layer%):"_xSurfaceEffectMatrixSemantic@16"
xSurfaceEffectMatrixSemantic(surface%, name$, value%, layer%)
xSetEffectMatrixSemantic_(entity%, name$, value%, layer%):"_xSetEffectMatrixSemantic@16"
xSetEffectMatrixSemantic(entity%, name$, value%, layer%)
xDeleteSurfaceConstant_(surface%, name$, layer%):"_xDeleteSurfaceConstant@12"
xDeleteSurfaceConstant(surface%, name$, layer%)
xDeleteEffectConstant_(entity%, name$, layer%):"_xDeleteEffectConstant@12"
xDeleteEffectConstant(entity%, name$, layer%)
xClearSurfaceConstants_(surface%, layer%):"_xClearSurfaceConstants@8"
xClearSurfaceConstants(surface%, layer%)
xClearEffectConstants_(entity%, layer%):"_xClearEffectConstants@8"
xClearEffectConstants(entity%, layer%)
xSetEffectTechnique_(entity%, name$, layer%):"_xSetEffectTechnique@12"
xSetEffectTechnique(entity%, name$, layer%)
xSurfaceTechnique_(surface%, name$, layer%):"_xSurfaceTechnique@12"
xSurfaceTechnique(surface%, name$, layer%)
xValidateEffectTechnique%(effect%, name$):"_xValidateEffectTechnique@8"
xSetEntityShaderLayer(entity%, layer%):"_xSetEntityShaderLayer@8"
xGetEntityShaderLayer%(entity%):"_xGetEntityShaderLayer@4"
xSetSurfaceShaderLayer(surface%, layer%):"_xSetSurfaceShaderLayer@8"
xGetSurfaceShaderLayer%(surface%):"_xGetSurfaceShaderLayer@4"
xSetFXInt(effect%, name$, value%):"_xSetFXInt@12"
xSetFXFloat(effect%, name$, value#):"_xSetFXFloat@12"
xSetFXBool(effect%, name$, value%):"_xSetFXBool@12"
xSetFXVector_(effect%, name$, x#, y#, z#, w#):"_xSetFXVector@24"
xSetFXVector(effect%, name$, x#, y#, z#, w#)
xSetFXVectorArray(effect%, name$, value%, count%):"_xSetFXVectorArray@16"
xSetFXMatrixArray(effect%, name$, value%, count%):"_xSetFXMatrixArray@16"
xSetFXFloatArray(effect%, name$, value%, count%):"_xSetFXFloatArray@16"
xSetFXIntArray(effect%, name$, value%, count%):"_xSetFXIntArray@16"
xSetFXEntityMatrix(effect%, name$, matrix%):"_xSetFXEntityMatrix@12"
xSetFXTexture_(effect%, name$, texture%, frame%):"_xSetFXTexture@16"
xSetFXTexture(effect%, name$, texture%, frame%)
xSetFXMatrixSemantic(effect%, name$, value%):"_xSetFXMatrixSemantic@12"
xDeleteFXConstant(effect%, name$):"_xDeleteFXConstant@8"
xClearFXConstants(effect%):"_xClearFXConstants@4"
xSetFXTechnique(effect%, name$):"_xSetFXTechnique@8"

; emitters commands
xCreateEmitter_%(psystem%, parent%):"_xCreateEmitter@8"
xCreateEmitter%(psystem%, parent%)
xEmitterEnable(emitter%, state%):"_xEmitterEnable@8"
xEmitterEnabled%(emitter%):"_xEmitterEnabled@4"
xEmitterGetPSystem%(emitter%):"_xEmitterGetPSystem@4"
xEmitterAddParticle%(emitter%):"_xEmitterAddParticle@4"
xEmitterFreeParticle(emitter%, particle%):"_xEmitterFreeParticle@8"
xEmitterValidateParticle%(emitter%, particle%):"_xEmitterValidateParticle@8"
xEmitterCountParticles%(emitter%):"_xEmitterCountParticles@4"
xEmitterGetParticle%(emitter%, index%):"_xEmitterGetParticle@8"
xEmitterAlive%(emitter%):"_xEmitterAlive@4"

; entity_animation commands
xExtractAnimSeq_%(entity%, firstFrame%, lastFrame%, sequence%):"_xExtractAnimSeq@16"
xExtractAnimSeq%(entity%, firstFrame%, lastFrame%, sequence%)
xLoadAnimSeq%(entity%, path$):"_xLoadAnimSeq@8"
xSetAnimSpeed_(entity%, speed#, rootBone$):"_xSetAnimSpeed@12"
xSetAnimSpeed(entity%, speed#, rootBone$)
xAnimSpeed_#(entity%, rootBone$):"_xAnimSpeed@8"
xAnimSpeed#(entity%, rootBone$)
xAnimating_%(entity%, rootBone$):"_xAnimating@8"
xAnimating%(entity%, rootBone$)
xAnimTime_#(entity%, rootBone$):"_xAnimTime@8"
xAnimTime#(entity%, rootBone$)
xAnimate_(entity%, mode%, speed#, sequence%, translate#, rootBone$):"_xAnimate@24"
xAnimate(entity%, mode%, speed#, sequence%, translate#, rootBone$)
xAnimSeq_%(entity%, rootBone$):"_xAnimSeq@8"
xAnimSeq%(entity%, rootBone$)
xAnimLength_#(entity%, rootBone$):"_xAnimLength@8"
xAnimLength#(entity%, rootBone$)
xSetAnimTime_(entity%, time#, sequence%, rootBone$):"_xSetAnimTime@16"
xSetAnimTime(entity%, time#, sequence%, rootBone$)
xSetAnimFrame_(entity%, frame#, sequence%, rootBone$):"_xSetAnimFrame@16"
xSetAnimFrame(entity%, frame#, sequence%, rootBone$)

; entity_control commands
xEntityAutoFade(entity%, nearRange#, farRange#):"_xEntityAutoFade@12"
xEntityOrder(entity%, order%):"_xEntityOrder@8"
xFreeEntity(entity%):"_xFreeEntity@4"
xCopyEntity_%(entity%, parent%, cloneBuffers%):"_xCopyEntity@12"
xCopyEntity%(entity%, parent%, cloneBuffers%)
xPaintEntity(entity%, brush%):"_xPaintEntity@8"
xEntityShininess(entity%, shininess#):"_xEntityShininess@8"
xEntityPickMode_(entity%, mode%, obscurer%, recursive%):"_xEntityPickMode@16"
xEntityPickMode(entity%, mode%, obscurer%, recursive%)
xEntityTexture_(entity%, texture%, frame%, index%, isRecursive%):"_xEntityTexture@20"
xEntityTexture(entity%, texture%, frame%, index%, isRecursive%)
xEntityFX(entity%, fx%):"_xEntityFX@8"
xGetParent%(entity%):"_xGetParent@4"
xSetFrustumSphere(entity%, x#, y#, z#, radii#):"_xSetFrustumSphere@20"
xCalculateFrustumVolume(entity%):"_xCalculateFrustumVolume@4"
xEntityParent_(entity%, parent%, isGlobal%):"_xEntityParent@12"
xEntityParent(entity%, parent%, isGlobal%)
xShowEntity(entity%):"_xShowEntity@4"
xHideEntity(entity%):"_xHideEntity@4"
xNameEntity(entity%, name$):"_xNameEntity@8"
xSetEntityQuaternion(entity%, quaternion%):"_xSetEntityQuaternion@8"
xSetEntityMatrix(entity%, matrix%):"_xSetEntityMatrix@8"
xEntityAlpha(entity%, alpha#):"_xEntityAlpha@8"
xEntityColor(entity%, red%, green%, blue%):"_xEntityColor@16"
xEntitySpecularColor(entity%, red%, green%, blue%):"_xEntitySpecularColor@16"
xEntityAmbientColor(entity%, red%, green%, blue%):"_xEntityAmbientColor@16"
xEntityEmissiveColor(entity%, red%, green%, blue%):"_xEntityEmissiveColor@16"
xEntityBlend(entity%, mode%):"_xEntityBlend@8"
xEntityAlphaRef(entity%, value%):"_xEntityAlphaRef@8"
xEntityAlphaFunc(entity%, value%):"_xEntityAlphaFunc@8"
xCreateInstance_%(entity%, parent%):"_xCreateInstance@8"
xCreateInstance%(entity%, parent%)
xFreezeInstances_(entity%, enable%):"_xFreezeInstances@8"
xFreezeInstances(entity%, enable%)
xInstancingAvaliable%():"_xInstancingAvaliable@0"
xGetEntityWorld%(entity%):"_xGetEntityWorld@4"
xSetEntityWorld(entity%, world%):"_xSetEntityWorld@8"

; entity_movement commands
xScaleEntity_(entity%, x#, y#, z#, isGlobal%):"_xScaleEntity@20"
xScaleEntity(entity%, x#, y#, z#, isGlobal%)
xPositionEntity_(entity%, x#, y#, z#, isGlobal%):"_xPositionEntity@20"
xPositionEntity(entity%, x#, y#, z#, isGlobal%)
xMoveEntity_(entity%, x#, y#, z#, isGlobal%):"_xMoveEntity@20"
xMoveEntity(entity%, x#, y#, z#, isGlobal%)
xTranslateEntity_(entity%, x#, y#, z#, isGlobal%):"_xTranslateEntity@20"
xTranslateEntity(entity%, x#, y#, z#, isGlobal%)
xRotateEntity_(entity%, x#, y#, z#, isGlobal%):"_xRotateEntity@20"
xRotateEntity(entity%, x#, y#, z#, isGlobal%)
xTurnEntity_(entity%, x#, y#, z#, isGlobal%):"_xTurnEntity@20"
xTurnEntity(entity%, x#, y#, z#, isGlobal%)
xPointEntity_(entity1%, entity2%, roll#):"_xPointEntity@12"
xPointEntity(entity1%, entity2%, roll#)
xAlignToVector_(entity%, x#, y#, z#, axis%, factor#):"_xAlignToVector@24"
xAlignToVector(entity%, x#, y#, z#, axis%, factor#)

; entity_state commands
xEntityDistance#(entity1%, entity2%):"_xEntityDistance@8"
xGetMatElement#(entity%, row%, col%):"_xGetMatElement@12"
xEntityClass$(entity%):"_xEntityClass@4"
xGetEntityBrush%(entity%):"_xGetEntityBrush@4"
xEntityX_#(entity%, isGlobal%):"_xEntityX@8"
xEntityX#(entity%, isGlobal%)
xEntityY_#(entity%, isGlobal%):"_xEntityY@8"
xEntityY#(entity%, isGlobal%)
xEntityZ_#(entity%, isGlobal%):"_xEntityZ@8"
xEntityZ#(entity%, isGlobal%)
xEntityVisible%(entity%, destination%):"_xEntityVisible@8"
xEntityScaleX#(entity%):"_xEntityScaleX@4"
xEntityScaleY#(entity%):"_xEntityScaleY@4"
xEntityScaleZ#(entity%):"_xEntityScaleZ@4"
xEntityRoll_#(entity%, isGlobal%):"_xEntityRoll@8"
xEntityRoll#(entity%, isGlobal%)
xEntityYaw_#(entity%, isGlobal%):"_xEntityYaw@8"
xEntityYaw#(entity%, isGlobal%)
xEntityPitch_#(entity%, isGlobal%):"_xEntityPitch@8"
xEntityPitch#(entity%, isGlobal%)
xEntityName$(entity%):"_xEntityName@4"
xCountChildren%(entity%):"_xCountChildren@4"
xGetChild%(entity%, index%):"_xGetChild@8"
xEntityInView%(entity%, camera%):"_xEntityInView@8"
xFindChild%(entity%, name$):"_xFindChild@8"
xGetEntityMatrix%(entity%):"_xGetEntityMatrix@4"
xGetEntityAlpha#(entity%):"_xGetEntityAlpha@4"
xGetAlphaRef%(entity%):"_xGetAlphaRef@4"
xGetAlphaFunc%(entity%):"_xGetAlphaFunc@4"
xEntityRed%(entity%):"_xEntityRed@4"
xEntityGreen%(entity%):"_xEntityGreen@4"
xEntityBlue%(entity%):"_xEntityBlue@4"
xGetEntityShininess#(entity%):"_xGetEntityShininess@4"
xGetEntityBlend%(entity%):"_xGetEntityBlend@4"
xGetEntityFX%(entity%):"_xGetEntityFX@4"
xEntityHidden%(entity%):"_xEntityHidden@4"
xEntitiesBBIntersect%(entity1%, entity2%):"_xEntitiesBBIntersect@8"

; filesystems commands
xMountPackFile_%(path$, mountpoint$, password$):"_xMountPackFile@12"
xMountPackFile%(path$, mountpoint$, password$)
xUnmountPackFile(packfile%):"_xUnmountPackFile@4"
xOpenFile%(path$):"_xOpenFile@4"
xReadFile%(path$):"_xReadFile@4"
xWriteFile%(path$):"_xWriteFile@4"
xCloseFile(file%):"_xCloseFile@4"
xFilePos%(file%):"_xFilePos@4"
xSeekFile(file%, offset%):"_xSeekFile@8"
xFileType%(path$):"_xFileType@4"
xFileSize%(path$):"_xFileSize@4"
xFileCreationTime%(path$):"_xFileCreationTime@4"
xFileCreationTimeStr$(path$):"_xFileCreationTimeStr@4"
xFileModificationTime%(path$):"_xFileModificationTime@4"
xFileModificationTimeStr$(path$):"_xFileModificationTimeStr@4"
xReadDir%(path$):"_xReadDir@4"
xCloseDir(handle%):"_xCloseDir@4"
xNextFile$(handle%):"_xNextFile@4"
xCurrentDir$():"_xCurrentDir@0"
xChangeDir(path$):"_xChangeDir@4"
xCreateDir%(path$):"_xCreateDir@4"
xDeleteDir%(path$):"_xDeleteDir@4"
xCopyFile%(pathSrc$, pathDest$):"_xCopyFile@8"
xDeleteFile%(path$):"_xDeleteFile@4"
xEof%(file%):"_xEof@4"
xReadByte%(file%):"_xReadByte@4"
xReadShort%(file%):"_xReadShort@4"
xReadInt%(file%):"_xReadInt@4"
xReadFloat#(file%):"_xReadFloat@4"
xReadString$(file%):"_xReadString@4"
xReadLine_$(file%, ls_flag%):"_xReadLine@8"
xReadLine$(file%, ls_flag%)
xWriteByte(file%, value%):"_xWriteByte@8"
xWriteShort(file%, value%):"_xWriteShort@8"
xWriteInt(file%, value%):"_xWriteInt@8"
xWriteFloat(file%, value#):"_xWriteFloat@8"
xWriteString(file%, value$):"_xWriteString@8"
xWriteLine_(file%, value$, ls_flag%):"_xWriteLine@12"
xWriteLine(file%, value$, ls_flag%)

; fonts commands
xLoadFont_%(name$, height%, bold%, italic%, underline%, fontface$):"_xLoadFont@24"
xLoadFont%(name$, height%, bold%, italic%, underline%, fontface$)
xText_(x#, y#, textString$, centerx%, centery%):"_xText@20"
xText(x#, y#, textString$, centerx%, centery%)
xSetFont(font%):"_xSetFont@4"
xFreeFont(font%):"_xFreeFont@4"
xFontWidth%():"_xFontWidth@0"
xFontHeight%():"_xFontHeight@0"
xStringWidth%(textString$):"_xStringWidth@4"
xStringHeight%(textString$):"_xStringHeight@4"

; graphics commands
xWinMessage%(message$):"_xWinMessage@4"
xGetMaxPixelShaderVersion%():"_xGetMaxPixelShaderVersion@0"
xLine(x1%, y1%, x2%, y2%):"_xLine@16"
xRect_(x%, y%, width%, height%, solid%):"_xRect@20"
xRect(x%, y%, width%, height%, solid%)
xRectsOverlap%(x1%, y1%, width1%, height1%, x2%, y2%, width2%, height2%):"_xRectsOverlap@32"
xViewport(x%, y%, width%, height%):"_xViewport@16"
xOval_(x%, y%, width%, height%, solid%):"_xOval@20"
xOval(x%, y%, width%, height%, solid%)
xOrigin(x%, y%):"_xOrigin@8"
xGetMaxVertexShaderVersion%():"_xGetMaxVertexShaderVersion@0"
xGetMaxAntiAlias%():"_xGetMaxAntiAlias@0"
xGetMaxTextureFiltering%():"_xGetMaxTextureFiltering@0"
xSetAntiAliasType(typeID%):"_xSetAntiAliasType@4"
xAppTitle(title$):"_xAppTitle@4"
xSetWND(window%):"_xSetWND@4"
xSetRenderWindow(window%):"_xSetRenderWindow@4"
xSetTopWindow(window%):"_xSetTopWindow@4"
xDestroyRenderWindow():"_xDestroyRenderWindow@0"
xFlip():"_xFlip@0"
xBackBuffer%():"_xBackBuffer@0"
xLockBuffer_(buffer%):"_xLockBuffer@4"
xLockBuffer(buffer%)
xUnlockBuffer_(buffer%):"_xUnlockBuffer@4"
xUnlockBuffer(buffer%)
xWritePixelFast_(x%, y%, argb%, buffer%):"_xWritePixelFast@16"
xWritePixelFast(x%, y%, argb%, buffer%)
xReadPixelFast_%(x%, y%, buffer%):"_xReadPixelFast@12"
xReadPixelFast%(x%, y%, buffer%)
xGetPixels_%(buffer%):"_xGetPixels@4"
xGetPixels%(buffer%)
xSaveBuffer(buffer%, path$):"_xSaveBuffer@8"
xGetCurrentBuffer%():"_xGetCurrentBuffer@0"
xBufferWidth_%(buffer%):"_xBufferWidth@4"
xBufferWidth%(buffer%)
xBufferHeight_%(buffer%):"_xBufferHeight@4"
xBufferHeight%(buffer%)
xCatchTimestamp%():"_xCatchTimestamp@0"
xGetElapsedTime#(timeStamp%):"_xGetElapsedTime@4"
xSetBuffer_(buffer%):"_xSetBuffer@4"
xSetBuffer(buffer%)
xSetMRT(buffer%, frame%, index%):"_xSetMRT@12"
xUnSetMRT():"_xUnSetMRT@0"
xGetNumberRT%():"_xGetNumberRT@0"
xTextureBuffer_%(texture%, frame%):"_xTextureBuffer@8"
xTextureBuffer%(texture%, frame%)
xLoadBuffer(buffer%, path$):"_xLoadBuffer@8"
xWritePixel_(x%, y%, argb%, buffer%):"_xWritePixel@16"
xWritePixel(x%, y%, argb%, buffer%)
xCopyPixel(sx%, sy%, sourceBuffer%, dx%, dy%, destinationBuffer%):"_xCopyPixel@24"
xCopyPixelFast(sx%, sy%, sourceBuffer%, dx%, dy%, destinationBuffer%):"_xCopyPixelFast@24"
xCopyRect(sx%, sy%, sw%, sh%, dx%, dy%, sourceBuffer%, destinationBuffer%):"_xCopyRect@32"
xGraphicsBuffer%():"_xGraphicsBuffer@0"
xGetColor%(x%, y%):"_xGetColor@8"
xReadPixel_%(x%, y%, buffer%):"_xReadPixel@12"
xReadPixel%(x%, y%, buffer%)
xGraphicsWidth_%(isVirtual%):"_xGraphicsWidth@4"
xGraphicsWidth%(isVirtual%)
xGraphicsHeight_%(isVirtual%):"_xGraphicsHeight@4"
xGraphicsHeight%(isVirtual%)
xGraphicsDepth%():"_xGraphicsDepth@0"
xColorAlpha%():"_xColorAlpha@0"
xColorRed%():"_xColorRed@0"
xColorGreen%():"_xColorGreen@0"
xColorBlue%():"_xColorBlue@0"
xClsColor_(red%, green%, blue%, alpha%):"_xClsColor@16"
xClsColor(red%, green%, blue%, alpha%)
xClearWorld_(entities%, brushes%, textures%):"_xClearWorld@12"
xClearWorld(entities%, brushes%, textures%)
xColor_(red%, green%, blue%, alpha%):"_xColor@16"
xColor(red%, green%, blue%, alpha%)
xCls():"_xCls@0"
xUpdateWorld_(speed#):"_xUpdateWorld@4"
xUpdateWorld(speed#)
xRenderEntity_(camera%, entity%, tween#):"_xRenderEntity@12"
xRenderEntity(camera%, entity%, tween#)
xRenderWorld_(tween#, renderShadows%):"_xRenderWorld@8"
xRenderWorld(tween#, renderShadows%)
xSetAutoTB(flag%):"_xSetAutoTB@4"
xMaxClipPlanes%():"_xMaxClipPlanes@0"
xWireframe(state%):"_xWireframe@4"
xDither(state%):"_xDither@4"
xSetSkinningMethod(skinMethod%):"_xSetSkinningMethod@4"
xTrisRendered%():"_xTrisRendered@0"
xDIPCounter%():"_xDIPCounter@0"
xSurfRendered%():"_xSurfRendered@0"
xEntityRendered%():"_xEntityRendered@0"
xAmbientLight_(red%, green%, blue%, world%):"_xAmbientLight@16"
xAmbientLight(red%, green%, blue%, world%)
xGetFPS%():"_xGetFPS@0"
xAntiAlias(state%):"_xAntiAlias@4"
xSetTextureFiltering(filter%):"_xSetTextureFiltering@4"
xStretchRect(texture1%, x1%, y1%, width1%, height1%, texture2%, x2%, y2%, width2%, height2%, filter%):"_xStretchRect@44"
xStretchBackBuffer(texture%, x%, y%, width%, height%, filter%):"_xStretchBackBuffer@24"
xGetDevice%():"_xGetDevice@0"
xReleaseGraphics():"_xReleaseGraphics@0"
xShowPointer():"_xShowPointer@0"
xHidePointer():"_xHidePointer@0"
xCreateDSS(width%, height%):"_xCreateDSS@8"
xDeleteDSS():"_xDeleteDSS@0"
xGridColor(centerRed%, centerGreen%, centerBlue%, gridRed%, gridGreen%, gridBlue%):"_xGridColor@24"
xDrawGrid(x#, z#, gridSize%, range%):"_xDrawGrid@16"
xDrawBBox(draw%, zOn%, red%, green%, blue%, alpha%):"_xDrawBBox@24"
xGraphics3D_(width%, height%, depth%, mode%, vsync%):"_xGraphics3D@20"
xGraphics3D(width%, height%, depth%, mode%, vsync%)
xGraphicsAspectRatio(aspectRatio#):"_xGraphicsAspectRatio@4"
xGraphicsBorderColor(red%, green%, blue%):"_xGraphicsBorderColor@12"
xGetRenderWindow%():"_xGetRenderWindow@0"
xKey(key$):"_xKey@4"
xSetEngineSetting(parameter$, value$):"_xSetEngineSetting@8"
xGetEngineSetting$(parameter$):"_xGetEngineSetting@4"
xHWInstancingAvailable%():"_xHWInstancingAvailable@0"
xShaderInstancingAvailable%():"_xShaderInstancingAvailable@0"
xSetShaderLayer(layer%):"_xSetShaderLayer@4"
xGetShaderLayer%():"_xGetShaderLayer@0"
xDrawMovementGizmo_(x#, y#, z#, selectMask%):"_xDrawMovementGizmo@16"
xDrawMovementGizmo(x#, y#, z#, selectMask%)
xDrawScaleGizmo_(x#, y#, z#, selectMask%, sx#, sy#, sz#):"_xDrawScaleGizmo@28"
xDrawScaleGizmo(x#, y#, z#, selectMask%, sx#, sy#, sz#)
xDrawRotationGizmo_(x#, y#, z#, selectMask%, pitch#, yaw#, roll#):"_xDrawRotationGizmo@28"
xDrawRotationGizmo(x#, y#, z#, selectMask%, pitch#, yaw#, roll#)
xCheckMovementGizmo%(x#, y#, z#, camera%, mx%, my%):"_xCheckMovementGizmo@24"
xCheckScaleGizmo%(x#, y#, z#, camera%, mx%, my%):"_xCheckScaleGizmo@24"
xCheckRotationGizmo%(x#, y#, z#, camera%, mx%, my%):"_xCheckRotationGizmo@24"
xCaptureWorld():"_xCaptureWorld@0"
xCountGfxModes%():"_xCountGfxModes@0"
xGfxModeWidth%(mode%):"_xGfxModeWidth@4"
xGfxModeHeight%(mode%):"_xGfxModeHeight@4"
xGfxModeDepth%(mode%):"_xGfxModeDepth@4"
xGfxModeExists%(width%, height%, depth%):"_xGfxModeExists@12"
xAppWindowFrame(state%):"_xAppWindowFrame@4"
xMillisecs%():"_xMillisecs@0"
xDeltaTime_%(fromInit%):"_xDeltaTime@4"
xDeltaTime%(fromInit%)
xDeltaValue_#(value#, time%):"_xDeltaValue@8"
xDeltaValue#(value#, time%)
xAddDeviceLostCallback(func%):"_xAddDeviceLostCallback@4"
xDeleteDeviceLostCallback(func%):"_xDeleteDeviceLostCallback@4"
xDeinit():"_xDeinit@0"

; images commands
xImageColor(image%, red%, green%, blue%):"_xImageColor@16"
xImageAlpha(image%, alpha#):"_xImageAlpha@8"
xImageBuffer_%(image%, frame%):"_xImageBuffer@8"
xImageBuffer%(image%, frame%)
xCreateImage_%(width%, height%, frame%):"_xCreateImage@12"
xCreateImage%(width%, height%, frame%)
xGrabImage_(image%, x%, y%, frame%):"_xGrabImage@16"
xGrabImage(image%, x%, y%, frame%)
xFreeImage(image%):"_xFreeImage@4"
xLoadImage%(path$):"_xLoadImage@4"
xLoadAnimImage%(path$, width%, height%, startFrame%, frames%):"_xLoadAnimImage@20"
xSaveImage_(image%, path$, frame%):"_xSaveImage@12"
xSaveImage(image%, path$, frame%)
xDrawImage_(image%, x#, y#, frame%):"_xDrawImage@16"
xDrawImage(image%, x#, y#, frame%)
xDrawImageRect_(image%, x#, y#, rectx#, recty#, rectWidth#, rectHeight#, frame%):"_xDrawImageRect@32"
xDrawImageRect(image%, x#, y#, rectx#, recty#, rectWidth#, rectHeight#, frame%)
xScaleImage(image%, x#, y#):"_xScaleImage@12"
xResizeImage(image%, width#, height#):"_xResizeImage@12"
xRotateImage(image%, angle#):"_xRotateImage@8"
xImageAngle#(image%):"_xImageAngle@4"
xImageWidth%(image%):"_xImageWidth@4"
xImageHeight%(image%):"_xImageHeight@4"
xImagesCollide%(image1%, x1%, y1%, frame1%, image2%, x2%, y2%, frame2%):"_xImagesCollide@32"
xImageRectCollide%(image%, x%, y%, frame%, rectx%, recty%, rectWidth%, rectHeight%):"_xImageRectCollide@32"
xImageRectOverlap%(image%, x#, y#, rectx#, recty#, rectWidth#, rectHeight#):"_xImageRectOverlap@28"
xImageXHandle%(image%):"_xImageXHandle@4"
xImageYHandle%(image%):"_xImageYHandle@4"
xHandleImage(image%, x#, y#):"_xHandleImage@12"
xMidHandle(image%):"_xMidHandle@4"
xAutoMidHandle(state%):"_xAutoMidHandle@4"
xTileImage_(image%, x#, y#, frame%):"_xTileImage@16"
xTileImage(image%, x#, y#, frame%)
xImagesOverlap%(image1%, x1#, y1#, image2%, x2#, y2#):"_xImagesOverlap@24"
xMaskImage(image%, red%, green%, blue%):"_xMaskImage@16"
xCopyImage%(image%):"_xCopyImage@4"
xDrawBlock_(image%, x#, y#, frame%):"_xDrawBlock@16"
xDrawBlock(image%, x#, y#, frame%)
xDrawBlockRect_(image%, x#, y#, rectx#, recty#, rectWidth#, rectHeight#, frame%):"_xDrawBlockRect@32"
xDrawBlockRect(image%, x#, y#, rectx#, recty#, rectWidth#, rectHeight#, frame%)
xImageActualWidth%(image%):"_xImageActualWidth@4"
xImageActualHeight%(image%):"_xImageActualHeight@4"

; inputs commands
xFlushKeys():"_xFlushKeys@0"
xFlushMouse():"_xFlushMouse@0"
xKeyHit%(key%):"_xKeyHit@4"
xKeyUp%(key%):"_xKeyUp@4"
xWaitKey():"_xWaitKey@0"
xMouseHit%(key%):"_xMouseHit@4"
xKeyDown%(key%):"_xKeyDown@4"
xGetKey%():"_xGetKey@0"
xMouseDown%(key%):"_xMouseDown@4"
xMouseUp%(key%):"_xMouseUp@4"
xGetMouse%():"_xGetMouse@0"
xMouseX%():"_xMouseX@0"
xMouseY%():"_xMouseY@0"
xMouseZ%():"_xMouseZ@0"
xMouseXSpeed%():"_xMouseXSpeed@0"
xMouseYSpeed%():"_xMouseYSpeed@0"
xMouseZSpeed%():"_xMouseZSpeed@0"
xMouseSpeed%():"_xMouseSpeed@0"
xMoveMouse(x%, y%):"_xMoveMouse@8"

; joysticks commands
xJoyType_%(portID%):"_xJoyType@4"
xJoyType%(portID%)
xJoyDown_%(key%, portID%):"_xJoyDown@8"
xJoyDown%(key%, portID%)
xJoyHit_%(key%, portID%):"_xJoyHit@8"
xJoyHit%(key%, portID%)
xGetJoy_%(portID%):"_xGetJoy@4"
xGetJoy%(portID%)
xFlushJoy():"_xFlushJoy@0"
xWaitJoy_%(portID%):"_xWaitJoy@4"
xWaitJoy%(portID%)
xJoyX_#(portID%):"_xJoyX@4"
xJoyX#(portID%)
xJoyY_#(portID%):"_xJoyY@4"
xJoyY#(portID%)
xJoyZ_#(portID%):"_xJoyZ@4"
xJoyZ#(portID%)
xJoyU_#(portID%):"_xJoyU@4"
xJoyU#(portID%)
xJoyV_#(portID%):"_xJoyV@4"
xJoyV#(portID%)
xJoyPitch_#(portID%):"_xJoyPitch@4"
xJoyPitch#(portID%)
xJoyYaw_#(portID%):"_xJoyYaw@4"
xJoyYaw#(portID%)
xJoyRoll_#(portID%):"_xJoyRoll@4"
xJoyRoll#(portID%)
xJoyHat_#(portID%):"_xJoyHat@4"
xJoyHat#(portID%)
xJoyXDir_%(portID%):"_xJoyXDir@4"
xJoyXDir%(portID%)
xJoyYDir_%(portID%):"_xJoyYDir@4"
xJoyYDir%(portID%)
xJoyZDir_%(portID%):"_xJoyZDir@4"
xJoyZDir%(portID%)
xJoyUDir_%(portID%):"_xJoyUDir@4"
xJoyUDir%(portID%)
xJoyVDir_%(portID%):"_xJoyVDir@4"
xJoyVDir%(portID%)
xCountJoys%():"_xCountJoys@0"

; lights commands
xCreateLight_%(typeID%):"_xCreateLight@4"
xCreateLight%(typeID%)
xLightShadowEpsilons(light%, epsilon1#, epsilon2#):"_xLightShadowEpsilons@12"
xLightEnableShadows(light%, state%):"_xLightEnableShadows@8"
xLightShadowsEnabled%(light%):"_xLightShadowsEnabled@4"
xLightRange(light%, range#):"_xLightRange@8"
xLightColor(light%, red%, green%, blue%):"_xLightColor@16"
xLightConeAngles(light%, inner#, outer#):"_xLightConeAngles@12"

; logging commands
xCreateLog_%(target%, level%, filename$, cssfilename$):"_xCreateLog@16"
xCreateLog%(target%, level%, filename$, cssfilename$)
xCloseLog%():"_xCloseLog@0"
xGetLogString$():"_xGetLogString@0"
xClearLogString():"_xClearLogString@0"
xSetLogLevel_(level%):"_xSetLogLevel@4"
xSetLogLevel(level%)
xSetLogTarget_(target%):"_xSetLogTarget@4"
xSetLogTarget(target%)
xGetLogLevel%():"_xGetLogLevel@0"
xGetLogTarget%():"_xGetLogTarget@0"
xLogInfo_(message$, func$, file$, line%):"_xLogInfo@16"
xLogInfo(message$, func$, file$, line%)
xLogMessage_(message$, func$, file$, line%):"_xLogMessage@16"
xLogMessage(message$, func$, file$, line%)
xLogWarning_(message$, func$, file$, line%):"_xLogWarning@16"
xLogWarning(message$, func$, file$, line%)
xLogError_(message$, func$, file$, line%):"_xLogError@16"
xLogError(message$, func$, file$, line%)
xLogFatal_(message$, func$, file$, line%):"_xLogFatal@16"
xLogFatal(message$, func$, file$, line%)

; meshes commands
xCreateMesh_%(parent%):"_xCreateMesh@4"
xCreateMesh%(parent%)
xLoadMesh_%(path$, parent%):"_xLoadMesh@8"
xLoadMesh%(path$, parent%)
xLoadMeshWithChild_%(path$, parent%):"_xLoadMeshWithChild@8"
xLoadMeshWithChild%(path$, parent%)
xLoadAnimMesh_%(path$, parent%):"_xLoadAnimMesh@8"
xLoadAnimMesh%(path$, parent%)
xCreateCube_%(parent%):"_xCreateCube@4"
xCreateCube%(parent%)
xCreateSphere_%(segments%, parent%):"_xCreateSphere@8"
xCreateSphere%(segments%, parent%)
xCreateCylinder_%(segments%, solid%, parent%):"_xCreateCylinder@12"
xCreateCylinder%(segments%, solid%, parent%)
xCreateTorus_%(segments%, R#, r_tube#, parent%):"_xCreateTorus@16"
xCreateTorus%(segments%, R#, r_tube#, parent%)
xCreateCone_%(segments%, solid%, parent%):"_xCreateCone@12"
xCreateCone%(segments%, solid%, parent%)
xCopyMesh_%(entity%, parent%):"_xCopyMesh@8"
xCopyMesh%(entity%, parent%)
xAddMesh(source%, destination%):"_xAddMesh@8"
xFlipMesh(entity%):"_xFlipMesh@4"
xPaintMesh(entity%, brush%):"_xPaintMesh@8"
xFitMesh_(entity%, x#, y#, z#, width#, height#, depth#, uniform%):"_xFitMesh@32"
xFitMesh(entity%, x#, y#, z#, width#, height#, depth#, uniform%)
xMeshWidth_#(entity%, recursive%):"_xMeshWidth@8"
xMeshWidth#(entity%, recursive%)
xMeshHeight_#(entity%, recursive%):"_xMeshHeight@8"
xMeshHeight#(entity%, recursive%)
xMeshDepth_#(entity%, recursive%):"_xMeshDepth@8"
xMeshDepth#(entity%, recursive%)
xScaleMesh(entity%, x#, y#, z#):"_xScaleMesh@16"
xRotateMesh(entity%, x#, y#, z#):"_xRotateMesh@16"
xPositionMesh(entity%, x#, y#, z#):"_xPositionMesh@16"
xUpdateNormals(entity%):"_xUpdateNormals@4"
xUpdateN(entity%):"_xUpdateN@4"
xUpdateTB(entity%):"_xUpdateTB@4"
xMeshesBBIntersect%(entity1%, entity2%):"_xMeshesBBIntersect@8"
xMeshesIntersect%(entity1%, entity2%):"_xMeshesIntersect@8"
xGetMeshVB%(entity%):"_xGetMeshVB@4"
xGetMeshIB%(entity%):"_xGetMeshIB@4"
xGetMeshVBSize%(entity%):"_xGetMeshVBSize@4"
xGetMeshIBSize%(entity%):"_xGetMeshIBSize@4"
xDeleteMeshVB(entity%):"_xDeleteMeshVB@4"
xDeleteMeshIB(entity%):"_xDeleteMeshIB@4"
xCountSurfaces%(entity%):"_xCountSurfaces@4"
xGetSurface%(entity%, index%):"_xGetSurface@8"
xCreatePivot_%(parent%):"_xCreatePivot@4"
xCreatePivot%(parent%)
xFindSurface%(entity%, brush%):"_xFindSurface@8"
xCreatePoly_%(sides%, parent%):"_xCreatePoly@8"
xCreatePoly%(sides%, parent%)
xMeshSingleSurface(entity%):"_xMeshSingleSurface@4"
xSaveMesh%(entity%, path$):"_xSaveMesh@8"
xLightMesh_(entity%, red%, green%, blue%, range#, lightX#, lightY#, lightZ#):"_xLightMesh@32"
xLightMesh(entity%, red%, green%, blue%, range#, lightX#, lightY#, lightZ#)
xMeshPrimitiveType(entity%, ptype%):"_xMeshPrimitiveType@8"

; particles commands
xParticlePosition(particle%, x#, y#, z#):"_xParticlePosition@16"
xParticleX#(particle%):"_xParticleX@4"
xParticleY#(particle%):"_xParticleY@4"
xParticleZ#(particle%):"_xParticleZ@4"
xParticleVeclocity(particle%, x#, y#, z#):"_xParticleVeclocity@16"
xParticleVX#(particle%):"_xParticleVX@4"
xParticleVY#(particle%):"_xParticleVY@4"
xParticleVZ#(particle%):"_xParticleVZ@4"
xParticleRotation(particle%, x#, y#, z#):"_xParticleRotation@16"
xParticlePitch#(particle%):"_xParticlePitch@4"
xParticleYaw#(particle%):"_xParticleYaw@4"
xParticleRoll#(particle%):"_xParticleRoll@4"
xParticleTorque(particle%, x#, y#, z#):"_xParticleTorque@16"
xParticleTPitch#(particle%):"_xParticleTPitch@4"
xParticleTYaw#(particle%):"_xParticleTYaw@4"
xParticleTRoll#(particle%):"_xParticleTRoll@4"
xParticleSetAlpha(particle%, alpha#):"_xParticleSetAlpha@8"
xParticleGetAlpha#(particle%):"_xParticleGetAlpha@4"
xParticleColor(particle%, x#, y#, z#):"_xParticleColor@16"
xParticleRed#(particle%):"_xParticleRed@4"
xParticleGreen#(particle%):"_xParticleGreen@4"
xParticleBlue#(particle%):"_xParticleBlue@4"
xParticleScale(particle%, x#, y#):"_xParticleScale@12"
xParticleSX#(particle%):"_xParticleSX@4"
xParticleSY#(particle%):"_xParticleSY@4"
xParticleScaleSpeed(particle%, x#, y#):"_xParticleScaleSpeed@12"
xParticleScaleSpeedX#(particle%):"_xParticleScaleSpeedX@4"
xParticleScaleSpeedY#(particle%):"_xParticleScaleSpeedY@4"

; physics commands
xEntityAddDummyShape(entity%):"_xEntityAddDummyShape@4"
xEntityAddBoxShape_(entity%, mass#, width#, height#, depth#):"_xEntityAddBoxShape@20"
xEntityAddBoxShape(entity%, mass#, width#, height#, depth#)
xEntityAddSphereShape_(entity%, mass#, radius#):"_xEntityAddSphereShape@12"
xEntityAddSphereShape(entity%, mass#, radius#)
xEntityAddCapsuleShape_(entity%, mass#, radius#, height#):"_xEntityAddCapsuleShape@16"
xEntityAddCapsuleShape(entity%, mass#, radius#, height#)
xEntityAddConeShape_(entity%, mass#, radius#, height#):"_xEntityAddConeShape@16"
xEntityAddConeShape(entity%, mass#, radius#, height#)
xEntityAddCylinderShape_(entity%, mass#, width#, height#, depth#):"_xEntityAddCylinderShape@20"
xEntityAddCylinderShape(entity%, mass#, width#, height#, depth#)
xEntityAddTriMeshShape(entity%):"_xEntityAddTriMeshShape@4"
xEntityAddTriMeshShapeProxy(entity%, proxy%):"_xEntityAddTriMeshShapeProxy@8"
xEntityAddConvexShape(entity%, mass#):"_xEntityAddConvexShape@8"
xEntityAddConvexShapeProxy(entity%, proxy%, mass#):"_xEntityAddConvexShapeProxy@12"
xEntityAddConcaveShape(entity%, mass#):"_xEntityAddConcaveShape@8"
xEntityAddConcaveShapeProxy(entity%, proxy%, mass#):"_xEntityAddConcaveShapeProxy@12"
xEntityAddTerrainShape(entity%):"_xEntityAddTerrainShape@4"
xEntityAttachBody(entity%, body%):"_xEntityAttachBody@8"
xEntityDetachBody%(entity%):"_xEntityDetachBody@4"
xFreeEntityBody(entity%):"_xFreeEntityBody@4"
xEntityAddCompoundShape(entity%, mass#):"_xEntityAddCompoundShape@8"
xEntityCompoundAddBox%(entity%, width#, height#, depth#):"_xEntityCompoundAddBox@16"
xEntityCompoundAddSphere%(entity%, radius#):"_xEntityCompoundAddSphere@8"
xEntityCompoundAddCapsule%(entity%, radius#, height#):"_xEntityCompoundAddCapsule@12"
xEntityCompoundAddCone%(entity%, radius#, height#):"_xEntityCompoundAddCone@12"
xEntityCompoundAddCylinder%(entity%, radius#, height#):"_xEntityCompoundAddCylinder@12"
xEntityCompoundCountChildren%(entity%):"_xEntityCompoundCountChildren@4"
xEntityCompoundRemoveChild(entity%, index%):"_xEntityCompoundRemoveChild@8"
xEntityCompoundChildSetPosition(entity%, index%, x#, y#, z#):"_xEntityCompoundChildSetPosition@20"
xEntityCompoundChildGetX#(entity%, index%):"_xEntityCompoundChildGetX@8"
xEntityCompoundChildGetY#(entity%, index%):"_xEntityCompoundChildGetY@8"
xEntityCompoundChildGetZ#(entity%, index%):"_xEntityCompoundChildGetZ@8"
xEntityCompoundChildSetRotation(entity%, index%, pitch#, yaw#, roll#):"_xEntityCompoundChildSetRotation@20"
xEntityCompoundChildGetPitch#(entity%, index%):"_xEntityCompoundChildGetPitch@8"
xEntityCompoundChildGetYaw#(entity%, index%):"_xEntityCompoundChildGetYaw@8"
xEntityCompoundChildGetRoll#(entity%, index%):"_xEntityCompoundChildGetRoll@8"
xCreateHingeJoint_%(firstBody%, secondBody%, pivotX#, pivotY#, pivotZ#, axisX#, axisY#, axisZ#, isGlobal%):"_xCreateHingeJoint@36"
xCreateHingeJoint%(firstBody%, secondBody%, pivotX#, pivotY#, pivotZ#, axisX#, axisY#, axisZ#, isGlobal%)
xCreateBallJoint_%(firstBody%, secondBody%, pivotX#, pivotY#, pivotZ#, isGlobal%):"_xCreateBallJoint@24"
xCreateBallJoint%(firstBody%, secondBody%, pivotX#, pivotY#, pivotZ#, isGlobal%)
xCreateD6Joint_%(firstBody%, secondBody%, pivot1X#, pivot1Y#, pivot1Z#, pivot2X#, pivot2Y#, pivot2Z#, isGlobal1%, isGlobal2%):"_xCreateD6Joint@40"
xCreateD6Joint%(firstBody%, secondBody%, pivot1X#, pivot1Y#, pivot1Z#, pivot2X#, pivot2Y#, pivot2Z#, isGlobal1%, isGlobal2%)
xCreateD6SpringJoint_%(firstBody%, secondBody%, pivot1X#, pivot1Y#, pivot1Z#, pivot2X#, pivot2Y#, pivot2Z#, isGlobal1%, isGlobal2%):"_xCreateD6SpringJoint@40"
xCreateD6SpringJoint%(firstBody%, secondBody%, pivot1X#, pivot1Y#, pivot1Z#, pivot2X#, pivot2Y#, pivot2Z#, isGlobal1%, isGlobal2%)
xJointHingeGetAngle#(joint%):"_xJointHingeGetAngle@4"
xJointD6GetPitchAngle#(joint%):"_xJointD6GetPitchAngle@4"
xJointD6GetYawAngle#(joint%):"_xJointD6GetYawAngle@4"
xJointD6GetRollAngle#(joint%):"_xJointD6GetRollAngle@4"
xJointD6GetAngle_#(joint%, axis%):"_xJointD6GetAngle@8"
xJointD6GetAngle#(joint%, axis%)
xJointDisableCollisions(joint%, state%):"_xJointDisableCollisions@8"
xJointEnable(joint%, state%):"_xJointEnable@8"
xJointIsEnabled%(joint%):"_xJointIsEnabled@4"
xJointGetImpulse#(joint%):"_xJointGetImpulse@4"
xFreeJoint(joint%):"_xFreeJoint@4"
xJointBallSetPivot_(joint%, x#, y#, z#, isGlobal%):"_xJointBallSetPivot@20"
xJointBallSetPivot(joint%, x#, y#, z#, isGlobal%)
xJointBallGetPivotX_#(joint%, isGlobal%):"_xJointBallGetPivotX@8"
xJointBallGetPivotX#(joint%, isGlobal%)
xJointBallGetPivotY_#(joint%, isGlobal%):"_xJointBallGetPivotY@8"
xJointBallGetPivotY#(joint%, isGlobal%)
xJointBallGetPivotZ_#(joint%, isGlobal%):"_xJointBallGetPivotZ@8"
xJointBallGetPivotZ#(joint%, isGlobal%)
xJointD6SetLimits(joint%, axis%, lower#, upper#):"_xJointD6SetLimits@16"
xJointD6SetLowerLinearLimits(joint%, lowerX#, lowerY#, lowerZ#):"_xJointD6SetLowerLinearLimits@16"
xJointD6SetUpperLinearLimits(joint%, upperX#, upperY#, upperZ#):"_xJointD6SetUpperLinearLimits@16"
xJointD6SetLowerAngularLimits(joint%, lowerX#, lowerY#, lowerZ#):"_xJointD6SetLowerAngularLimits@16"
xJointD6SetUpperAngularLimits(joint%, upperX#, upperY#, upperZ#):"_xJointD6SetUpperAngularLimits@16"
xJointD6SetLinearLimits(joint%, lowerX#, lowerY#, lowerZ#, upperX#, upperY#, upperZ#):"_xJointD6SetLinearLimits@28"
xJointD6SetAngularLimits(joint%, lowerX#, lowerY#, lowerZ#, upperX#, upperY#, upperZ#):"_xJointD6SetAngularLimits@28"
xJointD6GetLinearLowerX#(joint%):"_xJointD6GetLinearLowerX@4"
xJointD6GetLinearLowerY#(joint%):"_xJointD6GetLinearLowerY@4"
xJointD6GetLinearLowerZ#(joint%):"_xJointD6GetLinearLowerZ@4"
xJointD6GetLinearUpperX#(joint%):"_xJointD6GetLinearUpperX@4"
xJointD6GetLinearUpperY#(joint%):"_xJointD6GetLinearUpperY@4"
xJointD6GetLinearUpperZ#(joint%):"_xJointD6GetLinearUpperZ@4"
xJointD6GetAngularLowerX#(joint%):"_xJointD6GetAngularLowerX@4"
xJointD6GetAngularLowerY#(joint%):"_xJointD6GetAngularLowerY@4"
xJointD6GetAngularLowerZ#(joint%):"_xJointD6GetAngularLowerZ@4"
xJointD6GetAngularUpperX#(joint%):"_xJointD6GetAngularUpperX@4"
xJointD6GetAngularUpperY#(joint%):"_xJointD6GetAngularUpperY@4"
xJointD6GetAngularUpperZ#(joint%):"_xJointD6GetAngularUpperZ@4"
xJointD6SpringSetParam_(joint%, index%, enabled%, damping#, stiffness#):"_xJointD6SpringSetParam@20"
xJointD6SpringSetParam(joint%, index%, enabled%, damping#, stiffness#)
xJointHingeSetAxis(joint%, x#, y#, z#):"_xJointHingeSetAxis@16"
xJointHingeSetLimits_(joint%, lowerLimit#, upperLimit#, softness#, biasFactor#, relaxationFactor#):"_xJointHingeSetLimits@24"
xJointHingeSetLimits(joint%, lowerLimit#, upperLimit#, softness#, biasFactor#, relaxationFactor#)
xJointHingeGetLowerLimit#(joint%):"_xJointHingeGetLowerLimit@4"
xJointHingeGetUpperLimit#(joint%):"_xJointHingeGetUpperLimit@4"
xJointEnableMotor_(joint%, enabled%, targetVelocity#, maxForce#, index%):"_xJointEnableMotor@20"
xJointEnableMotor(joint%, enabled%, targetVelocity#, maxForce#, index%)
xJointHingeSetMotorTarget(joint%, targetAngle#, deltaTime#):"_xJointHingeSetMotorTarget@12"
xJointGetEntityA%(joint%):"_xJointGetEntityA@4"
xJointGetEntityB%(joint%):"_xJointGetEntityB@4"
xEntityApplyCentralForce_(entity%, x#, y#, z#, isGlobal%):"_xEntityApplyCentralForce@20"
xEntityApplyCentralForce(entity%, x#, y#, z#, isGlobal%)
xEntityApplyCentralImpulse_(entity%, x#, y#, z#, isGlobal%):"_xEntityApplyCentralImpulse@20"
xEntityApplyCentralImpulse(entity%, x#, y#, z#, isGlobal%)
xEntityApplyTorque_(entity%, x#, y#, z#, isGlobal%):"_xEntityApplyTorque@20"
xEntityApplyTorque(entity%, x#, y#, z#, isGlobal%)
xEntityApplyTorqueImpulse_(entity%, x#, y#, z#, isGlobal%):"_xEntityApplyTorqueImpulse@20"
xEntityApplyTorqueImpulse(entity%, x#, y#, z#, isGlobal%)
xEntityApplyForce_(entity%, x#, y#, z#, pointx#, pointy#, pointz#, isGlobal%, globalPoint%):"_xEntityApplyForce@36"
xEntityApplyForce(entity%, x#, y#, z#, pointx#, pointy#, pointz#, isGlobal%, globalPoint%)
xEntityApplyImpulse_(entity%, x#, y#, z#, pointx#, pointy#, pointz#, isGlobal%, globalPoint%):"_xEntityApplyImpulse@36"
xEntityApplyImpulse(entity%, x#, y#, z#, pointx#, pointy#, pointz#, isGlobal%, globalPoint%)
xEntityReleaseForces(entity%):"_xEntityReleaseForces@4"
xWorldSetGravity_(x#, y#, z#, world%):"_xWorldSetGravity@16"
xWorldSetGravity(x#, y#, z#, world%)
xWorldGetGravityX_#(world%):"_xWorldGetGravityX@4"
xWorldGetGravityX#(world%)
xWorldGetGravityY_#(world%):"_xWorldGetGravityY@4"
xWorldGetGravityY#(world%)
xWorldGetGravityZ_#(world%):"_xWorldGetGravityZ@4"
xWorldGetGravityZ#(world%)
xEntitySetGravity(entity%, x#, y#, z#):"_xEntitySetGravity@16"
xEntityGetGravityX#(entity%):"_xEntityGetGravityX@4"
xEntityGetGravityY#(entity%):"_xEntityGetGravityY@4"
xEntityGetGravityZ#(entity%):"_xEntityGetGravityZ@4"
xEntitySetLinearVelocity_(entity%, x#, y#, z#, isGlobal%):"_xEntitySetLinearVelocity@20"
xEntitySetLinearVelocity(entity%, x#, y#, z#, isGlobal%)
xEntityGetLinearVelocityX_#(entity%, isGlobal%):"_xEntityGetLinearVelocityX@8"
xEntityGetLinearVelocityX#(entity%, isGlobal%)
xEntityGetLinearVelocityY_#(entity%, isGlobal%):"_xEntityGetLinearVelocityY@8"
xEntityGetLinearVelocityY#(entity%, isGlobal%)
xEntityGetLinearVelocityZ_#(entity%, isGlobal%):"_xEntityGetLinearVelocityZ@8"
xEntityGetLinearVelocityZ#(entity%, isGlobal%)
xEntitySetAngularVelocity_(entity%, x#, y#, z#, isGlobal%):"_xEntitySetAngularVelocity@20"
xEntitySetAngularVelocity(entity%, x#, y#, z#, isGlobal%)
xEntityGetAngularVelocityX_#(entity%, isGlobal%):"_xEntityGetAngularVelocityX@8"
xEntityGetAngularVelocityX#(entity%, isGlobal%)
xEntityGetAngularVelocityY_#(entity%, isGlobal%):"_xEntityGetAngularVelocityY@8"
xEntityGetAngularVelocityY#(entity%, isGlobal%)
xEntityGetAngularVelocityZ_#(entity%, isGlobal%):"_xEntityGetAngularVelocityZ@8"
xEntityGetAngularVelocityZ#(entity%, isGlobal%)
xEntitySetDamping(entity%, linear#, angular#):"_xEntitySetDamping@12"
xEntityGetLinearDamping#(entity%):"_xEntityGetLinearDamping@4"
xEntityGetAngularDamping#(entity%):"_xEntityGetAngularDamping@4"
xEntitySetFriction(entity%, friction#):"_xEntitySetFriction@8"
xEntityGetFriction#(entity%):"_xEntityGetFriction@4"
xEntitySetAnisotropicFriction(entity%, fx#, fy#, fz#):"_xEntitySetAnisotropicFriction@16"
xEntityGetAnisotropicFrictionX#(entity%):"_xEntityGetAnisotropicFrictionX@4"
xEntityGetAnisotropicFrictionY#(entity%):"_xEntityGetAnisotropicFrictionY@4"
xEntityGetAnisotropicFrictionZ#(entity%):"_xEntityGetAnisotropicFrictionZ@4"
xEntitySetLinearFactor(entity%, x#, y#, z#):"_xEntitySetLinearFactor@16"
xEntityGetLinearFactorX#(entity%):"_xEntityGetLinearFactorX@4"
xEntityGetLinearFactorY#(entity%):"_xEntityGetLinearFactorY@4"
xEntityGetLinearFactorZ#(entity%):"_xEntityGetLinearFactorZ@4"
xEntitySetAngularFactor(entity%, x#, y#, z#):"_xEntitySetAngularFactor@16"
xEntityGetAngularFactorX#(entity%):"_xEntityGetAngularFactorX@4"
xEntityGetAngularFactorY#(entity%):"_xEntityGetAngularFactorY@4"
xEntityGetAngularFactorZ#(entity%):"_xEntityGetAngularFactorZ@4"
xEntitySetRestitution(entity%, restitution#):"_xEntitySetRestitution@8"
xEntityGetRestitution#(entity%):"_xEntityGetRestitution@4"
xEntitySetMass(entity%, mass#):"_xEntitySetMass@8"
xEntityGetMass#(entity%):"_xEntityGetMass@4"
xEntityCountContacts%(entity%):"_xEntityCountContacts@4"
xEntityGetContactX#(entity%, index%):"_xEntityGetContactX@8"
xEntityGetContactY#(entity%, index%):"_xEntityGetContactY@8"
xEntityGetContactZ#(entity%, index%):"_xEntityGetContactZ@8"
xEntityGetContactNX#(entity%, index%):"_xEntityGetContactNX@8"
xEntityGetContactNY#(entity%, index%):"_xEntityGetContactNY@8"
xEntityGetContactNZ#(entity%, index%):"_xEntityGetContactNZ@8"
xEntityGetContactDistance#(entity%, index%):"_xEntityGetContactDistance@8"
xEntityGetContact%(entity%, index%):"_xEntityGetContact@8"
xEntityGetContactImpulse#(entity%, index%):"_xEntityGetContactImpulse@8"
xEntitySetCollisionGroup(entity%, group%):"_xEntitySetCollisionGroup@8"
xEntityGetCollisionGroup%(entity%):"_xEntityGetCollisionGroup@4"
xEntitySetContactGroup(entity%, group%):"_xEntitySetContactGroup@8"
xEntityGetContactGroup%(entity%):"_xEntityGetContactGroup@4"
xEntitySetRaycastGroup(entity%, group%):"_xEntitySetRaycastGroup@8"
xEntityGetRaycastGroup%(entity%):"_xEntityGetRaycastGroup@4"
xPhysicsSetCollisionFilter(group0%, group1%, state%):"_xPhysicsSetCollisionFilter@12"
xPhysicsGetCollisionFilter%(group0%, group1%):"_xPhysicsGetCollisionFilter@8"
xPhysicsSetContactFilter(group0%, group1%, state%):"_xPhysicsSetContactFilter@12"
xPhysicsGetContactFilter%(group0%, group1%):"_xPhysicsGetContactFilter@8"
xPhysicsSetRaycastFilter(rayGroup%, bodyGroup%, state%):"_xPhysicsSetRaycastFilter@12"
xPhysicsGetRaycastFilter%(rayGroup%, bodyGroup%):"_xPhysicsGetRaycastFilter@8"
xEntityIsSleeping%(entity%):"_xEntityIsSleeping@4"
xEntityDisableSleeping_(entity%, state%):"_xEntityDisableSleeping@8"
xEntityDisableSleeping(entity%, state%)
xEntityWakeUp(entity%):"_xEntityWakeUp@4"
xEntitySleep(entity%):"_xEntitySleep@4"
xEntitySetSleepingThresholds(entity%, linearThreshold#, angularThreshold#):"_xEntitySetSleepingThresholds@12"
xEntityGetLinearSleepingThreshold#(entity%):"_xEntityGetLinearSleepingThreshold@4"
xEntityGetAngularSleepingThreshold#(entity%):"_xEntityGetAngularSleepingThreshold@4"
xPhysicsRayCast_(fromX#, fromY#, fromZ#, toX#, toY#, toZ#, rcType%, rayGroup%):"_xPhysicsRayCast@32"
xPhysicsRayCast(fromX#, fromY#, fromZ#, toX#, toY#, toZ#, rcType%, rayGroup%)
xPhysicsGetHitEntity_%(index%):"_xPhysicsGetHitEntity@4"
xPhysicsGetHitEntity%(index%)
xPhysicsGetHitPointX_#(index%):"_xPhysicsGetHitPointX@4"
xPhysicsGetHitPointX#(index%)
xPhysicsGetHitPointY_#(index%):"_xPhysicsGetHitPointY@4"
xPhysicsGetHitPointY#(index%)
xPhysicsGetHitPointZ_#(index%):"_xPhysicsGetHitPointZ@4"
xPhysicsGetHitPointZ#(index%)
xPhysicsGetHitNormalX_#(index%):"_xPhysicsGetHitNormalX@4"
xPhysicsGetHitNormalX#(index%)
xPhysicsGetHitNormalY_#(index%):"_xPhysicsGetHitNormalY@4"
xPhysicsGetHitNormalY#(index%)
xPhysicsGetHitNormalZ_#(index%):"_xPhysicsGetHitNormalZ@4"
xPhysicsGetHitNormalZ#(index%)
xPhysicsGetHitDistance_#(index%):"_xPhysicsGetHitDistance@4"
xPhysicsGetHitDistance#(index%)
xPhysicsCountHits%():"_xPhysicsCountHits@0"
xEntityBodyLocalPosition(entity%, x#, y#, z#):"_xEntityBodyLocalPosition@16"
xEntityBodyLocalRotation(entity%, pitch#, yaw#, roll#):"_xEntityBodyLocalRotation@16"
xEntityBodyLocalScale(entity%, x#, y#, z#):"_xEntityBodyLocalScale@16"
xWorldSetFrequency_(frequency#, world%):"_xWorldSetFrequency@8"
xWorldSetFrequency(frequency#, world%)
xEntityMakeKinematic(entity%, state%):"_xEntityMakeKinematic@8"
xEntityIsKinematic%(entity%):"_xEntityIsKinematic@4"
xPhysicsDebugRender(state%):"_xPhysicsDebugRender@4"
xEntityDisableSimulation(entity%, state%):"_xEntityDisableSimulation@8"
xEntityHasBody%(entity%):"_xEntityHasBody@4"
xEntityCreateVehicle(chassisEntity%):"_xEntityCreateVehicle@4"
xEntityFreeVehicle(chassisEntity%):"_xEntityFreeVehicle@4"
xEntityCountWheels%(chassisEntity%):"_xEntityCountWheels@4"
xEntityAddWheel%(chassisEntity%, wheelEntity%):"_xEntityAddWheel@8"
xEntityWheelSetRadius(chassisEntity%, index%, radius#):"_xEntityWheelSetRadius@12"
xEntityWheelSetAxle(chassisEntity%, index%, x#, y#, z#):"_xEntityWheelSetAxle@20"
xEntityWheelSetRay(chassisEntity%, index%, x#, y#, z#):"_xEntityWheelSetRay@20"
xEntityWheelSetSuspensionLength(chassisEntity%, index%, length#):"_xEntityWheelSetSuspensionLength@12"
xEntityWheelSetBrake(chassisEntity%, index%, brake#):"_xEntityWheelSetBrake@12"
xEntityWheelSetMaxSuspensionForce(chassisEntity%, index%, force#):"_xEntityWheelSetMaxSuspensionForce@12"
xEntityWheelSetMaxSuspensionTravel(chassisEntity%, index%, travel#):"_xEntityWheelSetMaxSuspensionTravel@12"
xEntityWheelSetSuspensionStiffness(chassisEntity%, index%, stiffness#):"_xEntityWheelSetSuspensionStiffness@12"
xEntityWheelSetSuspensionDamping(chassisEntity%, index%, damping#):"_xEntityWheelSetSuspensionDamping@12"
xEntityWheelSetSuspensionCompression(chassisEntity%, index%, compression#):"_xEntityWheelSetSuspensionCompression@12"
xEntityWheelSetFriction(chassisEntity%, index%, friction#):"_xEntityWheelSetFriction@12"
xEntityWheelSetEngineForce(chassisEntity%, index%, force#):"_xEntityWheelSetEngineForce@12"
xEntityWheelSetRollInfluence(chassisEntity%, index%, roll#):"_xEntityWheelSetRollInfluence@12"
xEntityWheelSetRotation(chassisEntity%, index%, rotation#):"_xEntityWheelSetRotation@12"
xEntityWheelSetSteering(chassisEntity%, index%, steering#):"_xEntityWheelSetSteering@12"
xEntityWheelSetConnectionPoint_(chassisEntity%, index%, x#, y#, z#, isGlobal%):"_xEntityWheelSetConnectionPoint@24"
xEntityWheelSetConnectionPoint(chassisEntity%, index%, x#, y#, z#, isGlobal%)
xEntityWheelGetSuspensionLength#(chassisEntity%, index%):"_xEntityWheelGetSuspensionLength@8"
xEntityWheelGetPitch#(chassisEntity%, index%):"_xEntityWheelGetPitch@8"
xEntityWheelGetYaw#(chassisEntity%, index%):"_xEntityWheelGetYaw@8"
xEntityWheelGetRoll#(chassisEntity%, index%):"_xEntityWheelGetRoll@8"
xEntityWheelGetContactEntity%(chassisEntity%, index%):"_xEntityWheelGetContactEntity@8"

; posteffects commands
xLoadPostEffect%(path$):"_xLoadPostEffect@4"
xFreePostEffect(postEffect%):"_xFreePostEffect@4"
xSetPostEffect_(index%, postEffect%, technique$):"_xSetPostEffect@12"
xSetPostEffect(index%, postEffect%, technique$)
xRenderPostEffects():"_xRenderPostEffects@0"
xSetPostEffectInt(postEffect%, name$, value%):"_xSetPostEffectInt@12"
xSetPostEffectFloat(postEffect%, name$, value#):"_xSetPostEffectFloat@12"
xSetPostEffectBool(postEffect%, name$, value%):"_xSetPostEffectBool@12"
xSetPostEffectVector_(postEffect%, name$, x#, y#, z#, w#):"_xSetPostEffectVector@24"
xSetPostEffectVector(postEffect%, name$, x#, y#, z#, w#)
xSetPostEffectTexture_(postEffect%, name$, texture%, frame%):"_xSetPostEffectTexture@16"
xSetPostEffectTexture(postEffect%, name$, texture%, frame%)
xDeletePostEffectConstant(postEffect%, name$):"_xDeletePostEffectConstant@8"
xClearPostEffectConstants(postEffect%):"_xClearPostEffectConstants@4"

; psystems commands
xCreatePSystem_%(pointSprites%):"_xCreatePSystem@4"
xCreatePSystem%(pointSprites%)
xPSystemType%(psystem%):"_xPSystemType@4"
xPSystemSetBlend(psystem%, mode%):"_xPSystemSetBlend@8"
xPSystemGetBlend%(psystem%):"_xPSystemGetBlend@4"
xPSystemSetMaxParticles(psystem%, maxNumber%):"_xPSystemSetMaxParticles@8"
xPSystemGetMaxParticles%(psystem%):"_xPSystemGetMaxParticles@4"
xPSystemSetEmitterLifetime(psystem%, lifetime%):"_xPSystemSetEmitterLifetime@8"
xPSystemGetEmitterLifetime%(psystem%):"_xPSystemGetEmitterLifetime@4"
xPSystemSetParticleLifetime(psystem%, lifetime%):"_xPSystemSetParticleLifetime@8"
xPSystemGetParticleLifetime%(psystem%):"_xPSystemGetParticleLifetime@4"
xPSystemSetCreationInterval(psystem%, interval%):"_xPSystemSetCreationInterval@8"
xPSystemGetCreationInterval%(psystem%):"_xPSystemGetCreationInterval@4"
xPSystemSetCreationFrequency(psystem%, frequency%):"_xPSystemSetCreationFrequency@8"
xPSystemGetCreationFrequency%(psystem%):"_xPSystemGetCreationFrequency@4"
xPSystemSetTexture(psystem%, texture%, frames%, speed#):"_xPSystemSetTexture@16"
xPSystemGetTexture%(psystem%):"_xPSystemGetTexture@4"
xPSystemGetTextureFrames%(psystem%):"_xPSystemGetTextureFrames@4"
xPSystemGetTextureAnimationSpeed%(psystem%):"_xPSystemGetTextureAnimationSpeed@4"
xPSystemSetOffset(psystem%, minx#, miny#, minz#, maxx#, maxy#, maxz#):"_xPSystemSetOffset@28"
xPSystemGetOffsetMinX#(psystem%):"_xPSystemGetOffsetMinX@4"
xPSystemGetOffsetMinY#(psystem%):"_xPSystemGetOffsetMinY@4"
xPSystemGetOffsetMinZ#(psystem%):"_xPSystemGetOffsetMinZ@4"
xPSystemGetOffsetMaxX#(psystem%):"_xPSystemGetOffsetMaxX@4"
xPSystemGetOffsetMaxY#(psystem%):"_xPSystemGetOffsetMaxY@4"
xPSystemGetOffsetMaxZ#(psystem%):"_xPSystemGetOffsetMaxZ@4"
xPSystemSetVelocity(psystem%, minx#, miny#, minz#, maxx#, maxy#, maxz#):"_xPSystemSetVelocity@28"
xPSystemGetVelocityMinX#(psystem%):"_xPSystemGetVelocityMinX@4"
xPSystemGetVelocityMinY#(psystem%):"_xPSystemGetVelocityMinY@4"
xPSystemGetVelocityMinZ#(psystem%):"_xPSystemGetVelocityMinZ@4"
xPSystemGetVelocityMaxX#(psystem%):"_xPSystemGetVelocityMaxX@4"
xPSystemGetVelocityMaxY#(psystem%):"_xPSystemGetVelocityMaxY@4"
xPSystemGetVelocityMaxZ#(psystem%):"_xPSystemGetVelocityMaxZ@4"
xPSystemEnableFixedQuads(psystem%, state%):"_xPSystemEnableFixedQuads@8"
xPSystemFixedQuadsUsed%(psystem%):"_xPSystemFixedQuadsUsed@4"
xPSystemSetTorque(psystem%, minx#, miny#, minz#, maxx#, maxy#, maxz#):"_xPSystemSetTorque@28"
xPSystemGetTorqueMinX#(psystem%):"_xPSystemGetTorqueMinX@4"
xPSystemGetTorqueMinY#(psystem%):"_xPSystemGetTorqueMinY@4"
xPSystemGetTorqueMinZ#(psystem%):"_xPSystemGetTorqueMinZ@4"
xPSystemGetTorqueMaxX#(psystem%):"_xPSystemGetTorqueMaxX@4"
xPSystemGetTorqueMaxY#(psystem%):"_xPSystemGetTorqueMaxY@4"
xPSystemGetTorqueMaxZ#(psystem%):"_xPSystemGetTorqueMaxZ@4"
xPSystemSetGravity(psystem%, gravity#):"_xPSystemSetGravity@8"
xPSystemGetGravity#(psystem%):"_xPSystemGetGravity@4"
xPSystemSetAlpha(psystem%, alpha#):"_xPSystemSetAlpha@8"
xPSystemGetAlpha#(psystem%):"_xPSystemGetAlpha@4"
xPSystemSetFadeSpeed(psystem%, speed#):"_xPSystemSetFadeSpeed@8"
xPSystemGetFadeSpeed#(psystem%):"_xPSystemGetFadeSpeed@4"
xPSystemSetParticleSize(psystem%, minx#, miny#, maxx#, maxy#):"_xPSystemSetParticleSize@20"
xPSystemGetSizeMinX#(psystem%):"_xPSystemGetSizeMinX@4"
xPSystemGetSizeMinY#(psystem%):"_xPSystemGetSizeMinY@4"
xPSystemGetSizeMaxX#(psystem%):"_xPSystemGetSizeMaxX@4"
xPSystemGetSizeMaxY#(psystem%):"_xPSystemGetSizeMaxY@4"
xPSystemSetScaleSpeed(psystem%, minx#, miny#, maxx#, maxy#):"_xPSystemSetScaleSpeed@20"
xPSystemGetScaleSpeedMinX#(psystem%):"_xPSystemGetScaleSpeedMinX@4"
xPSystemGetScaleSpeedMinY#(psystem%):"_xPSystemGetScaleSpeedMinY@4"
xPSystemGetScaleSpeedMaxX#(psystem%):"_xPSystemGetScaleSpeedMaxX@4"
xPSystemGetScaleSpeedMaxY#(psystem%):"_xPSystemGetScaleSpeedMaxY@4"
xPSystemSetAngles(psystem%, minx#, miny#, minz#, maxx#, maxy#, maxz#):"_xPSystemSetAngles@28"
xPSystemGetAnglesMinX#(psystem%):"_xPSystemGetAnglesMinX@4"
xPSystemGetAnglesMinY#(psystem%):"_xPSystemGetAnglesMinY@4"
xPSystemGetAnglesMinZ#(psystem%):"_xPSystemGetAnglesMinZ@4"
xPSystemGetAnglesMaxX#(psystem%):"_xPSystemGetAnglesMaxX@4"
xPSystemGetAnglesMaxY#(psystem%):"_xPSystemGetAnglesMaxY@4"
xPSystemGetAnglesMaxZ#(psystem%):"_xPSystemGetAnglesMaxZ@4"
xPSystemSetColorMode(psystem%, mode%):"_xPSystemSetColorMode@8"
xPSystemGetColorMode%(psystem%):"_xPSystemGetColorMode@4"
xPSystemSetColors(psystem%, sred#, sgreen#, sblue#, ered#, egreen#, eblue#):"_xPSystemSetColors@28"
xPSystemGetBeginColorRed#(psystem%):"_xPSystemGetBeginColorRed@4"
xPSystemGetBeginColorGreen#(psystem%):"_xPSystemGetBeginColorGreen@4"
xPSystemGetBeginColorBlue#(psystem%):"_xPSystemGetBeginColorBlue@4"
xPSystemGetEndColorRed#(psystem%):"_xPSystemGetEndColorRed@4"
xPSystemGetEndColorGreen#(psystem%):"_xPSystemGetEndColorGreen@4"
xPSystemGetEndColorBlue#(psystem%):"_xPSystemGetEndColorBlue@4"
xFreePSystem(psystem%):"_xFreePSystem@4"
xPSystemSetParticleParenting(psystem%, mode%):"_xPSystemSetParticleParenting@8"
xPSystemGetParticleParenting%(psystem%):"_xPSystemGetParticleParenting@4"

; raypicks commands
xLinePick_%(x#, y#, z#, dx#, dy#, dz#, distance#):"_xLinePick@28"
xLinePick%(x#, y#, z#, dx#, dy#, dz#, distance#)
xEntityPick_%(entity%, range#):"_xEntityPick@8"
xEntityPick%(entity%, range#)
xCameraPick%(camera%, x%, y%):"_xCameraPick@12"
xPickedNX#():"_xPickedNX@0"
xPickedNY#():"_xPickedNY@0"
xPickedNZ#():"_xPickedNZ@0"
xPickedX#():"_xPickedX@0"
xPickedY#():"_xPickedY@0"
xPickedZ#():"_xPickedZ@0"
xPickedEntity%():"_xPickedEntity@0"
xPickedSurface%():"_xPickedSurface@0"
xPickedTriangle%():"_xPickedTriangle@0"
xPickedTime%():"_xPickedTime@0"

; shadows commands
xSetShadowsBlur(blurLevel%):"_xSetShadowsBlur@4"
xSetShadowShader(path$):"_xSetShadowShader@4"
xInitShadows%(dirSize%, spotSize%, pointSize%):"_xInitShadows@12"
xSetShadowParams_(splitPlanes%, splitLambda#, useOrtho%, lightDist#):"_xSetShadowParams@16"
xSetShadowParams(splitPlanes%, splitLambda#, useOrtho%, lightDist#)
xRenderShadows(mainCamera%, texture%):"_xRenderShadows@8"
xShadowPriority(priority%):"_xShadowPriority@4"
xCameraDisableShadows(camera%):"_xCameraDisableShadows@4"
xCameraEnableShadows(camera%):"_xCameraEnableShadows@4"
xEntityCastShadows(entity%, light%, state%):"_xEntityCastShadows@12"
xEntityReceiveShadows(entity%, light%, state%):"_xEntityReceiveShadows@12"
xEntityIsCaster%(entity%, light%):"_xEntityIsCaster@8"
xEntityIsReceiver%(entity%, light%):"_xEntityIsReceiver@8"

; sounds commands
xLoadSound%(path$):"_xLoadSound@4"
xLoad3DSound%(path$):"_xLoad3DSound@4"
xFreeSound(sound%):"_xFreeSound@4"
xLoopSound(sound%):"_xLoopSound@4"
xSoundPitch(sound%, pitch%):"_xSoundPitch@8"
xSoundVolume(sound%, volume#):"_xSoundVolume@8"
xSoundPan(sound%, pan#):"_xSoundPan@8"
xPlaySound%(sound%):"_xPlaySound@4"
xStopChannel(channel%):"_xStopChannel@4"
xPauseChannel(channel%):"_xPauseChannel@4"
xResumeChannel(channel%):"_xResumeChannel@4"
xPlayMusic%(path$):"_xPlayMusic@4"
xChannelPitch(channel%, pitch%):"_xChannelPitch@8"
xChannelVolume(channel%, volume#):"_xChannelVolume@8"
xChannelPan(channel%, pan#):"_xChannelPan@8"
xChannelPlaying%(channel%):"_xChannelPlaying@4"
xEmitSound%(sound%, entity%):"_xEmitSound@8"
xCreateListener_%(parent%, roFactor#, doplerFactor#, distFactor#):"_xCreateListener@16"
xCreateListener%(parent%, roFactor#, doplerFactor#, distFactor#)
xGetListener%():"_xGetListener@0"
xInitalizeSound%():"_xInitalizeSound@0"

; sprites commands
xCreateSprite_%(parent%):"_xCreateSprite@4"
xCreateSprite%(parent%)
xSpriteViewMode(sprite%, mode%):"_xSpriteViewMode@8"
xHandleSprite(sprite%, x#, y#):"_xHandleSprite@12"
xLoadSprite_%(path$, flags%, parent%):"_xLoadSprite@12"
xLoadSprite%(path$, flags%, parent%)
xRotateSprite(sprite%, angle#):"_xRotateSprite@8"
xScaleSprite(sprite%, xScale#, yScale#):"_xScaleSprite@12"

; surfaces commands
xCreateSurface_%(entity%, brush%, dynamic%):"_xCreateSurface@12"
xCreateSurface%(entity%, brush%, dynamic%)
xGetSurfaceBrush%(surface%):"_xGetSurfaceBrush@4"
xAddVertex_%(surface%, x#, y#, z#, u#, v#, w#):"_xAddVertex@28"
xAddVertex%(surface%, x#, y#, z#, u#, v#, w#)
xAddTriangle%(surface%, v0%, v1%, v2%):"_xAddTriangle@16"
xSetSurfaceFrustumSphere(surface%, x#, y#, z#, radii#):"_xSetSurfaceFrustumSphere@20"
xVertexCoords(surface%, vertex%, x#, y#, z#):"_xVertexCoords@20"
xVertexNormal(surface%, vertex%, x#, y#, z#):"_xVertexNormal@20"
xVertexTangent(surface%, vertex%, x#, y#, z#):"_xVertexTangent@20"
xVertexBinormal(surface%, vertex%, x#, y#, z#):"_xVertexBinormal@20"
xVertexColor_(surface%, vertex%, red%, green%, blue%, alpha#):"_xVertexColor@24"
xVertexColor(surface%, vertex%, red%, green%, blue%, alpha#)
xVertexTexCoords_(surface%, vertex%, u#, v#, w#, textureSet%):"_xVertexTexCoords@24"
xVertexTexCoords(surface%, vertex%, u#, v#, w#, textureSet%)
xCountVertices%(surface%):"_xCountVertices@4"
xVertexX#(surface%, vertex%):"_xVertexX@8"
xVertexY#(surface%, vertex%):"_xVertexY@8"
xVertexZ#(surface%, vertex%):"_xVertexZ@8"
xVertexNX#(surface%, vertex%):"_xVertexNX@8"
xVertexNY#(surface%, vertex%):"_xVertexNY@8"
xVertexNZ#(surface%, vertex%):"_xVertexNZ@8"
xVertexTX#(surface%, vertex%):"_xVertexTX@8"
xVertexTY#(surface%, vertex%):"_xVertexTY@8"
xVertexTZ#(surface%, vertex%):"_xVertexTZ@8"
xVertexBX#(surface%, vertex%):"_xVertexBX@8"
xVertexBY#(surface%, vertex%):"_xVertexBY@8"
xVertexBZ#(surface%, vertex%):"_xVertexBZ@8"
xVertexU_#(surface%, vertex%, textureSet%):"_xVertexU@12"
xVertexU#(surface%, vertex%, textureSet%)
xVertexV_#(surface%, vertex%, textureSet%):"_xVertexV@12"
xVertexV#(surface%, vertex%, textureSet%)
xVertexW_#(surface%, vertex%, textureSet%):"_xVertexW@12"
xVertexW#(surface%, vertex%, textureSet%)
xVertexRed#(surface%, vertex%):"_xVertexRed@8"
xVertexGreen#(surface%, vertex%):"_xVertexGreen@8"
xVertexBlue#(surface%, vertex%):"_xVertexBlue@8"
xVertexAlpha#(surface%, vertex%):"_xVertexAlpha@8"
xTriangleVertex%(surface%, triangle%, corner%):"_xTriangleVertex@12"
xCountTriangles%(surface%):"_xCountTriangles@4"
xPaintSurface(surface%, brush%):"_xPaintSurface@8"
xClearSurface_(surface%, vertices%, triangles%):"_xClearSurface@12"
xClearSurface(surface%, vertices%, triangles%)
xGetSurfaceTexture_%(surface%, index%):"_xGetSurfaceTexture@8"
xGetSurfaceTexture%(surface%, index%)
xFreeSurface(surface%):"_xFreeSurface@4"
xSurfacePrimitiveType(surface%, ptype%):"_xSurfacePrimitiveType@8"
xSurfaceTexture(surface%, texture%, frame%, index%):"_xSurfaceTexture@16"
xSurfaceColor(surface%, red%, green%, blue%):"_xSurfaceColor@16"
xSurfaceAlpha(surface%, alpha#):"_xSurfaceAlpha@8"
xSurfaceShininess(surface%, shininess#):"_xSurfaceShininess@8"
xSurfaceBlend(surface%, blendMode%):"_xSurfaceBlend@8"
xSurfaceFX(surface%, fxFlags%):"_xSurfaceFX@8"
xSurfaceAlphaRef(surface%, alphaRef%):"_xSurfaceAlphaRef@8"
xSurfaceAlphaFunc(surface%, alphaFunc%):"_xSurfaceAlphaFunc@8"

; sysinfos commands
xCPUName$():"_xCPUName@0"
xCPUVendor$():"_xCPUVendor@0"
xCPUFamily%():"_xCPUFamily@0"
xCPUModel%():"_xCPUModel@0"
xCPUStepping%():"_xCPUStepping@0"
xCPUSpeed%():"_xCPUSpeed@0"
xVideoInfo$():"_xVideoInfo@0"
xVideoAspectRatio#():"_xVideoAspectRatio@0"
xVideoAspectRatioStr$():"_xVideoAspectRatioStr@0"
xGetTotalPhysMem#():"_xGetTotalPhysMem@0"
xGetAvailPhysMem#():"_xGetAvailPhysMem@0"
xGetTotalPageMem#():"_xGetTotalPageMem@0"
xGetAvailPageMem#():"_xGetAvailPageMem@0"
xGetTotalVidMem#():"_xGetTotalVidMem@0"
xGetAvailVidMem#():"_xGetAvailVidMem@0"
xGetTotalVidLocalMem#():"_xGetTotalVidLocalMem@0"
xGetAvailVidLocalMem#():"_xGetAvailVidLocalMem@0"
xGetTotalVidNonlocalMem#():"_xGetTotalVidNonlocalMem@0"
xGetAvailVidNonlocalMem#():"_xGetAvailVidNonlocalMem@0"
xGetXors3dVersion$():"_xGetXors3dVersion@0"
xGetXors3dMajorVersion%():"_xGetXors3dMajorVersion@0"
xGetXors3dMinorVersion%():"_xGetXors3dMinorVersion@0"
xGetXors3dRevision%():"_xGetXors3dRevision@0"

; terrains commands
xLoadTerrain_%(path$, parent%):"_xLoadTerrain@8"
xLoadTerrain%(path$, parent%)
xCreateTerrain_%(size%, parent%):"_xCreateTerrain@8"
xCreateTerrain%(size%, parent%)
xTerrainShading_(terrain%, state%):"_xTerrainShading@8"
xTerrainShading(terrain%, state%)
xTerrainHeight#(terrain%, x%, y%):"_xTerrainHeight@12"
xTerrainSize%(terrain%):"_xTerrainSize@4"
xTerrainX#(terrain%, x#, y#, z#):"_xTerrainX@16"
xTerrainY#(terrain%, x#, y#, z#):"_xTerrainY@16"
xTerrainZ#(terrain%, x#, y#, z#):"_xTerrainZ@16"
xModifyTerrain_(terrain%, x%, y%, height#, realtime%):"_xModifyTerrain@20"
xModifyTerrain(terrain%, x%, y%, height#, realtime%)
xTerrainDetail(terrain%, detail%):"_xTerrainDetail@8"
xTerrainSplatting(terrain%, state%):"_xTerrainSplatting@8"
xLoadTerrainTexture%(path$):"_xLoadTerrainTexture@4"
xFreeTerrainTexture(texture%):"_xFreeTerrainTexture@4"
xTerrainTextureLightmap(texture%, state%):"_xTerrainTextureLightmap@8"
xTerrainTexture(terrain%, texture%):"_xTerrainTexture@8"
xTerrainViewZone_(terrain%, viewZone%, texturingZone%):"_xTerrainViewZone@12"
xTerrainViewZone(terrain%, viewZone%, texturingZone%)
xTerrainLODs(lodsCount%):"_xTerrainLODs@4"

; textures commands
xTextureWidth%(texture%):"_xTextureWidth@4"
xTextureHeight%(texture%):"_xTextureHeight@4"
xCreateTexture_%(width%, height%, flags%, frames%):"_xCreateTexture@16"
xCreateTexture%(width%, height%, flags%, frames%)
xFreeTexture(texture%):"_xFreeTexture@4"
xSetTextureFilter(texture%, mode%):"_xSetTextureFilter@8"
xTextureBlend(texture%, blend%):"_xTextureBlend@8"
xTextureCoords(texture%, coords%):"_xTextureCoords@8"
xTextureFilter(matchText$, flags%):"_xTextureFilter@8"
xClearTextureFilters():"_xClearTextureFilters@0"
xLoadTexture_%(path$, flags%):"_xLoadTexture@8"
xLoadTexture%(path$, flags%)
xTextureName$(texture%):"_xTextureName@4"
xPositionTexture(texture%, x#, y#):"_xPositionTexture@12"
xScaleTexture(texture%, x#, y#):"_xScaleTexture@12"
xRotateTexture(texture%, angle#):"_xRotateTexture@8"
xLoadAnimTexture%(path$, flags%, width%, height%, startFrame%, frames%):"_xLoadAnimTexture@24"
xCreateTextureFromData_%(pixelsData%, width%, height%, flags%, frames%):"_xCreateTextureFromData@20"
xCreateTextureFromData%(pixelsData%, width%, height%, flags%, frames%)
xGetTextureData_%(texture%, frame%):"_xGetTextureData@8"
xGetTextureData%(texture%, frame%)
xGetTextureDataPitch_%(texture%, frame%):"_xGetTextureDataPitch@8"
xGetTextureDataPitch%(texture%, frame%)
xGetTextureSurface_%(texture%, frame%):"_xGetTextureSurface@8"
xGetTextureSurface%(texture%, frame%)
xGetTextureFrames%(texture%):"_xGetTextureFrames@4"
xSetCubeFace(texture%, face%):"_xSetCubeFace@8"
xSetCubeMode(texture%, mode%):"_xSetCubeMode@8"
xGetTextureBlend%(texture%):"_xGetTextureBlend@4"
xGetTextureX#(texture%):"_xGetTextureX@4"
xGetTextureY#(texture%):"_xGetTextureY@4"
xGetTextureScaleX#(texture%):"_xGetTextureScaleX@4"
xGetTextureScaleY#(texture%):"_xGetTextureScaleY@4"
xGetTextureAngle#(texture%):"_xGetTextureAngle@4"
xGetTextureCoords%(texture%):"_xGetTextureCoords@4"
xGetCubeFace%(texture%):"_xGetCubeFace@4"
xGetCubeMode%(texture%):"_xGetCubeMode@4"
xGetTextureFlags%(texture%):"_xGetTextureFlags@4"
xSetTextureFlags(texture%, flags%):"_xSetTextureFlags@8"
xTextureCounter%(texture%):"_xTextureCounter@4"

; transforms commands
xVectorPitch#(x#, y#, z#):"_xVectorPitch@12"
xVectorYaw#(x#, y#, z#):"_xVectorYaw@12"
xDeltaPitch#(entity1%, entity2%):"_xDeltaPitch@8"
xDeltaYaw#(entity1%, entity2%):"_xDeltaYaw@8"
xTFormedX#():"_xTFormedX@0"
xTFormedY#():"_xTFormedY@0"
xTFormedZ#():"_xTFormedZ@0"
xTFormPoint(x#, y#, z#, source%, destination%):"_xTFormPoint@20"
xTFormVector(x#, y#, z#, source%, destination%):"_xTFormVector@20"
xTFormNormal(x#, y#, z#, source%, destination%):"_xTFormNormal@20"

; videos commands
xOpenMovie%(path$):"_xOpenMovie@4"
xCloseMovie(video%):"_xCloseMovie@4"
xDrawMovie_(video%, x%, y%, width%, height%):"_xDrawMovie@20"
xDrawMovie(video%, x%, y%, width%, height%)
xMovieWidth%(video%):"_xMovieWidth@4"
xMovieHeight%(video%):"_xMovieHeight@4"
xMoviePlaying%(video%):"_xMoviePlaying@4"
xMovieSeek_(video%, time#, relative%):"_xMovieSeek@12"
xMovieSeek(video%, time#, relative%)
xMovieLength#(video%):"_xMovieLength@4"
xMovieCurrentTime#(video%):"_xMovieCurrentTime@4"
xMoviePause(video%):"_xMoviePause@4"
xMovieResume(video%):"_xMovieResume@4"
xMovieTexture%(video%):"_xMovieTexture@4"

; worlds commands
xCreateWorld%():"_xCreateWorld@0"
xSetActiveWorld(world%):"_xSetActiveWorld@4"
xGetActiveWorld%():"_xGetActiveWorld@0"
xGetDefaultWorld%():"_xGetDefaultWorld@0"
xDeleteWorld(world%):"_xDeleteWorld@4"
