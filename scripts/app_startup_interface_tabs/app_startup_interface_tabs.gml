/// app_startup_interface_tabs()

tab_move = null
tab_move_name = ""
tab_move_x = 0
tab_move_width = 0
tab_move_direction = e_scroll.VERTICAL
tab_move_box_x = 0
tab_move_box_y = 0
tab_move_box_width = 0
tab_move_box_height = 0
tab_move_mouseon_panel = null
tab_move_mouseon_position = 0

// Project properties
properties = new_tab(setting_properties_location, true)
with (properties)
{
	// Project
	project = tab_add_category("project", tab_properties_project, false)
	with (project)
	{
		tbx_name = new_textbox(true, 0, "")
		tbx_author = new_textbox(true, 0, "")
		tbx_description = new_textbox(false, 0, "")
		tbx_video_size_custom_width = new_textbox_integer()
		tbx_video_size_custom_height = new_textbox_integer()
		tbx_tempo = new_textbox_integer()
		tbx_name.next_tbx = tbx_author
		tbx_author.next_tbx = tbx_description
		tbx_description.next_tbx = tbx_name
	}
	
	// Library
	library = tab_add_category("library", tab_properties_library, false)
	with (library)
	{
		preview = new(obj_preview)
		preview.spawn_active = false
		list = new(obj_sortlist)
		list.can_deselect = true
		list.script = action_lib_list
		sortlist_column_add(list, "libname", 0)
		sortlist_column_add(list, "libtype", 0.45)
		sortlist_column_add(list, "libcount", 0.75)
		tbx_name = new_textbox(1, 0, "")
		tbx_repeat_x = new_textbox_integer()
		tbx_repeat_y = new_textbox_integer()
		tbx_repeat_z = new_textbox_integer()
		tbx_shape_detail = new_textbox_integer()
		tbx_shape_tex_hoffset = new_textbox_ndecimals()
		tbx_shape_tex_voffset = new_textbox_ndecimals()
		tbx_shape_tex_hrepeat = new_textbox_decimals()
		tbx_shape_tex_vrepeat = new_textbox_decimals()
	}
	
	// Background
	background = tab_add_category("background", tab_properties_background, false)
	with (background)
	{
		tbx_sunlight_strength = new_textbox_decimals()
		tbx_sunlight_strength.suffix = "%"
		tbx_desaturate_night_amount = new_textbox_decimals()
		tbx_desaturate_night_amount.suffix = "%"
		tbx_sky_clouds_fade_distance = new_textbox_integer()
		tbx_sky_clouds_z = new_textbox_ndecimals()
		tbx_sky_clouds_size = new_textbox_decimals()
		tbx_sky_clouds_height = new_textbox_decimals()
		tbx_sky_clouds_speed = new_textbox_ndecimals()
		tbx_sky_clouds_offset = new_textbox_ndecimals()
		tbx_fog_distance = new_textbox_integer()
		tbx_fog_size = new_textbox_integer()
		tbx_fog_height = new_textbox_integer()
		tbx_wind_speed = new_textbox_decimals()
		tbx_wind_speed.suffix = "%"
		tbx_wind_strength = new_textbox_decimals()
		tbx_sunlight_range = new_textbox_integer()
		tbx_texture_animation_speed = new_textbox_ndecimals()
	}
	
	// Resources
	resources = tab_add_category("resources", tab_properties_resources, false)
	with (resources)
	{
		preview = new(obj_preview)
		list = new(obj_sortlist)
		list.can_deselect = true
		list.script = action_res_list
		sortlist_column_add(list, "resname", 0)
		sortlist_column_add(list, "restype", 0.45)
		sortlist_column_add(list, "rescount", 0.75)
		sortlist_add(list, mc_res)
		
		tbx_item_sheet_width = new_textbox_integer()
		tbx_item_sheet_height = new_textbox_integer()
	}
}

lib_preview = properties.library.preview
lib_list = properties.library.list
res_preview = properties.resources.preview
res_list = properties.resources.list

// Ground editor
ground_editor = new_tab(setting_ground_editor_location, false)
ground_editor.script = tab_ground_editor
with (ground_editor)
	ground_scroll = new(obj_scrollbar)

// Template editor
template_editor = new_tab(setting_template_editor_location, false)
template_editor.script = tab_template_editor

