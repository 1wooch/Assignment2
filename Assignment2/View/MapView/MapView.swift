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
                    - isEditing
                        - Type: Bool
                        - Usage:Check whether the view is editing mode or not
 
                    - regionSaving
                        - Type: MKCoordinateRegion
                        - Usage:store current region inside for check scrolling.

 
                    - save
                        - Type: function
                        - Usage:save lonitude and latiude in place model.
                    - disaSave
                        - Type: function
                        - Usage:save lonitude and latiude in place model when the view disappear.
 
                    - checkLocationScrolling
                         - Type: function
                         - Usage: check whether the location is moving which means the user scrolling and if it doesn't scroll 0.5 sec run the function inside.
 
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
            10. If user click edit button then it will show up 2 textboxes that user can input longitude and latitude.
            11. If user input the vlaue in textbox and click button next to Longitude it will update the ``maplongitude`` and ``maplatidue`` value and map too.
            12. If the user scroll (move) around map and stop, after 0.5 second the map location will be update and show up (name of street or name of place user currently in)
            13. Whenever, user left the ``MapView`` run ``dissave``and   it will save data in coredata (latitude, longitude, zoom,street name)
 */
import SwiftUI
import MapKit



struct MapView: View {
    var place:Places

    

    @StateObject var mapmodel:MapPlace
    @State var mapzoom=10.0
    @State var maplatitude:String="0.0"
    @State var maplongitude:String="0.0"
    
    @State var isEditing = false
    
    //week11
    @State var regionSaving=MKCoordinateRegion(center:CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0) , span: MKCoordinateSpan(latitudeDelta: 100.0, longitudeDelta: 100.0) )
   // @State var textwk11region = region1
    

    
    var body: some View {
        
            VStack(spacing: 0){
                HStack(spacing: 0){
                    Text("Address : ").border(.black)
                    TextField("",text:$mapmodel.name)//.border(.black)
                    
                    Image(systemName: "sparkle.magnifyingglass").foregroundColor(.blue).onTapGesture{
                        
                        checkAddress()
                    }
                }
                
                HStack{
                    VStack{
                        Text("Latitude").bold()
                        Text("\(mapmodel.region.center.latitude)").bold()
                        
                    }.border(.green)
                  
                    VStack{
                        Text("Longitude").bold()
                        Text("\(mapmodel.region.center.longitude)").bold()
                    }.border(.green)
                }
                Slider(value: $mapzoom, in:10...60){
                    if !$0{
                        place.zoom=mapzoom
                        saveData()
                        checkZoom()
                    }
                }.padding().border(.blue)
                ZStack{
                    
//                    Map(coordinateRegion: $mapmodel.region).onChange(of: mapmodel.region){
//                        mapmodel.relay.send($0)
//                    }
                    
                }
                if !isEditing{
                    VStack(alignment: .center){
                        
                    }
                }else{
                    VStack(alignment:.center){
                        HStack{
                            Text("Latitude : ")
                            TextField("Latitude",text: $maplatitude)
                            
                        }.padding().border(.green)
                        HStack{
                            Text("Longitude : ")
                            TextField("Longitude",text: $maplongitude)
                            Image(systemName: "sparkle.magnifyingglass").foregroundColor(.blue).onTapGesture {
                                checkLocation()
                                place.strLatitude=maplatitude
                                place.strLongtitude=maplongitude
                                saveData()
                            }.padding().border(.blue)
                        }.padding().border(.green)
                        
                        
                    }
                }
                
            }
            .onReceive(mapmodel.debouncerPublisher){
                maplatitude=String(mapmodel.region.center.latitude)
                maplongitude=String(mapmodel.region.center.longitude)
                checkLocationScrolling()
                regionSaving=$0
            }
            .padding(.top,-10)
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
            checkLocation()
            checkZoom()
            checkMap()
        }.onDisappear(){
            disaSave()
        }
        .navigationBarItems(trailing: VStack{
            Button("\(isEditing ? "Confirm":"Edit")"){
                isEditing.toggle()
            }
        })
    }
    func disaSave(){
       
            place.strLatitude=maplatitude
            place.strLongtitude=maplongitude
            place.zoom=mapzoom
            place.strLoctionName=mapmodel.name
            saveData()
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
    func checkLocationScrolling(){
        mapmodel.longStr = String( mapmodel.region.center.longitude)
        mapmodel.latStr=String(mapmodel.region.center.latitude)
        mapmodel.fromLocToAddress()
        mapmodel.setupRegion()
    }
    func checkZoom(){
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
    }
}

