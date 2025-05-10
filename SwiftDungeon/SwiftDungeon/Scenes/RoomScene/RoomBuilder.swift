import SwiftUI

class RoomBuilder {

	static func build() -> RoomView {

		let roomGameState = RoomGameState()
		let actionCalculator = ActionCalculator()
		let characterManager = CharacterManager()
		let effectManager = EffectManager()
		let sceneUIStateManager = SceneUIStateManager()
		let turnManager = TurnManager()

		let roomGameManager = RoomGameManager(roomGameState: roomGameState,
											  actionCalculator: actionCalculator,
											  characterManager: characterManager,
											  effectManager: effectManager,
											  turnManager: turnManager)

		let viewModel = RoomViewModel(roomGameManager: roomGameManager,
									  sceneUIStateManager: sceneUIStateManager)

		return RoomView(viewModel: viewModel)
	}
}
