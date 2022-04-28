//
//  CitiesTableViewCell.swift
//  WheatherApp
//
//  Created by MacBook on 26.04.2022.
//

import UIKit

protocol CitiesProtocol {
    func addToFav(indexPath:IndexPath)
    func deletefFromFav(indexPath:IndexPath)
}

class CitiesTableViewCell: UITableViewCell {
    
    @IBOutlet weak var labelCountry: UILabel!
    @IBOutlet weak var labelCity: UILabel!
    @IBOutlet weak var buttonOutlet: UIButton!
    
    var citiesProtocol:CitiesProtocol?
    var indexPath:IndexPath?
    var buttonImage = false
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func favButton(_ sender: Any) {
        if buttonImage{
            //buttonOutlet.setImage(UIImage(systemName: "star"), for: .normal)
            buttonImage = false
            citiesProtocol?.deletefFromFav(indexPath: indexPath!)
        }else{
            //buttonOutlet.setImage(UIImage(systemName: "star.fill"), for: .normal)
            buttonImage = true
            citiesProtocol?.addToFav(indexPath: indexPath!)
        }
    }
}
