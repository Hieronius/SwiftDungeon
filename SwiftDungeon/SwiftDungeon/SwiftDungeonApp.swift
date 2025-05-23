import SwiftUI

// MARK: Initial Point of the App

// https://github.com/will-lumley/swiftui-navigation-example/blob/main/Navigator/ViewModel/FirstContentViewModel.swift

// https://levelup.gitconnected.com/using-a-navigationstack-with-mvvm-and-swiftui-36617c9f9147

@main
struct SwiftDungeonApp: App {







	// MARK: Dependencies

//	let roomGameStateSnapshot = RoomGameStateSnapshot()
//
//	let roomGameState = RoomGameState(
//		roomGameStateSnapshot: roomGameStateSnapshot)
//
//	let actionCalculator = ActionCalculator()
//	let actionHandler = ActionHandler(
//		actionCalculator: actionCalculator)
//	let characterManager = CharacterManager()
//	let effectManager = EffectManager()
//	let turnManager = TurnManager()

	// let dungeonManager = DungeonManager()


    var body: some Scene {


		
        WindowGroup {

			// TODO: It's actually works but back button should be removed
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
