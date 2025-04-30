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

	// MARK: - Game Flow

	func pauseGame() {
		gameState.isGameOn = false
	}

	func resumeGame() {
		gameState.isGameOn = true
	}

	func startFight() {

		gameState.isGameOn = true
		gameState.isHeroTurn = true
		gameState.currentRound = 1
		gameState.hero = characterManager.setupHero()
		gameState.enemyIndex = 0
		let position = gameState.enemyIndex
		gameState.enemy = characterManager.spawnEnemy(at: position)
	}

	func attack() {

		guard gameState.isGameOn else { return }
		guard let hero = gameState.hero else { return }
		guard let enemy = gameState.enemy else { return }

		if gameState.isHeroTurn {
			guard hero.currentEnergy >= 1 else { return }
			let result = combatManager.attack(hero, enemy)
			enemy.currentHealth = max(enemy.currentHealth - result, 0)
			hero.currentEnergy -= 1

		} else {
			guard enemy.currentEnergy >= 1 else { return }
			let result = combatManager.attack(enemy, hero)
			hero.currentHealth = max(hero.currentHealth - result, 0)
			enemy.currentEnergy -= 1

		}
	}

	func heal() {

		if gameState.isHeroTurn {

			guard let target = gameState.hero else { return }
			guard target.currentMana >= 10 else { return }
			target.currentHealth = combatManager.heal(target)
			target.currentMana -= 10

		} else {

			guard let target = gameState.enemy else { return }
			guard target.currentMana >= 10 else { return }
			target.currentHealth = combatManager.heal(target)
			target.currentMana -= 10
		}
	}
}
