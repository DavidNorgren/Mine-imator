/// json_load_object(root)
/// @arg root

var map = ds_map_create();

if (json_type_map != null)
	ds_map_add_map(json_type_map, map, ds_map_create())

while (json_load_char())
{
	if (json_char = e_json_char.CURLY_END)
		break
	
	// Read name
	if (!json_load_string())
		break
		
	var name = json_value;
	
	// Read colon
	if (json_char != e_json_char.COLON)
	{
		json_error = "Expected \":\""
		break
	}
	
	if (!json_load_char())
		break
	
	// Read value
	if (!json_load_value())
		break
		
	// Add to map
	switch (json_value_type)
	{
		case e_json_type.OBJECT:
			ds_map_add_map(map, name, json_value)
			break
		   
		case e_json_type.ARRAY:
			ds_map_add_list(map, name, json_value)
			break
		   
		default:
			map[?name] = json_value
	}
	
	// Add type
	if (json_type_map != null)
		ds_map_add(json_type_map[?map], name, json_value_type)
	
	// Check for end of list
	if (json_char = e_json_char.CURLY_END)
		break
		
	if (json_char != e_json_char.COMMA)
	{
		json_error = "Expected \",\""
		break
	}
}

// Next if not root
if (!argument0)
	json_load_char()

// Clean up on error
if (json_error != "")
{
	ds_map_destroy(map)
	return false
}

json_value = map
json_value_type = e_json_type.OBJECT

return true

