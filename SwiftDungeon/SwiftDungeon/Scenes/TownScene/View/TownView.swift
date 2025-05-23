import SwiftUI

/// `View` of Town module
struct TownView: View {

	// MARK: - Dependencies

	/// `ViewModel` of TownModule
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
