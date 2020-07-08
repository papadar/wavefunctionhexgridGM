/// @description Entropy collapse

#region			// SETUP or refresh the map entropy
	
if Entropy == -1 || keyboard_check_pressed(vk_enter) {											// setup world generation
	Entropy = 1;
	random_set_seed(random(5432)*5995432);														// cycle randomness seed

	for (var _RoomX = 0; _RoomX < mapWidth+2; _RoomX += 1;) {									// cycle through the grid cells
		for (var _RoomY = 0; _RoomY < mapHeight+2; _RoomY += 1;) {																												
			var _RoomXY = (_RoomX*100 + _RoomY)												// each cell has a unique number in the grid XXYY  ( warning world size only up to 100x100 - XXYY )
			listEntropy[_RoomXY] = ds_list_create()												// create a list of possible rooms for each cell
			if (_RoomX == 0) || (_RoomX >= mapWidth + 1) ||											
			(_RoomY == 0) || (_RoomY >= mapHeight + 1)  {										// border here is the outer most row
				ds_list_add(listEntropy[_RoomXY],63)											// room chosen with only closed doors
				ds_grid_set(gridIndex, _RoomX, _RoomY, 63);										
				ds_grid_set(gridEntropy, _RoomX, _RoomY, 2);									// entropy is set to collapsed
			} else {																			
				for (var _RoomIndex = 0; _RoomIndex < randRooms; _RoomIndex += 1;){	
					ds_list_add(listEntropy[_RoomXY],_RoomIndex)								// adds all 'randomizable rooms' to this cells list of possibilities
				}
				ds_list_trim(listEntropy[_RoomXY],listRandRoom);	
				ds_grid_set(gridEntropy, _RoomX, _RoomY, 1);									// solvable cells entropy temporarily set to 1
			}																
		}																	
	}																	
	show_debug_message("Entropy map size " + string(mapWidth) + " X " +string(mapHeight) + " created")																			

#region			// starting state entropy - resolve borders & add noise

	var _ListStart = ds_list_create()
	for (var _RoomX = 1; _RoomX < mapWidth+1; _RoomX += 1;) {									// cycle through all collapsable grid cells
		for (var _RoomY = 1; _RoomY < mapHeight+1; _RoomY += 1;) {								
			var _RoomXY = (_RoomX*100 + _RoomY)													
			ds_list_add(_ListStart, _RoomXY)													// add them to a list
		}																						
	}																							
																								
	ds_list_shuffle(_ListStart)																	// shuffle it
	hexEntropy(_ListStart)																		// send this list of cells to have their entropy resolved
	
	for (var _RoomX = 1; _RoomX < mapWidth+1; _RoomX += 1;) {									// add some noise to the solvable rooms entropy
		for (var _RoomY = 1; _RoomY < mapHeight+1; _RoomY += 1;) {	
			var _RoomXYentropy = ds_grid_get(gridEntropy,_RoomX,_RoomY)	
			if _RoomXYentropy > 0.5 {
				_RoomXYentropy -= random(0.3)
				ds_grid_set(gridEntropy,_RoomX,_RoomY,_RoomXYentropy)	
			}
		}
	}

#endregion

#region			// shuffle colors

var _colorChoice = irandom(7)+1
switch _colorChoice {
	case 1: gridCol0 = gridCol1; backCol0 = backCol1; break;
	case 2: gridCol0 = gridCol2; backCol0 = backCol2; break;
	case 3: gridCol0 = gridCol3; backCol0 = backCol3; break;
	case 4: gridCol0 = gridCol4; backCol0 = backCol4; break;
	case 5: gridCol0 = gridCol5; backCol0 = backCol5; break;
	case 6: gridCol0 = gridCol6; backCol0 = backCol6; break;
	case 7: gridCol0 = gridCol7; backCol0 = backCol7; break;
	case 8: gridCol0 = gridCol8; backCol0 = backCol8; break;
}

var _background = layer_background_get_id(layer_get_id("Background"));
layer_background_blend(_background, backCol0)

#endregion
	
}
	
#endregion

#region			// mouse click to make cell there solve next

if mouse_check_button(mb_left) {
	var clickX = floor(device_mouse_x_to_gui(0)/tileWidth) 
	if (clickX mod 2 == 1) { var _hexGridY = (tileHeight/-2); } else { var _hexGridY = 0; }
	var clickY = floor((device_mouse_y_to_gui(0)+_hexGridY)/tileHeight)
	if (clickX >= 0) && (clickX <= mapWidth+2) && (clickY >= 0) && (clickY <= mapHeight+2) {
		if ds_grid_get(gridEntropy,clickX,clickY) != 2 {
			ds_grid_set(gridEntropy,clickX,clickY,random(0.2))									// low end entropy - forcing it to be solved next
		}
	}
}

#endregion		

