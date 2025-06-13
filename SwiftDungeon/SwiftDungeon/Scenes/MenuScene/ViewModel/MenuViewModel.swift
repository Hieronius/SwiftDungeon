import SwiftUI

/// `ViewModel` of the MenuScene Module
final class MenuViewModel: ObservableObject {

	// MARK: - Dependecies

	/// `Compositional Root` of the app with preconstructed (predefined dependencies graph)
	///
	/// Think about it not like a complete graph but like of the list of cooking recepies you have on hand. What to put and how to cook instead of complete dish.
	private let compositionRoot: CompositionRoot

	/// Dependency to control Navigation Flow across the app
	private let navigationManager: NavigationManager

	// MARK: - Properties

	/// `NavigationPath` property to be used by UI to update when NavigationManager.path did change
	@Published var path: NavigationPath

	// MARK: - Initialization

	init(appDependencies: CompositionRoot,
		 navigationManager: NavigationManager) {
		
		self.compositionRoot = appDependencies
		self.navigationManager = navigationManager

		// MARK: This code makes Navigation Stack to work normally with Push/Pop but be cautious

		// Observe navigationManager.path updates
		self.path = navigationManager.path
		navigationManager.$path
			.receive(on: DispatchQueue.main)
			.assign(to: &$path)
	}
}

// MARK: - Navigation

extension MenuViewModel {

	// MARK: PushRoom

	func pushRoom() {
		navigationManager.push(.room)
	}

	// MARK: PushCorridor

	func pushCorridor() {
		navigationManager.push(.corridor)
	}

	// MARK: PushDungeon

	func pushDungeon() {
		navigationManager.push(.dungeon)
	}

	// MARK: PushTown

	func pushTown() {
		navigationManager.push(.town)
	}

	// MARK: PushWorld

	func pushWorld() {
		navigationManager.push(.world)
	}
}

// MARK: - Screen Creation

extension MenuViewModel {

	// MARK: Build Room

	func buildRoom() -> some View {
		compositionRoot.buildRoom()

	}

	// MARK: Build Corridor

	func buildCorridor() -> some View {
		compositionRoot.buildCorridor()
	}

	// MARK: Build Dungeon

	func buildDungeon() -> some View {
		compositionRoot.buildDungeon()
	}

	// MARK: Build Town

	func buildTown() -> some View {
		compositionRoot.buildTown()
	}

	// MARK: Build World

	func buildWorld() -> some View {
		compositionRoot.buildWorld()
	}

}
