import Foundation

/// An entity to create and build DungeonScene
class DungeonBuilder {

	static func build() -> DungeonView {

		let viewModel = DungeonViewModel()

		return DungeonView(viewModel: viewModel)
	}
}
