/// shader_high_ssr_set(depthsurface, normalsurface, normalsurface2, colorsurf)
/// @arg depthsurface
/// @arg normalsurface
/// @arg normalsurface2
/// @arg colorsurf

texture_set_stage(sampler_map[?"uDepthBuffer"], surface_get_texture(argument0))
texture_set_stage(sampler_map[?"uNormalBuffer"], surface_get_texture(argument1))
texture_set_stage(sampler_map[?"uNormalBufferExp"], surface_get_texture(argument2))
texture_set_stage(sampler_map[?"uColorBuffer"], surface_get_texture(argument3))

render_set_uniform("uNear", cam_near)
render_set_uniform("uFar", cam_far)
render_set_uniform("uProjMatrix", proj_matrix)
render_set_uniform("uProjMatrixInv", matrix_inverse(proj_matrix))
render_set_uniform("uViewMatrix", view_proj_matrix)
render_set_uniform("uViewMatrixInv", matrix_inverse(view_proj_matrix))

render_set_uniform("uStepSize", app.setting_render_ssr_step_size)
render_set_uniform_int("uStepAmount", app.setting_render_ssr_step_amount)
render_set_uniform_int("uRefineSteps", app.setting_render_ssr_refine_amount)
render_set_uniform("uRefineDepthTest", app.setting_render_ssr_refine_depth)
render_set_uniform("uMetallic", app.setting_render_ssr_metallic)
render_set_uniform("uRoughness", app.setting_render_ssr_roughness)

render_set_uniform_color("uSkyColor", merge_color(app.background_sky_color, c_black, background_sky_night_alpha() * 0.95), 1.0)
