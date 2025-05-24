import SwiftUI

/*
 MARK: Features to Implement
 - Display DungeonMap of Game Tiles
 - Display Explored/Unexplored tiles in black/gray colors
 - Display Hero label
 - Display types of special events if hero has an ability to scan
 - Implement a tap gesture to enter new neighboring tile
 */

/// `View` of DungeonScene module
struct DungeonView: View {

	// MARK: - Dependencies

	/// `ViewModel` of DungeonScene
	@StateObject private var viewModel: DungeonViewModel

	// MARK: - Initialization

	init(viewModel: DungeonViewModel) {
		_viewModel = StateObject(wrappedValue: viewModel)
	}

	// MARK: - Body

	var body: some View {

		Text("Dungeon Here")
			.navigationBarBackButtonHidden(true)
	}
}
