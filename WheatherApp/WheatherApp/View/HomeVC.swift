//
//  ViewController.swift
//  WheatherApp
//
//  Created by MacBook on 25.04.2022.
//

import UIKit
import CoreLocation

class HomeVC: UIViewController {
    
    var locationmanager = CLLocationManager()
    var lat:String = ""
    var long:String = ""
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var imageCurrent: UIImageView!
    @IBOutlet weak var currentLabel: UILabel!
    @IBOutlet weak var hourlyCollectionView: UICollectionView!
    @IBOutlet weak var dailyTableView: UITableView!
    
    var currentWeather = Current()
    var hourlyWeather = [Hourly]()
    var dailyWeather = [Daily]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        locationSetup()
        
        hourlyCollectionView.delegate = self
        hourlyCollectionView.dataSource = self
        
        dailyTableView.delegate = self
        dailyTableView.dataSource = self
        
        getData()
        setupCurrent()
        
        print("Lat: \(lat), Long: \(long)")
    }
    
    func locationSetup(){
        
        locationmanager.desiredAccuracy = kCLLocationAccuracyBest
        locationmanager.delegate = self
        locationmanager.requestWhenInUseAuthorization()
        locationmanager.startUpdatingLocation()
        
        if let lokasyon = locationmanager.location {
            lat = lokasyon.coordinate.latitude.debugDescription
            long = lokasyon.coordinate.longitude.debugDescription
        }
    }
    
    func setupCurrent(){
        
        currentLabel.text = String(format: "%0.0f°\n\(currentWeather.weather![0].description!.capitalized)",currentWeather.temp!)
        
        if let icon = currentWeather.weather![0].icon {
            
            if let url = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png") {
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: url)
                    DispatchQueue.main.async {
                        self.imageCurrent.image = UIImage(data: data!)
                    }
                }
            }
        }
    }
    
    func getData(){
        
        WebService().getCurrentWeather(lat: lat, lon: long) { currently in
            
            if let currently = currently {
                self.currentWeather = currently
            }
        }
        WebService().getHourlyWeather(lat: lat, lon: long) { hourly in
            
            if let hourly = hourly {
                
                for indeks in 0...23 {
                    self.hourlyWeather.append(hourly[indeks])
                }
            }
        }
        WebService().getDailyWeather(lat: lat, lon: long) { daily in
            if let daily = daily {
                for indeks in 0...6 {
                    self.dailyWeather.append(daily[indeks])
                }
            }
        }
        
    }
}

extension HomeVC:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyWeather.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let daily = dailyWeather[indexPath.row]
        
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "dailyCell", for: indexPath) as! DailyTableViewCell
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "EEEE"
        let dayName = dateFormatter.string(from: daily.dt!)
        
        cell.dateLabel.text = dayName
        cell.dereceLabel.text = String(format: "%0.0f°",daily.temp!.day!)
        cell.weatherDesc.text = daily.weather![0].description!.capitalized
        
        if let icon = daily.weather![0].icon {
            
            if let url = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png") {
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: url)
                    DispatchQueue.main.async {
                        if let data = data {
                            cell.weatherImage.image = UIImage(data: data)
                        }
                    }
                }
            }
        }
        
        return cell
    }
}

extension HomeVC:UICollectionViewDelegate,UICollectionViewDataSource {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return hourlyWeather.count
    }
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let hourly = hourlyWeather[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "hourlyCell", for: indexPath) as! HourlyCollectionViewCell
        
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm"
        let hour = dateFormatter.string(from: hourly.dt!)
        
        cell.degreeLabel.text = String(format: "%0.0f°",hourly.temp!)
        cell.hourLabel.text = hour
        
        if let icon = hourly.weather![0].icon {
            
            if let url = URL(string: "https://openweathermap.org/img/wn/\(icon)@2x.png") {
                DispatchQueue.global().async {
                    let data = try? Data(contentsOf: url)
                    DispatchQueue.main.async {
                        if let data = data {
                            cell.weatherImage.image = UIImage(data: data)
                        }
                    }
                }
            }
        }
        
        return cell
    }
}

extension HomeVC:CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        if let kor = locations.first {
            
            self.lat = kor.coordinate.latitude.debugDescription
            self.long = kor.coordinate.longitude.debugDescription
            
            locationmanager.stopUpdatingLocation()
        }
    
    }
}
