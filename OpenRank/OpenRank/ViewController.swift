//
//  ViewController.swift
//  OpenRank
//
//  Created by linxiaolong on 16/3/23.
//  Copyright © 2016年 wengxianxun. All rights reserved.
//

import UIKit

class ViewController: UIViewController,UITextFieldDelegate {

    var label = UITextField()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        self.performSelector("login", withObject: nil, afterDelay: 2)
        
//        let loginbtn = UIButton(frame: CGRect(x: 150, y: 150, width: 90, height: 45))
//        loginbtn.setTitle("登录", forState: UIControlState.Normal)
//        loginbtn.backgroundColor = UIColor.grayColor()
//        loginbtn.addTarget(self, action: #selector(ViewController.login), forControlEvents: UIControlEvents.TouchUpInside)
//        self.view.addSubview(loginbtn)
        
        
        let showBtn = UIButton(frame: CGRect(x: 150, y: 250, width: 90, height: 45))
        showBtn.setTitle("排行版", forState: UIControlState.Normal)
        showBtn.backgroundColor = UIColor.grayColor()
        showBtn.addTarget(self, action: #selector(ViewController.showRank), forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(showBtn)
        // Do any additional setup after loading the view, typically from a nib.
        
        
                let okbtn = UIButton(frame: CGRect(x: 10, y: 150, width: 90, height: 45))
                okbtn.setTitle("确定", forState: UIControlState.Normal)
                okbtn.backgroundColor = UIColor.grayColor()
                okbtn.addTarget(self, action: #selector(ViewController.okok), forControlEvents: UIControlEvents.TouchUpInside)
                self.view.addSubview(okbtn)
        
        label = UITextField(frame: CGRect(x: 10, y: 100, width: self.view.frame.size.width-20, height: 40))
        label.placeholder = "请输入测试分数"
        label.keyboardType = UIKeyboardType.NumberPad
        label.layer.borderWidth = 0.5
        label.delegate = self
        label.returnKeyType = UIReturnKeyType.Done
        label.layer.borderColor = UIColor.blackColor().CGColor
        self.view.addSubview(label)
        
    }
    
    func okok(){
        self.label.resignFirstResponder()
        SDKController.shareInstance().score = self.label.text!;
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    

    func login() {
        SDKController.shareInstance().login();
    }
    
    func showRank() {
        SDKController.shareInstance().showRank();
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

