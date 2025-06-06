import Foundation

/// Entity to define all possible options of the MenuScene to navigate from
///
/// Subscrubed to Hashable because we use it as NavigationStack item
/// String allows us to use raw value of each case in MenuItem.label by computed prop.
enum MenuType: String, Hashable, CaseIterable {

	case room = "Room"
	case dungeon = "Dungeon"
	case corridor = "Corridor"
	case town = "Town"
	case world = "World"
}
