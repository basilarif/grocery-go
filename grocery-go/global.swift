//
//  global.swift
//  Grocery Go
//
//  Created by Basil Arif on 2020-03-30.
//  Copyright © 2020 Basil Arif. All rights reserved.
//

import Foundation
import UIKit

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

let groceryGoGreen = hexStringToUIColor(hex: "#51AD2A")

struct myAccount {
    static var userName: String = ""
    static var email: String = ""
    static var password: String = ""
    static var name: String = ""
    static var userID: String = ""
    static var profilePicture = UIImage(named:"background-profile")
    //static var googleAPIKey: String = "AIzaSyDcsTcrA3Zpf_b6Gb0zDPMonCSJVoqHYQ4"
    
}
