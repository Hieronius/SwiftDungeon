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

					// place to extra action by multiple tapping of the screen
				}

			// Animation to play when enter new room

			if viewModel.roomUIState.isEnteredNewRoom {
				Text("Entered New Room")
					.font(.title2)
			}

			HighlightBorders(animate: viewModel.roomUIState.isEnteredNewRoom)

			// Label to display of which turn is right now

			if !viewModel.roomUIState.isEnteredNewRoom {

				if viewModel.roomUIState.isHeroTurn{
					Text("Hero Turn")
						.opacity(0.5)
				} else {
					Text("Enemy Turn")
						.opacity(0.5)
				}
			}

			VStack {

				BorderedSection {
					characterStatsSection()
				}
				Spacer()

				battleFieldSection()

				Spacer()
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
		.navigationBarBackButtonHidden(true)
		
		// MARK: ENTRY POINT OF THE GAME

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

			actionButton(title: "Menu") {
				viewModel.popScreen()
			}
			.opacity(0.8)
			.scaleEffect(0.8)

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
			characterStats(

				name: "Hero",
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
				effects: viewModel.heroUIState.heroActiveEffects
			)
			Spacer()
			gameInfoSection()
			Spacer()
			
			// Enemy
			characterStats(

				name: "Enemy",
				level: "\(viewModel.enemyUIState.enemyCurrentLevel)",
				currentExperience: 0,
				maxExperience: 0,
				currentHealth: CGFloat(viewModel.enemyUIState.enemyCurrentHealth),
				maxHealth:
					CGFloat(viewModel.enemyUIState.enemyMaxHealth),
				maxMana: CGFloat(viewModel.enemyUIState.enemyMaxMana), currentMana: CGFloat(viewModel.enemyUIState.enemyCurrentMana),
				currentEnergy: viewModel.enemyUIState.enemyCurrentEnergy,
				maxEnergy: viewModel.enemyUIState.enemyMaxEnergy,
				effects: viewModel.enemyUIState.enemyActiveEffects
			)
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
						.frame(width: 20, height: 20)
						.foregroundColor(.gray)
					Text(level)
						.font(.title3)
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
				impactLabel: "\(viewModel.heroUIState.heroActionLabel)",
				isActive: viewModel.roomUIState.isHeroTurn,
				activeColor: .yellow,
				effectColor: viewModel.sceneUIState.heroEffectColor,
				didHit: viewModel.roomUIState.heroWasHit,
				impactTextColor: viewModel.heroUIState.heroActionColor
			)
			Spacer()
			CharacterTileView(
				baseColor: .black,
				label:    "E",
				impactLabel: "\(viewModel.enemyUIState.enemyActionLabel)",
				isActive: !viewModel.roomUIState.isHeroTurn,
				activeColor: .red,
				effectColor: viewModel.sceneUIState.enemyEffectColor,
				didHit: viewModel.roomUIState.enemyWasHit,
				impactTextColor: viewModel.enemyUIState.enemyActionColor
			)
			Spacer()
		}
	}
	
	// MARK: - Menu Buttons Layer
	
	@ViewBuilder
	func menuButtons() -> some View {

		VStack {
			HStack {
//				Spacer()
				actionButton(title: "Skill",
							 action: viewModel.openSkills)
				actionButton(title: "Spell",
							 action: viewModel.openSpells)
				actionButton(title: "Inv",
							 action: viewModel.openInventory)
				actionButton(title: "Log",
							 action: viewModel.openLog)
//				Spacer()
				
			}
			
			HStack {
//				Spacer()
				actionButton(title: "Map",
							 action: viewModel.openMap)
				actionButton(title: "Stat",
							 action: viewModel.openStatus)
				actionButton(title: "Gear",
							 action: viewModel.openEquipment)
				actionButton(title: "Perc",
							 action: viewModel.openTalants)
//				Spacer()
			}
		}
	}

	// MARK: - Menu Screens

	@ViewBuilder
	func buildScreen(_ sceneUIState: SceneUISection) -> some View {

			switch sceneUIState {

				// MARK: Skill Set

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

					HStack {
						Spacer()
						actionButton(title: "Attack Stance",
									 action: viewModel.attackStance)
						actionButton(title: "Defence Stance",
									 action: viewModel.defenceStance)

						Spacer()
					}
				}

				// MARK: Spell Book

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

					HStack {

						Spacer()
						actionButton(title: "DoT",
									 action: viewModel.dot)
						actionButton(title: "Fireball",
									 action: viewModel.fireball)
						actionButton(title: "Exhaustion",
									 action: viewModel.exhaustion)
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

// MARK: Fixed sized container

struct FixedSizeContainer<Content: View>: View {
	
	let width: CGFloat
	let height: CGFloat
	let content: Content

	init(width: CGFloat, height: CGFloat, @ViewBuilder content: () -> Content) {
		self.width = width
		self.height = height
		self.content = content()
	}

	var body: some View {
		content
			.frame(width: width, height: height)
			.overlay(
				RoundedRectangle(cornerRadius: 8)
					.stroke(Color.gray, lineWidth: 1)
			)
	}
}
