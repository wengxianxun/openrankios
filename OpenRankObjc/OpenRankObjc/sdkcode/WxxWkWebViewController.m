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

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self initwebView];
    [self loadHtmlRequest];
}

-(void)initwebView{
    self.config = [[WKWebViewConfiguration alloc]init];
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
    NSString *url = [NSString stringWithFormat:@"http://openrank.duapp.com/index.php?c=rank&a=ShowRankHtml&user_openid=\(%@!)&app_id=\(%@)&score_score=\(%@)",openId,appid,self.score];
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
        [self.view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[self.topLayoutGuide]-0-[progressView(2)]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(_progressView,self.topLayoutGuide)]];
    }
    _progressView.progress = newvalue.floatValue;
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
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
