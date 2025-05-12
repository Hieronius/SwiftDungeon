import SwiftUI

struct EnemyUIState {

	var enemyCurrentLevel: Int
	var enemyMaxHealth: Int
	var enemyCurrentHealth: Int
	var enemyMaxMana: Int
	var enemyCurrentMana: Int
	var enemyMaxEnergy: Int
	var enemyCurrentEnergy: Int
	var enemyActionColor: Color
	var enemyActionLabel: Int
	var enemyBeingHit: Bool
	var enemyActiveEffects: [Effect]
}
