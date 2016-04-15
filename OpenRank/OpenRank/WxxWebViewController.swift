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

class WxxWebViewController: UIViewController,WKNavigationDelegate,WKUIDelegate,WKScriptMessageHandler {

    var score:String? //分数
    private var wk:WKWebView!
    private var config:WKWebViewConfiguration!
    private var progressView: UIProgressView!
    
    //便利构造器
    convenience init(score:String){
        self.init()
        //初始化分数
        self.score = score
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        // Do any additional setup after loading the view.
        
        let leftBtn = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Done, target: self, action: #selector(WxxWebViewController.closeSelf))
        self.navigationItem.leftBarButtonItem = leftBtn
        
        self.initWebView()
        self.loadHtmlRequest()
    }

    func initWebView(){
        
        config = WKWebViewConfiguration()
        //注册js方法
        config.userContentController.addScriptMessageHandler(self, name:"webViewApp")
        self.wk = WKWebView(frame: self.view.frame, configuration: config)
        self.wk.navigationDelegate = self
        self.wk.UIDelegate = self
        self.view.addSubview(self.wk)
    }
    func loadHtmlRequest(){
        
        if self.wk == nil{
            return
        }
        //加载分数排行
        var openid = NSUserDefaults.standardUserDefaults().valueForKey(OPENRANKOPENID) as? String
        
        openid = openid != nil ? openid : ""
        
        let appid = OpenRankController.shareInstance().appId!
        let score = self.score!
        let url = "http://openrank.duapp.com/index.php?c=rank&a=ShowRankHtml&user_openid=\(openid!)&app_id=\(appid)&score_score=\(score)"
        WxxLog.DEBUG(url)
        self.wk.loadRequest(NSURLRequest(URL: NSURL(string: url)!))
    }
    
    func rightBtn(title:String,action:Selector){
        
        let leftBtn = UIBarButtonItem(title: title, style: UIBarButtonItemStyle.Done, target: self, action: action)
        self.navigationItem.rightBarButtonItem = leftBtn
    }
    
    
    func login() {
        //登录 回调给开发者自己调用？
        //还是内置实现多平台登录？
        self.closeSelf()
        
        
        OpenRankController.shareInstance().htmlViewBlock!(ORenum: OpenRankEnum.LoginEnum)
    }
    func logout(){
        
        OpenRankController.shareInstance().logout()
        
        self.rightBtn("登录",action:#selector(WxxWebViewController.login))
        let ac = UIAlertController(title: "提示", message: "您已退出登录", preferredStyle: UIAlertControllerStyle.Alert)
        ac.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Cancel, handler: { (aa) -> Void in
            
        }))
        self.presentViewController(ac, animated: true, completion: nil)
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(animated: Bool) {
        print("viewDidAppear%f---%f",self.view.frame.size.width,self.view.frame.size.height)
        super.viewDidAppear(animated)
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear%f---%f",self.view.frame.size.width,self.view.frame.size.height)
        self.wk.addObserver(self, forKeyPath: "estimatedProgress", options: .New, context: nil)
    }
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.wk.removeObserver(self, forKeyPath: "estimatedProgress")
    }
    //MARK: KVO
    override func observeValueForKeyPath(keyPath: String?, ofObject object: AnyObject?, change: [String : AnyObject]?, context: UnsafeMutablePointer<Void>) {
        guard let keyPath = keyPath else {return}
        switch keyPath {
        case "estimatedProgress":
            if let newValue = change?[NSKeyValueChangeNewKey] as? NSNumber {
                progressChanged(newValue)
            }
        default:
            print("")
        }
    }
    
    
    override func didRotateFromInterfaceOrientation(fromInterfaceOrientation: UIInterfaceOrientation) {
        if UIInterfaceOrientationIsLandscape(fromInterfaceOrientation) {
            WxxLog.PRINT("横屏");
            self.wk.frame = self.view.frame
        }else{
            WxxLog.PRINT("竖屏");
            self.wk.frame = self.view.frame
        }
    }
    
    //实现js调用ios的handle委托
    func userContentController(userContentController: WKUserContentController, didReceiveScriptMessage message: WKScriptMessage) {
        //接受传过来的消息从而决定app调用的方法
        let dict = message.body as! Dictionary<String,String>
        let jsfunc:String = dict["jsfunc"]!
        
        if jsfunc=="nologin"{//未登录显示登录按钮
            self.rightBtn("登录",action:#selector(WxxWebViewController.login))
        }else if jsfunc=="islogin"{
            self.rightBtn("退出登录", action: #selector(WxxWebViewController.logout))
        }
    }
    
    private func progressChanged(newValue: NSNumber) {
        if progressView == nil {
            progressView = UIProgressView()
            progressView.translatesAutoresizingMaskIntoConstraints = false
            self.view.addSubview(progressView)
            
            self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("|-0-[progressView]-0-|", options: [], metrics: nil, views: ["progressView": progressView]))
            self.view.addConstraints(NSLayoutConstraint.constraintsWithVisualFormat("V:|[topGuide]-0-[progressView(2)]", options: [], metrics: nil, views: ["progressView": progressView, "topGuide": self.topLayoutGuide]))
        }
        
        progressView.progress = newValue.floatValue
        if progressView.progress == 1 {
            progressView.progress = 0
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.progressView.alpha = 0
            })
        } else if progressView.alpha == 0 {
            UIView.animateWithDuration(0.2, animations: { () -> Void in
                self.progressView.alpha = 1
            })
        }
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
