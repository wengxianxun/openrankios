//
//  LoginViewController.swift
//  OpenRank
//
//  Created by linxiaolong on 16/4/1.
//  Copyright © 2016年 wengxianxun. All rights reserved.
//  多平台登录界面

import UIKit

class LoginViewController: UIViewController,UITableViewDelegate,UITableViewDataSource {

    let dic = [0:(title:"QQ登录",logo:"sns_icon_24.png"),1:(title:"Sina微博登录",logo:"sns_icon_1.png")]
    var tableView = UITableView()
    
    class func showLoginVC(){
        
        WxxLog.PRINT("多平台登录");
        if let app = UIApplication.sharedApplication().delegate, let window = app.window!{
            
            let loginVC = LoginViewController()
            
            let nav = UINavigationController(rootViewController: loginVC)
            window.rootViewController?.presentViewController(nav, animated: true, completion: {
                WxxLog.PRINT("登录界面")
            })
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        // Do any additional setup after loading the view.
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(LoginViewController.closeSelf), name: kLOGINSUCCESSNOTIFACATION, object: nil)
        
        let leftBtn = UIBarButtonItem(title: "返回", style: UIBarButtonItemStyle.Done, target: self, action: #selector(LoginViewController.closeSelf))
        self.navigationItem.leftBarButtonItem = leftBtn
        
        tableView = UITableView(frame: self.view.frame, style: UITableViewStyle.Plain)
        tableView.dataSource = self;
        tableView.delegate = self;
        self.view.addSubview(tableView)
    }
    
    func qqlogin(){
        
        SDKController.shareInstance().qqlogin()
    }

    func closeSelf() {
        self.dismissViewControllerAnimated(true) {
            WxxLog.PRINT("登录界面->退出成功!");
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    
    // MARK: -uitableview
    //组
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    //行
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dic.count
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let initIdentifier = "Cell"
        let cell = UITableViewCell(style:UITableViewCellStyle.Subtitle, reuseIdentifier: initIdentifier)
        
        let data = dic[indexPath.row]
        
        cell.textLabel?.text = data!.title
//        cell.detailTextLabel?.text = "某平台登录"
        cell.imageView?.image = UIImage(named: data!.logo);
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.qqlogin()
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
