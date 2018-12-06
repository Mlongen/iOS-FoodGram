//
//  SearchViewController.swift
//  FoodGram
//
//  Created by Marcelo Longen on 2018-10-17.
//  Copyright © 2018 Marcelo Longen. All rights reserved.
//

import UIKit
import RAMReel
import NotificationBannerSwift

class SearchViewController: UIViewController,UICollectionViewDelegate {
    
    var dataSource: SimplePrefixQueryDataSource!
    var data: [String]!
    var ramReel: RAMReel<RAMCell, RAMTextField, SimplePrefixQueryDataSource>!
    var result: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        data = Array(MyDatabase.shared.allUsers.keys)
        dataSource = SimplePrefixQueryDataSource(data)
        
        ramReel = RAMReel(frame: view.bounds, dataSource: dataSource, placeholder: "Start by typing…", attemptToDodgeKeyboard: false) {
            print("Plain:", $0)
        }
        
        ramReel.hooks.append {
            self.result = $0
            if (self.data.contains(self.result)) {
                let banner = NotificationBanner(title: "User \(self.result) exists", subtitle: nil, style: .success)
                banner.show()
                 self.performSegue(withIdentifier: "showProfileFromSearch", sender: self)

            } else {
                let banner = NotificationBanner(title: "User \(self.result) does not exist", subtitle: nil, style: .danger)
                banner.show()
            }
        }
        
        view.addSubview(ramReel.view)

    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if (segue.identifier == "showProfileFromSearch") {
            if let dest = segue.destination as? ProfileViewController{
                dest.thisUser = self.result
            }

}
}
}
