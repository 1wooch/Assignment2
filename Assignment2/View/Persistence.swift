//
//  Persistence.swift
//  Assignment2
//
//  Created by 최원우 on 25/4/2023.
//

import Foundation
import CoreData

struct PersistanceHandler{
    static let shared = PersistanceHandler()
    let container:NSPersistentContainer
    
    init(){
        container = NSPersistentContainer(name: "Model")
        container.loadPersistentStores {
            _, error in if let err = error{
                fatalError("Error to load with \(err)")
            }
        }
    }
    
}

func saveData(){
    let ctx = PersistanceHandler.shared.container.viewContext
    do{
        try ctx.save()
    }catch{
        print("Error to save with \(error)")
    }
}
