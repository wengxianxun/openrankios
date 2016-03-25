//
//  SDKController.swift
//  OpenRank
//
//  Created by linxiaolong on 16/3/24.
//  Copyright © 2016年 wengxianxun. All rights reserved.
//

import UIKit


let APPID = "10000"
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
         
        if !OpenRankController.shareInstance().isLogin()  {
            
            NSNotificationCenter.defaultCenter().addObserver(self, selector: "analysisResponse:", name: kGetUserInfoResponse, object: sdkCall.getinstance())
            var premissions = [kOPEN_PERMISSION_GET_USER_INFO,
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
            //显示排行榜
            
        }
    }
    
    func analysisResponse(notify:NSNotification) {
        NSNotificationCenter.defaultCenter().removeObserver(kGetUserInfoResponse)
        
        var sdkcall = sdkCall.getinstance()
        
        //登录
        OpenRankController.shareInstance().login(sdkcall.oauth.openId, appId: APPID, nickName: sdkcall.nickname, logo: sdkcall.logo,block: {
            (backbool)->Void in
            //干嘛？
            if backbool {
                print("block 返回值:\(backbool)")
            }
            
        })
    }
    
}
