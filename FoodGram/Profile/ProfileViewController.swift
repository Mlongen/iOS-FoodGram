//
//  ProfileViewController.swift
//  FoodGram
//
//  Created by Marcelo Longen on 2018-10-17.
//  Copyright © 2018 Marcelo Longen. All rights reserved.
//

import UIKit
import FirebaseDatabase
import NotificationBannerSwift
import YPImagePicker
import SDWebImage
import Pastel


class ProfileViewController: UIViewController, UICollectionViewDataSource{
    
    @IBOutlet weak var pastelView: PastelView!
    static var shared = ProfileViewController()
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return MyDatabase.shared.specificProfilePosts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profilePostCell", for: indexPath) as! ProfilePostCell
        
        let index = indexPath.item
        
        let imageUrl = MyDatabase.shared.specificProfilePosts[index].image
        let url = URL(string: imageUrl)
        cell.postPic.sd_setImage(with: url, completed: { (image, error, cacheType, imageURL) in
            cell.postPic.image = image
        })
        cell.priceLabel.text = MyDatabase.shared.specificProfilePosts[index].price
        cell.ratingLabel.text = "Rating: " + String(MyDatabase.shared.specificProfilePosts[index].rating) + "/10"
        cell.restaurantName.text = MyDatabase.shared.specificProfilePosts[index].location
        cell.layer.cornerRadius = 20.0
        cell.layer.masksToBounds = true
        cell.layer.backgroundColor = UIColor.white.cgColor
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 1.0)//CGSizeMake(0, 2.0);
        cell.layer.shadowRadius = 20.0
        cell.layer.shadowOpacity = 0.2
        cell.layer.opacity = 0.80
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
        
        return cell
    }
    
    
    @IBOutlet weak var profileView: UIView!
    
    var thisUserID: String = ""
    
    @IBOutlet weak var settingsBtn: UIBarButtonItem!
    
    @IBAction func settingsAction(_ sender: Any) {
        let alert = UIAlertController(title: "Hey", message: "test", preferredStyle: .alert)
        // or show alert with options
        alert.show(self, sender: self.settingsBtn)
    }
    
    @IBAction func logoutAction(_ sender: Any) {
    }
    
    
    @IBOutlet weak var publicationsView: UIView!
    
    @IBOutlet weak var logoutBtn: UIBarButtonItem!
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userNameTitle: UINavigationItem!
    
    @IBOutlet weak var changePicButton: UIButton!
    
    @IBAction func changePic(_ sender: Any) {
        self.presentImagePicker()
    }
    @IBOutlet weak var addFriendBtn: UIButton!
    @IBOutlet weak var profilePic: UIImageView!
    
    @objc func addFriend(_ sender: Any) {

        let userID = thisUserID
        let mySelfUsername = MyDatabase.shared.getUserById(userID: MyDatabase.shared.thisUserDBContext)
        let creationDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedDate = formatter.string(from: creationDate)
        let notID = UUID().uuidString
        
        MyDatabase.shared.checkIfNotificationHasBeenSent(createdById: MyDatabase.shared.thisUserDBContext, sentTo: userID, type: "FriendRequest") { (hasBeenSent) in
            if (hasBeenSent == "FriendAlready" || hasBeenSent == "RequestedAlready") {
                let banner = NotificationBanner(title: "You already added this person as a friend.", subtitle: nil, style: .success)
                banner.show()
            } else {
                let notificationsRef = Database.database().reference().child("users").child(userID).child("notifications").child(notID)
                notificationsRef.child("notificationID").setValue(notID)
                notificationsRef.child("createdByUser").setValue(mySelfUsername)
                notificationsRef.child("createdByID").setValue(MyDatabase.shared.thisUserDBContext)
                notificationsRef.child("content").setValue("\(mySelfUsername) has added you as a friend.")
                notificationsRef.child("type").setValue("FriendRequest")
                notificationsRef.child("creationDate").setValue(formattedDate)
                notificationsRef.child("status").setValue("Pending")
                print(creationDate)
                self.addFriendBtn.setTitle("Pending", for: .normal)
                self.addFriendBtn.isEnabled = false
            }
        }
        
    }
    


    fileprivate func setProfileViewRadiusAndShadows() {
        profileView.layer.cornerRadius = 20.0
        profileView.layer.masksToBounds = true
        profileView.layer.backgroundColor = UIColor.white.cgColor
        profileView.layer.shadowColor = UIColor.gray.cgColor
        profileView.layer.shadowOffset = CGSize(width: 0, height: 1.0)//CGSizeMake(0, 2.0);
        profileView.layer.shadowRadius = 20.0
        profileView.layer.shadowOpacity = 0.2
        profileView.layer.opacity = 0.85
        profileView.layer.masksToBounds = false
        profileView.layer.shadowPath = UIBezierPath(roundedRect:profileView.bounds, cornerRadius:profileView.layer.cornerRadius).cgPath
    }
    
    fileprivate func setPublicationViewRadiusAndShadows() {
        publicationsView.layer.cornerRadius = 10.0
        publicationsView.layer.masksToBounds = true
        publicationsView.layer.backgroundColor = UIColor.white.cgColor
        publicationsView.layer.shadowColor = UIColor.gray.cgColor
        publicationsView.layer.shadowOffset = CGSize(width: 0, height: 1.0)//CGSizeMake(0, 2.0);
        publicationsView.layer.shadowRadius = 20.0
        publicationsView.layer.shadowOpacity = 0.2
        publicationsView.layer.opacity = 0.90
        publicationsView.layer.masksToBounds = false
        publicationsView.layer.shadowPath = UIBezierPath(roundedRect:publicationsView.bounds, cornerRadius:publicationsView.layer.cornerRadius).cgPath
    }
    
    fileprivate func checkFriendShipStatus() {
        // Do any additional setup after loading the view.
        if (thisUserID == MyDatabase.shared.thisUserDBContext){
            changePicButton.isHidden = false
            addFriendBtn.isHidden = true
            self.navigationItem.rightBarButtonItem = self.settingsBtn
            self.navigationItem.leftBarButtonItem = self.logoutBtn
            
        } else {
            changePicButton?.isHidden = true
            addFriendBtn.isHidden = false
            MyDatabase.shared.checkIfNotificationHasBeenSent(createdById: MyDatabase.shared.thisUserDBContext, sentTo: thisUserID, type: "FriendRequest") { (hasBeenSent) in
                if (hasBeenSent == "FriendAlready") {
                    self.addFriendBtn.setTitle("Remove friend", for: .normal)
                    self.addFriendBtn.isEnabled = false
                } else if (hasBeenSent == "RequestedAlready"){
                    self.addFriendBtn.setTitle("Pending", for: .normal)
                    self.addFriendBtn.isEnabled = false
                }
                
                self.navigationItem.rightBarButtonItem = nil
                self.navigationItem.leftBarButtonItem = nil
            }
            
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        pastelView.startPastelPoint = .bottomLeft
        pastelView.endPastelPoint = .topRight
        
        // Custom Duration
        pastelView.animationDuration = 2.0
        
        // Custom Color
        pastelView.setColors([#colorLiteral(red: 0.1058823529, green: 0.8078431373, blue: 0.8745098039, alpha: 1), #colorLiteral(red: 0.07936513195, green: 0.303920712, blue: 0.8549019694, alpha: 1)])
        
        pastelView.startAnimation()

        MyDatabase.shared.specificProfileCollectionView = collectionView
        if thisUserID == "" {
            thisUserID = MyDatabase.shared.thisUserDBContext
        }
        
        setProfileViewRadiusAndShadows()
        
        setPublicationViewRadiusAndShadows()
        
        MyDatabase.shared.readUserPostsById(userID: thisUserID)
        username?.text = MyDatabase.shared.getUserById(userID: thisUserID)
        MyDatabase.shared.getProfilePicByID(userID: thisUserID
            , completion: { (imageUrl) in
                let url = URL(string: imageUrl)
                self.profilePic.sd_setImage(with: url, completed: { (image, error, cacheType, imageURL) in
                    self.profilePic.image = image
                })
        })
        profilePic?.setRounded()
        checkFriendShipStatus()
        self.addFriendBtn.addTarget(self, action: #selector(addFriend(_:)), for: .touchUpInside)
    }
    
    func presentImagePicker(){
        var config = YPImagePickerConfiguration()
        config.library.mediaType = .photo
        config.library.onlySquare  = true
        config.onlySquareImagesFromCamera = true
        config.targetImageSize = .cappedTo(size: 400.0)
        config.usesFrontCamera = true
        config.showsFilters = true
        
        config.shouldSaveNewPicturesToAlbum = true
        config.screens = [.library, .photo]
        config.startOnScreen = .library
        config.showsCrop = .rectangle(ratio: (4/3))
        config.wordings.libraryTitle = "Gallery"
        config.hidesStatusBar = false
        config.library.maxNumberOfItems = 1
        config.library.minNumberOfItems = 1
        config.library.numberOfItemsInRow = 3
        config.library.spacingBetweenItems = 2
        config.isScrollToChangeModesEnabled = false
        
        // Build a picker with your configuration
        let picker = YPImagePicker(configuration: config)
        present(picker, animated: true, completion: nil)
        picker.didFinishPicking { [unowned self] items, _ in
            if let photo = items.singlePhoto {
                MyDatabase.shared.changeProfilePic(userID: self.thisUserID, picture: photo.image)
                self.profilePic.image = photo.image
            }
            picker.dismiss(animated: true, completion: nil)
        }
    }
    
}

extension Dictionary where Value: Equatable {
    func someKey(forValue val: Value) -> Key? {
        return first(where: { $1 == val })?.key
    }
}

