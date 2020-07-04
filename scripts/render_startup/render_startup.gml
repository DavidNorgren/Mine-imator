/// render_startup()

globalvar render_view_current, render_width, render_height, render_ratio, render_camera, render_time, render_surface_time,
		  render_target, render_surface, render_prev_color, render_prev_alpha, render_click_box, render_list, render_lights,
		  render_particles, render_hidden, render_background, render_watermark, render_light_amount, render_light_from,
		  render_light_to, render_light_near, render_light_far, render_light_fov, render_light_color, render_light_fade_size,
		  render_light_spot_sharpness, render_light_matrix, proj_from, proj_matrix, view_proj_matrix, proj_depth_near, proj_depth_far,
		  render_proj_from, render_active;

globalvar render_camera_bloom, render_camera_dof, render_camera_color_correction, render_camera_grain, render_camera_vignette, render_overlay;

log("Render init")
	
gpu_set_blendenable(true)
gpu_set_blendmode(bm_normal)
gpu_set_alphatestenable(true)
gpu_set_alphatestref(0)
gpu_set_texfilter(false)
gpu_set_tex_mip_enable(mip_off)
gpu_set_tex_mip_filter(tf_linear)
gpu_set_texrepeat(true)
gpu_set_ztestenable(false)
gpu_set_zwriteenable(false)
render_set_culling(true)

render_view_current = null
render_width = 1
render_height = 1
render_ratio = 1
render_camera = null
render_camera_bloom = false
render_camera_dof = false
render_camera_color_correction = false
render_camera_grain = false
render_camera_vignette = false
render_overlay = false

render_click_box = vbuffer_create_cube(view_3d_box_size / 2, point2D(0, 0), point2D(1, 1), 1, 1, false, false)
render_list = ds_list_create()
render_lights = true
render_particles = true
render_hidden = false
render_background = true
render_watermark = false

render_time = 0
render_surface_time = 0
render_active = null

render_target = null
render_surface[0] = null
render_surface[1] = null
render_surface[2] = null
render_surface[3] = null
render_surface[4] = null
render_surface[5] = null

// Shadows
globalvar render_shadowless_point_list, render_shadowless_point_data, render_shadowless_point_amount, render_surface_sun_buffer,
render_surface_spot_buffer, render_surface_point_buffer;

render_shadowless_point_amount = 0
render_shadowless_point_list = ds_list_create()
render_surface_sun_buffer = null
render_surface_spot_buffer = null
for (var d = 0; d < 6; d++)
	render_surface_point_buffer[d] = null

// SSAO
globalvar render_ssao_kernel, render_ssao_noise;
render_ssao_kernel = render_generate_sample_kernel(16)
render_ssao_noise = null

// Render modes
globalvar render_mode, render_mode_shader_map, render_shader_obj;
render_mode_shader_map = ds_map_create()
render_mode_shader_map[?e_render_mode.CLICK] = shader_replace
render_mode_shader_map[?e_render_mode.SELECT] = shader_blend
render_mode_shader_map[?e_render_mode.PREVIEW] = shader_color_fog
render_mode_shader_map[?e_render_mode.COLOR_FOG] = shader_color_fog
render_mode_shader_map[?e_render_mode.COLOR_FOG_LIGHTS] = shader_color_fog_lights
render_mode_shader_map[?e_render_mode.ALPHA_FIX] = shader_alpha_fix
render_mode_shader_map[?e_render_mode.ALPHA_TEST] = shader_alpha_test
render_mode_shader_map[?e_render_mode.HIGH_SSAO_DEPTH_NORMAL] = shader_high_ssao_depth_normal
render_mode_shader_map[?e_render_mode.HIGH_SSR_DEPTH_NORMAL] = shader_high_ssr_depth_normal
render_mode_shader_map[?e_render_mode.HIGH_DOF_DEPTH] = shader_depth
render_mode_shader_map[?e_render_mode.HIGH_LIGHT_SUN_DEPTH] = shader_depth
render_mode_shader_map[?e_render_mode.HIGH_LIGHT_SPOT_DEPTH] = shader_depth
render_mode_shader_map[?e_render_mode.HIGH_LIGHT_POINT_DEPTH] = shader_depth_point
render_mode_shader_map[?e_render_mode.HIGH_LIGHT_SUN] = shader_high_light_sun
render_mode_shader_map[?e_render_mode.HIGH_LIGHT_SPOT] = shader_high_light_spot
render_mode_shader_map[?e_render_mode.HIGH_LIGHT_POINT] = shader_high_light_point
render_mode_shader_map[?e_render_mode.HIGH_LIGHT_POINT_SHADOWLESS] = shader_high_light_point_shadowless
render_mode_shader_map[?e_render_mode.HIGH_LIGHT_NIGHT] = shader_high_light_night
render_mode_shader_map[?e_render_mode.HIGH_FOG] = shader_high_fog
render_mode_shader_map[?e_render_mode.COLOR_GLOW] = shader_color_glow