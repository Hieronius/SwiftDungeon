import SwiftUI

/// `View` of World module
struct WorldView: View {

	// MARK: - Dependencies

	/// `ViewModel` of World Scene
	@StateObject private var viewModel: WorldViewModel
	@Environment(\.dismiss) var dismiss

	// MARK: - Initialization

	init(viewModel: WorldViewModel) {
		_viewModel = StateObject(wrappedValue: viewModel)
	}

	// MARK: - Body

	var body: some View {

		// MARK: Action Button

		Spacer()

		actionButton(title: "Menu") {
			dismiss()
		}

		Spacer()

		VStack {

			Spacer()

			actionButton(title: "Ruins") {
				print("Entered Ruins")
			}

			Spacer()

			actionButton(title: "Cave") {
				print("Entered Cave")
			}

			Spacer()

			actionButton(title: "Sematery") {
				print("Entered Sematery")
			}

			Spacer()

			actionButton(title: "Forest") {
				print("Entered Forest")
			}

			Spacer()
		}

		Spacer()


			.navigationBarBackButtonHidden(true)
	}


	func actionButton(title: String, action: @escaping () -> Void) -> some View {

		Button(title, action: action)
			.buttonStyle(.bordered)
			.font(.title2)
			.foregroundColor(.white)
	}

	
}
