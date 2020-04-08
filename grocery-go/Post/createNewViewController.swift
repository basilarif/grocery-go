//
//  createNewViewController.swift
//  Grocery Go
//
//  Created by Basil Arif on 2020-04-04.
//  Copyright © 2020 Basil Arif. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class createNewViewController: UIViewController {
    
    @IBOutlet weak var chooseStoreButton: UIButton!
    @IBOutlet weak var titleText: UITextField!
    @IBOutlet weak var descriptionText: UITextField!
    @IBOutlet weak var priceText: UITextField!
    @IBOutlet weak var forDeliveryButton: UIButton!
    @IBOutlet weak var toDeliverButton: UIButton!
    @IBOutlet weak var addPhotosButton: UIButton!
    @IBOutlet weak var postAddButton: UIButton!
    var adPurpose: String!
    
    @IBAction func chooseStore(_ sender: Any) {
            self.performSegue(withIdentifier: "chooseStore", sender: self)
    }
    
    @IBAction func adPurpose(_ sender: Any) {
        if forDeliveryButton.isSelected {
            forDeliveryButton.backgroundColor = .green
            forDeliveryButton.setTitleColor(UIColor.white, for: .selected)
            toDeliverButton.backgroundColor = .white
            toDeliverButton.setTitleColor(UIColor.black, for: .selected)
            adPurpose = "Delivery"
        }
        if toDeliverButton.isSelected {
            toDeliverButton.backgroundColor = .green
            toDeliverButton.setTitleColor(UIColor.white, for: .selected)
            forDeliveryButton.backgroundColor = .white
            forDeliveryButton.setTitleColor(UIColor.black, for: .selected)
            adPurpose = "To Deliver"
        }
        else {
            adPurpose = ""
        }
    }
    
    @IBAction func addPhotos(_ sender: Any) {
        self.performSegue(withIdentifier: "addPhotos", sender: self)
    }
    
    @IBAction func postAdd(_ sender: Any) {
        if titleText.text == "" || descriptionText.text == "" || priceText.text == "" || adPurpose == "" {
            postAddButton.layer.opacity = 0.4
            postAddButton.isEnabled = false
        } else {
            postAddButton.layer.opacity = 1
            postAddButton.isEnabled = true
            // Add firebase call here
            // Need to call to add new post into database and show it in the "my posts" sections
            //self.performSegue(withIdentifier: "post", sender: self)
        }
    }
    
    
    override func viewDidLoad() {
        forDeliveryButton.layer.cornerRadius = 20
        toDeliverButton.layer.cornerRadius = 20
    }
}
