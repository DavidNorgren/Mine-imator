/// macros()
/// @desc Defines constants used in the project.

// Debug
#macro dev_mode						true
#macro dev_mode_debug_schematics	dev_mode && false
#macro dev_mode_debug_names			dev_mode && true
#macro dev_mode_debug_unused		dev_mode && true
#macro dev_mode_rotate_blocks		dev_mode && true

// Versions
#macro mineimator_version			"1.2.2"
#macro mineimator_version_extra		""
#macro mineimator_version_date		"2019.01.14"
#macro gm_runtime					"2.1.5.246"
#macro minecraft_version			"1.13.1"

// File formats
#macro project_format				e_project.FORMAT_120_PRE_3
#macro settings_format				e_settings.FORMAT_120
#macro minecraft_assets_format		e_minecraft_assets.FORMAT_120

// Directories
#macro file_directory				game_save_id
#macro data_directory				working_directory + "Data\\"
#macro projects_directory			working_directory + "Projects\\"
#macro schematics_directory			working_directory + "Schematics\\"
#macro skins_directory				working_directory + "Skins\\"
#macro particles_directory			working_directory + "Particles\\"
#macro languages_directory			data_directory + "Languages\\"
#macro minecraft_directory			data_directory + "Minecraft\\"

// Files
#macro language_file				languages_directory + "english.milanguage"
#macro import_file					data_directory + "import.exe"
#macro settings_file				data_directory + "settings.midata"
#macro legacy_file					data_directory + "legacy.midata"
#macro block_preview_file			data_directory + "blockpreview.midata"
#macro key_file						data_directory + "key.midata"
#macro log_previous_file			file_directory + "log_previous.txt"
#macro log_file						file_directory + "log.txt"
#macro temp_file					file_directory + "tmp.file"
#macro temp_image					file_directory + "tmp.png"
#macro download_image_file			file_directory + "download.png"
#macro unzip_directory				file_directory + "unzip\\"

// Minecraft structure
#macro mc_file_directory			file_directory + "Minecraft_unzip\\"
#macro mc_assets_directory			"assets\\minecraft\\"
#macro mi_assets_directory			"assets\\mineimator\\"
#macro mc_models_directory			mc_assets_directory + "models\\"
#macro mc_blockstates_directory		mc_assets_directory + "blockstates\\"
#macro mc_textures_directory		mc_assets_directory + "textures\\"
#macro mc_character_directory		mc_models_directory + "character\\"
#macro mc_special_block_directory	mc_models_directory + "special_block\\"
#macro mc_block_directory			mc_models_directory + "block\\"
#macro mc_loops_directory			mc_character_directory + "loops\\"

#macro mc_pack_image_file			"pack.png"
#macro mc_grass_image_file			mc_textures_directory + "colormap\\grass.png"
#macro mc_foliage_image_file		mc_textures_directory + "colormap\\foliage.png"
#macro mc_particles_image_file		mc_textures_directory + "particle\\particles.png"
#macro mc_explosion_image_file		mc_textures_directory + "entity\\explosion.png"
#macro mc_sun_image_file			mc_textures_directory + "environment\\sun.png"
#macro mc_moon_phases_image_file	mc_textures_directory + "environment\\moon_phases.png"
#macro mc_clouds_image_file			mc_textures_directory + "environment\\clouds.png"

// Links
#macro link_article_drivers			"https://www.thewindowsclub.com/how-to-update-graphics-drivers-windows"
#macro link_website					"https://www.mineimator.com"
#macro link_tutorials				"https://www.mineimator.com/tutorials"
#macro link_download				"https://www.mineimator.com/download"
#macro link_upgrade					"https://www.mineimator.com/upgrade"
#macro link_assets					"https://www.mineimator.com/assets/"
#macro link_assets_versions			link_assets + "versions.midata"
#macro link_news					"https://www.mineimator.com/news.php?version=" + mineimator_version
#macro link_skins					"https://www.mineimator.com/skin?username="
#macro link_forums					"https://www.mineimatorforums.com"
#macro link_forums_bugs				"https://www.mineimatorforums.com/index.php?/forum/51-mine-imator-issues-and-bugs/"
#macro link_minecraft				"https://www.minecraft.net"
#macro link_david					"https://www.stuffbydavid.com"
#macro link_modelbench				"https://www.mineimator.com/modelbench"
#macro show_modelbench_popup		false
#macro http_ok						200
#macro http_bad_request				400

