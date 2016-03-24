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
        
        OpenRankController.shareInstance().login("123", appId: "123", nickName: "你好", headUrl: "http:",block: {
            (back)->Void in
            //干嘛？
            print("block 返回值:\(back)")
        })
        // Do any additional setup after loading the view, typically from a nib.
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

