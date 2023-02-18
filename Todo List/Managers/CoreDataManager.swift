//
//  CoreDataManager.swift
//  Todo List
//
//  Created by Dodi Aditya on 18/02/23.
//

import Foundation
import CoreData

class CoreDataManager {
    
    let persistentContainer: NSPersistentContainer
    static let shared: CoreDataManager = CoreDataManager()
    
    private init () {
        persistentContainer = NSPersistentContainer(name: "TodoModel")
        persistentContainer.loadPersistentStores {
            description,
            error in
            
            if let error = error {
                fatalError("Unable to init Core Data \(error)")
            }
        }
    }
    
}
