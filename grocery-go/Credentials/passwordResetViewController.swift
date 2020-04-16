//
//  passwordResetViewController.swift
//  grocery-go
//
//  Created by Basil Arif on 2020-04-16.
//  Copyright © 2020 Basil Arif. All rights reserved.
//

import Foundation
import UIKit
import Firebase


class passwordResetViewController: UIViewController {
    
    @IBOutlet weak var emailBox: UITextField!
    @IBOutlet weak var sendEmailButton: UIButton!
    @IBOutlet weak var message: UILabel!
    @IBOutlet weak var homePageButton: UIButton!
    
    @IBAction func textInput(_ sender: UITextField) {
        if emailBox.hasText {
            sendEmailButton.layer.opacity = 1
            sendEmailButton.isEnabled = true
        }
        else {
            sendEmailButton.layer.opacity = 0.4
            sendEmailButton.isEnabled = false
        }
    }
    
    @IBAction func sendEmail (_sender: Any) {
        Auth.auth().sendPasswordReset(withEmail: emailBox.text!) { error in
            // ...
        }
        emailBox.isHidden = true
        sendEmailButton.isHidden = true
        message.isHidden = false
        homePageButton.isHidden = false
    }
    
    override func viewDidLoad() {
        sendEmailButton.layer.opacity = 0.4
        sendEmailButton.isEnabled = false
        message.isHidden = true
        homePageButton.isHidden = true
    }
}
