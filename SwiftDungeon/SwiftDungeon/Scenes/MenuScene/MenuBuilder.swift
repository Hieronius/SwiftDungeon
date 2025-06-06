import SwiftUI

/// Entity to build `MenuScene`
class MenuBuilder {

	/// Universal method to construct MenuScene with all required dependencies
	static func build() -> some View {

		let viewModel = MenuViewModel()

		let view = MenuView(viewModel: viewModel)
		return view
	}
}
