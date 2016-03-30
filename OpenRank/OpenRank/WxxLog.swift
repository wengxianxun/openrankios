//
//  WxxLog.swift
//  OpenRank
//
//  Created by linxiaolong on 16/3/30.
//  Copyright © 2016年 wengxianxun. All rights reserved.
//

import UIKit

class WxxLog {
    
    class func DEBUG(message:String, function:String = #function){
//        首先在Build Settings中找到 Swift Compliler-Custom Flags,并添加以下参数 -DDEBUG参数
        #if DEBUG
            print("DEBUG: \(function) : \(message)")
        #endif
    }
    
    
    class func PRINT(message:String, function:String = #function){
        //print 级别不显示\(function)
        print("PRINT:  \(message)")
        
    }
}
