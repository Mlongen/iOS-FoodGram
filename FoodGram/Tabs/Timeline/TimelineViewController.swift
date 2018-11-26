//
//  TimelineViewController.swift
//  FoodGram
//
//  Created by Marcelo Longen on 2018-10-17.
//  Copyright © 2018 Marcelo Longen. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SDWebImage

private let reuseIdentifier = "PostCell"

class TimelineViewController: UICollectionViewController {

    var database: MyDatabase!
    var ref: DatabaseReference!
    var userID: String!
    override func viewDidLoad() {
        super.viewDidLoad()

        let width = (view.frame.size.width - 20)
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
        print(Auth.auth().currentUser!.uid)
        database = MyDatabase.shared
        database.readFriendPosts()
    }



    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return database.friendPosts.count
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PostCell
        
        
        //configure cell
        
        let index = indexPath.item
        cell.descriptionLabel.text = database.friendPosts[index].postDescription
        let imageUrl = database.friendPosts[index].image
        let url = URL(string: imageUrl)
        cell.foodPic.sd_setImage(with: url, completed: { [weak self] (image, error, cacheType, imageURL) in
            cell.foodPic.image = image
        })
        cell.rating.text = "Rating: " + String(database.friendPosts[index].rating) + "/10"
        
        return cell
    }
}
