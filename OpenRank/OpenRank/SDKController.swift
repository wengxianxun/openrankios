//
//  SDKController.swift
//  OpenRank
//
//  Created by linxiaolong on 16/3/24.
//  Copyright © 2016年 wengxianxun. All rights reserved.
//

import UIKit


let APPID = "a1b516e2c4a282c3f281a30b5b9237bb"
class SDKController: NSObject {

    var score:String = "0"
    
    //单例
    class func shareInstance()->SDKController{
        
        struct YUSingleton{
            static var predicate:dispatch_once_t = 0  //静态的线程安全
            static var instance:SDKController? = nil //可选静态类
        }
        dispatch_once(&YUSingleton.predicate, {YUSingleton.instance = SDKController()})
        return YUSingleton.instance!
    }
    
    override init() {
        super.init()
        self.score = "66666666";
        //初始化
        OpenRankController.shareInstance().initAppId(APPID)
    }
    
    func showRank() {
        OpenRankController.shareInstance().showRankFromScore(self.score,block: {
            (ORenum)->Void in
            switch ORenum{
                case .LoginEnum:
                    //登录
                    //注：开发者可直接使用loginviewcontroller界面来作为登录界面，也可以自己实现登录界面，如果有嵌入sharesdk可以直接使用sharesdk
                    LoginViewController.showLoginVC()
                    break
                case .OutRankViewEnum:
                    //退出
                    break
            }
        })
    }
    
    func pushLoginVC(){
        
        
        
    }
    
    //登录
    func login(){
        
            let sdkcall = sdkCall.getinstance()
            //登录
            OpenRankController.shareInstance().login(sdkcall.oauth.openId, appId: APPID, nickName: sdkcall.nickname, logo: sdkcall.logo,block: {
                (backbool)->Void in
                //干嘛？
                if backbool {
                    print("block 返回值:\(backbool)")
                    //显示排行榜
                    //                OpenRankController.shareInstance().showRankFromScore(self.score)
                    
                }
                
            })
    }
    
    
    func qqlogin(){
        
        if !OpenRankController.shareInstance().isLogin()  {
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(SDKController.analysisResponse(_:)), name: kGetUserInfoResponse, object: sdkCall.getinstance())
            let premissions = [kOPEN_PERMISSION_GET_USER_INFO,
                               kOPEN_PERMISSION_GET_SIMPLE_USER_INFO,
                               kOPEN_PERMISSION_ADD_ALBUM,
                               kOPEN_PERMISSION_ADD_ONE_BLOG,
                               kOPEN_PERMISSION_ADD_SHARE,
                               kOPEN_PERMISSION_ADD_TOPIC,
                               kOPEN_PERMISSION_CHECK_PAGE_FANS,
                               kOPEN_PERMISSION_GET_INFO,
                               kOPEN_PERMISSION_GET_OTHER_INFO,
                               kOPEN_PERMISSION_LIST_ALBUM,
                               kOPEN_PERMISSION_UPLOAD_PIC,
                               kOPEN_PERMISSION_GET_VIP_INFO,
                               kOPEN_PERMISSION_GET_VIP_RICH_INFO];
            
            sdkCall.getinstance().oauth.authorize(premissions, inSafari: false)
        }else{
        }
    }
    
    func analysisResponse(notify:NSNotification) {
        NSNotificationCenter.defaultCenter().removeObserver(kGetUserInfoResponse)
        
        self.login()
    }
    
}
