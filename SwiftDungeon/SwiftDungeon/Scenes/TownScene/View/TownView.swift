import SwiftUI

/// `View` of CorridorScene module
struct TownView: View {

	// MARK: - Dependencies

	/// `ViewModel` of CorridorScene
	@StateObject private var viewModel: TownViewModel

	// MARK: - Initialization

	init(viewModel: TownViewModel) {
		_viewModel = StateObject(wrappedValue: viewModel)
	}

	// MARK: - Body

	var body: some View {

		return Text("Town Here")
	}
}
