import Foundation

/// An entity to create a comprehensive list of screens to navigation between for our `NavigationManager`
enum AppScreen: String, Hashable, Identifiable {

	var id: AppScreen { self }

	/// Room encounter during dungeon exploration
	case room = "Room"

	/// Corridor encounter during dungeon exploration
	case corridor = "Corridor"

	/// Dungeon or Dungeon Map location during dungeon exploration
	case dungeon = "Dungeon"

	/// Town screen outside the dungeon with merchant, blacksmith and so on
	case town = "Town"

	/// World map screen with all kinds of lands and dungeons to choose
	case world = "World"
}


