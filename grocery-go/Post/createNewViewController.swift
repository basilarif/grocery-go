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


func hexStringToUIColor (hex:String) -> UIColor {
    var cString:String = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()
    
    if (cString.hasPrefix("#")) {
        cString.remove(at: cString.startIndex)
    }
    
    if ((cString.count) != 6) {
        return UIColor.gray
    }
    
    var rgbValue:UInt64 = 0
    Scanner(string: cString).scanHexInt64(&rgbValue)
    
    return UIColor(
        red: CGFloat((rgbValue & 0xFF0000) >> 16) / 255.0,
        green: CGFloat((rgbValue & 0x00FF00) >> 8) / 255.0,
        blue: CGFloat(rgbValue & 0x0000FF) / 255.0,
        alpha: CGFloat(1.0)
    )
}

let buttonSelectedColor = hexStringToUIColor(hex: "#51AD2A")

class imageArrayCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
}

class createNewViewController: UIViewController, UITextViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDataSource, UICollectionViewDelegate  {
    
    @IBOutlet weak var chooseStoreButton: UIButton!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var titleText: UITextView!
    @IBOutlet weak var descriptionText: UITextView!
    @IBOutlet weak var priceText: UITextView!
    @IBOutlet weak var forDeliveryButton: UIButton!
    @IBOutlet weak var toDeliverButton: UIButton!
    @IBOutlet weak var addPhotosButton: UIButton!
    @IBOutlet weak var addMorePhotosButton: UIButton!
    @IBOutlet weak var photosCollectionView: UICollectionView!
    @IBOutlet weak var postAddButton: UIButton!
    
    var receiptImageArr:[UIImage] = [UIImage()]
    var receiptFileNameArr:[String] = []
    var receiptImage:UIImage = UIImage()
    
    var adPurpose: String!
    let reuseIdentifier = "cell"
    
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
            forDeliveryButton.backgroundColor = buttonSelectedColor
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
            toDeliverButton.backgroundColor = buttonSelectedColor
            toDeliverButton.setTitleColor(UIColor.white, for: .selected)
        }
        forDeliveryButton.isSelected = false
        forDeliveryButton.backgroundColor = .white
        forDeliveryButton.setTitleColor(UIColor.black, for: .normal)
        adPurpose = "To Deliver"
    }
    
    // Adding Photos
    
    func openCamera()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.camera) {
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.sourceType = UIImagePickerController.SourceType.camera
            imagePicker.allowsEditing = false
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have camera", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func openGallery()
    {
        if UIImagePickerController.isSourceTypeAvailable(UIImagePickerController.SourceType.photoLibrary){
            let imagePicker = UIImagePickerController()
            imagePicker.delegate = self
            imagePicker.allowsEditing = false
            imagePicker.sourceType = UIImagePickerController.SourceType.photoLibrary
            self.present(imagePicker, animated: true, completion: nil)
        }
        else
        {
            let alert  = UIAlertController(title: "Warning", message: "You don't have permission to access gallery.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        guard let image = info[.originalImage] as? UIImage else {
            print("No image found")
            return
        }
        DispatchQueue.main.async {
            self.receiptImage = image
            self.receiptImageArr.append(self.receiptImage)
        }
    }
    
    @IBAction func addPhotos(_ sender: Any) {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        //self.performSegue(withIdentifier: "addPhotos", sender: self)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            return receiptImageArr.count
        }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath as IndexPath) as! imageArrayCell
            cell.image.image = receiptImageArr[indexPath.item] //image
            cell.backgroundColor = UIColor.clear // make cell more visible in our example project
        cell.image.setNeedsDisplay()
            
            return cell
        }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageView = UIImageView(image:receiptImageArr[indexPath.row])
        imageView.frame = self.view.frame
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        imageView.addGestureRecognizer(tap)
        
        self.view.addSubview(imageView)
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }

    // Posting Ad
    @IBAction func postAdd(_ sender: Any) {
            // Add firebase call here
            // Need to call to add new post into database and show it in the "my posts" sections
            //self.performSegue(withIdentifier: "post", sender: self)
        }
    
    
    override func viewDidLoad() {
//        photosCollectionView.isHidden = true
//        addMorePhotosButton.isHidden = true
        receiptImageArr.remove(at: 0)
        print("Number of item: ")
        print(receiptImageArr.count)
        addPhotosButton.isHidden = false
        addMorePhotosButton.isHidden = true
        photosCollectionView.isHidden = true
        chooseStoreButton.isHidden = true
        containerView.layer.cornerRadius = 20
        titleText.delegate = self
//        titleText.clipsToBounds = true
//        titleText.layer.cornerRadius = 20
        descriptionText.delegate = self
//        descriptionText.clipsToBounds = true
//        descriptionText.layer.cornerRadius = 20
        priceText.delegate = self
//        priceText.clipsToBounds = true
//        priceText.layer.cornerRadius = 20
        forDeliveryButton.isSelected = false
        toDeliverButton.isSelected = false
        forDeliveryButton.layer.cornerRadius = 20
        toDeliverButton.layer.cornerRadius = 20
        photosCollectionView.delegate = self
        postAddButton.isEnabled = false
        postAddButton.layer.cornerRadius = 20
    }
    
    override func viewDidAppear(_ animated: Bool) {
        photosCollectionView.reloadData()
        print(receiptImageArr.count)
        if  receiptImageArr.count >= 1 {
            print("Yes")
            addPhotosButton.isHidden = true
            addMorePhotosButton.isHidden = false
            photosCollectionView.isHidden = false
        } else {
            print("no")
            addPhotosButton.isHidden = false
            addMorePhotosButton.isHidden = true
            photosCollectionView.isHidden = true
        }
    }
}
