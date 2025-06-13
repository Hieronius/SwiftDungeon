import SwiftUI

/// `Composition Root` or initial set of all app dependencies accordingly to Seeman's book "Dependency Injection"
///
/// We use static method to resolve dependecies because it's more predictable and stable than just an init
final class CompositionRoot {

	/// Shared entity to control navigation flow and `NavigationStack` across the app
	private let navigationManager = NavigationManager()

	/// Method to return current navigation manager
	func getNavigationManager() -> NavigationManager {
		self.navigationManager
	}

	// MARK: Build Menu

	/// Universal method to construct MenuScene with all required dependencies
	func buildMenu() -> some View {

		let navigationManager = getNavigationManager()
		let viewModel = MenuViewModel(
			appDependencies: self,
			navigationManager: navigationManager
		)

		let view = MenuView(viewModel: viewModel)
		return view
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

		let navigationManager = getNavigationManager()

		let viewModel = RoomViewModel(
			roomGameManager: roomGameManager,
			navigationManager: navigationManager,
			sceneUIStateManager: sceneUIStateManager
		)

		// Build RoomView

		return RoomView(viewModel: viewModel)
	}

	// MARK: Build Corridor

	func buildCorridor() -> CorridorView {

		let navigationManager = getNavigationManager()

		let viewModel = CorridorViewModel(
			navigationManager: navigationManager
		)

		return CorridorView(viewModel: viewModel)
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

		let navigationManager = getNavigationManager()

		let viewModel = DungeonViewModel(
			dungeonGameManager: dungeonGameManager,
			navigationManager: navigationManager
		)

		return DungeonView(viewModel: viewModel)
	}

	// MARK: Build Town

	func buildTown() -> TownView {

		let navigationManager = getNavigationManager()

		let viewModel = TownViewModel(
			navigationManager: navigationManager
		)

		return TownView(viewModel: viewModel)
	}

	// MARK: Build World

	func buildWorld() -> WorldView {

		let navigationManager = getNavigationManager()

		let viewModel = WorldViewModel(
			navigationManager: navigationManager
		)

		return WorldView(viewModel: viewModel)
	}
}
