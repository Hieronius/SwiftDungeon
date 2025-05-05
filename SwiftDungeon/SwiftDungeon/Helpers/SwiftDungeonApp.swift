import SwiftUI

@main
struct SwiftDungeonApp: App {

    var body: some Scene {
		
        WindowGroup {

			let gameState = GameState()
			let combatManager = CombatManager()
			let characterManager = CharacterManager()
			let effectManager = EffectManager()
			let sceneUIStateManager = SceneUIStateManager()
			let viewModel = RoomViewModel(gameState: gameState,
										  combatManager: combatManager,
										  characterManager: characterManager,
										  effectManager: effectManager,
										  sceneUIStateManager: sceneUIStateManager)

            RoomView(viewModel: viewModel)
        }
    }
}
