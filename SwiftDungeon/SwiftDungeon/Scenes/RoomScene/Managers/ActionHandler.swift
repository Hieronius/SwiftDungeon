import Foundation

// MARK: - ActionResult

/// Should be refactored and placed into separate file
struct ActionResult {

	// refactor
	let didHit: Bool
	let isCritical: Bool
	let impact: Int
	let effects: [Effect]
	let log: [String]
}

// MARK: - ActionHandler

/// Handles attacks, spells, item use or interactions with the world.
final class ActionHandler {

	// MARK: - Dependencies

	var actionCalculator: ActionCalculator

	// MARK: - Initialization

	init(actionCalculator: ActionCalculator) {
		self.actionCalculator = actionCalculator
	}

	// MARK: - Actions



	// MARK: Attack

	func attack(_ host: Character, _ target: Character) -> ActionResult {
		
		let damage = actionCalculator.attack(host, target)

		return ActionResult(didHit: true,
							isCritical: false,
							impact: damage,
							effects: [],
							log: [])
	}

	// MARK: Block

	func block(_ host: Character) -> ActionResult {

		let blockValue = actionCalculator.block(host)

		return ActionResult(didHit: true,
							isCritical: false,
							impact: blockValue,
							effects: [], // armorUP effect can be added
							log: []) // "armor has been increased by \("blockValue")

	}

	// MARK: Cut

	func cut(_ host: Character, _ target: Character) -> ActionResult {

		let damage = actionCalculator.cut(host, target)

		return ActionResult(didHit: true,
							isCritical: false,
							impact: damage,
							effects: [], // bleeding effect can be added
							log: []) // "\(target) lost \(damage) of hp due to bleeding
	}

	// MARK: Stun

	/// Should be refactored to replace raw data from RoomGameManager
	func stun(_ host: Character, target: Character) -> ActionResult {

		ActionResult(didHit: true, isCritical: false, impact: 0, effects: [], log: [])
	}

	// MARK: Sunder Armor

	func sunderArmor(_ host: Character, _ target: Character) -> ActionResult {

		let armorValue = actionCalculator.sunderArmor(host, target)

		return ActionResult(didHit: true,
							isCritical: false,
							impact: armorValue,
							effects: [],
							log: [])
	}

	// MARK: - Spells



	// MARK: Heal

	func heal(_ host: Character) -> ActionResult {

		let healValue = actionCalculator.heal(host)

		return ActionResult(didHit: true,
							isCritical: false,
							impact: healValue,
							effects: [],
							log: [])
	}

	// MARK: AttackUP

	func attackUP(_ host: Character) -> ActionResult {

		let attackValue = actionCalculator.attackUP(host)

		return ActionResult(didHit: true,
							isCritical: false,
							impact: attackValue,
							effects: [],
							log: [])
	}

	// MARK: - Items

	func useItem() {

	}

	// add more
}
