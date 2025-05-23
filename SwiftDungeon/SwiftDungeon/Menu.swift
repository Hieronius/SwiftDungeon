import SwiftUI

// MARK: - MenuItem

/// Struct to define a single MenuItem
struct MenuItem: Identifiable, Hashable {

	/// An ID to comform to Identifiable
	let id = UUID()

	/// Label of the Menu Item
	let title: String
}

// MARK: Menu Items

/// All Possible Menu Options
let menuItems = [
	MenuItem(title: "Room"),
	MenuItem(title: "Corridor"),
	MenuItem(title: "Dungeon"),
	MenuItem(title: "Town"),
	MenuItem(title: "World")
]

// TODO: Transform into MVVM Module
// MARK: - MenuView

/// Menu with different options to choose such as `Room`/`Dungeon` and so on
struct MenuView: View {

	/// An array of menu items to track
	var items: [MenuItem]

	var body: some View {

		// MARK: NavigationStack

		NavigationStack {

			// Display MenuItems in the form of the List

			List(items) { item in
				NavigationLink(item.title, value: item)
			}
			.navigationTitle("Main Menu")

			// Define data type for navigation destination and pass it through the closure

			.navigationDestination(for: MenuItem.self) { item in

				// Check Menu Option Label and build the module of it's name

				switch item.title {

				case "Room":
					// **Don’t return a NavigationStack here**,
					// just the view content
					RoomBuilder.build()

				case "Corridor":
					CorridorBuilder.build()

				case "Dungeon":
					EmptyView()

				case "Town":
					EmptyView()

				case "World":
					EmptyView()

				default:
					DetailView(item: item)
				}
			}
		}
	}
}

// TODO: Refactor accordingly to MVVM
// MARK: Destination Screen

// 4. The destination screen
struct DetailView: View {
	let item: MenuItem

	var body: some View {
		Text("You picked \(item.title)!")
			.font(.largeTitle)
			.navigationTitle(item.title)
	}
}
