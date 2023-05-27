//
//  ViewModel.swift
//  Assignment2
//
//  Created by 최원우 on 26/4/2023.
//
/// ## Brief Description
/// ViewModel
/**
     - Type: Model
     - Element:
                    - defaultImage
                        - Type: Image
                        - Usage : default image for when the image doesn't exist.
                    - downloadImages
                        - Type: Image
                        - Usage : Image download from web if the URL exist for place.
                    - TimeZone
                        - Type: Struct
                        - Usage : struct that contain timezone value as string.
                    - SunriseSunset
                        - Type: Struct
                        - Usage : struct that contain sunrise and sunset 2 different value as string. It is GMT time so need to change into local.
 
                    - SunriseSunsetAPI
                        - Type: Struct
                        - Usage : struct that contain sunrise and sunset 2 different value as string. It is GMT time so need to change into local.
                    -strName
                        - Type: string
                        - Usage : string that has name of the place
 
                    -strLocationName
                        - Type: string
                        - Usage : string that has name of the  loacation
                    -strDetail
                        - Type: string
                        - Usage : string that has Detail of the place.
                    -strLatitude
                        - Type: string
                        - Usage : string that has Latitude

                    -strLongitude
                        - Type: string
                        - Usage : string that has Longitude
                    -strUrl
                        - Type: string
                        - Usage : string that has Url for image
                    -rowDisplay
                        - Type: string
                        - Usage : string that use for display name on main view.
                    -getImage
                        - Type: function
                        - Usage : function that getting image from web.
                    -saveData
                        - Type: function
                        - Usage : function that use save the data in coredata.
                    -addPlace
                        - Type: function
                        - Usage : function that use to add place.
                    -removePlace
                        - Type: function
                        - Usage : function that use remove the place data in coredata. and get input as places (place row ) value
                    -fetchSunriseset
                        - Type: function
                        - Usage : function  that get longitude and latitude as string value, get sunrise and sunset value from api and  return sunset and sunrise array as return
                    -fetchTimeZone
                         - Type: function
                         - Usage : function  that get longitude and latitude as string value, get timezone value from api and  return timezone string as return
                    -timeConvertToGMT
                        - Type: function
                        - Usage : ffunction that takes time value as string and convert it into local time and return that local time as string.




 
 





                   
 
     - Procedure:
            1. get ``strlatitude`` and ``strLongitude`` from ``Places`` coredata
        
 */
import Foundation
import CoreData

import SwiftUI
import MapKit
import CoreLocation
let defaultImage=Image(systemName: "photo").resizable()

var downloadImages :[URL:Image] = [:]

struct TimeZone:Decodable{
    var timeZone:String
    
}
struct SunriseSunset: Codable {
    var sunrise: String
    var sunset: String
}
struct SunriseSunsetAPI: Codable {
    var results: SunriseSunset
    var status:String?
}


extension Places{
    var strName:String{
        get{
            self.name ?? "New Place"
        }set{
            self.name=newValue
        }
    }
    var strLoctionName:String{
        get{
            self.locationName ?? "New Street"
        }set{
            self.locationName=newValue
        }
    }
    var strDetail:String{
        get{
            self.detail ?? "Enter Detail "
        }set{
            self.detail=newValue
        }
    }
    
    var strLatitude:String{
        get{
            "\(self.latitude)"
        }set{
            guard let latitude = Float(newValue)else{
                return
            }
            self.latitude=latitude
        }
    }
    var strLongtitude:String{
        get{
            "\(self.longitude)"
        }set{
            guard let longitude = Float(newValue)else{
                return
            }
            self.longitude=longitude
        }
    }
    
    var strUrl:String{
        get{
            self.url?.absoluteString ?? "No URL"
        }set{
            guard let url = URL(string: newValue) else{
                return
            }
            self.url=url
        }
    }
    
    var rowDisplay:String{
        "Name: \(self.strName)"
    }
    
