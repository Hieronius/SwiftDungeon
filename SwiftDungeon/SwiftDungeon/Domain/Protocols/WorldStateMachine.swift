//import Foundation

//https://code.tutsplus.com/how-to-build-a-jrpg-a-primer-for-game-developers--gamedev-6676a
//
//
//protocol IState {
//	func update(elapsedTime: Float)
//	func render()
//	func onEnter(params: Any?)
//	func onExit()
//}
//
//class EmptyState: IState {
//	func update(elapsedTime: Float) {
//		// Nothing to update in the empty state
//	}
//
//	func render() {
//		// Nothing to render in the empty state
//	}
//
//	func onEnter(params: Any?) {
//		// No action on enter
//	}
//
//	func onExit() {
//		// No action on exit
//	}
//}
//
//class StateMachine {
//	private var states: [String: IState] = [:]
//	private var currentState: IState = EmptyState()
//
//	func update(elapsedTime: Float) {
//		currentState.update(elapsedTime: elapsedTime)
//	}
//
//	func render() {
//		currentState.render()
//	}
//
//	func change(to stateName: String, params: Any? = nil) {
//		currentState.onExit()
//		if let newState = states[stateName] {
//			currenState = newState
//			currentState.onEnter(params: params)
//		} else {
//			print("Warning: State '\(stateName)' not found.")
//		}
//	}
//
//	func add(name: String, state: IState) {
//		states[name] = state
//	}
//}
//
//let gameMode = StateMachine()
//
//// These state classes should conform to IState
//gameMode.add(name: "mainmenu",   state: MainMenuState(gameMode))
//gameMode.add(name: "localmap",   state: LocalMapState(gameMode))
//gameMode.add(name: "worldmap",   state: WorldMapState(gameMode))
//gameMode.add(name: "battle",     state: BattleState(gameMode))
//gameMode.add(name: "ingamemenu", state: InGameMenuState(gameMode))
//
//gameMode.change(to: "mainmenu")
//
//func updateGame() {
//	let elapsedTime: Float = getElapsedFrameTime()
//	gameMode.update(elapsedTime: elapsedTime)
//	gameMode.render()
//}
