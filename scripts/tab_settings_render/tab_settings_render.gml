/// tab_settings_render()

// Camera effects
tab_control_checkbox()
draw_checkbox("settingsrendercameraeffects", dx, dy, setting_render_camera_effects, action_setting_render_camera_effects)
tab_next()

// Shadows
tab_control_checkbox_expand()
draw_checkbox_expand("settingsrendershadows", dx, dy, setting_render_shadows, action_setting_render_shadows, checkbox_expand_settings_shadows, action_checkbox_expand_settings_shadows)
tab_next()

if (setting_render_shadows && checkbox_expand_settings_shadows)
{
	dx += 4
	dw -= 4
	
	var capwid = text_caption_width("settingsrendershadowssunbuffersize", 
									"settingsrendershadowsspotbuffersize", 
									"settingsrendershadowspointbuffersize", 
									"settingsrendershadowsblurquality", 
									"settingsrendershadowsblursize")
	
	tab_control(24)
	draw_button_menu("settingsrendershadowssunbuffersize", e_menu.LIST, dx, dy, dw, 24, setting_render_shadows_sun_buffer_size, text_get("settingsrendershadowsbuffersize" + string(setting_render_shadows_sun_buffer_size)) + " (" + string(setting_render_shadows_sun_buffer_size) + "x" + string(setting_render_shadows_sun_buffer_size) + ")", action_setting_render_shadows_sun_buffer_size, null, null, capwid)
	tab_next()
	
	tab_control(24)
	draw_button_menu("settingsrendershadowsspotbuffersize", e_menu.LIST, dx, dy, dw, 24, setting_render_shadows_spot_buffer_size, text_get("settingsrendershadowsbuffersize" + string(setting_render_shadows_spot_buffer_size)) + " (" + string(setting_render_shadows_spot_buffer_size) + "x" + string(setting_render_shadows_spot_buffer_size) + ")", action_setting_render_shadows_spot_buffer_size, null, null, capwid)
	tab_next()
	
	tab_control(24)
	draw_button_menu("settingsrendershadowspointbuffersize", e_menu.LIST, dx, dy, dw, 24, setting_render_shadows_point_buffer_size, text_get("settingsrendershadowsbuffersize" + string(setting_render_shadows_point_buffer_size)) + " (" + string(setting_render_shadows_point_buffer_size) + "x" + string(setting_render_shadows_point_buffer_size) + ")", action_setting_render_shadows_point_buffer_size, null, null, capwid)
	tab_next()
	
	tab_control_meter()
	draw_meter("settingsrendershadowsblurquality", dx, dy, dw, setting_render_shadows_blur_quality, 48, 1, 64, 20, 1, tab.render.tbx_shadows_blur_quality, action_setting_render_shadows_blur_quality, capwid)
	tab_next()
	
	tab_control_meter()
	draw_meter("settingsrendershadowsblursize", dx, dy, dw, round(setting_render_shadows_blur_size * 100), 48, 0, 400, 100, 1, tab.render.tbx_shadows_blur_size, action_setting_render_shadows_blur_size, capwid)
	tab_next()
	
	dx -= 4
	dw += 4
	checkbox_expand_end()
}

// SSAO
tab_control_checkbox_expand()
draw_checkbox_expand("settingsrenderssao", dx, dy, setting_render_ssao, action_setting_render_ssao, checkbox_expand_settings_ssao, action_checkbox_expand_settings_ssao)
tab_next()

if (setting_render_ssao && checkbox_expand_settings_ssao)
{
	dx += 4
	dw -= 4
	
	var capwid = text_caption_width("settingsrenderssaoradius", "settingsrenderssaopower", "settingsrenderssaoblurpasses")
	
	tab_control_dragger()
	draw_dragger("settingsrenderssaoradius", dx, dy, dw, setting_render_ssao_radius, setting_render_ssao_radius / 200, 0, 256, 12, 0, tab.render.tbx_ssao_radius, action_setting_render_ssao_radius, capwid)
	tab_next()
	
	tab_control_meter()
	draw_meter("settingsrenderssaopower", dx, dy, dw, round(setting_render_ssao_power * 100), 50, 0, 500, 100, 1, tab.render.tbx_ssao_power, action_setting_render_ssao_power, capwid)
	tab_next()
	
	tab_control_meter()
	draw_meter("settingsrenderssaoblurpasses", dx, dy, dw, setting_render_ssao_blur_passes, 50, 0, 8, 2, 1, tab.render.tbx_ssao_blur_passes, action_setting_render_ssao_blur_passes, capwid)
	tab_next()
	
	tab_control_color()
	draw_button_color("settingsrenderssaocolor", dx, dy, dw, setting_render_ssao_color, c_black, false, action_setting_render_ssao_color)
	tab_next()
	dy += 10
	
	dx -= 4
	dw += 4
	checkbox_expand_end()
}

