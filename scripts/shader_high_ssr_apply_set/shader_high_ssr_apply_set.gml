/// shader_high_ssr_apply_set(coordsurf, colorsurf, depthsurf, normalsurf)
/// @arg coordsurf
/// @arg colorsurf
/// @arg depthsurf
/// @arg normalsurf

texture_set_stage(sampler_map[?"uHitBuffer"], surface_get_texture(argument0))
texture_set_stage(sampler_map[?"uColorBuffer"], surface_get_texture(argument1))
var d = argument2;//texture_set_stage(sampler_map[?"uDepthBuffer"], surface_get_texture(argument2))
var n = argument3;//texture_set_stage(sampler_map[?"uNormalBuffer"], surface_get_texture(argument2))

render_set_uniform("uNear", cam_near)
render_set_uniform("uFar", cam_far)
render_set_uniform("uProjMatrix", proj_matrix)
render_set_uniform("uProjMatrixInv", matrix_inverse(proj_matrix))

render_set_uniform("uRoughness", app.setting_render_shadows_blur_size)

render_set_uniform_vec2("uScreenSize", render_width, render_height)
