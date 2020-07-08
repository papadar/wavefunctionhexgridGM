/// remove any value from trimmee list found in the trimmer list

var _ListTrim = argument[0]; var _ListTrimSize = ds_list_size(_ListTrim);				// list to be trimmed
var _ListComb = argument[1]; var _ListCombSize = ds_list_size(_ListComb);				// comb to trim with

for (var _NumberListTrim = 0; _NumberListTrim < _ListTrimSize; _NumberListTrim += 1;){	// cycle through the list
	var _IndexListTrim = ds_list_find_value(_ListTrim,_NumberListTrim)					// room at index _NumberListTrim
	for (var _RoomIndex = 0; _RoomIndex < _ListCombSize; _RoomIndex += 1;){				// cycle through the trim-er list
		var _ListCombIndex = ds_list_find_value(_ListComb,_RoomIndex)					// room at index r
		if _IndexListTrim == _ListCombIndex && (_ListTrimSize >= 1 ){					// if these rooms match & and there is more than one item left
			ds_list_delete(_ListTrim,_NumberListTrim);									// delete the room from the trimmee list
			_NumberListTrim -= 1;														// adjust my position as the list now shorter!
			_ListTrimSize = ds_list_size(_ListTrim);									// update the list length
		}
	}
}
