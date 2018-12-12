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
import Presentr

private let reuseIdentifier = "PostCell"

class LikeButton: UIButton {
    var userID: String!
}

class TimelineViewController: UICollectionViewController {
    @IBOutlet var TimelineViewController: UICollectionView!
    var database: MyDatabase!

    static var isNotification: Bool!
    
    lazy var addPostController: AddPostViewController = {
        let addPostController = self.storyboard?.instantiateViewController(withIdentifier: "AddPostViewController")
        return addPostController as! AddPostViewController
    }()
    
    lazy var notificationController: NotificationViewController = {
        let notificationController = self.storyboard?.instantiateViewController(withIdentifier: "NavController")
        return notificationController as! NotificationViewController
    }()
    @IBOutlet weak var notificationsButton: UIBarButtonItem!
    
    var ref: DatabaseReference!
    var userID: String!
    var radius: Int = 20
    override func viewDidLoad() {
        super.viewDidLoad()
//        let width = (view.frame.size.width - 20)
//        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
//        layout.itemSize = CGSize(width: width, height: width + 30)
       
        database = MyDatabase.shared
        MyDatabase.shared.timeLineCollectionView = collectionView
        let refresh = UIRefreshControl()
        refresh.addTarget(TimelineViewController, action: #selector(self.refresh), for: .valueChanged)
        collectionView.refreshControl = refresh
        
        
    }


    @objc func refresh(){
        MyDatabase.shared.bridgeReload()
    }
    

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of items
        return database.friendPosts.count
    }
    
    @objc func likeButtonTapped(_ sender: Any) -> Void {
        var btn = sender as! LikeButton
        
        var userID = btn.userID
        
        MyDatabase.shared.checkIfUserAlreadyLiked(destinationID: userID!) { (hasLiked) in
            if hasLiked {
                //return negative
            } else {
                MyDatabase.shared.addLikeToUser(destinationID: userID!)
            }
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PostCell
                let index = indexPath.item
        
        let userID = database.friendPosts[index].userId
        //configure cell
        

        cell.userName.text = database.getUserById(userID:userID)
        cell.amount.text = database.friendPosts[index].price
        cell.restaurantName.text = database.friendPosts[index].location
        cell.descriptionLabel.text = database.friendPosts[index].postDescription
        cell.likeButton.userID = userID
        cell.likeButton.addTarget(self, action: #selector(self.likeButtonTapped(_:)), for: .touchUpInside)
        
        let imageUrl = database.friendPosts[index].image
        let url = URL(string: imageUrl)
        cell.foodPic.sd_setImage(with: url, completed: { (image, error, cacheType, imageURL) in
            cell.foodPic.image = image
        })
        MyDatabase.shared.getProfilePicByID(userID: userID) { (urlStr) in
            let url = URL(string: urlStr)
            cell.profilePic.sd_setImage(with: url, completed: { (image, error, cacheType, imageURL) in
                cell.profilePic.image = image
            })
        }
        
        cell.layer.cornerRadius = 20.0
        cell.layer.masksToBounds = true
        cell.layer.backgroundColor = UIColor.white.cgColor
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 3.0)//CGSizeMake(0, 2.0);
        cell.layer.shadowRadius = 10.0
        cell.layer.shadowOpacity = 0.7
                cell.layer.opacity = 0.85
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
        let width = (view.frame.size.width - 20)
        cell.profilePic.setRounded()
        cell.rating.text = "Rating: " + String(database.friendPosts[index].rating) + "/10"
        
        return cell
    }

    
}

//bar buttons
extension TimelineViewController{
    
    @IBAction func notificationBTNTapped(_ sender: Any) {
        let presenter: Presentr = {
            
            let width = ModalSize.fluid(percentage: 0.8)
            let height = ModalSize.fluid(percentage: 0.5)
            let center = ModalCenterPosition.center
            let customType = PresentationType.custom(width: width, height: height, center: center)
            
            let customPresenter = Presentr(presentationType: customType)
            customPresenter.transitionType = .coverVerticalFromTop
            customPresenter.dismissTransitionType = .crossDissolve
            customPresenter.roundCorners = true
            customPresenter.cornerRadius = CGFloat(radius)
            customPresenter.backgroundOpacity = 0.5
            customPresenter.dismissOnSwipe = true
            customPresenter.dismissOnSwipeDirection = .top
            return customPresenter
        }()
        customPresentViewController(presenter, viewController:  notificationController, animated: true, completion: nil)
    }
    
    @IBAction func addBtnTapped(_ sender: Any) {
        let presenter: Presentr = {
            
            let width = ModalSize.fluid(percentage: 0.8)
            let height = ModalSize.fluid(percentage: 0.85)
            let center = ModalCenterPosition.center
            let customType = PresentationType.custom(width: width, height: height, center: center)
            let customPresenter = Presentr(presentationType: customType)
            customPresenter.transitionType = .coverVerticalFromTop
            customPresenter.dismissTransitionType = .crossDissolve
            customPresenter.roundCorners = true
            customPresenter.cornerRadius = CGFloat(radius)
            customPresenter.backgroundOpacity = 0.5
            customPresenter.dismissOnSwipe = true
            customPresenter.dismissOnSwipeDirection = .top
            return customPresenter
        }()
        customPresentViewController(presenter, viewController: addPostController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
