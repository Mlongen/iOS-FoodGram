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
    var notificationsTableView: UITableView?
    var searchCollectionView: UICollectionView?
    
    var specificProfileCollectionView: UICollectionView?
    var searchResults: [Post]
    var searchResultIds: [String]
    
    var allNotifications: [Notification]
    var filteredNotifications: [Notification]
    var filteredNotificationsIds: [String]
    
    var specificProfilePosts: [Post]
    var specificProfilePostIds: [String]
    
    
    init(thisUserDBContext: String = "0") {
        
        self.thisUserDBContext = thisUserDBContext
        self.selfPosts = [Post]()
        self.friends = [String]()
        self.friendPosts = [Post]()
        self.allNotifications = [Notification]()
        self.filteredNotifications = [Notification]()
        self.filteredNotificationsIds = [String]()
        self.timelinePostIds = [String]()
        self.hasLoadedPosts = 0
        self.hasLoadedFriends = 0
        self.hasLoadedAllUsers = 0
        self.searchResults = [Post]()
        self.searchResultIds = [String]()
        self.specificProfilePosts = [Post]()
        self.specificProfilePostIds = [String]()
        self.allUsers = [String: String]()
        

    }
    
    func readFriends()
    {
        self.ref = Database.database().reference().child("users").child(self.thisUserDBContext).child("friends")
        self.ref.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    if let value = snap.value as? Dictionary<String, AnyObject> {
                        let user = value["userId"] as? String ?? ""
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
    
    func filterSearchDuplicates(post: Post) {
        if !self.searchResultIds.contains(post.postId) {
            MyDatabase.shared.searchResults.append(post)
            self.searchResultIds.append(post.postId)
        }
    }
    
    func filterSpecificProfileDuplicates(post: Post) {
        if !self.specificProfilePostIds.contains(post.postId) {
            MyDatabase.shared.specificProfilePosts.append(post)
            self.specificProfilePostIds.append(post.postId)
        }
    }
    func filterAllUsersDuplicates(userName: String, userId: String) {
        if (!self.allUsers.keys.contains(userName) && userName != "") {
            self.allUsers[userName] = userId
        }
    }
    
    func filterNotificationDuplicates(notification: Notification) {
        if (!self.filteredNotificationsIds.contains(notification.notificationID)) {
            self.filteredNotifications.append(notification)
            self.filteredNotificationsIds.append(notification.notificationID)
        }
    }

    func freshUserList() -> [String] {
        var result = [String]()
        self.ref = Database.database().reference().child("users")
        self.ref.observe(DataEventType.value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    if let value = snap.value as? Dictionary<String, AnyObject> {
                        let thisUser = value["userName"] as? String ?? ""
                        result.append(thisUser)
                    }
                }
            }

        }
        )
        return result
    }
    func readFriendsPosts() {
        for friend in friends {
            self.ref = Database.database().reference().child("users").child(friend).child("posts")
            self.ref.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
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
            })

        }
        self.friendPosts = self.friendPosts.sorted(by: {
            $0.creationDate.compare($1.creationDate) == .orderedDescending
        })
        self.hasLoadedPosts = self.hasLoadedPosts + 1
    }
    
    func reloadFriendsPosts() {
        self.friendPosts.removeAll()
        self.timelinePostIds.removeAll()
        for friend in friends {
            self.ref = Database.database().reference().child("users").child(friend).child("posts")
            self.ref.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
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
    
    
    func hotReload() {
        self.readAllUsersOnce()
        self.reloadNotifications()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5, execute: {
            self.hotReload()
        })
    }

    func readAllUsersOnce()
    {
        self.ref = Database.database().reference().child("users")
        self.ref.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    if let value = snap.value as? Dictionary<String, AnyObject> {
                        let userID = value["userID"] as? String ?? ""
                        let thisUser = value["userName"] as? String ?? ""
                            self.filterAllUsersDuplicates(userName: thisUser, userId: userID)
                    }
                }
            }
            MyDatabase.shared.hasLoadedAllUsers = MyDatabase.shared.hasLoadedAllUsers + 1
        })
    }
    @objc func bridgeReload() {
        MyDatabase.shared.reloadFriendsPosts()
    }
    
    func readUserPostsById(userID: String){
        self.specificProfilePostIds.removeAll()
        self.specificProfilePosts.removeAll()
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
                        
                        self.filterSpecificProfileDuplicates(post: newPost)
                        
                    }
                }
            }
            self.specificProfilePosts = self.specificProfilePosts.sorted(by: {
                $0.creationDate.compare($1.creationDate) == .orderedDescending
            })
            MyDatabase.shared.specificProfileCollectionView?.reloadData()
            MyDatabase.shared.specificProfileCollectionView?.refreshControl?.endRefreshing()
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
    
    func setUserNameAfterCreation(username: String) {
        self.ref = Database.database().reference().child("users").child(MyDatabase.shared.thisUserDBContext)
        self.ref.child("userName").setValue(username)
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
    
    func checkIfUsername(userID: String,  completion: @escaping (String) -> ()){
        let DBref = Database.database().reference().child("users").child(userID).child("userName")
        DBref.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            if let name = snapshot.value as? String {
                completion(name)
            } else {
                completion("")
            }
            
        })
    }
    func checkIfUserExists(email: String, completion: @escaping (Bool) -> ()){
    
        self.ref = Database.database().reference().child("users")
        self.ref.observe(DataEventType.value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                    if let value = snap.value as? Dictionary<String, AnyObject> {
                        let userEmail = value["email"] as? String ?? ""
                        if email == userEmail {
                            completion(true)
                            break
                        }
                    }
                }
            }
        })
    }
    func addUserAsFriend(userName: String) {
        let senderUserId = self.getUserIDByName(userName: userName)
        let reference = Database.database().reference().child("users").child(self.thisUserDBContext).child("friends").child(senderUserId )
        reference.child("userName").setValue(userName)
        reference.child("userId").setValue(senderUserId)
        
        let reference2 = Database.database().reference().child("users").child(senderUserId).child("friends").child(self.thisUserDBContext)
        reference2.child("userName").setValue(self.getUserById(userID: self.thisUserDBContext))
        reference2.child("userId").setValue(self.thisUserDBContext)
        
        
    }

    func getUserById(userID: String) -> String{

        return self.allUsers.someKey(forValue: userID)!
        }
    
    func getUserIDByName(userName: String) -> String{
        return self.allUsers[userName]!
    }
    }


