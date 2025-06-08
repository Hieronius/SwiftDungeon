import SwiftUI

/// An entity to control navigation flow in the app
///
/// Should be constructed in composition root and injected via init into ViewModels of the modules we want be able to navigate through
final class NavigationManager {

	// MARK: - Properties

	private var path = NavigationPath()

	var isEmpty: Bool { path.isEmpty }

	var count: Int { path.count }

	// MARK: - Methods

	func getPath() -> NavigationPath {
		return path
	}

	func push(_ screen: MenuType) {
		path.append(screen)
	}

	func pop() {
		guard !isEmpty else { return }
		path.removeLast()
	}

	func reset() {
		path = NavigationPath()
	}

	func moveFromDungeonToRoom() {

	}

	func moveFromRoomToDungeon() {
		
	}
}
