import SwiftUI

struct RoomView: View {

	// MARK: - State Properties

	@StateObject private var viewModel: RoomViewModel

	// MARK: - Initialization

	init(viewModel: RoomViewModel) {
		_viewModel = StateObject(wrappedValue: viewModel)
	}

	// MARK: - Body

    var body: some View {
        VStack {

			HStack {
				Text("\(viewModel.currentRoom)")
				Text("\(viewModel.currentRound)")
			}

			HStack {
				Button("Attack") {
					viewModel.attack()
				}
				Button("Heal") {
					viewModel.heal()
				}
			}
			


        }
        .padding()
		.background(Color.black)
		.edgesIgnoringSafeArea(.all)
    }
}

// MARK: ContentView

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
		let gameState = GameState()
		let combatManager = CombatManager()
		let characterManager = CharacterManager()
		let viewModel = RoomViewModel(gameState: gameState,
									  combatManager: combatManager,
									  characterManager: characterManager)

		RoomView(viewModel: viewModel)
    }
}
