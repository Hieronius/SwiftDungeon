import SwiftUI

/// `ViewModel` of the MenuScene Module
final class MenuViewModel: ObservableObject {

	// MARK: - Properties

	/// All Possible Menu Options exposed to View to observe
	@Published var menuItems = [

		MenuItem(type: .room),
		MenuItem(type: .corridor),
		MenuItem(type: .dungeon),
		MenuItem(type: .town),
		MenuItem(type: .world)
	]
}
