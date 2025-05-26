import SwiftUI

/*
 MARK: Features to Implement
 - Display DungeonMap of Game Tiles
 - Display Explored/Unexplored tiles in black/gray colors
 - Display Hero label
 - Display types of special events if hero has an ability to scan
 - Implement a tile as Button and make it inactive if it's not neighbour of user's tile. If active - put user tile in it
 - Implement some UI like Energy, current level, current dungeon and so on
 */

/// `View` of DungeonScene module
struct DungeonView: View {

	// MARK: - Dependencies

	/// `ViewModel` of DungeonScene
	@StateObject private var viewModel: DungeonViewModel

	// MARK: - Properties

	/// Property to allow to dismiss the screen after entering to via NavigationLink and NavigationStack
	@Environment(\.dismiss) var dismiss

	// MARK: - Initialization

	init(viewModel: DungeonViewModel) {
		_viewModel = StateObject(wrappedValue: viewModel)
	}

	// MARK: - Body

	var body: some View {

		Spacer()

		actionButton(title: "Menu") {
			dismiss()
		}

		Spacer()

		getDungeonMap()

		Spacer()
		
		.navigationBarBackButtonHidden(true)
	}

	// MARK: Action Button

	func actionButton(title: String, action: @escaping () -> Void) -> some View {

		Button(title, action: action)
			.buttonStyle(.bordered)
			.font(.title2)
			.foregroundColor(.white)
	}

	// MARK: Get Dungeon Map

	@ViewBuilder
	func getDungeonMap() -> some View {

		VStack {

			ForEach(viewModel.dungeonMap.indices, id: \.self) { row in

				HStack {

					ForEach(viewModel.dungeonMap[row].indices, id: \.self) { col in

						let tile = viewModel.dungeonMap[row][col]

						getTileButton(tile: tile) {

							viewModel.handleTappedDirection(row, col)

							print("taped the tile")

						}
					}
				}
			}
		}
	}

	// TODO: Transform to struct TileView
	// MARK: Tile Button View

	func getTileButton(tile: Tile, action: @escaping () -> Void) -> some View {

		let isHeroPosition = viewModel.checkIfHeroPositionTile(tile.row, tile.col)
		let tileColor: Color = isHeroPosition ? .orange : .white
		var title: String
		var opacityRatio: CGFloat = 1.0

		// Just turn this property to 0 for complete hidden state of the button

		if tile.type == .empty { opacityRatio = 0.1 }

		switch tile.type {
		case .room:
			title = "R"
		case .corridor:
			title = "C"
		case .empty:
			title = "E"
		}

		return Button(title, action: action)
			.frame(width: 50, height: 50)
			.buttonStyle(.bordered)
			.font(.title2)
			.foregroundColor(tileColor)
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
