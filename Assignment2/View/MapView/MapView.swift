//
//  MapView.swift
//  Assignment2
//
//  Created by 최원우 on 6/5/2023.
//

import SwiftUI
import MapKit


struct MapView: View {
    var place:Places

    

    @StateObject var mapmodel:MapPlace
    @State var zoom=10.0
    @State var latitude=0.0
    @State var longitude=0.0
    var body: some View {
        
        VStack{
            HStack{
                Text("Address")
                TextField("Address",text:$mapmodel.name)
            }
            HStack{
                Text("Lat/Long")
                TextField("Latitude",value: $latitude,format:.number)
                TextField("Longitude",value: $longitude,format:.number)

            }
            Slider(value: $zoom, in:10...60){
                print($0)
            }

            Map(coordinateRegion: $mapmodel.region)
            
        }.padding()
        .onAppear(){

        }
    }
}

