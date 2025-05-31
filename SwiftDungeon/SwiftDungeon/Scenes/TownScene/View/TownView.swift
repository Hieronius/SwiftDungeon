import SwiftUI

/// `View` of TownScene
struct TownView: View {

	// MARK: - Dependencies

	/// `ViewModel` of TownScene
	@StateObject private var viewModel: TownViewModel
	/// Property to allow to dismiss the screen after entering to via NavigationLink and NavigationStack
	@Environment(\.dismiss) var dismiss

	// MARK: - Initialization

	init(viewModel: TownViewModel) {
		_viewModel = StateObject(wrappedValue: viewModel)
	}

	// MARK: - Body

	var body: some View {

		actionButton(title: "Menu") {
			dismiss()
		}

		Text("Town Here")
			.navigationBarBackButtonHidden(true)
	}

	// MARK: Action Button

	func actionButton(title: String, action: @escaping () -> Void) -> some View {

		Button(title, action: action)
			.buttonStyle(.bordered)
			.font(.title2)
			.foregroundColor(.white)
	}
}
