//
//  FriendsCollectionController.swift
//  FoodGram
//
//  Created by Marcelo Longen on 2018-10-17.
//  Copyright © 2018 Marcelo Longen. All rights reserved.
//

import UIKit
import Presentr
import SDWebImage

private let reuseIdentifier = "FriendCell"

class FriendsCollectionController: UICollectionViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = (view.frame.size.width - 20)
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width / 4)
        
        

    }
    lazy var searchController: SearchViewController = {
        let searchController = self.storyboard?.instantiateViewController(withIdentifier: "SearchController")
        return searchController as! SearchViewController
    }()
    

    @IBAction func openSearchController(_ sender: Any) {
        let presenter: Presentr = {
            
            let width = ModalSize.fluid(percentage: 0.95)
            let height = ModalSize.fluid(percentage: 0.3)
            let center = ModalCenterPosition.topCenter
            let customType = PresentationType.custom(width: width, height: height, center: center)
            
            let customPresenter = Presentr(presentationType: customType)
            customPresenter.transitionType = .coverVerticalFromTop
            customPresenter.dismissTransitionType = .crossDissolve
            customPresenter.roundCorners = true
            customPresenter.backgroundOpacity = 0.5
            customPresenter.dismissOnSwipe = true
            customPresenter.dismissOnSwipeDirection = .top
            customPresenter.accessibilityScroll(UIAccessibilityScrollDirection.down)
            return customPresenter
        }()
        customPresentViewController(presenter, viewController:  searchController, animated: true, completion: nil)
    }

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return MyDatabase.shared.allUsers.count
    }

    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FriendCell
    
        let index = indexPath.item
        cell.layer.cornerRadius = 10
        cell.layer.masksToBounds = true
        cell.layer.backgroundColor = UIColor.white.cgColor
        cell.layer.shadowColor = UIColor.white.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 2.0)//CGSizeMake(0, 2.0);
        cell.layer.shadowRadius = 1.0
        cell.layer.shadowOpacity = 0.2
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
        
        let usersArray = Array(MyDatabase.shared.allUsers)
        cell.userName.text = usersArray[index].key
        
        cell.profilePic.layer.cornerRadius =  cell.profilePic.frame.size.width / 2
        cell.profilePic.clipsToBounds = true
        
        
        MyDatabase.shared.getProfilePicByID(userID: MyDatabase.shared.getUserIDByName(userID: usersArray[index].key)) { (urlStr) in
            let url = URL(string: urlStr)
            cell.profilePic.sd_setImage(with: url, completed: { [weak self] (image, error, cacheType, imageURL) in
                cell.profilePic.image = image
            })
        }

        // Configure the cell
    
        return cell
    }

    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        let cell = collectionView.cellForItem(at: indexPath) as! FriendCell
        performSegue(withIdentifier: "detailFromFriendList", sender: cell)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {

        if (segue.identifier == "detailFromFriendList") {
            if let dest = segue.destination as? ProfileViewController, let cell = sender as? FriendCell {
                dest.thisUser = cell.userName.text!
}
}
}
}


