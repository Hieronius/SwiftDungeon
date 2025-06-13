import SwiftUI

final class CorridorViewModel: ObservableObject {

	// MARK: - Dependencies

	let navigationManager: NavigationManager

	// MARK: - Initialization

	init(navigationManager: NavigationManager) {
		self.navigationManager = navigationManager
	}
}

// MARK: - Navigation

extension CorridorViewModel {

	func popScreen() {
		navigationManager.pop()
	}

	func pushRoom() {
		popScreen()
		navigationManager.push(.room)
	}

	func pushDungeon() {
		popScreen()
		navigationManager.push(.dungeon)
	}

	func pushTown() {
		popScreen()
		navigationManager.push(.town)
	}

	func pushWorld() {
		popScreen()
		navigationManager.push(.world)
	}
}
