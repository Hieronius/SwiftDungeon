import Foundation

protocol AppCoordinatorProtocol {

	func push(_ path: any Hashable)
	func popLast()

}

final class AppCoordinator: AppCoordinatorProtocol {

	// MARK: Dependencies

	let roomBuilder: RoomBuilder
//	let mainMenuBuilder: MainMenuBuilder

	init(roomBuilder: RoomBuilder) {

		self.roomBuilder = roomBuilder
	}


	func push(_ path: any Hashable) {

	}
	
	func popLast() {

	}


}
