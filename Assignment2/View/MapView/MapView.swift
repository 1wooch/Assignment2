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

    

    @ObservedObject var mapmodel:MapPlace
    
    var body: some View {
        
        VStack{
           

            Map(coordinateRegion: $mapmodel.region)
            
        }.padding()
        .onAppear(){
//            latitude=Double(place.latitude)
//            longtitude=Double(place.longitude)
        }
    }
}

