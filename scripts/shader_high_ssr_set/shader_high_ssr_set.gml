/// shader_high_ssr_set(depthsurface, normalsurface)
/// @arg depthsurface
/// @arg normalsurface

texture_set_stage(sampler_map[?"uDepthBuffer"], surface_get_texture(argument0))
texture_set_stage(sampler_map[?"uNormalBuffer"], surface_get_texture(argument1))

render_set_uniform("uNear", cam_near)
render_set_uniform("uFar", cam_far)
render_set_uniform("uProjMatrix", proj_matrix)
render_set_uniform("uProjMatrixInv", matrix_inverse(proj_matrix))
render_set_uniform("uViewMatrixInv", matrix_inverse(matrix_get(matrix_view)))

render_set_uniform("uStepSize", app.setting_render_ssr_step_size)
render_set_uniform_int("uStepAmount", app.setting_render_ssr_step_amount)
render_set_uniform_int("uRefineSteps", app.setting_render_ssr_refine_amount)
render_set_uniform("uRefineDepthTest", app.setting_render_ssr_refine_depth)
render_set_uniform("uMetallic", app.setting_render_ssr_metallic)
render_set_uniform("uSpecular", app.setting_render_ssr_specular)
