import SwiftUI

class RoomBuilder {

	static func build() -> RoomView {

		// Build Dependencies for RoomGameManager

		let roomGameStateSnapshot = RoomGameStateSnapshot()

		let roomGameState = RoomGameState(
			roomGameStateSnapshot: roomGameStateSnapshot)

		let actionCalculator = ActionCalculator()
		let actionHandler = ActionHandler(actionCalculator: actionCalculator)
		let characterManager = CharacterManager()
		let effectManager = EffectManager()
		let turnManager = TurnManager()

		// Build RoomGameManager

		let roomGameManager = RoomGameManager(
			roomGameState: roomGameState,
			actionHandler: actionHandler,
			actionCalculator: actionCalculator,
			characterManager: characterManager,
			effectManager: effectManager,
			turnManager: turnManager
		)

		// Build RoomViewModel

		let sceneUIStateManager = SceneUIStateManager()

		let viewModel = RoomViewModel(
			roomGameManager: roomGameManager,
			sceneUIStateManager: sceneUIStateManager
		)

		// Build RoomView

		return RoomView(viewModel: viewModel)
	}
}
