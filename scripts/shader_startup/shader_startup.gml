/// shader_startup()

globalvar shader_map, shader_texture_surface, shader_texture_filter_linear, shader_texture_filter_mipmap;
globalvar shader_blend_color, shader_blend_alpha;

// Init shaders

log("Shader init")
log("shaders_are_supported", yesno(shaders_are_supported()))

var err = false;
if (!shaders_are_supported())
	err = true

// Compiled?
if (!err)
{
	shader_map = ds_map_create()
	new_shader("shader_alpha_fix")
	new_shader("shader_alpha_test")
	new_shader("shader_blend")
	new_shader("shader_border")
	new_shader("shader_color_camera")
	new_shader("shader_color_fog")
	new_shader("shader_color_fog_lights")
	new_shader("shader_depth")
	new_shader("shader_depth_point")
	new_shader("shader_draw_texture")
	new_shader("shader_replace")
	new_shader("shader_high_aa")
	new_shader("shader_high_dof")
	new_shader("shader_high_fog")
	new_shader("shader_high_fog_apply")
	new_shader("shader_high_light_apply")
	new_shader("shader_high_light_night")
	new_shader("shader_high_light_point")
	new_shader("shader_high_light_spot")
	new_shader("shader_high_light_sun",)
	new_shader("shader_high_ssao")
	new_shader("shader_high_ssao_blur")
	new_shader("shader_high_ssao_depth_normal")

	shader_texture_surface = false
	shader_texture_filter_linear = false
	shader_texture_filter_mipmap = false

	with (obj_shader)
	{
		log(name + " compiled", yesno(shader_is_compiled(shader)))
		
		if (!shader_is_compiled(shader))
		{
			err = true
			break
		}
	}
}

if (err)
{
	log("Shader compilation failed")
	log("Try updating your graphics drivers", link_article_drivers)
	if (show_question("Some shaders failed to compile.\nCheck that your graphics drivers are up-to-date and restart Mine-imator.\n\nOpen support article about updating graphics drivers?"))
		open_url(link_article_drivers)
		
	game_end()
	return false
}

// Set special uniforms

with (shader_map[?shader_border])
	new_shader_uniform("uTexSize")

with (shader_map[?shader_color_camera])
{
	new_shader_uniform("uBrightness")
	new_shader_uniform("uAlpha")
	new_shader_uniform("uRGBAdd")
	new_shader_uniform("uRGBSub")
	new_shader_uniform("uHSBAdd")
	new_shader_uniform("uHSBSub")
	new_shader_uniform("uHSBMul")
	new_shader_uniform("uMixColor")
}

with (shader_map[?shader_color_fog])
{
	new_shader_uniform("uColorsExt")
	new_shader_uniform("uRGBAdd")
	new_shader_uniform("uRGBSub")
	new_shader_uniform("uHSBAdd")
	new_shader_uniform("uHSBSub")
	new_shader_uniform("uHSBMul")
	new_shader_uniform("uMixColor")
}

with (shader_map[?shader_color_fog_lights])
{
	new_shader_uniform("uIsGround")
	new_shader_uniform("uIsSky")
	new_shader_uniform("uColorsExt")
	new_shader_uniform("uRGBAdd")
	new_shader_uniform("uRGBSub")
	new_shader_uniform("uHSBAdd")
	new_shader_uniform("uHSBSub")
	new_shader_uniform("uHSBMul")
	new_shader_uniform("uMixColor")
	new_shader_uniform("uLightAmount")
	new_shader_uniform("uLightData")
	new_shader_uniform("uAmbientColor")
	new_shader_uniform("uBrightness")
	new_shader_uniform("uBlockBrightness")
}

with (shader_map[?shader_depth])
{
	new_shader_uniform("uNear")
	new_shader_uniform("uFar")
}

with (shader_map[?shader_depth_point])
{
	new_shader_uniform("uEye")
	new_shader_uniform("uNear")
	new_shader_uniform("uFar")
}

with (shader_map[?shader_replace])
	new_shader_uniform("uReplaceColor")

with (shader_map[?shader_high_aa])
{
	new_shader_uniform("uScreenSize")
	new_shader_uniform("uPower")
}

