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
					viewModel.restoreCharacter(isHeroTurn: viewModel.roomUIState.isHeroTurn)
				}
			
			VStack {

				BorderedSection {
					characterStatsSection()
				}

				battleFieldSection()

				BorderedSection {
					menuButtons()
				}
				.opacity(0.8)
				.scaleEffect(0.8)

				sectionActionButtons()

				Spacer()
				actionButton(title: "End Turn",
							 action: viewModel.endTurn)
				.bold(true)
				.scaleEffect(1.2)
			}
			
		}
		
		// MARK: ENTRY POINT TO THE GAME
		.onAppear {
			viewModel.startFight()
		}
	}
}

// MARK: - Section Action Buttons
private extension RoomView {

	/// Builds the appropriate action buttons for the current UI section
	@ViewBuilder
	func sectionActionButtons() -> some View {

		switch viewModel.sceneUIStateManager.activeSection {

		case .skills:
			buildScreen(.skills)
		case .spellbook:
			buildScreen(.spellbook)
		case .equipment:
			EmptyView()
		default:
			EmptyView()
		}
	}
}
	
	// MARK: - Info Layer (Room & Round)

private extension RoomView {
	
	@ViewBuilder
	func gameInfoSection() -> some View {
		VStack {
			infoText(label: "Room:", value: viewModel.roomUIState.currentRoom)
			infoText(label: "Round:", value: viewModel.roomUIState.currentRound)
		}
		
	}
	
	func infoText(label: String, value: Int) -> some View {
		HStack {
			Text(label)
				.font(.title3)
				.foregroundColor(.white)

			Text("\(value)")
				.font(.title3)
				.foregroundColor(.white)
		}
	}

}
	
// MARK: - Character Stats Layer

private extension RoomView {
	
	@ViewBuilder
	func characterStatsSection() -> some View {
		HStack {
			
			// Hero
			Spacer()
			characterStats(name: "Hero",
						   level: "\(viewModel.heroUIState.heroCurrentLevel)",
						   currentExperience: CGFloat(viewModel.heroUIState.heroCurrentExperience),
						   maxExperience:
							CGFloat(viewModel.heroUIState.heroMaxExperience),
						   currentHealth: CGFloat(viewModel.heroUIState.heroCurrentHealth),
						   maxHealth:
							CGFloat(viewModel.heroUIState.heroMaxHealth),
						   maxMana: CGFloat(viewModel.heroUIState.heroMaxMana),
						   currentMana: CGFloat(viewModel.heroUIState.heroCurrentMana),
						   currentEnergy: viewModel.heroUIState.heroCurrentEnergy,
						   maxEnergy: viewModel.heroUIState.heroMaxEnergy,
						   effects: viewModel.heroUIState.heroActiveEffects)
			Spacer()
			gameInfoSection()
			Spacer()
			
			// Enemy
			characterStats(name: "Enemy",
						   level: "\(viewModel.enemyUIState.enemyCurrentLevel)",
						   currentExperience: 0,
						   maxExperience: 0,
						   currentHealth: CGFloat(viewModel.enemyUIState.enemyCurrentHealth),
						   maxHealth:
							CGFloat(viewModel.enemyUIState.enemyMaxHealth),
						   maxMana: CGFloat(viewModel.enemyUIState.enemyMaxMana), currentMana: CGFloat(viewModel.enemyUIState.enemyCurrentMana),
						   currentEnergy: viewModel.enemyUIState.enemyCurrentEnergy,
						   maxEnergy: viewModel.enemyUIState.enemyMaxEnergy,
						   effects: viewModel.enemyUIState.enemyActiveEffects)
			Spacer()
		}
	}
	
	func characterStats(name: String,
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
						.frame(width: 25, height: 25)
						.foregroundColor(.gray)
					Text(level)
						.font(.title2)
						.foregroundColor(.white)
				}
				.cornerRadius(20)
				Text(name)
					.font(.title2)
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
			StatusBar(effects: effects)
		}
	}
}
	
	// MARK: - Battle Field Layer

private extension RoomView {
	
