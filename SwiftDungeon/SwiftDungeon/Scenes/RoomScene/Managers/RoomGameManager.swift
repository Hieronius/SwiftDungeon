import Foundation

class RoomGameManager {

	// Any attacks and spells should be treated as actions
	let roomGameState: RoomGameState
	let actionCalculator: ActionCalculator
	let characterManager: CharacterManager
	let effectManager: EffectManager
	let turnManager: TurnManager

	init(
		roomGameState: RoomGameState,
		actionCalculator: ActionCalculator,
		characterManager: CharacterManager,
		effectManager: EffectManager,
		turnManager: TurnManager
	) {
		self.roomGameState = roomGameState
		self.actionCalculator = actionCalculator
		self.characterManager = characterManager
		self.effectManager = effectManager
		self.turnManager = turnManager

	}
}

// MARK: - Game Options

extension RoomGameManager {
	
	func pauseGame() {
		roomGameState.isGameOn = false
	}
	
	func resumeGame() {
		roomGameState.isGameOn = true
	}
}

// MARK: - Game Flow States

extension RoomGameManager {

	func startFight() {

		roomGameState.isGameOn = true
		roomGameState.isHeroTurn = true
		roomGameState.isHeroWon = false
		roomGameState.isGameOver = false
		roomGameState.currentRound = 1
		roomGameState.hero = characterManager.setupHero()
		roomGameState.enemyIndex = 0
		let position = roomGameState.enemyIndex
		roomGameState.enemy = characterManager.spawnEnemy(at: position)

		checkWinLoseCondition()

	}

	// MARK: EndTurn

	func endTurn() {

		guard roomGameState.isGameOn else { return }

		if !roomGameState.isHeroTurn {

			roomGameState.currentRound += 1
			guard let hero = roomGameState.hero else { return }
			hero.currentEnergy = hero.maxEnergy

			effectManager.processEffectsAtTurnStart(hero)

			if hero.isStunned {

				DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {

					self.roomGameState.isHeroTurn.toggle()
					self.checkWinLoseCondition()

					self.endTurn()
				}

			} else {

				roomGameState.isHeroTurn.toggle()
				checkWinLoseCondition()

			}

		} else if roomGameState.isHeroTurn {

			guard let enemy = roomGameState.enemy else { return }
			enemy.currentEnergy = enemy.maxEnergy

			effectManager.processEffectsAtTurnStart(enemy)

			if enemy.isStunned {

				DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
					self.roomGameState.isHeroTurn.toggle()
					self.checkWinLoseCondition()

					self.endTurn()
				}

			} else {

				roomGameState.isHeroTurn.toggle()
				checkWinLoseCondition()

			}
		}

	}

	// MARK: Check Win/Lose Condition

	func checkWinLoseCondition() {

		guard let hero = roomGameState.hero else { return }
		guard let enemy = roomGameState.enemy else { return }

		if roomGameState.currentRoom > GameConfig.dungeonLength {
			roomGameState.isGameCompleted = true
			roomGameState.isGameOn = false
			return
		}

		if hero.currentHealth < 1 {
			roomGameState.isGameOn = false
			roomGameState.isGameOver = true
			startFight()

		} else if enemy.currentHealth < 1 {

			roomGameState.isGameOn = false
			roomGameState.isHeroWon = true
			let experience = roomGameState.currentRoom * GameConfig.expPerRoom
			if (hero.stats.currentExperience + experience) >= hero.stats.maxExperience {
				heroLevelUP()
			} else {
				hero.stats.currentExperience += experience
			}
			enterNewRoom()
		}
	}

	// MARK: Enter New Room

	func enterNewRoom() {

		roomGameState.currentRoom += 1
		roomGameState.isGameOn = true
		roomGameState.isHeroTurn = true
		roomGameState.isHeroWon = false
		roomGameState.isGameOver = false
		roomGameState.currentRound = 1
		restoreCharacter(isHeroTurn: false)
		print("enemy index before - \(roomGameState.enemyIndex)")
		roomGameState.enemyIndex += 1
		print("enemy indexc after - \(roomGameState.enemyIndex)")
		let position = roomGameState.enemyIndex
		roomGameState.enemy = characterManager.spawnEnemy(at: position)
	}
}

// MARK: - Hero Updates

extension RoomGameManager {

	func heroLevelUP() {

		guard let hero = roomGameState.hero else { return }

		hero.stats.level += 1
		hero.stats.maxExperience += 100
		hero.stats.currentExperience = 1
		hero.stats.strength += 2
		hero.stats.agility += 2
		hero.stats.vitality += 2
		hero.stats.intellect += 1
		hero.maxHealth += 10
		hero.maxMana += 10
		hero.maxDamage += 1
		hero.minDamage += 1
		restoreCharacter(isHeroTurn: true)

		checkWinLoseCondition()
	}

