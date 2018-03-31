//
//  ViewController.m
//  Pthread
//
//  Created by yangrui on 2018/3/22.
//  Copyright © 2018年 yangrui. All rights reserved.
//

#import "ViewController.h"
#import "GHWebViewController.h"
@interface ViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic, strong)NSArray *webNames;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@end

@implementation ViewController

-(NSArray *)webNames{
    
    if (!_webNames) {
        _webNames = @[@"01_pthread_NSThread_GCD",
                      @"02_GCD_NSOperation_SDWebImage",
                      @"03_NSCache_runloop",
                      @"04d_网络基础_NSURLConnection_NSURLSession",
                      @"05_JSON解析_XML解析_NSURLSessionDownloadTask_文件压缩和解压缩",
                      @"06_NSURLSession文件上传_AFN",
                      @"07_数据安全_数字签名_HTTPS"];
    }
    return _webNames;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.navigationController.automaticallyAdjustsScrollViewInsets = NO;
    
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    return self.webNames.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *ID = @"abc";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
    }
    cell.textLabel.text = self.webNames[indexPath.row];
    return cell;
}


-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    [self performSegueWithIdentifier:@"webView" sender:@(indexPath.row)];
}
-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    GHWebViewController *webVC = (GHWebViewController *)segue.destinationViewController;
   
    webVC.webName =  self.webNames[ [((NSNumber *)sender)integerValue] ];
}

@end
