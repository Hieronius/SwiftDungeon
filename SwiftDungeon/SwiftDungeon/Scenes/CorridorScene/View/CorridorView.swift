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

		VStack {
			Button("Menu") {
				viewModel.popScreen()
			}
			Button("Go to Room") {
				viewModel.pushRoom()
			}
			Button("Go to Dungeon") {
				viewModel.pushDungeon()
			}
			Button("Go to Town") {
				viewModel.pushTown()
			}
			Button("Go to Town") {
				viewModel.pushTown()
			}
			Button("Go to World") {
				viewModel.pushWorld()
			}
		}
		.navigationBarBackButtonHidden(true)
	}
}
