import Foundation

/// An entity to create and build TownModule
class WorldBuilder {

	static func build() -> WorldView {

		let viewModel = WorldViewModel()

		return WorldView(viewModel: viewModel)
	}
}
