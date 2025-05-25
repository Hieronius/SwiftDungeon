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

		// TODO: Use forEach for rows and columns
		// TODO: Create TileView as Struct with row/col properties

		VStack {

			ForEach(viewModel.dungeonMap.indices, id: \.self) { row in

				HStack {

					ForEach(viewModel.dungeonMap[row].indices, id: \.self) { col in

						let tile = viewModel.dungeonMap[row][col]

						TileButton(tile: tile) { print("taped the tile") }
					}
				}
			}
		}
		.navigationBarBackButtonHidden(true)
	}

	// TODO: Transform to struct TileView
	// MARK: Tile Button View

	func TileButton(tile: Tile, action: @escaping () -> Void) -> some View {

		var title: String
		var opacityRatio: CGFloat = 1.0

		if tile.type == .empty { opacityRatio = 0.5 }

		switch tile.type {
		case .room:
			title = "Room"
		case .corridor:
			title = "Corr"
		case .empty:
			title = "Empt"
		}

		return Button(title, action: action)
			.buttonStyle(.bordered)
			.font(.title2)
			.foregroundColor(.white)
			.opacity(opacityRatio)
	}
}

struct TileView: View {

	let row: Int
	let column: Int
	let isExplored: Bool
	let heroPosition: Bool

	var body: some View {

		Button("Tile") { print("Tile pressed") }
			.buttonStyle(.bordered)
			.font(.title2)
			.foregroundColor(.white)
		
	}
}
