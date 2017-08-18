//
//  ViewController.m
//  spritetest
//

#import "ViewController.h"

 #import <MediaPlayer/MediaPlayer.h>
#import<AVFoundation/AVFoundation.h>
#define minWith 10
//typedef void (^DelayReturnPixelBuffer)(CVPixelBufferRef pixelBuffer);

@interface ViewController ()
@property (nonatomic, strong)NSMutableArray *array;
@property (nonatomic, strong)NSMutableArray *filterStreakArray;
@property (nonatomic, strong)UIView         *parentView;



@end

@implementation ViewController
-(BOOL)shouldAutorotate
{

    return NO;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    CGFloat rotation = 0.0;
    if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft) {
        rotation = -M_PI_2;
    }else {
        //        if (self.lastOrentation == UIInterfaceOrientationLandscapeLeft) {
        rotation = M_PI_2;
        //        }
    }
//    self.view.backgroundColor = [UIColor blackColor];
//    self.view.transform = CGAffineTransformMakeRotation(rotation);
//
//    _playerView1 = [[PlayerView1 alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.height, self.view.bounds.size.width)];
//    _playerView1.backgroundColor = [UIColor clearColor];
//    _playerView1.center  = CGPointMake(self.view.bounds.size.height/2, self.view.bounds.size.width/2);
//    [self.view addSubview:_playerView1];
//    _playerView2 = [[PlayerView1 alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.height/2, self.view.bounds.size.width)];
//    _playerView2.backgroundColor = [UIColor clearColor];
//    _playerView2.center  = CGPointMake(self.view.bounds.size.height*3/4, self.view.bounds.size.width/2);
//    [self.view addSubview:_playerView2];
//    self.glkVideoView = [[LTGLKView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.width)];
//    self.glkVideoView.center = self.view.center;
//    self.glkVideoView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//    self.glkVideoView.LTGLKViewDelegate = self;
//    [self.glkVideoView prepareGLKView];
//    [self.view addSubview: self.glkVideoView];
//    [self panoramaAddGLKViewGesture:self.view];
//    self.panoramaOrentation = [UIDevice currentDevice].orientation;
//    [self panoramaSetupGyroscope];
    
    self.parentView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.height, self.view.bounds.size.width)];
    [self.view addSubview:self.parentView];
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSString *moviePath = [bundle pathForResource:@"miss" ofType:@"mp4"];
    NSURL *movieURL = [NSURL fileURLWithPath:moviePath];
    NSURL *sourceMovieURL = [NSURL URLWithString:@"http://220.181.117.131/205/32/1/letv-uts/14/ver_00_22-1049007645-avc-199959-aac-32008-376880-11338499-5381f77093ddab5fa6b201d0ac6a86b3-1465270743147.m3u8?crypt=81aa7f2e214&b=240&nlh=4096&nlt=60&bf=72&p2p=1&video_type=mp4&termid=2&tss=ios&platid=3&splatid=341&its=0&qos=3&fcheck=0&mltag=4701&proxy=611247386,1778575169,1778917272&uid=1105892494&keyitem=GOw_33YJAAbXYE-cnQwpfLlv_b2zAkYctFVqe5bsXQpaGNn3T1-vhw..&ntm=1467870600&nkey=ce5416cb035d0ffb3083b18f7aef2b17&nkey2=c980c7a3d77a31273698c90143e88d76&geo=CN-1-9-666&appid=4000&cde=1023&cdeid=01aa64fd39ffb47a0de9c77a577dc0be&cdekey=fbb798ae6f858f0fd7e4cda355e7aabb&cdetm=1467859610&cvid=417001402798&dname=mobile&hwtype=iphone&iscpn=&key=955230a5962e6dd8ac61298c59ff0dbc&m3v=3&mmsid=58404825&ostype=macos&p1=0&p2=00&payff=0&pcode=010210000&pid=10022718&playid=0&sign=mb&tag=mobile&tm=1467859310&uinfo=AAAAAAAAAAB4lylV6ru-7PP5s04mvFNswabIFcmWgDSr7nIjBWEDfQ==&uuid=01563B05-AB6A-4880-9FB6-168DC34EAF89_1467859310658&version=6.7&vid=25697432&vtype=161&errc=0&gn=820&vrtmcd=102&buss=4701&cips=10.58.92.51"];
    
    AVAsset *movieAsset    = [AVURLAsset URLAssetWithURL:movieURL options:nil];
    AVPlayerItem *firstVideoItem = [AVPlayerItem playerItemWithURL:movieURL];
    self.queuePlayer = [AVQueuePlayer queuePlayerWithItems:[NSArray arrayWithObjects:firstVideoItem,nil]];
    AVPlayerLayer *layer = [AVPlayerLayer playerLayerWithPlayer:self.queuePlayer ];
    layer.player.actionAtItemEnd = AVPlayerItemStatusReadyToPlay;
    layer.frame = CGRectMake(0, 0, self.parentView.bounds.size.width, self.parentView.bounds.size.height);
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemDidPlayToEndTime:) name:AVPlayerItemDidPlayToEndTimeNotification object:firstVideoItem];
//    [player play];
    [self.parentView.layer addSublayer:layer];
    [self.queuePlayer play];
    
    self.glkVideoView = [LTGLKView ltGLKView:YES withFrame:self.parentView.bounds];
    self.glkVideoView.parameter.isDevide = NO;
    self.glkVideoView.center = self.parentView.center;
    self.glkVideoView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    self.glkVideoView.LTGLKViewDelegate = self;
    [self.glkVideoView prepareGLKView];
    self.glkVideoView.userInteractionEnabled = YES;
    [self.parentView addSubview: self.glkVideoView];
    [self panoramaAddGLKViewGesture:self.glkVideoView];

    if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive) {
        // fix bug: http://jira.letv.cn/browse/IPHONEHD-7765
        self.glkVideoView.parameter.isPause = YES;
    }
    [self panoramaSetupGyroscope];
    UIButton *vRbtn = [UIButton buttonWithType:UIButtonTypeCustom];
    vRbtn.frame =  CGRectMake(0, 24, 60, 40);
    vRbtn.backgroundColor = [UIColor redColor];
    vRbtn.layer.cornerRadius = 20;
    [vRbtn setTitle:@"VR" forState:UIControlStateNormal];
    [vRbtn setTitle:@"普通" forState:UIControlStateSelected];
    [vRbtn addTarget:self action:@selector(VRchange:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:vRbtn];
    
    self.parentView.transform = CGAffineTransformMakeRotation(M_PI/2);
    self.parentView.backgroundColor = [UIColor blueColor];
    self.parentView.frame =CGRectMake(0, 0, self.view.bounds.size.width,self.view.bounds.size.height) ;

 }
