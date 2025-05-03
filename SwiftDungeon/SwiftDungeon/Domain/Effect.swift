import Foundation

struct Effect {

	let type: EffectType
	var duration: Int


}

enum EffectType {

	case block(value: Int)
	case healthRegen(initialHeal: Int, healthPerTurn: Int)
	case bleeding(initialDamage: Int, damagePerTurn: Int)

	var isDebuff: Bool {
		switch self {
		case .bleeding: return true
		default: return false
		}
	}

	var isTicking: Bool {
		switch self {
		case .healthRegen, .bleeding: return true
		default: return false
		}
	}
}
