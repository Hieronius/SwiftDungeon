import SwiftUI

class GameState: ObservableObject {

	@Published var hero: Character?
	@Published var enemy: Character?
	@Published var enemyIndex = 1
	@Published var isGameOn = true
	@Published var isHeroTurn = true
	@Published var currentRound = 0
	@Published var currentRoom = 1
}
