//
//  SDKController.swift
//  OpenRank
//
//  Created by linxiaolong on 16/3/24.
//  Copyright © 2016年 wengxianxun. All rights reserved.
//

import UIKit



class SDKController: NSObject {

    //单例
    class func shareInstance()->SDKController{
        
        struct YUSingleton{
            static var predicate:dispatch_once_t = 0  //静态的线程安全
            static var instance:SDKController? = nil //可选静态类
        }
        dispatch_once(&YUSingleton.predicate, {YUSingleton.instance = SDKController()})
        return YUSingleton.instance!
    }
    
    //登录
    func login(){
//        if isLogin() {
//            
//        }
    }
    
    
}
