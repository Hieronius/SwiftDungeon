import Foundation

class CombatManager {

	/// Calculates average from host min/max damage and subtracting target's current armor
	func attack(_ host: Character, _ target: Character) -> Int {
		let damage = Int.random(in: host.minDamage...host.maxDamage) - target.currentArmor
		return damage > 0 ? damage : 0
	}

	/// Adds blockValue to caster currentArmor for one turn
	func block(_ caster: Character) -> Int {
		caster.currentArmor + caster.blockValue
	}

	/// Heals host by his spellPower value
	func heal(_ caster: Character) -> Int {
		caster.spellPower
	}

	func buff(_ caster: Character) -> Int {
		caster.spellPower / 4
	}

}
