//
//  SDkController.h
//  OpenRankObjc
//
//  Created by linxiaolong on 16/4/8.
//  Copyright © 2016年 wengxianxun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDkController : NSObject
+(SDkController *)shareInstance;
-(void)showRank;
-(void)qqlogin;
@end
