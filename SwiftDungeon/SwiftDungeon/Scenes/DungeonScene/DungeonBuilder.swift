import Foundation

/// An entity to create and build DungeonScene
class DungeonBuilder {

	static func build() -> DungeonView {

		/// Game Tiles Generator for Dungeon Level
		let dungeonMapGenerator = DungeonMapGenerator()
		let viewModel = DungeonViewModel(
			dungeonMapGenerator: dungeonMapGenerator
		)

		return DungeonView(viewModel: viewModel)
	}
}
