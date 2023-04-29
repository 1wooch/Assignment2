//
//  ContentView.swift
//  Assignment2
//
//  Created by 최원우 on 25/4/2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var ctx
    @FetchRequest(entity:Places.entity() ,sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)])
    var places:FetchedResults<Places>
    @State var image = defaultImage

    var body: some View {
        NavigationView{
            VStack{
                List{
                    ForEach(places){
                        place in
                        NavigationLink(destination: DetailView(place: place)){
                            //RowView(place: place)
                            
                            HStack{
                                //image.frame(width: 40, height: 40).clipShape(Circle())
                                RowView(place: place)
                                Text("\(place.strName)")
                            }                       }
                    }.onDelete(perform: removeItem)
                }
            }.navigationTitle("My Places")
                .navigationBarItems( trailing:VStack{
                    Button("+"){
                    addPlace()
                }
                }
            )
        }
    }
    func addPlace(){
        let place = Places(context:ctx)
        place.name="New Place"
        place.detail=""
        saveData()
    }
    func removeItem(offsets:IndexSet){
        for index in offsets{
            let place = places[index]
            ctx.delete(place)
            saveData()
        }
    }
    
}

