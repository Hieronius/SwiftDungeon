import Foundation

// TODO: Should be refactored to avoid hardcoded dependencies creation
/// An entity to create and build DungeonScene
class DungeonBuilder {

	static func build() -> DungeonView {

		let dungeonGameStateSnapshot = DungeonGameStateSnapshot()

		let dungeonGameState = DungeonGameState(dungeonGameStateSnapshot: dungeonGameStateSnapshot)

		let dungeonMapGenerator = DungeonMapGenerator()

		let dungeonScheme = DungeonScheme()

		let dungeonGameManager = DungeonGameManager(
			dungeonGameState: dungeonGameState,
			dungeonMapGenerator: dungeonMapGenerator,
			dungeonScheme: dungeonScheme
		)

		let viewModel = DungeonViewModel(dungeonGameManager: dungeonGameManager)

		return DungeonView(viewModel: viewModel)
	}
}
