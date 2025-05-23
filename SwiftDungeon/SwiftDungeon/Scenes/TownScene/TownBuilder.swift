import Foundation

/// An entity to create and build TownModule
class TownBuilder {

	static func build() -> TownView {

		let viewModel = TownViewModel()

		return TownView(viewModel: viewModel)
	}
}
