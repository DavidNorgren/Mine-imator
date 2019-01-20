/// render_set_projection(from, to, up, fov, aspect, znear, zfar)
/// @arg from
/// @arg to
/// @arg up
/// @arg fov
/// @arg aspect
/// @arg znear
/// @arg zfar

var mV = matrix_build_lookat(argument0[X], argument0[Y], argument0[Z], 
							 argument1[X], argument1[Y], argument1[Z],
							 argument2[X], argument2[Y], argument2[Z]);
var mP = matrix_build_projection_perspective_fov(-argument3, -argument4, argument5, argument6);

camera_set_view_mat(cam_render, mV)
camera_set_proj_mat(cam_render, mP)
camera_apply(cam_render)
