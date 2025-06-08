import SwiftUI

/*
 MARK: Features to Implement

 1. Create a single TileViewBlock with constant size so each tile would fill it in costant distance between each other to immitate a real map
 2. Implement Scroll View to scroll the map (scale size, may be)
 - Transform method getTile to struct TileView
 - Implement different shape of the room and corridorr
 - Display Hero label
 - Display types of special events if hero has an ability to scan
 - Implement some UI like Energy, current level, current dungeon and so on
 - Implement method to scale map up and down instead of scroll
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

		actionButton(title: "To the Room!") {
			
		}

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

		// If starting point is empty it should not be the starting point

		let originalBackgroundColor: Color = tile.isExplored ? .gray : .white
		let isHeroPosition = tile.isHeroPosition(viewModel.heroPosition)
		let tileColor: Color = isHeroPosition ? .orange : originalBackgroundColor
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
