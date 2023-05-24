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
import Combine

//for week 11 stop the map
typealias Relay = PassthroughSubject<MKCoordinateRegion,Never>
typealias Publisher = Publishers.Debounce<Relay,RunLoop>
extension MKCoordinateRegion:Equatable{
    public static func == (lhs:MKCoordinateRegion,rhs:MKCoordinateRegion)->Bool{
        lhs.center.latitude==rhs.center.latitude && lhs.center.longitude==rhs.center.longitude
    }
}
//

class MapPlace:NSObject, ObservableObject{ //added NSObject for week 11
    @Published var name = ""
    @Published var latitude = 0.0
    @Published var longitude = 0.0
    @Published var delta = 100.0

    @Published var region = MKCoordinateRegion(center:CLLocationCoordinate2D(latitude: 0.0, longitude: 0.0) , span: MKCoordinateSpan(latitudeDelta: 100.0, longitudeDelta: 100.0) )
    @Published var timeZone=""
    @Published var sunRise=""
    @Published var sunSet=""
    static let shared = MapPlace()
    
    //for week 11
    let relay = Relay()
    let debouncerPublisher:Publisher
    override init(){
        debouncerPublisher = relay.debounce(for: 0.5 , scheduler: RunLoop.main)
        super.init()
    }
    //
    
    
    
//    init(){
//
//    }
    
}
