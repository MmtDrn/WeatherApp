//
//  FavVC.swift
//  WheatherApp
//
//  Created by MacBook on 25.04.2022.
//

import UIKit

class FavVC: UIViewController {
    
    let context = appDelegate.persistentContainer.viewContext
    @IBOutlet weak var favCitiesTableView: UITableView!
    var cities = [JsonCities]()
    var currentWeather = [Current]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        favCitiesTableView.delegate = self
        favCitiesTableView.dataSource = self
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        do {
            self.cities = try context.fetch(JsonCities.fetchRequest())
            
            DispatchQueue.main.async {
                self.favCitiesTableView.reloadData()
            }
        } catch {
            print(error.localizedDescription)
        }
        for city in cities {
            
            WebService().getCurrentWeather(lat: city.lat!, lon: city.long!) { current in
                if let current = current {
                    self.currentWeather.append(current)
                }
            }
        }
    }
}

extension FavVC:UITableViewDelegate,UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cities.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let city = cities[indexPath.row]
        let weather = currentWeather[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "favCell", for: indexPath) as! FavTableViewCell
        
        cell.cityNameLabel.text = city.name?.capitalized
        cell.degreesLabel.text = String(format: "%0.0f°",weather.temp!)
        cell.weatherDescp.text = weather.weather![0].description!.capitalized
        
        if let icon = weather.weather![0].icon {
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
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        let city = cities[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: "Sil"){ [self]
            (contextualAction, view, boolValue) in
            
            self.context.delete(city)
            appDelegate.saveContext()
            
            DispatchQueue.main.async {
                do {
                    self.cities = try self.context.fetch(JsonCities.fetchRequest())
                    
                    DispatchQueue.main.async {
                        self.favCitiesTableView.reloadData()
                    }
                } catch {
                    print(error.localizedDescription)
                }
                
                self.favCitiesTableView.reloadData()
            }
        }
        return UISwipeActionsConfiguration(actions: [deleteAction])
    }
}
