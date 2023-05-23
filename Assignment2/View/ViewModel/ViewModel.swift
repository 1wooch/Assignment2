//
//  ViewModel.swift
//  Assignment2
//
//  Created by 최원우 on 26/4/2023.
//

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
        var inputLong = inputLong
        var inputLat = inputLat
    let urlStr2 =
    "https://www.timeapi.io/api/TimeZone/coordinate?latitude=\(inputLat)&longitude=\(inputLong)"
    
        if let number = Double(inputLong) {
            let decimalLong = String(format: "%.2f", number)
            inputLong=decimalLong
            //decimalLongValue=decimalLong
        } else {
            print("Invalid input")
        }
        if let number = Double(inputLat) {
             let decimalLat = String(format: "%.2f", number)
             inputLat=decimalLat
        } else {
            print("Invalid input")
        }
        let urlStr =
        "https://www.timeapi.io/api/TimeZone/coordinate?latitude=\(inputLat)&longitude=\(inputLong)"
        guard let url = URL(string: urlStr2) else {
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

            }
        }.resume()
    }
