import SwiftUI

struct RoomView: View {

	// MARK: - State Properties

	@StateObject private var viewModel: RoomViewModel
	@State private var isEnemyUI = true

	// MARK: - Initialization

	init(viewModel: RoomViewModel) {
		_viewModel = StateObject(wrappedValue: viewModel)
	}

	// MARK: - Main Structure of the RoomScene

	var body: some View {
		ZStack {

			// Make screen tappable to implement different functions
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
			}

		}

		// MARK: ENTRY POINT TO THE GAME
		.onAppear {
			viewModel.startFight()
		}
	}

	// MARK: - Info Layer (Room & Round)

	@ViewBuilder
	private func gameInfoSection() -> some View {
		HStack {
			Spacer()
			infoText(label: "Current Room:", value: viewModel.roomState.currentRoom)
			Spacer()
			infoText(label: "Current Round:", value: viewModel.roomState.currentRound)
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
						   level: "\(viewModel.heroState.heroCurrentLevel)",
						   currentExperience: CGFloat(viewModel.heroState.heroCurrentExperience),
						   maxExperience:
							CGFloat(viewModel.heroState.heroMaxExperience),
						   currentHealth: CGFloat(viewModel.heroState.heroCurrentHealth),
						   maxHealth:
							CGFloat(viewModel.heroState.heroMaxHealth),
						   maxMana: CGFloat(viewModel.heroState.heroMaxMana),
						   currentMana: CGFloat(viewModel.heroState.heroCurrentMana),
						   energy: viewModel.heroState.heroCurrentEnergy,
						   effects: viewModel.heroState.heroActiveEffects)
			Spacer()

			// Enemy
			characterStats(name: "Enemy",
						   level: "\(viewModel.enemyState.enemyCurrentLevel)",
						   currentExperience: 0,
						   maxExperience: 0,
						   currentHealth: CGFloat(viewModel.enemyState.enemyCurrentHealth),
						   maxHealth:
							CGFloat(viewModel.enemyState.enemyMaxHealth),
						   maxMana: CGFloat(viewModel.enemyState.enemyMaxMana), currentMana: CGFloat(viewModel.enemyState.enemyCurrentMana),
						   energy: viewModel.enemyState.enemyCurrentEnergy,
						   effects: viewModel.enemyState.enemyActiveEffects)
		}
	}

	private func characterStats(name: String,
								level: String,
								currentExperience: CGFloat,
								maxExperience: CGFloat,
								currentHealth: CGFloat,
								maxHealth: CGFloat,
								maxMana: CGFloat,
								currentMana: CGFloat,
								energy: Int,
								effects: [Effect]) -> some View {
		VStack {
			HStack {
				ZStack {
					Rectangle()
						.frame(width: 30, height: 30)
						.foregroundColor(.gray)
					Text(level)
						.font(.title2)
						.foregroundColor(.white)
				}
				.cornerRadius(10)
				Text(name)
					.font(.title)
					.bold(true)
					.foregroundColor(.white)
			}
			ExperienceBar(currentExperience: currentExperience,
						  maxExperience: maxExperience)
			HealthBar(currentHealth: currentHealth,
					  maxHealth: maxHealth)
			ManaBar(currentMana: currentMana,
					maxMana: maxMana)
			EnergyBar(energy: energy)
			EffectBar(effects: effects)
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
				isActive: viewModel.roomState.isHeroTurn,
				activeColor: .gray,
				effectColor: viewModel.heroEffectColor,
				didHit: viewModel.roomState.heroWasHit
			)
			Spacer()
			CharacterTileView(
				baseColor: .red,
				label:    "E",
				isActive: !viewModel.roomState.isHeroTurn,
				activeColor: .orange,
				effectColor: viewModel.enemyEffectColor,
				didHit: viewModel.roomState.enemyWasHit
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
			actionButton(title: "Cut",
						 action: viewModel.cut)
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

// MARK: Effect Bar

struct EffectBar: View {

	var effects: [Effect]

	private var hasBuff: Bool { effects.contains { !$0.type.isDebuff } }
	private var hasDebuff: Bool { effects.contains { $0.type.isDebuff } }

	var body: some View {
		HStack(spacing: 4) {
			// Buff slot
			Image(systemName: "arrowtriangle.up")
				.foregroundColor(.cyan)
				.font(.system(size: 20))
				.opacity(hasBuff ? 1 : 0)            // always present, just invisible
				.frame(width: 20, height: 20)        // reserve exact size

			// Debuff slot
			Image(systemName: "arrowtriangle.down")
				.foregroundColor(.purple)
				.font(.system(size: 20))
				.opacity(hasDebuff ? 1 : 0)          // always present
				.frame(width: 20, height: 20)        // reserve exact size
		}
	}
}

// MARK: Special Effects For Hero/Enemy Tiles

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
