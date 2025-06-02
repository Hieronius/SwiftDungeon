import Foundation

/// Single Game Tile of the DungeonMap
struct Tile: Identifiable {

	/// A unique identifier for each tile
	let id = UUID()

	/// Row position on the map
	let row: Int

	/// Column position on the map
	let col: Int

	/// Corridor or Room or any other types we create in the future
	var type: TileType

	/// Should be marked if the hero already been here
	var isExplored: Bool

	/// A single or multiple events such as Enemy -> Quest -> Reward
	var events:  [EventType]
}

extension Tile {
	
	func isHeroPosition(_ heroPosition: (Int, Int)) -> Bool {
		return (self.row, self.col) == heroPosition
	}
}
