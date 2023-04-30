//
//  RowView.swift
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
                    - image
                        - Type: Image
                        - Usage:default image but if there is image url exist then get that image
                    
     - Procedure:
            1. display image with the name

 */
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


