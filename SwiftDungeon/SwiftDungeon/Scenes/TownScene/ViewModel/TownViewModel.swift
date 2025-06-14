import SwiftUI

final class TownViewModel: ObservableObject {

	// MARK: - Dependencies

	let navigationManager: NavigationManager

	// MARK: - Initialization

	init(navigationManager: NavigationManager) {
		self.navigationManager = navigationManager
	}
}

// MARK: - Navigation

extension TownViewModel {
	
	func popScreen() {
		navigationManager.pop()
	}
}
