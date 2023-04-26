//
//  DetailView.swift
//  Assignment2
//
//  Created by 최원우 on 26/4/2023.
//

import SwiftUI

struct DetailView: View {
    var places:Places
    @State var name = ""
    @State var detail=""
    @State var url=""
    @State var longtitude=""
    @State var lengitude=""
    @State var isEditing = false
    var body: some View {
        VStack{
            if !isEditing{
                List{
                    Text("Name: \(name)")
                    Text("Detail: \(detail)")
                    Text("Longtitude: \(longtitude)")
                    Text("Letitude: \(lengitude)")
                    Text("Url: \(url) ")
                }
            }
        }
        .navigationTitle("Place Detail")
        .onAppear{
            name=places.strName
            detail=places.strDetail
            longtitude=places.strLongtitude
            lengitude=places.strLatitude
            url=places.strUrl
            
        }
    }
}

