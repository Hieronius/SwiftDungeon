import SwiftUI

final class SceneUIStateManager: ObservableObject {
	@Published var activeSection: SceneUISection = .skills

	/// Choose section to open
	func open(_ section: SceneUISection) {
		if activeSection == section {
			activeSection = .skills // toggle off if already selected
		} else {
			activeSection = section
		}
	}

	func closeAll() {
		activeSection = .skills
	}

	/// func - toggle for SwiftUI View to reveal section
	func isOpen(_ section: SceneUISection) -> Bool {
		activeSection == section
	}
}
