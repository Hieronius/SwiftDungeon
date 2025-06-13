import SwiftUI

/// `ViewModel` of the Room Module
///
/// Connects an actial Room logic `RoomGameManager` and `UI`
final class RoomViewModel: ObservableObject {

	// MARK: - Dependencies

	/// An entity to control an entire Room encounter (turn, enemies, effects and such)
	let roomGameManager: RoomGameManager

	/// Manager to control navigation flow
	let navigationManager: NavigationManager

	/// Room - dedicated manager to control UI state with in the screen
	let sceneUIStateManager: SceneUIStateManager

	// MARK: - Published Properties

	@Published var roomUIState: RoomUIState
	@Published var heroUIState: HeroUIState
	@Published var enemyUIState: EnemyUIState
	@Published var sceneUIState: SceneUIState

	// MARK: - Initialization

	init(roomGameManager: RoomGameManager,
		 navigationManager: NavigationManager,
		 sceneUIStateManager: SceneUIStateManager) {

		self.roomGameManager = roomGameManager
		self.navigationManager = navigationManager
		self.sceneUIStateManager = sceneUIStateManager
		
		self.roomUIState = RoomUIState()
		self.sceneUIState = SceneUIState()

		// MARK: Apply getLastestGameStateSnapshot method instead

		let snapshot = roomGameManager.roomGameState.getActualGameStateSnapshot()

		self.heroUIState = HeroUIState(
			heroCurrentLevel: snapshot.hero?.stats.level ?? 0,
			heroMaxHealth: snapshot.hero?.maxHealth ?? 0,
			heroCurrentHealth: snapshot.hero?.currentHealth ?? 0,
			heroMaxMana: snapshot.hero?.maxMana ?? 0,
			heroCurrentMana: snapshot.hero?.currentMana ?? 0,
			heroMaxEnergy: snapshot.hero?.maxEnergy ?? 0,
			heroCurrentEnergy: snapshot.hero?.currentEnergy ?? 0,
			heroCurrentExperience: snapshot.hero?.stats.currentExperience ?? 0,
			heroMaxExperience: snapshot.hero?.stats.maxExperience ?? 0,
			heroActionColor: .white,
			heroActionLabel: 0,
			heroBeingHit: false,
			heroActiveEffects: snapshot.hero?.activeEffects ?? []
		)

		self.enemyUIState = EnemyUIState(
			enemyCurrentLevel: snapshot.enemy?.stats.level ?? 0,
			enemyMaxHealth: snapshot.enemy?.maxHealth ?? 0,
			enemyCurrentHealth: snapshot.enemy?.currentHealth ?? 0,
			enemyMaxMana: snapshot.enemy?.maxMana ?? 0,
			enemyCurrentMana: snapshot.enemy?.currentMana ?? 0,
			enemyMaxEnergy: snapshot.enemy?.maxEnergy ?? 0,
			enemyCurrentEnergy: snapshot.enemy?.currentEnergy ?? 0,
			enemyActionColor: .white,
			enemyActionLabel: 0,
			enemyBeingHit: false,
			enemyActiveEffects: snapshot.enemy?.activeEffects ?? []
		)

	}
}

// MARK: - Methods



// MARK: - Navigation

extension RoomViewModel {

	// MARK: PopScreen

	func popScreen() {
		navigationManager.pop()
	}

	// MARK: JumpToDungeon

	func jumpToDungeon() {
		popScreen()
		navigationManager.push(.dungeon)
	}
}

// MARK: - Room Game Logic

extension RoomViewModel {

	// MARK: Start Fight

	func startFight() {

		roomGameManager.startFight()
		syncGameUIState()
	}

	// MARK: End Turn
	
	func endTurn() {

		roomGameManager.endTurn()
		syncGameUIState()
	}

	// MARK: Reset isEnteredNewRoom property

