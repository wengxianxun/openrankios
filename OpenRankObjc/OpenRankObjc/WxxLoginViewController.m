//
//  WxxLoginViewController.m
//  OpenRankObjc
//
//  Created by linxiaolong on 16/4/14.
//  Copyright © 2016年 wengxianxun. All rights reserved.
//

#import "WxxLoginViewController.h"
#import "SDkController.h"
@interface WxxLoginViewController ()
@property (nonatomic,retain)UITableView *tableView;
@property (nonatomic,retain)NSArray *arr;
@end

@implementation WxxLoginViewController

+(void)showLoginVC{
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    WxxLoginViewController *wkvc = [[WxxLoginViewController alloc]init];
    UINavigationController *nv = [[UINavigationController alloc]initWithRootViewController:wkvc];
    [window.rootViewController presentViewController:nv animated:YES completion:^{
        
    }];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.arr = [NSArray arrayWithObjects:@{@"title":@"qq登录",@"logo":@"sns_icon_24.png"}, nil];
    // Do any additional setup after loading the view.
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(closeSelf)];
    self.navigationItem.leftBarButtonItem = left;
    
    self.tableView = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
}

-(void)closeSelf{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}

-(void)qqlogin{
    [[SDkController shareInstance]qqlogin];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arr.count;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
    }
    NSDictionary *dic = [self.arr objectAtIndex:indexPath.row];
    cell.textLabel.text = [dic objectForKey:@"title"];
    cell.imageView.image = [UIImage imageNamed:[dic objectForKey:@"logo"]];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [self qqlogin];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
