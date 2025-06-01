import Foundation

/// Protocol of the Main Coordinator of the game
protocol AppCoordinatorProtocol {

	func push(_ path: any Hashable)
	func popLast()

}

/// Main Coordinator of the App
final class AppCoordinator: AppCoordinatorProtocol {

	// MARK: - Dependencies

	let roomBuilder: RoomBuilder
//	let mainMenuBuilder: MainMenuBuilder

	// MARK: - Initialization

	init(roomBuilder: RoomBuilder) {

		self.roomBuilder = roomBuilder
	}

	// MARK: - Public Methods


	func push(_ path: any Hashable) {

	}
	
	func popLast() {

	}


}
