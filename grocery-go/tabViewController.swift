//
//  tabViewController.swift
//  grocery-go
//
//  Created by Basil Arif on 2020-04-15.
//  Copyright © 2020 Basil Arif. All rights reserved.
//

import Foundation
import UIKit

class tabViewController: UITabBarController {
    
//    override func tabBar(_ tabBar: UITabBar, didSelect item: UITabBarItem) {
//        let rootView = self.viewControllers![self.selectedIndex]
//        rootView.popToRootViewController(animated: false)
//    }
//    
    override func viewDidLoad() {
        super.viewDidLoad()
//        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.gray], for: .normal)
        
        self.tabBar.items?[0].image = UIImage(named: "home")?.withRenderingMode(.alwaysOriginal)
        self.tabBar.items?[0].selectedImage = UIImage(named: "home-selected")?.withRenderingMode(. alwaysOriginal)
        self.tabBar.items?[0].setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        self.tabBar.items?[0].setTitleTextAttributes([NSAttributedString.Key.foregroundColor: groceryGoGreen], for: .selected)
        
        self.tabBar.items?[1].image = UIImage(named: "post")?.withRenderingMode(.alwaysOriginal)
        self.tabBar.items?[1].selectedImage = UIImage(named: "post-selected")?.withRenderingMode(. alwaysOriginal)
        self.tabBar.items?[1].setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        self.tabBar.items?[1].setTitleTextAttributes([NSAttributedString.Key.foregroundColor: groceryGoGreen], for: .selected)
        
        self.tabBar.items?[2].image = UIImage(named: "messages")?.withRenderingMode(.alwaysOriginal)
        self.tabBar.items?[2].selectedImage = UIImage(named: "messages-selected")?.withRenderingMode(. alwaysOriginal)
        self.tabBar.items?[2].setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        self.tabBar.items?[2].setTitleTextAttributes([NSAttributedString.Key.foregroundColor: groceryGoGreen], for: .selected)
        
        self.tabBar.items?[3].image = UIImage(named: "settings")?.withRenderingMode(.alwaysOriginal)
        self.tabBar.items?[3].selectedImage = UIImage(named: "settings-selected")?.withRenderingMode(. alwaysOriginal)
        self.tabBar.items?[3].setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.black], for: .normal)
        self.tabBar.items?[3].setTitleTextAttributes([NSAttributedString.Key.foregroundColor: groceryGoGreen], for: .selected)
    }
}
