####一、Core Animation 简介

- Core Animation 中文翻译为核心动画，他是一组非常强大的动画处理API， 使用它能做出非常绚丽的动画效果，而且往往事半功倍。

- core Animation 可以用在Mac OSX 和iOS 平台。

- Core Animation 的动画执行过程都是在后台操作的，不会阻塞主线程。
**要注意的是：**Core Animation 是直接作用在CALayer 上的，并非UIView。



#### 开发步骤：

1> 首先的有layer
2> 初始化一个CAAnimation 对象，并设置一些动画相关属性
3> 通过调用CALayer 的addAinmation:forKey:方法，增加CAAnimation对象d奥layer中，这样就能开始执行动画了。


#### 三、 CABasicAnimation

```objc
-(void)test{
 
    
    //1、创建动画
// CABasicAnimation 继承自 CAPropertyAnimation
    CABasicAnimation *basicAnima = [CABasicAnimation animation];
    
    //2、 设置动画属性
    basicAnima.keyPath = @"position.y";
    basicAnima.toValue = @(400);
    
    // 动画完成后会自动删除动画
    basicAnima.removedOnCompletion = NO;
    
    //动画完成时候保持什么状态
    basicAnima.fillMode = kCAFillModeForwards;
    
    // 添加动画
    [self.redView.layer addAnimation:basicAnima forKey:@"basicAnima"];
    
    
    
    //注意：直接修改  self.redView.layer.position  是没有动画的，因为  self.redView.layer 是RootLayer 跟层。
    // 只有自定义的layer 才会有隐士动画，UIView 的layer 必须使用 核心动画
   
    
}
```


####四、心跳效果

```objc
// 心跳效果
-(void)test2{
    
    // 1 创建动画
    CABasicAnimation *anim = [CABasicAnimation animation];
    
    //2、 设置属性
    anim.keyPath = @"transform.retation"; //表示的是 X Y 同时缩放
    anim.toValue = @(0);
    
    //3 设置动画执行的次数
    anim.repeatCount = HUGE;  //MAXFLOAT
    anim.duration = 0.5;
    
    //4 设置动画自动返回，怎么出来的怎么回去
    anim.autoreverses = YES;
    
    [self.redView.layer addAnimation:anim forKey:@"heartBit"];
    
    
}
```

####五、 帧动画

```objc

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    //可以根据路径做动画
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    
    anim.keyPath = @"transform.rotation";
    //进行多个值之间的动画
    anim.values = @[@(angleToRadio(-5)),@(angleToRadio(5)),@(angleToRadio(-5))];
    anim.repeatCount = MAXFLOAT;
    
    //anim.autoreverses = YES;

    anim.duration = 0.1;
    
    
    
    //添加动画
    [self.iconImageView.layer addAnimation:anim forKey:nil];
    
}
```



####六、 路径动画 --游泳的鱼

```objc
@interface ViewController ()

/** <#注释#>*/
@property (nonatomic ,weak) CALayer *fistLayer;

@property (strong, nonatomic)  NSMutableArray *imageArray;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    //设置背景
    self.view.layer.contents = (id)[UIImage imageNamed:@"bg"].CGImage;
    
    CALayer *fistLayer = [CALayer layer];
    fistLayer.frame = CGRectMake(100, 288, 89, 40);
    //fistLayer.backgroundColor = [UIColor redColor].CGColor;
    [self.view.layer addSublayer:fistLayer];
    self.fistLayer = fistLayer;
    
    //加载图片
    NSMutableArray *imageArray = [NSMutableArray array];
    for (int i = 0; i < 10; i++) {
       UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"fish%d",i]];
        [imageArray addObject:image];
    }
    self.imageArray = imageArray;
    //添加定时器
    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(update) userInfo:nil repeats:YES];
    
    
    
    //添加核心动画
    CAKeyframeAnimation *anim = [CAKeyframeAnimation animation];
    anim.keyPath = @"position";
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:CGPointMake(100, 288)];
    [path addLineToPoint:CGPointMake(100, 100)];
    [path addLineToPoint:CGPointMake(300, 100)];
    [path addQuadCurveToPoint:CGPointMake(300, 600) controlPoint:CGPointMake(400, 600)];
    [path addLineToPoint:CGPointMake(100, 288)];
    
    
    //设置路径
    anim.path = path.CGPath;
    anim.duration = 5.0;
    anim.repeatCount = HUGE;
    //根据路径,自动旋转
    anim.rotationMode = @"autoReverse";
    
    //设置时间计算模型
    anim.calculationMode = @"cubic";
    
    [self.fistLayer addAnimation:anim forKey:@"moveAnim"];

    
    
}

static int _imageIndex = 0;
- (void)update {
    
    //从数组当中取出图片
    UIImage *image = self.imageArray[_imageIndex];
    self.fistLayer.contents = (id)image.CGImage;
    _imageIndex++;
    if (_imageIndex > 9) {
        _imageIndex = 0;
    }
}




@end

```




