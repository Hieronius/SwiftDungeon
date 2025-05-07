import SwiftUI

class RoomBuilder {

	static func build() -> RoomView {

		let gameState = RoomGameState()
		let combatManager = ActionCalculator()
		let characterManager = CharacterManager()
		let effectManager = EffectManager()
		let sceneUIStateManager = SceneUIStateManager()
		let viewModel = RoomViewModel(gameState: gameState,
									  combatManager: combatManager,
									  characterManager: characterManager,
									  effectManager: effectManager,
									  sceneUIStateManager: sceneUIStateManager)

		return RoomView(viewModel: viewModel)
	}
}
