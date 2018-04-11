####GPUImage 美颜相机

- GPUImageStillCamera 用于拍色当前手机的画面，但是通常不会用实时视频的录制（使用另外一个），主要用户拍摄某一个画面，并保存（显示）图片。
- GPUImageStillCamera -> GPUImageFilter ->GPUImageView 这样，摄像机转到View 上显示出来。


```objc
// 可以理解为设备
GPUImageStillCamera *imageCamera
// filter 滤镜
GPUImageFilter *filter 
// 显示出来的View
GPUImageView *view 
```

- SessionPreset参数设置

![](/assets/sessionPreset.png)


```objc

#import "YRMeiYanViewController.h"

#import "GPUImage.h"
 #import "GPUImageSketchFilter.h" //素描
@interface YRMeiYanViewController ()
/** 相机  */
@property(nonatomic, strong)GPUImageStillCamera *stillCamera ;

/** 亮度 滤镜*/
@property(nonatomic, strong)GPUImageBrightnessFilter *brightnessFilter;

/**预览视图*/
@property(nonatomic, strong)GPUImageView *cameraView;


@property (weak, nonatomic) IBOutlet UIView *preViewContainer;


@end

@implementation YRMeiYanViewController

-(GPUImageStillCamera *)stillCamera{
    
    if (!_stillCamera) {
        // 创建相机
        _stillCamera = [[GPUImageStillCamera alloc]initWithSessionPreset:AVCaptureSessionPresetMedium
                                                          cameraPosition:AVCaptureDevicePositionFront];;
        // 设置相机的方向
        _stillCamera.outputImageOrientation = UIInterfaceOrientationPortrait;
    }
    return _stillCamera;
}

-(GPUImageBrightnessFilter *)brightnessFilter{
    
    if (!_brightnessFilter) {
        _brightnessFilter = [GPUImageBrightnessFilter new];
        // 亮度 0 ~ 1.0
        _brightnessFilter.brightness = 0.3;
    }
    return _brightnessFilter;
}


-(void)viewDidLoad{
    
    [super viewDidLoad];
    [self setupMeiYanCamera];
}



-(void)setupMeiYanCamera{
    
   // 创建相机
    [self stillCamera];
    // 设置滤镜 和参数
    [self brightnessFilter];
    
    
    // 相机添加滤镜
    [self.stillCamera addTarget:self.brightnessFilter];


    // 创建显示画面的View
    self.cameraView =  [[GPUImageView alloc] initWithFrame:self.preViewContainer.bounds];
    self.cameraView.layer.borderColor = [UIColor redColor].CGColor;
    self.cameraView.layer.borderWidth = 2.0;
    [self.preViewContainer insertSubview:self.cameraView atIndex:0];
    
    //滤镜添加 预览图层
    [self.brightnessFilter addTarget:self.cameraView];    
}




- (IBAction)startBtnClick:(id)sender {
//    [self.stillCamera startCameraCapture];
    self.cameraView.layer.borderColor = [UIColor greenColor].CGColor;
    self.cameraView.layer.borderWidth = 2.0;
    [self.stillCamera startCameraCapture];
}
- (IBAction)rotateBtnClick:(id)sender {
     [self.stillCamera rotateCamera];
}
- (IBAction)stopBtnClick:(id)sender {
    [self.stillCamera capturePhotoAsImageProcessedUpToFilter:self.brightnessFilter withCompletionHandler:^(UIImage *processedImage, NSError *error) {
        
        UIImageWriteToSavedPhotosAlbum(processedImage, nil, nil, nil);
        
        [self.stillCamera stopCameraCapture];
        
    }];
}

@end

```