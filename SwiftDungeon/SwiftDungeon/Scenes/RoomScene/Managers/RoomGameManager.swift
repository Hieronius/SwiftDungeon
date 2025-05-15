import Foundation

class RoomGameManager {

	// MARK: - Dependencies

	let roomGameState: RoomGameState
	let actionHandler: ActionHandler
	let actionCalculator: ActionCalculator
	let characterManager: CharacterManager
	let effectManager: EffectManager
	let turnManager: TurnManager

	// MARK: Initialization

	init(
		roomGameState: RoomGameState,
		actionHandler: ActionHandler,
		actionCalculator: ActionCalculator,
		characterManager: CharacterManager,
		effectManager: EffectManager,
		turnManager: TurnManager
	) {
		self.roomGameState = roomGameState
		self.actionHandler = actionHandler
		self.actionCalculator = actionCalculator
		self.characterManager = characterManager
		self.effectManager = effectManager
		self.turnManager = turnManager

	}

}

// MARK: - Game Options

extension RoomGameManager {
	
	func pauseGame() {
		var snapshot = roomGameState.getActualGameStateSnapshot()
		snapshot.isGameOn = false
		roomGameState.applyNewGameStateSnapshot(snapshot)
	}
	
	func resumeGame() {
		var snapshot = roomGameState.getActualGameStateSnapshot()
		snapshot.isGameOn = true
		roomGameState.applyNewGameStateSnapshot(snapshot)
	}
}

// MARK: - Game Flow States

extension RoomGameManager {

	// should be put to GameState
	func startFight() {

		var snapshot = roomGameState.getActualGameStateSnapshot()

		snapshot.isGameOn = true
		snapshot.isHeroTurn = true
		snapshot.isHeroWon = false
		snapshot.isGameOver = false
		snapshot.currentRound = 1
		// should be refactored to "getHero()" from char manager to
		// gameState.instantiateHero(_ hero: Char)
		snapshot.hero = characterManager.setupHero()
		snapshot.enemyIndex = 0
		let position = snapshot.enemyIndex
		snapshot.enemy = characterManager.spawnEnemy(at: position)

		roomGameState.applyNewGameStateSnapshot(snapshot)

		checkWinLoseCondition()


	}

	// MARK: EndTurn

	func endTurn() {

		var snapshot = roomGameState.getActualGameStateSnapshot()

		guard snapshot.isGameOn else { return }

		if !snapshot.isHeroTurn {

			snapshot.currentRound += 1
			guard let hero = snapshot.hero else { return }
			hero.currentEnergy = hero.maxEnergy

			effectManager.processEffectsAtTurnStart(hero)

			if hero.isStunned {

				DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {

					snapshot.isHeroTurn.toggle()
					self.checkWinLoseCondition()

					self.endTurn()
				}

			} else {

				snapshot.isHeroTurn.toggle()
				checkWinLoseCondition()

			}

		} else if snapshot.isHeroTurn {

			guard let enemy = snapshot.enemy else { return }
			enemy.currentEnergy = enemy.maxEnergy

			effectManager.processEffectsAtTurnStart(enemy)

			if enemy.isStunned {

				DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
					snapshot.isHeroTurn.toggle()
					self.checkWinLoseCondition()

					self.endTurn()
				}

			} else {

				snapshot.isHeroTurn.toggle()
				checkWinLoseCondition()

			}
		}

