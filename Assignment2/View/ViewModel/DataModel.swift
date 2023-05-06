//
//  DataModel.swift
//  Assignment2
//
//  Created by 최원우 on 6/5/2023.
//

import Foundation
import MapKit
import CoreLocation
import CoreData


class MapPlace: ObservableObject{
    @Published var name = ""
    @Published var latitude = 0.0
    @Published var longitude = 0.0
    @Published var delta = 100.0
    @Published var region = MKCoordinateRegion(center:CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0) , span: MKCoordinateSpan(latitudeDelta: 100.0, longitudeDelta: 100.0) )
    
    static let shared = MapPlace()
    
    
    init(){
        
    }
    
}
