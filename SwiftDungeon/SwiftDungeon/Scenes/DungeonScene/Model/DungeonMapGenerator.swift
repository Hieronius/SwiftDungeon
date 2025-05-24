import Foundation

/// An entity to generate a unique set of tiles for each dungeon level
struct DungeonMapGenerator {

	/// Method should apply current level of the dungeon to generate set of tiles
	func generateMap(currentLevel: Int) -> [[Tile]] {

		let rowsSize = Int.random(in: 1...10)
		let columnsSize = Int.random(in: 1...10)

		var map: [[Tile]] = []

		

		return [[]]
	}
}
