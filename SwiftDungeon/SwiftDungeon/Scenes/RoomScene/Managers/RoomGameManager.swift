import Foundation

/*

MARK: Example of complete refactoring

func customAttack() {
	 let chars = roomGameState.checkAndReturnHeroAndEnemy -> (Hero, Enemy)
	 let hero = char.hero
	 let enemy = char.enemy

	 ActionHandler -> struct ActionResult { }
	 let actionResult = ActionHandler.attack(hero, enemy)
	 roomGameState.applyActionResult(actionResult))
}
 */

class RoomGameManager {

	// MARK: - Dependencies

	// Any attacks and spells should be treated as actions
	let roomGameState: RoomGameState

	// probably should be used by ActionHandler
	let actionCalculator: ActionCalculator
	let characterManager: CharacterManager
	let effectManager: EffectManager
	let turnManager: TurnManager

	// MARK: Initialization

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

	// should be put to GameState
	func startFight() {

		roomGameState.isGameOn = true
		roomGameState.isHeroTurn = true
		roomGameState.isHeroWon = false
		roomGameState.isGameOver = false
		roomGameState.currentRound = 1
		// should be refactored to "getHero()" from char manager to
		// gameState.instantiateHero(_ hero: Char)
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

	/// Method should be put to the GameState file and return bool when being called
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

	/// Probably should be put to Hero/Enemy class for self mutation
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

		let snapshot = roomGameState.getActualGameStateSnapshot()

		let isHeroTurn = snapshot.isHeroTurn
		guard let hero = snapshot.hero else { return }
		guard let enemy = snapshot.enemy else { return }

		let host = isHeroTurn ? hero : enemy
		let target = isHeroTurn ? enemy : hero

		guard host.currentEnergy >= GameConfig.attackEnergyCost else { return }

		let result = actionCalculator.attack(host, target)

		// Should be refactored to avoid direct state mutation

		target.currentHealth = max(target.currentHealth - result, 0)
		host.currentEnergy -= GameConfig.attackEnergyCost
		
		triggerHit(onHero: !isHeroTurn)

		roomGameState.actionImpact = result

		checkWinLoseCondition()
	}

	// MARK: Block

	func block() {

		guard let snapshot = roomGameState
			.checkIsGameOneCurrentTurnHeroAndEnemy()
		else { return }

		let host = snapshot.host

		guard host.currentEnergy >= GameConfig.blockEnergyCost else { return }

		let blockValue = actionCalculator.block(host)
		let buff = Effect(type: .armorUP(value: blockValue), duration: 3)

		effectManager.applyEffect(buff, host)
		host.currentEnergy -= GameConfig.blockEnergyCost
		

		checkWinLoseCondition()
	}

	// MARK: Cut

	func cut() {

		let snapshot = roomGameState.getActualGameStateSnapshot()

		let isHeroTurn = snapshot.isHeroTurn
		guard let hero = snapshot.hero else { return }
		guard let enemy = snapshot.enemy else { return }

		let host = isHeroTurn ? hero : enemy
		let target = isHeroTurn ? enemy : hero

		guard host.currentEnergy >= GameConfig.cutEnergyCost else { return }

		host.currentEnergy = max(host.currentEnergy - GameConfig.cutEnergyCost, 0)

		let result = actionCalculator.cut(host, target)
		let debuff = Effect(type: .bleeding(initialDamage: result, damagePerTurn: result), duration: 3)

		effectManager.applyEffect(debuff, target)

		triggerHit(onHero: !isHeroTurn)

		roomGameState.actionImpact = result

		checkWinLoseCondition()
	}

	// MARK: Stun

