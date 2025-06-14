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

		Spacer()

		actionButton(title: "Menu") {
			viewModel.popScreen()
		}

		Spacer()

		HStack {

			Spacer()

			VStack {

				Spacer()
				actionButton(title: "Alchemy") {
					print("entered alchemy shop")
				}

				Spacer()

				actionButton(title: "Forge") {
					print("entered blacksmith shop")
				}

				Spacer()

				actionButton(title: "Training") {
					print("entered training centre")
				}

				Spacer()
			}

			Spacer()

			VStack {

				Spacer()

				actionButton(title: "Consumabales") {
					print("entered grocery store")
				}

				Spacer()

				actionButton(title: "Quest") {
					print("entered adventure guild")
				}

				Spacer()
			}

			Spacer()
		}

		Spacer()

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
