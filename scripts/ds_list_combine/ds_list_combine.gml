// combine the lists by appending any new values of the 2nd list into the first list

var _ListGrow = argument[0]																	// Grow list
var _ListAdd = argument[1]																	// add list
var _SizeListAdd = ds_list_size(_ListAdd)													// add size
																
for (var _NumberListAdd = 0; _NumberListAdd < _SizeListAdd; _NumberListAdd += 1;) {			// cycle through each value of the list to add
	var _IndexListAdd = ds_list_find_value(_ListAdd,_NumberListAdd)							// get the index
	if !ds_list_find_index(_ListGrow,_IndexListAdd ){										// if not already in the combined list,
		ds_list_add(_ListGrow,_IndexListAdd)												// add it
	}
}