#region			// collapse one cell & update the surrounding entropy												
	if (Entropy > 0) {																			// if map has some entropy remaining
	//while (Entropy > 0) {																	// change to while here to resolve the map in one step, rather than one cell per step
	var _LowestEntropy = ds_grid_get_min(gridEntropy, 1, 1, mapWidth+1,mapHeight+1);			// Get the lowest entropy value within the collapsable area	
	if _LowestEntropy != 2 {
		
			var _ListLowestEntropy = ds_list_create()											// create a list of the lowest entropy 	
			for (var _RoomX = 1; _RoomX < mapWidth+1; _RoomX += 1;) {							// cycle through all cells
				for (var _RoomY = 1; _RoomY < mapHeight+1; _RoomY += 1;) {									
					var _RoomXYentropy = ds_grid_get(gridEntropy,_RoomX,_RoomY)					// check the written entropy
					if _RoomXYentropy == _LowestEntropy	{										// if this cell has equal lowest entropy
						var _RoomXY = (_RoomX*100 + _RoomY)										// get the unique number of the cell
						ds_list_add(_ListLowestEntropy,_RoomXY)									// add it to the list
					}														
				}																
			}	
			
			ds_list_shuffle(_ListLowestEntropy);												// shuffle the order of the list
			var _SizeListLowestEntropy = ds_list_size(_ListLowestEntropy);											
			var _lowestXY = irandom(_SizeListLowestEntropy-1);									// choose one at random
			var _RoomXY = ds_list_find_value(_ListLowestEntropy,_lowestXY)						// recover the coordinates			
			var _ParentX = _RoomXY div 100														// x coord								
			var _ParentY = _RoomXY mod 100														// y coord
			var _SizeListRoomXY = ds_list_size(listEntropy[_RoomXY])							// number of possible rooms for this cell
			var _RoomChoice = irandom(_SizeListRoomXY-1)										// choose a random number from the possible rooms
			var _RoomIndex = ds_list_find_value(listEntropy[_RoomXY], _RoomChoice)				// get the index of the chosen room
			ds_grid_set(gridIndex, _ParentX, _ParentY, _RoomIndex)								// record the chosen room index within the grid of all rooms
			ds_grid_set(gridEntropy, _ParentX, _ParentY, 2)										// set entropy of this cell to 2
																								
																								// update the entropy for the surrounding 6 rooms in a randomised order	
																								
		if _ParentX mod 2 == 0 { var _OddColumn = 0; } else { var _OddColumn = 1; }				// find out if i'm an odd or even column
																								
		//        ╠════╣           ╠════╣    ╠════╣												
		//   ╠════╣ 10 ╠════╣     ═╣ 00 ╠════╣ 20 ╠═												
		//  ═╣ 00 ╠════╣ 20 ╠═     ╠════╣ 10 ╠════╣												// diagram of odd and even hex grid arrangement
		//   ╠════╣ XX ╠════╣     ═╣ 01 ╠════╣ 21 ╠═											// grid 'wiggles' in the y axis, alternating neighbour arrangement
		//  ═╣ 01 ╠════╣ 21 ╠═     ╠════╣ XX ╠════╣
		//   ╠════╣ 12 ╠════╣     ═╣ 02 ╠════╣ 22 ╠═
		//  ═╣ 02 ╠════╣ 22 ╠═     ╠════╣ 12 ║════╣
		//   ╠════╣    ╠════╣      		╠════╣
											
		var _ListCheckHex = ds_list_create();  													// add my 6 neighbours to a checklist	
		var _SizeListCheckCell = 0;																
		for (var _RoomX = _ParentX-1; _RoomX < _ParentX+2; _RoomX += 1; ){						// x axis
			for (var _RoomY = _ParentY-1; _RoomY < _ParentY + 2; _RoomY += 1;) {				// y axis
				if (_RoomX > 0) && (_RoomX < mapWidth+2) &&										
				(_RoomY > 0) && (_RoomY < mapHeight+2) {										// skip the border rooms
					var _CheckMe = 0;															
					if (_RoomX == _ParentX) && (_RoomY == _ParentY) {							// skip the parent cell
					} else {																				
					if (_RoomX == _ParentX) || (_RoomY == _ParentY) { _CheckMe = 1; }			// my column and row always included
					}																			
					if (_OddColumn == 1) { if (_RoomY == _ParentY-1){ _CheckMe = 1; }			// top row for 'ODD' arrangement
					} else { if (_RoomY == _ParentY+1) { _CheckMe = 1; }						// bottomn row for 'EVEN' arrangement
					}																			
					if _CheckMe == 1 {															
						var _RoomXY = (_RoomX*100 + _RoomY)										// get the unique number name of the cell
						var _ListRoomXY = listEntropy[_RoomXY]									// get the list of possible rooms for this cell
						var _SizeListRoomXY = ds_list_size(_ListRoomXY)							// and the length of the list
						var _EntropyRoomXY = ds_grid_get(gridEntropy, _RoomX, _RoomY)			// also check the recorded entropy of this cell
						if (_EntropyRoomXY != 2) && (_SizeListRoomXY > 1) {						// check that i am not overwriting anything...
							ds_list_add(_ListCheckHex, _RoomXY )							
							_SizeListCheckCell += 1;														
						}
					}
				}																	
			}																		
		}																			
																				
		ds_list_shuffle(_ListCheckHex);															// shuffle the list order
		hexEntropy(_ListCheckHex)

	} else {																					// lowest entropy found is 2 - skip calculation
		Entropy = 0;
		show_debug_message("world is generated")
		for (var _RoomX = 0; _RoomX < mapWidth+2; _RoomX += 1;) {								// delete the lists for possible rooms
			for (var _RoomY = 0; _RoomY < mapHeight+2; _RoomY += 1;) {																							
				var _RoomXY = (_RoomX*100 + _RoomY)										
				if ds_exists(listEntropy[_RoomXY], ds_type_list)					
				ds_list_destroy(listEntropy[_RoomXY]);
			}
		}
	}

} // end of entropy collapse cycle

#endregion
