//
//  postViewController.swift
//  Grocery Go
//
//  Created by Basil Arif on 2020-04-04.
//  Copyright © 2020 Basil Arif. All rights reserved.
//

import Foundation
import UIKit

class yourPostCell: UITableViewCell {
    
    @IBOutlet weak var titleText: UILabel!
    @IBOutlet weak var descriptionText: UILabel!
    @IBOutlet weak var priceText: UILabel!
    @IBOutlet weak var timeElapsed: UILabel!
    @IBOutlet weak var cellPhoto: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
}


class postViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var postData = [yourPost]()
    
    var titleString: String!
    var descriptionString: String!
    var priceString: String!
    var timeStampString: String!
    var picsArray:[UIImage] = [UIImage()]
    var storeIndexPath: String!
    
    @IBOutlet weak var yourPostTable: UITableView!
    
    let cellSpacingHeight: CGFloat = 5

    func numberOfSections(in tableView: UITableView) -> Int {
        return self.postData.count
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return cellSpacingHeight
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int){
        view.tintColor = .clear
        let header = view as! UITableViewHeaderFooterView
        header.textLabel?.textColor = UIColor.white
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func viewDidLoad() {
        self.tabBarController?.tabBar.isHidden = false
        postData = [
            yourPost(title: "", description: "", price: "", timeStamp: "", imageArray: [])
        ]
        self.postData.append(yourPost(title: titleString ?? "", description: descriptionString ?? "", price: priceString ?? "", timeStamp: "", imageArray: picsArray))
        self.postData.removeFirst()
        self.yourPostTable.reloadData()
        self.yourPostTable.contentSize.height = CGFloat(self.postData.count * 66)
        self.yourPostTable.tableFooterView = UIView(frame: CGRect.zero)
        self.yourPostTable.rowHeight = 66
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "yourPostCell", for:indexPath) as! yourPostCell
        cell.titleText?.text = postData[indexPath.section].title
        cell.descriptionText?.text = postData[indexPath.section].description
        cell.priceText?.text = postData[indexPath.section].price
        cell.timeElapsed?.text = postData[indexPath.section].timeStamp
        //cell.cellPhoto?.image = postData[indexPath.section].imageArray[0]
        cell.layer.cornerRadius = 4
        cell.layer.borderColor = UIColor.black.cgColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "yourPostExpandedView", sender: nil)
    }
    
    var tempTitle: String!
    var tempDescription: String!
    var tempPrice: String!
    
    var imagesArray: [UIImage] = []
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? postEnlargedViewController,
            let indexPath = yourPostTable.indexPathForSelectedRow {
            destination.tempTitle = postData[indexPath.section].title
            destination.tempDescription = postData[indexPath.section].description
            destination.tempPrice = postData[indexPath.section].price
            destination.imagesArray = picsArray
        }
    }
}
