import SwiftUI

final class CorridorViewModel: ObservableObject {

	// MARK: - Dependencies

	let navigationManager: NavigationManager

	// MARK: - Initialization

	init(navigationManager: NavigationManager) {
		self.navigationManager = navigationManager
	}
}
