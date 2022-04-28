//
//  CitiesVC.swift
//  WheatherApp
//
//  Created by MacBook on 26.04.2022.
//

import UIKit

let appDelegate = UIApplication.shared.delegate as! AppDelegate

class CitiesVC: UIViewController, CitiesProtocol {
    
    let context = appDelegate.persistentContainer.viewContext
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var tableView: UITableView!
    
    var jsonData = [JsonData]()
    var searchingJsonData = [JsonData]()
    var searching = false

    override func viewDidLoad() {
        super.viewDidLoad()

        WebService().parseJson { jsonData in
            self.jsonData = jsonData
        }
        
        tableView.delegate = self
        tableView.dataSource = self
        
        searchBar.delegate = self
    }
}

extension CitiesVC:UITableViewDelegate,UITableViewDataSource {

    func addToFav(indexPath: IndexPath) {
        
        if searching{
            let city = searchingJsonData[indexPath.row]
            let citie = JsonCities(context: self.context)
            
            citie.id = Int16(truncatingIfNeeded: city.id!)
            citie.name = city.name!
            citie.country = city.country!
            citie.state = city.state
            citie.lat = city.coord!.lat!.debugDescription
            citie.long = city.coord!.lon!.debugDescription
                    
            appDelegate.saveContext()
        }else{
            let city = jsonData[indexPath.row]
            let citie = JsonCities(context: self.context)
            
            citie.id = Int16(truncatingIfNeeded: city.id!)
            citie.name = city.name!
            citie.country = city.country!
            citie.state = city.state
            citie.lat = city.coord!.lat!.debugDescription
            citie.long = city.coord!.lon!.debugDescription
                    
            appDelegate.saveContext()
        }
    }
    func deletefFromFav(indexPath: IndexPath) {
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searching{
            return searchingJsonData.count
        }else{
            return jsonData.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "citiesCell", for: indexPath) as! CitiesTableViewCell
        
        if searching{
            let city = searchingJsonData[indexPath.row]
            
            cell.labelCountry.text = "Ülke: \(city.country!)"
            cell.labelCity.text = "Şehir: \(city.name!)"
        }else{
            let city = jsonData[indexPath.row]
            
            cell.labelCountry.text = "Ülke: \(city.country!)"
            cell.labelCity.text = "Şehir: \(city.name!)"
        }
        
        
        cell.citiesProtocol = self
        cell.indexPath = indexPath
        
        return cell
    }
}

extension CitiesVC:UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        if searchText == ""{
            self.searching = false
        }else{
            self.searching = true
            
            self.searchingJsonData = self.jsonData.filter({ jsonData in
                jsonData.name!.lowercased().contains(searchText.lowercased())
            })
        }
        self.tableView.reloadData()
    }
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        view.endEditing(true)
    }
}
