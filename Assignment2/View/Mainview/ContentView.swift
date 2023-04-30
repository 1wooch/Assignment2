//
//  ContentView.swift
//  Assignment2
//
//  Created by 최원우 on 25/4/2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    @Environment(\.managedObjectContext) var ctx //viewcontext
    @FetchRequest(entity:Places.entity() ,sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)])
    var places:FetchedResults<Places>
    @State var image = defaultImage
    @State var isSearch = false
    @State var placeName:String=""
    var body: some View {
        NavigationView{
            VStack{
                if !isSearch{
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
                    
                }
                else{
                    TextField("Place Name:",text: $placeName)
                    NavigationLink("Search"){
                        searchView(placeName: placeName, viewContext: ctx)
                    }
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
                }
            }.navigationTitle("My Places")
                .navigationBarItems( trailing:HStack{
                    Button("+"){
                        addPlace()
                    }
                    Button("\(isSearch ? "Done":"Search")"){
                        
                        isSearch.toggle()
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

