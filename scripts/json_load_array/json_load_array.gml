/// json_load_array()

var list = ds_list_create()

while (json_load_char())
{
	if (json_char = e_json_char.SQUARE_END)
		break
		
	// Read value
	if (!json_load_value())
		break
		
	ds_list_add(list, json_value)
		
	// Mark type
	switch (json_value_type)
	{
		case e_json_type.OBJECT:
			ds_list_mark_as_map(list, ds_list_size(list) - 1)
			break
		   
		case e_json_type.ARRAY:
			ds_list_mark_as_list(list, ds_list_size(list) - 1)
			break
	}
	
	// Check for end of list
	if (json_char = e_json_char.SQUARE_END)
		break
		
	if (json_char != e_json_char.COMMA)
	{
		json_error = "Expected \",\""
		break
	}
}

// Clean up on error
if (json_error != "")
{
	ds_list_destroy(list)
	return false
}

json_value = list
json_value_type = e_json_type.ARRAY

// Next
json_load_char()

return true