// notification stuff
extension MyDatabase {
    
    func checkIfNotificationHasBeenSent(createdById: String, sentTo: String, type: String, completion: @escaping (String) -> ()){
            self.ref = Database.database().reference().child("users").child(sentTo).child("notifications")
            self.ref.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
                if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                    for snap in snapshots {
                        if let value = snap.value as? Dictionary<String, AnyObject> {
                            let snapCreatedById = value["createdByID"] as? String ?? ""
                            let snapType = value["type"] as? String ?? ""
                            let status = value["status"] as? String ?? ""
                            
                            if (snapCreatedById == createdById && type == "FriendRequest" && status == "Accepted") {
                                completion("FriendAlready")
                                print(1)
                                return
                            }
                            if (snapCreatedById == createdById && snapType == type) {
                                completion("RequestedAlready")
                                print(2 )
                                return
                            }
                            
                        }
                    }
                    completion("NotFound")
                }
                
            })
    }
    
    func reloadNotifications()
    {
        MyDatabase.shared.allNotifications.removeAll()
        MyDatabase.shared.filteredNotifications.removeAll()
        MyDatabase.shared.filteredNotificationsIds.removeAll()
        self.ref = Database.database().reference().child("users").child(self.thisUserDBContext).child("notifications")
        self.ref.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {

                for snap in snapshots {
                    if let value = snap.value as? Dictionary<String, AnyObject> {
                        let notificationID = value["notificationID"] as? String ?? ""
                        let content = value["content"] as? String ?? ""
                        let createdByID = value["createdByID"] as? String ?? ""
                        let createdByUser = value["createdByUser"] as? String ?? ""
                        let creationDate = value["creationDate"] as? String ?? ""
                        let status = value["status"] as? String ?? ""
                        let type = value["type"] as? String ?? ""

                        
                        let notification = Notification(notificationID: notificationID, createdByUser: createdByUser, createdByID: createdByID, content: content, type: type, creationDate: creationDate, status: status)
                        
                        if (notification.status != "Accepted") {
                           self.filterNotificationDuplicates(notification: notification)
                        }
                        MyDatabase.shared.allNotifications.append(notification)
                    }
                }
            }
            self.filteredNotifications =  self.filteredNotifications.sorted(by: {
                $0.creationDate.compare($1.creationDate) == .orderedDescending
            })
            MyDatabase.shared.notificationsTableView?.reloadData()
            MyDatabase.shared.notificationsTableView?.refreshControl?.endRefreshing()
        })
    }
    
    func removeNotification(notification: Notification) {
        let index = MyDatabase.shared.filteredNotifications.firstIndex(of: notification)
        MyDatabase.shared.filteredNotifications.remove(at: index!)

    }
    
    func setNotificationAsRead(notificationId: String, status: String) {
        if (status == "Pending") {
            let DBref = Database.database().reference().child("users").child(MyDatabase.shared.thisUserDBContext).child("notifications").child(notificationId)
            DBref.child("status").setValue("Read")
        }
    }
    
    func setNotificationAccepted(notificationId: String) {
        let DBref = Database.database().reference().child("users").child(MyDatabase.shared.thisUserDBContext).child("notifications").child(notificationId)
        DBref.child("status").setValue("Accepted")
        
    }
    
}