	func restoreCharacter(isHeroTurn: Bool) {

		let target = isHeroTurn ? roomGameState.hero : roomGameState.enemy
		guard let target else { return }
		target.currentHealth = target.maxHealth
		target.currentMana = target.maxMana
		target.currentEnergy = target.maxEnergy

		checkWinLoseCondition()
	}
}

// MARK: - Fight Mechanics

extension RoomGameManager {

	// MARK: Impact Mechanic

	func actionImpactAndTarget() -> (Bool, Int) {
		let impact = roomGameState.actionImpact
		let target = roomGameState.isHeroTurn
		return (target, impact)
	}

	// MARK: - Actions



	// MARK: Attack

	func attack() {

		guard roomGameState.isGameOn else { return }
		guard let hero = roomGameState.hero else { return }
		guard let enemy = roomGameState.enemy else { return }

		if roomGameState.isHeroTurn {

			guard hero.currentEnergy >= GameConfig.attackEnergyCost else { return }
			let result = actionCalculator.attack(hero, enemy)
			enemy.currentHealth = max(enemy.currentHealth - result, 0)
			hero.currentEnergy -= GameConfig.attackEnergyCost
			roomGameState.actionImpact = result
			triggerHit(onHero: false)

		} else {

			guard enemy.currentEnergy >= GameConfig.attackEnergyCost else { return }
			let result = actionCalculator.attack(enemy, hero)
			hero.currentHealth = max(hero.currentHealth - result, 0)
			enemy.currentEnergy -= GameConfig.attackEnergyCost
			roomGameState.actionImpact = result
			triggerHit(onHero: true)
		}
		checkWinLoseCondition()

	}

	// MARK: Block

	func block() {

		guard roomGameState.isGameOn else { return }

		let target = roomGameState.isHeroTurn ? roomGameState.hero : roomGameState.enemy
		guard let target else { return }
		guard target.currentEnergy >= GameConfig.blockEnergyCost else { return }

		let blockValue = actionCalculator.block(target)
		let buff = Effect(type: .armorUP(value: blockValue), duration: 3)

		effectManager.applyEffect(buff, target)
		target.currentEnergy -= GameConfig.blockEnergyCost
		

		checkWinLoseCondition()
	}

	// MARK: Cut

	func cut() {

		guard roomGameState.isGameOn else { return }
		guard let hero = roomGameState.hero else { return }
		guard let enemy = roomGameState.enemy else { return }

		if roomGameState.isHeroTurn {

			guard hero.currentEnergy >= GameConfig.cutEnergyCost else { return }
			hero.currentEnergy = max(hero.currentEnergy - GameConfig.cutEnergyCost, 0)
			let result = actionCalculator.cut(hero, enemy)
			let debuff = Effect(type: .bleeding(initialDamage: result, damagePerTurn: result), duration: 3)
			effectManager.applyEffect(debuff, enemy)
			triggerHit(onHero: false)

		} else {

			guard enemy.currentEnergy >= GameConfig.cutEnergyCost else { return }
			enemy.currentEnergy = max(enemy.currentEnergy - GameConfig.cutEnergyCost, 0)
			let result = actionCalculator.cut(enemy, hero)
			let debuff = Effect(type: .bleeding(initialDamage: result, damagePerTurn: result), duration: 3)
			effectManager.applyEffect(debuff, hero)
			triggerHit(onHero: true)

		}
		checkWinLoseCondition()

	}

	// MARK: Stun

	func stun() {

		guard roomGameState.isGameOn else { return }
		guard let hero = roomGameState.hero else { return }
		guard let enemy = roomGameState.enemy else { return }

		if roomGameState.isHeroTurn {

			guard hero.currentEnergy >= GameConfig.stunEnergyCost else { return }
			hero.currentEnergy = max(hero.currentEnergy - GameConfig.stunEnergyCost, 0)

			let stunEffect = Effect(type: .stun, duration: GameConfig.stunDuration)
			effectManager.applyEffect(stunEffect, enemy)
						triggerHit(onHero: false)

		} else {

			guard enemy.currentEnergy >= GameConfig.cutEnergyCost else { return }
			enemy.currentEnergy = max(enemy.currentEnergy - GameConfig.stunEnergyCost, 0)

			let stunEffect = Effect(type: .stun, duration: GameConfig.stunDuration)
			effectManager.applyEffect(stunEffect, hero)
						triggerHit(onHero: true)

		}
		checkWinLoseCondition()

	}

