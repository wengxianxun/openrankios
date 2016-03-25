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
var finishClosure:((finish: Bool, name:String ) -> ())?
    class func shareInstance() -> OpenRankController {
        struct WXSingleton{
            static var predicate:dispatch_once_t = 0  //静态的线程安全
            static var instance:OpenRankController? = nil //可选静态类
        }
        dispatch_once(&WXSingleton.predicate, {WXSingleton.instance = OpenRankController()})
        return WXSingleton.instance!
    }
    
    //是否已登录
    func isLogin()->Bool{
        return NSUserDefaults.standardUserDefaults().boolForKey(OPENRANKISLOGIN)
    }
    
    /**
     *  登录用户数据   注：openrank目前只存储开发者提供的用户数据（包括第三方：QQ，微博，微信等），不单独提供新用户注册系统
     *  参数：
     *      openId      ->用户的唯一id
     *      appId       ->在官网注册的appId
     *      nickName    ->玩家昵称
     *      headUrl     ->玩家头像连接 注：QQ，微博，微信等sdk登录后都会提供头像连接，如果您的用户没有头像连接请传 @"" 值
     *      score       ->玩家的最新高分， 服务端会对本分数进行判断，如果低于旧分数不会更新
     *
     */
    /**
     *  外部使用方式
        OpenRankController.shareInstance().login("123", appId: "123", nickName: "你好", headUrl: "http:",block: {
            (back)->Void in
            //干嘛？
            print("block 返回值:\(back)")
        })
     */
    func login(openId:String,appId:String,nickName:String,logo:String,block:(backbool:Bool)->Void) {
        
        var url = NSURL(string: "http://openrank.duapp.com/index.php?c=user&a=login&user_openid=\(openId)&app_id=\(appId)&score_score=\(0)&user_name=\(nickName)&user_logo=\(logo)")
        
        
        
        block(backbool: true)
        
        
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
