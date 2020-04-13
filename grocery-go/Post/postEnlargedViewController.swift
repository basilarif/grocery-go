//
//  postEnlargedViewController.swift
//  grocery-go
//
//  Created by Basil Arif on 2020-04-11.
//  Copyright © 2020 Basil Arif. All rights reserved.
//

import Foundation
import UIKit


class enlargedImageArrayCell: UICollectionViewCell {
    
    @IBOutlet weak var image: UIImageView!
}


class postEnlargedViewController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    var tempTitle: String!
    var tempDescription: String!
    var tempPrice: String!
    
    var imagesArray: [UIImage] = []
    
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var postTitle: UILabel!
    @IBOutlet weak var postDescription: UITextView!
    @IBOutlet weak var postPrice: UILabel!
    @IBOutlet weak var chatButton: UIButton!
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return imagesArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "enlargeImageCell", for: indexPath as IndexPath) as! enlargedImageArrayCell
        cell.image.image = imagesArray[indexPath.item] //image
        cell.backgroundColor = UIColor.clear // make cell more visible in our example project
        cell.image.setNeedsDisplay()
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let imageView = UIImageView(image:imagesArray[indexPath.row])
        imageView.frame = self.view.frame
        imageView.backgroundColor = .black
        imageView.contentMode = .scaleAspectFit
        imageView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissFullscreenImage))
        imageView.addGestureRecognizer(tap)
        
        self.view.addSubview(imageView)
    }
    
    @objc func dismissFullscreenImage(_ sender: UITapGestureRecognizer) {
        sender.view?.removeFromSuperview()
    }
    
    override func viewDidLoad() {
        postTitle.text = tempTitle
        postDescription.text = tempDescription
        postPrice.text = tempPrice
        collectionView.delegate = self
        containerView.layer.cornerRadius = 20
        chatButton.layer.cornerRadius = 20
        self.collectionView.reloadData()
    }
    
    
}
