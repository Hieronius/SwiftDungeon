import Foundation

/// An entity to create and build DungeonScene
class DungeonBuilder {

	static func build() -> DungeonView {

		let dungeonMapGenerator = DungeonMapGenerator()
		let viewModel = DungeonViewModel(
			dungeonMapGenerator: dungeonMapGenerator
		)

		return DungeonView(viewModel: viewModel)
	}
}
