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
					viewModel.restoreCharacter(isHeroTurn: viewModel.roomState.isHeroTurn)
				}

			VStack {
				BorderedSection {
					gameInfoSection()
				}
				BorderedSection {
					characterStatsSection()
				}
					battleFieldSection()
				BorderedSection {
					// another actionButtons
				}
					actionButtons()
				actionButton(title: "End Turn",
							 action: viewModel.endTurn)
				.bold(true)
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

	// MARK: - Character Stats Layer

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
						   currentEnergy: viewModel.heroState.heroCurrentEnergy,
						   maxEnergy: viewModel.heroState.heroMaxEnergy,
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
						   currentEnergy: viewModel.enemyState.enemyCurrentEnergy,
						   maxEnergy: viewModel.enemyState.enemyMaxEnergy,
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
								currentEnergy: Int,
								maxEnergy: Int,
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
			EnergyBar(currentEnergy: currentEnergy,
					  maxEnergy: maxEnergy)
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
				effectLabel: "\(viewModel.heroState.heroActionLabel)",
				isActive: viewModel.roomState.isHeroTurn,
				activeColor: .white,
				effectColor: viewModel.heroEffectColor,
				didHit: viewModel.roomState.heroWasHit,
				effectTextColor: viewModel.heroState.heroActionColor
			)
			Spacer()
			CharacterTileView(
				baseColor: .black,
				label:    "E",
				effectLabel: "\(viewModel.enemyState.enemyActionLabel)",
				isActive: !viewModel.roomState.isHeroTurn,
				activeColor: .red,
				effectColor: viewModel.enemyEffectColor,
				didHit: viewModel.roomState.enemyWasHit,
				effectTextColor: viewModel.enemyState.enemyActionColor
			)
			Spacer()
		}
	}

	// MARK: - Menu Buttons Layer

	@ViewBuilder
	private func menuButtons() -> some View {

		HStack {

			Spacer()
			actionButton(title: "Skills",
						 action: viewModel.attack)
			actionButton(title: "Heal",
						 action: viewModel.heal)
			actionButton(title: "Bleed",
						 action: viewModel.cut)
			actionButton(title: "EnDOWN",
						 action: viewModel.exhaustion)
			Spacer()
		}

	}

	// MARK: - Action Buttons Layer

	@ViewBuilder
	private func actionButtons() -> some View {

		HStack {

			Spacer()
			actionButton(title: "Attack",
						 action: viewModel.attack)
			actionButton(title: "Heal",
						 action: viewModel.heal)
			actionButton(title: "Bleed",
						 action: viewModel.cut)
			actionButton(title: "EnDOWN",
						 action: viewModel.exhaustion)
			Spacer()
		}

		HStack {

			Spacer()
			actionButton(title: "HPReg",
						 action: viewModel.healthRegen)
			actionButton(title: "MPReg",
						 action: viewModel.manaRegen)
			Spacer()
		}

		HStack {

			Spacer()
			actionButton(title: "Block",
						 action: viewModel.block)
			actionButton(title: "AtUP",
						 action: viewModel.buffAD)
			actionButton(title: "ArmUP",
						 action: viewModel.buffArmor)
			actionButton(title: "Stun",
						 action: viewModel.stun)
			Spacer()
		}
	}

	// MARK: Action Button View

	private func actionButton(title: String, action: @escaping () -> Void) -> some View {
		Button(title, action: action)
			.buttonStyle(.bordered)
			.font(.title2)
			.foregroundColor(.white)
	}
}

// MARK: Experience Bar View

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

// MARK: Health Bar View

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

// MARK: Mana Bar View

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

// MARK: Energy Bar View

struct EnergyBar: View {
	var currentEnergy: Int // Value between 1 and 5
	var maxEnergy: Int

	var body: some View {
		HStack {
			ForEach(0..<maxEnergy, id: \.self) { index in
				Rectangle()
					.frame(width: 15, height: 20)
					.foregroundColor(index < currentEnergy ? .yellow : .gray) // Filled or empty
			}
		}
	}
}

// MARK: Effect Bar View

struct EffectBar: View {

	var effects: [Effect]

	private var hasBuff: Bool { effects.contains { !$0.type.isDebuff } }
	private var hasDebuff: Bool { effects.contains { $0.type.isDebuff } }
	private var isStunned: Bool { effects.contains { $0.type == .stun } }

	var body: some View {
		HStack(spacing: 4) {
			// Buff slot
			Image(systemName: "arrow.up")
				.foregroundColor(.cyan)
				.font(.system(size: 20))
				.opacity(hasBuff ? 1 : 0)            // always present, just invisible
				.frame(width: 20, height: 20)        // reserve exact size

			// Debuff slot
			Image(systemName: "arrow.down")
				.foregroundColor(.red)
				.font(.system(size: 20))
				.opacity(hasDebuff ? 1 : 0)          // always present
				.frame(width: 20, height: 20)        // reserve exact size

			// Stun slot
			Image(systemName: "zzz")
				.foregroundColor(.purple)
				.font(.system(size: 20))
				.opacity(isStunned ? 1 : 0)
				.frame(width: 20, height: 20)
		}
	}
}

// MARK: Special Effects For Hero/Enemy Tiles

struct CharacterTileView: View {
	let baseColor: Color
	let label: String
	let effectLabel: String        // The number or text to show ("3", "10", etc.)
	let isActive: Bool
	let activeColor: Color
	let effectColor: Color?
	let didHit: Bool
	let effectTextColor: Color?    // New: color of the label (red, green, etc.)

	@State private var pulse = false
	@State private var internalEffect: Color? = nil
	@State private var shaking = false
	@State private var showEffectLabel = false  // New: controls label visibility

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

			// Main character label (e.g., "H", "E")
			Text(label)
				.font(.title)
				.foregroundColor(.white)

			// New: Effect text overlay (e.g. "3", "10")
			if showEffectLabel && !effectLabel.isEmpty {
				Text(effectLabel)
					.font(.title2)
					.bold()
					.foregroundColor(effectTextColor ?? .white)
					.offset(y: -30) // Appears above the square
					.transition(.opacity)
			}
		}
		.frame(width: 130, height: 130)
		.onChange(of: effectColor) { newColor in
			internalEffect = newColor
		}
		.onChange(of: didHit) { hit in
			if hit {
				animateHit()
			}
		}
		.onChange(of: effectLabel) { _ in
			showEffectLabel = true
			DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
				showEffectLabel = false
			}
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

// MARK: Border Section

struct BorderedSection<Content: View>: View {
	let content: Content

	init(@ViewBuilder content: () -> Content) {
		self.content = content()
	}

	var body: some View {
		content
			.padding()
			.background(Color.black)
			.overlay(
				RoundedRectangle(cornerRadius: 8)
					.stroke(Color.gray, lineWidth: 2)
			)
			.padding(.horizontal, 16)
			.padding(.vertical, 4)
	}
}

// MARK: - ContentView Previews

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		let gameState = GameState()
		let combatManager = CombatManager()
		let characterManager = CharacterManager()
		let effectManager = EffectManager()
		let viewModel = RoomViewModel(gameState: gameState,
									  combatManager: combatManager,
									  characterManager: characterManager,
									  effectManager: effectManager)

		RoomView(viewModel: viewModel)
	}
}
