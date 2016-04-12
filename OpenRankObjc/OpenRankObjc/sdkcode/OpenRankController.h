//
//  OpenRankController.h
//  OpenRankObjc
//
//  Created by linxiaolong on 16/4/8.
//  Copyright © 2016年 wengxianxun. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface OpenRankController : NSObject
+(id)shareInstance;
-(NSString*)appId;
-(void)initAppId:(NSString *)appId;
-(void)showRankFromScore:(NSString *)score block:(void(^)(int orenum))block;
@end
