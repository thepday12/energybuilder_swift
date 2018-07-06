//
//  RightViewController.swift
//  energybuilder
//
//  Created by Thep To Kim on 6/15/18.
//  Copyright © 2018 Thep To Kim. All rights reserved.
//

import Foundation
import UIKit
let myNotificationReloadInfoKey = "co.reload"
class RightViewController: UIViewController {
    var gradientLayer: CAGradientLayer!
    
   
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(forName: NSNotification.Name(rawValue: myNotificationReloadInfoKey),object: nil,queue: nil, using:reloadDisplay)
        
        
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func reloadDisplay(notification: Notification){
       
    }
    
   
    
    
    
    
    
    
    
    
}
