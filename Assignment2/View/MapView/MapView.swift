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
    @State var mapzoom=10.0
    @State var maplatitude:String="0.0"
    @State var maplongitude:String="0.0"
    
    var body: some View {
        
        VStack{
            HStack{
                Text("Address")
                TextField("",text:$mapmodel.name)
                Image(systemName: "sparkle.magnifyingglass").foregroundColor(.blue).onTapGesture{
                    
                    checkAddress()
                }
            }
            HStack{
                Text("Lat/Long")
                TextField("",text: $maplatitude)
                TextField("",text: $maplongitude)
        
                Image(systemName: "sparkle.magnifyingglass").foregroundColor(.blue).onTapGesture {
                    checkLocation()
                    place.strLatitude=maplatitude
                    place.strLongtitude=maplongitude
                    saveData()
                }
            }
            Slider(value: $mapzoom, in:10...60){
                if !$0{
                    place.zoom=mapzoom
                    saveData()
                    print("Zoom Slider____\(mapzoom)")
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
                        place.strLatitude=maplatitude
                        place.strLongtitude=maplongitude
                        saveData()
                    }
                        
                }.offset(x:10,y:200)
            }
            
        }.padding()
        .task {
            checkMap()
        }
        .onAppear(){
            if(place.zoom<10.0){
                place.zoom=10
            }
            mapzoom=place.zoom
            maplatitude=place.strLatitude
            maplongitude=place.strLongtitude
            print("mapview appe \(mapzoom)")
            checkLocation()
            checkZoom()
            checkMap()

        }.onDisappear(){

                place.strLatitude=maplatitude
                place.strLongtitude=maplongitude
                place.zoom=mapzoom
                print("mapview dis \(mapzoom)")
                saveData()
        }
        
    }
    func save(){
        print("\(maplatitude) 1111")
        print("\(maplongitude) 2222")
        place.strLatitude=maplatitude
        place.strLongtitude=maplongitude
        saveData()
    }
    func checkAddress(){
        DispatchQueue.main.async {
            mapmodel.fromAddressToLocD(upadateViewLoc)
            save()
        }
        


    }
    func checkLocation(){
        mapmodel.longStr=maplongitude
        mapmodel.latStr=maplatitude
        mapmodel.fromLocToAddress()
        mapmodel.setupRegion()
        //get the value from coredata and adapt in here
    }
    func checkZoom(){
        //mapmodel.updateFromRegion()
        checkMap()
        mapmodel.fromZoomToDelta(mapzoom)
        mapmodel.fromLocToAddress()
        mapmodel.setupRegion()//kind of save
    }
    func checkMap(){
        mapmodel.updateFromRegion()
        maplatitude=mapmodel.latStr
        maplongitude=mapmodel.longStr
        mapmodel.fromLocToAddress()
    }
    func upadateViewLoc(){
        maplatitude=mapmodel.latStr
        maplongitude=mapmodel.longStr
        place.strLatitude=maplatitude
        place.strLongtitude=maplongitude
        saveData()
        print("\(maplatitude)3333")
        print("\(maplongitude)444")
    }
}