- (void)playerItemDidPlayToEndTime:(NSNotification *)notification{
    [self.queuePlayer seekToTime:CMTimeMake(0, 1)];
    [self.queuePlayer play];
}

- (void)VRchange:(UIButton *)sender{
    sender.selected= !sender.selected;
    self.glkVideoView.parameter.isDevide = sender.selected;

}
- (void) LTGLKViewGetPixelBuffer: (LTGLKView*) ltGLKView
{
    [self getPixelBuffer:YES
              withResult:^(CVPixelBufferRef pixelBuffer) {
                  [self.glkVideoView displayPixelBuffer: pixelBuffer];
              }];
}
- (void)getPixelBuffer:(BOOL) isPanorama withResult:(DelayReturnPixelBuffer) delayReturnPixelBuffer
{
    AVPlayerItem* currentItem = self.queuePlayer.currentItem;
    
    if (!currentItem) {
        NSLog(@"LTPlayerCore currentItem is nil");
        return;
    }
    float systemVersion = [[[UIDevice currentDevice] systemVersion] doubleValue];
    // iOS 8
    // videoOutput用了之后必须立即remove,否则退到后台再回来就没有视频画面了
    if (currentItem.outputs.count == 0 || !self.videoOutput) {
        NSDictionary* videoOutputOptions = @{ (id) kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_420YpCbCr8BiPlanarVideoRange) };
        self.videoOutput = [[AVPlayerItemVideoOutput alloc] initWithPixelBufferAttributes: videoOutputOptions];
        [currentItem addOutput: self.videoOutput];
        // 第一次addoutput,都要等1秒
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            CVPixelBufferRef buffer = 0;
            CMTime currentTime = [self.videoOutput itemTimeForHostTime: CACurrentMediaTime ()];
            if ([self.videoOutput hasNewPixelBufferForItemTime: currentTime]) {
                buffer = [self.videoOutput copyPixelBufferForItemTime: currentTime itemTimeForDisplay: NULL];
            }
            delayReturnPixelBuffer(buffer);
            if (systemVersion >= 8 && systemVersion < 9 && !isPanorama) {
                [currentItem removeOutput:self.videoOutput];
                self.videoOutput = nil;
            }
        });
    } else {
        
        CVPixelBufferRef buffer = 0;
        CMTime currentTime = [self.videoOutput itemTimeForHostTime: CACurrentMediaTime ()];
        if ([self.videoOutput hasNewPixelBufferForItemTime: currentTime]) {
            buffer = [self.videoOutput copyPixelBufferForItemTime: currentTime itemTimeForDisplay: NULL];
        }
        delayReturnPixelBuffer(buffer);
    }
}


- (void) LTGLKViewAdditionalMovement: (LTGLKView*) ltGLKView
{
    
}

