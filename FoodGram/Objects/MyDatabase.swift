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
    var ref: DatabaseReference!
    var thisUserDBContext: String
    var selfPosts: [Post]
    var friendPosts: [Post]
    var notifications: [Notification]
    
    init(thisUserDBContext: String = "0") {
        
        self.thisUserDBContext = thisUserDBContext
        self.selfPosts = [Post]()
        self.friendPosts = [Post]()
        self.notifications = [Notification]()

    }
    
    
    func addFriendPosts()
    {
    }
    func readFriendPosts()
    {
        ref = Database.database().reference().child("posts").child(self.thisUserDBContext)
        ref.observe(DataEventType.value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            let postID = value?["postID"] as? String ?? ""
            let userID = self.thisUserDBContext
            let image = value?["image"] as? String ?? ""
            let postDescription = value?["post description"] as? String ?? ""
            let creationDate = Date()
            let price = value?["price"] as? NSInteger ?? 0
            let location = value?["location"] as? String ?? ""
            let rating = value?["rating"] as? NSInteger ?? 0

            
            
            
            let newPost = Post(postId: postID, userId: userID, image: image, postDescription: postDescription, creationDate: Date(), price: price, location: location, rating: rating)
            
            self.friendPosts.append(newPost)

        })
    }
    
    func addUserToDB(_ user: User) {
        self.ref = Database.database().reference().child("users").child(user.uid)
        self.ref.child("userID").setValue(user.uid)
        self.ref.child("userName").setValue("marcelolongen")
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
