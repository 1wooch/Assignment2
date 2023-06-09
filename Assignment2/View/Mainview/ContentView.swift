//
//  ContentView.swift
//  Assignment2
//
//  Created by 최원우 on 25/4/2023.
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
                    - Image
                        - Type: Image
                        - Usage : Upload and display image
                    - isSearch
                        - Type: Bool
                        - Usage: Check whether the search function on or off.
                    - placeName
                        - Type: String
                        - Usage: Display Place Name
                    - ctx
                        - Type: @Environment (\.managedObjectContext)
                        - Usage: Get all the coredata Places
                    - mapmodel
                        - Type: @ObservedObject
                        - Usage: Get all the place model.
                   
                    - removeItem()
                        - Type: function
                        - Usage: delete one place


     - Procedure:
            1. Get  coredata in the beginning
            2. Display all the data by using ``foreach`` loop.
            3. Each list will linked to ``DetailView`` using ``navigationLink``
            4. User can go to ``searchView`` by clicking 'Search' button
            5. User can add new place by clicking '+' button and ``addPlace()``
            6. User can delete the place by sliding the place ``removeItem(offsets:)``
            
 */
struct ContentView: View {
    @Environment(\.managedObjectContext) var ctx //viewcontext
    @FetchRequest(entity:Places.entity() ,sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)])
    var places:FetchedResults<Places>
    
    @State var image = defaultImage
    @State var isSearch = false
    @State var placeName:String=""
    @ObservedObject var mapmodel:MapPlace
    
    var body: some View {
        NavigationView{
            VStack{
                if !isSearch{
                    List{
                        ForEach(places){
                            place in
                            NavigationLink(destination: DetailView(place: place, mapmodel: mapmodel)){
                                //RowView(place: place)
                                
                                HStack{
                                    //image.frame(width: 40, height: 40).clipShape(Circle())
                                    RowView(place: place)
                                    Text("\(place.strName)")
                                }                       }
                        }.onDelete(perform: removeItem )
                    }
                    
                }
                else{
                    TextField("Place Name:",text: $placeName)
                    NavigationLink("Search"){
                        searchView(placeName: placeName, viewContext: ctx, mapmodel: mapmodel)
                    }
                    List{
                        ForEach(places){
                            place in
                            NavigationLink(destination: DetailView(place: place,mapmodel: mapmodel)){
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
                .onAppear(){
                    //copyPlaces=places
                }.onDisappear(){
                    //places = copyPlaces
                }
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

    func removeItem(offsets:IndexSet){
        var plcs:[Places]=[]
        offsets.forEach{
            plcs.append(places[$0])
        }
        removePlace(places: plcs)
        
    }
    
}

