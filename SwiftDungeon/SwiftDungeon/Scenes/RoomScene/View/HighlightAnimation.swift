import SwiftUI

// 1) Define a Shape that starts at the top‐middle,
//    goes to top corner, down to bottom corner,
//    then to bottom‐middle.
struct SideBorder: Shape {
	
	enum Side { case left, right }
	let side: Side

	func path(in rect: CGRect) -> Path {
		var path = Path()
		let midX = rect.midX
		let topY = rect.minY
		let bottomY = rect.maxY
		let xCorner = side == .left ? rect.minX : rect.maxX

		// start at top middle
		path.move(to: CGPoint(x: midX, y: topY))
		// to top corner
		path.addLine(to: CGPoint(x: xCorner, y: topY))
		// down to bottom corner
		path.addLine(to: CGPoint(x: xCorner, y: bottomY))
		// to bottom middle
		path.addLine(to: CGPoint(x: midX, y: bottomY))

		return path
	}
}

// 2) Overlay two strokes (gray + white) and trim them
struct HighlightBorders: View {
	var animate: Bool

	var body: some View {
		ZStack {
			// Gray background stroke
			SideBorder(side: .left)
				.trim(from: 0, to: animate ? 1 : 0)
				.stroke(Color.gray, lineWidth: 6)
			SideBorder(side: .right)
				.trim(from: 0, to: animate ? 1 : 0)
				.stroke(Color.gray, lineWidth: 6)

			// White foreground stroke
			SideBorder(side: .left)
				.trim(from: 0, to: animate ? 1 : 0)
				.stroke(Color.white, lineWidth: 4)
			SideBorder(side: .right)
				.trim(from: 0, to: animate ? 1 : 0)
				.stroke(Color.white, lineWidth: 4)
		}
		.animation(.linear(duration: 1), value: animate)
		.ignoresSafeArea()  // so it spans the full screen
	}
}
