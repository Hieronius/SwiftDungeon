import SwiftUI

// MARK: Initial Point of the App

@main
struct SwiftDungeonApp: App {

	// MARK: - Dependencies


	// MARK: - Body
    var body: some Scene {

        WindowGroup {

			MenuView(items: menuItems)

			// AppCordinator.assembly(screen: .MainScreen)

			// MainMenu(option: Options)

			// switch MainMenuoption

			// case newGame:
			// RoomBuilder.build(.Dungeon(dungeonManager: dungeonManager)

			// case town:
			// RoomBuilder.build(.Town(dungeonManager: dungeon)

			// case dungeon:
			// RoomBuilder.build(.Dungeon(dungeonManager: roomScreen.dungeonManager)

//			RoomBuilder.build()
        }
    }
}