with (shader_map[?shader_high_dof])
{
	new_shader_sampler("uDepthBuffer")
	new_shader_uniform("uScreenSize")
	new_shader_uniform("uBlurSize")
	new_shader_uniform("uDepth")
	new_shader_uniform("uRange")
	new_shader_uniform("uFadeSize")
	new_shader_uniform("uNear")
	new_shader_uniform("uFar")
}

with (shader_map[?shader_high_fog_apply])
{
	new_shader_sampler("uFogBuffer")
	new_shader_uniform("uFogColor")
}

with (shader_map[?shader_high_light_apply])
	new_shader_uniform("uAmbientColor")

with (shader_map[?shader_high_light_night])
{
	new_shader_uniform("uLightEnable")
	new_shader_uniform("uBrightness")
	new_shader_uniform("uBlockBrightness")
}

with (shader_map[?shader_high_light_point])
{
	new_shader_uniform("uBrightness")
	new_shader_uniform("uBlockBrightness")
	new_shader_uniform("uIsSky")
	new_shader_uniform("uLightAmount")
	new_shader_uniform("uLightPosition")
	new_shader_uniform("uLightColor")
	new_shader_uniform("uLightNear")
	new_shader_uniform("uLightFar")
	new_shader_uniform("uLightFadeSize")
	new_shader_sampler("uDepthBufferXp")
	new_shader_sampler("uDepthBufferXn")
	new_shader_sampler("uDepthBufferYp")
	new_shader_sampler("uDepthBufferYn")
	new_shader_sampler("uDepthBufferZp")
	new_shader_sampler("uDepthBufferZn")
	new_shader_uniform("uBlurQuality")
	new_shader_uniform("uBlurSize")
}

with (shader_map[?shader_high_light_spot])
{
	new_shader_uniform("uBrightness")
	new_shader_uniform("uBlockBrightness")
	new_shader_uniform("uIsSky")
	new_shader_uniform("uLightAmount")
	new_shader_uniform("uLightMatrix")
	new_shader_uniform("uLightPosition")
	new_shader_uniform("uLightColor")
	new_shader_uniform("uLightNear")
	new_shader_uniform("uLightFar")
	new_shader_uniform("uLightFadeSize")
	new_shader_uniform("uLightSpotSharpness")
	new_shader_sampler("uDepthBuffer")
	new_shader_uniform("uBlurQuality")
	new_shader_uniform("uBlurSize")
}

with (shader_map[?shader_high_light_sun])
{
	new_shader_uniform("uBrightness")
	new_shader_uniform("uBlockBrightness")
	new_shader_uniform("uIsGround")
	new_shader_uniform("uSunAt")
	new_shader_uniform("uIsSky")
	new_shader_uniform("uLightMatrix")
	new_shader_uniform("uLightPosition")
	new_shader_uniform("uLightNear")
	new_shader_uniform("uLightFar")
	new_shader_uniform("uLightColor")
	new_shader_sampler("uDepthBuffer")
	new_shader_uniform("uBlurQuality")
	new_shader_uniform("uBlurSize")
}

with (shader_map[?shader_high_ssao])
{
	new_shader_sampler("uDepthBuffer")
	new_shader_sampler("uNormalBuffer")
	new_shader_sampler("uBrightnessBuffer")
	new_shader_sampler("uNoiseBuffer")
	new_shader_uniform("uNear")
	new_shader_uniform("uFar")
	new_shader_uniform("uProjMatrix")
	new_shader_uniform("uProjMatrixInv")
	new_shader_uniform("uScreenSize")
	new_shader_uniform("uKernel")
	new_shader_uniform("uRadius")
	new_shader_uniform("uPower")
	new_shader_uniform("uColor")
}

with (shader_map[?shader_high_ssao_blur])
{
	new_shader_sampler("uDepthBuffer")
	new_shader_sampler("uNormalBuffer")
	new_shader_uniform("uScreenSize")
	new_shader_uniform("uPixelCheck")
}

with (shader_map[?shader_high_ssao_depth_normal])
{
	new_shader_uniform("uSSAOEnable")
	new_shader_uniform("uBrightness")
	new_shader_uniform("uNear")
	new_shader_uniform("uFar")
}

return true
