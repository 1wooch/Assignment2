//
//  DetailView.swift
//  Assignment2
//
//  Created by 최원우 on 26/4/2023.
//
/// # **ContentView**
///
/// ## Brief Description
/// Display Mainview
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


 
 
     - Procedure:
            1. display all the data of place
            2. if ``editmode`` = True then move to edit mode
            3. in edit mode user can enter new value for each ``place`` entity value
 

 */
import SwiftUI

struct DetailView: View {
    @State var place:Places
    @State var name = ""
    @State var detail=""
    @State var url=""
    @State var longtitude=""
    @State var latitude=""
    @State var isEditing = false
    @State var image = defaultImage
    //Map
    @ObservedObject var mapmodel:MapPlace

    
    var body: some View {
        VStack{
            if !isEditing{
                List{
                    Text("Name: \(name)")
                    Text("Detail: \(detail)")
                    Text("Longtitude: \(place.strLatitude)")
                    Text("Letitude: \(place.strLongtitude)")
                    //Text("Url: \(url) ")
                    NavigationLink(destination: MapView(place: $place,mapmodel: mapmodel)){
                        HStack{
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
//
           // image.scaledToFit().cornerRadius(20).shadow(radius: 20)
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
            print("detailView appe \(place.strLatitude)")
            print("detailView appe\(place.strLongtitude)")
        }.onDisappear(){
            place.strName=name
            place.strDetail=detail
            place.strLatitude=latitude
            place.strLongtitude=longtitude
            print("detailView disa\(place.strLatitude)")
            print("detailView disa\(place.strLongtitude)")
            place.strUrl=url
            saveData()
        }
        .task {
            await image = place.getImage()
        }
    }
}

