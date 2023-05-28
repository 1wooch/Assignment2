//
//  searchView.swift
//  Assignment2
//
//  Created by 최원우 on 30/4/2023.
//

import SwiftUI
import CoreData

/// # **ContentView**
///
/// ## Brief Description
/// Display Mainview
/**
     - Type: View
     - Element:
                    - placename
                        - Type: string
                        - Usage : variable for place name
                    - viewContext
                        - Type: NSManagedObjectContext
                        - Usage: get viewContext for container
                    - matchs
                        - Type: [places]
                        - Usage: Display matched result.
                    - mapmodel
                        - Type: MapPlace
                        - Usage: getting mapplace model
                     
                   
     - Procedure:
            1. Get  entered place name by user in the beginning
            2. Search the name that contain user entered string.
            3. Display all the result.
 */
struct searchView: View {
    var placeName:String
    var viewContext: NSManagedObjectContext
    @State var matchs:[Places]?
    @ObservedObject var mapmodel:MapPlace

    
    var body: some View {
        List{
            ForEach(matchs ?? []){
                match in NavigationLink(destination: DetailView(place: match ,  mapmodel: mapmodel)){
                    HStack{
                        RowView(place: match)
                        Text("\(match.strName)")
                    }
                }
            }
        }.navigationTitle("Search Result")
            .task {
                let fetchRequest: NSFetchRequest<Places> = Places.fetchRequest()
                fetchRequest.entity=Places.entity()
                fetchRequest.predicate = NSPredicate (
                                    format: "name contains %@", placeName
                                )
                matchs = try? viewContext.fetch(fetchRequest)
            }
    }
}

