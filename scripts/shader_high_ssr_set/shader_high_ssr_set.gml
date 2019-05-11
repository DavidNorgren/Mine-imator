/// shader_high_ssr_set(colorsurf, depthsurface, normalsurface)
/// @arg colorsurf
/// @arg depthsurface
/// @arg normalsurface

texture_set_stage(sampler_map[?"uColorBuffer"], surface_get_texture(argument0))
texture_set_stage(sampler_map[?"uDepthBuffer"], surface_get_texture(argument1))
texture_set_stage(sampler_map[?"uNormalBuffer"], surface_get_texture(argument2))
texture_set_stage(sampler_map[?"uNoiseBuffer"], surface_get_texture(render_ssao_noise))
gpu_set_texrepeat_ext(sampler_map[?"uNoiseBuffer"], true)
gpu_set_texfilter_ext(sampler_map[?"uNoiseBuffer"], true)

render_set_uniform("uNear", cam_near)
render_set_uniform("uFar", cam_far)
render_set_uniform("uProjMatrix", proj_matrix)
render_set_uniform("uProjMatrixInv", matrix_inverse(proj_matrix))
render_set_uniform("uViewMatrixInv", matrix_inverse(matrix_get(matrix_view)))

render_set_uniform_vec2("uScreenSize", render_width, render_height)
render_set_uniform("uKernel", render_ssao_kernel)

render_set_uniform("uBlurStrength", app.setting_render_shadows_blur_size)
