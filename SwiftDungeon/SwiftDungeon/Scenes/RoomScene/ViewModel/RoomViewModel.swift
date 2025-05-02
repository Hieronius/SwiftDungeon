import SwiftUI

class RoomViewModel: ObservableObject {

	// MARK: - Dependencies

	private let gameState: GameState
	private let combatManager: CombatManager
	private let characterManager: CharacterManager

	// MARK: - Published Properties

	@Published var roomState: RoomState
	@Published var heroState: HeroState
	@Published var enemyState: EnemyState

	// Utility

	@Published var heroEffectColor: Color? = nil
	@Published var enemyEffectColor: Color? = nil

	// MARK: - Initialization

	init(gameState: GameState,
		 combatManager: CombatManager,
		 characterManager: CharacterManager) {

		self.gameState = gameState
		self.combatManager = combatManager
		self.characterManager = characterManager

		self.roomState = RoomState()

		self.heroState = HeroState(
			heroCurrentLevel: gameState.hero?.stats.level ?? 0,
			heroMaxHealth: gameState.hero?.maxHealth ?? 0,
			heroCurrentHealth: gameState.hero?.currentHealth ?? 0,
			heroMaxMana: gameState.hero?.maxMana ?? 0,
			heroCurrentMana: gameState.hero?.currentMana ?? 0,
			heroMaxEnergy: gameState.hero?.maxEnergy ?? 0,
			heroCurrentEnergy: gameState.hero?.currentEnergy ?? 0,
			heroCurrentExperience: gameState.hero?.stats.currentExperience ?? 0,
			heroMaxExperience: gameState.hero?.stats.maxExperience ?? 0,
			heroActiveEffects: gameState.hero?.activeEffects ?? []
		)

		self.enemyState = EnemyState(
			enemyCurrentLevel: gameState.enemy?.stats.level ?? 0,
			enemyMaxHealth: gameState.enemy?.maxHealth ?? 0,
			enemyCurrentHealth: gameState.enemy?.currentHealth ?? 0,
			enemyMaxMana: gameState.enemy?.maxMana ?? 0,
			enemyCurrentMana: gameState.enemy?.currentMana ?? 0,
			enemyMaxEnergy: gameState.enemy?.maxEnergy ?? 0,
			enemyCurrentEnergy: gameState.enemy?.currentEnergy ?? 0,
			enemyActiveEffects: gameState.enemy?.activeEffects ?? []
		)
	}

	// MARK: Sync Game State

	func syncGameState() {

		// Save/Load function can be implemented here

		roomState = RoomState(
			currentRoom: gameState.currentRoom,
			currentRound: gameState.currentRound,
			isHeroTurn: gameState.isHeroTurn,
			heroWasHit: roomState.heroWasHit,
			enemyWasHit: roomState.enemyWasHit
		)

		guard let hero = gameState.hero else { return }
		guard let enemy = gameState.enemy else { return }

		heroState = HeroState(
			heroCurrentLevel: hero.stats.level,
			heroMaxHealth: hero.maxHealth,
			heroCurrentHealth: hero.currentHealth,
			heroMaxMana: hero.maxMana,
			heroCurrentMana: hero.currentMana,
			heroMaxEnergy: hero.maxEnergy,
			heroCurrentEnergy: hero.currentEnergy,
			heroCurrentExperience: hero.stats.currentExperience,
			heroMaxExperience: hero.stats.maxExperience,
			heroActiveEffects: hero.activeEffects
		)

		enemyState = EnemyState(
			enemyCurrentLevel: enemy.stats.level,
			enemyMaxHealth: enemy.maxHealth,
			enemyCurrentHealth: enemy.currentHealth,
			enemyMaxMana: enemy.maxMana,
			enemyCurrentMana: enemy.currentMana,
			enemyMaxEnergy: enemy.maxEnergy,
			enemyCurrentEnergy: enemy.currentEnergy,
			enemyActiveEffects: enemy.activeEffects
		)
	}

	// MARK: - Game Flow States

	func pauseGame() {
		gameState.isGameOn = false
	}

	func resumeGame() {
		gameState.isGameOn = true
	}

	func startFight() {

		gameState.isGameOn = true
		gameState.isHeroTurn = true
		gameState.isHeroWon = false
		gameState.isGameOver = false
		gameState.currentRound = 1
		gameState.hero = characterManager.setupHero()
		gameState.enemyIndex = 0
		let position = gameState.enemyIndex
		gameState.enemy = characterManager.spawnEnemy(at: position)

		syncGameState()
	}

	func endTurn() {

		guard gameState.isGameOn else { return }

		if !gameState.isHeroTurn {

			gameState.currentRound += 1
			guard let hero = gameState.hero else { return }
			hero.currentEnergy = hero.maxEnergy

			hero.clearAllEffects()

		} else if gameState.isHeroTurn {

			guard let enemy = gameState.enemy else { return }
			enemy.currentEnergy = enemy.maxEnergy

			enemy.clearAllEffects()
		}
		gameState.isHeroTurn.toggle()

		syncGameState()

	}

