import SwiftUI

class RoomViewModel: ObservableObject {

	// MARK: - Dependencies

	@Published private var gameState: GameState
	private let combatManager: CombatManager
	private let characterManager: CharacterManager

	// MARK: - Properties

	var currentRoom: Int { gameState.currentRoom }
	var currentRound: Int { gameState.currentRound }

	// MARK: - Initialization

	init(gameState: GameState,
		 combatManager: CombatManager,
		 characterManager: CharacterManager) {

		self.gameState = gameState
		self.combatManager = combatManager
		self.characterManager = characterManager
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
	}

	func endTurn() {

		guard gameState.isGameOn else { return }

		if !gameState.isHeroTurn {

			gameState.currentRound += 1
			guard let hero = gameState.hero else { return }
			hero.currentEnergy = hero.maxEnergy

		} else if gameState.isHeroTurn {

			guard let enemy = gameState.enemy else { return }
			enemy.currentEnergy = enemy.maxEnergy
		}
		gameState.isHeroTurn.toggle()
	}

	func checkWinLoseCondition() {

		guard let hero = gameState.hero else { return }
		guard let enemy = gameState.enemy else { return }

		if hero.currentHealth < 1 {
			gameState.isGameOn = false
			gameState.isGameOver = true

		} else if enemy.currentHealth < 1 {
			gameState.isGameOn = false
			gameState.isHeroWon = true
		}
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
	}

	func restoreHero() {
		print("restore button")
		print(gameState.hero)
		guard let hero = gameState.hero else { return }
		print("got response")
		hero.currentHealth = hero.maxHealth
		hero.currentMana = hero.maxMana
		hero.currentEnergy = hero.maxEnergy
		print(hero.currentHealth)
	}

	// MARK: - Fight Mechanics

	func attack() {

		print("pressed attack button")

		guard gameState.isGameOn else { return }
		guard let hero = gameState.hero else { return }
		guard let enemy = gameState.enemy else { return }

		if gameState.isHeroTurn {

			guard hero.currentEnergy >= 1 else { return }
			let result = combatManager.attack(hero, enemy)
			enemy.currentHealth = max(enemy.currentHealth - result, 0)
			hero.currentEnergy -= 1

			// checkWinLoseCondition()

		} else {

			guard enemy.currentEnergy >= 1 else { return }
			let result = combatManager.attack(enemy, hero)
			hero.currentHealth = max(hero.currentHealth - result, 0)
			enemy.currentEnergy -= 1

			// checkWinLoseCondition()

		}
	}

	func block() {

		guard gameState.isGameOn else { return }

		let target = gameState.isHeroTurn ? gameState.hero : gameState.enemy
		guard let target else { return }
		guard target.currentEnergy >= 1 else { return }
		target.currentArmor += combatManager.block(target)
		target.currentEnergy -= 1
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
	}

	func buff() {

		guard gameState.isGameOn else { return }

		let target = gameState.isHeroTurn ? gameState.hero : gameState.enemy
		guard let target else { return }
		guard target.currentEnergy >= 1, target.currentMana >= 10 else { return }

		let result = combatManager.buff(target)
		target.minDamage += result
		target.maxDamage += result
		target.currentMana -= 10
		target.currentEnergy -= 1
	}
}