//search stuff
extension MyDatabase
{
    func findPostsByRestaurantname(searchedName: String) {
        
        self.searchResults.removeAll()
        self.searchResultIds.removeAll()
        let users = Array(MyDatabase.shared.allUsers.values)
        
    
        for user in users {
            self.ref = Database.database().reference().child("users").child(user).child("posts")
            self.ref.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
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
                            
                            if location == searchedName {
                                let newPost = Post(postId: postID, userId: userID, image: image, postDescription: postDescription, creationDate: creationDate, price: price, location: location, rating: rating)
                                
                                self.filterSearchDuplicates(post: newPost)
                            }
                        }
                    }
                }
                self.searchResults = self.searchResults.sorted(by: {
                    $0.creationDate.compare($1.creationDate) == .orderedDescending
                })
                MyDatabase.shared.searchCollectionView!.reloadData()
            })
        }
    }
}

//like stuff
extension MyDatabase {
    
    func getNumberOfLikes(userDestinationId: String, postDestinationID: String, completion: @escaping (Int) -> ()){
        var totalLikes = 0
        self.ref = Database.database().reference().child("users").child(userDestinationId).child("posts").child(postDestinationID).child("Likes")
        self.ref.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            if let snapshots = snapshot.children.allObjects as? [DataSnapshot] {
                for snap in snapshots {
                        totalLikes = totalLikes + 1
                    
                }
            }
            completion(totalLikes)
        })
    }
    
    func checkIfUserAlreadyLiked(userDestinationId: String, postDestinationID: String, completion: @escaping (Bool) -> ()){
        
        self.ref = Database.database().reference().child("users").child(userDestinationId).child("posts").child(postDestinationID).child("Likes")
        self.ref.observeSingleEvent(of: DataEventType.value, with: { (snapshot) in
            if snapshot.hasChild(MyDatabase.shared.thisUserDBContext) {
                completion(true)
            } else {
                completion(false)
            }
            
        })
    }
    func addLikeToUser(userDestinationId: String, postDestinationId: String)
    {
        self.ref = Database.database().reference().child("users").child(userDestinationId).child("posts").child(postDestinationId).child("Likes")
        self.ref.child(MyDatabase.shared.thisUserDBContext).setValue(MyDatabase.shared.thisUserDBContext)

    }

    func removeLikeFromUser(userDestinationId: String, postDestinationId: String)
    {
                self.ref = Database.database().reference().child("users").child(userDestinationId).child("posts").child(postDestinationId).child("Likes")
                self.ref.child(MyDatabase.shared.thisUserDBContext).setValue(nil)
    }
}

