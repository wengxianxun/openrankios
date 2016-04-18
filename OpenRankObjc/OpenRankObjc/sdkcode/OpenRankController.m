//
//  OpenRankController.m
//  OpenRankObjc
//
//  Created by linxiaolong on 16/4/8.
//  Copyright © 2016年 wengxianxun. All rights reserved.
//

#import "OpenRankController.h"
#import "ORConfig.h"
#import "WxxURLRequest.h"
#import "WxxWkWebViewController.h"


@interface OpenRankController()

@property (nonatomic,retain)NSString *appId;

@end

@implementation OpenRankController

+(OpenRankController*)shareInstance{
    static OpenRankController *openrankcontroller = nil;
    static dispatch_once_t oncetoken;
    dispatch_once(&oncetoken, ^{
        openrankcontroller = [OpenRankController new];
    });
    return openrankcontroller;
}
 
-(NSString*)appId{
    return _appId;
}
-(void)initAppId:(NSString *)appId{
    self.appId = appId;
}

-(BOOL)isLogin{
    return [[NSUserDefaults standardUserDefaults] boolForKey:OPENRANKISLOGIN];
}

-(void)logout{
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:OPENRANKUSERLOGO];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:OPENRANKOPENID];
    [[NSUserDefaults standardUserDefaults] setObject:@"" forKey:OPENRANKUSERNAME];
    [[NSUserDefaults standardUserDefaults] setBool:NO forKey:OPENRANKISLOGIN];
}


-(void)loginFromOpenId:(NSString *)openId appId:(NSString *)appId logo:(NSString *)logo nickName:(NSString *)nickName block:(void(^)(BOOL backbool))block{
    
    NSString *url = [NSString stringWithFormat:@"http://openrank.duapp.com/index.php?c=user&a=login&user_openid=%@&app_id=%@&score_score=%@&user_name=%@&user_logo=%@",openId,appId,@"0",nickName,logo];
    NSLog(@"%@",url);
    WxxURLRequest *request = [WxxURLRequest hnRrequestWithURL:[NSURL URLWithString:url]];
    [request URLRequestAsynchronouslyWithCompletionUsingBlock:^(BOOL finished, WxxURLRequest *request) {
        
        NSError *error = nil;
        NSDictionary *jsonDic = [NSJSONSerialization JSONObjectWithData:request.data options:NSJSONReadingAllowFragments error:&error];
        NSString *result = [jsonDic objectForKey:@"result"];
        if ([result isEqualToString:@"1"]) {
            [[NSUserDefaults standardUserDefaults]setValue:nickName forKey:OPENRANKUSERNAME];
            [[NSUserDefaults standardUserDefaults]setValue:logo forKey:OPENRANKUSERLOGO];
            [[NSUserDefaults standardUserDefaults]setValue:openId forKey:OPENRANKOPENID];
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:OPENRANKISLOGIN];
            block(YES);
            
            [[NSNotificationCenter defaultCenter]postNotificationName:kLOGINSUCCESSNOTIFACATION object:nil];
            
            [self showRankFromScore:@"" block:^(OpenRankEnum orenum) {
                
            }];
        }
        
        NSLog(@"返回结果");
    }];
}

-(void)showRankFromScore:(NSString *)score block:(void(^)(OpenRankEnum orenum))block{
    if (self.htmlblock) {
        self.htmlblock = nil;
    }
    self.htmlblock = block;
    
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    WxxWkWebViewController *wkvc = [[WxxWkWebViewController alloc]init:score];
    UINavigationController *nv = [[UINavigationController alloc]initWithRootViewController:wkvc];
    [window.rootViewController presentViewController:nv animated:YES completion:^{
        
    }];
}

@end
