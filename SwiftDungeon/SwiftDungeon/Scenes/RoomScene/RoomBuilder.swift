import SwiftUI

// TODO: Should be refactored to separate dependencies initialization in a single place like app starting point and pass it to any needed modules


class RoomBuilder {

	// Dependencies

//	let roomGameStateSnapshot = RoomGameStateSnapshot()
//
//	let roomGameState = RoomGameState(
//		roomGameStateSnapshot: roomGameStateSnapshot)
//
//	let actionCalculator = ActionCalculator()
//	let actionHandler = ActionHandler(actionCalculator: actionCalculator)
//	let characterManager = CharacterManager()
//	let effectManager = EffectManager()
//	let turnManager = TurnManager()


	// init(dependencies)

	// buildRoom()
	// buildDungeon()

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