		roomGameState.applyNewGameStateSnapshot(snapshot)

	}

	// MARK: Check Win/Lose Condition

	/// Method should be put to the GameState file and return bool when being called
	func checkWinLoseCondition() {

		var snapshot = roomGameState.getActualGameStateSnapshot()

		guard let hero = snapshot.hero else { return }
		guard let enemy = snapshot.enemy else { return }

		if snapshot.currentRoom > GameConfig.dungeonLength {
			snapshot.isGameCompleted = true
			snapshot.isGameOn = false
			return
		}

		if hero.currentHealth < 1 {
			snapshot.isGameOn = false
			snapshot.isGameOver = true
			startFight()

		} else if enemy.currentHealth < 1 {

			snapshot.isGameOn = false
			snapshot.isHeroWon = true
			let experience = snapshot.currentRoom * GameConfig.expPerRoom
			if (hero.stats.currentExperience + experience) >= hero.stats.maxExperience {
				heroLevelUP()
			} else {
				hero.stats.currentExperience += experience
			}
			roomGameState.applyNewGameStateSnapshot(snapshot)
			enterNewRoom()
		}
	}

	// MARK: Enter New Room

	// Should be put to the GameState
	func enterNewRoom() {

		var snapshot = roomGameState.getActualGameStateSnapshot()

		snapshot.currentRoom += 1
		snapshot.isGameOn = true
		snapshot.isHeroTurn = true
		snapshot.isHeroWon = false
		snapshot.isGameOver = false
		snapshot.currentRound = 1
		snapshot.enemyIndex += 1
		let position = snapshot.enemyIndex
		snapshot.enemy = characterManager.spawnEnemy(at: position)

		restoreCharacter(isHeroTurn: false)
		roomGameState.applyNewGameStateSnapshot(snapshot)
	}
}

// MARK: - Hero Updates

extension RoomGameManager {

	/// Probably should be put to Hero/Enemy class for self mutation
	func heroLevelUP() {

		let snapshot = roomGameState.getActualGameStateSnapshot()

		guard let hero = snapshot.hero else { return }

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


	}

	func restoreCharacter(isHeroTurn: Bool) {

		let snapshot = roomGameState.getActualGameStateSnapshot()

		let target = isHeroTurn ? snapshot.hero : snapshot.enemy
		guard let target else { return }
		target.currentHealth = target.maxHealth
		target.currentMana = target.maxMana
		target.currentEnergy = target.maxEnergy
	}
}

// MARK: - Fight Mechanics

extension RoomGameManager {

	// MARK: Impact Mechanic

	func actionImpactAndTarget() -> (Bool, Int) {

		let snapshot = roomGameState.getActualGameStateSnapshot()
		let impact = snapshot.actionImpact
		let target = snapshot.isHeroTurn
		return (target, impact)
	}

	// MARK: - Actions


	// MARK: Attack

	func attack() {

		var snapshot = roomGameState.getActualGameStateSnapshot()

		let isHeroTurn = snapshot.isHeroTurn
		guard let hero = snapshot.hero else { return }
		guard let enemy = snapshot.enemy else { return }

		let host = isHeroTurn ? hero : enemy
		let target = isHeroTurn ? enemy : hero

		guard host.currentEnergy >= GameConfig.attackEnergyCost else { return }

		let result = actionHandler.attack(host, target)
		let damage = result.impact

		// Should be refactored to avoid direct state mutation

		// MARK: Probably should be added to snapshot to return

		target.currentHealth = max(target.currentHealth - damage, 0)
		host.currentEnergy -= GameConfig.attackEnergyCost

		snapshot.actionImpact = damage

		roomGameState.applyNewGameStateSnapshot(snapshot)

		triggerHit(onHero: !isHeroTurn)

		checkWinLoseCondition()
	}

	// MARK: Block

	func block() {

		let snapshot = roomGameState.getActualGameStateSnapshot()

		let isHeroTurn = snapshot.isHeroTurn
		guard let hero = snapshot.hero else { return }
		guard let enemy = snapshot.enemy else { return }

		let host = isHeroTurn ? hero : enemy

		guard host.currentEnergy >= GameConfig.blockEnergyCost else { return }

		let result = actionHandler.block(host)
		let blockValue = result.impact
		let buff = Effect(type: .armorUP(value: blockValue), duration: 3)

		effectManager.applyEffect(buff, host)
		host.currentEnergy -= GameConfig.blockEnergyCost

		checkWinLoseCondition()
	}

