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

class createNewViewController: UIViewController, UITextViewDelegate {
    
    @IBOutlet weak var chooseStoreButton: UIButton!
    @IBOutlet weak var titleText: UITextView!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var priceText: UITextView!
    @IBOutlet weak var forDeliveryButton: UIButton!
    @IBOutlet weak var toDeliverButton: UIButton!
    @IBOutlet weak var addPhotosButton: UIButton!
    @IBOutlet weak var postAddButton: UIButton!
    var adPurpose: String!
    
    // Choosing store: Currently unavailable
    @IBAction func chooseStore(_ sender: Any) {
            self.performSegue(withIdentifier: "chooseStore", sender: self)
    }
    
    
    // Text Body
    func textViewDidBeginEditing(_ textView: UITextView) {
        if titleText.text == "Title" {
            titleText.text = nil
            titleText.textColor = UIColor.black
        }
        else if descriptionText.text == "Description" {
            descriptionText.text = nil
            descriptionText.textColor = UIColor.black
        }
        else if priceText.text == "Price" {
            priceText.text = "$"
            priceText.textColor = UIColor.black
        }
        if (titleText.text == "" || titleText.text == "Title")
            || (descriptionText.text == "" || descriptionText.text == "Description")
            || ((priceText.text == "" || priceText.text == "$") || priceText.text == "Price")
            || adPurpose == "" {
            postAddButton.layer.opacity = 0.4
            postAddButton.isEnabled = false
        } else {
            postAddButton.layer.opacity = 1
            postAddButton.isEnabled = true
        }
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        if titleText.text == "" {
            titleText.text = "Title"
            titleText.textColor = .lightGray
        }
        if descriptionText.text == "" {
            descriptionText.text = "Description"
            descriptionText.textColor = .lightGray
        }
        if priceText.text == "" {
            priceText.text = "Price"
            priceText.textColor = .lightGray
        }
    }

    
    // Buttons
    @IBAction func forDelivery(_ sender: Any) {
        if forDeliveryButton.isSelected == true {
            forDeliveryButton.isSelected = false
            forDeliveryButton.backgroundColor = .white
            forDeliveryButton.setTitleColor(UIColor.black, for: .normal)
        }
        else {
            forDeliveryButton.isSelected = true
            forDeliveryButton.backgroundColor = .green
            forDeliveryButton.setTitleColor(UIColor.white, for: .selected)
        }
        toDeliverButton.isSelected = false
        toDeliverButton.backgroundColor = .white
        toDeliverButton.setTitleColor(UIColor.black, for: .normal)
        adPurpose = "Delivery"
    }
    
    @IBAction func toDeliver(_ sender: Any) {
        if toDeliverButton.isSelected == true {
            toDeliverButton.isSelected = false
            toDeliverButton.backgroundColor = .white
            toDeliverButton.setTitleColor(UIColor.black, for: .normal)
        }
        else {
            toDeliverButton.isSelected = true
            toDeliverButton.backgroundColor = .green
            toDeliverButton.setTitleColor(UIColor.white, for: .selected)
        }
        forDeliveryButton.isSelected = false
        forDeliveryButton.backgroundColor = .white
        forDeliveryButton.setTitleColor(UIColor.black, for: .normal)
        adPurpose = "To Deliver"
    }
    
    // Adding Photos
    @IBAction func addPhotos(_ sender: Any) {
        self.performSegue(withIdentifier: "addPhotos", sender: self)
    }
    
    // Posting Ad
    @IBAction func postAdd(_ sender: Any) {
            // Add firebase call here
            // Need to call to add new post into database and show it in the "my posts" sections
            //self.performSegue(withIdentifier: "post", sender: self)
        }
    
    
    override func viewDidLoad() {
        chooseStoreButton.isHidden = true
        titleText.delegate = self
        descriptionText.delegate = self
        priceText.delegate = self
        forDeliveryButton.isSelected = false
        toDeliverButton.isSelected = false
        forDeliveryButton.layer.cornerRadius = 20
        toDeliverButton.layer.cornerRadius = 20
        postAddButton.isEnabled = false
        postAddButton.layer.cornerRadius = 20
    }
}