// SSR
tab_control_checkbox_expand()
draw_checkbox_expand("settingsrenderssr", dx, dy, setting_render_ssr, action_setting_render_ssr, checkbox_expand_settings_ssr, action_checkbox_expand_settings_ssr)
tab_next()

if (setting_render_ssr && checkbox_expand_settings_ssr)
{
	dx += 4
	dw -= 4
	
	var capwid = text_caption_width("settingsrenderssrstepsize",
	"settingsrenderssrstepamount",
	"settingsrenderssrrefineamount",
	"settingsrenderssrrefinedepth",
	"settingsrenderssrrefinemetallic",
	"settingsrenderssrrefinespecular")
	
	tab_control_meter()
	draw_meter("settingsrenderssrstepsize", dx, dy, dw, setting_render_ssr_step_size, 50, 1, 50, 2, 0.01, tab.render.tbx_ssr_step_size, action_setting_render_ssr_step_size, capwid)
	tab_next()
	
	tab_control_meter()
	draw_meter("settingsrenderssrstepamount", dx, dy, dw, setting_render_ssr_step_amount, 50, 1, 200, 140, 1, tab.render.tbx_ssr_step_amount, action_setting_render_ssr_step_amount, capwid)
	tab_next()
	
	tab_control_meter()
	draw_meter("settingsrenderssrrefineamount", dx, dy, dw, setting_render_ssr_refine_amount, 50, 0, 30, 100, 1, tab.render.tbx_ssr_step_refine_amount, action_setting_render_ssr_refine_amount, capwid)
	tab_next()
	
	tab_control_meter()
	draw_meter("settingsrenderssrrefinedepth", dx, dy, dw, setting_render_ssr_refine_depth, 50, 0, 100, 4, 0.01, tab.render.tbx_ssr_step_refine_depth, action_setting_render_ssr_refine_depth, capwid)
	tab_next()
	
	tab_control_meter()
	draw_meter("settingsrenderssrmetallic", dx, dy, dw, round(setting_render_ssr_metallic * 100), 50, 0, 100, 100, 1, tab.render.tbx_ssr_metallic, action_setting_render_ssr_metallic, capwid)
	tab_next()
	
	tab_control_meter()
	draw_meter("settingsrenderssrspecular", dx, dy, dw, round(setting_render_ssr_specular * 100), 50, 0, 100, 100, 1, tab.render.tbx_ssr_specular, action_setting_render_ssr_specular, capwid)
	tab_next()
}

// Glow
tab_control_checkbox_expand()
draw_checkbox_expand("settingsrenderglow", dx, dy, setting_render_glow, action_setting_render_glow, checkbox_expand_settings_glow, action_checkbox_expand_settings_glow)
tab_next()

if (setting_render_glow && checkbox_expand_settings_glow)
{
	dx += 4
	dw -= 4
	
	var capwid = text_caption_width("settingsrenderglowradius", 
									"settingsrenderglowintensity")
	
	tab_control_meter()
	draw_meter("settingsrenderglowradius", dx, dy, dw, round(setting_render_glow_radius * 100), 50, 0, 300, 100, 1, tab.render.tbx_glow_radius, action_setting_render_glow_radius, capwid)
	tab_next()
	
	tab_control_meter()
	draw_meter("settingsrenderglowintensity", dx, dy, dw, round(setting_render_glow_intensity * 100), 50, 0, 300, 100, 1, tab.render.tbx_glow_intensity, action_setting_render_glow_intensity, capwid)
	tab_next()
	
	tab_control_checkbox()
	draw_checkbox("settingsrenderglowfalloff", dx, dy, setting_render_glow_falloff, action_setting_render_glow_falloff)
	tab_next()
	
	if (setting_render_glow_falloff)
	{
		capwid = text_caption_width("settingsrenderglowfalloffradius", 
									"settingsrenderglowfalloffintensity")
		
		tab_control_meter()
		draw_meter("settingsrenderglowfalloffradius", dx, dy, dw, round(setting_render_glow_falloff_radius * 100), 50, 0, 300, 200, 1, tab.render.tbx_glow_falloff_radius, action_setting_render_glow_falloff_radius, capwid)
		tab_next()
	
		tab_control_meter()
		draw_meter("settingsrenderglowfalloffintensity", dx, dy, dw, round(setting_render_glow_falloff_intensity * 100), 50, 0, 300, 100, 1, tab.render.tbx_glow_falloff_intensity, action_setting_render_glow_falloff_intensity, capwid)
		tab_next()
	}
	
	dx -= 4
	dw += 4
	checkbox_expand_end()
}

