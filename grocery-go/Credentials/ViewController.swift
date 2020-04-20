//
//  ViewController.swift
//  grocery-go
//
//  Created by Basil Arif on 2020-04-07.
//  Copyright © 2020 Basil Arif. All rights reserved.
//

import UIKit
import Firebase

class ViewController: UIViewController {

    override func viewDidLoad() {
        navigationController?.isNavigationBarHidden = true
        checkAuth()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func checkAuth(){
        if Auth.auth().currentUser != nil {
            print("auth is not nil")
            self.updateMyAccount(uid: Auth.auth().currentUser!.uid){(success) in
                if success == "success" {
                    self.performSegue(withIdentifier: "goHome", sender: self)
                } else {
                    print("could not load user data")
                }
            }
            
        }
    }
    
    func updateMyAccount(uid:String, completion: @escaping (_ message: String) -> Void){
        let db = Firestore.firestore()
        let userRef = db.collection("users").whereField("uid", isEqualTo: uid)
        userRef.getDocuments() {
            (querySnapshot, error) in
            if let error = error {
                print("Error getting host documents: \(error)")
            } else {
                for document in querySnapshot!.documents {
                    let email = document.data()["email"] as! String
                    let username = document.data()["username"] as! String
                    let name = document.data()["name"] as! String
                    myAccount.userName = username
                    myAccount.email = email
                    myAccount.name = name
                    completion("success")
                }
                
            }
        }
    }

}