	// MARK: Cut

	func cut() {

		var snapshot = roomGameState.getActualGameStateSnapshot()

		let isHeroTurn = snapshot.isHeroTurn
		guard let hero = snapshot.hero else { return }
		guard let enemy = snapshot.enemy else { return }

		let host = isHeroTurn ? hero : enemy
		let target = isHeroTurn ? enemy : hero

		guard host.currentEnergy >= GameConfig.cutEnergyCost else { return }

		host.currentEnergy = max(host.currentEnergy - GameConfig.cutEnergyCost, 0)

		let result = actionHandler.cut(host, target)
		let impact = result.impact

		let debuff = Effect(type: .bleeding(initialDamage: impact, damagePerTurn: impact), duration: 3)

		effectManager.applyEffect(debuff, target)

		snapshot.actionImpact = impact

		roomGameState.applyNewGameStateSnapshot(snapshot)

		triggerHit(onHero: !isHeroTurn)

		checkWinLoseCondition()
	}

	// MARK: Stun

	func stun() {

		var snapshot = roomGameState.getActualGameStateSnapshot()

		let isHeroTurn = snapshot.isHeroTurn
		guard let hero = snapshot.hero else { return }
		guard let enemy = snapshot.enemy else { return }

		let host = isHeroTurn ? hero : enemy
		let target = isHeroTurn ? enemy : hero

		guard host.currentEnergy >= GameConfig.stunEnergyCost else { return }

		host.currentEnergy = max(host.currentEnergy - GameConfig.stunEnergyCost, 0)

		let stunEffect = Effect(type: .stun, duration: GameConfig.stunDuration)

		effectManager.applyEffect(stunEffect, target)

		snapshot.actionImpact = 0

		roomGameState.applyNewGameStateSnapshot(snapshot)

		triggerHit(onHero: !isHeroTurn)

		checkWinLoseCondition()
	}

	// MARK: Sunder Armor

	func sunderArmor() {

		var snapshot = roomGameState.getActualGameStateSnapshot()

		let isHeroTurn = snapshot.isHeroTurn
		guard let hero = snapshot.hero else { return }
		guard let enemy = snapshot.enemy else { return }

		let host = isHeroTurn ? hero : enemy
		let target = isHeroTurn ? enemy : hero

		guard host.currentEnergy >= GameConfig.sunderArmorCost else { return }

		host.currentEnergy = max(host.currentEnergy - GameConfig.sunderArmorCost, 0)

		let result = actionHandler.sunderArmor(host, target)
		let impact = result.impact

		let sunderEffect = Effect(type: .armorDOWN(value: impact),
								  duration: GameConfig.sunderArmorDuration)

		effectManager.applyEffect(sunderEffect, target)

		snapshot.actionImpact = impact

		roomGameState.applyNewGameStateSnapshot(snapshot)

		triggerHit(onHero: !isHeroTurn)

		checkWinLoseCondition()
	}

	// MARK: - Spells



	// MARK: Heal

	func heal() {

		let snapshot = roomGameState.getActualGameStateSnapshot()

		let isHeroTurn = snapshot.isHeroTurn
		guard let hero = snapshot.hero else { return }
		guard let enemy = snapshot.enemy else { return }

		let host = isHeroTurn ? hero : enemy

		let result = actionHandler.heal(host)
		let healValue = result.impact

		host.currentHealth = min(host.currentHealth + healValue, host.maxHealth)
		host.currentMana -= GameConfig.healManaCost
		host.currentEnergy -= GameConfig.spellEnergyCost

		roomGameState.applyNewGameStateSnapshot(snapshot)

		checkWinLoseCondition()
	}

	// MARK: AttackUP

