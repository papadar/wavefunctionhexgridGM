/// @description display the grid

#region																			// DS_Grid level display
																				// border rooms are not drawn
for ( var _RoomX = 1; _RoomX < mapWidth+1; _RoomX += 1; ) {						// room_draw - cycle through each room and draw it
	if (_RoomX mod 2 == 1) {													
		var _hexGridY = (tileHeight/-2); } else { var _hexGridY = 0;			// every 2nd column is half offset to create the hex grid
	}																			
	for ( var _RoomY = 1; _RoomY < mapHeight+1; _RoomY += 1; ) {					
		var _RoomXpos = (_RoomX*tileWidth)										// room render co-ords
		var _RoomYpos = (_RoomY*tileHeight)+_hexGridY			
		var _RoomColor = gridCol0; 																									
		var _EntropyCheck = ds_grid_get(gridEntropy,_RoomX,_RoomY)				// check the entopy of the room
		if _EntropyCheck == 2 {													// entropy has been set
			
			var _RoomIndex = ds_grid_get(gridIndex,_RoomX,_RoomY)				// get the room index
			if  _RoomIndex != undefined {
				var _Door0 = ds_grid_get(gridRooms,0,_RoomIndex);
				var _Door1 = ds_grid_get(gridRooms,1,_RoomIndex);
				var _Door2 = ds_grid_get(gridRooms,2,_RoomIndex);
				var _Door3 = ds_grid_get(gridRooms,3,_RoomIndex);
				var _Door4 = ds_grid_get(gridRooms,4,_RoomIndex);
				var _Door5 = ds_grid_get(gridRooms,5,_RoomIndex);

				if _Door0 == 0 { draw_sprite_ext(s_Doors_Hex_0,0, _RoomXpos, _RoomYpos,1,1,0, _RoomColor, 1 ) } else if _Door0 == 1 { draw_sprite_ext(s_Doors_Hex_1,0, _RoomXpos, _RoomYpos,1,1,0, _RoomColor, 1 ) } 
				if _Door1 == 0 { draw_sprite_ext(s_Doors_Hex_0,1, _RoomXpos, _RoomYpos,1,1,0, _RoomColor, 1 ) } else if _Door1 == 1 { draw_sprite_ext(s_Doors_Hex_1,1, _RoomXpos, _RoomYpos,1,1,0, _RoomColor, 1 ) } 
				if _Door2 == 0 { draw_sprite_ext(s_Doors_Hex_0,2, _RoomXpos, _RoomYpos,1,1,0, _RoomColor, 1 ) } else if _Door2 == 1 { draw_sprite_ext(s_Doors_Hex_1,2, _RoomXpos, _RoomYpos,1,1,0, _RoomColor, 1 ) } 
				if _Door3 == 0 { draw_sprite_ext(s_Doors_Hex_0,3, _RoomXpos, _RoomYpos,1,1,0, _RoomColor, 1 ) } else if _Door3 == 1 { draw_sprite_ext(s_Doors_Hex_1,3, _RoomXpos, _RoomYpos,1,1,0, _RoomColor, 1 ) } 
				if _Door4 == 0 { draw_sprite_ext(s_Doors_Hex_0,4, _RoomXpos, _RoomYpos,1,1,0, _RoomColor, 1 ) } else if _Door4 == 1 { draw_sprite_ext(s_Doors_Hex_1,4, _RoomXpos, _RoomYpos,1,1,0, _RoomColor, 1 ) } 
				if _Door5 == 0 { draw_sprite_ext(s_Doors_Hex_0,5, _RoomXpos, _RoomYpos,1,1,0, _RoomColor, 1 ) } else if _Door5 == 1 { draw_sprite_ext(s_Doors_Hex_1,5, _RoomXpos, _RoomYpos,1,1,0, _RoomColor, 1 ) } 
			} else {
				draw_sprite_ext(s_Door_Hex_u,0,_RoomXpos,_RoomYpos, 1,1,0,c_red,1)	// Error! no matching room for this index
			}
		} else { // room is not resolved
			var _EntropyAlpha = clamp(1 - _EntropyCheck,0.1,1)					// Alpha is dependant on the entropy of the cell
				draw_sprite_ext(s_Door_Hex_u,0,_RoomXpos,_RoomYpos, 1,1,0,_RoomColor,_EntropyAlpha)
		}
	}
	
}


#endregion
