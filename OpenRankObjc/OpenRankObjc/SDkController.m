//
//  SDkController.m
//  OpenRankObjc
//
//  Created by linxiaolong on 16/4/8.
//  Copyright © 2016年 wengxianxun. All rights reserved.
//

#import "SDkController.h"
#import "OpenRankController.h"
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
    [[OpenRankController shareInstance]showRankFromScore:self.score block:^(int orenum) {
        
    }];
}

@end
