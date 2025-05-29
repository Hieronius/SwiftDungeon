import Foundation

/*
 MARK: - Plan to implement Tiles
 1. Implement random generation of different structures of Corridor/Room tile sets

 - How about a defined set of empty/corridors/rooms which should be affected by current level?
 - May be we also should construct the whole map in size or even an emoty ones and only after to decide how to fill it?
 */

// MARK: - DungeonMapGenerator

/// An entity to generate a unique set of tiles for each dungeon level
struct DungeonMapGenerator {

	// MARK: GenerateMap

	/// Method should apply current level of the dungeon to generate set of tiles
	func generateMap(_ currentLevel: Int) -> [[Tile]] {

		// Current Level should affect the size of the matrix

		let ratio = currentLevel
		let rowsSize = Int.random(in: 1+ratio...5+ratio)
		let columnsSize = Int.random(in: 1+ratio...5+ratio)

		// 1. Populate matrix with empty tiles
		// In other words it's just am empty rectangle of all possible space filled with empty rooms to work with

		let defaultTile = Tile(
			row: 0,
			col: 0,
			type: .empty,
			isExplored: false,
			events: []
		)

		var map: [[Tile]] = Array(repeating: Array(repeating: defaultTile,
												   count: rowsSize),
								  count: columnsSize)

		// 2. Traverse matrix again and generate a unique tile for each element of the matrix

		for row in 0..<map.count {
			for col in 0..<map[row].count {
				map[row][col] = generateTile(row, col)
			}
		}

		return map
	}

	// MARK: GenerateTile

	/// Method to generate a random tile like .empty/.room/.corridor
	func generateTile(_ row: Int, _ col: Int) -> Tile {

		/*
		 MARK: Current Ratio of the elements on the map:
		 - Empty around 33 %
		 - Rooms around 33 %
		 - Corridors around 33 %
		 */

		let random = Int.random(in: 1...3)

		switch random {

		// Put Room Tile on the map
			
		case 1: return Tile(row: row,
						col: col,
						type: .room,
						isExplored: false,
						events: [])

		// Put Corridor Tile on the map

		case 2: return Tile(row: row,
						col: col,
						type: .corridor,
						isExplored: false,
						events: [])

		// Put Empty Tile on the map

		case 3: return Tile(row: row,
						col: col,
						type: .empty,
						isExplored: false,
						events: [])

		// Put Empty Tile on the map at any other conditions

		default: return Tile(row: row,
						col: col,
						type: .empty,
						isExplored: false,
						events: [])
		}
	}
}
