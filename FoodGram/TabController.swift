//
//  TabController.swift
//  FoodGram
//
//  Created by Marcelo Longen on 2018-12-07.
//  Copyright © 2018 Marcelo Longen. All rights reserved.
//

import UIKit
import TransitionableTab

class TabController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self

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
extension TabController: TransitionableTab {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return animateTransition(tabBarController, shouldSelect: viewController)
    }
}
