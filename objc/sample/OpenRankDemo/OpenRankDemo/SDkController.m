//
//  SDkController.m
//  OpenRankObjc
//
//  Created by linxiaolong on 16/4/8.
//  Copyright © 2016年 wengxianxun. All rights reserved.
//

#import "SDkController.h"
#import "AppDelegate.h"
#import <OpenRankKit/OpenRankKit.h>
#import "WxxLoginViewController.h"
#import <TencentOpenAPI/TencentApiInterface.h>
#import <TencentOpenAPI/TencentMessageObject.h>
#import "sdkCall.h"
#import "WeiboUser.h"
@interface SDkController()

@property (nonatomic,retain)NSString *score;
@end

#define appid @"a1b516e2c4a282c3f281a30b5b9237bb"
@implementation SDkController



+(SDkController*)shareInstance{
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

-(void)showRankWithScore:(NSString *)score{
    self.score = score;
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


//****************************************************//
//*****************         qq       ******************//
//****************************************************//
-(void)login{
    
    sdkCall *sdc = [sdkCall getinstance];
    //上传qq用户openid, logo, 昵称
    [[OpenRankController shareInstance]loginFromOpenId:sdc.oauth.openId appId:appid logo:sdc.logo nickName:sdc.nickname score:self.score block:^(BOOL backbool) {
        NSLog(@"登录成功");
    }];
}

//qq登录
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

//获取qq用户信息回调
- (void)analysisResponse:(NSNotification *)notify
{
    if (notify)
    {
        [[NSNotificationCenter defaultCenter]removeObserver:kGetUserInfoResponse];
        //执行openrank登录
        [self login];
    }
}

//****************************************************//
//*****************         weibo       ******************//
//****************************************************//
- (void)testRequestForUserProfile
{
    //    M2AppDelegate *myDelegate =(M2AppDelegate*)[[UIApplication sharedApplication] delegate];
    [WBHttpRequest requestForUserProfile:self.wbCurrentUserID withAccessToken:self.wbtoken andOtherProperties:nil queue:nil withCompletionHandler:^(WBHttpRequest *httpRequest, id result, NSError *error) {
        NSLog(@"%@",result);
        //        DemoRequestHanlder(httpRequest, result, error);
        WeiboUser *wuser = result;
        
        [[OpenRankController shareInstance]loginFromOpenId:wuser.userID appId:appid logo:wuser.avatarLargeUrl nickName:wuser.name score:self.score block:^(BOOL backbool) {
            NSLog(@"登录成功");
        }];
    }];
}

-(void)weibologin{
    WBAuthorizeRequest *request = [WBAuthorizeRequest request];
    request.redirectURI = kRedirectURI;
    request.scope = @"all";
    request.userInfo = @{@"SSO_From": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    [WeiboSDK sendRequest:request];
    
}

- (void)didReceiveWeiboRequest:(WBBaseRequest *)request
{
    
}

- (void)didReceiveWeiboResponse:(WBBaseResponse *)response
{
    if ([response isKindOfClass:WBSendMessageToWeiboResponse.class])
    {
        
    }
    else if ([response isKindOfClass:WBAuthorizeResponse.class])
    {
        
        
        [SDkController shareInstance].wbtoken  = [(WBAuthorizeResponse *)response accessToken];
        [SDkController shareInstance].wbCurrentUserID = [(WBAuthorizeResponse *)response userID];
        //        self.wbRefreshToken = [(WBAuthorizeResponse *)response refreshToken];
        [[SDkController shareInstance]testRequestForUserProfile];
    }
    else if ([response isKindOfClass:WBPaymentResponse.class])
    {
        
    }
    else if([response isKindOfClass:WBSDKAppRecommendResponse.class])
    {
        
    }else if([response isKindOfClass:WBShareMessageToContactResponse.class])
    {
        
        WBShareMessageToContactResponse* shareMessageToContactResponse = (WBShareMessageToContactResponse*)response;
        NSString* accessToken = [shareMessageToContactResponse.authResponse accessToken];
        
        NSString* userID = [shareMessageToContactResponse.authResponse userID];
        
    }
}
@end
