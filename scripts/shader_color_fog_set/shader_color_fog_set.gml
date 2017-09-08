/// shader_color_fog_set()

var uTexture = shader_get_sampler_index(shader_color_fog, "uTexture"), 
	uBlendColor = shader_get_uniform(shader_color_fog, "uBlendColor"), 
	uColorsExt = shader_get_uniform(shader_color_fog, "uColorsExt"), 
	uRGBAdd = shader_get_uniform(shader_color_fog, "uRGBAdd"), 
	uRGBSub = shader_get_uniform(shader_color_fog, "uRGBSub"), 
	uRGBMul = shader_get_uniform(shader_color_fog, "uRGBMul"), 
	uHSBAdd = shader_get_uniform(shader_color_fog, "uHSBAdd"), 
	uHSBSub = shader_get_uniform(shader_color_fog, "uHSBSub"), 
	uHSBMul = shader_get_uniform(shader_color_fog, "uHSBMul"), 
	uMixColor = shader_get_uniform(shader_color_fog, "uMixColor");

shader_set(shader_color_fog)

// Texture
gpu_set_tex_filter_ext(uTexture, shader_texture_filter_linear)
gpu_set_tex_mip_enable(shader_texture_filter_mipmap)
gpu_set_tex_mip_filter_ext(uTexture, test(shader_texture_filter_mipmap, tf_linear, tf_point))
texture_set_stage(uTexture, texture_get(shader_texture))

// Color
shader_set_uniform_color(uBlendColor, shader_blend_color, shader_alpha)
shader_set_uniform_f(uColorsExt, bool_to_float(shader_colors_ext))
if (shader_colors_ext)
{
	shader_set_uniform_color(uRGBAdd, shader_rgbadd, 1)
	shader_set_uniform_color(uRGBSub, shader_rgbsub, 1)
	shader_set_uniform_color(uRGBMul, shader_rgbmul, shader_alpha)
	shader_set_uniform_color(uHSBAdd, shader_hsbadd, 1)
	shader_set_uniform_color(uHSBSub, shader_hsbsub, 1)
	shader_set_uniform_color(uHSBMul, shader_hsbmul, 1)
	shader_set_uniform_color(uMixColor, shader_mixcolor, shader_mixpercent)
}

// Fog
shader_set_fog(shader_color_fog)

// Wind
shader_set_wind(shader_color_fog)
