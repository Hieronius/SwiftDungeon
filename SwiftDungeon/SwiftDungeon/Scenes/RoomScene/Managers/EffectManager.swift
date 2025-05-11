import Foundation

class EffectManager {
	
	func applyEffect(_ effect: Effect, _ target: Character) {
		
		switch effect.type {
			
			// Buffs
			
		case .armorUP(let value):
			target.currentArmor += value

		case .attackUP(value: let value):
			target.minDamage += value
			target.maxDamage += value

		case .healthRegen(let initialHeal, _):
			target.currentHealth = min(target.currentHealth + initialHeal, target.maxHealth)

		case .manaRegen(initialMana: let initialMana, _):
			target.currentMana = min(target.currentMana + initialMana, target.maxMana)
			
			// Debuffs

		case .bleeding(let initialDamage, _):
			target.currentHealth -= initialDamage

		case .armorDOWN(value: let value):
			target.currentArmor = max(target.currentArmor - value, 0)

		case .energyDOWN(value: let value):
			target.maxEnergy -= value

		case .attackDOWN(value: let value):
			target.minDamage -= value
			target.maxDamage -= value

		case .stun:
			print("stunned")
		}
		target.activeEffects.append(effect)
	}
	
	// 2) START OF TURN: tick & expire
	func processEffectsAtTurnStart(_ target: Character) {
		// iterate backwards so removals don’t shift indices
		for idx in (0..<target.activeEffects.count).reversed() {

			var effect = target.activeEffects[idx]
			
			// TICKING: apply per-turn
			
			if effect.type.isTicking {
				
				switch effect.type {
					
					// Buffs
					
				case .healthRegen(_, let perTurn):
					target.currentHealth = min(target.currentHealth + perTurn, target.maxHealth)

				case .manaRegen(_, let perTurn):
					target.currentMana = min(target.currentMana + perTurn, target.maxMana)
					
					// Debuffs
					
				case .bleeding(_, let perTurn):
					target.currentHealth = max(target.currentHealth - perTurn, 0)

				default:
					break
				}
			}

			if case .stun = effect.type {
				target.isStunned = true
			}

			effect.duration -= 1
			target.activeEffects[idx] = effect
			
			// STATIC expired? revert any static buff & remove
			if effect.duration <= 0 {
				
				switch effect.type {

				case .armorUP(let value):
					target.currentArmor -= value

				case .armorDOWN(let value):
					target.currentArmor += value

				case .attackUP(let value):
					target.minDamage -= value
					target.maxDamage -= value

				case .attackDOWN(let value):
					target.minDamage += value
					target.maxDamage += value

				case .energyDOWN(let value):
					target.maxEnergy += value
					target.currentEnergy = target.maxEnergy

				case .stun:
					target.isStunned = false
					
				default:
					break
				}
				
				target.activeEffects.remove(at: idx)
			}
		}
	}
	
	// convenience filters
	func clearAllEffects(_ target: Character) {
		// revert all remaining buffs first
		for effect in target.activeEffects {
			if case .armorUP(let value) = effect.type {
				target.currentArmor -= value
			}
		}
		target.activeEffects.removeAll()
	}
	
	func clearBuffs(_ target: Character) {
		let (buffs, rest) = target.activeEffects.partitioned { !$0.type.isDebuff }
		buffs.forEach {
			if case .armorUP(let value) = $0.type {
				target.currentArmor -= value
			}
		}
		target.activeEffects = rest
	}
	func clearDebuffs(_ target: Character) {
		let (debuffs, rest) = target.activeEffects.partitioned { $0.type.isDebuff }
		debuffs.forEach {
			if case .armorDOWN(let value) = $0.type {
				target.currentArmor += value
			}
		}
		// no static debuffs today, but you’d revert them here
		target.activeEffects = rest
	}
}

// helper to split an array
extension Array {
	func partitioned(by isFirst: (Element) -> Bool) -> (first: [Element], second: [Element]) {
		var a = [Element]()
		var b = [Element]()
		for x in self {
			if isFirst(x) {
				a.append(x)
			} else {
				b.append(x)
			}
		}
		return (first: a, second: b)
	}
}
