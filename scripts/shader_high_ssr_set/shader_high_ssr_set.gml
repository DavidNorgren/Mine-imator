/// shader_high_ssr_set(colorsurf, depthsurface, normalsurface, projection, view)
/// @arg colorsurf
/// @arg depthsurface
/// @arg normalsurface
/// @arg projection
/// @arg view

texture_set_stage(sampler_map[?"uColorBuffer"], surface_get_texture(argument0))
texture_set_stage(sampler_map[?"uDepthBuffer"], surface_get_texture(argument1))
texture_set_stage(sampler_map[?"uNormalBuffer"], surface_get_texture(argument2))

render_set_uniform("uNear", 0.1)
render_set_uniform("uFar", 5000)
render_set_uniform("uProjMatrix", argument3)
render_set_uniform("uProjMatrixInv", matrix_inverse(argument3))