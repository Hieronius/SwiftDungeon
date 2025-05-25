import Foundation

/// Each `Tile` should have it's own type of event
enum EventType {

	/// User can try to disarm the trap and get some points or get some damage if failed
	case trap

	/// User encounter an enemy from array of level enemies
	case enemy

	/// If user has a quest to get something from the dungeon we can put it here
	case quest

	/// A little quest to get a reward, quest progress or dungeon pass. May be with some consequences
	case riddle

	/// A chest, some exp points, stats restoration and so on. Can be applied after other events as result
	case reward
}
