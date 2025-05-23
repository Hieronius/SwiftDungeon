import SwiftUI

/// `View` of TownScene
struct TownView: View {

	// MARK: - Dependencies

	/// `ViewModel` of TownScene
	@StateObject private var viewModel: TownViewModel

	// MARK: - Initialization

	init(viewModel: TownViewModel) {
		_viewModel = StateObject(wrappedValue: viewModel)
	}

	// MARK: - Body

	var body: some View {

		Text("Town Here")
			.navigationBarBackButtonHidden(true)
	}
}
