//
//  Daily.swift
//  WeatherApp
//
//  Created by MacBook on 21.04.2022.
//

import Foundation

class Daily:Codable {
    
    var dt:Date?
    var temp:Temp?
    var weather:[Weather]?
    
    init() {
    }
    
    init(dt:Date,temp:Temp,weather:[Weather]) {
        self.dt = dt
        self.temp = temp
        self.weather = weather
    }
}
