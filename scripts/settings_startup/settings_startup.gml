/// settings_startup()

trial_startup()

setting_minecraft_assets_version = minecraft_version
setting_minecraft_assets_new_version = ""
setting_minecraft_assets_new_format = 0
setting_minecraft_assets_new_changes = ""
setting_minecraft_assets_new_image = ""

setting_project_folder = projects_directory

recent_list = ds_list_create()
recent_thumbnail_width = 110
recent_thumbnail_height = 58
recent_add_wait = false

closed_alert_list = ds_list_create()

backup_next = 0
setting_backup = true
setting_backup_time = 10
setting_backup_amount = 3
setting_spawn_objects = true
setting_spawn_cameras = true

setting_tip_show = true
setting_tip_delay = 0.35

setting_view_grid_size_hor = 3
setting_view_grid_size_ver = 3
setting_view_real_time_render = true
setting_view_real_time_render_time = 100

font_main = font_add_lib(data_directory + "opensans.ttf", 10, false, false)
font_main_bold = font_add_lib(data_directory + "opensansbold.ttf", 10, false, false)
font_main_big = font_add_lib(data_directory + "opensansbold.ttf", 16, false, false)

setting_font = font_main
setting_font_bold = font_main_bold
setting_font_big = font_main_big
setting_font_filename = ""
setting_language_filename = language_file

action_setting_color_reset()

setting_timeline_autoscroll = true
setting_timeline_compact = false
setting_timeline_select_jump = true
setting_z_is_up = false
setting_smooth_camera = true

setting_toolbar_location = "top"
setting_toolbar_size = 90

setting_panel_left_bottom_size = 380
setting_panel_right_bottom_size = 380
setting_panel_bottom_size = 205
setting_panel_top_size = 205
setting_panel_left_top_size = 380
setting_panel_right_top_size = 380

setting_properties_location = "right_top"
setting_ground_editor_location = "right_bottom"
setting_template_editor_location = "right_bottom"
setting_timeline_location = "bottom"
setting_timeline_editor_location = "right_top"
setting_frame_editor_location = "right_bottom"
setting_frame_editor_color_advanced = false
setting_settings_location = "right_bottom"

setting_view_split = 0.5

setting_view_main_controls = true
setting_view_main_lights = true
setting_view_main_particles = true
setting_view_main_grid = false
setting_view_main_aspect_ratio = false
setting_view_main_location = "full"

setting_view_second_show = false
setting_view_second_controls = false
setting_view_second_lights = true
setting_view_second_particles = true
setting_view_second_grid = false
setting_view_second_aspect_ratio = true
setting_view_second_location = "right_bottom"
setting_view_second_width = 440
setting_view_second_height = 280

setting_modelbench_popup_hidden = false

setting_key_new = ord("N")
setting_key_new_control = true
setting_key_import_asset = ord("I")
setting_key_import_asset_control = true
setting_key_open = ord("O")
setting_key_open_control = true
setting_key_save = ord("S")
setting_key_save_control = true
setting_key_undo = ord("Z")
setting_key_undo_control = true
setting_key_redo = ord("Y")
setting_key_redo_control = true
setting_key_play = vk_space
setting_key_play_control = false
setting_key_play_beginning = vk_enter
setting_key_play_beginning_control = false
setting_key_move_marker_right = vk_right
setting_key_move_marker_right_control = false
setting_key_move_marker_left = vk_left
setting_key_move_marker_left_control = false
setting_key_render = vk_f5
setting_key_render_control = false
setting_key_folder = ord("F")
setting_key_folder_control = true
setting_key_select_timelines = ord("A")
setting_key_select_timelines_control = true
setting_key_duplicate_timelines = ord("D")
setting_key_duplicate_timelines_control = true
setting_key_remove_timelines = ord("R")
setting_key_remove_timelines_control = true
setting_key_create_keyframes = ord("Q")
setting_key_create_keyframes_control = true
setting_key_copy_keyframes = ord("C")
setting_key_copy_keyframes_control = true
setting_key_cut_keyframes = ord("X")
setting_key_cut_keyframes_control = true
setting_key_paste_keyframes = ord("V")
setting_key_paste_keyframes_control = true
setting_key_remove_keyframes = vk_delete
setting_key_remove_keyframes_control = false
setting_key_spawn_particles = ord("S")
setting_key_spawn_particles_control = false
setting_key_clear_particles = ord("C")
setting_key_clear_particles_control = false
setting_key_forward = ord("W")
setting_key_back = ord("S")
setting_key_left = ord("A")
setting_key_right = ord("D")
setting_key_ascend = ord("E")
setting_key_descend = ord("Q")
setting_key_roll_forward = ord("Z")
setting_key_roll_back = ord("C")
setting_key_roll_reset = ord("X")
setting_key_reset = ord("R")
setting_key_fast = vk_space
setting_key_slow = vk_lshift
setting_move_speed = 1
setting_look_sensitivity = 1
setting_fast_modifier = 3
setting_slow_modifier = 0.25

