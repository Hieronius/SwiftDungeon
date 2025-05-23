import SwiftUI

final class MainMenuViewModel: ObservableObject, Identifiable {

	// MARK: - Screens (Types)

	enum Path: Hashable {

//		case dungeon(DungeonViewModel)
//		case town(TownViewModel)
//		case corridor(CorridorViewModel)
//		case worldMap(WorldMapViewModel)
		case room(RoomViewModel)
	}

	// MARK: - Properties

	var id = UUID()

	/// The object that handles our navigation stack
	@Published var paths = NavigationPath()

	/// The ViewModel that represents our first view in the navigation stack
//		public lazy var roomViewModel: RoomViewModel = {
//			.init(navigator: self, text: "First!")
//		}()

}

// MARK: - NavigationCoordinator

extension MainMenuViewModel: AppCoordinatorProtocol {

	public func push(_ path: any Hashable) {
		DispatchQueue.main.async { [weak self] in
			self?.paths.append(path)
		}
	}

	public func popLast() {
		DispatchQueue.main.async { [weak self] in
			self?.paths.removeLast()
		}
	}

}
