//
//  LoginController.swift
//  FoodGram
//
//  Created by Marcelo Longen on 2018-11-21.
//  Copyright © 2018 Marcelo Longen. All rights reserved.
//

import UIKit
import Firebase

class LoginController: UIViewController {

    @IBOutlet weak var createAccBtn: UIButton!
    @IBAction func createAccAction(_ sender: Any) {
        Auth.auth().createUser(withEmail: "marcelolongen@gmail.com", password: "123456") { (authResult, error) in
            // ...
            guard let user = authResult?.user else { return }
            MyDatabase.shared.thisUserDBContext = user.uid
            self.performSegue(withIdentifier: "showTab",sender: self)
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

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
