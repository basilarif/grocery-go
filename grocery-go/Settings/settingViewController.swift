//
//  settingViewController.swift
//  Grocery Go
//
//  Created by Basil Arif on 2020-04-01.
//  Copyright © 2020 Basil Arif. All rights reserved.
//

import Foundation
import UIKit
import Firebase

class settingsViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var profilePhoto: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var signOutBtn: UIButton!
    var uploadedPic:UIImage = UIImage()
    
    @IBAction func signOutUser(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        do {
            myAccount.userName = ""
            myAccount.email = ""
            myAccount.password = ""
            myAccount.name = ""
            myAccount.userID = ""
            //myAccount.profilePicture = nil
            try firebaseAuth.signOut()
            self.performSegue(withIdentifier: "backToSignIn", sender: self)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
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
            self.uploadedPic = image
            self.profilePhoto.image = self.uploadedPic
            guard let uid = Auth.auth().currentUser?.uid else { return }
            let fireStorePath = "gs://grocery-go-4268b.appspot.com"
            let storageRef = Storage.storage().reference().child(fireStorePath + "/user/profile-picture/\(uid)")
            
            guard let imageData = self.uploadedPic.jpegData(compressionQuality:0.7) else { return }
            
            let metaData = StorageMetadata()
            metaData.contentType = "image/jpg"
            storageRef.putData(imageData, metadata: metaData)
        }
//        uploadProfileImage(uploadedPic, completion: { (success) -> Void in
//            })
    }
    
    @IBAction func uploadNewPic(_ sender: Any) {
        let alert = UIAlertController(title: "Choose Image", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Camera", style: .default, handler: { _ in
            self.openCamera()
        }))
        
        alert.addAction(UIAlertAction(title: "Gallery", style: .default, handler: { _ in
            self.openGallery()
        }))
        
        alert.addAction(UIAlertAction.init(title: "Cancel", style: .cancel, handler: nil))
        
        self.present(alert, animated: true, completion: nil)
        
    }
//    func uploadProfileImage(_ image:UIImage, completion: @escaping ((_ url:URL?)->())) {
//        guard let uid = Auth.auth().currentUser?.uid else { return }
//        let storageRef = Storage.storage().reference().child("user/\(uid)")
//
//        guard let imageData = uploadedPic.jpegData(compressionQuality:0.7) else { return }
//
//        let metaData = StorageMetadata()
//        metaData.contentType = "image/jpg"
//
//        storageRef.putData(imageData, metadata: metaData) { metaData, error in
//            if error == nil, metaData != nil {
//
//                storageRef.downloadURL { url, error in
//                    completion(url)
//                    print("Success")
//                    // success!
//                }
//            } else {
//                // failed
//                print("failed")
//                completion(nil)
//            }
//        }
//    }
    
    
//    func uploadImagePic(uploadedPic :UIImage){
//        var data = NSData()
//        data = UIImageJPEGRepresentation(uploadedPic, 0.8)! as NSData
//        // set upload path
//        let filePath = "\(myAccount.userid)" // path where you wanted to store img in storage
//        let metaData = FIRStorageMetadata()
//        metaData.contentType = "image/jpg"
//        self.storageRef = FIRStorage.storage().reference()
//        self.storageRef.child(filePath).put(data as Data, metadata: metaData){(metaData,error) in
//            if let error = error {
//                print(error.localizedDescription)
//                return
//            }
//            else {
//                //store downloadURL
//                let downloadURL = metaData!.downloadURL()!.absoluteString
//            }
//        }
//    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let fireStorePath = "gs://grocery-go-4268b.appspot.com"
        let storageRef = Storage.storage().reference(withPath: fireStorePath + "/user/profile-picture/\(uid)")
        storageRef.getData(maxSize: 5*1024*1024){ (data, error) in
            if let error = error{
                print("Error \(error)")
            }
            if let data = data {
                //self.newImage.image = UIImage(data: data)
                
                self.profilePhoto.image = UIImage(data: data)
                self.profilePhoto.layer.cornerRadius = self.profilePhoto.frame.size.width/2
                self.profilePhoto.layer.borderColor = UIColor(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0).cgColor
                self.profilePhoto.layer.borderWidth = 2.4
            }
        }
        signOutBtn.layer.cornerRadius = 20
        containerView.layer.cornerRadius = 20
        self.userName.text = myAccount.userName
    }
}
