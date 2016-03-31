//
//  OpenRankController.swift
//  OpenRank
//
//  Created by linxiaolong on 16/3/23.
//  Copyright © 2016年 wengxianxun. All rights reserved.
//

import UIKit

//协议
protocol OpenrankProtocol {
    //单例
    static func shareInstance() -> OpenRankController
    
    //初始化sdk
    func initAppId(appId:String)
    
    //是否登录
    func isLogin()->Bool
    //登录
    func login(openId:String,appId:String,nickName:String,logo:String,block:(backbool:Bool)->Void)
    //显示排行榜
    func showRankFromScore(score:String)
}

public class OpenRankController: NSObject,OpenrankProtocol {
    
    private var finishClosure:((finish: Bool, name:String ) -> ())?
    public var appId:String?
    
    public class func shareInstance() -> OpenRankController {
        struct WXSingleton{
            static var predicate:dispatch_once_t = 0  //静态的线程安全
            static var instance:OpenRankController? = nil //可选静态类
        }
        dispatch_once(&WXSingleton.predicate, {WXSingleton.instance = OpenRankController()})
        return WXSingleton.instance!
    }
    
    override init() {
        
    }
    
    /**
     * 初始化appid
     */
    public func initAppId(appId: String) {
        self.appId = appId
    }
    
    /**
     * 是否已登录
     */
    public func isLogin()->Bool{
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
    public func login(openId:String,appId:String,nickName:String,logo:String,block:(backbool:Bool)->Void) {
        
        let url = "http://openrank.duapp.com/index.php?c=user&a=login&user_openid=\(openId)&app_id=\(appId)&score_score=\(0)&user_name=\(nickName)&user_logo=\(logo)"
        
        let wxxrequest = WxxHttpRequest()
        wxxrequest.requestGetFromAsyn(url) { (back) in
            
            let result = back.objectForKey("result") as! String;
            if result == "1"{
                print("登录成功");
                NSUserDefaults.standardUserDefaults().setValue(nickName, forKey: OPENRANKUSERNAME)
                NSUserDefaults.standardUserDefaults().setValue(logo, forKey: OPENRANKUSERLOGO)
                NSUserDefaults.standardUserDefaults().setValue(openId, forKey: OPENRANKOPENID)
                NSUserDefaults.standardUserDefaults().setBool(true, forKey: OPENRANKISLOGIN)
                block(backbool: true)
            }
            
        }
    }
    
    
    /**
     *  调用本方法在window上弹出在线排行榜
     *  参数：
     *      score       ->玩家的最新高分， 服务端会对本分数进行判断，如果低于旧分数不会更新
     *
     */
    public func showRankFromScore(score:String){
        WxxLog.PRINT("开始请求分数排行榜");
        if let app = UIApplication.sharedApplication().delegate, let window = app.window!{
            
            let webVC = WxxWebViewController(score: score)
            
            let nav = UINavigationController(rootViewController: webVC)
            window.rootViewController?.presentViewController(nav, animated: true, completion: { 
                WxxLog.PRINT("排行榜界面")
            })
        }
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
