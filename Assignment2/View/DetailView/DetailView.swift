//
//  DetailView.swift
//  Assignment2
//
//  Created by 최원우 on 26/4/2023.
//
/// # **ContentView**
///
/// ## Brief Description
/// Display Detailview
/**
     - Type: View
     - Element:
                    - place
                        - Type: places
                        - Usage : variable for place name
                    - name
                        - Type: string
                        - Usage:string value for name
                
                    - detail
                        - Type: string
                        - Usage:string value for detail
                    - url
                        - Type: string
                        - Usage:string value for url
                    - longtitude
                        - Type: string
                        - Usage:string value for longtitude
                    - latitude
                        - Type: string
                        - Usage:string value for latitude

                    - isEditing
                        - Type: bool
                        - Usage:bool value to check edit mode

                    - image
                        - Type: Image
                        - Usage:image for place image
                                        
                    - detailmapdelta
                        - Type: double
                        - Usage:setting a minimap delta value
                    - locationNameD
                        - Type: String
                        - Usage:Store Location Name 

                     
                    - c1,c2
                    - Type: double
                    - Usage: calulate material to get map delta.
 
                    - mapmodel
                    - Type: MapPlace
                    - Usage: get mapmodel

                    - detailviewRegion
                    - Type: MKCoordinateRegion
                    - Usage:  map value.


                                         
 
 
     - Procedure:
            1. display all the data of place
            2. if ``editmode`` = True then move to edit mode
            3. in edit mode user can enter new value for each ``place`` entity value
            4. get ``place.zoom`` , ``place.latitude``, ``place.longitude`` from place coredata
            5. put the value from procedure 4 and put that in ``detailviewRegion``
            6. When disappear the value will be save on coredata and send it to mapview
 

 */
import SwiftUI
import MapKit


struct DetailView: View {
    var place:Places
    @State var name = ""
    @State var detail=""
    @State var url=""
    @State var longtitude=""
    @State var latitude=""
    @State var isEditing = false
    @State var image = defaultImage
    
    @State var locationNameD:String=""
    @State var detailmapdelta = 20.0
    var c1 = -10.0
    var c2 = 3.5
    @ObservedObject var mapmodel:MapPlace
    @State private var detailviewRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude:0.0, longitude: 0.0), span: MKCoordinateSpan(latitudeDelta: 0.5, longitudeDelta: 0.5))

    var body: some View {
        VStack{
            if !isEditing{
                List{
                    Text("Name: \(name)")
                    Text("Location name \(locationNameD)")
                    Text("Detail: \(detail)")
                    
                    Text("Longtitude: \(place.strLatitude)")
                    Text("Letitude: \(place.strLongtitude)")
                    //Text("Url: \(url) ")
                    NavigationLink(destination: MapView(place: place,mapmodel: mapmodel)){
                        HStack{
                            Map(coordinateRegion: $detailviewRegion//$mapmodel.region
                            ).frame(width: 50.0)
                            Text("Edit Map")
                        }
                    }
                    
                    image.scaledToFit().cornerRadius(20).shadow(radius: 20)
                }
            }else{
                List{
                    TextField("Name:",text:$name)
                    TextField("Detail:",text:$detail)
                    TextField("Longtitude:",text: $longtitude)
                    TextField("Letitude:" ,text:$latitude)
                    TextField("Url:",text: $url)
                    
                }
            }
        }
        .navigationTitle("Place Detail")
        .navigationBarItems( trailing:VStack{
            Button("\(isEditing ? "Confirm":"Edit")"){
                if(isEditing){
                    place.strName=name
                    place.strUrl=url
                    place.strDetail=detail
                    place.strLatitude=latitude
                    place.strLongtitude=longtitude
                    saveData()
                    Task{
                        image = await place.getImage()
                    }
                }
                isEditing.toggle()
            }
        })
        .onAppear{
            name=place.strName
            detail=place.strDetail
            longtitude=place.strLongtitude
            latitude=place.strLatitude
            url=place.strUrl
            locationNameD=place.strLoctionName
            detailmapdelta=pow(10.0,place.zoom/c1+c2)
        
            self.detailviewRegion.center.latitude=Double(place.latitude)
            self.detailviewRegion.center.longitude=Double(place.longitude)
            self.detailviewRegion.span.longitudeDelta=detailmapdelta
            self.detailviewRegion.span.latitudeDelta=detailmapdelta
            
        }.onDisappear(){
            place.strName=name
            place.strDetail=detail
            place.strLatitude=latitude
            place.strLongtitude=longtitude
            //place.strLoctionName=locationNameD
            place.strUrl=url
            saveData()
        }
        .task {
            await image = place.getImage()
        }
    }
}

