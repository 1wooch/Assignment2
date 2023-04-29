//
//  DetailView.swift
//  Assignment2
//
//  Created by 최원우 on 26/4/2023.
//

import SwiftUI

struct DetailView: View {
    var place:Places
    @State var name = ""
    @State var detail=""
    @State var url=""
    @State var longtitude=""
    @State var latitude=""
    @State var isEditing = false
    @State var image = defaultImage
    var body: some View {
        VStack{
            if !isEditing{
                List{
                    Text("Name: \(name)")
                    Text("Detail: \(detail)")
                    Text("Longtitude: \(longtitude)")
                    Text("Letitude: \(latitude)")
                    //Text("Url: \(url) ")
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
            
        }.onDisappear(){
            place.strName=name
            place.strDetail=detail
            place.strLatitude=latitude
            place.strLatitude=latitude
            place.strUrl=url
            saveData()
        }
        .task {
            await image = place.getImage()
        }
    }
}

