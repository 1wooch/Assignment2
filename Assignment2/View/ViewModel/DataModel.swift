//
//  DataModel.swift
//  Assignment2
//
//  Created by 최원우 on 6/5/2023.
//

/// ## Brief Description
/// DataModel
/**
     - Type: View
     - Element:
                    - name
                        - Type: String
                        - Usage : store name of location
                    - latitude
                        - Type: Double
                        - Usage : store latitude value
                    - longitude
                        - Type: Double
                        - Usage : store longitude value
                    - delta
                        - Type: Double
                        - Usage : store delta value for zooming
                    - region
                        - Type: MKCoordinateRegion
                        - Usage : togerenate map it store the value for latitude and logintude in region and span is for zooming
 
     - Procedure:
            N/A
           
 */


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
    @Published var timeZone=""
    @Published var sunRise=""
    @Published var sunSet=""
    static let shared = MapPlace()
    
    
    init(){
        
    }
    
}
