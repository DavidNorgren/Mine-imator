/// shader_high_ssao_blur_set(raysurface, depthsurface, checkx, checky)
/// @arg raysurface
/// @arg depthsurface
/// @arg checkx
/// @arg checky

var raybuffer = argument0;

//texture_set_stage(sampler_map[?"uRayBuffer"], surface_get_texture(argument0))
texture_set_stage(sampler_map[?"uDepthBuffer"], surface_get_texture(argument1))
//gpu_set_texrepeat_ext(sampler_map[?"uRayBuffer"], false)
gpu_set_texrepeat_ext(sampler_map[?"uDepthBuffer"], false)

render_set_uniform_vec2("uScreenSize", render_width, render_height)
render_set_uniform_vec2("uPixelCheck", argument2, argument3)
