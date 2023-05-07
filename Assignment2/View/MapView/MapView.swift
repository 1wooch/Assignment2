//
//  MapView.swift
//  Assignment2
//
//  Created by 최원우 on 6/5/2023.
//

import SwiftUI
import MapKit


struct MapView: View {
    @Binding var place:Places

    

    @StateObject var mapmodel:MapPlace
    @State var zoom=10.0
    @State var maplatitude:String="0.0"
    @State var maplongitude:String="0.0"
    
    var body: some View {
        
        VStack{
            HStack{
                Text("Address")
                TextField("",text:$mapmodel.name)
                Image(systemName: "sparkle.magnifyingglass").foregroundColor(.blue).onTapGesture {
                    checkAddress()
                }
            }
            HStack{
                Text("Lat/Long")
                TextField("",text: $maplatitude)
                //,text: $mapmodel.latStr)//value: $latitude,format:.number)
                TextField("",text: $maplongitude)
                          //,text: $mapmodel.longStr)//value: $longitude,format:.number)
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
        .task {
            checkMap()
        }
        .onAppear(){
            
            maplatitude=place.strLatitude
            
            maplongitude=place.strLongtitude
            print(maplatitude)
            print(maplongitude)
            checkLocation()
            checkMap()

        }.onDisappear(){
            place.strLatitude=maplatitude
            place.strLongtitude=maplongitude
            print(place.strLatitude)
            print(place.strLongtitude)
            
            saveData()
        }
        
    }
    func checkAddress(){
        mapmodel.fromAddressToLocD(upadateViewLoc)
//        Task{
//
//            await mapmodel.fromAddressToLoc()
//            //mapmodel.fromAddressToLocD()
//            maplatitude = mapmodel.latStr
//            maplongitude=mapmodel.longStr
//        }

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
        mapmodel.fromZoomToDelta(zoom)
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
        
    }
}

