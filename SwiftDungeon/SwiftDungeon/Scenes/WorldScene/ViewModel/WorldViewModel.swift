import SwiftUI

final class WorldViewModel: ObservableObject {

	// MARK: - Dependencies

	let navigationManager: NavigationManager


	// MARK: - Initialization

	init(navigationManager: NavigationManager) {
		self.navigationManager = navigationManager
	}
}

// MARK: - Navigation

extension WorldViewModel {

	func popScreen() {
		navigationManager.pop()
	}
}
