//
//  signInViewController.swift
//  Grocery Go
//
//  Created by Basil Arif on 2020-03-30.
//  Copyright © 2020 Basil Arif. All rights reserved.
//

import Foundation
import Firebase
import UIKit


import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG

//func md5( string: String) -> String {
//    var digest = [UInt8](repeating: 0, count: Int(CC_MD5_DIGEST_LENGTH))
//    if let data = string.data(using: String.Encoding.utf8) {
//        CC_MD5(data.withUnsafeBytes, CC_LONG(data.count), &digest)
//    }
//
//    var digestHex = ""
//    for index in 0..<Int(CC_MD5_DIGEST_LENGTH) {
//        digestHex += String(format: "%02x", digest[index])
//    }
//
//    return digestHex
//}


class signUpViewController: UIViewController {
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var name: UITextField!
    @IBOutlet weak var createAccountButton: UIButton!
    
    @IBAction func textInput(_ sender: UITextField) {
        if (userName.hasText && email.hasText) && (password.hasText && name.hasText) {
            createAccountButton.layer.opacity = 1
            createAccountButton.isEnabled = true
        }
        else {
            createAccountButton.layer.opacity = 0.4
            createAccountButton.isEnabled = false
        }
    }
    
    @IBAction func newCreateAccount(_ sender: Any) {
        let emailString = email.text!
        Auth.auth().createUser(withEmail: emailString, password: password.text!) { authResult, error in
            // ...
            print("authenticated")
            //let md5Data = md5(string:self.password.text!)
            //let md5Hex =  md5Data.map { String(format: "%02hhx", $0) }.joined()
            let emailString = self.email.text!
            let emailComma = emailString.replacingOccurrences(of: ".", with: ",")
            self.userName.text = self.userName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            
            //setting up user object
            myAccount.userName = self.userName.text!
            myAccount.email = self.email.text!
            myAccount.password = self.password.text!//md5Hex
            
            // Add Data to firebase
            let db = Firestore.firestore()
            db.collection("users").document(emailComma).setData([
                "email": self.email.text!,
                "username": self.userName.text!,
                "name": self.name.text!,
                "uid"   : authResult?.user.uid
                ])
            self.performSegue(withIdentifier: "signedUp", sender: self)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = true
        createAccountButton.layer.opacity = 0.4
        createAccountButton.isEnabled = false
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIInputViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    @objc func keyboardWillShow(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIResponder.keyboardFrameBeginUserInfoKey] as? NSValue)?.cgRectValue {
            if self.view.frame.origin.y == 0 {
                self.view.frame.origin.y -= keyboardSize.height/2
            }
        }
    }
    
    @objc func keyboardWillHide(notification: NSNotification) {
        if self.view.frame.origin.y != 0 {
            self.view.frame.origin.y = 0
        }
    }
}
