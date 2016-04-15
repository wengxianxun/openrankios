//
//  OpenRankController.h
//  OpenRankObjc
//
//  Created by linxiaolong on 16/4/8.
//  Copyright © 2016年 wengxianxun. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    LoginEnum=0,////登录,开发者可设置自定义登录界面，
    OutRankViewEnum,////退出排行榜界面
} OpenRankEnum;

typedef void(^htmlblock)(OpenRankEnum orEnum);
@interface OpenRankController : NSObject
@property (nonatomic,copy)htmlblock htmlblock;
+(OpenRankController*)shareInstance;
-(NSString*)appId;
-(void)initAppId:(NSString *)appId;
-(void)showRankFromScore:(NSString *)score block:(void(^)(OpenRankEnum orenum))block;
-(void)loginFromOpenId:(NSString *)openId appId:(NSString *)appId logo:(NSString *)logo nickName:(NSString *)nickName block:(void(^)(BOOL backbool))block;
-(void)logout;
@end
