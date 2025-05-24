import Foundation

/// A type of the game tile in the dungeon map
enum TileType {

	/// Square one and probably should be used to put enemies
	case room

	/// Rectangle one for small events like quests, riddles, traps or rewards
	case corridor

	/// We use it to create black spots on the map matrix so user can't enter them
	case empty
}