	func stun() {

		let snapshot = roomGameState.getActualGameStateSnapshot()

		let isHeroTurn = snapshot.isHeroTurn
		guard let hero = snapshot.hero else { return }
		guard let enemy = snapshot.enemy else { return }

		let host = isHeroTurn ? hero : enemy
		let target = isHeroTurn ? enemy : hero

		guard host.currentEnergy >= GameConfig.stunEnergyCost else { return }

		host.currentEnergy = max(host.currentEnergy - GameConfig.stunEnergyCost, 0)

		let stunEffect = Effect(type: .stun, duration: GameConfig.stunDuration)

		effectManager.applyEffect(stunEffect, target)

		triggerHit(onHero: !isHeroTurn)

		roomGameState.actionImpact = 0

		checkWinLoseCondition()
	}

	// MARK: Sunder Armor

	func sunderArmor() {

		let snapshot = roomGameState.getActualGameStateSnapshot()

		let isHeroTurn = snapshot.isHeroTurn
		guard let hero = snapshot.hero else { return }
		guard let enemy = snapshot.enemy else { return }

		let host = isHeroTurn ? hero : enemy
		let target = isHeroTurn ? enemy : hero

		guard host.currentEnergy >= GameConfig.sunderArmorCost else { return }

		host.currentEnergy = max(host.currentEnergy - GameConfig.sunderArmorCost, 0)
		let impact = actionCalculator.sunderArmor(host, target)
		let sunderEffect = Effect(type: .armorDOWN(value: impact),
								  duration: GameConfig.sunderArmorDuration)

		effectManager.applyEffect(sunderEffect, target)

		triggerHit(onHero: !isHeroTurn)

		roomGameState.actionImpact = 0

		checkWinLoseCondition()


	}

	// MARK: - Spells



	// MARK: Heal

	func heal() {

		guard let snapshot = roomGameState
			.checkIsGameOneCurrentTurnHeroAndEnemy()
		else { return }

		let host = snapshot.host

		guard host.currentEnergy >= GameConfig.spellEnergyCost,
			  host.currentMana >= GameConfig.healManaCost else {
			return
		}

		let result = actionCalculator.heal(host)
		host.currentHealth = min(host.currentHealth + result, host.maxHealth)
		host.currentMana -= GameConfig.healManaCost
		host.currentEnergy -= GameConfig.spellEnergyCost

		checkWinLoseCondition()
	}

	// MARK: BuffAD

	func buffAD() {

		guard let snapshot = roomGameState
			.checkIsGameOneCurrentTurnHeroAndEnemy()
		else { return }

		let host = snapshot.host

		guard host.currentEnergy >= GameConfig.spellEnergyCost,
			  host.currentMana >= GameConfig.buffManaCost else {
			return

		}

		let result = actionCalculator.attackUP(host)
		let buff = Effect(type: .attackUP(value: result), duration: 3)
		effectManager.applyEffect(buff, host)

		host.currentMana -= GameConfig.buffManaCost
		host.currentEnergy -= GameConfig.spellEnergyCost

		checkWinLoseCondition()
	}

	// MARK: Buff Armor

	func buffArmor() {

		guard let snapshot = roomGameState
			.checkIsGameOneCurrentTurnHeroAndEnemy()
		else { return }

		let host = snapshot.host

		guard host.currentEnergy >= GameConfig.spellEnergyCost,
			  host.currentMana >= GameConfig.buffManaCost else {
			return

		}

		let result = actionCalculator.armorUP(host)
		let buff = Effect(type: .armorUP(value: result), duration: 3)
		effectManager.applyEffect(buff, host)

		host.currentMana -= GameConfig.buffManaCost
		host.currentEnergy -= GameConfig.spellEnergyCost

		checkWinLoseCondition()
	}

	// MARK: Fireball

