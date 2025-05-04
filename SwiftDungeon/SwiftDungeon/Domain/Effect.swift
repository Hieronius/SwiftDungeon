import Foundation

struct Effect {

	let type: EffectType
	var duration: Int


}

enum EffectType {

	// Static Buffs

	case blockUP(value: Int)
	case attackUP(value: Int)

	// Ticking Buffs

	case healthRegen(initialHeal: Int, healthPerTurn: Int)
	case manaRegen(initialMana: Int, manaPerTurn: Int)

	// Static Debuffs

	case blockDOWN(value: Int)
	case attackDOWN(value: Int)

	// Ticking Debuffs

	case bleeding(initialDamage: Int, damagePerTurn: Int)
	case exaustion(initialEnergy: Int, energyPerTurn: Int)

	var isDebuff: Bool {
		switch self {
		case .bleeding, .exaustion, .attackDOWN, .blockDOWN: return true
		default: return false
		}
	}

	var isTicking: Bool {
		switch self {
		case .healthRegen, .bleeding, .manaRegen, .exaustion: return true
		default: return false
		}
	}
}
