import Foundation

/// An entity to generate a unique set of tiles for each dungeon level
struct DungeonMapGenerator {

	/// Method should apply current level of the dungeon to generate set of tiles
	func generateMap(_ currentLevel: Int) -> [[Tile]] {

		let ratio = currentLevel
		let rowsSize = Int.random(in: 5+ratio...10+ratio)
		let columnsSize = Int.random(in: 5+ratio...10+ratio)

		var defaultTile = Tile(type: .empty,
							   isExplored: false,
							   events: [])

		var map: [[Tile]] = Array(repeating: Array(repeating: defaultTile, count: rowsSize), count: columnsSize)

		

		return map
	}
}
