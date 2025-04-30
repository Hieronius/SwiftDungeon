import Foundation

struct Buff {
	let type: BuffType  // .attack(+5), .armor(+3), etc.
	var duration: Int   // Turns remaining
}

enum BuffType {
	case attack(value: Int)
	case armor(value: Int)
	// Add more types like .block, .spellPower, etc.
}