	func checkWinLoseCondition() {

		guard let hero = gameState.hero else { return }
		guard let enemy = gameState.enemy else { return }

		if gameState.currentRoom > 14 {
			gameState.isGameCompleted = true
			gameState.isGameOn = false
			return
		}

		if hero.currentHealth < 1 {
			gameState.isGameOn = false
			gameState.isGameOver = true
			startFight()

		} else if enemy.currentHealth < 1 {

			gameState.isGameOn = false
			gameState.isHeroWon = true
			let experience = roomState.currentRoom * 50
			if (heroState.heroCurrentExperience + experience) >= hero.stats.maxExperience {
				heroLevelUP()
			} else {
				hero.stats.currentExperience += experience
			}
			enterNewRoom()
		}

		syncGameState()
	}

	func heroLevelUP() {

		guard let hero = gameState.hero else { return }

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
		restoreHero()

		syncGameState()
	}

	func restoreHero() {

		guard let hero = gameState.hero else { return }
		hero.currentHealth = hero.maxHealth
		hero.currentMana = hero.maxMana
		hero.currentEnergy = hero.maxEnergy

		syncGameState()
	}

	func enterNewRoom() {

		gameState.currentRoom += 1
		gameState.isGameOn = true
		gameState.isHeroTurn = true
		gameState.isHeroWon = false
		gameState.isGameOver = false
		gameState.currentRound = 1
		restoreHero()
		gameState.enemyIndex += 1
		let position = gameState.enemyIndex
		gameState.enemy = characterManager.spawnEnemy(at: position)

		syncGameState()
	}

	// MARK: - Fight Mechanics

	func attack() {

		guard gameState.isGameOn else { return }
		guard let hero = gameState.hero else { return }
		guard let enemy = gameState.enemy else { return }

		if gameState.isHeroTurn {

			guard hero.currentEnergy >= 1 else { return }
			let result = combatManager.attack(hero, enemy)
			enemy.currentHealth = max(enemy.currentHealth - result, 0)
			hero.currentEnergy -= 1
			triggerHit(onHero: false)

		} else {

			guard enemy.currentEnergy >= 1 else { return }
			let result = combatManager.attack(enemy, hero)
			hero.currentHealth = max(hero.currentHealth - result, 0)
			enemy.currentEnergy -= 1
			triggerHit(onHero: true)

		}
		checkWinLoseCondition()

		syncGameState()
	}

	func block() {

		guard gameState.isGameOn else { return }

		let target = gameState.isHeroTurn ? gameState.hero : gameState.enemy
		guard let target else { return }
		guard target.currentEnergy >= 1 else { return }

		let isHero = gameState.isHeroTurn
		triggerEffect(forHero: isHero, color: .blue)

		let blockValue = combatManager.block(target)
		let buff = Effect(type: .buff(.armor(value: blockValue)),
						  duration: 1)

		target.applyEffect(buff)
		target.currentEnergy -= 1

		syncGameState()
	}

	func heal() {

		guard gameState.isGameOn else { return }

		let target = gameState.isHeroTurn ? gameState.hero : gameState.enemy
		guard let target else { return }
		guard target.currentEnergy >= 1, target.currentMana >= 10 else { return }
		let isHero = gameState.isHeroTurn
		triggerEffect(forHero: isHero, color: .green)

		let result = combatManager.heal(target)
		target.currentHealth = min(target.currentHealth + result, target.maxHealth)
		target.currentMana -= 10
		target.currentEnergy -= 1

		syncGameState()
	}

	func buff() {

		guard gameState.isGameOn else { return }

		let target = gameState.isHeroTurn ? gameState.hero : gameState.enemy
		guard let target else { return }
		guard target.currentEnergy >= 1, target.currentMana >= 10 else { return }

		let isHero = gameState.isHeroTurn
		triggerEffect(forHero: isHero, color: .yellow)

		let result = combatManager.buff(target)
		let buff = Effect(type: .buff(.attack(value: result)),
						  duration: 1)

		target.applyEffect(buff)
		target.currentMana -= 10
		target.currentEnergy -= 1

		syncGameState()
	}

	func cut() {

		guard gameState.isGameOn else { return }
		guard let hero = gameState.hero else { return }
		guard let enemy = gameState.enemy else { return }

		if gameState.isHeroTurn {

			guard hero.currentEnergy >= 1 else { return }
			hero.currentEnergy -= 1
			let result = combatManager.cut(hero, enemy)
			let debuff = Effect(type: .debuff(.bleeding(value: result)),
								duration: 1)
			enemy.applyEffect(debuff)
			triggerHit(onHero: false)

		} else {

			guard enemy.currentEnergy >= 1 else { return }
			enemy.currentEnergy -= 1
			let result = combatManager.cut(enemy, hero)
			let debuff = Effect(type: .debuff(.bleeding(value: result)),
								duration: 1)
			hero.applyEffect(debuff)
			triggerHit(onHero: true)

		}
		checkWinLoseCondition()

		syncGameState()

	}

	// MARK: - Helpers

	private func triggerEffect(forHero: Bool, color: Color) {
		if forHero {
			heroEffectColor = color
			DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
				if self.gameState.isHeroTurn { self.heroEffectColor = nil }
			}
		} else {
			enemyEffectColor = color
			DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
				if !self.gameState.isHeroTurn { self.enemyEffectColor = nil }
			}
		}
	}

	// helper to trigger a 1s “hit” animation on the target
	private func triggerHit(onHero: Bool) {
		if onHero {
			roomState.heroWasHit = true
			DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
				self.roomState.heroWasHit = false
			}
		} else {
			roomState.enemyWasHit = true
			DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
				self.roomState.enemyWasHit = false
			}
		}
	}
}
