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


class homePagePostCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
}

class homeViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var newImage: UIImageView!
    
    var indexPoint:Int!
    var homePagePostData = [yourPost]()
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return homePagePostData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        print("index path item #:")
        print(indexPath.item)
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "homePagePostCell", for: indexPath as IndexPath) as! homePagePostCell
        cell.layer.cornerRadius = 20
        //cell.layer.masksToBounds = true
//        var realImage :UIImage
//        if let imageIndex = homePagePostData[indexPath.item].imageArray[0] as? UIImage {
//            realImage = imageIndex
//            cell.image.image = realImage
//        } else {
//            print("image does not exist")
//        }
        cell.titleLabel.text = homePagePostData[indexPath.item].title
        cell.priceLabel.text = homePagePostData[indexPath.item].price
        cell.timeLabel.text = ""
        cell.backgroundColor = UIColor.green // make cell more visible in our example project
        cell.image.setNeedsDisplay()
        //collectionView.reloadData()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        indexPoint = indexPath.item
        performSegue(withIdentifier: "homePagePostExpandedView", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let destination = segue.destination as? postEnlargedViewController {
            destination.tempTitle = homePagePostData[indexPoint].title
            destination.tempDescription = homePagePostData[indexPoint].description
            destination.tempPrice = homePagePostData[indexPoint].price
            destination.imagesArray = homePagePostData[indexPoint].imageArray
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.isNavigationBarHidden = false
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor.white]
        self.navigationController?.navigationBar.titleTextAttributes = textAttributes
        self.navigationController?.navigationBar.topItem?.title = "Home"
        collectionView.delegate = self
        homePagePostData = [
            yourPost(title: "", description: "", price: "", timeStamp: "", imageArray: [])
        ]
        
        //Create a reference to the file you want to download
        let db = Firestore.firestore()
        db.collection("posts").getDocuments() { (querySnapshot, err) in
            if let err = err {
                print("Error getting documents: \(err)")
            } else {
                for document in querySnapshot!.documents{
                    print(document.documentID)
                    let data = document.data()
                    let title = data["title"] as! String
                    let description = data["description"] as! String
                    let price = data["price"] as! String
                    var picsArray:[UIImage] = [UIImage()]
                    var pos = 0
                    //var x = true
                    while pos < 1 {
                        print(pos)
                        let docID = document.documentID
                        guard let uid = Auth.auth().currentUser?.uid else { return }
                        let fireStorePath = "gs://grocery-go-4268b.appspot.com"
                        let storageRef = Storage.storage().reference().child(fireStorePath + "/posts/\(uid)/\(docID)/\(pos+1)")
                        storageRef.getData(maxSize: 5*1024*1024){ (data, error) in
                            if let error = error {
                                print("Error \(error)")
                            }
                            if let data = data {
                                //self.newImage.image = UIImage(data: data)
                                print("Success appending")
                                picsArray.append(UIImage(data: data)!)
                            }
                        }
                        pos += 1
                    }
                    //let timeStamp = data["timeStamp"] as! Timestamp
                    //let myTimeInterval = TimeInterval(timeStamp)
                    //let time = NSDate(timeIntervalSince1970: TimeInterval(timeStamp))
                    //let formatter = DateFormatter()
                    // initially set the format based on your datepicker date / server String
                    //formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
                    
                    //let myString = formatter.string(from: time as Date) // string purpose I add here
                    // convert your string to date
                    //let yourDate = formatter.date(from: myString)
                    //let myStringafd = formatter.string(from: yourDate!)
                    
                    //let imageArray = data["imageArray"] as! NSArray
                    self.homePagePostData.append(yourPost(title: title, description: description, price: price, timeStamp: "2d", imageArray: picsArray))
                }
                print(self.homePagePostData)
                self.homePagePostData.removeFirst()
                //self.collectionView.reloadData()
            }
        }
    }
//    override func viewDidAppear(_ animated: Bool) {
//        collectionView.reloadData()
//    }
}