// AA
tab_control_checkbox_expand()
draw_checkbox_expand("settingsrenderaa", dx, dy, setting_render_aa, action_setting_render_aa, checkbox_expand_settings_aa, action_checkbox_expand_settings_aa)
tab_next()

if (setting_render_aa && checkbox_expand_settings_aa)
{
	dx += 4
	dw -= 4
	
	tab_control_meter()
	draw_meter("settingsrenderaapower", dx, dy, dw, round(setting_render_aa_power * 100), 48, 0, 300, 100, 1, tab.render.tbx_aa_power, action_setting_render_aa_power)
	tab_next()
	
	dx -= 4
	dw += 4
	checkbox_expand_end()
}

// Watermark
if (trial_version)
{
	tab_control_checkbox()
	draw_checkbox("settingsrenderwatermark", dx, dy, setting_render_watermark, action_setting_render_watermark)
}
else
{
	tab_control_checkbox_expand()
	draw_checkbox_expand("settingsrenderwatermark", dx, dy, setting_render_watermark, action_setting_render_watermark, checkbox_expand_settings_watermark, action_checkbox_expand_settings_watermark)
}
tab_next()

if (setting_render_watermark)
{
	
	if (!trial_version && checkbox_expand_settings_watermark)
	{
		dx += 4
		dw -= 4
		
		var capwid = text_caption_width("settingsrenderwatermarkpositionx", 
									"settingsrenderwatermarkpositiony", 
									"settingsrenderwatermarkscale", 
									"settingsrenderwatermarkalpha", 
									"settingswatermarkimage")
		
		// Watermark Image
		tab_control(18)
		var fn = test((setting_render_watermark_filename = ""), text_get("settingsrenderwatermarkdefault"), setting_render_watermark_filename);
		draw_label(text_get("settingsrenderwatermarkimage") + ":", dx, dy)
		draw_label(string_limit(fn, dw - capwid), dx + capwid, dy)
		tip_wrap = false
		tip_set(fn, dx, dy, capwid + string_width(fn), 16)
		tab_next()

		tab_control(24)

		if (draw_button_normal("settingswatermarkopen", dx, dy, 24, 24, e_button.NO_TEXT, false, false, true, icons.BROWSE))
			action_setting_render_watermark_open()
	
		if (draw_button_normal("settingswatermarkreset", dx + 25, dy, 24, 24, e_button.NO_TEXT, false, false, true, icons.RESET))
			action_setting_render_watermark_reset()
	
		tab_next()
		
		// X Position
		tab_control(24)
		draw_button_menu("settingsrenderwatermarkpositionx", e_menu.LIST, dx, dy, dw, 24, setting_render_watermark_anchor_x, text_get("settingsrenderwatermark" + setting_render_watermark_anchor_x), action_setting_render_watermark_position_x, null, null, capwid)
		tab_next()
		
		// Y Position
		tab_control(24)
		draw_button_menu("settingsrenderwatermarkpositiony", e_menu.LIST, dx, dy, dw, 24, setting_render_watermark_anchor_y, text_get("settingsrenderwatermark" + setting_render_watermark_anchor_y), action_setting_render_watermark_position_y, null, null, capwid)
		tab_next()
		
		// Scale
		tab_control_meter()
		draw_meter("settingsrenderwatermarkscale", dx, dy, dw, round(setting_render_watermark_scale * 100), 48, 0, 1000, 100, 1, tab.render.tbx_watermark_scale, action_setting_render_watermark_scale, capwid)
		tab_next()
		
		// Alpha
		tab_control_meter()
		draw_meter("settingsrenderwatermarkalpha", dx, dy, dw, round(setting_render_watermark_alpha * 100), 48, 0, 100, 100, 1, tab.render.tbx_watermark_alpha, action_setting_render_watermark_alpha, capwid)
		tab_next()
		
		// Preview
		draw_watermark_preview(dx, dy, dw)
		dy += (30 * tab.scroll.needed)
		
		dx -= 4
		dw += 4
		checkbox_expand_end()
	}
	else
	{
		if (trial_version)
		{
			var str = string_wrap(text_get("settingsrenderwatermarkupgraderequired"), dw);
			draw_label(str, dx, dy)
			dy += string_height(str)
		}
	}
}






