import Foundation

/// Single Game Tile of the DungeonMap
struct Tile: Identifiable {

	/// A unique identifier for each tile
	let id = UUID()

	/// Corridor or Room or any other types we create in the future
	var type: TileType

	/// Should be marked if the hero already been here
	var isExplored: Bool

	/// A single or multiple events such as Enemy -> Quest -> Reward
	var events:  [EventType]

}
