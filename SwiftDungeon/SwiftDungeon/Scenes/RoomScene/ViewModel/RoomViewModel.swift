import SwiftUI

class RoomViewModel: ObservableObject {

	// MARK: - Dependencies

	private let gameState: GameState
	private let combatManager: CombatManager
	private let characterManager: CharacterManager
	private let effectManager: EffectManager

	// MARK: - Published Properties

	@Published var roomState: RoomState
	@Published var heroState: HeroState
	@Published var enemyState: EnemyState

	// Utility

	@Published var heroEffectColor: Color? = nil
	@Published var enemyEffectColor: Color? = nil

	// MARK: - Initialization

	init(gameState: GameState,
		 combatManager: CombatManager,
		 characterManager: CharacterManager,
		 effectManager: EffectManager) {

		self.gameState = gameState
		self.combatManager = combatManager
		self.characterManager = characterManager
		self.effectManager = effectManager

		self.roomState = RoomState()

		self.heroState = HeroState(
			heroCurrentLevel: gameState.hero?.stats.level ?? 0,
			heroMaxHealth: gameState.hero?.maxHealth ?? 0,
			heroCurrentHealth: gameState.hero?.currentHealth ?? 0,
			heroMaxMana: gameState.hero?.maxMana ?? 0,
			heroCurrentMana: gameState.hero?.currentMana ?? 0,
			heroMaxEnergy: gameState.hero?.maxEnergy ?? 0,
			heroCurrentEnergy: gameState.hero?.currentEnergy ?? 0,
			heroCurrentExperience: gameState.hero?.stats.currentExperience ?? 0,
			heroMaxExperience: gameState.hero?.stats.maxExperience ?? 0,
			heroActionColor: .white,
			heroActionLabel: 99,
			heroActiveEffects: gameState.hero?.activeEffects ?? []
		)

		self.enemyState = EnemyState(
			enemyCurrentLevel: gameState.enemy?.stats.level ?? 0,
			enemyMaxHealth: gameState.enemy?.maxHealth ?? 0,
			enemyCurrentHealth: gameState.enemy?.currentHealth ?? 0,
			enemyMaxMana: gameState.enemy?.maxMana ?? 0,
			enemyCurrentMana: gameState.enemy?.currentMana ?? 0,
			enemyMaxEnergy: gameState.enemy?.maxEnergy ?? 0,
			enemyCurrentEnergy: gameState.enemy?.currentEnergy ?? 0,
			enemyActionColor: .white,
			enemyActionLabel: 100,
			enemyActiveEffects: gameState.enemy?.activeEffects ?? []
		)
	}
}

// MARK: - Sync Game State

extension RoomViewModel {

	func syncGameState() {

		// Save/Load function can be implemented here

		roomState = RoomState(
			currentRoom: gameState.currentRoom,
			currentRound: gameState.currentRound,
			isHeroTurn: gameState.isHeroTurn,
			heroWasHit: roomState.heroWasHit,
			enemyWasHit: roomState.enemyWasHit
		)

		guard let hero = gameState.hero else { return }
		guard let enemy = gameState.enemy else { return }

		heroState = HeroState(
			heroCurrentLevel: hero.stats.level,
			heroMaxHealth: hero.maxHealth,
			heroCurrentHealth: hero.currentHealth,
			heroMaxMana: hero.maxMana,
			heroCurrentMana: hero.currentMana,
			heroMaxEnergy: hero.maxEnergy,
			heroCurrentEnergy: hero.currentEnergy,
			heroCurrentExperience: hero.stats.currentExperience,
			heroMaxExperience: hero.stats.maxExperience,
			heroActionColor: heroState.heroActionColor,
			heroActionLabel: heroState.heroActionLabel,
			heroActiveEffects: hero.activeEffects
		)

		enemyState = EnemyState(
			enemyCurrentLevel: enemy.stats.level,
			enemyMaxHealth: enemy.maxHealth,
			enemyCurrentHealth: enemy.currentHealth,
			enemyMaxMana: enemy.maxMana,
			enemyCurrentMana: enemy.currentMana,
			enemyMaxEnergy: enemy.maxEnergy,
			enemyCurrentEnergy: enemy.currentEnergy,
			enemyActionColor: enemyState.enemyActionColor,
			enemyActionLabel: enemyState.enemyActionLabel,
			enemyActiveEffects: enemy.activeEffects
		)
	}
}

// MARK: - Game Options

extension RoomViewModel {

	func pauseGame() {
		gameState.isGameOn = false
	}

	func resumeGame() {
		gameState.isGameOn = true
	}
}

