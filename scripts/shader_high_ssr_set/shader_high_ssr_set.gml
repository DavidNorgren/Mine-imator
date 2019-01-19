/// shader_high_ssao_set(depthsurface, normalsurface, projection, view)
/// @arg depthsurface
/// @arg normalsurface
/// @arg projection
/// @arg view


log(sampler_map[?"uDepthBuffer"])
texture_set_stage(sampler_map[?"uDepthBuffer"], surface_get_texture(argument0))
texture_set_stage(sampler_map[?"uNormalBuffer"], surface_get_texture(argument1))

/*render_set_uniform("uProjMatrix", proj_matrix)
render_set_uniform("uProjMatrixInv", matrix_inverse(proj_matrix))
render_set_uniform("uViewMatrix", matrix_get(matrix_view))
render_set_uniform("uViewMatrixInv", matrix_inverse(matrix_get(matrix_view)))
render_set_uniform_vec2("uScreenSize", render_width, render_height)*/
