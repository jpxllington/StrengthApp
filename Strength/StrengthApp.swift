//
//  StrengthApp.swift
//  Strength
//
//  Created by James Pollington on 04/03/2022.
//

import SwiftUI

@main
struct StrengthApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
