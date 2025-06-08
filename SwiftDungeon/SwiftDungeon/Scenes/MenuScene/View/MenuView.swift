import SwiftUI

/// Menu with different options to choose such as `Room`/`Dungeon` and so on
struct MenuView: View {

	// MARK: - Dependencies

	/// `ViewModel` for MenuView to observe
	@StateObject private var viewModel: MenuViewModel

	// MARK: - Properties

	/// Place to store our actual Navigation Stack
	///
	/// Use to push/pop screens to create different combinations like transition from DungeonMap to Room
	// @State private var path = NavigationPath()

	// MARK: - Initialization

	init(viewModel: MenuViewModel) {
		_viewModel = StateObject(wrappedValue: viewModel)
	}

	// MARK: - Body

	var body: some View {

		// MARK: NavigationStack

		NavigationStack(path: $viewModel.path) {

			// Display MenuItems in the form of the List

			List(viewModel.menuItems) { item in
				NavigationLink(item.title, value: item)
			}
			.navigationTitle("Main Menu")
			.navigationBarTitleDisplayMode(.inline)

			// Define data type for navigation destination and pass it through the closure

			.navigationDestination(for: MenuItem.self) { item in

				switch item.type {

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
