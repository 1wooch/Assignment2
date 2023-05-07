//
//  MapViewModel.swift
//  Assignment2
//
//  Created by 최원우 on 7/5/2023.
//

import Foundation
import CoreLocation

extension MapPlace{
    var latStr:String{
        get{String(format: "%.5f",latitude)}
        set{
            guard let lat = Double(newValue), lat <= 90.0, lat >= -90.0 else {
                return
            }
            latitude = lat
        }
    }
    var longStr:String{
        get{String(format: "%.5f",longitude)}
        set{
            guard let long = Double(newValue), long <= 180.0, long >= -180.0 else {
                return
            }
            longitude = long
        }
    }
    func updateFromRegion(){
        latitude=region.center.latitude
        longitude=region.center.longitude
    }
    func fromLocToAddress(){
        let coder=CLGeocoder()
        coder.reverseGeocodeLocation(CLLocation(latitude: latitude, longitude: longitude)){
            marks,error in
            if let err = error{
                //null case
                print("error in fromLocToAddress: \(err)")
                return
            }
            let mark = marks?.first
            let name = mark?.name ?? mark?.country ?? mark?.locality ?? mark?.administrativeArea ?? "No name"
            self.name=name
            
            
        }
    }
    
}
