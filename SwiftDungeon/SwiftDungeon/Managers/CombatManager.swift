import Foundation

class CombatManager {

	func attack(_ host: Character, _ target: Character) -> Int {
		Int.random(in: host.minDamage...host.maxDamage) - target.currentArmor
	}

	/// Adds armor value
	func block(_ caster: Character) -> Int {
		caster.currentArmor + caster.blockValue
	}

	// should be refactored so the method only calculates heal instead of using game state properties
	func heal(_ host: Character) -> Int {
		host.spellPower
	}

}
