import SwiftUI

class RoomViewModel: ObservableObject {

	var gameState: GameState
	var combatManager: CombatManager
	var characterManager: CharacterManager
}
