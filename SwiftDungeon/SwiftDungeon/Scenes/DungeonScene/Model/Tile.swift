import Foundation

/// Single Game Tile of the DungeonMap
struct Tile {

	/// Corridor or Room or any other types we create in the future
	let type: TileType

	/// Should be marked if the hero already been here
	let isExplored: Bool

	/// A single or multiple events such as Enemy -> Quest -> Reward
	let events:  [EventType]

}
