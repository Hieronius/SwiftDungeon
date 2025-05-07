import SwiftUI

class RoomViewModel: ObservableObject {

	// MARK: - Dependencies

	// call in view - viewModel.sceneManager.open(.skills/spells)
	let sceneUIStateManager: SceneUIStateManager
	private let roomGameState: RoomGameState
	private let combatManager: ActionCalculator
	private let characterManager: CharacterManager
	private let effectManager: EffectManager

	// MARK: - Published Properties

	@Published var roomUIState: RoomUIState
	@Published var heroUIState: HeroUIState
	@Published var enemyUIState: EnemyUIState
	@Published var sceneUIState: SceneUIState

	// MARK: - Initialization

	init(gameState: RoomGameState,
		 combatManager: ActionCalculator,
		 characterManager: CharacterManager,
		 effectManager: EffectManager,
		 sceneUIStateManager: SceneUIStateManager) {

		self.roomGameState = gameState
		self.combatManager = combatManager
		self.characterManager = characterManager
		self.effectManager = effectManager
		self.sceneUIStateManager = sceneUIStateManager

		self.roomUIState = RoomUIState()
		self.sceneUIState = SceneUIState()

		self.heroUIState = HeroUIState(
			heroCurrentLevel: gameState.hero?.stats.level ?? 0,
			heroMaxHealth: gameState.hero?.maxHealth ?? 0,
			heroCurrentHealth: gameState.hero?.currentHealth ?? 0,
			heroMaxMana: gameState.hero?.maxMana ?? 0,
			heroCurrentMana: gameState.hero?.currentMana ?? 0,
			heroMaxEnergy: gameState.hero?.maxEnergy ?? 0,
			heroCurrentEnergy: gameState.hero?.currentEnergy ?? 0,
			heroCurrentExperience: gameState.hero?.stats.currentExperience ?? 0,
			heroMaxExperience: gameState.hero?.stats.maxExperience ?? 0,
			heroActionColor: .white,
			heroActionLabel: 99,
			heroActiveEffects: gameState.hero?.activeEffects ?? []
		)

		self.enemyUIState = EnemyUIState(
			enemyCurrentLevel: gameState.enemy?.stats.level ?? 0,
			enemyMaxHealth: gameState.enemy?.maxHealth ?? 0,
			enemyCurrentHealth: gameState.enemy?.currentHealth ?? 0,
			enemyMaxMana: gameState.enemy?.maxMana ?? 0,
			enemyCurrentMana: gameState.enemy?.currentMana ?? 0,
			enemyMaxEnergy: gameState.enemy?.maxEnergy ?? 0,
			enemyCurrentEnergy: gameState.enemy?.currentEnergy ?? 0,
			enemyActionColor: .white,
			enemyActionLabel: 100,
			enemyActiveEffects: gameState.enemy?.activeEffects ?? []
		)
	}
}

// MARK: - Sync Game State

extension RoomViewModel {

	func update() {

		syncGameState()
		checkWinLoseCondition()

		if roomGameState.isHeroTurn {
				// Wait for player input
				print("Waiting for player move...")
			} else {
				// performEnemyTurn()
			}
	}

