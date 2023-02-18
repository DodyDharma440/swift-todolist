//
//  Todo_ListApp.swift
//  Todo List
//
//  Created by Dodi Aditya on 18/02/23.
//

import SwiftUI

@main
struct Todo_ListApp: App {
    let persistentContainer = CoreDataManager.shared.persistentContainer
    
    var body: some Scene {
        WindowGroup {
            ContentView().environment(\.managedObjectContext, persistentContainer.viewContext)
        }
    }
}
