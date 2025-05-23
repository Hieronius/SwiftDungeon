import SwiftUI

/// `View` of CorridorScene module
struct CorridorView: View {

	// MARK: - Dependencies

	/// `ViewModel` of CorridorScene
	@StateObject private var viewModel: CorridorViewModel

	// MARK: - Initialization

	init(viewModel: CorridorViewModel) {
		_viewModel = StateObject(wrappedValue: viewModel)
	}

	// MARK: - Body

	var body: some View {

		return Text("Corridor Here")
	}
}