	func syncGameState() {

		// Save/Load function can be implemented here

		roomUIState = RoomUIState(
			currentRoom: roomGameState.currentRoom,
			currentRound: roomGameState.currentRound,
			isHeroTurn: roomGameState.isHeroTurn,
			heroWasHit: roomUIState.heroWasHit,
			enemyWasHit: roomUIState.enemyWasHit
		)

		guard let hero = roomGameState.hero else { return }
		guard let enemy = roomGameState.enemy else { return }

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

// MARK: - Game Options

extension RoomViewModel {

	func pauseGame() {
		roomGameState.isGameOn = false
	}

	func resumeGame() {
		roomGameState.isGameOn = true
	}
}

// MARK: - Game Flow States

extension RoomViewModel {

	func startFight() {

		roomGameState.isGameOn = true
		roomGameState.isHeroTurn = true
		roomGameState.isHeroWon = false
		roomGameState.isGameOver = false
		roomGameState.currentRound = 1
		roomGameState.hero = characterManager.setupHero()
		roomGameState.enemyIndex = 0
		let position = roomGameState.enemyIndex
		roomGameState.enemy = characterManager.spawnEnemy(at: position)

		syncGameState()
	}

	func endTurn() {

		guard roomGameState.isGameOn else { return }

		if !roomGameState.isHeroTurn {

			roomGameState.currentRound += 1
			guard let hero = roomGameState.hero else { return }
			hero.currentEnergy = hero.maxEnergy

			effectManager.processEffectsAtTurnStart(hero)

			if hero.isStunned {

				DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {

					self.roomGameState.isHeroTurn.toggle()
					self.checkWinLoseCondition()

					self.syncGameState()
					self.endTurn()
				}

			} else {

				roomGameState.isHeroTurn.toggle()
				checkWinLoseCondition()

				syncGameState()
			}

		} else if roomGameState.isHeroTurn {

			guard let enemy = roomGameState.enemy else { return }
			enemy.currentEnergy = enemy.maxEnergy

			effectManager.processEffectsAtTurnStart(enemy)

			if enemy.isStunned {

				DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
					self.roomGameState.isHeroTurn.toggle()
					self.checkWinLoseCondition()

					self.syncGameState()
					self.endTurn()
				}

			} else {

				roomGameState.isHeroTurn.toggle()
				checkWinLoseCondition()

				syncGameState()
			}
		}

	}

	func checkWinLoseCondition() {

		guard let hero = roomGameState.hero else { return }
		guard let enemy = roomGameState.enemy else { return }

		if roomGameState.currentRoom > GameConfig.dungeonLength {
			roomGameState.isGameCompleted = true
			roomGameState.isGameOn = false
			return
		}

		if hero.currentHealth < 1 {
			roomGameState.isGameOn = false
			roomGameState.isGameOver = true
			startFight()

		} else if enemy.currentHealth < 1 {

			roomGameState.isGameOn = false
			roomGameState.isHeroWon = true
			let experience = roomUIState.currentRoom * GameConfig.expPerRoom
			if (heroUIState.heroCurrentExperience + experience) >= hero.stats.maxExperience {
				heroLevelUP()
			} else {
				hero.stats.currentExperience += experience
			}
			enterNewRoom()
		}

		syncGameState()
	}

	func enterNewRoom() {

		roomGameState.currentRoom += 1
		roomGameState.isGameOn = true
		roomGameState.isHeroTurn = true
		roomGameState.isHeroWon = false
		roomGameState.isGameOver = false
		roomGameState.currentRound = 1
		restoreCharacter(isHeroTurn: true)
		roomGameState.enemyIndex += 1
		let position = roomGameState.enemyIndex
		roomGameState.enemy = characterManager.spawnEnemy(at: position)

		syncGameState()
	}
}

// MARK: - Hero Updates

extension RoomViewModel {

	func heroLevelUP() {
		
		guard let hero = roomGameState.hero else { return }

		hero.stats.level += 1
		hero.stats.maxExperience += 100
		hero.stats.currentExperience = 1
		hero.stats.strength += 2
		hero.stats.agility += 2
		hero.stats.vitality += 2
		hero.stats.intellect += 1
		hero.maxHealth += 10
		hero.maxMana += 10
		hero.maxDamage += 1
		hero.minDamage += 1
		restoreCharacter(isHeroTurn: true)

		syncGameState()
	}

	func restoreCharacter(isHeroTurn: Bool) {

		let target = isHeroTurn ? roomGameState.hero : roomGameState.enemy
		guard let target else { return }
		target.currentHealth = target.maxHealth
		target.currentMana = target.maxMana
		target.currentEnergy = target.maxEnergy

		syncGameState()
	}
}

// MARK: - Fight Mechanics

extension RoomViewModel {

	func attack() {

		guard roomGameState.isGameOn else { return }
		guard let hero = roomGameState.hero else { return }
		guard let enemy = roomGameState.enemy else { return }

		if roomGameState.isHeroTurn {

			guard hero.currentEnergy >= GameConfig.attackEnergyCost else { return }
			let result = combatManager.attack(hero, enemy)
			enemy.currentHealth = max(enemy.currentHealth - result, 0)
			hero.currentEnergy -= GameConfig.attackEnergyCost
			passActionVisualResult(.red, result)
			triggerHit(onHero: false)

		} else {

			guard enemy.currentEnergy >= GameConfig.attackEnergyCost else { return }
			let result = combatManager.attack(enemy, hero)
			hero.currentHealth = max(hero.currentHealth - result, 0)
			enemy.currentEnergy -= GameConfig.attackEnergyCost
			passActionVisualResult(.red, result)
			triggerHit(onHero: true)

		}
		checkWinLoseCondition()

		syncGameState()
	}

	func block() {

		guard roomGameState.isGameOn else { return }

		let target = roomGameState.isHeroTurn ? roomGameState.hero : roomGameState.enemy
		guard let target else { return }
		guard target.currentEnergy >= GameConfig.blockEnergyCost else { return }

		let isHero = roomGameState.isHeroTurn
		triggerEffect(forHero: isHero, color: .blue)

		let blockValue = combatManager.block(target)
		let buff = Effect(type: .armorUP(value: blockValue), duration: 3)

		effectManager.applyEffect(buff, target)
		target.currentEnergy -= GameConfig.blockEnergyCost

		syncGameState()
	}

