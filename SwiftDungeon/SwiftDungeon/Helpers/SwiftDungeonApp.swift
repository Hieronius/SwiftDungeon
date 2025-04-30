import SwiftUI

@main
struct SwiftDungeonApp: App {

    var body: some Scene {
		
        WindowGroup {

			let gameState = GameState()
			let combatManager = CombatManager()
			let characterManager = CharacterManager()
			let viewModel = RoomViewModel(gameState: gameState,
										  combatManager: combatManager,
										  characterManager: characterManager)

            RoomView(viewModel: viewModel)
        }
    }
}