	// MARK: Sunder Armor

	func sunderArmor() {

		guard roomGameState.isGameOn else { return }
		guard let hero = roomGameState.hero else { return }
		guard let enemy = roomGameState.enemy else { return }

		if roomGameState.isHeroTurn {

			guard hero.currentEnergy >= GameConfig.sunderArmorCost else { return }
			hero.currentEnergy = max(hero.currentEnergy - GameConfig.sunderArmorCost, 0)
			let impact = actionCalculator.sunderArmor(hero, enemy)
			let sunderEffect = Effect(type: .armorDOWN(value: impact), duration: GameConfig.sunderArmorDuration)
			effectManager.applyEffect(sunderEffect, enemy)
						triggerHit(onHero: false)

		} else {

			guard enemy.currentEnergy >= GameConfig.sunderArmorCost else { return }
			enemy.currentEnergy = max(enemy.currentEnergy - GameConfig.sunderArmorCost, 0)
			let impact = actionCalculator.sunderArmor(enemy, hero)
			let sunderEffect = Effect(type: .armorDOWN(value: impact), duration: GameConfig.sunderArmorDuration)
			effectManager.applyEffect(sunderEffect, hero)
						triggerHit(onHero: true)

		}
		checkWinLoseCondition()
	}

	// MARK: - Spells



	// MARK: Heal

	func heal() {

		guard roomGameState.isGameOn else { return }

		let target = roomGameState.isHeroTurn ? roomGameState.hero : roomGameState.enemy
		guard let target else { return }
		guard target.currentEnergy >= GameConfig.spellEnergyCost,
			  target.currentMana >= GameConfig.healManaCost else {
			return
		}

		let result = actionCalculator.heal(target)
		target.currentHealth = min(target.currentHealth + result, target.maxHealth)
		target.currentMana -= GameConfig.healManaCost
		target.currentEnergy -= GameConfig.spellEnergyCost

		checkWinLoseCondition()
	}

	// MARK: BuffAD

	func buffAD() {

		guard roomGameState.isGameOn else { return }

		let target = roomGameState.isHeroTurn ? roomGameState.hero : roomGameState.enemy
		guard let target else { return }
		guard target.currentEnergy >= GameConfig.spellEnergyCost,
			  target.currentMana >= GameConfig.buffManaCost else {
			return

		}

		let result = actionCalculator.attackUP(target)
		let buff = Effect(type: .attackUP(value: result), duration: 3)
		effectManager.applyEffect(buff, target)

		target.currentMana -= GameConfig.buffManaCost
		target.currentEnergy -= GameConfig.spellEnergyCost

		checkWinLoseCondition()
	}

	// MARK: BuffAD

	func buffArmor() {

		guard roomGameState.isGameOn else { return }

		let target = roomGameState.isHeroTurn ? roomGameState.hero : roomGameState.enemy
		guard let target else { return }
		guard target.currentEnergy >= GameConfig.spellEnergyCost,
			  target.currentMana >= GameConfig.buffManaCost else {
			return

		}

		let result = actionCalculator.armorUP(target)
		let buff = Effect(type: .armorUP(value: result), duration: 3)
		effectManager.applyEffect(buff, target)

		target.currentMana -= GameConfig.buffManaCost
		target.currentEnergy -= GameConfig.spellEnergyCost

		checkWinLoseCondition()
	}

	// MARK: Fireball

	func fireball() {

		guard roomGameState.isGameOn else { return }
		guard let hero = roomGameState.hero else { return }
		guard let enemy = roomGameState.enemy else { return }

		if roomGameState.isHeroTurn {

			guard hero.currentMana >= GameConfig.fireballManaCost else { return }
			let result = actionCalculator.fireball(hero, enemy)
			enemy.currentHealth = max(enemy.currentHealth - result, 0)
			hero.currentMana = max(hero.currentMana - GameConfig.fireballManaCost, 0)
			roomGameState.actionImpact = result
			triggerHit(onHero: false)

		} else {

			guard enemy.currentMana >= GameConfig.fireballManaCost else { return }
			let result = actionCalculator.fireball(enemy, hero)
			hero.currentHealth = max(hero.currentHealth - result, 0)
			enemy.currentMana = max(enemy.currentMana - GameConfig.fireballManaCost, 0)
			roomGameState.actionImpact = result
			triggerHit(onHero: true)
		}
		checkWinLoseCondition()
	}

	// MARK: Exhaustion

