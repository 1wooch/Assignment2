//
//  MapViewModel.swift
//  Assignment2
//
//  Created by 최원우 on 7/5/2023.
//

import Foundation
import CoreLocation
import SwiftUI
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
    func setupRegion(){
        withAnimation{
            region.center.latitude=latitude
            region.center.longitude=longitude
            region.span.longitudeDelta=delta
            region.span.latitudeDelta=delta
        }
    }
    func fromZoomToDelta(_ zoom:Double){
        let c1 = -10.0
        let c2 = 3.0 //minimum zoom
        delta = pow(10.0,zoom/c1+c2)
    }
    func fromAddressToLocD(_ cb:@escaping ()->Void)async{ // @escaping -> keep the call back not destrying it
        let encode = CLGeocoder()
        encode.geocodeAddressString(self.name){
            marks,error in if let err = error{
                print("error in fromAddressToLoc \(err)")
                return
            }
            if let mark = marks?.first{
                self.latitude=mark.location?.coordinate.latitude ?? self.latitude
                self.longitude=mark.location?.coordinate.longitude ?? self.longitude
                cb()
                self.setupRegion()
            }
            
        }
    }
    func fromAddressToLoc() async {
        let encode = CLGeocoder()
        let marks = try? await encode.geocodeAddressString(self.name)
        if let mark = marks?.first{
            self.latitude=mark.location?.coordinate.latitude ?? self.latitude
            self.longitude=mark.location?.coordinate.longitude ?? self.longitude
  
            self.setupRegion()
        }
     }
}