with (template_editor)
{
	// Character list
	char_list = new(obj_sortlist)
	char_list.script = action_lib_model_name
	sortlist_column_add(char_list, "charname", 0)
	for (var c = 0; c < ds_list_size(mc_assets.char_list); c++)
		sortlist_add(char_list, mc_assets.char_list[|c].name)
		
	// Item
	item_scroll = new(obj_scrollbar)
	
	// Block
	block_list = new(obj_sortlist)
	block_list.script = action_lib_block_name
	sortlist_column_add(block_list, "blockname", 0)
	for (var b = 0; b < ds_list_size(mc_assets.block_list); b++)
		if (!mc_assets.block_list[|b].timeline || mc_assets.block_list[|b].tl_model_name = "")
			sortlist_add(block_list, mc_assets.block_list[|b].name)
	
	// Special block list
	special_block_list = new(obj_sortlist)
	special_block_list.script = action_lib_model_name
	sortlist_column_add(special_block_list, "spblockname", 0)
	for (var b = 0; b < ds_list_size(mc_assets.special_block_list); b++)
		sortlist_add(special_block_list, mc_assets.special_block_list[|b].name)
	
	// Bodypart list
	bodypart_model_list = new(obj_sortlist)
	bodypart_model_list.script = action_lib_bodypart_model_name
	sortlist_column_add(bodypart_model_list, "bodypartmodelname", 0)
	for (var m = 0; m < ds_list_size(mc_assets.char_list); m++)
		sortlist_add(bodypart_model_list, mc_assets.char_list[|m].name)
	for (var m = 0; m < ds_list_size(mc_assets.special_block_list); m++)
		sortlist_add(bodypart_model_list, mc_assets.special_block_list[|m].name)
		
	// Particle editor
	tbx_spawn_amount = new_textbox_integer()

	tbx_spawn_region_sphere_radius = new_textbox_decimals()
	tbx_spawn_region_cube_size = new_textbox_decimals()
	tbx_spawn_region_box_xsize = new_textbox_decimals()
	tbx_spawn_region_box_ysize = new_textbox_decimals()
	tbx_spawn_region_box_zsize = new_textbox_decimals()
	
	tbx_bounding_box_ground_z = new_textbox_ndecimals()
	tbx_bounding_box_custom_xstart = new_textbox_ndecimals()
	tbx_bounding_box_custom_ystart = new_textbox_ndecimals()
	tbx_bounding_box_custom_zstart = new_textbox_ndecimals()
	tbx_bounding_box_custom_xend = new_textbox_ndecimals()
	tbx_bounding_box_custom_yend = new_textbox_ndecimals()
	tbx_bounding_box_custom_zend = new_textbox_ndecimals()
	
	tbx_destroy_at_amount_val = new_textbox_integer()
	tbx_destroy_at_time_seconds = new_textbox_ndecimals()
	tbx_destroy_at_time_random = new_textbox_ndecimals()
	
	type_list = new(obj_sortlist)
	type_list.script = action_lib_pc_type_list
	type_list.can_deselect = true
	sortlist_column_add(type_list, "particleeditortypename", 0)
	sortlist_column_add(type_list, "particleeditortypekind", 0.4)
	sortlist_column_add(type_list, "particleeditortyperate", 0.75)
	preview_start = current_time
	preview_speed = 1
	
	tbx_type_name = new_textbox(true, 0, "")
	tbx_type_spawn_rate = new_textbox_integer()
	tbx_type_spawn_rate.suffix = "%"
	tbx_type_text = new_textbox(false, 0, "")
	tbx_type_sprite_frame_width = new_textbox_integer()
	tbx_type_sprite_frame_height = new_textbox_integer()
	tbx_type_sprite_frame_start = new_textbox_integer()
	tbx_type_sprite_frame_end = new_textbox_integer()
	
	tbx_type_sprite_animation_speed = new_textbox_decimals()
	tbx_type_sprite_animation_speed_random = new_textbox_decimals()
	
	tbx_type_xspd = new_textbox_ndecimals()
	tbx_type_xspd_random = new_textbox_ndecimals()
	tbx_type_yspd = new_textbox_ndecimals()
	tbx_type_yspd_random = new_textbox_ndecimals()
	tbx_type_zspd = new_textbox_ndecimals()
	tbx_type_zspd_random = new_textbox_ndecimals()
	tbx_type_xspd_add = new_textbox_ndecimals()
	tbx_type_xspd_add_random = new_textbox_ndecimals()
	tbx_type_yspd_add = new_textbox_ndecimals()
	tbx_type_yspd_add_random = new_textbox_ndecimals()
	tbx_type_zspd_add = new_textbox_ndecimals()
	tbx_type_zspd_add_random = new_textbox_ndecimals()
	tbx_type_xspd_mul = new_textbox_ndecimals()
	tbx_type_xspd_mul_random = new_textbox_ndecimals()
	tbx_type_yspd_mul = new_textbox_ndecimals()
	tbx_type_yspd_mul_random = new_textbox_ndecimals()
	tbx_type_zspd_mul = new_textbox_ndecimals()
	tbx_type_zspd_mul_random = new_textbox_ndecimals()
	
	tbx_type_xrot = new_textbox_ndecimals()
	tbx_type_xrot.suffix = "°"
	tbx_type_xrot_random = new_textbox_ndecimals()
	tbx_type_xrot_random.suffix = "°"
	tbx_type_yrot = new_textbox_ndecimals()
	tbx_type_yrot.suffix = "°"
	tbx_type_yrot_random = new_textbox_ndecimals()
	tbx_type_yrot_random.suffix = "°"
	tbx_type_zrot = new_textbox_ndecimals()
	tbx_type_zrot.suffix = "°"
	tbx_type_zrot_random = new_textbox_ndecimals()
	tbx_type_zrot_random.suffix = "°"
	
	tbx_type_xrot_spd = new_textbox_ndecimals()
	tbx_type_xrot_spd_random = new_textbox_ndecimals()
	tbx_type_yrot_spd = new_textbox_ndecimals()
	tbx_type_yrot_spd_random = new_textbox_ndecimals()
	tbx_type_zrot_spd = new_textbox_ndecimals()
	tbx_type_zrot_spd_random = new_textbox_ndecimals()
	tbx_type_xrot_spd_add = new_textbox_ndecimals()
	tbx_type_xrot_spd_add_random = new_textbox_ndecimals()
	tbx_type_yrot_spd_add = new_textbox_ndecimals()
	tbx_type_yrot_spd_add_random = new_textbox_ndecimals()
	tbx_type_zrot_spd_add = new_textbox_ndecimals()
	tbx_type_zrot_spd_add_random = new_textbox_ndecimals()
	tbx_type_xrot_spd_mul = new_textbox_ndecimals()
	tbx_type_xrot_spd_mul_random = new_textbox_ndecimals()
	tbx_type_yrot_spd_mul = new_textbox_ndecimals()
	tbx_type_yrot_spd_mul_random = new_textbox_ndecimals()
	tbx_type_zrot_spd_mul = new_textbox_ndecimals()
	tbx_type_zrot_spd_mul_random = new_textbox_ndecimals()
	
	tbx_type_sprite_angle = new_textbox_ndecimals()
	tbx_type_sprite_angle.suffix = "°"
	tbx_type_sprite_angle_random = new_textbox_ndecimals()
	tbx_type_sprite_angle_random.suffix = "°"
	tbx_type_sprite_angle_add = new_textbox_ndecimals()
	tbx_type_sprite_angle_add.suffix = "°"
	tbx_type_sprite_angle_add_random = new_textbox_ndecimals()
	tbx_type_sprite_angle_add_random.suffix = "°"
	
	tbx_type_scale = new_textbox_ndecimals()
	tbx_type_scale_random = new_textbox_ndecimals()
	tbx_type_scale_add = new_textbox_ndecimals()
	tbx_type_scale_add_random = new_textbox_ndecimals()
	
	tbx_type_alpha = new_textbox_integer()
	tbx_type_alpha.suffix = "%"
	tbx_type_alpha_random = new_textbox_integer()
	tbx_type_alpha_random.suffix = "%"
	tbx_type_alpha_add = new_textbox_integer()
	tbx_type_alpha_add.suffix = "%"
	tbx_type_alpha_add_random = new_textbox_integer()
	tbx_type_alpha_add_random.suffix = "%"
	
	tbx_type_color_mix_time = new_textbox_decimals()
	tbx_type_color_mix_time_random = new_textbox_decimals()
	
	tbx_type_bounce_factor = new_textbox_decimals()
}

