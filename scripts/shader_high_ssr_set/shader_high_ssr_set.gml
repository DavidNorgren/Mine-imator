/// shader_high_ssao_set(depthsurface, normalsurface, projection, view)
/// @arg depthsurface
/// @arg normalsurface
/// @arg projection
/// @arg view


log(sampler_map[?"uDepthBuffer"])
texture_set_stage(sampler_map[?"uDepthBuffer"], surface_get_texture(argument0))
texture_set_stage(sampler_map[?"uNormalBuffer"], surface_get_texture(argument1))

render_set_uniform("uNear", 0.1)
render_set_uniform("uFar", 5000)
render_set_uniform("uProjMatrix", argument2)
render_set_uniform("uProjMatrixInv", matrix_inverse(argument2))
log("matrix",argument2)
log("proj_matrix", proj_matrix)