//
//  SearchViewController.swift
//  FoodGram
//
//  Created by Marcelo Longen on 2018-10-17.
//  Copyright © 2018 Marcelo Longen. All rights reserved.
//

import UIKit
import SearchTextField

class SearchViewController: UIViewController {
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Connect your IBOutlet...
       
        
        // ...or create it manually
        let mySearchTextField = SearchTextField(frame: CGRect(x: 10, y: 100, width: 200, height: 40))
        
        // Set the array of strings you want to suggest
        mySearchTextField.filterStrings(["Red", "Blue", "Yellow"])
        
       mySearchTextField.inlineMode = true

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