ptype_list = template_editor.type_list

// Timeline
timeline = new_tab(setting_timeline_location, true)
timeline.script = tab_timeline
with (timeline)
{
	list_width = 320
	hor_scroll = new(obj_scrollbar)
	ver_scroll = new(obj_scrollbar)
}

// Timeline editor
timeline_editor = new_tab(setting_timeline_editor_location, false)
with (timeline_editor)
{
	// Information
	info = tab_add_category("timelineeditorinfo", tab_timeline_editor_info, true)
	with (info)
	{
		rot_point_mouseon = false
		rot_point_snap = false
		rot_point_snap_size = 1
		rot_point_copy = point3D(0, 0, 0)
		tbx_name = new_textbox(true, 0, "")
		tbx_text = new_textbox(false, 0, "")
		tbx_rot_point_x = new_textbox_ndecimals()
		tbx_rot_point_y = new_textbox_ndecimals()
		tbx_rot_point_z = new_textbox_ndecimals()
		tbx_rot_point_snap = new_textbox_decimals()
		tbx_rot_point_snap.text = string(rot_point_snap_size)
	}
	
	// Hierarchy
	hierarchy = tab_add_category("timelineeditorhierarchy", tab_timeline_editor_hierarchy, true)
	
	// Graphics
	graphics = tab_add_category("timelineeditorgraphics", tab_timeline_editor_graphics, false)
	with (graphics)
		tbx_depth = new_textbox_ninteger()
		
	// Audio
	audio = tab_add_category("timelineeditoraudio", tab_timeline_editor_audio, true)
}