	func attackUP() {

		let snapshot = roomGameState.getActualGameStateSnapshot()

		let isHeroTurn = snapshot.isHeroTurn
		guard let hero = snapshot.hero else { return }
		guard let enemy = snapshot.enemy else { return }

		let host = isHeroTurn ? hero : enemy

		let result = actionHandler.attackUP(host)
		let impact = result.impact

		let buff = Effect(type: .attackUP(value: impact), duration: 3)
		effectManager.applyEffect(buff, host)

		host.currentMana -= GameConfig.buffManaCost
		host.currentEnergy -= GameConfig.spellEnergyCost

		roomGameState.applyNewGameStateSnapshot(snapshot)

		checkWinLoseCondition()
	}

	// MARK: ArmorUP

	func armorUP() {

		let snapshot = roomGameState.getActualGameStateSnapshot()

		let isHeroTurn = snapshot.isHeroTurn
		guard let hero = snapshot.hero else { return }
		guard let enemy = snapshot.enemy else { return }

		let host = isHeroTurn ? hero : enemy

		guard host.currentEnergy >= GameConfig.spellEnergyCost,
			  host.currentMana >= GameConfig.buffManaCost else {
			return

		}

		let result = actionHandler.armorUP(host)
		let impact = result.impact

		let buff = Effect(type: .armorUP(value: impact), duration: 3)
		effectManager.applyEffect(buff, host)

		host.currentMana -= GameConfig.buffManaCost
		host.currentEnergy -= GameConfig.spellEnergyCost

		roomGameState.applyNewGameStateSnapshot(snapshot)

		checkWinLoseCondition()
	}

	// MARK: Fireball

	func fireball() {

		var snapshot = roomGameState.getActualGameStateSnapshot()

		let isHeroTurn = snapshot.isHeroTurn
		guard let hero = snapshot.hero else { return }
		guard let enemy = snapshot.enemy else { return }

		let host = isHeroTurn ? hero : enemy
		let target = isHeroTurn ? enemy : hero

		guard host.currentMana >= GameConfig.fireballManaCost,
			  host.currentEnergy >= GameConfig.spellEnergyCost else {
			return
		}

		let result = actionHandler.fireball(host, target)
		let impact = result.impact

		target.currentHealth = max(target.currentHealth - impact, 0)
		host.currentMana = max(host.currentMana - GameConfig.fireballManaCost, 0)
		host.currentEnergy = max(host.currentEnergy - GameConfig.spellEnergyCost, 0)

		snapshot.actionImpact = impact

		roomGameState.applyNewGameStateSnapshot(snapshot)

		triggerHit(onHero: !isHeroTurn)

		checkWinLoseCondition()

	}

	// MARK: Exhaustion

	/// Target has decreased amount of current energy in next turn
	func exhaustion() {

		var snapshot = roomGameState.getActualGameStateSnapshot()

		let isHeroTurn = snapshot.isHeroTurn
		guard let hero = snapshot.hero else { return }
		guard let enemy = snapshot.enemy else { return }

		let host = isHeroTurn ? hero : enemy
		let target = isHeroTurn ? enemy : hero

		guard host.currentMana >= GameConfig.exhaustionManaCost,
			  host.currentEnergy >= GameConfig.spellEnergyCost else {
			return
		}

		host.currentMana = max(host.currentMana - GameConfig.exhaustionManaCost, 0)
		host.currentEnergy = max(host.currentEnergy - GameConfig.spellEnergyCost, 0)

		let result = actionHandler.exhaustion(host, target)
		let impact = result.impact

		let exhaustioneffect = Effect(type: .energyDOWN(value: impact), duration: GameConfig.exhaustionDuration)
		effectManager.applyEffect(exhaustioneffect, target)

		snapshot.actionImpact = 0

		roomGameState.applyNewGameStateSnapshot(snapshot)

		triggerHit(onHero: !isHeroTurn)

		checkWinLoseCondition()

	}

	// MARK: Health Regen

