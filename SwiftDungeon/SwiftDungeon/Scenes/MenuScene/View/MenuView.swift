import SwiftUI

/// Menu with different options to choose such as `Room`/`Dungeon` and so on
struct MenuView: View {

	// MARK: - Dependencies

	/// `ViewModel` for MenuView to observe
	@StateObject private var viewModel: MenuViewModel

	// MARK: - Initialization

	init(viewModel: MenuViewModel) {
		_viewModel = StateObject(wrappedValue: viewModel)
	}

	// MARK: - Body

	var body: some View {

		// MARK: NavigationStack

		NavigationStack(path: $viewModel.path) {

			// Display Screens in the form of the List

			// 1. Push the Screen

			List {
				Button("Room") {
					viewModel.pushRoom()
				}
				Button("Corridor") {
					viewModel.pushCorridor()
				}
				Button("Dungeon") {
					viewModel.pushDungeon()
				}
				Button("Town") {
					viewModel.pushTown()
				}
				Button("World") {
					viewModel.pushWorld()
				}
			}
			.navigationTitle("Main Menu")
			.navigationBarTitleDisplayMode(.inline)

			// Define data type for navigation destination and pass it through the closure

			.navigationDestination(for: AppScreen.self) { screen in

				// 2. Build the screen accordingly to it's type

				switch screen {

					// MARK: RoomBuilder

				case .room: viewModel.buildRoom()

					// MARK: CorridorBuilder

				case .corridor: viewModel.buildCorridor()

					// MARK: DungeonBuilder

				case .dungeon: viewModel.buildDungeon()

					// MARK: TownBuilder

				case .town: viewModel.buildTown()

					// MARK: WorldBuilder

				case .world: viewModel.buildWorld()

				}
			}
		}
	}
}
