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
				.contentShape(Rectangle())
				.onTapGesture(count: 3) {
					viewModel.restoreHero()
				}

			VStack {
				gameInfoSection()
				Spacer()
				characterStatsSection()
				Spacer()
				battleFieldSection()
				Spacer()
				actionButtons()
				Spacer()
			}

		}

		// Entry point for Game Flow
		.onAppear {
			viewModel.startFight()
		}
	}

	// MARK: - Info Layer (Room & Round)
	@ViewBuilder
	private func gameInfoSection() -> some View {
		HStack {
			Spacer()
			infoText(label: "Current Room:", value: viewModel.currentRoom)
			Spacer()
			infoText(label: "Current Round:", value: viewModel.currentRound)
			Spacer()
		}
		
	}

	private func infoText(label: String, value: Int) -> some View {
		HStack {
			Text(label)
				.font(.title2)
				.foregroundColor(.white)
			Text("\(value)")
				.font(.title2)
				.foregroundColor(.white)
		}
	}

	// MARK: - Character Stats (Hero & Enemy)
	@ViewBuilder
	private func characterStatsSection() -> some View {
		HStack {
			characterStats(name: "Hero", health: 100, mana: 100, energy: 5)
			Spacer()
			characterStats(name: "Enemy", health: 100, mana: 100, energy: 5)
		}
	}

	private func characterStats(name: String, health: CGFloat, mana: CGFloat, energy: Int) -> some View {
		VStack {
			Text(name)
				.font(.title2)
				.foregroundColor(.white)
			HealthBar(health: health)
			ManaBar(mana: mana)
			EnergyBar(energy: energy)
		}
	}

	// MARK: - Battle Field Layer

	@ViewBuilder
	private func battleFieldSection() -> some View {
		HStack {
			Spacer()
			characterTile(
				color: .black,
				label: "H",
				isActive: viewModel.isHeroTurn,
				activeColor: .gray
			)
			Spacer()
			characterTile(
				color: .red,
				label: "E",
				isActive: !viewModel.isHeroTurn,
				activeColor: .orange
			)
			Spacer()
		}
	}

	// MARK: - Action Buttons

	@ViewBuilder
	private func actionButtons() -> some View {
		HStack {
			Spacer()
			actionButton(title: "Attack",
						 action: viewModel.attack)
			Spacer()
			actionButton(title: "Heal",
						 action: viewModel.heal)
			Spacer()
		}
		HStack {
			Spacer()
			actionButton(title: "Block",
						 action: viewModel.block)
			Spacer()
			actionButton(title: "Buff",
						 action: viewModel.buff)
			Spacer()
		}
		actionButton(title: "End Turn",
					 action: viewModel.endTurn)
	}

	private func actionButton(title: String, action: @escaping () -> Void) -> some View {
		Button(title, action: action)
			.buttonStyle(.bordered)
			.font(.title)
			.foregroundColor(.white)
	}
}

// MARK: Health Bar
struct HealthBar: View {
	var health: CGFloat // Value between 0 and 100

	var body: some View {
		ZStack(alignment: .leading) {
			Rectangle()
				.frame(width: 125, height: 20)
				.foregroundColor(.gray) // Background bar

			Rectangle()
				.frame(width: health * 1.25, height: 20) // Adjust width dynamically
				.foregroundColor(.red) // Health bar
		}
		.cornerRadius(5)
	}
}

// MARK: Mana Bar
struct ManaBar: View {
	var mana: CGFloat // Value between 0 and 100

	var body: some View {
		ZStack(alignment: .leading) {
			Rectangle()
				.frame(width: 125, height: 20)
				.foregroundColor(.gray) // Background bar

			Rectangle()
				.frame(width: mana * 1.25, height: 20) // Adjust width dynamically
				.foregroundColor(.blue) // Mana bar
		}
		.cornerRadius(5)
	}
}

// MARK: Energy Bar
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

// MARK: Special Effects

private func characterTile(color: Color, label: String, isActive: Bool, activeColor: Color) -> some View {
	ZStack {
		// Aura/Pulse effect
		if isActive {
			Circle()
				.stroke(activeColor.opacity(0.6), lineWidth: 2)
				.frame(width: 130, height: 130)
				.scaleEffect(1.2)
				.opacity(0)
				.overlay(
					Circle()
						.stroke(activeColor, lineWidth: 3)
						.frame(width: 130, height: 130)
						.scaleEffect(1.5)
						.opacity(0)
				)
				.animation(
					Animation.easeInOut(duration: 1.5)
						.repeatForever(autoreverses: false),
					value: isActive
				)
		}

		// Main tile
		Rectangle()
			.frame(width: 100, height: 100)
			.foregroundColor(color)
			.overlay(
				Rectangle()
					.stroke(isActive ? activeColor : Color.white, lineWidth: isActive ? 3 : 1)
			)

		Text(label)
			.font(.title2)
			.foregroundColor(.white)
	}
}

// MARK: - ContentView Previews
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
