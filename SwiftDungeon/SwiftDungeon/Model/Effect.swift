import Foundation

struct Effect {
	let type: EffectType  // Now properly nested
	var duration: Int     // Turns remaining
	var isDebuff: Bool {
		if case .debuff = type {
			return true
		}
		return false
	}
}

enum EffectType {
	case buff(Buff)
	case debuff(Debuff)

	enum Buff {
		case attack(value: Int)
		case armor(value: Int)
		// Add more buffs here
	}

	enum Debuff {
		case bleeding(value: Int)
		case energy(value: Int)
		// Add more debuffs here
	}
}
