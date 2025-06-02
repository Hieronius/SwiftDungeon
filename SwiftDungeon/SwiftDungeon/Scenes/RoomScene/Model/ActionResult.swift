import Foundation

// MARK: - ActionResult

/// Should be refactored and placed into separate file
struct ActionResult {

	// TODO: refactor
	let didHit: Bool
	let isCritical: Bool
	let impact: Int
	let effects: [Effect]
	let log: [String]
}
