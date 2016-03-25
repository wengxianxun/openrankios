//
//  ViewController.swift
//  OpenRank
//
//  Created by linxiaolong on 16/3/23.
//  Copyright © 2016年 wengxianxun. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        self.performSelector("login", withObject: nil, afterDelay: 2)
        
        // Do any additional setup after loading the view, typically from a nib.
    }

    func login() {
        SDKController.shareInstance().login();
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        var wxxWebvc = WxxWebViewController()
//        self.presentViewController(wxxWebvc, animated: true) {
//            
//        }
    }


}

