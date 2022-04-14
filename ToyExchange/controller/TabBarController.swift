//
//  UITabBarControllerViewController.swift
//  ToyExchange
//
//  Created by Med Wajdi BRAHEM on 7/11/2021.
//

import UIKit

class TabBarController: UITabBarController {

    //lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //hide navigation back button
        self.navigationItem.setHidesBackButton(true, animated: true)
        
      
    }
    


}
