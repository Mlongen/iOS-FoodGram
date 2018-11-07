//
//  AddPostViewController.swift
//  FoodGram
//
//  Created by Marcelo Longen on 2018-11-07.
//  Copyright © 2018 Marcelo Longen. All rights reserved.
//

import UIKit

class AddPostViewController: UIViewController {

    
    @IBOutlet weak var restaurantName: UITextField!
    
    @IBOutlet weak var amount: UISlider!
    
    
    @IBOutlet weak var rating: UISlider!
    @IBOutlet weak var postDescription: UITextField!
    @IBOutlet weak var image: UIImageView!
    
    
    @IBOutlet weak var postButton: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

}
