//
//  TimelineViewController.swift
//  FoodGram
//
//  Created by Marcelo Longen on 2018-10-17.
//  Copyright © 2018 Marcelo Longen. All rights reserved.
//

import UIKit
import Firebase

private let reuseIdentifier = "PostCell"

class TimelineViewController: UICollectionViewController {

    var database: MyDatabase!
    var userID: String!
    override func viewDidLoad() {
        super.viewDidLoad()

        let width = (view.frame.size.width - 20)
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
        print(Auth.auth().currentUser!.uid)
        database = MyDatabase.shared
        database.thisUserDBContext = userID
        database.addFriendPosts()
        database.addFriendPosts()
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
        cell.foodPic.image = database.friendPosts[index].image
        cell.rating.text = "Rating: " + String(database.friendPosts[index].rating) + "/10"
        
        return cell
    }
}
