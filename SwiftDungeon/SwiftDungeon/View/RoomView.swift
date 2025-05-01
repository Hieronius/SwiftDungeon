import SwiftUI

// MARK: Note to implement
// ifVisibleInventory/ifVisibleSkills property can be used in GameState or even here in the view to display a bunch of views/buttons/screens accordingly
struct RoomView: View {

	// MARK: - State Properties
	@StateObject private var viewModel: RoomViewModel
	@State private var isEnemyUI = true

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
			// Hero
			characterStats(name: "Hero",
						   currentExperience: CGFloat(viewModel.heroCurrentExperience),
						   maxExperience:
							CGFloat(viewModel.heroMaxExperience),
						   currentHealth: CGFloat(viewModel.heroCurrentHealth),
						   maxHealth:
							CGFloat(viewModel.heroMaxHealth),
						   maxMana: CGFloat(viewModel.heroMaxMana),
						   currentMana: CGFloat(viewModel.heroCurrentMana),
						   energy: viewModel.heroCurrentEnergy)
			Spacer()
			// Enemy
			characterStats(name: "Enemy",
						   currentExperience: 0,
						   maxExperience: 0,
						   currentHealth: CGFloat(viewModel.enemyCurrentHealth),
						   maxHealth:
							CGFloat(viewModel.enemyMaxHealth),
						   maxMana: CGFloat(viewModel.enemyMaxMana), currentMana: CGFloat(viewModel.enemyCurrentMana),
						   energy: viewModel.enemyCurrentEnergy)
		}
	}

	private func characterStats(name: String,
								currentExperience: CGFloat,
								maxExperience: CGFloat,
								currentHealth: CGFloat,
								maxHealth: CGFloat,
								maxMana: CGFloat,
								currentMana: CGFloat,
								energy: Int) -> some View {
		VStack {
			Text(name)
				.font(.title2)
				.foregroundColor(.white)
			ExperienceBar(currentExperience: currentExperience,
						  maxExperience: maxExperience)
			HealthBar(currentHealth: currentHealth,
					  maxHealth: maxHealth)
			ManaBar(currentMana: currentMana,
					maxMana: maxMana)
			EnergyBar(energy: energy)
		}
	}

	// MARK: - Battle Field Layer

	@ViewBuilder
	private func battleFieldSection() -> some View {
		HStack {
			Spacer()
			CharacterTileView(
				baseColor: .black,
				label:    "H",
				isActive: viewModel.isHeroTurn,
				activeColor: .gray,
				effectColor: viewModel.heroEffectColor,
				didHit: viewModel.heroWasHit
			)
			Spacer()
			CharacterTileView(
				baseColor: .red,
				label:    "E",
				isActive: !viewModel.isHeroTurn,
				activeColor: .orange,
				effectColor: viewModel.enemyEffectColor,
				didHit: viewModel.enemyWasHit
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
			actionButton(title: "Heal",
						 action: viewModel.heal)
			Spacer()
		}
		HStack {
			Spacer()
			actionButton(title: "Block",
						 action: viewModel.block)
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

// MARK: Experience Bar

struct ExperienceBar: View {
	
	var currentExperience: CGFloat // Value between 0 and 100
	var maxExperience: CGFloat

	private var experiencePercentage: CGFloat {
		guard maxExperience > 0 else { return 0 }
		guard currentExperience > 0 else { return 1 }
		return (currentExperience / maxExperience) * 100
	}

	var body: some View {
		ZStack(alignment: .leading) {
			Rectangle()
				.frame(width: 100, height: 20)
				.foregroundColor(.gray) // Background bar

			Rectangle()
				.frame(width: experiencePercentage, height: 20) // Adjust width dynamically
				.foregroundColor(.orange) // Health bar
		}
		.cornerRadius(5)
		.opacity(experiencePercentage > 0 ? 1 : 0)
	}
}

// MARK: Health Bar

struct HealthBar: View {

	var currentHealth: CGFloat // Value between 0 and 100
	var maxHealth: CGFloat

	private var healthPercentage: CGFloat {
		guard maxHealth > 0 else { return 0 }
		return (currentHealth / maxHealth) * 100
	}

	var body: some View {
		ZStack(alignment: .leading) {
			Rectangle()
				.frame(width: 100, height: 20)
				.foregroundColor(.gray) // Background bar

			Rectangle()
				.frame(width: healthPercentage, height: 20) // Adjust width dynamically
				.foregroundColor(.red) // Health bar
		}
		.cornerRadius(5)
	}
}

// MARK: Mana Bar

struct ManaBar: View {

	var currentMana: CGFloat // Value between 0 and 100
	var maxMana: CGFloat

	private var manaPercentage: CGFloat {
		guard maxMana > 0 else { return 0 }
		return (currentMana / maxMana) * 100
	}

	var body: some View {
		ZStack(alignment: .leading) {
			Rectangle()
				.frame(width: 100, height: 20)
				.foregroundColor(.gray) // Background bar

			Rectangle()
				.frame(width: manaPercentage, height: 20) // Adjust width dynamically
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

import SwiftUI

struct CharacterTileView: View {
	let baseColor: Color
	let label: String
	let isActive: Bool
	let activeColor: Color
	let effectColor: Color?
	let didHit: Bool

	@State private var pulse = false
	@State private var internalEffect: Color? = nil
	@State private var shaking = false

	var body: some View {
		ZStack {
			// Aura pulse
			if isActive {
				Circle()
					.stroke(activeColor, lineWidth: 3)
					.frame(width: 130, height: 130)
					.scaleEffect(pulse ? 1.6 : 1.2)
					.opacity(pulse ? 0 : 0.6)
					.onAppear {
						pulse = false
						startPulse()
					}
					.onChange(of: isActive) { newValue in
						guard newValue else { return }
						pulse = false
						startPulse()
					}
			}

			// Main square with optional effect color + shake
			Rectangle()
				.frame(width: 100, height: 100)
				.foregroundColor(internalEffect ?? baseColor)
				.overlay(
					Rectangle()
						.stroke(isActive ? activeColor : .white,
								lineWidth: isActive ? 3 : 1)
				)
				.offset(x: shaking ? 8 : 0)
				.animation(
					shaking
					? Animation.linear(duration: 0.05)
						.repeatCount(6, autoreverses: true)
					: .default,
					value: shaking
				)

			// Label
			Text(label)
				.font(.title2)
				.foregroundColor(.white)
		}
		.frame(width: 130, height: 130)
		.onChange(of: effectColor) { newColor in
			internalEffect = newColor
		}
		.onChange(of: didHit) { hit in
			if hit { animateHit() }
		}
	}

	private func startPulse() {
		withAnimation(
			Animation.easeOut(duration: 1.5)
				.repeatForever(autoreverses: false)
		) {
			pulse = true
		}
	}

	private func animateHit() {
		shaking = true
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
			shaking = false
		}
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
