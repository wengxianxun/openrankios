//
//  WxxWkWebViewController.m
//  OpenRankObjc
//
//  Created by linxiaolong on 16/4/11.
//  Copyright © 2016年 wengxianxun. All rights reserved.
//

#import "WxxWkWebViewController.h"
#import "ORConfig.h"
#import "OpenRankController.h"
@interface WxxWkWebViewController ()
@property (nonatomic,retain)WKWebViewConfiguration *config;
@property (nonatomic,retain)NSString *score;
@property (nonatomic,retain)UIProgressView *progressView;
@end

@implementation WxxWkWebViewController

-(id)init:(NSString *)score{
    
    self = [super init];
    if (self) {
        self.score = score;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UIBarButtonItem *left = [[UIBarButtonItem alloc]initWithTitle:@"返回" style:UIBarButtonItemStyleDone target:self action:@selector(closeSelf)];
    self.navigationItem.leftBarButtonItem = left;
    
    [self initwebView];
    [self loadHtmlRequest];
}

-(void)initwebView{
    self.config = [[WKWebViewConfiguration alloc]init];
    [self.config.userContentController addScriptMessageHandler:self name:@"webViewApp"];
    self.wkwebview = [[WKWebView alloc]initWithFrame:self.view.frame configuration:self.config];
    self.wkwebview.navigationDelegate = self;
    self.wkwebview.UIDelegate = self;
    [self.view addSubview:self.wkwebview];
}
-(void)loadHtmlRequest{
    if (self.wkwebview == nil) {
        return;
    }
    NSString *openId = [[NSUserDefaults standardUserDefaults]valueForKey:OPENRANKOPENID];
    NSString *appid = [[OpenRankController shareInstance] appId];
    NSString *url = [NSString stringWithFormat:@"http://openrank.duapp.com/index.php?c=rank&a=ShowRankHtml&user_openid=\%@&app_id=\%@&score_score=\%@",openId,appid,self.score];
    NSLog(@"%@",url);
    [self.wkwebview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:url]]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




-(void)viewWillAppear:(BOOL)animated{
    [self.wkwebview addObserver:self forKeyPath:@"estimatedProgress" options:NSKeyValueObservingOptionNew context:nil];
}
-(void)viewWillDisappear:(BOOL)animated{
    [self.wkwebview removeObserver:self forKeyPath:@"estimatedProgress"];
}

-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context{
    if ([keyPath isEqualToString:@"estimatedProgress"]) {
        
        [self progressChange:change];
    }
    
}

-(void)progressChange:(NSNumber*)newvalue{
    if (_progressView==nil) {
        self.progressView = [[UIProgressView alloc]init];
        _progressView.translatesAutoresizingMaskIntoConstraints = false;
        [self.view addSubview:_progressView];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[_progressView]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_progressView)]];
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[topLayoutGuide]-0-[progressView(2)]" options:0 metrics:nil views:@{@"progressView":_progressView,@"topLayoutGuide":self.topLayoutGuide}]];
    }
    [self.progressView setProgress:self.wkwebview.estimatedProgress animated:YES];
    if (_progressView.progress == 1) {
        _progressView.progress = 0;
        [UIView animateWithDuration:0.2 animations:^{
            self.progressView.alpha = 0;
        }];
    }else if (_progressView.alpha == 0){
        
        [UIView animateWithDuration:0.2 animations:^{
            self.progressView.alpha = 1;
        }];
    }
}

-(void)login{
    [self closeSelf];
    [OpenRankController shareInstance].htmlblock(LoginEnum);
}
-(void)logout{
    [[OpenRankController shareInstance]logout];
    [self rightBtn:@"登录" action:@selector(login)];
    
}
-(void)closeSelf{
    [self dismissViewControllerAnimated:YES completion:^{
        
    }];
}
-(void)rightBtn:(NSString *)tile action:(SEL)select{
    
    UIBarButtonItem *right = [[UIBarButtonItem alloc]initWithTitle:tile style:UIBarButtonItemStyleDone target:self action:select];
    self.navigationItem.rightBarButtonItem = right;
}
-(void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message{
    
    NSDictionary *dic = message.body;
    NSString *jsfunc = [dic objectForKey:@"jsfunc"];
    
    if ([jsfunc isEqualToString:@"nologin"]) {
        [self rightBtn:@"登录" action:@selector(login)];
    }else if ([jsfunc isEqualToString:@"islogin"]){
        [self rightBtn:@"退出登录" action:@selector(logout)];
    }
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
