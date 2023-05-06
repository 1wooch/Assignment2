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
                Image(systemName: "sparkle.magnifyingglass").foregroundColor(.blue).onTapGesture {
                    checkAddress()
                }
            }
            HStack{
                Text("Lat/Long")
                TextField("Latitude",value: $latitude,format:.number)
                TextField("Longitude",value: $longitude,format:.number)
                Image(systemName: "sparkle.magnifyingglass").foregroundColor(.blue).onTapGesture {
                    checkLocation()
                }
            }
            Slider(value: $zoom, in:10...60){
                if !$0{
                    checkZoom()
                }
            }
            ZStack{
                Map(coordinateRegion: $mapmodel.region)
                VStack(alignment: .leading){
                    Text("Latitude:\(mapmodel.region.center.latitude) ").font(.footnote)
                    Text("Longitude:\(mapmodel.region.center.longitude) ").font(.footnote)
                    Button("Update"){
                        checkMap()
                    }
                        
                }.offset(x:10,y:200)
            }
            
        }.padding()
        .onAppear(){

        }
    }
    func checkAddress(){
        
    }
    func checkLocation(){
        
    }
    func checkZoom(){
        
    }
    func checkMap(){
        
    }
}

