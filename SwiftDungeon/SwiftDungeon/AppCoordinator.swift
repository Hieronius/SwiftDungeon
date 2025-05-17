import Foundation

protocol AppCoordinatorProtocol {

}

final class AppCoordinator: AppCoordinatorProtocol {

	// MARK: Dependencies

	let roomBuilder: RoomBuilder
//	let mainMenuBuilder: MainMenuBuilder

	init(roomBuilder: RoomBuilder) {

		self.roomBuilder = roomBuilder
	}



}
