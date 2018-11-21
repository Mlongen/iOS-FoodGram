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
        ref = Database.database().reference()
        self.myDB = MyDatabase.shared
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func addPost(_ sender: Any) {
        self.ref.child("users/\(myDB.thisUserDBContext)/username").setValue("test")
    }
    

}
