//
//  JsonData.swift
//  WheatherApp
//
//  Created by MacBook on 26.04.2022.
//

import Foundation

class JsonDataResult:Codable {
    
    var jsonData:[JsonData]?
}

class JsonData:Codable {
    
    var id:Int?
    var name:String?
    var state:String?
    var country:String?
    var coord:Coordinate?
    
    init() {
    }
    
    init(id:Int,name:String,state:String,country:String,coord:Coordinate) {
        self.id = id
        self.name = name
        self.state = state
        self.country = country
        self.coord = coord
    }
}

class Coordinate:Codable {
    
    var lon:Double?
    var lat:Double?
    
    init() {
    }
    
    init(lon:Double,lat:Double) {
        self.lat = lat
        self.lon = lon
    }
}
