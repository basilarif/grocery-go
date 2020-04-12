//
//  homeViewController.swift
//  Grocery Go
//
//  Created by Basil Arif on 2020-04-01.
//  Copyright © 2020 Basil Arif. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class homeViewController: UIViewController {
    
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var newImage: UIImageView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userName.text = "Welcome " + myAccount.userName
        
        // Create a reference to the file you want to download
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let fireStorePath = "gs://grocery-go-4268b.appspot.com"
//        let downloadURL = StorageReference().child(fireStorePath + "/user/\(uid)")
//
//        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
//        downloadURL.getData(maxSize: 1 * 1024 * 1024) { data, error in
//            if let error = error {
//                print("error")
//                // Uh-oh, an error occurred!
//            } else {
//                // Data for "images/island.jpg" is returned
//                let image = UIImage(data: data!)
//                print("success")
//                self.newImage.image = image
//                myAccount.profilePicture = image
//            }
//        }
        let storageRef = Storage.storage().reference(withPath: fireStorePath + "/user/\(uid)")
        storageRef.getData(maxSize: 5*1024*1024){ (data, error) in
            if let error = error{
                self.newImage.image = UIImage(named: "background-profile")
                //print("Error \(error)")
            }
            if let data = data {
                self.newImage.image = UIImage(data: data)
                myAccount.profilePicture = UIImage(data: data)
            }
        }
    }
}