// Frame editor
frame_editor = new_tab(setting_frame_editor_location, false)
with (frame_editor)
{
	// Position
	position = tab_add_category("frameeditorposition", tab_frame_editor_position, false)
	with (position)
	{
		snap_enabled = false
		snap_size = 16
		copy = point3D(0, 0, 0)
		tbx_x = new_textbox_ndecimals()
		tbx_y = new_textbox_ndecimals()
		tbx_z = new_textbox_ndecimals()
		tbx_snap = new_textbox_decimals()
		tbx_snap.text = string(snap_size)
	}
	
	// Rotation
	rotation = tab_add_category("frameeditorrotation", tab_frame_editor_rotation, false)
	with (rotation)
	{
		loops = false
		snap_enabled = false
		snap_size = 15
		copy = point3D(0, 0, 0)
		tbx_x = new_textbox_ndecimals()
		tbx_x.suffix = "°"
		tbx_y = new_textbox_ndecimals()
		tbx_y.suffix = "°"
		tbx_z = new_textbox_ndecimals()
		tbx_z.suffix = "°"
		tbx_loops_x = new_textbox_ndecimals()
		tbx_loops_y = new_textbox_ndecimals()
		tbx_loops_z = new_textbox_ndecimals()
		tbx_snap = new_textbox_decimals()
		tbx_snap.text = string(snap_size)
	}
	
	// Scale
	scale = tab_add_category("frameeditorscale", tab_frame_editor_scale, false)
	with (scale)
	{
		scale_all = true
		snap_enabled = false
		snap_size = 0.25
		copy = point3D(1, 1, 1)
		tbx_x = new_textbox_decimals()
		tbx_y = new_textbox_decimals()
		tbx_z = new_textbox_decimals()
		tbx_snap = new_textbox_decimals()
		tbx_snap.text = string(snap_size)
	}
	
	// Bend
	bend = tab_add_category("frameeditorbend", tab_frame_editor_bend, false)
	with (bend)
	{
		snap_enabled = false
		snap_size = 15
		copy = vec3(0)
		tbx_wheel[0] = new_textbox_ndecimals()
		tbx_wheel[0].suffix = "°"
		tbx_wheel[1] = new_textbox_ndecimals()
		tbx_wheel[1].suffix = "°"
		tbx_wheel[2] = new_textbox_ndecimals()
		tbx_wheel[2].suffix = "°"
		tbx_snap = new_textbox_decimals()
		tbx_snap.text = string(snap_size)
	}
	
	// Color
	color = tab_add_category("frameeditorcolor", tab_frame_editor_color, false)
	with (color)
	{
		advanced = app.setting_frame_editor_color_advanced
		copy_alpha = 1
		copy_rgb_add = c_black
		copy_rgb_sub = c_black
		copy_rgb_mul = c_white
		copy_hsb_add = c_black
		copy_hsb_sub = c_black
		copy_hsb_mul = c_white
		copy_mix_color = c_black
		copy_glow_color = c_white
		copy_mix_percent = 0
		copy_brightness = 0
		tbx_alpha = new_textbox_integer()
		tbx_alpha.suffix = "%"
		tbx_mix_percent = new_textbox_integer()
		tbx_mix_percent.suffix = "%"
		tbx_brightness = new_textbox_integer()
		tbx_brightness.suffix = "%"
	}
	
	// Particles
	particles = tab_add_category("frameeditorparticles", tab_frame_editor_particles, false)
	with (particles)
	{
		tbx_seed = new_textbox_ninteger()
		tbx_force = new_textbox_ndecimals()
	}
	
	// Light
	light = tab_add_category("frameeditorlight", tab_frame_editor_light, false)
	with (light)
	{
		copy_color = c_white
		copy_range = 250
		copy_fade_size = 0.5
		copy_spot_radius = 50
		copy_spot_sharpness = 0.5
		has_spotlight = false
		tbx_range = new_textbox_decimals()
		tbx_fade_size = new_textbox_integer()
		tbx_fade_size.suffix = "%"
		tbx_spot_radius = new_textbox_decimals()
		tbx_spot_sharpness = new_textbox_integer()
		tbx_spot_sharpness.suffix = "%"
	}
	
	// Camera
	camera = tab_add_category("frameeditorcamera", tab_frame_editor_camera, false)
	with (camera)
	{
		video_template = null
		look_at_rotate = true
		tbx_fov = new_textbox_integer()
		tbx_fov.suffix = "°"
		tbx_ratio = new_textbox_decimals()
		tbx_rotate_distance = new_textbox_decimals()
		tbx_rotate_angle_xy = new_textbox_ndecimals()
		tbx_rotate_angle_xy.suffix = "°"
		tbx_rotate_angle_z = new_textbox_ndecimals()
		tbx_rotate_angle_z.suffix = "°"
		tbx_dof_depth = new_textbox_decimals()
		tbx_dof_range = new_textbox_decimals()
		tbx_dof_fade_size = new_textbox_decimals()
		tbx_dof_blur_size = new_textbox_decimals()
		tbx_dof_blur_size.suffix = "%"
		tbx_dof_fringe_angle_red = new_textbox_ndecimals()
		tbx_dof_fringe_angle_red.suffix = "°"
		tbx_dof_fringe_angle_green = new_textbox_ndecimals()
		tbx_dof_fringe_angle_green.suffix = "°"
		tbx_dof_fringe_angle_blue = new_textbox_ndecimals()
		tbx_dof_fringe_angle_blue.suffix = "°"
		tbx_dof_fringe_red = new_textbox_integer()
		tbx_dof_fringe_red.suffix = "%"
		tbx_dof_fringe_green = new_textbox_integer()
		tbx_dof_fringe_green.suffix = "%"
		tbx_dof_fringe_blue = new_textbox_integer()
		tbx_dof_fringe_blue.suffix = "%"
		tbx_video_size_custom_width = new_textbox_integer()
		tbx_video_size_custom_height = new_textbox_integer()
		tbx_bloom_threshold = new_textbox_integer()
		tbx_bloom_threshold.suffix = "%"
		tbx_bloom_intensity = new_textbox_integer()
		tbx_bloom_intensity.suffix = "%"
		tbx_bloom_radius = new_textbox_integer()
		tbx_bloom_radius.suffix = "%"
		tbx_contrast = new_textbox_integer()
		tbx_contrast.suffix = "%"
		tbx_brightness = new_textbox_integer()
		tbx_brightness.suffix = "%"
		tbx_saturation = new_textbox_integer()
		tbx_saturation.suffix = "%"
		tbx_grain_strength = new_textbox_ninteger()
		tbx_grain_strength.suffix = "%"
		tbx_grain_saturation = new_textbox_integer()
		tbx_grain_saturation.suffix = "%"
		tbx_grain_size = new_textbox_integer()
		tbx_vignette_radius = new_textbox_integer()
		tbx_vignette_radius.suffix = "%"
		tbx_vignette_softness = new_textbox_integer()
		tbx_vignette_softness.suffix = "%"
		tbx_vignette_strength = new_textbox_integer()
		tbx_vignette_strength.suffix = "%"
		
		snap_fringe_enabled = false
		snap_fringe_size = 22.5
		fringe_copy = array(0, 0, 0, 0, 0, 0)
		tbx_snap_fringe = new_textbox_decimals()
		tbx_snap_fringe.text = string(snap_fringe_size)
	}
	
	// Texture
	texture = tab_add_category("frameeditortexture", tab_frame_editor_texture, false)
	
	// Sound
	sound = tab_add_category("frameeditorsound", tab_frame_editor_sound, true)
	with (sound)
	{
		tbx_volume = new_textbox_integer()
		tbx_volume.suffix = "%"
		tbx_start = new_textbox_decimals()
		tbx_end = new_textbox_ndecimals()
	}
	
	// Text
	text = tab_add_category("frameeditortext", tab_frame_editor_text, false)
	with (text)
		tbx_text = new_textbox(false, 0, "")
	
	// Keyframe
	keyframe = tab_add_category("frameeditorkeyframe", tab_frame_editor_keyframe, false)
}

