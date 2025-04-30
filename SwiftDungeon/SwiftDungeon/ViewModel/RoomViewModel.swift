import SwiftUI

class RoomViewModel: ObservableObject {

	// MARK: - Dependencies

	private let gameState: GameState
	private let combatManager: CombatManager
	private let characterManager: CharacterManager

	// MARK: - Properties

	// State

	@Published var currentRoom: Int
	@Published var currentRound: Int
	@Published var isHeroTurn: Bool

	// Hero Stats

	@Published var heroMaxHealth: Int
	@Published var heroCurrentHealth: Int
	@Published var heroMaxMana: Int
	@Published var heroCurrentMana: Int
	@Published var heroMaxEnergy: Int
	@Published var heroCurrentEnergy: Int

	// Enemy Stats

	@Published var enemyMaxHealth: Int
	@Published var enemyCurrentHealth: Int
	@Published var enemyMaxMana: Int
	@Published var enemyCurrentMana: Int
	@Published var enemyMaxEnergy: Int
	@Published var enemyCurrentEnergy: Int


	// MARK: - Initialization

	init(gameState: GameState,
		 combatManager: CombatManager,
		 characterManager: CharacterManager) {

		self.gameState = gameState
		self.combatManager = combatManager
		self.characterManager = characterManager

		self.currentRoom = gameState.currentRoom
		self.currentRound = gameState.currentRound
		self.isHeroTurn = gameState.isHeroTurn

		self.heroMaxHealth = gameState.hero?.maxHealth ?? 0
		self.heroCurrentHealth = gameState.hero?.currentHealth ?? 0
		self.heroMaxMana = gameState.hero?.maxMana ?? 0
		self.heroCurrentMana = gameState.hero?.currentMana ?? 0
		self.heroMaxEnergy = gameState.hero?.maxEnergy ?? 0
		self.heroCurrentEnergy = gameState.hero?.currentEnergy ?? 0

		self.enemyMaxHealth = gameState.enemy?.maxHealth ?? 0
		self.enemyCurrentHealth = gameState.enemy?.currentHealth ?? 0
		self.enemyMaxMana = gameState.enemy?.maxMana ?? 0
		self.enemyCurrentMana = gameState.enemy?.currentMana ?? 0
		self.enemyMaxEnergy = gameState.enemy?.maxEnergy ?? 0
		self.enemyCurrentEnergy = gameState.enemy?.currentEnergy ?? 0
	}

	// MARK: Sync Game State

	func syncGameState() {

		currentRoom = gameState.currentRoom
		currentRound = gameState.currentRound
		isHeroTurn = gameState.isHeroTurn

		guard let hero = gameState.hero else { return }
		guard let enemy = gameState.enemy else { return }

		heroMaxHealth = hero.maxHealth
		heroCurrentHealth = hero.currentHealth
		heroMaxMana = hero.maxMana
		heroCurrentMana = hero.currentMana
		heroMaxEnergy = hero.maxEnergy
		heroCurrentEnergy = hero.currentEnergy

		enemyMaxHealth = enemy.maxHealth
		enemyCurrentHealth = enemy.currentHealth
		enemyMaxMana = enemy.maxMana
		enemyCurrentMana = enemy.currentMana
		enemyMaxEnergy = enemy.maxEnergy
		enemyCurrentEnergy = enemy.currentEnergy

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

		if hero.currentHealth < 1 {
			gameState.isGameOn = false
			gameState.isGameOver = true
			startFight()
			print("Game over -> start new game")

		} else if enemy.currentHealth < 1 {
			gameState.isGameOn = false
			gameState.isHeroWon = true
			enterNewRoom()
			print("New room should be intered")
		}

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
		gameState.isGameOn = true
		gameState.isHeroTurn = true
		gameState.isHeroWon = false
		gameState.isGameOver = false
		gameState.currentRound = 1
		gameState.currentRoom += 1
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
			print(result)
			enemy.currentHealth = max(enemy.currentHealth - result, 0)
			hero.currentEnergy -= 1

			 checkWinLoseCondition()

		} else {

			guard enemy.currentEnergy >= 1 else { return }
			let result = combatManager.attack(enemy, hero)
			hero.currentHealth = max(hero.currentHealth - result, 0)
			enemy.currentEnergy -= 1

			 checkWinLoseCondition()

		}
		syncGameState()
	}

	func block() {

		guard gameState.isGameOn else { return }

		let target = gameState.isHeroTurn ? gameState.hero : gameState.enemy
		guard let target else { return }
		guard target.currentEnergy >= 1 else { return }
		
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

		let result = combatManager.buff(target)
		let buff = Effect(type: .buff(.attack(value: result)),
						  duration: 1)

		target.applyEffect(buff)
		target.currentMana -= 10
		target.currentEnergy -= 1

		syncGameState()
	}
}
