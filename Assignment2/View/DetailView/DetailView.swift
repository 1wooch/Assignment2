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
    var body: some View {
        VStack{
            if !isEditing{
                List{
                    Text("Name: \(name)")
                    Text("Detail: \(detail)")
                    Text("Longtitude: \(longtitude)")
                    Text("Letitude: \(latitude)")
                    Text("Url: \(url) ")
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
            HStack{
                Button("\(isEditing ? "Confirm":"Edit")"){
                    if(isEditing){
                        place.strName=name
                        place.strUrl=url
                        place.strDetail=detail
                        place.strLatitude=latitude
                        saveData()
                        
                    }
                    isEditing.toggle()
                    
                }
            }
        }
        .navigationTitle("Place Detail")
        .onAppear{
            name=place.strName
            detail=place.strDetail
            longtitude=place.strLongtitude
            latitude=place.strLatitude
            url=place.strUrl
            
        }
    }
}
