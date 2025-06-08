import SwiftUI

final class WorldViewModel: ObservableObject {

	// MARK: - Dependencies

	let navigationManager: NavigationManager


	// MARK: - Initialization

	init(navigationManager: NavigationManager) {
		self.navigationManager = navigationManager
	}
}
