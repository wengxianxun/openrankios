//
//  AppDelegate.m
//  OpenRankDemo
//
//  Created by linxiaolong on 16/4/22.
//  Copyright © 2016年 wengxianxun. All rights reserved.
//

#import "AppDelegate.h"
#import "SDkController.h"
@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    [WeiboSDK enableDebugMode:YES];
    [WeiboSDK registerApp:kAppKey];
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    //    if ([sourceApplication isEqualToString:@"com.sina.weibo"]) {
    //        return [WeiboSDK handleOpenURL:url delegate:self];
    //    }else{
    //        return [TencentOAuth HandleOpenURL:url];
    //    }
    NSString *string =[url absoluteString];
    
    if ([string hasPrefix:@"wb"])
    {
        return [WeiboSDK handleOpenURL:url delegate:[SDkController shareInstance]];
    }
    else if ([string hasPrefix:@"qq"] || [string hasPrefix:@"tencent"])
    {
        return [TencentOAuth HandleOpenURL:url];
    }else{
        return YES;
    }
    //
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url
{
    //    return [WeiboSDK handleOpenURL:url delegate:self];
    NSString *string =[url absoluteString];
    
    if ([string hasPrefix:@"微博url的前缀"])
    {
        return [WeiboSDK handleOpenURL:url delegate:self];
    }
    else if ([string hasPrefix:@"Facebook的url的前缀"])
    {
        return [TencentOAuth HandleOpenURL:url];
    }else{
        return YES;
    }
    //
}

@end
