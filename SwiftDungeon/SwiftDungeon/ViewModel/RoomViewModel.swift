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

		guard let hero = gameState.hero else { return }
		guard let enemy = gameState.enemy else { return }

		if gameState.isHeroTurn {
			combatManager.attack(hero, enemy)
		} else {
			combatManager.attack(enemy, hero)
		}
	}

	func heal() {

		if gameState.isHeroTurn {

			guard let target = gameState.hero else { return }
			combatManager.heal(target)

		} else {

			guard let target = gameState.enemy else { return }
			combatManager.heal(target)
		}
	}
}
