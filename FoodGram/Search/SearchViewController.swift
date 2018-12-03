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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        data = Array(MyDatabase.shared.allUsers.keys)
        dataSource = SimplePrefixQueryDataSource(data)
        
        ramReel = RAMReel(frame: view.bounds, dataSource: dataSource, placeholder: "Start by typing…", attemptToDodgeKeyboard: false) {
            print("Plain:", $0)
        }
        
        ramReel.hooks.append {
            let r = $0
            if (self.data.contains(r)) {
                let banner = NotificationBanner(title: "User \(r) exists", subtitle: nil, style: .success)
                banner.show()
            } else {
                let banner = NotificationBanner(title: "User \(r) does not exist", subtitle: nil, style: .danger)
                banner.show()
            }
        }
        
        view.addSubview(ramReel.view)

    }

}
