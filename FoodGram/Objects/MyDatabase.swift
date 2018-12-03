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
import AwaitKit

class MyDatabase: NSObject {
    static let shared = MyDatabase()
    var hasLoaded: NSInteger
    var ref: DatabaseReference!
    var thisUserDBContext: String
    var selfPosts: [Post]
    var friendPosts: [Post]
    var friends: [Friend]
    var allUsers: [String: String]

    
    var notifications: [Notification]
    
    init(thisUserDBContext: String = "0") {
        
        self.thisUserDBContext = thisUserDBContext
        self.selfPosts = [Post]()
        self.friends = [Friend]()
        self.friendPosts = [Post]()
        self.notifications = [Notification]()
        self.hasLoaded = 0
        allUsers = [String: String]()
        

    }
    
    
    
    
    func addFriendPosts()
    {
    }
    
//    func readFriends()
//    {
////        self.ref = Database.database().reference().child("users").child(self.thisUserDBContext)
////
////        ef.observe(DataEventType.value, with: { (snapshot) in
////
////            let value = snapshot.value as? NSDictionary
////            let postID = value?["postID"] as? String ?? ""
////            let userID = self.thisUserDBContext
////            let image = #imageLiteral(resourceName: "food")
////            let postDescription = value?["post description"] as? String ?? ""
////            let creationDate = Date()
////            let price = value?["price"] as? NSInteger ?? 0
////            let location = value?["location"] as? String ?? ""
////            let rating = value?["rating"] as? NSInteger ?? 0
////
////            let newPost = Post(postId: postID, userId: userID, image: "image", postDescription: postDescription, creationDate: Date(), price: price, location: location, rating: rating)
////
////            self.friendPosts.append(newPost)
////
//        })
//
//    }
    
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
        })
    }
    func readFriendPosts()
    {
        self.ref = Database.database().reference().child("users").child(self.thisUserDBContext).child("posts")
        self.ref.observe(DataEventType.value, with: { (snapshot) in
    
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    if let value = snap.value as? Dictionary<String, AnyObject> {
                        let postID = value["postID"] as? String ?? ""
                        let userID = self.thisUserDBContext
                        let image = value["image"] as? String ?? ""
                        let postDescription = value["post description"] as? String ?? ""
                        let creationDate = Date()
                        let price = value["price"] as? NSInteger ?? 0
                        let location = value["location"] as? String ?? ""
                        let rating = value["rating"] as? NSInteger ?? 0
                        
                        
                        let newPost = Post(postId: postID, userId: userID, image: image, postDescription: postDescription, creationDate: Date(), price: price, location: location, rating: rating)
                        
                        self.friendPosts.append(newPost)
                    }
                }
            }
            self.hasLoaded += 1
        })
        
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
    

}
