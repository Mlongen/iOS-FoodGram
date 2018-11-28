//
//  AddPostViewController.swift
//  FoodGram
//
//  Created by Marcelo Longen on 2018-11-07.
//  Copyright © 2018 Marcelo Longen. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import GooglePlaces
import GooglePlacePicker



class AddPostViewController: UIViewController, GMSPlacePickerViewControllerDelegate {
    var ref: DatabaseReference!
    var myDB: MyDatabase!
    var storageRef: StorageReference!


    @IBAction func pickPlace(_ sender: Any) {
        let config = GMSPlacePickerConfig(viewport: nil)
        let placePicker = GMSPlacePickerViewController(config: config)
        
        placePicker.delegate = self
        
        present(placePicker, animated: true, completion: nil)
    }
    
    @IBOutlet weak var restaurantName: UITextField!
    @IBOutlet weak var amount: UISlider!
    @IBOutlet weak var rating: UISlider!
    @IBOutlet weak var postDescription: UITextField!
    @IBOutlet weak var image: UIImageView!
    
    @IBOutlet weak var nameLabel: UILabel!
    
    
    @IBOutlet weak var postButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myDB = MyDatabase.shared
        ref = Database.database().reference().child("posts").child(myDB.thisUserDBContext)
        self.storageRef = Storage.storage().reference()
        
        
        // Do any additional setup after loading the view.
    }
    
    func placePicker(_ viewController: GMSPlacePickerViewController, didPick place: GMSPlace) {
        viewController.dismiss(animated: true, completion: nil)
        print("Place name \(place.name)")
        self.nameLabel.text = place.name
    }
    
    fileprivate func upload(_ image: UIImage, _ postId: String, _ userId: String, _ postDescription: String, _ formattedDate: String, _ price: Int, _ location: String, _ rating: Int) {
        if let imageData = image.pngData(){
            storageRef.child(postId).putData(imageData, metadata: nil) { (metadata, error) in
                if(error != nil){
                    print(error!)
                    return
                }
                
                // Fetch the download URL
                self.storageRef.child(postId).downloadURL { url, error in
                    if let error = error {
                        
                        print(error)
                        return
                    } else {
                        // Get the download URL
                        let urlStr:String = (url?.absoluteString ?? "")
                        self.ref.child("postID").setValue(postId)
                        self.ref.child("userID").setValue(userId)
                        self.ref.child("image").setValue(urlStr)
                        self.ref.child("postDescription").setValue(postDescription)
                        self.ref.child("creationDate").setValue(formattedDate)
                        self.ref.child("price").setValue(price)
                        self.ref.child("location").setValue(location)
                        self.ref.child("rating").setValue(rating)
                    }
                }
            }
        }
    }
    
    @IBAction func addPost(_ sender: Any) {
        let postId = UUID().uuidString
        let userId = myDB.thisUserDBContext
        
        let image = #imageLiteral(resourceName: "food-1")
        let postDescription = "description"
        let creationDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        let formattedDate = formatter.string(from: creationDate)
        let price = 11
        let location = "location"
        let rating = 10
    
        upload(image, postId, userId, postDescription, formattedDate, price, location, rating)
    }

    func convertImageToBase64(image: UIImage) -> String {
        let imageData = image.pngData()!
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
    

    func placePickerDidCancel(_ viewController: GMSPlacePickerViewController) {
        // Dismiss the place picker, as it cannot dismiss itself.
        viewController.dismiss(animated: true, completion: nil)
        
        print("No place selected")
        self.nameLabel.text = "No place selected"
    }
}
