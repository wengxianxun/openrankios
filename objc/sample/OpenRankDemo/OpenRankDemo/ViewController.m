//
//  ViewController.m
//  OpenRankDemo
//
//  Created by linxiaolong on 16/4/22.
//  Copyright © 2016年 wengxianxun. All rights reserved.
//

#import "ViewController.h"
#import "SDkController.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(100, 200, 90, 40)];
    btn.backgroundColor = [UIColor blackColor];
    [btn setTitle:@"排行榜" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(showrank) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:btn];
    // Do any additional setup after loading the view, typically from a nib.
}


-(void)showrank{
    //上传最高分，显示排行榜
    [[SDkController shareInstance]showRankWithScore:@"66666"];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