// MARK: - Game Flow States

extension RoomViewModel {

	func startFight() {

		gameState.isGameOn = true
		gameState.isHeroTurn = true
		gameState.isHeroWon = false
		gameState.isGameOver = false
		gameState.currentRound = 1
		gameState.hero = characterManager.setupHero()
		gameState.enemyIndex = 0
		let position = gameState.enemyIndex
		gameState.enemy = characterManager.spawnEnemy(at: position)

		syncGameState()
	}

	func endTurn() {

		guard gameState.isGameOn else { return }

		if !gameState.isHeroTurn {

			gameState.currentRound += 1
			guard let hero = gameState.hero else { return }
			hero.currentEnergy = hero.maxEnergy

			effectManager.processEffectsAtTurnStart(hero)

			if hero.isStunned {

				DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {

					self.gameState.isHeroTurn.toggle()
					self.checkWinLoseCondition()

					self.syncGameState()
					self.endTurn()
				}

			} else {

				gameState.isHeroTurn.toggle()
				checkWinLoseCondition()

				syncGameState()
			}

		} else if gameState.isHeroTurn {

			guard let enemy = gameState.enemy else { return }
			enemy.currentEnergy = enemy.maxEnergy

			effectManager.processEffectsAtTurnStart(enemy)

			if enemy.isStunned {

				DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
					self.gameState.isHeroTurn.toggle()
					self.checkWinLoseCondition()

					self.syncGameState()
					self.endTurn()
				}

			} else {

				gameState.isHeroTurn.toggle()
				checkWinLoseCondition()

				syncGameState()
			}
		}

	}

	func checkWinLoseCondition() {

		guard let hero = gameState.hero else { return }
		guard let enemy = gameState.enemy else { return }

		if gameState.currentRoom > GameConfig.dungeonLength {
			gameState.isGameCompleted = true
			gameState.isGameOn = false
			return
		}

		if hero.currentHealth < 1 {
			gameState.isGameOn = false
			gameState.isGameOver = true
			startFight()

		} else if enemy.currentHealth < 1 {

			gameState.isGameOn = false
			gameState.isHeroWon = true
			let experience = roomState.currentRoom * GameConfig.expPerRoom
			if (heroState.heroCurrentExperience + experience) >= hero.stats.maxExperience {
				heroLevelUP()
			} else {
				hero.stats.currentExperience += experience
			}
			enterNewRoom()
		}

		syncGameState()
	}

	func enterNewRoom() {

		gameState.currentRoom += 1
		gameState.isGameOn = true
		gameState.isHeroTurn = true
		gameState.isHeroWon = false
		gameState.isGameOver = false
		gameState.currentRound = 1
		restoreCharacter(isHeroTurn: true)
		gameState.enemyIndex += 1
		let position = gameState.enemyIndex
		gameState.enemy = characterManager.spawnEnemy(at: position)

		syncGameState()
	}
}

// MARK: - Hero Updates

extension RoomViewModel {

	func heroLevelUP() {
		
		guard let hero = gameState.hero else { return }

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

		syncGameState()
	}

	func restoreCharacter(isHeroTurn: Bool) {

		let target = isHeroTurn ? gameState.hero : gameState.enemy
		guard let target else { return }
		target.currentHealth = target.maxHealth
		target.currentMana = target.maxMana
		target.currentEnergy = target.maxEnergy

		syncGameState()
	}
}

// MARK: - Fight Mechanics

extension RoomViewModel {

	func attack() {

		guard gameState.isGameOn else { return }
		guard let hero = gameState.hero else { return }
		guard let enemy = gameState.enemy else { return }

		if gameState.isHeroTurn {

			guard hero.currentEnergy >= GameConfig.attackEnergyCost else { return }
			let result = combatManager.attack(hero, enemy)
			enemy.currentHealth = max(enemy.currentHealth - result, 0)
			hero.currentEnergy -= GameConfig.attackEnergyCost
			passActionVisualResult(.red, result)
			triggerHit(onHero: false)

		} else {

			guard enemy.currentEnergy >= GameConfig.attackEnergyCost else { return }
			let result = combatManager.attack(enemy, hero)
			hero.currentHealth = max(hero.currentHealth - result, 0)
			enemy.currentEnergy -= GameConfig.attackEnergyCost
			passActionVisualResult(.red, result)
			triggerHit(onHero: true)

		}
		checkWinLoseCondition()

		syncGameState()
	}

