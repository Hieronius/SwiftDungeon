import SwiftUI

/*
 Ingame Menu

 1. Menu -> Room
 2. Room -> IngameMenu (inventory, room, map, skills)
 3. IngameMenu -> Inventory
 4. Inventory -> room (pop(2))

 4.1. Inventory -> map
 5. map -> room(pop(3)
 */

// MARK: - MenuItem

/// Struct to define a single MenuItem
struct MenuItem: Identifiable, Hashable {

	/// An ID to comform to Identifiable
	let id = UUID()

	/// Label of the Menu Item
	let title: String
}

// MARK: Menu Items should be put in view model

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

	/// Place to store our actual Navigation Stack
	///
	/// Use to push/pop screens to create different combinations like transition from DungeonMap to Room
	@State private var path = NavigationPath()

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
			.navigationBarTitleDisplayMode(. inline)

			// Define data type for navigation destination and pass it through the closure

			.navigationDestination(for: MenuItem.self) { item in

				// Check Menu Option Label and build the module of it's name

				switch item.title {

					// MARK: RoomBuilder

				case "Room":
					// **Don’t return a NavigationStack here**,
					// just the view content
					RoomBuilder.build()

					// MARK: CorridorBuilder

				case "Corridor":
					CorridorBuilder.build()

					// MARK: DungeonBuilder

				case "Dungeon":
					DungeonBuilder.build()

					// MARK: TownBuilder

				case "Town":
					TownBuilder.build()

					// MARK: WorldBuilder

				case "World":
					WorldBuilder.build()

				default:
					EmptyView()
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
