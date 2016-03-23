//
//  WxxWebViewController.swift
//  OpenRank
//
//  Created by weng xiangxun on 16/3/23.
//  Copyright © 2016年 wengxianxun. All rights reserved.
//  使用例子  http://www.cocoachina.com/ios/20150911/13301.html

import UIKit
//使用wkwebview先导入webkit
import WebKit

class WxxWebViewController: UIViewController {

    var wk:WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        self.wk = WKWebView(frame: self.view.frame)
        self.wk.loadRequest(NSURLRequest(URL: NSURL(string: "http://www.baidu.com")!))
        self.view.addSubview(self.wk)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