	@ViewBuilder
	func battleFieldSection() -> some View {
		HStack {
			Spacer()
			CharacterTileView(
				baseColor: .black,
				label:    "H",
				effectLabel: "\(viewModel.heroUIState.heroActionLabel)",
				isActive: viewModel.roomUIState.isHeroTurn,
				activeColor: .yellow,
				effectColor: viewModel.sceneUIState.heroEffectColor,
				didHit: viewModel.roomUIState.heroWasHit,
				effectTextColor: viewModel.heroUIState.heroActionColor
			)
			Spacer()
			CharacterTileView(
				baseColor: .black,
				label:    "E",
				effectLabel: "\(viewModel.enemyUIState.enemyActionLabel)",
				isActive: !viewModel.roomUIState.isHeroTurn,
				activeColor: .red,
				effectColor: viewModel.sceneUIState.enemyEffectColor,
				didHit: viewModel.roomUIState.enemyWasHit,
				effectTextColor: viewModel.enemyUIState.enemyActionColor
			)
			Spacer()
		}
	}
	
	// MARK: - Menu Buttons Layer
	
	@ViewBuilder
	func menuButtons() -> some View {

		VStack {
			HStack {
				
				actionButton(title: "Skil",
							 action: viewModel.openSkills)
				actionButton(title: "Spel",
							 action: viewModel.openSpells)
				actionButton(title: "Inv",
							 action: viewModel.openInventory)
				actionButton(title: "Log",
							 action: viewModel.openLog)
				
			}
			
			HStack {
				actionButton(title: "Map",
							 action: viewModel.openMap)
				actionButton(title: "Stat",
							 action: viewModel.openStatus)
				actionButton(title: "Gear",
							 action: viewModel.openEquipment)
				actionButton(title: "Tals",
							 action: viewModel.openTalants)
			}
		}
	}

	// MARK: - Menu Screens

	@ViewBuilder
	func buildScreen(_ sceneUIState: SceneUISection) -> some View {

		switch sceneUIState {

		// Skill Set

		case .skills:

			VStack {

				HStack {
					Spacer()
					actionButton(title: "Attack",
								 action: viewModel.attack)
					actionButton(title: "Stun",
								 action: viewModel.stun)
					actionButton(title: "Bleed",
								 action: viewModel.cut)
					Spacer()
				}

				HStack {

					Spacer()
					actionButton(title: "Sunder",
								 action: viewModel.sunderArmor)
					actionButton(title: "Block",
								 action: viewModel.block)
					Spacer()
				}
			}

		// Spell Book

		case .spellbook:

			VStack {

				HStack {
					Spacer()
					actionButton(title: "HPReg",
								 action: viewModel.healthRegen)
					actionButton(title: "MPReg",
								 action: viewModel.manaRegen)
					actionButton(title: "Heal",
								 action: viewModel.heal)
					Spacer()
				}
				HStack {

					Spacer()
					actionButton(title: "EnDOWN",
								 action: viewModel.exhaustion)
					actionButton(title: "AtUP",
								 action: viewModel.buffAD)
					actionButton(title: "ArmUP",
								 action: viewModel.buffArmor)
					Spacer()
				}
			}

		default:
			infoText(label: "Unknown Screen", value: 911)
		}
	}


	// MARK: Action Button View

	func actionButton(title: String, action: @escaping () -> Void) -> some View {
		Button(title, action: action)
			.buttonStyle(.bordered)
			.font(.title2)
			.foregroundColor(.white)
	}
}

// MARK: - ContentView Previews

struct ContentView_Previews: PreviewProvider {
	static var previews: some View {
		let gameState = RoomGameState()
		let combatManager = CombatManager()
		let characterManager = CharacterManager()
		let effectManager = EffectManager()
		let sceneUIStateManager = SceneUIStateManager()
		let viewModel = RoomViewModel(gameState: gameState,
									  combatManager: combatManager,
									  characterManager: characterManager,
									  effectManager: effectManager,
									  sceneUIStateManager: sceneUIStateManager)

		RoomView(viewModel: viewModel)
	}
}
