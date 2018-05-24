#### 应用程序的启动与keywindow的加载原理

```objc

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //1.创建窗口
    self.window = [[UIWindow alloc] init];
    self.window.backgroundColor = [UIColor blueColor];
    
    //2.设置窗口的根控制器 (每一个UIWindow都必须得要有一个根控制器.rootViewController.)
    UIViewController *vc = [[UIViewController alloc] init];
    vc.view.backgroundColor = [UIColor redColor];
    
    self.window.rootViewController = vc;
    //NSLog(@"%@",[UIApplication sharedApplication].keyWindow);
    //NSLog(@"%@",self.window);
    
    //3.显示窗口
    [self.window makeKeyAndVisible];
    //NSLog(@"%@",self.window);
    //NSLog(@"%@",[UIApplication sharedApplication].keyWindow);
    //self.window.hidden = NO;
    
    /*
     makeKeyAndVisible:
     1.设置当前窗口为应用程序的主窗口, 
       [UIApplication sharedApplication].keyWindow = self.window;
     2.显示窗口
       self.window.hidden = NO;
       把窗口的根控制器添加到窗口上面.
       [self.window addSubview:self.window.rootViewController.view];
     
     */
     
    return YES;
}

```