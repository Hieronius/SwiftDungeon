import SwiftUI

struct StatusBar: View {

	// MARK: - Properties

	var effects: [Effect]

	private var hasBuff: Bool {
		effects.contains { !$0.type.isDebuff }
	}
	private var hasDebuff: Bool {
		effects.contains { $0.type.isDebuff }
	}
	private var isStunned: Bool {
		effects.contains { $0.type == .stun }
	}

	// MARK: Body

	var body: some View {
		HStack(spacing: 4) {

			// MARK: Buff Slot

			Image(systemName: "arrow.up")
				.foregroundColor(.cyan)
				.font(.system(size: 15))
				.opacity(hasBuff ? 1 : 0)            // always present, just invisible
				.frame(width: 15, height: 15)        // reserve exact size

			// MARK: Debuff Slot

			Image(systemName: "arrow.down")
				.foregroundColor(.red)
				.font(.system(size: 15))
				.opacity(hasDebuff ? 1 : 0)          // always present
				.frame(width: 15, height: 15)        // reserve exact size

			// MARK: Stun Slot
			
			Image(systemName: "zzz")
				.foregroundColor(.purple)
				.font(.system(size: 15))
				.opacity(isStunned ? 1 : 0)
				.frame(width: 15, height: 15)
		}
	}
}
