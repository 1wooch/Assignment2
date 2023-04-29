//
//  RowView.swift
//  Assignment2
//
//  Created by 최원우 on 26/4/2023.
//

import SwiftUI

struct RowView: View {
    var place:Places
    @State var image = defaultImage
   var body: some View {
        HStack{
            image.frame(width: 40, height: 40).clipShape(Circle())
            //Text("\(place.strName)")
        }.task{
            image=await place.getImage()
        }
    }
}


