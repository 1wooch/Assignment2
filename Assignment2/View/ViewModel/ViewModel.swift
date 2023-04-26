//
//  ViewModel.swift
//  Assignment2
//
//  Created by 최원우 on 26/4/2023.
//

import Foundation
import CoreData

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
            self.detail ?? ""
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
            self.url?.absoluteString ?? ""
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
    
    
}


func saveData() {
    let ctx = PersistenceHandler.shared.container.viewContext
    do{
        try ctx.save()
    } catch {
        fatalError("Error in save data with \(error)")
    }
}
