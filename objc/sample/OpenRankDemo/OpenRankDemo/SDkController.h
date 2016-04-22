//
//  SDkController.h
//  OpenRankObjc
//
//  Created by linxiaolong on 16/4/8.
//  Copyright © 2016年 wengxianxun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDkController : NSObject<WeiboSDKDelegate>{
    NSString* wbtoken;
    NSString* wbCurrentUserID;
}
@property (strong, nonatomic) NSString *wbtoken;
@property (strong, nonatomic) NSString *wbRefreshToken;
@property (strong, nonatomic) NSString *wbCurrentUserID;

- (void)testRequestForUserProfile;
+(SDkController*)shareInstance;
-(void)showRankWithScore:(NSString *)score;
-(void)qqlogin;
-(void)weibologin;
@end
