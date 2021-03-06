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
import Pastel

private let reuseIdentifier = "PostCell"

class LikeButton: UIButton {
    var userID: String!
    var postID: String!
    var arrayRef: [Post]!
    var index: Int!
}

class TimelineViewController: UICollectionViewController {
    @IBOutlet var TimelineViewController: UICollectionView!
    var database: MyDatabase!

    @IBOutlet weak var pastelView: PastelView!
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
        pastelView.startPastelPoint = .topRight
        pastelView.endPastelPoint = .bottomLeft
        
        // Custom Duration
        pastelView.animationDuration = 5.0
        
        // Custom Color
        pastelView.setColors([#colorLiteral(red: 0.1058823529, green: 0.8078431373, blue: 0.8745098039, alpha: 1), #colorLiteral(red: 0.07936513195, green: 0.303920712, blue: 0.8549019694, alpha: 1)])
        
        pastelView.startAnimation()
       
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
        let btn = sender as! LikeButton
        MyDatabase.shared.checkIfUserAlreadyLiked(userDestinationId: btn.userID, postDestinationID: btn.postID) { (hasLiked) in
            if hasLiked {
                MyDatabase.shared.removeLikeFromUser(userDestinationId: btn.userID, postDestinationId: btn.postID)
            } else {
                MyDatabase.shared.addLikeToUser(userDestinationId: btn.userID, postDestinationId: btn.postID)
            }
        }
        UIView.animate(withDuration: 0.2) {
            btn.frame.size.width += 5
            btn.frame.size.height += 5
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.2) {
            UIView.animate(withDuration: 0.2) {
                btn.frame.size.width -= 5
                btn.frame.size.height -= 5
            }
        }

        self.collectionView.reloadData()
    }
    
    

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let  cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! PostCell
                let index = indexPath.item
        
        
        let userID = database.friendPosts[index].userId
        //configure cell
        MyDatabase.shared.getNumberOfLikes(userDestinationId: userID, postDestinationID: database.friendPosts[index].postId)  { (total) in
            cell.numberOfLikes.text = String(total)
        }

        cell.userName.text = database.getUserById(userID:userID)
        cell.amount.text = database.friendPosts[index].price
        cell.restaurantName.text = database.friendPosts[index].location
        cell.descriptionLabel.text = database.friendPosts[index].postDescription
        cell.likeButton.userID = userID
        cell.likeButton.arrayRef = MyDatabase.shared.friendPosts
        cell.likeButton.index = index
        cell.likeButton.postID = database.friendPosts[index].postId
        cell.likeButton.addTarget(self, action: #selector(self.likeButtonTapped(_:)), for: .touchUpInside)
        
        let imageUrl = database.friendPosts[index].image
        let url = URL(string: imageUrl)
        cell.foodPic.sd_setImage(with: url, completed: { (image, error, cacheType, imageURL) in
            cell.foodPic.image = image
        })
        MyDatabase.shared.getProfilePicByID(userID: userID) { (urlStr) in
            if (urlStr == "image" || urlStr == "") {
                var newUrlStr = "https://firebasestorage.googleapis.com/v0/b/iosfoodgram.appspot.com/o/72EF94D0-10BA-4D0E-BBC3-90477B2600BE?alt=media&token=d44c9931-3096-44c2-9d10-37877990059b"
                let url = URL(string: newUrlStr)
                cell.profilePic.sd_setImage(with: url, completed: { (image, error, cacheType, imageURL) in
                    cell.profilePic.image = image
                })
            } else {
                let url = URL(string: urlStr)
                cell.profilePic.sd_setImage(with: url, completed: { (image, error, cacheType, imageURL) in
                    cell.profilePic.image = image
                })
            }
        }
        
        
        cell.layer.cornerRadius = 20.0
        cell.layer.masksToBounds = true
        cell.layer.shadowColor = UIColor.white.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1.8)//CGSizeMake(0, 2.0);
        cell.layer.shadowRadius = 10.0
        cell.layer.shadowOpacity = 0.50
                cell.layer.opacity = 0.95
        cell.layer.masksToBounds = false
//        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
        cell.profilePic.setRounded()
        cell.rating.text = "Rating: " + String(database.friendPosts[index].rating) + "/10"
        
        return cell
    }

    
}



//bar buttons
extension TimelineViewController{
    
    @IBAction func notificationBTNTapped(_ sender: Any) {
        let presenter: Presentr = {
            
            let width = ModalSize.fluid(percentage: 0.85)
            let height = ModalSize.fluid(percentage: 0.5)
            let center = ModalCenterPosition.center
            let customType = PresentationType.custom(width: width, height: height, center: center)
            
            let customPresenter = Presentr(presentationType: customType)
            customPresenter.transitionType = .coverVerticalFromTop
            customPresenter.dismissTransitionType = .crossDissolve
            customPresenter.cornerRadius = 20
            customPresenter.roundCorners = true
            customPresenter.dropShadow = PresentrShadow(shadowColor: UIColor.white, shadowOpacity: 0.50, shadowOffset: CGSize(width: 0, height: 1.8), shadowRadius: 10)
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
