import Foundation

struct Effect {

	let type: EffectType
	var duration: Int


}

enum EffectType: Equatable {

	// Static Buffs

	case armorUP(value: Int)
	case attackUP(value: Int)

	// Ticking Buffs

	case healthRegen(initialHeal: Int, healthPerTurn: Int)
	case manaRegen(initialMana: Int, manaPerTurn: Int)

	// Static Debuffs

	case armorDOWN(value: Int)
	case attackDOWN(value: Int)
	case energyDOWN(value: Int)
	case stun

	// Ticking Debuffs

	case bleeding(initialDamage: Int, damagePerTurn: Int)

	var isDebuff: Bool {
		switch self {
		case 	.bleeding,
				.attackDOWN,
				.armorDOWN,
				.stun,
				.energyDOWN:
				return true

		default: return false
		}
	}

	var isTicking: Bool {
		switch self {
		case 	.healthRegen,
				.bleeding,
				.manaRegen:
			return true
		default: return false
		}
	}
}
