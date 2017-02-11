//
//  ViewController.swift
//  RITW.HelloWorld
//
//  Created by XIndong Zhang on 2017/1/28.
//  Copyright © 2017年 SmackInnovations. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    

    @IBAction func retrieveData(_ sender: Any) {
        let userDefaults = UserDefaults(suiteName: "group.com.RITW")
        if let testUserId = userDefaults?.object(forKey: "userId") as? String {
            print("User Id: \(testUserId)")
        }
        
    }

}

