import SwiftUI

struct BorderedSection<Content: View>: View {

	// MARK:  - Properties

	let content: Content

	// MARK: - Initialization

	init(@ViewBuilder content: () -> Content) {
		self.content = content()
	}

	// MARK: Body

	var body: some View {
		content
			.padding()
			.background(Color.black)
			.overlay(
				RoundedRectangle(cornerRadius: 8)
					.stroke(Color.gray, lineWidth: 2)
			)
			.padding(.horizontal, 16)
			.padding(.vertical, 4)
	}
}
