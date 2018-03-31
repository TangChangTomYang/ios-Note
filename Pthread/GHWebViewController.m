//
//  GHWebViewController.m
//  Pthread
//
//  Created by yangrui on 2018/3/24.
//  Copyright © 2018年 yangrui. All rights reserved.
//

#import "GHWebViewController.h"
#import <WebKit/WebKit.h>
// web 地址
//asdfasdfa.we.asdf.a.a
@interface GHWebViewController ()


@property(nonatomic, strong)WKWebView *webView;
@end

@implementation GHWebViewController
    

-(WKWebView *)webView{

    if(!_webView){
        _webView = [[WKWebView alloc]initWithFrame:self.view.bounds];
        [self.view addSubview:_webView];
    }
    return _webView;
}


-(void)setWebName:(NSString *)webName{
    _webName = [webName copy];
    self.navigationItem.title = webName;
    NSString *path = [[NSBundle mainBundle] pathForResource:webName ofType:@"webarchive"];
    [self.webView loadRequest: [NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
}
- (void)viewDidLoad {
    [super viewDidLoad];

}



@end
