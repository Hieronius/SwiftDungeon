import SwiftUI

/// `View` of World module
struct WorldView: View {

	// MARK: - Dependencies

	/// `ViewModel` of World Scene
	@StateObject private var viewModel: WorldViewModel

	// MARK: - Initialization

	init(viewModel: WorldViewModel) {
		_viewModel = StateObject(wrappedValue: viewModel)
	}

	// MARK: - Body

	var body: some View {

		return Text("World Here")
	}
}
