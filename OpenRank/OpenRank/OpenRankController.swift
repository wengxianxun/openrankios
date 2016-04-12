//
//  OpenRankController.swift
//  OpenRank
//
//  Created by linxiaolong on 16/3/23.
//  Copyright © 2016年 wengxianxun. All rights reserved.
//

import UIKit

public enum OpenRankEnum:Int{
    
    case LoginEnum = 0      //登录,开发者可设置自定义登录界面，
    case OutRankViewEnum = 1 //退出排行榜界面
}

//协议
protocol OpenrankProtocol {
    //单例
//    static func shareInstance() -> OpenRankController
    
    //初始化sdk
    func initAppId(appId:String)
    
    //是否登录
    func isLogin()->Bool
    //登录
    func login(openId:String,appId:String,nickName:String,logo:String,block:(backbool:Bool)->Void)
    //显示排行榜
    func showRankFromScore(score:String,block:(ORenum:OpenRankEnum)->Void)
    
    //显示排行榜
    func showRankFromScoreToObjectC(score:String,block:(ORenum:Int)->Void)
}

@objc public class OpenRankController: NSObject,OpenrankProtocol {
    
    private var finishClosure:((finish: Bool, name:String ) -> ())?
    public var htmlViewBlock:((ORenum:OpenRankEnum)->Void)?
    public var appId:String?
    
    class var swiftSharedInstance: OpenRankController {
        struct Singleton {
            static let instance = OpenRankController()
        }
        return Singleton.instance
    }
    
    // the sharedInstance class method can be reached from ObjC
    public class func shareInstance() -> OpenRankController {
        return OpenRankController.swiftSharedInstance
    }
//    public static let shareInstacea = OpenRankController()
//    public class func shareInstance() -> OpenRankController {
////        struct WXSingleton{
////            static var predicate:dispatch_once_t = 0  //静态的线程安全
////            static var instance:OpenRankController? = nil //可选静态类
////        }
////        dispatch_once(&WXSingleton.predicate, {WXSingleton.instance = OpenRankController()})
////        return WXSingleton.instance!
//        return shareInstacea;
//    }
    
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
    
    func logout() {
        NSUserDefaults.standardUserDefaults().setValue("", forKey: OPENRANKUSERNAME)
        NSUserDefaults.standardUserDefaults().setValue("", forKey: OPENRANKUSERLOGO)
        NSUserDefaults.standardUserDefaults().setValue("", forKey: OPENRANKOPENID)
        NSUserDefaults.standardUserDefaults().setBool(false, forKey: OPENRANKISLOGIN)
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
        
        let url = "http://ios-spot.joyingmobi.com/v2/reqf?s=1,5,b6a4ba10dab728bf,fPoO,1,23g3yfPIuWH-kK48t0RPxgUFWRVbcB1ilHcOXnSRWt7DosbARTRxUWoboAOIIH6c4oB00X0eWY1NFuhkihDx20m1Hr-8XmnFckbtXKjLpH55khLflw-036DH9hRcbG7xoD7pc7PpEYm3XLJfdLCs3pkzWSXHBSWR.pwOjQn7oNfyR.jV8hB6ZYG5nNYK1leP4X0RFBh3cBWHPfTzT8iYhuWxmxSBKtikSHYKsHgmUoAZwf-up4jPaiGpNlqgnGYQFVc4v6HG.siOqPzzEEf6gGpyWOHhet8zk3oN9ar-ouk1HZoViOMTAgWZ5NVRe1v2W7Q5xaDF9WDYP3xb65yss6IZNMiRwejw1sr.tD74Lm5ZVX2RGISH8KtMAxOBGuIBo---K5zhJacMYqCODP52PR1u1myHPqhTY5ydNwJr1v.yg034NSiiiGTRyGCiSVKly4NTKmvf39YmrFq.xEbLiPu0QYZ.Qjus4R9tyg.TcH521Cly-qrvcg-hY.HbYQOhqRzxCwFg9QKvw0.UwwLhESp8EgEQ0HBqwZ4wcLJ2pOzQoV0Q-2xMcsR-Hb5VrYLrnIp2hi.xtVIMFs7bMGa-W3mqRn3ZkQZO6iDu.sGe0dRR40NQFC9T4asU1eKoynSr.c9SUYFb4atNObAy,"
        //"http://openrank.duapp.com/index.php?c=user&a=login&user_openid=\(openId)&app_id=\(appId)&score_score=\(0)&user_name=\(nickName)&user_logo=\(logo)"
        WxxLog.DEBUG("登录url:\(url)")
        
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
                
                
                NSNotificationCenter.defaultCenter().postNotificationName(kLOGINSUCCESSNOTIFACATION, object: nil)
                self.showRankFromScore("", block: { (ORenum) in
                    
                })
            }
            
        }
    }
    
    
    /**
     *  调用本方法在window上弹出在线排行榜
     *  参数：
     *      score       ->玩家的最新高分， 服务端会对本分数进行判断，如果低于旧分数不会更新
     *
     */
    public func showRankFromScore(score:String,block:(ORenum:OpenRankEnum)->Void){
        WxxLog.PRINT("开始请求分数排行榜");
        if let app = UIApplication.sharedApplication().delegate, let window = app.window!{
            
            htmlViewBlock = block
            
            let webVC = WxxWebViewController(score: score)
            
            let nav = UINavigationController(rootViewController: webVC)
            window.rootViewController?.presentViewController(nav, animated: true, completion: { 
                WxxLog.PRINT("排行榜界面")
            })
        }
        
    }
    
    
    public func showRankFromScoreToObjectC(score:String,block:(ORenum:Int)->Void){
        self.showRankFromScore(score, block: {(ORenum)->Void in
            block(ORenum: ORenum.rawValue)
        })
        
    }
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
}
