import Foundation

/// Calculates a specific impact of specific action, skill or spell
final class ActionCalculator {

	// MARK: - Actions

	// MARK: Attack

	/// Calculates average from host min/max damage and subtracting target's current armor
	func attack(_ host: Character, _ target: Character) -> Int {
		
		let damage = Int.random(in: host.minDamage...host.maxDamage) - target.currentArmor
		return damage > 0 ? damage : 0
	}

	// MARK: Block

	/// Adds blockValue to caster currentArmor for one turn
	func block(_ caster: Character) -> Int {
		caster.currentArmor + caster.blockValue
	}

	// MARK: Cut

	func cut(_ host: Character, _ target: Character) -> Int {
		
		let damage = (Int.random(in: host.minDamage...host.maxDamage) - target.currentArmor) / 2
		return damage > 0 ? damage : 0
	}

	// MARK: Sunder Armor

	// should be modifed to imply host stats
	func sunderArmor(_ host: Character, _ target: Character) -> Int {
		
		let onePercentOfArmor = Double(target.currentArmor) / 100
		let impact = 30.0 * (onePercentOfArmor)
		return Int(impact)
	}

	// MARK: - Spells



	// MARK: Heal

	/// Heals host by his spellPower value
	func heal(_ caster: Character) -> Int {
		caster.spellPower
	}

	// MARK: Attack Up

	func attackUP(_ caster: Character) -> Int {
		caster.spellPower / 4
	}

	// MARK: Armor Up

	func armorUP(_ caster: Character) -> Int {
		caster.spellPower / 5
	}

	// MARK: Fireball

	func fireball(_ host: Character, _ target: Character) -> Int {
		
		let impact = host.spellPower
		return impact
	}

	// MARK: Dot

	func dot(_ host: Character, _ target: Character) -> Int {
		
		let impact = host.spellPower / 2
		return impact
	}

	// MARK: Exhaustion

	func exhaustion(_ host: Character, _ target: Character) -> Int {
		
		let impact = 1
		return impact
	}

	// MARK: Health Regen

	func healthRegen(_ host: Character) -> Int {
		
		let impact = 10
		return impact
	}

	// MARK: Mana Regen

	func manaRegen(_ host: Character) -> Int {
		
		let impact = 10
		return impact
	}

}
