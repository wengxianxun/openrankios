//
//  ViewController.m
//  OpenRankObjc
//
//  Created by linxiaolong on 16/4/8.
//  Copyright © 2016年 wengxianxun. All rights reserved.
//

#import "ViewController.h"
#import "SDkController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view, typically from a nib.
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 100, 90, 40)];
    btn.backgroundColor = [UIColor blackColor];
    [btn addTarget:self action:@selector(showrank) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
}

-(void)showrank{
    [[SDkController shareInstance]showRank];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
