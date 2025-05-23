import Foundation

/// An entity to create and build CorridorModule
class CorridorBuilder {

	static func build() -> CorridorView {

		let viewModel = CorridorViewModel()

		return CorridorView(viewModel: viewModel)
	}
}