	func resetIsEnteredNewRoom() {
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
			self.roomGameManager.resetIsEnteredNewRoom()
			self.syncGameUIState()
		}
	}

	// MARK: Reset characterBeingHit property

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
		getVisualImpactFromAction(color: .red)
		syncGameUIState()
		resetCharacterBeingHitAndSyncGameState()
	}

	// MARK: Stun

	func stun() {
		roomGameManager.stun()
		getVisualImpactFromAction(color: .purple)
		syncGameUIState()
		resetCharacterBeingHitAndSyncGameState()
	}

	// MARK: Cut

	func cut() {
		roomGameManager.cut()
		getVisualImpactFromAction(color: .red)
		let actionImpact = roomGameManager.actionImpactAndTarget()
		let currentTurn = actionImpact.0
		syncGameUIState()
		resetCharacterBeingHitAndSyncGameState()
	}

	// MARK: Sunder Armor

	func sunderArmor() {
		roomGameManager.sunderArmor()
		getVisualImpactFromAction(color: .purple)
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

	// MARK: Defence Stance

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
		let actionImpact = roomGameManager.actionImpactAndTarget()
		let currentTurn = actionImpact.0
		triggerEffect(forHero: currentTurn, color: .green)
		syncGameUIState()
	}

	// MARK: Mana Regen

	func manaRegen() {
		roomGameManager.manaRegen()
		let actionImpact = roomGameManager.actionImpactAndTarget()
		let currentTurn = actionImpact.0
		triggerEffect(forHero: currentTurn, color: .blue)
		syncGameUIState()
	}

	// MARK: Exhausion

	func exhaustion() {
		roomGameManager.exhaustion()
		getVisualImpactFromAction(color: .purple)
		syncGameUIState()
		resetCharacterBeingHitAndSyncGameState()
	}

	// MARK: BuffAD

	func buffAD() {
		roomGameManager.attackUP()
		let actionImpact = roomGameManager.actionImpactAndTarget()
		let currentTurn = actionImpact.0
		triggerEffect(forHero: currentTurn, color: .yellow)
		syncGameUIState()

	}

	// MARK: BuffArmor

	func buffArmor() {

		roomGameManager.armorUP()
		let actionImpact = roomGameManager.actionImpactAndTarget()
		let currentTurn = actionImpact.0
		triggerEffect(forHero: currentTurn, color: .yellow)
		syncGameUIState()
	}

	// MARK: FireBall

	func fireball() {

		roomGameManager.fireball()
		getVisualImpactFromAction(color: .purple)
		syncGameUIState()
		resetCharacterBeingHitAndSyncGameState()
	}

	// MARK: DoT

	func dot() {
		roomGameManager.dot()
		getVisualImpactFromAction(color: .purple)
		syncGameUIState()
		resetCharacterBeingHitAndSyncGameState()
	}
}

// MARK: Sync Room UI State

extension RoomViewModel {

	func syncGameUIState() {

		// Save/Load function can be implemented here

		// MARK: USING ROOMSTATEMANAGER FROM VIEW MODEL IS NOT RIGHT

		let snapshot = roomGameManager.roomGameState.getActualGameStateSnapshot()

		roomUIState = RoomUIState(
			currentRoom: snapshot.currentRoom,
			currentRound: snapshot.currentRound,
			isEnteredNewRoom: snapshot.isEnteredNewRoom,
			isHeroTurn: snapshot.isHeroTurn,
			heroWasHit: snapshot.heroWasHit, // put to game state if no animation
			enemyWasHit: snapshot.enemyWasHit // put to game state if no animation
		)

		guard let hero = snapshot.hero else { return }
		guard let enemy = snapshot.enemy else { return }

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
			heroBeingHit: heroUIState.heroBeingHit,
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
			enemyBeingHit: enemyUIState.enemyBeingHit,
			enemyActiveEffects: enemy.activeEffects
		)

	}
}

// MARK: - Menu Scene State

extension RoomViewModel {

	func openSkills() {
		sceneUIStateManager.open(.skills)
		sceneUIState.uiState = .skills
	}

	func openSpells() {
		sceneUIStateManager.open(.spellbook)
		sceneUIState.uiState = .spellbook
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

	/// Method to display a specific number of impact on the target such as attack/spell/effect damage done
	func getVisualImpactFromAction(color: Color) {

		let actionResult: (Bool, Int) = roomGameManager.actionImpactAndTarget()
		let target = actionResult.0
		let impact = actionResult.1
		passActionVisualResult(target, impact, color)
	}

	// MARK: TriggerEffect

	/// Method used to add animation of the heal/block/buff abilities on the caster (by paining the whole square with a specific color green/yellow/blue
	private func triggerEffect(forHero: Bool, color: Color) {

		// MARK: Should be refactored by using gameState.getSnapshot()

		if forHero {
			sceneUIState.heroEffectColor = color
			DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
				if self.roomGameManager.roomGameState.roomGameStateSnapshot.isHeroTurn { self.sceneUIState.heroEffectColor = nil }
			}

		} else {
			sceneUIState.enemyEffectColor = color
			DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
				if !self.roomGameManager.roomGameState.roomGameStateSnapshot.isHeroTurn { self.sceneUIState.enemyEffectColor = nil }
			}
		}
	}

	// MARK: PassActionVisualResult

	/// Specific method to update UI accordingly to type of the action been made
	private func passActionVisualResult(_ target: Bool,
										_ label: Int,
										_ color: Color) {

		if target {
			enemyUIState.enemyActionColor = color
			enemyUIState.enemyActionLabel = label
		} else {
			heroUIState.heroActionColor = color
			heroUIState.heroActionLabel = label
		}

	}
}
