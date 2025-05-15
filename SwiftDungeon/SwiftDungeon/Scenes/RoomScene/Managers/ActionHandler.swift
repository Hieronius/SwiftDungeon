import Foundation

/// Should be refactored and placed into separate file
struct ActionResult {

	// refactor
	let didHit: Bool
	let isCritical: Bool
	let impact: Int
	let effects: [Effect]
	let log: [String]
}

/// Handles attacks, spells, item use or interactions with the world.
class ActionHandler {

	var actionCalculator: ActionCalculator

	init(actionCalculator: ActionCalculator) {
		self.actionCalculator = actionCalculator
	}

	func attack(_ host: Character, _ target: Character) -> ActionResult {
		
		let damage = actionCalculator.attack(host, target)

		return ActionResult(didHit: true,
							isCritical: false,
							impact: damage,
							effects: [],
							log: [])
	}

	func block(_ host: Character) -> ActionResult {

		let blockValue = actionCalculator.block(host)

		return ActionResult(didHit: true,
							isCritical: false,
							impact: blockValue,
							effects: [],
							log: [])

	}

	func heal() {

	}

	func useItem() {

	}

	// add more
}
