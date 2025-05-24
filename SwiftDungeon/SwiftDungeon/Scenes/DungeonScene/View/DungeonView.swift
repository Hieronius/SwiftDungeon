import SwiftUI

/*
 MARK: Features to Implement
 - Display DungeonMap of Game Tiles
 - Display Explored/Unexplored tiles in black/gray colors
 - Display Hero label
 - Display types of special events if hero has an ability to scan
 - Implement a tile as Button and make it inactive if it's not neighbour of user's tile. If active - put user tile in it
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

		// TODO: Use forEach for rows and columns
		// TODO: Create TileView as Struct with row/col properties

		VStack {
			ForEach(viewModel.dungeonMap, id: \.self) {
				Text("TILE")
			}
		}
			.navigationBarBackButtonHidden(true)
	}
}
