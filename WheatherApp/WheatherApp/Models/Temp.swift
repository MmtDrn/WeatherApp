//
//  Temp.swift
//  WeatherApp
//
//  Created by MacBook on 21.04.2022.
//

import Foundation

class Temp:Codable{
    
    var day:Double?
    var min:Double?
    var max:Double?
    
    init() {
    }
    
    init(day:Double,min:Double,max:Double) {
        self.day = day
        self.min = min
        self.max = max
    }
}
