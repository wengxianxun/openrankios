//
//  SDkController.m
//  OpenRankObjc
//
//  Created by linxiaolong on 16/4/8.
//  Copyright © 2016年 wengxianxun. All rights reserved.
//

#import "SDkController.h"
#import "OpenRankController.h"
#import "WxxLoginViewController.h"
#import <TencentOpenAPI/TencentApiInterface.h>
#import <TencentOpenAPI/TencentMessageObject.h>
#import "sdkCall.h"
@interface SDkController()

@property (nonatomic,retain)NSString *score;
@end

#define appid @"a1b516e2c4a282c3f281a30b5b9237bb"
@implementation SDkController



+(id)shareInstance{
    static SDkController *openrankcontroller = nil;
    static dispatch_once_t oncetoken;
    dispatch_once(&oncetoken, ^{
        openrankcontroller = [SDkController new];
    });
    return openrankcontroller;
}

-(id)init{
    self = [super init];
    if (self) {
        self.score = @"0";
        [[OpenRankController shareInstance]initAppId:appid];
    }
    return self;
}

-(void)showRank{
    [[OpenRankController shareInstance]showRankFromScore:self.score block:^(OpenRankEnum orenum) {
        NSLog(@"%d",orenum);
        switch (orenum) {
            case LoginEnum:
                [WxxLoginViewController showLoginVC];
                break;
            case OutRankViewEnum:
                
                break;
            default:
                break;
        }
    }];
}

-(void)login{
    
    sdkCall *sdc = [sdkCall getinstance];
    [[OpenRankController shareInstance]loginFromOpenId:sdc.oauth.openId appId:appid logo:sdc.logo nickName:sdc.nickname block:^(BOOL backbool) {
        NSLog(@"登录陈宫");
    }];
}

-(void)qqlogin{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(analysisResponse:) name:kGetUserInfoResponse object:[sdkCall getinstance]];
    NSArray* permissions = [NSArray arrayWithObjects:
                            kOPEN_PERMISSION_GET_USER_INFO,
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
                            kOPEN_PERMISSION_GET_VIP_RICH_INFO,
                            nil];
    
    [[[sdkCall getinstance] oauth] authorize:permissions inSafari:NO];
}
- (void)analysisResponse:(NSNotification *)notify
{
    if (notify)
    {
        [[NSNotificationCenter defaultCenter]removeObserver:kGetUserInfoResponse];
        [self login];
    }
}
@end
