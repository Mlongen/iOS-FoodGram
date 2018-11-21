//
//  AddPostViewController.swift
//  FoodGram
//
//  Created by Marcelo Longen on 2018-11-07.
//  Copyright © 2018 Marcelo Longen. All rights reserved.
//

import UIKit
import FirebaseDatabase


class AddPostViewController: UIViewController {
    var ref: DatabaseReference!
    var myDB: MyDatabase!

    
    @IBOutlet weak var restaurantName: UITextField!
    
    @IBOutlet weak var amount: UISlider!
    
    
    @IBOutlet weak var rating: UISlider!
    @IBOutlet weak var postDescription: UITextField!
    @IBOutlet weak var image: UIImageView!
    
    
    
    @IBOutlet weak var postButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.myDB = MyDatabase.shared
        ref = Database.database().reference().child("posts").child(myDB.thisUserDBContext)
        
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addPost(_ sender: Any) {
        let uuid = UUID().uuidString
        let userID = myDB.thisUserDBContext
        
        let image = #imageLiteral(resourceName: "food")
        let imageData = convertImageToBase64(image: image)
        
        let postDescription = "description"
        let creationDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd-MMM-yyyy"
        let formattedDate = formatter.string(from: creationDate)
        let price = 11
        let location = "location"
        let rating = 10
    
        
        ref.child("postID").setValue(uuid)
        ref.child("userID").setValue(userID)
//        ref.child("image").setValue(imageData)
        ref.child("postDescription").setValue(postDescription)
        ref.child("creationDate").setValue(formattedDate)
        ref.child("price").setValue(price)
        ref.child("location").setValue(location)
        ref.child("rating").setValue(rating)
        
        

    }
    
    func convertImageToBase64(image: UIImage) -> String {
        let imageData = image.pngData()!
        return imageData.base64EncodedString(options: Data.Base64EncodingOptions.lineLength64Characters)
    }
    

}
