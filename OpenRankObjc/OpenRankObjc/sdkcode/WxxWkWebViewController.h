//
//  WxxWkWebViewController.h
//  OpenRankObjc
//
//  Created by linxiaolong on 16/4/11.
//  Copyright © 2016年 wengxianxun. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <WebKit/WebKit.h>
@interface WxxWkWebViewController : UIViewController<WKNavigationDelegate,WKUIDelegate>
@property (nonatomic,retain)WKWebView *wkwebview;
@end