import Foundation

class CombatManager {

	func attack(_ host: Character, _ target: Character) -> Int {
		Int.random(in: host.minDamage...host.maxDamage)
	}

	func block(_ host: Character) {

	}

	// should be refactored so the method only calculates heal instead of using game state properties
	func heal(_ host: Character) -> Int {
		host.maxHealth
	}

}
