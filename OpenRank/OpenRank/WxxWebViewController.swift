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

//typealias 类型别名, 为原有类型定义一个新名字
private typealias wkNavigationDelegate = WxxWebViewController
extension wkNavigationDelegate{
    func webView(webView: WKWebView, didFailNavigation navigation: WKNavigation!, withError error: NSError) {
        NSLog(error.debugDescription)
    }
    func webView(webView: WKWebView, didFailProvisionalNavigation navigation: WKNavigation!, withError error: NSError) {
        NSLog(error.debugDescription)
    }
}

private typealias wkUIdelegate = WxxWebViewController
extension wkUIdelegate{
    func webView(webView: WKWebView, runJavaScriptAlertPanelWithMessage message: String, initiatedByFrame frame: WKFrameInfo, completionHandler: () -> Void) {
        
        let ac = UIAlertController(title: webView.title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        ac.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (aa) -> Void in
            completionHandler()
        }))
        self.presentViewController(ac, animated: true, completion: nil)
    }
}

class WxxWebViewController: UIViewController,WKNavigationDelegate,WKUIDelegate {

    var score:String? //分数
    private var wk:WKWebView!
    
    //便利构造器
    convenience init(score:String){
        self.init()
        self.score = score
        
        

    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.redColor()
        // Do any additional setup after loading the view.
        
        let leftBtn = UIBarButtonItem(title: "退出", style: UIBarButtonItemStyle.Done, target: self, action: #selector(WxxWebViewController.closeSelf))
        self.navigationItem.leftBarButtonItem = leftBtn
        
        self.wk = WKWebView(frame: self.view.frame)
        self.wk.navigationDelegate = self
        self.wk.UIDelegate = self
        self.view.addSubview(self.wk)
        //加载分数排行
        let openid = NSUserDefaults.standardUserDefaults().valueForKey(OPENRANKOPENID) as! String
        let appid = OpenRankController.shareInstance().appid!
        let score = self.score!
        let url = "http://openrank.duapp.com/index.php?c=rank&a=ShowRankHtml&user_openid=\(openid)&app_id=\(appid)&score_score=\(score)"
        self.wk.loadRequest(NSURLRequest(URL: NSURL(string: url)!))
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        
        
        
    }
    
    func closeSelf() {
        self.dismissViewControllerAnimated(true) { 
            print("排行榜界面->退出成功!");
        }
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
