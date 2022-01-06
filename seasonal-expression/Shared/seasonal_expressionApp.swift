//
//  seasonal_expressionApp.swift
//  Shared
//
//  Created by Jess Jiang on 1/5/22.
//

import SwiftUI

@main
struct seasonal_expressionApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