	func fireball() {

		let snapshot = roomGameState.getActualGameStateSnapshot()

		let isHeroTurn = snapshot.isHeroTurn
		guard let hero = snapshot.hero else { return }
		guard let enemy = snapshot.enemy else { return }

		let host = isHeroTurn ? hero : enemy
		let target = isHeroTurn ? enemy : hero

		guard host.currentMana >= GameConfig.fireballManaCost,
			  host.currentEnergy >= GameConfig.spellEnergyCost else {
			return
		}

		let result = actionCalculator.fireball(host, target)
		target.currentHealth = max(target.currentHealth - result, 0)
		host.currentMana = max(host.currentMana - GameConfig.fireballManaCost, 0)
		host.currentEnergy = max(host.currentEnergy - GameConfig.spellEnergyCost, 0)

		triggerHit(onHero: !isHeroTurn)

		roomGameState.actionImpact = result

		checkWinLoseCondition()

	}

	// MARK: Exhaustion

	/// Target has decreased amount of current energy in next turn
	func exhaustion() {

		let snapshot = roomGameState.getActualGameStateSnapshot()

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
		let impact = actionCalculator.exhaustion(host, target)
		let exhaustioneffect = Effect(type: .energyDOWN(value: impact), duration: GameConfig.exhaustionDuration)
		effectManager.applyEffect(exhaustioneffect, target)

		triggerHit(onHero: !isHeroTurn)

		roomGameState.actionImpact = 0

		checkWinLoseCondition()

	}

	// MARK: Health Regen

	func healthRegen() {

		guard let snapshot = roomGameState
			.checkIsGameOneCurrentTurnHeroAndEnemy()
		else { return }

		let host = snapshot.host

		guard host.currentMana >= GameConfig.healthRegenManaCost,
			  host.currentEnergy >= GameConfig.spellEnergyCost else {
			return
		}

		let healValue = actionCalculator.healthRegen(host)
		let buff = Effect(type: .healthRegen(initialHeal: healValue, healthPerTurn: healValue), duration: GameConfig.healthRegenDuration)

		effectManager.applyEffect(buff, host)
		host.currentMana = max(host.currentMana - GameConfig.healthRegenManaCost, 0)
		host.currentEnergy = max(host.currentEnergy - GameConfig.spellEnergyCost, 0)

		checkWinLoseCondition()
	}

	// MARK: Mana Regen

	func manaRegen() {

		guard let snapshot = roomGameState
			.checkIsGameOneCurrentTurnHeroAndEnemy()
		else { return }

		let host = snapshot.host

		guard host.currentMana >= GameConfig.manaRegenManaCost,
			  host.currentEnergy >= GameConfig.spellEnergyCost else { return }

		let manaValue = actionCalculator.manaRegen(host)
		let buff = Effect(type: .manaRegen(initialMana: manaValue, manaPerTurn: manaValue), duration: GameConfig.manaRegenDuration)

		effectManager.applyEffect(buff, host)
		host.currentMana = max(host.currentMana - GameConfig.healthRegenManaCost, 0)
		host.currentEnergy = max(host.currentEnergy - GameConfig.spellEnergyCost, 0)

		checkWinLoseCondition()
	}

	// MARK: DoT

	/// Periodic Magic Damage
	func dot() {

		guard let snapshot = roomGameState
			.checkIsGameOneCurrentTurnHeroAndEnemy()
		else { return }

		let host = snapshot.host
		let target = snapshot.target
		let isHeroTurn = snapshot.isHeroTurn

		guard host.currentMana >= GameConfig.dotManaCost,
			  host.currentEnergy >= GameConfig.spellEnergyCost else {
			return
		}

		host.currentEnergy = max(host.currentEnergy - GameConfig.spellEnergyCost, 0)
		host.currentMana = max(host.currentMana - GameConfig.dotManaCost, 0)

		let result = actionCalculator.dot(host, target)
		let debuff = Effect(type: .bleeding(initialDamage: result, damagePerTurn: result), duration: 3)
		effectManager.applyEffect(debuff, target)

		triggerHit(onHero: !isHeroTurn)

		roomGameState.actionImpact = result

		checkWinLoseCondition()
	}

}

// MARK: Trigger/Reset TargetBeingHit

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
