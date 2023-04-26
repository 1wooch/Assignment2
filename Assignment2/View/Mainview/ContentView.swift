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
    @FetchRequest(sortDescriptors: [])
    var places:FetchedResults<Places>
    var body: some View {
        NavigationView{
            VStack{
                List{
                    ForEach(places){
                        place in Text(place.name ?? "no name")
                    }
                }
                Button("+"){
                    addPlace()
                }
            }
        }
    }
    func addPlace(){
        let place = Places(context:ctx)
        place.name="New Place"
        place.detail=""
        saveData()
    }
}

