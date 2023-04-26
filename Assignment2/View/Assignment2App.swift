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
    var body: some Scene {
        WindowGroup {
            ContentView().environment(\.managedObjectContext, model.container.viewContext)
        }
    }
}
