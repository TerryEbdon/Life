### @file
### @author   Terry Ebdon
### @date     14-FEB-2017
### @brief		The Game Of Life, in AWK. Why? Because I can.
###
### @copyright
### Licensed under the Apache License, Version 2.0 (the "License");
### you may not use this file except in compliance with the License.
### You may obtain a copy of the License at
###
###      http://www.apache.org/licenses/LICENSE-2.0
###
### Unless required by applicable law or agreed to in writing, software
### distributed under the License is distributed on an "AS IS" BASIS,
### WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
### See the License for the specific language governing permissions and
### limitations under the License.
BEGIN {
	dead 				= " "
	alive				= "*"
	min					= "min"
	max					= "max"
	r[min]			= 0
	r[max]			= 9
	c[min]			= 0
	c[max]			= 9
	liveCells		= 0
	generation	= 0

	#~ init()
}

NR == FNR {
	x++
	for ( f = 1; f <= NF; ++f ) {
		#~ printf( "%s", $f )
		gsub( "-", dead, $f )
		world[ f, NR ] = $f
	}
	printf( "\n%d fields in row %d\n", NF, NR )
}

END {
	print x, "rows !!"
	#~ displayWorld()

	playGame()
}

function playGame() {
	#~ while ( liveCells > 0 ) {
	for ( game=0; game<5; game++ ) {
		++generation
		displayWorld()
	#~ print getNumNeighbours(3,3)
	#~ exit
		resizeWorld()
		evolve()
		pause()
	}

	print "End of game."
}

function evolve() {
	for ( row=r[min]; row<=r[max]; row++ ) {
		for ( col=c[min]; col<=c[max]; col++ ) {
			newWorld[col,row] = newCellState( col, row )
		}
	}

	for ( row=r[min]; row<=r[max]; row++ ) {
		for ( col=c[min]; col<=c[max]; col++ ) {
			world[col,row] = newWorld[ col, row ]
			delete newWorld[ col, row ]
		}
	}
}

function newCellState( newCol, newRow ) {
	newState = dead
	numNeighbours = getNumNeighbours( newCol, newRow )
	#~ return world[ newCol, newRow ] ###############
	if ( world[ newCol, newRow ] == dead ) {
		if ( numNeighbours == 3 ) {
			newState = alive # Reproduction
		}
	} else { #currently alive
		if ( numNeighbours < 2 ) {
			newState = dead # Underpopulation
		} else {
			if ( numNeighbours < 4 ) { # 2 or 3 neighbours
				newState = alive # Survival
			} else {
				newState = dead # More thn 3 neighbours; death through over-population
			}
		}
	}

	return newState
}

function getNumNeighbours( newCol, newRow ) {
	rowAbove = iMax( newRow-1, r[min] )
	rowBelow = iMin( newRow+1, r[max] )

	colLeft = iMax( newCol-1, c[min] )
	colRight = iMin( newCol+1, c[max] )

	gnnNeighbours = 0
	#~ if ( newCol == 3 && newRow == 3 ) {
		#~ printf( "newCol %d, newRow: %d\n", newCol, newRow )
		#~ printf( "left:  %d, right:  %d min: %d, max: %d\n", colLeft, colRight, c[min], c[max] )
		#~ printf( "above: %d, below:  %d min: %d, max: %d\n", rowAbove, rowBelow, r[min], r[max] )
	#~ }
	#~ return 2
	for ( gnnCol = colLeft; gnnCol <= colRight; ++gnnCol ) {
		for ( gnnRow = rowAbove; gnnRow <= rowBelow; ++gnnRow ) {
			if ( gnnCol != newCol || gnnRow != newRow ) {
				#~ if ( newCol == 3 && newRow == 3 ) {
					#~ printf( "world[%d,%d]=%s\n",
						#~ gnnCol, gnnRow, world[ gnnCol, gnnRow ] )
				#~ }
				if ( world[gnnCol,gnnRow] == alive) {
					++gnnNeighbours
				}
			}
		}
	}
	#~ if ( newCol == 3 && newRow == 3 ) {
		#~ print "gnnNeighbours:", gnnNeighbours
	#~ }
	return gnnNeighbours
}

