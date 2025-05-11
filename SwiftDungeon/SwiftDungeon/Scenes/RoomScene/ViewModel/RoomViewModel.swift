import SwiftUI

class RoomViewModel: ObservableObject {

	// MARK: - Dependencies

	// call in view - viewModel.openInventory()
	let sceneUIStateManager: SceneUIStateManager
	let roomGameManager: RoomGameManager

	// MARK: - Published Properties

	@Published var roomUIState: RoomUIState
	@Published var heroUIState: HeroUIState
	@Published var enemyUIState: EnemyUIState
	@Published var sceneUIState: SceneUIState

	// MARK: - Initialization

	init(roomGameManager: RoomGameManager,
		 sceneUIStateManager: SceneUIStateManager) {

		self.roomGameManager = roomGameManager
		self.sceneUIStateManager = sceneUIStateManager

		self.roomUIState = RoomUIState()
		self.sceneUIState = SceneUIState()

		self.heroUIState = HeroUIState(
			heroCurrentLevel: roomGameManager.roomGameState.hero?.stats.level ?? 0,
			heroMaxHealth: roomGameManager.roomGameState.hero?.maxHealth ?? 0,
			heroCurrentHealth: roomGameManager.roomGameState.hero?.currentHealth ?? 0,
			heroMaxMana: roomGameManager.roomGameState.hero?.maxMana ?? 0,
			heroCurrentMana: roomGameManager.roomGameState.hero?.currentMana ?? 0,
			heroMaxEnergy: roomGameManager.roomGameState.hero?.maxEnergy ?? 0,
			heroCurrentEnergy: roomGameManager.roomGameState.hero?.currentEnergy ?? 0,
			heroCurrentExperience: roomGameManager.roomGameState.hero?.stats.currentExperience ?? 0,
			heroMaxExperience: roomGameManager.roomGameState.hero?.stats.maxExperience ?? 0,
			heroActionColor: .white,
			heroActionLabel: 99,
			heroActiveEffects: roomGameManager.roomGameState.hero?.activeEffects ?? []
		)

		self.enemyUIState = EnemyUIState(
			enemyCurrentLevel: roomGameManager.roomGameState.enemy?.stats.level ?? 0,
			enemyMaxHealth: roomGameManager.roomGameState.enemy?.maxHealth ?? 0,
			enemyCurrentHealth: roomGameManager.roomGameState.enemy?.currentHealth ?? 0,
			enemyMaxMana: roomGameManager.roomGameState.enemy?.maxMana ?? 0,
			enemyCurrentMana: roomGameManager.roomGameState.enemy?.currentMana ?? 0,
			enemyMaxEnergy: roomGameManager.roomGameState.enemy?.maxEnergy ?? 0,
			enemyCurrentEnergy: roomGameManager.roomGameState.enemy?.currentEnergy ?? 0,
			enemyActionColor: .white,
			enemyActionLabel: 100,
			enemyActiveEffects: roomGameManager.roomGameState.enemy?.activeEffects ?? []
		)

	}
}

// MARK: Methods to wrap and pass to View

extension RoomViewModel {

	func startFight() {

		roomGameManager.startFight()
		syncGameUIState()
	}
	
	func endTurn() {

		roomGameManager.endTurn()
		syncGameUIState()
	}
	
	func restoreCharacter(isHeroTurn: Bool) {

		// Refactor to remove arguments input in view model
//		roomGameManager.restoreCharacter(isHeroTurn: <#T##Bool#>)
	}

	func resetCharacterBeingHitAndSyncGameState() {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
			self.roomGameManager.resetCharacterBeingHit()
			self.syncGameUIState()
		}
	}

	// MARK: - Skills



	// MARK: Attack

	func attack() {
		roomGameManager.attack()
		getVisualImpactFromAction()
		syncGameUIState()
		resetCharacterBeingHitAndSyncGameState()
	}

	// MARK: Stun

	func stun() {
		roomGameManager.stun()
		getVisualImpactFromAction()
		syncGameUIState()
		resetCharacterBeingHitAndSyncGameState()
	}

	// MARK: Cut

	func cut() {
		roomGameManager.cut()
		getVisualImpactFromAction()
		let actionImpact = roomGameManager.actionImpactAndTarget()
		let currentTurn = actionImpact.0
		syncGameUIState()
		resetCharacterBeingHitAndSyncGameState()
	}

	// MARK: Sunder Armor

	func sunderArmor() {
		roomGameManager.sunderArmor()
		syncGameUIState()
		resetCharacterBeingHitAndSyncGameState()
	}

	// MARK: Block

	func block() {
		roomGameManager.block()
		let actionImpact = roomGameManager.actionImpactAndTarget()
		let currentTurn = actionImpact.0
		triggerEffect(forHero: currentTurn, color: .blue)
		syncGameUIState()
	}

	// MARK: Attack Stance

	func attackStance() {

	}

	// MARK: - Defence Stance

	func defenceStance() {

	}

	// MARK: - Spells



	// MARK: Heal

	func heal() {
		roomGameManager.heal()
		let actionImpact = roomGameManager.actionImpactAndTarget()
		let currentTurn = actionImpact.0
		triggerEffect(forHero: currentTurn, color: .green)
		syncGameUIState()
	}

	// MARK: Health Regen

	func healthRegen() {
		roomGameManager.healthRegen()
		syncGameUIState()
	}

	// MARK: Mana Regen

	func manaRegen() {
		roomGameManager.manaRegen()
		syncGameUIState()
	}

	// MARK: Exhausion

	func exhaustion() {
		roomGameManager.exhaustion()
		getVisualImpactFromAction()
		syncGameUIState()
		resetCharacterBeingHitAndSyncGameState()
	}

	// MARK: BuffAD

	func buffAD() {
		roomGameManager.buffAD()
		let actionImpact = roomGameManager.actionImpactAndTarget()
		let currentTurn = actionImpact.0
		triggerEffect(forHero: currentTurn, color: .yellow)
		syncGameUIState()

	}

	// MARK: BuffArmor

	func buffArmor() {

		roomGameManager.buffArmor()
		let actionImpact = roomGameManager.actionImpactAndTarget()
		let currentTurn = actionImpact.0
		triggerEffect(forHero: currentTurn, color: .yellow)
		syncGameUIState()
	}

	// MARK: FireBall

	func fireball() {

		roomGameManager.fireball()
		getVisualImpactFromAction()
		syncGameUIState()
		resetCharacterBeingHitAndSyncGameState()
	}

	// MARK: DoT

	func dot() {
		roomGameManager.dot()
		getVisualImpactFromAction()
		syncGameUIState()
		resetCharacterBeingHitAndSyncGameState()
	}
}

