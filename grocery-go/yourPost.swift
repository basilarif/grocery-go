//
//  yourPost.swift
//  grocery-go
//
//  Created by Basil Arif on 2020-04-11.
//  Copyright © 2020 Basil Arif. All rights reserved.
//

import Foundation
import UIKit
import Firebase

struct yourPost: Equatable{
    let title: String
    let description: String
    let price: String
    let timeStamp: String
    let imageArray: [UIImage]
}
