####一、设置应用消息数量

```objc
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    // 1. 注册通知
    NSInteger setTypes = UIUserNotificationTypeBadge |  UIUserNotificationTypeSound |  UIUserNotificationTypeAlert;
    UIUserNotificationSettings *notiSettings = [UIUserNotificationSettings settingsForTypes: setTypes
                                      categories:nil];
    [application registerUserNotificationSettings:notiSettings];
    
    
    // 2. 设置应用图标 
    application.applicationIconBadgeNumber = 11;
    return YES;
}
```



####二、设置联网的状态状态栏上的小菊花)

```objc
-（void）test{
    [UIApplication sharedApplication].networkActivityIndicatorVisible =  YES ;
}
```



####三、设置状栏的样式
 **从 ios 7 开始，系统提供了2种方式管理状态栏**
 - 1> 通过UIViewController 管理（每个UIViewController 都可以拥有自己不同的状态栏）
 - 2> 通过UIApplication 管理（一个应用的状态栏都是由他统一管理）
 
 方式一，在对应控制器中重写下面两个方法即可
     ```objc
    控制状态栏显示的样式 
    -(UIStatusBarStyle)preferredStatusBarStyle{
    
        return UIStatusBarStyleLightContent;
    }

    控制状态栏是否显示
    -(BOOL)prefersStatusBarHidden{
        return YES;
    }
     ```
     
 方式二， 在适当的调用调用方法即可，如下：
     ```objc
    通过 UIApplication 来控制状态栏，这种方式，需在在info.plist 中配置
     View controller-based status bar appearance = NO，表示禁用控制器控制状态栏
    
    -(void)changeStatusBarStyle{
    
        [UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
        [UIApplication sharedApplication].statusBarHidden = YES;
    }
 
     ```