	func block() {

		guard gameState.isGameOn else { return }

		let target = gameState.isHeroTurn ? gameState.hero : gameState.enemy
		guard let target else { return }
		guard target.currentEnergy >= GameConfig.blockEnergyCost else { return }

		let isHero = gameState.isHeroTurn
		triggerEffect(forHero: isHero, color: .blue)

		let blockValue = combatManager.block(target)
		let buff = Effect(type: .armorUP(value: blockValue), duration: 3)

		effectManager.applyEffect(buff, target)
		target.currentEnergy -= GameConfig.blockEnergyCost

		syncGameState()
	}

	func heal() {

		guard gameState.isGameOn else { return }

		let target = gameState.isHeroTurn ? gameState.hero : gameState.enemy
		guard let target else { return }
		guard target.currentEnergy >= GameConfig.spellEnergyCost,
			  target.currentMana >= GameConfig.healManaCost else {
			return
		}
		let isHero = gameState.isHeroTurn
		triggerEffect(forHero: isHero, color: .green)

		let result = combatManager.heal(target)
		target.currentHealth = min(target.currentHealth + result, target.maxHealth)
		target.currentMana -= GameConfig.healManaCost
		target.currentEnergy -= GameConfig.spellEnergyCost

		syncGameState()
	}

	func buffAD() {

		guard gameState.isGameOn else { return }

		let target = gameState.isHeroTurn ? gameState.hero : gameState.enemy
		guard let target else { return }
		guard target.currentEnergy >= GameConfig.spellEnergyCost,
			  target.currentMana >= GameConfig.buffManaCost else {
			return

		}

		let isHero = gameState.isHeroTurn
		triggerEffect(forHero: isHero, color: .yellow)

		let result = combatManager.attackUP(target)
		let buff = Effect(type: .attackUP(value: result), duration: 3)
		effectManager.applyEffect(buff, target)

		target.currentMana -= GameConfig.buffManaCost
		target.currentEnergy -= GameConfig.spellEnergyCost

		syncGameState()
	}

	func cut() {

		guard gameState.isGameOn else { return }
		guard let hero = gameState.hero else { return }
		guard let enemy = gameState.enemy else { return }

		if gameState.isHeroTurn {

			guard hero.currentEnergy >= GameConfig.cutEnergyCost else { return }
			hero.currentEnergy -= GameConfig.cutEnergyCost
			let result = combatManager.cut(hero, enemy)
			let debuff = Effect(type: .bleeding(initialDamage: result, damagePerTurn: result), duration: 3)
			effectManager.applyEffect(debuff, enemy)
			triggerHit(onHero: false)

		} else {

			guard enemy.currentEnergy >= GameConfig.cutEnergyCost else { return }
			enemy.currentEnergy -= GameConfig.cutEnergyCost
			let result = combatManager.cut(enemy, hero)
			let debuff = Effect(type: .bleeding(initialDamage: result, damagePerTurn: result), duration: 3)
			effectManager.applyEffect(debuff, hero)
			triggerHit(onHero: true)

		}
		checkWinLoseCondition()

		syncGameState()

	}

	func exhaustion() {

	}

	func healthRegen() {

	}

	func manaRegen() {

	}

	func buffArmor() {
		
	}

	func stun() {

		guard gameState.isGameOn else { return }
		guard let hero = gameState.hero else { return }
		guard let enemy = gameState.enemy else { return }

		if gameState.isHeroTurn {

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

		syncGameState()
	}

}

// MARK: - Helpers

extension RoomViewModel {

	private func triggerEffect(forHero: Bool, color: Color) {
		if forHero {
			heroEffectColor = color
			DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
				if self.gameState.isHeroTurn { self.heroEffectColor = nil }
			}
		} else {
			enemyEffectColor = color
			DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
				if !self.gameState.isHeroTurn { self.enemyEffectColor = nil }
			}
		}
	}

	// helper to trigger a 1s “hit” animation on the target
	private func triggerHit(onHero: Bool) {
		if onHero {
			roomState.heroWasHit = true
			DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
				self.roomState.heroWasHit = false
			}
		} else {
			roomState.enemyWasHit = true
			DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
				self.roomState.enemyWasHit = false
			}
		}
	}

	private func passActionVisualResult(_ color: Color, _ label: Int) {

		if gameState.isHeroTurn {
			enemyState.enemyActionColor = color
			enemyState.enemyActionLabel = label
		} else {
			heroState.heroActionColor = color
			heroState.heroActionLabel = label
		}

		DispatchQueue.main.asyncAfter(deadline: .now() + 0.29) {
			self.enemyState.enemyActionLabel = -100
			self.heroState.heroActionLabel = -100
		}
	}
}
