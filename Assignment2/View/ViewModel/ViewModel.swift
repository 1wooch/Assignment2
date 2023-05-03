//
//  ViewModel.swift
//  Assignment2
//
//  Created by 최원우 on 26/4/2023.
//

import Foundation
import CoreData

import SwiftUI

let defaultImage=Image(systemName: "photo").resizable()

var downloadImages :[URL:Image] = [:]

extension Places{
    var strName:String{
        get{
            self.name ?? "New Place"
        }set{
            self.name=newValue
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
    saveData()
}
//func removeItem(offsets:IndexSet){
//    let ctx = PersistenceHandler.shared.container.viewContext
//    @FetchRequest(entity:Places.entity() ,sortDescriptors: [NSSortDescriptor(key: "name", ascending: true)])
//    var places:FetchedResults<Places>
//    for index in offsets{
//        let place = places[index]
//        ctx.delete(place)
//        saveData()
//    }
//}
func removePlace(places:[Places]){
    let ctx = PersistenceHandler.shared.container.viewContext
    places.forEach{
        ctx.delete($0)
    }
    saveData()
}