setting_bend_style = "realistic"
setting_schematic_remove_edges = false
setting_liquid_animation = true
setting_noisy_grass_water = false
setting_texture_filtering = true
setting_texture_filtering_level = 1
setting_block_brightness = 0.75
setting_block_glow = true
setting_light_bleeding = true

setting_render_camera_effects = true
setting_render_ssao = true
setting_render_ssao_radius = 12
setting_render_ssao_power = 1
setting_render_ssao_samples = 16
setting_render_ssao_blur_passes = 2
setting_render_ssao_color = c_black
setting_render_ssr = true
setting_render_shadows = true
setting_render_shadows_sun_buffer_size = 2048
setting_render_shadows_spot_buffer_size = 512
setting_render_shadows_point_buffer_size = 256
setting_render_shadows_blur_quality = 20
setting_render_shadows_blur_size = 1
setting_render_glow = true
setting_render_glow_radius = 1
setting_render_glow_intensity = 1
setting_render_glow_falloff = false
setting_render_glow_falloff_radius = 2
setting_render_glow_falloff_intensity = 1
setting_render_aa = true
setting_render_aa_power = 1
setting_render_watermark = trial_version
setting_render_watermark_image = spr_watermark
setting_render_watermark_filename = ""
setting_render_watermark_anchor_x = "right"
setting_render_watermark_anchor_y = "bottom"
setting_render_watermark_scale = 1
setting_render_watermark_alpha = 1

setting_render_ssr = true
setting_render_ssr_step_size = 2
setting_render_ssr_step_amount = 140
setting_render_ssr_refine_amount = 25
setting_render_ssr_refine_depth = 4
setting_render_ssr_metallic = 1
setting_render_ssr_specular = 1

setting_export_movie_format = "mp4"
setting_export_movie_frame_rate = 30
setting_export_movie_bit_rate = 2500000
setting_export_movie_include_audio = true
setting_export_movie_remove_background = false
setting_export_movie_include_hidden = false
setting_export_movie_high_quality = true

setting_export_image_remove_background = false
setting_export_image_include_hidden = false
setting_export_image_high_quality = true


setting_cubist_platform = 0
setting_cubist_device = 0
setting_cubist_ao = 0
setting_cubist_ao_strength = 0
setting_cubist_ao_samples = 15
setting_cubist_ao_distance = 5


checkbox_expand_settings_ssao = true
checkbox_expand_settings_shadows = true
checkbox_expand_settings_glow = true
checkbox_expand_settings_aa = true
checkbox_expand_settings_watermark = true
checkbox_expand_background_clouds = true
checkbox_expand_background_ground = true
checkbox_expand_background_fog = true
checkbox_expand_background_wind = true
checkbox_expand_frameeditor_rotatepoint = true
checkbox_expand_frameeditor_dof = true
checkbox_expand_frameeditor_bloom = true
checkbox_expand_frameeditor_clrcor = true
checkbox_expand_frameeditor_vignette = true
checkbox_expand_frameeditor_grain = true
checkbox_expand_setting_cubist_ao = true
checkbox_expand_settings_ssr = true

settings_load()

texture_set_mipmap_level(setting_texture_filtering_level)