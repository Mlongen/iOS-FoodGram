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
import AwaitKit

private let reuseIdentifier = "PostCell"

class TimelineViewController: UICollectionViewController {

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
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let width = (view.frame.size.width - 20)
        let layout = collectionView.collectionViewLayout as! UICollectionViewFlowLayout
        layout.itemSize = CGSize(width: width, height: width)
        print(Auth.auth().currentUser!.uid)
       
        database = MyDatabase.shared

        let refresh = UIRefreshControl()
        refresh.addTarget(self, action: #selector(self.refresh), for: .valueChanged)
        collectionView.refreshControl = refresh
    }


    @objc func refresh(){
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
            if (self.database.hasLoaded > 0)
            {
                print(MyDatabase.shared.friendPosts.count)
                self.collectionView.refreshControl?.endRefreshing()
            } else {

            }
        }
        
       
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
        cell.userName.text = database.getUserById(userID: database.friendPosts[index].userId)
        cell.amount.text = database.friendPosts[index].price
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
            customPresenter.backgroundOpacity = 0.5
            customPresenter.dismissOnSwipe = true
            customPresenter.dismissOnSwipeDirection = .top
            customPresenter.accessibilityScroll(UIAccessibilityScrollDirection.down)
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
            customPresenter.backgroundOpacity = 0.5
            customPresenter.dismissOnSwipe = true
            customPresenter.dismissOnSwipeDirection = .top
            return customPresenter
        }()
        customPresentViewController(presenter, viewController: addPostController, animated: true, completion: nil)
    }
    
}