function newCellStateX( newCol, newRow ) {
	if ( world[ newCol, newRow ] == alive ) {
		newState = dead
	} else {
		newState = alive
	}
	return newState
}
function pause() {
	system( "sleep 1" )
}

function resizeWorld() {

	if ( isColOccupied( c[min] )  ) {
		addColumn( --c[min] )
	}

	if ( isColOccupied( c[max] ) ) {
		addColumn( ++c[max] )
	}

	if ( isRowOccupied( r[min] ) ) {
		addRow( --r[min] )
	}

	if ( isRowOccupied( r[max] ) ) {
		addRow( ++r[max] )
	}
}

function isRowOccupied( rowToCheck ) {
	rowOccupied = 0
	for (colToCheck = c[min]; rowOccupied == 0 && colToCheck <= c[max]; ++colToCheck ) {
		if ( world[ colToCheck, rowToCheck ] == alive ) {
			++rowOccupied
		}
	}
	return rowOccupied
}

function isColOccupied( colToCheck ) {
	colOccupied = 0
	for (rowToCheck = r[min]; colOccupied == 0 && rowToCheck <= r[max]; ++rowToCheck ) {
		if ( world[ colToCheck, rowToCheck ] == alive ) {
			++colOccupied
		}
	}
	return colOccupied
}

function addColumn( colToAdd ) {
	for ( rowToAdd = r[min]; rowToAdd <= r[max]; ++rowToAdd ) {
		world[ colToAdd, rowToAdd] = dead
	}
}

function addRow( rowToAdd ) {
	for ( colToAdd = c[min]; colToAdd <= c[max]; ++colToAdd ) {
		world[ colToAdd, rowToAdd] = dead
	}
}
# world[ col, row ]
function init() {
	xenocide()
}

function initBlinker() {
	xenocide()
	world[3,3] = alive
	world[3,4] = alive
	world[3,5] = alive
}

function initBlock() {
	xenocide()
	world[3,3] = alive
	world[3,4] = alive
	world[4,3] = alive
	world[4,4] = alive
}

function xenocide() {
	for ( row=r[min]; row<=r[max]; row++ ) {
		for ( col=c[min]; col<=c[max]; col++ ) {
			world[col,row]= dead
		}
	}
}

function initRandom() {
	srand()
	for ( row=r[min]; row<=r[max]; row++ ) {
		for ( col=c[min]; col<=c[max]; col++ ) {
			world[col,row]= deadOrAlive()
		}
	}
}

function deadOrAlive() {
	num = int(rand()*10)
	if ( num < 5) {
		state = dead
	} else {
		state= alive
		++liveCells
	}
	return state
}

function clearScreen() {
	system( "clear" )
}

function displayWorld() {
	clearScreen()
	printf( "Generation: %d Occupied: %d col[%d,%d] row[%d,%d]\n",
		generation, occupied, c[min], c[max], r[min], r[max] )

	displayColumnBar()
	for ( row=r[min]; row<=r[max]; row++ ) {
		printf( "%3d ", row )
		for ( col=c[min]; col<=c[max]; col++ ) {
			printf("%s", world[col,row])
		}
		printf("\n")
	}
	displayColumnBar()
}

function displayColumnBar() {
	for ( headerLine = 3; headerLine >0; headerLine-- ) {
		printf( "    " )
		for ( dc = c[min]; dc <= c[max]; dc++ ) {
			printf( "%1s", displayColChar( headerLine, dc ) )
		}
		printf( "\n" )
	}
}

function displayColChar( line, dc ) {

	return substr( dc, line, 1 )
}

function iMin( v1, v2 ) {
	if ( v1 <= v2 ) {
		rv = v1
	} else {
		rv = v2
	}
	return rv
}

function iMax( v1, v2 ) {
	if ( v1 >= v2 ) {
		rv = v1
	} else {
		rv = v2
	}
	return rv
}
