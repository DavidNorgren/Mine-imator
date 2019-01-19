/// shader_high_ssao_set(depthsurface, normalsurface, brightnesssurf)
/// @arg depthsurface
/// @arg normalsurface
/// @arg brightnesssurf
/// @arg colorsurf

texture_set_stage(sampler_map[?"uDepthBuffer"], surface_get_texture(argument0))
texture_set_stage(sampler_map[?"uNormalBuffer"], surface_get_texture(argument1))
texture_set_stage(sampler_map[?"uBrightnessBuffer"], surface_get_texture(argument2))
texture_set_stage(sampler_map[?"uNoiseBuffer"], surface_get_texture(render_ssao_noise))
gpu_set_texrepeat_ext(sampler_map[?"uDepthBuffer"], false)
gpu_set_texrepeat_ext(sampler_map[?"uNormalBuffer"], false)
gpu_set_texrepeat_ext(sampler_map[?"uBrightnessBuffer"], false)
gpu_set_texrepeat_ext(sampler_map[?"uNoiseBuffer"], true)

render_set_uniform("uNear", cam_near)
render_set_uniform("uFar", cam_far)
render_set_uniform("uProjMatrix", proj_matrix)
render_set_uniform("uProjMatrixInv", matrix_inverse(proj_matrix))
render_set_uniform_vec2("uScreenSize", render_width, render_height)

render_set_uniform("uKernel", render_ssao_kernel)
render_set_uniform("uRadius", app.setting_render_ssao_radius)
render_set_uniform("uPower", app.setting_render_ssao_power)
render_set_uniform_color("uColor", app.setting_render_ssao_color, 1)
