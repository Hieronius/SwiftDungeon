import Foundation

/// An entity to create a comprehensive list of screens to navigation between for our `NavigationManager`
enum AppScreen: Hashable {

	/// Main Menu of the game
	case menu

	/// Room encounter during dungeon exploration
	case room

	/// Corridor encounter during dungeon exploration
	case corridor

	/// Dungeon or Dungeon Map location during dungeon exploration
	case dungeon

	/// Town screen outside the dungeon with merchant, blacksmith and so on
	case town

	/// World map screen with all kinds of lands and dungeons to choose
	case world
}


