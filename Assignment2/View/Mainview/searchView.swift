//
//  searchView.swift
//  Assignment2
//
//  Created by 최원우 on 30/4/2023.
//

import SwiftUI
import CoreData


struct searchView: View {
    var placeName:String
    var viewContext: NSManagedObjectContext
    @State var matchs:[Places]?
    
    var body: some View {
        List{
            ForEach(matchs ?? []){
                match in NavigationLink(destination: DetailView(place: match)){
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