    func getImage() async ->Image{
        guard let url = self.url else{return defaultImage}
        if let image = downloadImages[url] {return image}
        do{
            let(data, _)=try await URLSession.shared.data(from: url)
            guard let uiimg = UIImage(data: data) else{
                return defaultImage
            }
            let image = Image(uiImage: uiimg).resizable()
            downloadImages[url]=image
            return image
        }catch{
            print("error happen while download image \(error)")
        }
        return defaultImage
    }
}

func saveData() {
    let ctx = PersistenceHandler.shared.container.viewContext
    do{
        print("Save function executed")
        try ctx.save()
    } catch {
        fatalError("Error in save data with \(error)")
    }
}

func addPlace(){
    let ctx = PersistenceHandler.shared.container.viewContext
    @FetchRequest(entity:Places.entity() ,sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)])
    var places:FetchedResults<Places>
    let place = Places(context:ctx)
    place.name="New Place"
    place.detail=""
    place.zoom=10.0
    place.locationName="New Street"
    saveData()
}

func removePlace(places:[Places]){
    let ctx = PersistenceHandler.shared.container.viewContext
    places.forEach{
        ctx.delete($0)
    }
    saveData()
}

func fetchSunriseset(_ inputLong: String, _ inputLat: String, completion: @escaping ([String]) -> Void) {
    var inputLong = inputLong
    var inputLat = inputLat
    let urlStr2 = "https://api.sunrise-sunset.org/json?lat=\(inputLat)&lng=\(inputLong)"
    print(urlStr2)
    if let number = Double(inputLong) {
        let decimalLong = String(format: "%.2f", number)
        inputLong = decimalLong
    } else {
        print("Invalid input")
    }
    
    if let number = Double(inputLat) {
        let decimalLat = String(format: "%.2f", number)
        inputLat = decimalLat
    } else {
        print("Invalid input")
    }
    
    let urlStr = "https://api.sunrise-sunset.org/json?lat=\(inputLat)&lng=\(inputLong)"
    guard let url = URL(string: urlStr) else {
        return
    }
    
    let request = URLRequest(url: url)
    
    URLSession.shared.dataTask(with: request) { data, _, _ in
        guard let data = data,
              let api = try? JSONDecoder().decode(SunriseSunsetAPI.self, from: data)
        else {
            return
        }
        
        DispatchQueue.main.async {
            let sunrise = api.results.sunrise
            let sunset = api.results.sunset
            completion([sunrise, sunset])
        }
        
    }.resume()
}

func fetchTimeZone(_ inputLong:String, _ inputLat:String, completion:@escaping(String)->Void){
        let inputLong = inputLong
        let inputLat = inputLat
  
        let urlStr = "https://www.timeapi.io/api/TimeZone/coordinate?latitude=\(inputLat)&longitude=\(inputLong)"
        guard let url = URL(string: urlStr) else {
            return
        }
        let request = URLRequest(url: url)
        URLSession.shared.dataTask(with: request){
            data,_, _ in
            guard let data=data, let api=try?
                    JSONDecoder().decode(TimeZone.self, from: data)else{
                return
            }
            DispatchQueue.main.async {
                completion(api.timeZone)
                //print(api.timeZone)
            }
        }.resume()
    }

func timeConvertToGMT(from tm:String, to timezone:String)->String{
    
    let inputFormatter = DateFormatter()
    inputFormatter.dateFormat="h:mm:ss a" // use different format due to input will be "8:24:35 PM" format h= hour mm =minutes  ss = seconds a = pm or am
    

    inputFormatter.timeZone = Foundation.TimeZone(secondsFromGMT: 0)
    let outputFormatter = DateFormatter()
    outputFormatter.dateFormat="h:mm:ss a"
    outputFormatter.locale=Locale(identifier: "en_US_POSIX")
    outputFormatter.timeZone = Foundation.TimeZone(identifier: timezone)
    
    if let time = inputFormatter.date(from: tm){
        print("what was it?")
        print(outputFormatter.string(from: time))
        return outputFormatter.string(from: time)
        
    }
    return "Error caused in time to GMT"
    
}