	/// Target has decreased amount of current energy in next turn
	func exhaustion() {

		guard roomGameState.isGameOn else { return }
		guard let hero = roomGameState.hero else { return }
		guard let enemy = roomGameState.enemy else { return }

		if roomGameState.isHeroTurn {

			guard hero.currentMana >= GameConfig.exhaustionManaCost else { return }
			hero.currentMana = max(hero.currentMana - GameConfig.exhaustionManaCost, 0)
			let impact = actionCalculator.exhaustion(hero, enemy)
			let exhaustioneffect = Effect(type: .energyDOWN(value: impact), duration: GameConfig.exhaustionDuration)
			effectManager.applyEffect(exhaustioneffect, enemy)
						triggerHit(onHero: false)

		} else {

			guard enemy.currentMana >= GameConfig.exhaustionManaCost else { return }
			enemy.currentMana = max(enemy.currentMana - GameConfig.exhaustionManaCost, 0)
			let impact = actionCalculator.exhaustion(enemy, hero)
			let exhaustioneffect = Effect(type: .energyDOWN(value: impact), duration: GameConfig.exhaustionDuration)
			effectManager.applyEffect(exhaustioneffect, hero)
						triggerHit(onHero: true)

		}
		
		checkWinLoseCondition()
	}

	// MARK: Health Regen

	func healthRegen() {

		guard roomGameState.isGameOn else { return }

		let target = roomGameState.isHeroTurn ? roomGameState.hero : roomGameState.enemy
		guard let target else { return }
		guard target.currentMana >= GameConfig.healthRegenManaCost,
		target.currentEnergy >= GameConfig.spellEnergyCost else {
			return
		}

		let healValue = actionCalculator.healthRegen(target)
		let buff = Effect(type: .healthRegen(initialHeal: healValue, healthPerTurn: healValue), duration: GameConfig.healthRegenDuration)

		effectManager.applyEffect(buff, target)
		target.currentMana = max(target.currentMana - GameConfig.healthRegenManaCost, 0)
		target.currentEnergy = max(target.currentEnergy - GameConfig.spellEnergyCost, 0)

		checkWinLoseCondition()
	}

	// MARK: Mana Regen

	func manaRegen() {

		guard roomGameState.isGameOn else { return }

		let target = roomGameState.isHeroTurn ? roomGameState.hero : roomGameState.enemy
		guard let target else { return }
		guard target.currentMana >= GameConfig.manaRegenManaCost,
		target.currentEnergy >= GameConfig.spellEnergyCost else { return }

		let manaValue = actionCalculator.manaRegen(target)
		let buff = Effect(type: .manaRegen(initialMana: manaValue, manaPerTurn: manaValue), duration: GameConfig.manaRegenDuration)

		effectManager.applyEffect(buff, target)
		target.currentMana = max(target.currentMana - GameConfig.healthRegenManaCost, 0)
		target.currentEnergy = max(target.currentEnergy - GameConfig.spellEnergyCost, 0)

		checkWinLoseCondition()
	}

	// MARK: DoT

	/// Periodic Magic Damage
	func dot() {
		
		guard roomGameState.isGameOn else { return }
		guard let hero = roomGameState.hero else { return }
		guard let enemy = roomGameState.enemy else { return }

		if roomGameState.isHeroTurn {

			guard hero.currentEnergy >= GameConfig.cutEnergyCost else { return }
			hero.currentEnergy = max(hero.currentEnergy - GameConfig.cutEnergyCost, 0)
			let result = actionCalculator.cut(hero, enemy)
			let debuff = Effect(type: .bleeding(initialDamage: result, damagePerTurn: result), duration: 3)
			effectManager.applyEffect(debuff, enemy)
			triggerHit(onHero: false)

		} else {

			guard enemy.currentEnergy >= GameConfig.cutEnergyCost else { return }
			enemy.currentEnergy = max(enemy.currentEnergy - GameConfig.cutEnergyCost, 0)
			let result = actionCalculator.cut(enemy, hero)
			let debuff = Effect(type: .bleeding(initialDamage: result, damagePerTurn: result), duration: 3)
			effectManager.applyEffect(debuff, hero)
			triggerHit(onHero: true)

		}
		checkWinLoseCondition()
	}
}

// MARK: Trigger Hit

extension RoomGameManager {

	// helper to trigger a 1s “hit” animation on the target
	private func triggerHit(onHero: Bool) {

		if onHero {
			roomGameState.heroWasHit = true

		} else {
			roomGameState.enemyWasHit = true
		}
	}

	/// Method to reset isEnemy/isHeroWasHit to false to refresh shaking animation
	/// Called from ViewModel to avoid decoupling
	func resetCharacterBeingHit() {

		roomGameState.enemyWasHit = false
		roomGameState.heroWasHit = false
	}
}
