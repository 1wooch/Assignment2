//
//  MapView.swift
//  Assignment2
//
//  Created by 최원우 on 6/5/2023.
//
/// ## Brief Description
/// Display Mapview
/**
     - Type: View
     - Element:
                    - mapmodel
                        - Type: MapPlace
                        - Usage : get map model.
                    - mapzoom
                        - Type: double
                        - Usage: get zoom value
                
                    - maplatitude
                        - Type: string
                        - Usage:string value for latitude
                    - maplongitude
                        - Type: string
                        - Usage:string value for longitude
 
                    - save
                        - Type: function
                        - Usage:save lonitude and latiude in place model.
 
                    - checkAddress
                        - Type: function
                        - Usage: use ``DispatchQueue.main.async`` because sometime  it takes sometime to get the longitude or latitude from map application, and get it and ``save()``
 
                    - checkZoom
                        - Type: function
                        - Usage: put ``mapzoom`` in ``fromZoomToDelta`` and adjust delta value in map

                    - checkMap
                        - Type: function
                        - Usage: adjust map and location name in textfield by using ``updateFromRegion()`` and ``fromLocToAddress()``functions
 
                    - updateViewLoc
                        - Type: function
                        - Usage: update ``maplatitude`` and ``maplongitude`` and put that in place coredata
                                     
                    - checkLocation
                       - Type: function
                       - Usage:get the value from coredata and adapt in here
 
     - Procedure:
            1. get ``strlatitude`` and ``strLongitude`` from ``Places`` coredata
            2. check whether the zoom value is bigger than 10.0
            3. ``checkLocation`` for get name of location
            4. ``checkZoom`` to zoom in
            5. ``checkMap`` to update the model value
            6. If user input the value in location textbox it will run ``checkAddress``
            7. if user input Latitude and longitude then it will move to ``checkLocation`` and change the map
            8. if user use the slider then it will change the ``mapzoom`` value
            9. if user click the "Update" button then it will update the ``Logitude`` and ``Latitude``
           10. Whenever, user left the ``MapView`` it will save data in coredata (latitude, longitude and zoom)
 */
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
                
            }
            VStack(alignment:.center){
                Text("Latitude:\(mapmodel.region.center.latitude) ")//.font(.footnote)
                Text("Longitude:\(mapmodel.region.center.longitude) ")//.font(.footnote)
                Button("Update"){
                    checkMap()
                    place.strLatitude=maplatitude
                    place.strLongtitude=maplongitude
                    saveData()
                }
                    
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

