import Foundation

struct Effect {

	let type: EffectType
	var duration: Int


}

enum EffectType {

	// Static Buffs

	case armorUP(value: Int)
	case attackUP(value: Int)

	// Ticking Buffs

	case healthRegen(initialHeal: Int, healthPerTurn: Int)
	case manaRegen(initialMana: Int, manaPerTurn: Int)

	// Static Debuffs

	case armorDOWN(value: Int)
	case attackDOWN(value: Int)
	case stun

	// Ticking Debuffs

	case bleeding(initialDamage: Int, damagePerTurn: Int)
	case exhaustion(initialEnergy: Int, energyPerTurn: Int)

	var isDebuff: Bool {
		switch self {
		case .bleeding, .exhaustion, .attackDOWN, .armorDOWN, .stun: return true
		default: return false
		}
	}

	var isTicking: Bool {
		switch self {
		case .healthRegen, .bleeding, .manaRegen, .exhaustion: return true
		default: return false
		}
	}
}
