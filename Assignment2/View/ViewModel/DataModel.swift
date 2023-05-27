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
                    - Relay
                        - Type: PassthroughSubject
                        - Usage : provides a convenient way to adapt existing imperative code to the Combine model. (ref:https://developer.apple.com/documentation/combine/passthroughsubject)
 
                    - Publisher
                        - Type: publisher
                        - Usage : get value and send it to Relay
                    - MKCoordinateRegion:
                        - Type: function : Equatable
                        - Usage : check whether the current longitude and latitude is same and if that is differnt consider it the map has been scrolled by user and do the function.
                    - timeZone
                        - Type: String
                        - Usage : store timezone value as string
                    - sunRise
                        - Type: String
                        - Usage : store sunrise time  value as string
                    - sunSet
                        - Type: String
                        - Usage : store sunset time value as string
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

}
