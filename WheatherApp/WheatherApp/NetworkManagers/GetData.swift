//
//  GetData.swift
//  WeatherApp
//
//  Created by MacBook on 21.04.2022.
//

import Foundation

class WebService {
    
    func getDailyWeather(lat:String,lon:String,completion: @escaping ([Daily]?) -> ()) {
        
        var semaphore = DispatchSemaphore (value: 0)
        
        var request = URLRequest(url: URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&units=metric&exclude=minutely,alerts,hourly,current&lang=tr&appid=1d835fa8095dc0443598e78b3d71882a")!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
          guard let data = data else {
            print(String(describing: error))
            semaphore.signal()
            return
          }
        let daily = try? JSONDecoder().decode(DailyResponse.self, from: data)
            
            if let daily = daily {
                completion(daily.daily)
            }
            
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
    
    func getHourlyWeather(lat:String,lon:String,completion: @escaping ([Hourly]?) -> ()) {
        
        var semaphore = DispatchSemaphore (value: 0)
        
        var request = URLRequest(url: URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&units=metric&exclude=minutely,alerts,daily,current&lang=tr&appid=1d835fa8095dc0443598e78b3d71882a")!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
          guard let data = data else {
            print(String(describing: error))
            semaphore.signal()
            return
          }
        let hourly = try? JSONDecoder().decode(HourlyResponse.self, from: data)
            
            if let hourly = hourly {
                completion(hourly.hourly)
            }
            
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
    
    func getCurrentWeather(lat:String,lon:String,completion: @escaping (Current?) -> ()) {
        
        var semaphore = DispatchSemaphore (value: 0)
        
        var request = URLRequest(url: URL(string: "https://api.openweathermap.org/data/2.5/onecall?lat=\(lat)&lon=\(lon)&units=metric&exclude=minutely,alerts,hourly,daily&lang=tr&appid=1d835fa8095dc0443598e78b3d71882a")!,timeoutInterval: Double.infinity)
        request.httpMethod = "GET"
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            
          guard let data = data else {
            print(String(describing: error))
            semaphore.signal()
            return
          }
        let current = try? JSONDecoder().decode(CurrentResponse.self, from: data)
            
            if let current = current {
                completion(current.current)
            }
            
            semaphore.signal()
        }
        task.resume()
        semaphore.wait()
    }
    
    func parseJson(comletion: @escaping ([JsonData]) -> ()) {
        
        guard let path = Bundle.main.path(forResource: "cityList", ofType: "json") else { return  }
        
        let url = URL(fileURLWithPath: path)
        
        do {
            let jsonData = try Data(contentsOf: url)
            let result = try JSONDecoder().decode(JsonDataResult.self, from: jsonData)
            
            if let result = result.jsonData {
                comletion(result)
            }
        } catch {
            print(error)
        }
        
    }


}
