//
//  Assignment2App.swift
//  Assignment2
//
//  Created by 최원우 on 25/4/2023.
//

import SwiftUI

@main
struct Assignment2App: App {
    var model = PersistenceHandler.shared
    @StateObject var mapModel = MapPlace.shared
    var body: some Scene {
        WindowGroup {
            ContentView(mapmodel:mapModel).environment(\.managedObjectContext, model.container.viewContext)
        }
    }
}