// Settings
settings = new_tab(setting_settings_location, false)
with (settings)
{
	// Program
	program = tab_add_category("settingsprogram", tab_settings_program, false)
	with (program)
	{
		tbx_backup_time = new_textbox_integer()
		tbx_backup_amount = new_textbox_integer()
	}
	
	// Interface
	interface = tab_add_category("settingsinterface", tab_settings_interface, false)
	with (interface)
	{
		tbx_tip_delay = new_textbox_decimals()
		tbx_view_grid_size_hor = new_textbox_integer()
		tbx_view_grid_size_ver = new_textbox_integer()
		tbx_view_real_time_render_time = new_textbox_integer()
	}
	
	// Controls
	controls = tab_add_category("settingscontrols", tab_settings_controls, false)
	with (controls)
	{
		tbx_move_speed = new_textbox_decimals()
		tbx_look_sensitivity = new_textbox_decimals()
		tbx_fast_modifier = new_textbox_decimals()
		tbx_slow_modifier = new_textbox_decimals()
	}
	
	// Graphics
	graphics = tab_add_category("settingsgraphics", tab_settings_graphics, false)
	with (graphics)
	{
		tbx_texture_filtering_level = new_textbox_integer()
		tbx_block_brightness = new_textbox_decimals()
		tbx_block_brightness.suffix = "%"
	}
	
	// Render
	render = tab_add_category("settingsrender", tab_settings_render, false)
	with (render)
	{
		tbx_ssao_range = new_textbox_decimals()
		tbx_ssao_radius = new_textbox_decimals()
		tbx_ssao_power = new_textbox_integer()
		tbx_ssao_power.suffix = "%"
		tbx_ssao_blur_passes = new_textbox_integer()
		tbx_shadows_blur_quality = new_textbox_integer()
		tbx_shadows_blur_size = new_textbox_integer()
		tbx_shadows_blur_size.suffix = "%"
		
		tbx_ssr_step_size = new_textbox_decimals()
		tbx_ssr_step_amount = new_textbox_integer()
		tbx_ssr_step_refine_amount = new_textbox_decimals()
		tbx_ssr_step_refine_depth = new_textbox_decimals()
		tbx_ssr_metallic = new_textbox_integer()
		tbx_ssr_specular = new_textbox_integer()
		
		tbx_glow_radius = new_textbox_integer()
		tbx_glow_radius.suffix = "%"
		tbx_glow_intensity = new_textbox_integer()
		tbx_glow_intensity.suffix = "%"
		tbx_glow_falloff_radius = new_textbox_integer()
		tbx_glow_falloff_radius.suffix = "%"
		tbx_glow_falloff_intensity = new_textbox_integer()
		tbx_glow_falloff_intensity.suffix = "%"
		tbx_aa_power = new_textbox_integer()
		tbx_aa_power.suffix = "%"
		tbx_watermark_scale = new_textbox_integer()
		tbx_watermark_scale.suffix = "%"
		tbx_watermark_alpha = new_textbox_integer()
		tbx_watermark_alpha.suffix = "%"
	}
	
	// Render
	cubist = tab_add_category("settingscubist", tab_settings_cubist, false)
	with (cubist)
	{
		tbx_ao_strength = new_textbox_decimals()
	}
}

