// take a list of rooms, and calculates the entropy in the Hex grid

var _SizeList = ds_list_size(argument[0])
	
for(var _ListIndex = 0; _ListIndex < _SizeList; _ListIndex += 1;  ) {

	var _ListKnockOut = ds_list_create();
	ds_list_combine(_ListKnockOut, listRandRoom )										// remove the rooms that cannot be randomly chosen
		
	var _RoomXY = ds_list_find_value(argument[0], _ListIndex)							// get the room number from the list
	var _RoomX = _RoomXY div 100														// recover my x & y positions
	var _RoomY = _RoomXY mod 100																
	var _ListDoor = ds_list_create();													// create & shuffle a list of my door indexes 
	ds_list_add(_ListDoor,0,1,2,3,4,5); ds_list_shuffle(_ListDoor);									
	for (var _IndexDoor = 0; _IndexDoor < 6; _IndexDoor += 1;) {						// cycle through my doors / neighbours
		switch _IndexDoor {																// different rules each door 																					
		case 0:																			// 0th door - entropy of neighbour above's 3rd door
			var _EntropyNeighbour = ds_grid_get(gridEntropy,_RoomX,_RoomY-1)													
			if _EntropyNeighbour == 2 {													// entropy of room above is collapsed
				var _IndexNeighbour = ds_grid_get(gridIndex,_RoomX,_RoomY-1)			// get the room index of the above cell
				if _IndexNeighbour != undefined {
					var _DoorNeighbour = ds_grid_get(gridRooms,3,_IndexNeighbour)		// get the matching door state from the room index	
					switch _DoorNeighbour {										
						case 0: ds_list_combine(_ListKnockOut,listDoor0_0); break;		// add all rooms not open to my knockout list									
						case 1: ds_list_combine(_ListKnockOut,listDoor0_1); break;		// add all rooms not closed  to my knockout list														
						case 2: ds_list_combine(_ListKnockOut,listDoor0_2); break;		// add all rooms not wide open to my knockout list			
					}
				}
			} break;	
		case 1:																			// 1st door - entropy of neighbours NE door 4										
			if (_RoomX mod 2 == 0) {													// Column is odd
				var _EntropyNeighbour = ds_grid_get(gridEntropy,_RoomX+1,_RoomY)
				var _IndexNeighbour = ds_grid_get(gridIndex,_RoomX+1,_RoomY)			// get the room index of the cell
			} else {																	// column is even
				var _EntropyNeighbour = ds_grid_get(gridEntropy,_RoomX+1,_RoomY-1)						
				var _IndexNeighbour = ds_grid_get(gridIndex,_RoomX+1,_RoomY-1)			// get the room index of the cell
			}															
																			
			if _EntropyNeighbour == 2 {													// entropy of room above is collapsed													
				if _IndexNeighbour != undefined {
					var _DoorNeighbour = ds_grid_get(gridRooms,4,_IndexNeighbour)		// get the matching door state from the room index	
					switch _DoorNeighbour {										
						case 0: ds_list_combine(_ListKnockOut,listDoor1_0); break;		// add all rooms not open to my knockout list									
						case 1: ds_list_combine(_ListKnockOut,listDoor1_1); break;		// add all rooms not closed  to my knockout list														
						case 2: ds_list_combine(_ListKnockOut,listDoor1_2); break;		// add all rooms not wide open to my knockout list			
					}
				}
			}
			break;
		case 2:																			// 2nd door - entropy of neighbour NE door 5										
			if (_RoomX mod 2 == 0) {										
				var _EntropyNeighbour = ds_grid_get(gridEntropy,_RoomX+1,_RoomY+1)		// column is odd
				var _IndexNeighbour = ds_grid_get(gridIndex,_RoomX+1,_RoomY+1)			// get the room index of the cell
			} else {													
				var _EntropyNeighbour = ds_grid_get(gridEntropy,_RoomX+1,_RoomY)		// column is even
				var _IndexNeighbour = ds_grid_get(gridIndex,_RoomX+1,_RoomY)			// get the room index of the cell
			}																													
			if _EntropyNeighbour == 2 {													// entropy of room above is collapsed													
				if _IndexNeighbour != undefined {
					var _DoorNeighbour = ds_grid_get(gridRooms,5,_IndexNeighbour)		// get the matching door state from the room index	
					switch _DoorNeighbour {										
						case 0: ds_list_combine(_ListKnockOut,listDoor2_0); break;		// add all rooms not open to my knockout list									
						case 1: ds_list_combine(_ListKnockOut,listDoor2_1); break;		// add all rooms not closed  to my knockout list														
						case 2: ds_list_combine(_ListKnockOut,listDoor2_2); break;		// add all rooms not wide open to my knockout list			
					}
				}
			}
			break;
		case 3:																			// 0th door - entropy of neighbour above's 3rd door
			var _EntropyNeighbour = ds_grid_get(gridEntropy,_RoomX,_RoomY+1)									
			if _EntropyNeighbour == 2 {													// entropy of room above is collapsed
				var _IndexNeighbour = ds_grid_get(gridIndex,_RoomX,_RoomY+1)			// get the room index of the above cell
				if _IndexNeighbour != undefined {
					var _DoorNeighbour = ds_grid_get(gridRooms,0,_IndexNeighbour)		// get the matching door state from the room index	
					switch _DoorNeighbour {										
						case 0: ds_list_combine(_ListKnockOut,listDoor3_0); break;		// add all rooms not open to my knockout list									
						case 1: ds_list_combine(_ListKnockOut,listDoor3_1); break;		// add all rooms not closed  to my knockout list														
						case 2: ds_list_combine(_ListKnockOut,listDoor3_2); break;		// add all rooms not wide open to my knockout list			
					}
				} 
			} break;
		case 4:																			// 4th door - entropy of neighbour NW door 1										
			if (_RoomX mod 2 == 0) {										
				var _EntropyNeighbour = ds_grid_get(gridEntropy,_RoomX-1,_RoomY+1)		// column is odd
				var _IndexNeighbour = ds_grid_get(gridIndex,_RoomX-1,_RoomY+1)			// get the room index of the cell
			} else {													
				var _EntropyNeighbour = ds_grid_get(gridEntropy,_RoomX-1,_RoomY)		// column is even
				var _IndexNeighbour = ds_grid_get(gridIndex,_RoomX-1,_RoomY)			// get the room index of the cell
			}																													
			if _EntropyNeighbour == 2 {													// entropy of room above is collapsed													
				if _IndexNeighbour != undefined {
					var _DoorNeighbour = ds_grid_get(gridRooms,1,_IndexNeighbour)		// get the matching door state from the room index	
					switch _DoorNeighbour {										
						case 0: ds_list_combine(_ListKnockOut,listDoor4_0); break;		// add all rooms not open to my knockout list									
						case 1: ds_list_combine(_ListKnockOut,listDoor4_1); break;		// add all rooms not closed  to my knockout list														
						case 2: ds_list_combine(_ListKnockOut,listDoor4_2); break;		// add all rooms not wide open to my knockout list			
					}
				} 
			}
			break;
		case 5:																			// 5th door - entropy of neighbour NW door 2										
			if (_RoomX mod 2 == 0) {										
				var _EntropyNeighbour = ds_grid_get(gridEntropy,_RoomX-1,_RoomY)		// column is odd
				var _IndexNeighbour = ds_grid_get(gridIndex,_RoomX-1,_RoomY)			// get the room index of the cell
			} else {													
				var _EntropyNeighbour = ds_grid_get(gridEntropy,_RoomX-1,_RoomY-1)		// column is even
				var _IndexNeighbour = ds_grid_get(gridIndex,_RoomX-1,_RoomY-1)			// get the room index of the cell
			}																													
			if _EntropyNeighbour == 2 {													// entropy of room above is collapsed													
				if _IndexNeighbour != undefined {
					var _DoorNeighbour = ds_grid_get(gridRooms,2,_IndexNeighbour)		// get the matching door state from the room index	
					switch _DoorNeighbour {										
						case 0: ds_list_combine(_ListKnockOut,listDoor5_0); break;		// add all rooms not open to my knockout list									
						case 1: ds_list_combine(_ListKnockOut,listDoor5_1); break;		// add all rooms not closed  to my knockout list														
						case 2: ds_list_combine(_ListKnockOut,listDoor5_2); break;		// add all rooms not wide open to my knockout list			
					}
				} 
			}
			break;
		}
	}																	
	if ds_grid_get(gridEntropy,_RoomX,_RoomY) != 2 {									// make sure it wasn't set already
		ds_list_trim(listEntropy[_RoomXY],_ListKnockOut)								// apply the _ListKnockOut
		var _EntropyXYCalc = (ds_list_size(listEntropy[_RoomXY])/totalRooms)			// calculate the current entropy
		ds_grid_set(gridEntropy,_RoomX,_RoomY,_EntropyXYCalc)							// write to the cell
	}

}