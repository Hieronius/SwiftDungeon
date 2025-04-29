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

		ZStack {
			Color.black
			.edgesIgnoringSafeArea(.all)

			VStack {

//				Spacer()

				// MARK: - Info Layer (Top)

				HStack {

					Spacer()

					HStack {

						Text("Current Room:")
							.font(.title2)
							.foregroundColor(.white)

						Text("\(viewModel.currentRoom)")
							.font(.title2)
							.foregroundColor(.white)

					}

					Spacer()

					HStack {
						Text("Current Round:")
							.font(.title2)
							.foregroundColor(.white)
						Text("\(viewModel.currentRound)")
							.font(.title2)
							.foregroundColor(.white)
					}

					Spacer()
				}

				Spacer()

				// MARK: - Character's Stats (Top - Middle)

				HStack {

					VStack {
						Text("Hero")
							.font(.title2)
							.foregroundColor(.white)
						HealthBar(health: 100)
						ManaBar(mana: 100)
						EnergyBar(energy: 5)
					}

					Spacer()
					Spacer()

					VStack {
						Text("Enemy")
							.font(.title2)
							.foregroundColor(.white)
						HealthBar(health: 100)
						ManaBar(mana: 100)
						EnergyBar(energy: 5)
					}
				}

				Spacer()

				Spacer()

				// MARK: - Battle Field Layer (Middle)

				HStack {

					Spacer()

					ZStack {
						Rectangle()
							.frame(width: 100, height: 100)
							.foregroundColor(.black)
							.border(.white)
						Text("H")
							.font(.title2)
							.foregroundColor(.white)
					}

					Spacer()

					ZStack {
						Rectangle()
							.frame(width: 100, height: 100)
							.foregroundColor(.red)
							.border(.white)
						Text("H")
							.font(.title2)
							.foregroundColor(.white)
					}

					Spacer()

				}

				Spacer()
				Spacer()

				// MARK: - Buttons Layer (Bottom)

				HStack {
					Spacer()
					Button("Attack") {
						viewModel.attack()
					}
					.buttonStyle(.bordered)
					.font(.title)
					.foregroundColor(.white)
					Spacer()
					Button("Heal") {
						viewModel.heal()
					}
					.buttonStyle(.bordered)
					.font(.title)
					.foregroundColor(.white)
					Spacer()
				}

				Spacer()

			}
		}
    }
}

// MARK: Health/Mana/Energy Bars

struct HealthBar: View {
	var health: CGFloat // Value between 0 and 100

	var body: some View {
		ZStack(alignment: .leading) {
			Rectangle()
				.frame(width: health * 1.25, height: 20)
				.foregroundColor(.gray) // Background bar

			Rectangle()
				.frame(width: health * 1.25, height: 20) // Adjust width dynamically
				.foregroundColor(.red) // Health bar
		}
		.cornerRadius(5)
	}
}

struct ManaBar: View {
	var mana: CGFloat // Value between 0 and 100

	var body: some View {
		ZStack(alignment: .leading) {
			Rectangle()
				.frame(width: mana * 1.25, height: 20)
				.foregroundColor(.gray) // Background bar

			Rectangle()
				.frame(width: mana * 1.25, height: 20) // Adjust width dynamically
				.foregroundColor(.blue) // Health bar
		}
		.cornerRadius(5)
	}
}

struct EnergyBar: View {
	var energy: Int // Value between 1 and 5

	var body: some View {
		HStack {
			ForEach(0..<5) { index in
				Rectangle()
					.frame(width: 15, height: 20)
					.foregroundColor(index < energy ? .yellow : .gray) // Filled or empty
			}
		}
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