- (CGRect)screenBoundsWithPortraitOrientation{
    UIScreen *screen = [UIScreen mainScreen];
    CGRect bounds =screen.bounds;
        if([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft || [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight){
            CGRect newBounds = bounds;
            newBounds.size.width =bounds.size.height;
            newBounds.size.height =bounds.size.width;
            return newBounds;
        }else{
            return bounds;
        }
   }

-(void)viewWillAppear:(BOOL)animated{
    [[NSNotificationCenter defaultCenter] removeObserver: self name: UIDeviceOrientationDidChangeNotification object: nil];
    [[NSNotificationCenter defaultCenter] addObserver: self
                                             selector: @selector (deviceOrientationDidChange:)
                                                 name: UIDeviceOrientationDidChangeNotification
                                               object: nil];
    [[UIDevice currentDevice] beginGeneratingDeviceOrientationNotifications];

}
- (BOOL)checkPanoramaDeviceOrientationStatus
{
    if ([UIDevice currentDevice].orientation != UIDeviceOrientationLandscapeLeft &&
        [UIDevice currentDevice].orientation != UIDeviceOrientationLandscapeRight) {
        return YES;
    }
    return NO;
}

// 处理屏幕转动
- (void)deviceOrientationDidChange:(NSNotification *)noti {
    NSLog(@"deviceOrientationDidChange : %@",self.class);
    if ([UIDevice currentDevice].orientation == UIDeviceOrientationUnknown || [UIDevice currentDevice].orientation == UIDeviceOrientationFaceUp || [UIDevice currentDevice].orientation == UIDeviceOrientationFaceDown) {
        return;
    }
    // 全景视频
    if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft ||
        [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight ||
        [UIDevice currentDevice].orientation == UIDeviceOrientationPortrait ||
        [UIDevice currentDevice].orientation == UIDeviceOrientationPortraitUpsideDown) {
        self.panoramaOrentation = [UIDevice currentDevice].orientation;
    }
//#warning 全景视频 禁用竖屏
//    if ([self checkPanoramaDeviceOrientationStatus]) {
//        return;
//    }
    CGFloat angle;

    UIInterfaceOrientation orientation;
    UIDeviceOrientation realOrientation;
    if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft) {
        orientation = UIInterfaceOrientationLandscapeRight;
        realOrientation = UIDeviceOrientationLandscapeLeft;
        angle = M_PI / 2;
    }else if ([UIDevice currentDevice].orientation == UIDeviceOrientationPortrait){
           angle =M_PI / 2;
    
    }else if ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight){
    
    }
    return;

    

}
- (void)panoramaSetupGyroscope
{
    if (self.panoramaMotionManager) {
        [self.panoramaMotionManager stopDeviceMotionUpdates];
        self.panoramaMotionManager = nil;
    }
    self.panoramaMotionManager = [[CMMotionManager alloc] init];
    if (self.isOpenGyroscope) {
        self.isOpenGyroscope = NO;
    } else {
        
        [self panoramaGyroscopeChoose];
        self.isOpenGyroscope = YES;
    }

}

- (void)panoramaGyroscopeChoose
{
       // LTGLKView *glkView = ((LTPanoramaPlayerCore *)self.player).glkVideoView;
    LTGLKView *glkView = self.glkVideoView;
    
    //    if (![glkView isKindOfClass:[LTGLKView class]]) {
    //        return;
    //    }
    // 开启或关闭了重力感应
    // 开启或关闭了重力感应
    if ([self.panoramaMotionManager isDeviceMotionAvailable]) {
        if (!self.panoramaMotionManager.isDeviceMotionActive) {
            glkView.parameter.prevTouchPoint = CGPointZero;
            
            // 这里用0.01的话 在iPhone 4上会卡,在高配机(6)上太灵活会在某一个方向卡住...不知为啥
            // 就用0.02吧
            float updateTime = 0.02f;
            self.panoramaMotionManager.deviceMotionUpdateInterval = updateTime;
            __weak typeof(self) weakSelf = self;
            NSOperationQueue *queue = [[NSOperationQueue alloc] init];
            [self.panoramaMotionManager startDeviceMotionUpdatesToQueue:queue
                                                            withHandler:^(CMDeviceMotion *motion, NSError *error) {
                                                                if (weakSelf.glkVideoView.parameter.isMoveModeActive) {
                                                                    return;
                                                                }
                                                                
                                                                float x = (motion.rotationRate.x * 5);
                                                                float y = (motion.rotationRate.y * 5);
                                                                float z = (motion.rotationRate.z * 3);
                                                                
                                                                if (weakSelf.panoramaOrentation == UIDeviceOrientationLandscapeRight) {
                                                                    x = -(motion.rotationRate.x * 5);
                                                                    y = (motion.rotationRate.y * 5);
                                                                } else if (weakSelf.panoramaOrentation == UIDeviceOrientationLandscapeLeft) {
                                                                    x = (motion.rotationRate.x * 5);
                                                                    y = -(motion.rotationRate.y * 5);
                                                                } else if (weakSelf.panoramaOrentation == UIDeviceOrientationPortrait
                                                                           || weakSelf.panoramaOrentation == UIDeviceOrientationPortraitUpsideDown) {
                                                                    // 竖屏
                                                                    return;
                                                                }
                                                                [weakSelf.glkVideoView.parameter moivePoint:x
                                                                                                               withY:y
                                                                                                               withZ:z
                                                                                                 withIsMoveByGesture:NO];
                                                            }];
        } else {
            [self.panoramaMotionManager stopDeviceMotionUpdates];
        }
    } else {
        [self showAlertNoGyroscopeAvaliable];
    }

}
- (void)showAlertNoGyroscopeAvaliable
{
    NSString *title = [[[NSBundle mainBundle] localizedInfoDictionary] objectForKey:@"CFBundleDisplayName"];
    [[[UIAlertView alloc] initWithTitle:title message:NSLocalizedString(@"当前设备不支持陀螺仪", @"") delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil] show];
}





