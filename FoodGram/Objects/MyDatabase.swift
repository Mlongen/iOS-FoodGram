//
//  Database.swift
//  FoodGram
//
//  Created by Marcelo Longen on 2018-11-06.
//  Copyright © 2018 Marcelo Longen. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import Firebase

class MyDatabase: NSObject {
    static let shared = MyDatabase()
    var hasLoadedFriends: NSInteger
    var hasLoadedPosts: NSInteger
    var hasLoadedAllUsers: NSInteger
    
    var ref: DatabaseReference!
    var thisUserDBContext: String
    var selfPosts: [Post]
    var friendPosts: [Post]
    var friends: [String]
    var allUsers: [String: String]
    var timelinePostIds: [String]
    var timeLineCollectionView: UICollectionView?
    
    var notifications: [Notification]
    
    init(thisUserDBContext: String = "0") {
        
        self.thisUserDBContext = thisUserDBContext
        self.selfPosts = [Post]()
        self.friends = [String]()
        self.friendPosts = [Post]()
        self.notifications = [Notification]()
        self.timelinePostIds = [String]()
        self.hasLoadedPosts = 0
        self.hasLoadedFriends = 0
        self.hasLoadedAllUsers = 0
        allUsers = [String: String]()
        

    }
    
    func readFriends()
    {
        self.ref = Database.database().reference().child("users").child(self.thisUserDBContext).child("friends")
        self.ref.observe(DataEventType.value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    if let value = snap.value as? Dictionary<String, AnyObject> {
                        let user = value["userId"] as? String ?? ""
                        print(user)
                        MyDatabase.shared.friends.append(user)
                    }
                    
                }
            }
            self.hasLoadedFriends = self.hasLoadedFriends + 1
        })
        
    }
    func filterDuplicates(post: Post) {
        
        if !self.timelinePostIds.contains(post.postId) {
            MyDatabase.shared.friendPosts.append(post)
            self.timelinePostIds.append(post.postId)
        }
        
    }
    
    func readFriendsPosts() {
        for friend in friends {
            self.ref = Database.database().reference().child("users").child(friend).child("posts")
            self.ref.observe(DataEventType.value, with: { (snapshot) in
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                    for snap in snapshots {
                        if let value = snap.value as? Dictionary<String, AnyObject> {
                            let postID = value["postId"] as? String ?? ""
                            let userID = value["userID"] as? String ?? ""
                            let image = value["image"] as? String ?? ""
                            let postDescription = value["postDescription"] as? String ?? ""
                            let creationDate = value["creationDate"] as? String ?? ""
                            let price = value["price"] as? String ?? ""
                            let location = value["location"] as? String ?? ""
                            let rating = value["rating"] as? NSInteger ?? 0
                            
                            let newPost = Post(postId: postID, userId: userID, image: image, postDescription: postDescription, creationDate: creationDate, price: price, location: location, rating: rating)
                            
                            self.filterDuplicates(post: newPost)
                        }
                        
                    }
                }
                self.friendPosts = self.friendPosts.sorted(by: {
                    $0.creationDate.compare($1.creationDate) == .orderedDescending
                })
                self.hasLoadedPosts = self.hasLoadedPosts + 1
                
                
            })

//            MyDatabase.shared.timeLineCollectionView!.reloadData()
        }
    }
    
    func reloadFriendsPosts() {
        self.friendPosts.removeAll()
        self.timelinePostIds.removeAll()
        for friend in friends {
            self.ref = Database.database().reference().child("users").child(friend).child("posts")
            self.ref.observe(DataEventType.value, with: { (snapshot) in
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                    for snap in snapshots {
                        if let value = snap.value as? Dictionary<String, AnyObject> {
                            let postID = value["postId"] as? String ?? ""
                            let userID = value["userID"] as? String ?? ""
                            let image = value["image"] as? String ?? ""
                            let postDescription = value["postDescription"] as? String ?? ""
                            let creationDate = value["creationDate"] as? String ?? ""
                            let price = value["price"] as? String ?? ""
                            let location = value["location"] as? String ?? ""
                            let rating = value["rating"] as? NSInteger ?? 0
                            
                            let newPost = Post(postId: postID, userId: userID, image: image, postDescription: postDescription, creationDate: creationDate, price: price, location: location, rating: rating)
                            
                            self.filterDuplicates(post: newPost)
                        }
                    }
                }
                self.friendPosts = self.friendPosts.sorted(by: {
                    $0.creationDate.compare($1.creationDate) == .orderedDescending
                })
                MyDatabase.shared.timeLineCollectionView!.reloadData()
                MyDatabase.shared.timeLineCollectionView!.refreshControl?.endRefreshing()
            })

        }
        
    }
    
    func readNotifications()
    {
        self.ref = Database.database().reference().child("users").child(self.thisUserDBContext).child("notifications")
        self.ref.observe(DataEventType.value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    if let value = snap.value as? Dictionary<String, AnyObject> {
                        let notificationID = value["notificationID"] as? String
                        let content = value["content"] as? String
                        let createdByID = value["createdByID"] as? String
                        let createdByUser = value["createdByUser"] as? String
                        let status = value["status"] as? String
                        let type = value["type"] as? String
                        
                        let notification = Notification(notificationID: notificationID!, createdByUser: createdByUser!, createdByID: createdByID!, content: content!, type: type!, status: status!)
                        
                        MyDatabase.shared.notifications.append(notification)
                    }
                }
            }
        })
    }
    func readAllUsers()
    {
        self.ref = Database.database().reference().child("users")
        self.ref.observe(DataEventType.value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    if let value = snap.value as? Dictionary<String, AnyObject> {
                        let userID = value["userID"] as? String ?? ""
                        let thisUser = value["userName"] as? String ?? ""
                        self.allUsers[thisUser] = userID
                    }
                }
            }
            MyDatabase.shared.hasLoadedAllUsers = MyDatabase.shared.hasLoadedAllUsers + 1
        })
    }
    @objc func bridgeReload() {
        MyDatabase.shared.reloadFriendsPosts()
    }
    
    func readUserPostsById(userID: String) -> [Post]{
        var result = [Post]()
        
        let DBref = Database.database().reference().child("users").child(userID).child("posts")
        DBref.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
    
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    if let value = snap.value as? Dictionary<String, AnyObject> {
                        let postID = value["postID"] as? String ?? ""
                        let userID = self.thisUserDBContext
                        let image = value["image"] as? String ?? ""
                        let creationDate = value["creationDate"] as? String ?? ""
                        let postDescription = value["postDescription"] as? String ?? ""
                        let price = value["price"] as? String ?? ""
                        let location = value["location"] as? String ?? ""
                        let rating = value["rating"] as? NSInteger ?? 0
                        
                        let newPost = Post(postId: postID, userId: userID, image: image, postDescription: postDescription, creationDate: creationDate, price: price, location: location, rating: rating)
                        
                        result.append(newPost)
                        
                    }
                }
            }
        })
        return result
    }
    
    func addUserToDB(_ user: Firebase.User, username: String) {
        self.ref = Database.database().reference().child("users").child(user.uid)
        self.ref.child("userID").setValue(user.uid)
        self.ref.child("userName").setValue(username)
        let creationDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        let formattedDate = formatter.string(from: creationDate)
        self.ref.child("dateOfCreation").setValue(formattedDate)
        self.ref.child("email").setValue(user.email)
        self.ref.child("profileImg").setValue("image")
        self.ref.child("friends").setValue([Friend]())
        self.ref.child("notifications").setValue([Notification]())
    }
    
    func changeProfilePic(userID: String, picture: UIImage) {

        let imagePath = Storage.storage().reference().child(userID + "_pic")
        if let imageData = picture.pngData(){
            imagePath.putData(imageData, metadata: nil) { (metadata, error) in
                if(error != nil){
                    print(error!)
                    return
                }
                // Fetch the download URL
                imagePath.downloadURL { (url, error) in
                    if let error = error {
                        print(error)
                        return
                    } else {
                        // Get the download URL
                        let urlStr:String = (url?.absoluteString ?? "")
                        let DBref = Database.database().reference().child("users").child(userID)
                                DBref.child("profileImg").setValue(urlStr)
                    }
                }
            }
        }
    }
    func getProfilePicByID(userID: String,  completion: @escaping (String) -> ()){
        let DBref = Database.database().reference().child("users").child(userID).child("profileImg")
        DBref.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            if let profilePic = snapshot.value as? String {
                completion(profilePic)
            } else {
                completion("")
            }
            
        })
    }
    
    func addUserAsFriend(userName: String) {
        let senderUserId = self.getUserIDByName(userID: userName)
        let reference = Database.database().reference().child("users").child(self.thisUserDBContext).child("friends").child(senderUserId )
        reference.child("userName").setValue(userName)
        reference.child("userId").setValue(senderUserId)
        
        let reference2 = Database.database().reference().child("users").child(senderUserId).child("friends").child(self.thisUserDBContext)
        reference2.child("userName").setValue(self.getUserById(userID: self.thisUserDBContext))
        reference2.child("userId").setValue(self.thisUserDBContext)
        
        
    }
    
    func getUserPostsAndAwaitByName(userName: String) ->[Post] {
        
        let userId = self.getUserIDByName(userID: userName)
        return self.readUserPostsById(userID: userId)
    }

    func getUserById(userID: String) -> String{

        return self.allUsers.someKey(forValue: userID)!
        }
    
    func getUserIDByName(userID: String) -> String{
        return self.allUsers[userID]!
    }
    }



