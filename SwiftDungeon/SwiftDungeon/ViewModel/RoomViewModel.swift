import SwiftUI

class RoomViewModel: ObservableObject {

	var gameState: GameState
	var combatManager: CombatManager
	var characterManager: CharacterManager

	init(gameState: GameState,
		 combatManager: CombatManager,
		 characterManager: CharacterManager) {

		self.gameState = gameState
		self.combatManager = combatManager
		self.characterManager = characterManager
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
}
