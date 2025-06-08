import Foundation

/// `Composition Root` or initial set of all app dependencies accordingly to Seeman's book "Dependency Injection"
///
/// We use static method to resolve dependecies because it's more predictable and stable than just an init
final class AppDependencies {

	/// Static method to construct dependency, set of dependencies or the whole screens/modules
	static func buildNavigationManager() -> NavigationManager {

		let navigationManager = NavigationManager()
		return navigationManager
	}
}
