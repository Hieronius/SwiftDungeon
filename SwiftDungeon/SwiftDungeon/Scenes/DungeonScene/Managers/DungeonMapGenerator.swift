import Foundation

/*
 MARK: - Plan to implement Tiles
 4. Create a single TileViewBlock with constant size so each tile would fill it in costant distance between each other to immitate a real map
 5. Implement Scroll View to scroll the map
 */

/// An entity to generate a unique set of tiles for each dungeon level
struct DungeonMapGenerator {

	/// Method should apply current level of the dungeon to generate set of tiles
	func generateMap(_ currentLevel: Int) -> [[Tile]] {

		// Current Level should affect the size of the matrix

		let ratio = currentLevel
		let rowsSize = Int.random(in: 1+ratio...5+ratio)
		let columnsSize = Int.random(in: 1+ratio...5+ratio)

		// 1. Populate matrix with empty tiles

		let defaultTile = Tile(
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
				map[row][col] = generateTile()
			}
		}

		return map
	}

	/// Method to generate a random tile like .empty/.room/.corridor
	func generateTile() -> Tile {

		let random = Int.random(in: 1...3)
		switch random {
		case 1:
			return Tile(type: .room, isExplored: false, events: [])
		case 2:
			return Tile(type: .corridor, isExplored: false, events: [])
		case 3:
			return Tile(type: .empty, isExplored: false, events: [])
		default:
			return Tile(type: .empty, isExplored: false, events: [])
		}
	}
}
