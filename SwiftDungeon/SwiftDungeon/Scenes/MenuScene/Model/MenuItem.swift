import SwiftUI

// MARK: - MenuItem

/// Struct to define a single MenuItem
struct MenuItem: Identifiable, Hashable {

	/// An ID to comform to Identifiable
	let id = UUID()

	/// Type of the screen such as .room, .dungeon, .town and so on
	let type: MenuType

	/// Label of the Menu Item
	var title: String { type.rawValue }
}
