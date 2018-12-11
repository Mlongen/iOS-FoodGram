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
        tabBarController?.tabBarItem.imageInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        
        // Do any additional setup after loading the view.
    }
    
}
extension TabController: TransitionableTab {
    
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        return animateTransition(tabBarController, shouldSelect: viewController)
    }
}
