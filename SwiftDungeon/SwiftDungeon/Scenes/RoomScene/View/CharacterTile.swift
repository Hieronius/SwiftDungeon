import SwiftUI

// MARK: Special Effects For Hero/Enemy Tiles

struct CharacterTileView: View {
	let baseColor: Color
	let label: String
	let impactLabel: String        // The number or text to show ("3", "10", etc.)
	let isActive: Bool
	let activeColor: Color
	let effectColor: Color?
	let didHit: Bool
	let impactTextColor: Color?    // New: color of the label (red, green, etc.)

	@State private var pulse = false
	@State private var internalEffect: Color? = nil
	@State private var shaking = false
	@State private var showEffectLabel = false  // New: controls label visibility

	var body: some View {
		ZStack {
			// Aura pulse
			if isActive {
				Circle()
					.stroke(activeColor, lineWidth: 3)
					.frame(width: 130, height: 130)
					.scaleEffect(pulse ? 1.6 : 1.2)
					.opacity(pulse ? 0 : 0.6)
					.onAppear {
						pulse = false
						startPulse()
					}
					.onChange(of: isActive) { newValue in
						guard newValue else { return }
						pulse = false
						startPulse()
					}
			}

			// Main square with optional effect color + shake
			Rectangle()
				.frame(width: 100, height: 100)
				.foregroundColor(internalEffect ?? baseColor)
				.overlay(
					Rectangle()
						.stroke(isActive ? activeColor : .white,
								lineWidth: isActive ? 3 : 1)
				)
				.offset(x: shaking ? 8 : 0)
				.animation(
					shaking
					? Animation.linear(duration: 0.05)
						.repeatCount(6, autoreverses: true)
					: .default,
					value: shaking
				)

			// Main character label (e.g., "H", "E")
			Text(label)
				.font(.title)
				.foregroundColor(.white)

			// New: Effect text overlay (e.g. "3", "10")
			if showEffectLabel && !impactLabel.isEmpty {
				Text(impactLabel)
					.font(.title2)
					.bold()
					.foregroundColor(impactTextColor ?? .white)
					.offset(y: -30) // Appears above the square
					.transition(.opacity)
			}
		}
		.frame(width: 130, height: 130)
		.onChange(of: didHit) { hit in
			if hit {
				animateHit()
			}
			showEffectLabel = true
			DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
				showEffectLabel = false
			}
		}
		.onChange(of: effectColor) { newColor in
			internalEffect = newColor
		}

//		.onChange(of: didHit) { _ in
//			showEffectLabel = true
//			DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
//				showEffectLabel = false
//			}
//		}
	}

	private func startPulse() {
		withAnimation(
			Animation.easeOut(duration: 1.5)
				.repeatForever(autoreverses: false)
		) {
			pulse = true
		}
	}

	private func animateHit() {
		shaking = true
		DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
			shaking = false
		}
	}
}
