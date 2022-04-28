//
//  Hourly.swift
//  WeatherApp
//
//  Created by MacBook on 21.04.2022.
//

import Foundation

class Hourly:Codable{
    
    var dt:Date?
    var temp:Double?
    var weather:[Weather]?
    
    init() {
    }
    
    init(dt:Date,temp:Double,weather:[Weather]) {
        self.dt = dt
        self.temp = temp
        self.weather = weather
    }
}
