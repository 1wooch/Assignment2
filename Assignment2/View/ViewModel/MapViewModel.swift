//
//  MapViewModel.swift
//  Assignment2
//
//  Created by 최원우 on 7/5/2023.
//


/// ## Brief Description
/// MapViewModel
/**
     - Type: View
     - Element:
                    - latStr
                        - Type: String
                        - Usage : get latitude from ``MapPlace`` and put it in string
 
                    - longstr
                        - Type: String
                        - Usage :  get longitude from ``MapPlace`` and put it in string
 
                    - updateFromRegion
                        - Type: Function
                        - Usage : get latitude from map.region
 
                    - fromLocToAddress
                        - Type: Function
                        - Usage : Get a location which is latitude and longitude  and get a location. In the function, get as detail as name can, country-> locality-> localarea.
 
                    - setupRegion
                        - Type: Function
                        - Usage : Put zoom (delta) and location(longitude , latitude)  in region
 
                    - fromZoomToDelta
                        - Type: Function
                        - Usage : get a zoom value from mapview and put it in equation and get delta after that use setupRegion.
 
 
                    - fromAddressToLocD
                        - Type: Function
                        - Usage : get a address (name) and get a location information (latitude, logitude) and return that value.
 
 
 
                    - fromAddressTiKic
                        - Type: Function
                        - Usage : same as fromAddressToLocD but has async

     - Procedure:
            callback datamodel for map.
           
 */


import Foundation
import CoreLocation
import SwiftUI

//struct TimeZone:Decodable{
//    var timeZone:String
//
//}
//struct SunriseSunset: Codable {
//    var sunrise: String
//    var sunset: String
//}
//struct SunriseSunsetAPI: Codable {
//    var results: SunriseSunset
//    var status:String?
//}
//

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
    func fromAddressToLocD(_ cb:@escaping ()->Void){ // @escaping -> keep the call back not destrying it
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
    
    
//    func fetchSunriseset(_ inputLong:String, _ inputLat:String){
//        var inputLong = inputLong
//        var inputLat = inputLat
//
//        if let number = Double(inputLong) {
//            let decimalLong = String(format: "%.2f", number)
//            inputLong=decimalLong
//            //decimalLongValue=decimalLong
//        } else {
//            print("Invalid input")
//        }
//        if let number = Double(inputLat) {
//             let decimalLat = String(format: "%.2f", number)
//             inputLat=decimalLat
//        } else {
//            print("Invalid input")
//        }
//        let urlStr =
//        "https://api.sunrise-sunset.org/json?lat=\(inputLat)&lng=\(inputLong)"
//        print(urlStr)
//        //{"sunrise":"8:23:05 PM","sunset":"7:05:48 AM","solar_noon":"1:44:26 AM"}
//        guard let url = URL(string: urlStr) else {
//            return
//        }
//        let request = URLRequest(url: url)
//        URLSession.shared.dataTask(with: request){
//            data,_, _ in
//            guard let data=data, let api=try?
//                    JSONDecoder().decode(SunriseSunsetAPI.self, from: data)else{
//                return
//            }
//
//            DispatchQueue.main.async {
//                self.sunRise=api.results.sunrise
//                self.sunSet=api.results.sunset
//
//            }
//            print(self.sunSet)
//            print(self.sunRise)
//        }.resume()
//
//
//    }
//    
//    
//    func fetchTimeZone(_ inputLong:String, _ inputLat:String){
//
//        var inputLong = inputLong
//        var inputLat = inputLat
//
//        if let number = Double(inputLong) {
//            let decimalLong = String(format: "%.2f", number)
//            inputLong=decimalLong
//            //decimalLongValue=decimalLong
//        } else {
//            print("Invalid input")
//        }
//        if let number = Double(inputLat) {
//             let decimalLat = String(format: "%.2f", number)
//             inputLat=decimalLat
//        } else {
//            print("Invalid input")
//        }
//
//
//        let urlStr =
//        "https://www.timeapi.io/api/TimeZone/coordinate?latitude=\(inputLat)&longitude=\(inputLong)"
//        guard let url = URL(string: urlStr) else {
//            return
//        }
//        let request = URLRequest(url: url)
//        URLSession.shared.dataTask(with: request){
//            data,_, _ in
//            guard let data=data, let api=try?
//                    JSONDecoder().decode(TimeZone.self, from: data)else{
//                return
//            }
//
//            DispatchQueue.main.async {
//                self.timeZone=api.timeZone
//
//            }
//        }.resume()
//    }
}