	func heal() {

		guard roomGameState.isGameOn else { return }

		let target = roomGameState.isHeroTurn ? roomGameState.hero : roomGameState.enemy
		guard let target else { return }
		guard target.currentEnergy >= GameConfig.spellEnergyCost,
			  target.currentMana >= GameConfig.healManaCost else {
			return
		}
		let isHero = roomGameState.isHeroTurn
		triggerEffect(forHero: isHero, color: .green)

		let result = combatManager.heal(target)
		target.currentHealth = min(target.currentHealth + result, target.maxHealth)
		target.currentMana -= GameConfig.healManaCost
		target.currentEnergy -= GameConfig.spellEnergyCost

		syncGameState()
	}

	func buffAD() {

		guard roomGameState.isGameOn else { return }

		let target = roomGameState.isHeroTurn ? roomGameState.hero : roomGameState.enemy
		guard let target else { return }
		guard target.currentEnergy >= GameConfig.spellEnergyCost,
			  target.currentMana >= GameConfig.buffManaCost else {
			return

		}

		let isHero = roomGameState.isHeroTurn
		triggerEffect(forHero: isHero, color: .yellow)

		let result = combatManager.attackUP(target)
		let buff = Effect(type: .attackUP(value: result), duration: 3)
		effectManager.applyEffect(buff, target)

		target.currentMana -= GameConfig.buffManaCost
		target.currentEnergy -= GameConfig.spellEnergyCost

		syncGameState()
	}

	func cut() {

		guard roomGameState.isGameOn else { return }
		guard let hero = roomGameState.hero else { return }
		guard let enemy = roomGameState.enemy else { return }

		if roomGameState.isHeroTurn {

			guard hero.currentEnergy >= GameConfig.cutEnergyCost else { return }
			hero.currentEnergy -= GameConfig.cutEnergyCost
			let result = combatManager.cut(hero, enemy)
			let debuff = Effect(type: .bleeding(initialDamage: result, damagePerTurn: result), duration: 3)
			effectManager.applyEffect(debuff, enemy)
			triggerHit(onHero: false)

		} else {

			guard enemy.currentEnergy >= GameConfig.cutEnergyCost else { return }
			enemy.currentEnergy -= GameConfig.cutEnergyCost
			let result = combatManager.cut(enemy, hero)
			let debuff = Effect(type: .bleeding(initialDamage: result, damagePerTurn: result), duration: 3)
			effectManager.applyEffect(debuff, hero)
			triggerHit(onHero: true)

		}
		checkWinLoseCondition()

		syncGameState()

	}

	func exhaustion() {

	}

	func healthRegen() {

	}

	func manaRegen() {

	}

	func buffArmor() {
		
	}

	func sunderArmor() {
		
	}

	func stun() {

		guard roomGameState.isGameOn else { return }
		guard let hero = roomGameState.hero else { return }
		guard let enemy = roomGameState.enemy else { return }

		if roomGameState.isHeroTurn {

			guard hero.currentEnergy >= GameConfig.stunEnergyCost else { return }
			hero.currentEnergy = max(hero.currentEnergy - GameConfig.stunEnergyCost, 0)

			let stunEffect = Effect(type: .stun, duration: GameConfig.stunDuration)
			effectManager.applyEffect(stunEffect, enemy)
			triggerHit(onHero: false)

		} else {

			guard enemy.currentEnergy >= GameConfig.cutEnergyCost else { return }
			enemy.currentEnergy = max(enemy.currentEnergy - GameConfig.stunEnergyCost, 0)

			let stunEffect = Effect(type: .stun, duration: GameConfig.stunDuration)
			effectManager.applyEffect(stunEffect, hero)
			triggerHit(onHero: true)

		}
		checkWinLoseCondition()

		syncGameState()
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

// MARK: - Helpers

extension RoomViewModel {

	private func triggerEffect(forHero: Bool, color: Color) {
		if forHero {
			sceneUIState.heroEffectColor = color
			DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
				if self.roomGameState.isHeroTurn { self.sceneUIState.heroEffectColor = nil }
			}
		} else {
			sceneUIState.enemyEffectColor = color
			DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
				if !self.roomGameState.isHeroTurn { self.sceneUIState.enemyEffectColor = nil }
			}
		}
	}

	// helper to trigger a 1s “hit” animation on the target
	private func triggerHit(onHero: Bool) {
		if onHero {
			roomUIState.heroWasHit = true
			DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
				self.roomUIState.heroWasHit = false
			}
		} else {
			roomUIState.enemyWasHit = true
			DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
				self.roomUIState.enemyWasHit = false
			}
		}
	}

	private func passActionVisualResult(_ color: Color, _ label: Int) {

		if roomGameState.isHeroTurn {
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
