//
//  WxxHttpRequest.swift
//  OpenRank
//
//  Created by linxiaolong on 16/3/24.
//  Copyright © 2016年 wengxianxun. All rights reserved.
//

import UIKit

class WxxHttpRequest: NSObject,NSURLConnectionDataDelegate {
    
    typealias blockF =  (back:AnyObject)->Void
    var blockFunc = blockF?()
    
    func saveScore(score:Int, userid:String) {
        let urlString:String = "http://www.baidu.com"
        var url:NSURL!
        url = NSURL(string: urlString)
        
        let request = NSMutableURLRequest(URL: url)
        let body = "score=\(score)&user=\(userid)"
        
        //编码post数据
        let postData = body.dataUsingEncoding(NSUTF8StringEncoding)
        //保用POST提交
        request.HTTPMethod = "POST"
        
        request.HTTPBody = postData
        
        //响应对象
        var respone:NSURLResponse?
        
        do{
            //发出请求
            let received:NSData? = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &respone)
            let datastring = NSString(data:received!, encoding: NSUTF8StringEncoding)
            print(datastring)
            
        }catch let error as NSError{
            //打印错误消息
            print(error.code)
            print(error.description)
        }
    }
    
    //同步get
    func requestGetFromSyn(urlString:String){
        
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        request.HTTPMethod = "GET"
        
        var respone:NSURLResponse?
        
        do{
            let received:NSData? = try NSURLConnection.sendSynchronousRequest(request, returningResponse: &respone)
            let dataString = NSString(data: received!, encoding: NSUTF8StringEncoding)
            print(dataString)
        }catch let error as NSError{
            //打印错误消息
            print(error.code)
            print(error.description)
        }
        
    }
    
    //异步get
    func requestGetFromAsyn(urlString:String,block:(back:AnyObject)->Void) {
        if blockFunc != nil{
            blockFunc = nil
        }
        blockFunc = block;
        let request = NSMutableURLRequest(URL: NSURL(string: urlString)!)
        request.HTTPMethod = "GET"
        var conn:NSURLConnection!
        conn = NSURLConnection(request: request,delegate: self)
        conn.start()
        print(conn)
    }
    
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        print("请求成功！");
        print(response) 
    }
    
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData)
    {
        print("返回成功！");
        let datastring = NSString(data:data, encoding: NSUTF8StringEncoding)
        print(datastring)
        //解析 JSON 数据
        do {
            let json : AnyObject! = try NSJSONSerialization.JSONObjectWithData(data,options:NSJSONReadingOptions.AllowFragments)
//            let score = json.objectForKey("score") as! Int
//            print(score)
            let result = json.objectForKey("result") as! String
//            if let result = json.objectForKey("result") as! Int {
//
//            }
            blockFunc!(back:json);
        }catch let error as NSError{
            //打印错误消息
            print(error.code)
            print(error.description)
        }
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection)
    {
        print("请求结束！");
    }
}
