import SwiftUI

/// `Composition Root` or initial set of all app dependencies accordingly to Seeman's book "Dependency Injection"
///
/// We use static method to resolve dependecies because it's more predictable and stable than just an init
final class AppDependencies {

	// MARK: Build NavigationManager

	/// Static method to construct dependency, set of dependencies or the whole screens/modules
	func buildNavigationManager() -> NavigationManager {

		let navigationManager = NavigationManager()
		return navigationManager
	}

	// MARK: Build Menu

	/// Universal method to construct MenuScene with all required dependencies
	func buildMenu() -> some View {

		let navigationManager = buildNavigationManager()
		let viewModel = MenuViewModel(
			appDependencies: self,
			navigationManager: navigationManager
		)

		let view = MenuView(viewModel: viewModel)
		return view
	}

	// MARK: Build Dungeon

	func buildDungeon() -> DungeonView {

		let dungeonGameStateSnapshot = DungeonGameStateSnapshot()

		let dungeonGameState = DungeonGameState(dungeonGameStateSnapshot: dungeonGameStateSnapshot)

		let dungeonMapGenerator = DungeonMapGenerator()

		let dungeonScheme = DungeonScheme()

		let dungeonGameManager = DungeonGameManager(
			dungeonGameState: dungeonGameState,
			dungeonMapGenerator: dungeonMapGenerator,
			dungeonScheme: dungeonScheme
		)

		let navigationManager = buildNavigationManager()

		let viewModel = DungeonViewModel(
			dungeonGameManager: dungeonGameManager,
			navigationManager: navigationManager
		)

		return DungeonView(viewModel: viewModel)
	}

	// MARK: Build Room

	func buildRoom() -> RoomView {

		// Build Dependencies for RoomGameManager

		let roomGameStateSnapshot = RoomGameStateSnapshot()

		let roomGameState = RoomGameState(
			roomGameStateSnapshot: roomGameStateSnapshot)

		let actionCalculator = ActionCalculator()
		let actionHandler = ActionHandler(actionCalculator: actionCalculator)
		let characterManager = CharacterManager()
		let effectManager = EffectManager()
		let turnManager = TurnManager()

		// Build RoomGameManager

		let roomGameManager = RoomGameManager(
			roomGameState: roomGameState,
			actionHandler: actionHandler,
			characterManager: characterManager,
			effectManager: effectManager,
			turnManager: turnManager
		)

		// Build RoomViewModel

		let sceneUIStateManager = SceneUIStateManager()

		let viewModel = RoomViewModel(
			roomGameManager: roomGameManager,
			sceneUIStateManager: sceneUIStateManager
		)

		// Build RoomView

		return RoomView(viewModel: viewModel)
	}

}
