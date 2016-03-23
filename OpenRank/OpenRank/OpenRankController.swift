//
//  OpenRankController.swift
//  OpenRank
//
//  Created by linxiaolong on 16/3/23.
//  Copyright © 2016年 wengxianxun. All rights reserved.
//

import UIKit
//宏定义
let OPENRANKISLOGIN = "OPENRANKISLOGIN"

class OpenRankController: NSObject {

    //单例
    class func shareInstance()->OpenRankController{
    
        struct YUSingleton{
            static var predicate:dispatch_once_t = 0  //静态的线程安全
            static var instance:OpenRankController? = nil //可选静态类
        }
        dispatch_once(&YUSingleton.predicate, {YUSingleton.instance = OpenRankController()})
        return YUSingleton.instance!
    }
    
    //登录
    func login(){
        if isLogin() {
            
        }
    }
    
    //是否已登录
    private func isLogin()->Bool{
        return NSUserDefaults.standardUserDefaults().boolForKey(OPENRANKISLOGIN)
    }
}
