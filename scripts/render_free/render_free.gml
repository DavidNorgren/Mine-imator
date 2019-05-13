/// render_free()

surface_free(render_surface[0])
surface_free(render_surface[1])
surface_free(render_surface[2])
surface_free(render_surface[3])
surface_free(render_surface[4])
surface_free(render_surface[5])

surface_free(render_surface_sun_buffer)
surface_free(render_surface_spot_buffer)
for (var d = 0; d < 6; d++)
	surface_free(render_surface_point_buffer[d])
