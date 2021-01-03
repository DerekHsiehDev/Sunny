//
//  WeatheryApp.swift
//  Weathery
//
//  Created by Derek Hsieh on 12/20/20.
//

import SwiftUI

@main
struct WeatheryApp: App {
    
    let persistenceContainer = PersistenceController.shared

    
    var body: some Scene {
        
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceContainer.container.viewContext)
        }
    }
}
