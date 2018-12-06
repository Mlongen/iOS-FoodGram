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

class ProfileViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    private let reuseIdentifier = "ProfilePostCell"
    var thisUser: String = "test"
    
    @IBOutlet weak var username: UILabel!
    @IBOutlet weak var userNameTitle: UINavigationItem!
    
    @IBOutlet weak var changePicButton: UIButton!
    
    @IBAction func changePic(_ sender: Any) {
        self.presentImagePicker()
    }
    @IBOutlet weak var addFriendBtn: UIButton!
    @IBOutlet weak var profilePic: UIImageView!
    
    @IBAction func addFriend(_ sender: Any) {

        let userID = MyDatabase.shared.allUsers[thisUser] as! String

        let mySelfUsername = MyDatabase.shared.allUsers.someKey(forValue: MyDatabase.shared.thisUserDBContext) as! String

        let notID = UUID().uuidString
        let notificationsRef = Database.database().reference().child("users").child(userID).child("notifications").child(notID)
        notificationsRef.child("notificationID").setValue(notID)
        notificationsRef.child("createdByUser").setValue(mySelfUsername)
        notificationsRef.child("createdByID").setValue(MyDatabase.shared.thisUserDBContext)
        notificationsRef.child("content").setValue("\(mySelfUsername) has added you as a friend.")
        notificationsRef.child("type").setValue("FriendRequest")
        notificationsRef.child("status").setValue("Pending")
        
        let banner = NotificationBanner(title: "Friendship request sent", subtitle: nil, style: .success)
        banner.show()
        
    }
    @IBOutlet weak var profilePostsCollection: UICollectionView!
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath)

        return cell
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        username.text = thisUser
        self.title = thisUser
        
        profilePic.layer.cornerRadius =  profilePic.frame.size.width / 2
        profilePic.clipsToBounds = true
        // Do any additional setup after loading the view.
        if (username.text == MyDatabase.shared.allUsers.someKey(forValue: MyDatabase.shared.thisUserDBContext) as? String){
            changePicButton.isHidden = false
            addFriendBtn.isHidden = true
        
        } else {
            changePicButton.isHidden = true
            addFriendBtn.isHidden = false
        }
        
    }
    
    func presentImagePicker(){
        var config = YPImagePickerConfiguration()
        config.library.mediaType = .photo
        config.library.onlySquare  = false
        config.onlySquareImagesFromCamera = true
        config.targetImageSize = .original
        config.usesFrontCamera = true
        config.showsFilters = true
        
        config.shouldSaveNewPicturesToAlbum = true
        config.albumName = "MyGreatAppName"
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
        var picker = YPImagePicker(configuration: config)
        present(picker, animated: true, completion: nil)
        picker.didFinishPicking { [unowned self] items, _ in
            if let photo = items.singlePhoto {
                MyDatabase.shared.changeProfilePic(userID: MyDatabase.shared.getUserIDByName(userID: self.thisUser), picture: photo.image)
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
