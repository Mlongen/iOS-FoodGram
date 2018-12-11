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

class ProfileViewController: UIViewController, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "profilePostCell", for: indexPath) as! ProfilePostCell
        
        let index = indexPath.item
        cell.layer.cornerRadius = 20.0
        cell.layer.masksToBounds = true
        cell.layer.backgroundColor = UIColor.white.cgColor
        cell.layer.shadowColor = UIColor.gray.cgColor
        cell.layer.shadowOffset = CGSize(width: 0, height: 3.0)//CGSizeMake(0, 2.0);
        cell.layer.shadowRadius = 10.0
        cell.layer.shadowOpacity = 0.7
        cell.layer.masksToBounds = false
        cell.layer.shadowPath = UIBezierPath(roundedRect:cell.bounds, cornerRadius:cell.contentView.layer.cornerRadius).cgPath
        
        return cell
    }
    
    
    var thisUser: String = ""
    
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userNameTitle: UINavigationItem!
    
    @IBOutlet weak var changePicButton: UIButton!
    
    @IBAction func changePic(_ sender: Any) {
        self.presentImagePicker()
    }
    @IBOutlet weak var addFriendBtn: UIButton!
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBAction func addFriend(_ sender: Any) {

        let userID = MyDatabase.shared.allUsers[thisUser]

        let mySelfUsername = MyDatabase.shared.getUserById(userID: userID!)

        let creationDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        let formattedDate = formatter.string(from: creationDate)
        let notID = UUID().uuidString
        let notificationsRef = Database.database().reference().child("users").child(userID!).child("notifications").child(notID)
        notificationsRef.child("notificationID").setValue(notID)
        notificationsRef.child("createdByUser").setValue(mySelfUsername)
        notificationsRef.child("createdByID").setValue(MyDatabase.shared.thisUserDBContext)
        notificationsRef.child("content").setValue("\(mySelfUsername) has added you as a friend.")
        notificationsRef.child("type").setValue("FriendRequest")
        notificationsRef.child("creationDate").setValue(formattedDate)
        notificationsRef.child("status").setValue("Pending")
        
        let banner = NotificationBanner(title: "Friendship request sent", subtitle: nil, style: .success)
        banner.show()
        
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()

        username?.text = thisUser
        self.title = thisUser
        profilePic?.setRounded()
        // Do any additional setup after loading the view.
        if (username?.text == MyDatabase.shared.allUsers.someKey(forValue: MyDatabase.shared.thisUserDBContext)){
            changePicButton.isHidden = false
            addFriendBtn.isHidden = true
        
        } else {
//            changePicButton?.isHidden = true
//            addFriendBtn.isHidden = false
        }

        
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
                MyDatabase.shared.changeProfilePic(userID: MyDatabase.shared.getUserIDByName(userName: self.thisUser), picture: photo.image)
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
