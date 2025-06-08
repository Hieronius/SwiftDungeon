import SwiftUI

/// `ViewModel` of the MenuScene Module
final class MenuViewModel: ObservableObject {

	// MARK: - Dependecies

	/// `Compositional Root` of the app with preconstructed (predefined dependencies graph)
	///
	/// Think about it not like a complete graph but like of the list of cooking recepies you have on hand. What to put and how to cook instead of complete dish.
	private let appDependencies: AppDependencies

	/// Dependency to control Navigation Flow across the app
	private let navigationManager: NavigationManager

	// MARK: - Properties

	/// `NavigationPath` property to be used by UI to update when NavigationManager.path did change
	@Published var path: NavigationPath

	/// All Possible Menu Options exposed to View to observe
	@Published var menuItems = [

		MenuItem(type: .room),
		MenuItem(type: .corridor),
		MenuItem(type: .dungeon),
		MenuItem(type: .town),
		MenuItem(type: .world)
	]

	init(appDependencies: AppDependencies,
		 navigationManager: NavigationManager) {
		
		self.appDependencies = appDependencies
		self.navigationManager = navigationManager

		self.path = navigationManager.getPath()
	}
}

// MARK: - Navigation

extension MenuViewModel {

	func buildDungeon() -> some View {
		appDependencies.buildDungeon()
	}

	func buildRoom() -> some View {
		appDependencies.buildRoom()
	}
}
