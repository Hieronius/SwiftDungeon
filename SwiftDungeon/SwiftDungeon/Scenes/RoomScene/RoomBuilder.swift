import SwiftUI

class RoomBuilder {

	static func build() -> RoomView {

		// Build Dependencies for RoomGameManager

		let roomGameState = RoomGameState()
		let actionCalculator = ActionCalculator()
		let characterManager = CharacterManager()
		let effectManager = EffectManager()
		let sceneUIStateManager = SceneUIStateManager()
		let turnManager = TurnManager()

		// Build RoomGameManager

		let roomGameManager = RoomGameManager(roomGameState: roomGameState,
											  actionCalculator: actionCalculator,
											  characterManager: characterManager,
											  effectManager: effectManager,
											  turnManager: turnManager)

		// Build RoomViewModel

		let viewModel = RoomViewModel(roomGameManager: roomGameManager,
									  sceneUIStateManager: sceneUIStateManager)

		// Build RoomView

		return RoomView(viewModel: viewModel)
	}
}
