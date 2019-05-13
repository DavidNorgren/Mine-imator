/// shader_high_ssr_color_set(raysurf)
/// @arg raysurf

texture_set_stage(sampler_map[?"uRayBuffer"], surface_get_texture(argument0))
render_set_uniform_color("uSkyColor", app.background_sky_color, 1.0)