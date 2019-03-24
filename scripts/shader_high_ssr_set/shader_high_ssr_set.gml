/// shader_high_ssr_set(colorsurf, depthsurface, normalsurface)
/// @arg colorsurf
/// @arg depthsurface
/// @arg normalsurface

texture_set_stage(sampler_map[?"uColorBuffer"], surface_get_texture(argument0))
texture_set_stage(sampler_map[?"uDepthBuffer"], surface_get_texture(argument1))
texture_set_stage(sampler_map[?"uNormalBuffer"], surface_get_texture(argument2))

render_set_uniform("uNear", cam_near)
render_set_uniform("uFar", cam_far)
render_set_uniform("uProjMatrix", proj_matrix)
render_set_uniform("uProjMatrixInv", matrix_inverse(proj_matrix))