// Textures
#macro block_sheet_width			32
#macro block_sheet_height			32
#macro block_sheet_ani_width		32
#macro block_sheet_ani_height		2
#macro block_sheet_ani_frames		64
#macro item_sheet_width				32
#macro item_sheet_height			16

// Colors
#macro c_main						make_color_rgb(200, 200, 200)
#macro c_secondary					make_color_rgb(67, 103, 163)
#macro c_text						make_color_rgb(10, 10, 10)
#macro c_tips						make_color_rgb(40, 40, 40)
#macro c_highlight					make_color_rgb(132, 159, 204)
#macro c_alerts						make_color_rgb(240, 255, 159)
#macro c_controls					make_color_rgb(40, 40, 40)
#macro c_sky						make_color_rgb(145, 185, 255)
#macro c_clouds						make_color_rgb(255, 255, 255)
#macro c_sunlight					make_color_rgb(252, 255, 199)
#macro c_ambient					make_color_rgb(105, 110, 161)
#macro c_night						make_color_rgb(14, 14, 24)
#macro c_clouds_bottom				make_color_rgb(174, 181, 193)
#macro c_clouds_top					make_color_rgb(255, 255, 255)
#macro c_clouds_sideslight			make_color_rgb(215, 222, 234)
#macro c_clouds_sidesdark			make_color_rgb(194, 201, 215)
#macro c_plains_biome_foliage       make_color_rgb(119, 171, 47)
#macro c_plains_biome_grass         make_color_rgb(145, 189, 89)
#macro c_plains_biome_water         make_color_rgb(62, 117, 225)

// Minecraft color palette
#macro c_minecraft_white			hex_to_color("E9ECEC")	
#macro c_minecraft_orange			hex_to_color("F07613")	
#macro c_minecraft_magenta			hex_to_color("BD44B3")	
#macro c_minecraft_light_blue		hex_to_color("3AAFD9")	
#macro c_minecraft_yellow			hex_to_color("F8C627")	
#macro c_minecraft_lime				hex_to_color("70B919")	
#macro c_minecraft_pink				hex_to_color("ED8DAC")	
#macro c_minecraft_gray				hex_to_color("3E4447")	
#macro c_minecraft_light_gray		hex_to_color("8E8E86")	
#macro c_minecraft_cyan				hex_to_color("158991")	
#macro c_minecraft_purple			hex_to_color("792AAC")	
#macro c_minecraft_blue				hex_to_color("35399D")	
#macro c_minecraft_brown			hex_to_color("724728")	
#macro c_minecraft_green			hex_to_color("546D1B")	
#macro c_minecraft_red				hex_to_color("A12722")	
#macro c_minecraft_black			hex_to_color("141519")	

// Audio
#macro sample_rate					44100
#macro sample_size					4
#macro sample_max					32767
#macro sample_avg_per_sec			100

// Interface
#macro glow_alpha					0.75
#macro shadow_size					5
#macro shadow_alpha					0.1
#macro view_3d_control_size			0.225
#macro view_3d_control_width		20
#macro view_3d_box_size				12

// Values
#macro null							noone
#macro no_limit						100000000
#macro default_model				"human"
#macro default_model_part			"head"
#macro default_special_block		"chest"
#macro default_block				"grass_block"
#macro default_item					"item/diamond_sword"
#macro default_ground				"block/grass_block_top"

// World
#macro block_size					16
#macro item_size					16
#macro world_size					30000

// Vectors and matrices
#macro X							0
#macro Y							1
#macro Z							2
#macro W							3
#macro MAT_X						12
#macro MAT_Y						13
#macro MAT_Z						14
#macro MAT_IDENTITY					matrix_build(0, 0, 0, 0, 0, 0, 1, 1, 1)