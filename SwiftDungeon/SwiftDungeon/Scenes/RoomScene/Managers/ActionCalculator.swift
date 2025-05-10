import Foundation

class ActionCalculator {

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

	func attackUP(_ caster: Character) -> Int {
		caster.spellPower / 4
	}

	func armorUP(_ caster: Character) -> Int {
		caster.spellPower / 5
	}

	func cut(_ host: Character, _ target: Character) -> Int {
		let damage = (Int.random(in: host.minDamage...host.maxDamage) - target.currentArmor) / 2
		return damage > 0 ? damage : 0
	}

	// should be modifed to imply host stats
	func sunderArmor(_ host: Character, _ target: Character) -> Int {
		let onePercentOfArmor = Double(target.currentArmor) / 100
		let impact = 30.0 * (onePercentOfArmor)
		return Int(impact)
	}

}

/*
 ROUND 1

 Hero Turn
 Check for Effects
 Positive effects: 0, Negative effects: 0
 cast block, duration 3
 End Turn

 Enemy Turn
 Positive effects: 0, Negative effects: 0
 cast bleeding, duration 3
 End Turn

 ROUND 2

 Hero Turn
 Check for Effects
 Positive efects: 1, Negative effects: 1
 if buff -> if static { duration -1 } else { applyEffect, duration -1 }
 keep block up, cut duration by 1
 if debuff -> if static { duration -1 } else { applyEffect, duration -1 }
 apply bleeding effect, cur duration by 1
 End Round

 Enemy Turn
 Check for Effects
 */