	func healthRegen() {

		let snapshot = roomGameState.getActualGameStateSnapshot()

		let isHeroTurn = snapshot.isHeroTurn
		guard let hero = snapshot.hero else { return }
		guard let enemy = snapshot.enemy else { return }

		let host = isHeroTurn ? hero : enemy

		guard host.currentMana >= GameConfig.healthRegenManaCost,
			  host.currentEnergy >= GameConfig.spellEnergyCost else {
			return
		}

		let result = actionHandler.healthRegen(host)
		let impact = result.impact

		let buff = Effect(type: .healthRegen(initialHeal: impact, healthPerTurn: impact), duration: GameConfig.healthRegenDuration)

		effectManager.applyEffect(buff, host)
		host.currentMana = max(host.currentMana - GameConfig.healthRegenManaCost, 0)
		host.currentEnergy = max(host.currentEnergy - GameConfig.spellEnergyCost, 0)

		roomGameState.applyNewGameStateSnapshot(snapshot)

		checkWinLoseCondition()
	}

	// MARK: Mana Regen

	func manaRegen() {

		let snapshot = roomGameState.getActualGameStateSnapshot()

		let isHeroTurn = snapshot.isHeroTurn
		guard let hero = snapshot.hero else { return }
		guard let enemy = snapshot.enemy else { return }

		let host = isHeroTurn ? hero : enemy

		guard host.currentMana >= GameConfig.manaRegenManaCost,
			  host.currentEnergy >= GameConfig.spellEnergyCost else { return }

		let result = actionHandler.manaRegen(host)
		let impact = result.impact

		let buff = Effect(type: .manaRegen(initialMana: impact, manaPerTurn: impact), duration: GameConfig.manaRegenDuration)

		effectManager.applyEffect(buff, host)
		host.currentMana = max(host.currentMana - GameConfig.healthRegenManaCost, 0)
		host.currentEnergy = max(host.currentEnergy - GameConfig.spellEnergyCost, 0)

		roomGameState.applyNewGameStateSnapshot(snapshot)

		checkWinLoseCondition()
	}

	// MARK: DoT

	/// Periodic Magic Damage
	func dot() {

		var snapshot = roomGameState.getActualGameStateSnapshot()

		let isHeroTurn = snapshot.isHeroTurn
		guard let hero = snapshot.hero else { return }
		guard let enemy = snapshot.enemy else { return }

		let host = isHeroTurn ? hero : enemy
		let target = isHeroTurn ? enemy : hero

		guard host.currentMana >= GameConfig.dotManaCost,
			  host.currentEnergy >= GameConfig.spellEnergyCost else {
			return
		}

		host.currentEnergy = max(host.currentEnergy - GameConfig.spellEnergyCost, 0)
		host.currentMana = max(host.currentMana - GameConfig.dotManaCost, 0)

		let result = actionHandler.dot(host, target)
		let impact = result.impact
		let debuff = Effect(type: .bleeding(initialDamage: impact, damagePerTurn: impact), duration: 3)
		effectManager.applyEffect(debuff, target)

		snapshot.actionImpact = impact

		roomGameState.applyNewGameStateSnapshot(snapshot)

		triggerHit(onHero: !isHeroTurn)

		checkWinLoseCondition()
	}

}

// MARK: Trigger/Reset TargetBeingHit

extension RoomGameManager {

	// helper to trigger a 1s “hit” animation on the target
	private func triggerHit(onHero: Bool) {

		var snapshot = roomGameState.getActualGameStateSnapshot()

		if onHero {
			snapshot.heroWasHit = true

		} else {
			snapshot.enemyWasHit = true
		}

		roomGameState.applyNewGameStateSnapshot(snapshot)
	}

	/// Method to reset isEnemy/isHeroWasHit to false to refresh shaking animation
	/// Called from ViewModel to avoid decoupling
	func resetCharacterBeingHit() {

		var snapshot = roomGameState.getActualGameStateSnapshot()

		snapshot.enemyWasHit = false
		snapshot.heroWasHit = false

		roomGameState.applyNewGameStateSnapshot(snapshot)
	}
}
