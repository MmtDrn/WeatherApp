//
//  WeatherInfo.swift
//  WeatherApp
//
//  Created by MacBook on 21.04.2022.
//

import Foundation

class Weather:Codable {
    
    var description:String?
    var icon:String?
    
    init() {
    }
    
    init(description:String,icon:String) {
        self.description = description
        self.icon = icon
    }
}