- (void)panoramaAddGLKViewGesture:(UIView *)playControlView {
    
    for(int i=0; i<[playControlView.gestureRecognizers count]; i++) {
        UIGestureRecognizer *gesture = [playControlView.gestureRecognizers objectAtIndex:i];
        [playControlView removeGestureRecognizer:gesture];
    }
    
    UIPinchGestureRecognizer *pinch = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(panoramaPinchForZoom:)];
    pinch.delegate = self;
    [playControlView addGestureRecognizer:pinch];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(panoramaTapGesture)];
    tapGesture.delegate = self;
    [playControlView addGestureRecognizer:tapGesture];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panoramaPanGesture:)];
    panGesture.delegate = self;
    panGesture.maximumNumberOfTouches = 1;
    [playControlView addGestureRecognizer:panGesture];
}

#pragma mark - GestureActions

- (void)panoramaPinchForZoom:(UIPinchGestureRecognizer *)gesture
{
    LTGLKView *glkView = self.glkVideoView;
    if (gesture.state == UIGestureRecognizerStateBegan) {
        glkView.parameter.isZooming = YES;
        gesture.scale = glkView.parameter.zoomValue;
    } else if (gesture.state == UIGestureRecognizerStateChanged) {
        CGFloat zoom = gesture.scale;
        zoom = MAX(MIN(zoom, kMaximumZoomValue), kMinimumZoomValue);
        glkView.parameter.zoomValue = zoom;
    } else if (gesture.state == UIGestureRecognizerStateEnded) {
        glkView.parameter.isZooming = NO;
    }

}

- (void)panoramaTapGesture
{
//    [self.viewPlayControl forbidControlHiddenState:!self.viewPlayControl.controlIsHidden];
}

- (void)panoramaPanGesture:(UIPanGestureRecognizer *)panGesture
{
    LTGLKView *glkView = self.glkVideoView;

    
    CGPoint currentPoint = [panGesture locationInView:panGesture.view];
    switch (panGesture.state) {
        case UIGestureRecognizerStateEnded: {
            glkView.parameter.isMoveModeActive = NO;
            glkView.parameter.prevTouchPoint = CGPointZero;
            glkView.parameter.velocityValue = [panGesture velocityInView:panGesture.view];
            break;
        }
        case UIGestureRecognizerStateBegan: {
            glkView.parameter.isMoveModeActive = YES;
            glkView.parameter.prevTouchPoint = currentPoint;
            [self disableExtraMovement];
            break;
        }
        case UIGestureRecognizerStateChanged: {
            //            CGPoint point = [self calculateVerticesY:currentPoint];
            //            [self moveToPointX:point.x
            //                     andPointY:point.y];
            [glkView.parameter moivePoint:currentPoint.x
                                    withY:currentPoint.y
                                    withZ:0
                      withIsMoveByGesture:YES];
            //            glkView.parameter.prevTouchPoint = currentPoint;
            break;
        }
        default:
            break;
    }
}
/**
 *  手势触发的时候清空加速度
 */
- (void)disableExtraMovement
{
    LTGLKView *glkView = self.glkVideoView;
    glkView.parameter.velocityValue = CGPointZero;
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer {
    return YES;
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    //    NSLog(@" ................ touch.view:%@", touch.view);
    if ([touch.view isKindOfClass:[self.view class]]
        ) {
        [self disableExtraMovement];
        return YES;
    } else {
        return NO;
    }
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
    if ([gestureRecognizer isKindOfClass:[UIPanGestureRecognizer class]] && [otherGestureRecognizer isKindOfClass:[UITapGestureRecognizer class]]) {
        return YES;
    }
    return NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end