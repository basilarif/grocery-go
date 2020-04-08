//
//  chooseStoreViewController.swift
//  Grocery Go
//
//  Created by Basil Arif on 2020-04-04.
//  Copyright © 2020 Basil Arif. All rights reserved.
//

import Foundation
import UIKit
import Firebase
import CoreLocation
import Alamofire

struct storeDetails {
    let image: UIImageView
    let storeName: UILabel
    let storeAddress: UILabel
    let distance: UILabel
}

class chooseStoreCell: UITableViewCell {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}

class chooseStoreViewController: UIViewController {
    
    // User Latitude and Longitude
    var currentLocationLat = 0 as Double
    var currentLocationLon = 0 as Double
    
    // Table View Details
    @IBOutlet weak var tableView: UITableView!
    var sDetails = [storeDetails]()
    let cellSpacingHeight: CGFloat = 5
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sDetails.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = .clear
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
//    func getStoresData() {
//        let placesURL = "https://maps.googleapis.com/maps/api/place/nearbysearch/json?location=\(String(self.currentLocationLat)),\(String(self.currentLocationLon))&radius=2000&keyword=Grocery store&key=" + myAccount.googleAPIKey
//        print(placesURL)
//        Alamofire.request(placesURL).responseJSON{
//            response in
//            let result = response.result.value
//            let JSON = result as! NSDictionary
//            print(JSON)
//        }
//    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first{
            currentLocationLat = location.coordinate.latitude
            currentLocationLon = location.coordinate.longitude
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Failed to find user's location: \(error.localizedDescription)")
    }
    
    
    
    override func viewDidLoad() {
        //getStoresData()
    }
}
