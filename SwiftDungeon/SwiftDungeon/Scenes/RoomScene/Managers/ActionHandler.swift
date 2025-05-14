import Foundation

/// Should be refactored and placed into separate file
struct ActionResult {

	// refactor
	let didHit: Bool
	let isCritical: Bool
	let damage: Int
	let effects: [Effect]
	let log: [String]
}

class ActionHandler {

	var actionCalculator: ActionCalculator

	init(actionCalculator: ActionCalculator) {
		self.actionCalculator = actionCalculator
	}

//	func attack(host: Character, target: Character) -> ActionResult {
//
//	}

	func block() {

	}

	func heal() {

	}

	func useItem() {

	}

	// add more
}