// MARK: Sync Room UI State

extension RoomViewModel {

	func syncGameUIState() {

		// Save/Load function can be implemented here

		// MARK: USING ROOMSTATEMANAGER FROM VIEW MODEL IS NOT RIGHT

		roomUIState = RoomUIState(
			currentRoom: roomGameManager.roomGameState.currentRoom,
			currentRound: roomGameManager.roomGameState.currentRound,
			isHeroTurn: roomGameManager.roomGameState.isHeroTurn,
			heroWasHit: roomGameManager.roomGameState.heroWasHit, // put to game state if no animation
			enemyWasHit: roomGameManager.roomGameState.enemyWasHit // put to game state if no animation
		)

		guard let hero = roomGameManager.roomGameState.hero else { return }
		guard let enemy = roomGameManager.roomGameState.enemy else { return }

		heroUIState = HeroUIState(
			heroCurrentLevel: hero.stats.level,
			heroMaxHealth: hero.maxHealth,
			heroCurrentHealth: hero.currentHealth,
			heroMaxMana: hero.maxMana,
			heroCurrentMana: hero.currentMana,
			heroMaxEnergy: hero.maxEnergy,
			heroCurrentEnergy: hero.currentEnergy,
			heroCurrentExperience: hero.stats.currentExperience,
			heroMaxExperience: hero.stats.maxExperience,
			heroActionColor: heroUIState.heroActionColor,
			heroActionLabel: heroUIState.heroActionLabel,
			heroActiveEffects: hero.activeEffects
		)

		enemyUIState = EnemyUIState(
			enemyCurrentLevel: enemy.stats.level,
			enemyMaxHealth: enemy.maxHealth,
			enemyCurrentHealth: enemy.currentHealth,
			enemyMaxMana: enemy.maxMana,
			enemyCurrentMana: enemy.currentMana,
			enemyMaxEnergy: enemy.maxEnergy,
			enemyCurrentEnergy: enemy.currentEnergy,
			enemyActionColor: enemyUIState.enemyActionColor,
			enemyActionLabel: enemyUIState.enemyActionLabel,
			enemyActiveEffects: enemy.activeEffects
		)

	}
}

// MARK: - Menu Scene State

extension RoomViewModel {

	func openSkills() {
		sceneUIStateManager.open(.skills)
		sceneUIState.uiState = .skills
		print(sceneUIStateManager.activeSection)
	}

	func openSpells() {
		sceneUIStateManager.open(.spellbook)
		sceneUIState.uiState = .spellbook
		print(sceneUIStateManager.activeSection)
	}

	func openLog() {
		sceneUIStateManager.open(.log)
	}

	func openStatus() {
		sceneUIStateManager.open(.status)
	}

	func openEquipment() {
		sceneUIStateManager.open(.equipment)
	}

	func openTalants() {
		sceneUIStateManager.open(.talants)
	}

	func openMap() {
		sceneUIStateManager.open(.map)
	}

	func openInventory() {
		sceneUIStateManager.open(.inventory)
	}
}

// MARK: - Visuals

extension RoomViewModel {

	// MARK: GetVisualImpactFromAction

	func getVisualImpactFromAction() {

		let actionResult: (Bool, Int) = roomGameManager.actionImpactAndTarget()
		let target = actionResult.0
		let impact = actionResult.1
		passActionVisualResult(target, impact)
	}

	// MARK: TriggerEffect

	/// Method used to add animation of the heal/block/buff abilities on the caster
	private func triggerEffect(forHero: Bool, color: Color) {

		if forHero {

			sceneUIState.heroEffectColor = color
			DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
				if self.roomGameManager.roomGameState.isHeroTurn { self.sceneUIState.heroEffectColor = nil }
			}

		} else {

			sceneUIState.enemyEffectColor = color
			DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
				if !self.roomGameManager.roomGameState.isHeroTurn { self.sceneUIState.enemyEffectColor = nil }
			}
		}
	}

	// MARK: PassActionVisualResult

	private func passActionVisualResult(_ target: Bool,
										_ label: Int) {

		let color: Color = .red

		if target {
			enemyUIState.enemyActionColor = color
			enemyUIState.enemyActionLabel = label
		} else {
			heroUIState.heroActionColor = color
			heroUIState.heroActionLabel = label
		}

		DispatchQueue.main.asyncAfter(deadline: .now() + 0.29) {
			self.enemyUIState.enemyActionLabel = -100
			self.heroUIState.heroActionLabel = -100
		}
	}
}
