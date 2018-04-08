#### QQ粘性布局

**主要涉及技术点：**

- 1、UIPanGesture 
- 2、UIImageView 动画
- 3、CAShapeLayer 
- 4、UIBezierPath


```objc
@interface BageValueBtn()
@property (nonatomic ,weak)UIView *smallC;
@property (nonatomic ,weak) CAShapeLayer *shapL;
@end

@implementation BageValueBtn

-(CAShapeLayer *)shapL {
    if (_shapL == nil) {
        //形状图层(根据一个路径生成一个图层(形状))
        CAShapeLayer *shapL = [CAShapeLayer layer];
        shapL.fillColor = [UIColor redColor].CGColor;
        [self.superview.layer insertSublayer:shapL atIndex:0];
        _shapL = shapL;
    }
    return _shapL;
}


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
       //初始化
        [self setUp];
    }
    return self;
}

//初始化
- (void)setUp {
    
    //设置圆角
    self.layer.cornerRadius = self.bounds.size.width * 0.5;
    self.backgroundColor = [UIColor redColor];
    [self setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    //添加手势
    UIPanGestureRecognizer *pan = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(pan:)];
    [self addGestureRecognizer:pan];
    
    //添加小圆
    UIView *smallC = [[UIView alloc] init];
    smallC.frame = self.frame;
    smallC.backgroundColor = self.backgroundColor;
    smallC.layer.cornerRadius = self.layer.cornerRadius;
    //[self.superview addSubview:smallC];
    [self.superview insertSubview:smallC belowSubview:self];
    self.smallC = smallC;
    
}

- (void)pan:(UIPanGestureRecognizer *)pan {
    
    //获取偏移量
    CGPoint transP = [pan translationInView:self];
    
    //平移(frame,center,transform);
    //transform不会去修改center.
    //self.transform = CGAffineTransformTranslate(self.transform, transP.x, transP.y);
    CGPoint center = self.center;
    center.x += transP.x;
    center.y += transP.y;
    self.center = center;

    
    //求两个圆之间距离
    CGFloat distance = [self distanceWithSmall:self.smallC bigC:self];
    NSLog(@"%f",distance);
    
    //获取小圆的最原始的半径
    CGFloat smallR = self.bounds.size.width * 0.5;
    smallR = smallR - distance / 10.0;
    self.smallC.bounds = CGRectMake(0, 0, smallR * 2, smallR * 2);
    self.smallC.layer.cornerRadius = smallR;
    
    
    //根据两个圆描述一个不规则的路径
    if (self.smallC.hidden == NO) {
        UIBezierPath *path = [self pathWithSmallC:self.smallC bigC:self];
        self.shapL.path = path.CGPath;
    }
   
    if (distance > 70) {
        //隐藏小圆
        self.smallC.hidden = YES;
        [self.shapL removeFromSuperlayer];
    }
    //监听手指的状态
    if (pan.state == UIGestureRecognizerStateEnded) {
        //小于70,复位
        if(distance < 70) {
            [UIView animateWithDuration:0.3 delay:0 usingSpringWithDamping:0.2 initialSpringVelocity:0 options:UIViewAnimationOptionCurveLinear animations:^{
                self.smallC.hidden = NO;
                [self.shapL removeFromSuperlayer];
                self.center = self.smallC.center;
            } completion:nil];
        }else {
            //大于70,播放动画,消失
            //加载图片
            NSMutableArray *imageArray = [NSMutableArray array];
            for (int i = 0; i < 8;i++) {
                UIImage *image = [UIImage imageNamed:[NSString stringWithFormat:@"%d",i+1]];
                [imageArray addObject:image];
            }
            //添加imageView
            UIImageView *imageV = [[UIImageView alloc] init];
            imageV.frame = self.bounds;
            [self addSubview:imageV];
            
            imageV.animationImages = imageArray;
            imageV.animationDuration = 1;
            [imageV startAnimating];
            
            //动画执行完成时,让按钮消失
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self removeFromSuperview];
            });
            
        }
       
    }
    
    
    //复位
    [pan setTranslation:CGPointZero inView:self];
    
}

//求两个圆之间距离
- (CGFloat)distanceWithSmall:(UIView *)smallC bigC:(UIView *)bigC {
    
    //x轴方向的偏移量
    CGFloat offsetX = bigC.center.x - smallC.center.x;
    //y轴方向的偏移量
    CGFloat offsetY = bigC.center.y - smallC.center.y;
    return  sqrt(offsetX * offsetX + offsetY * offsetY);
}


//根据两个圆描述一个不规则的路径
- (UIBezierPath *)pathWithSmallC:(UIView *)smallC bigC:(UIView *)bigC {
    
    
    CGFloat x1 = smallC.center.x;
    CGFloat y1 = smallC.center.y;
    
    CGFloat x2 = bigC.center.x;
    CGFloat y2 = bigC.center.y;
    
    CGFloat d = [self distanceWithSmall:smallC bigC:bigC];
    if (d <= 0) {
        return nil;
    }
    
    CGFloat cosθ = (y2 - y1) / d;
    CGFloat sinθ = (x2 - x1) / d;
    
    CGFloat r1 = smallC.bounds.size.width * 0.5;
    CGFloat r2 = bigC.bounds.size.width * 0.5;
    
    CGPoint pointA = CGPointMake(x1 - r1 * cosθ, y1 + r1 * sinθ);
    CGPoint pointB = CGPointMake(x1 + r1 * cosθ, y1 - r1 * sinθ);
    CGPoint pointC = CGPointMake(x2 + r2 * cosθ, y2 - r2 * sinθ);
    CGPoint pointD = CGPointMake(x2 - r2 * cosθ, y2 + r2 * sinθ);
    CGPoint pointO = CGPointMake(pointA.x + d * 0.5 * sinθ, pointA.y + d * 0.5 * cosθ);
    CGPoint pointP = CGPointMake(pointB.x + d * 0.5 * sinθ, pointB.y + d * 0.5 * cosθ);
    
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    //连线
    //AB
    [path moveToPoint:pointA];
    [path addLineToPoint:pointB];
    //BC(曲线)
    [path addQuadCurveToPoint:pointC controlPoint:pointP];
    //CD
    [path addLineToPoint:pointD];
    //DA(曲线)
    [path addQuadCurveToPoint:pointA controlPoint:pointO];
    return path;
}


//取消高亮状态
- (void)setHighlighted:(BOOL)highlighted {

}
@end


```