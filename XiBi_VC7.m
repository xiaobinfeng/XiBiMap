//
//  XiBi_VC7.m
//  XiBiMap
//
//  Created by mac on 2016/10/26.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "XiBi_VC7.h"
#define Title1 @"开始截屏(手指在屏幕滑动)"
#define Title2 @"截屏"

@interface XiBi_VC7 ()

@end

@implementation XiBi_VC7

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //配置用户key
    [MAMapServices sharedServices].apiKey = XBKey;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, self.view.bounds.size.width, 65);
    [button setTitle:Title1 forState:UIControlStateNormal];
    button.backgroundColor = [UIColor greenColor];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    //创建高德地图
    self.mapView = [[MAMapView alloc] initWithFrame:CGRectMake(0, 65, self.view.bounds.size.width, self.view.bounds.size.height-65)];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
    //初始化形状图层
    [self initShapeLayer];
    
    //添加pan手势
    UIPanGestureRecognizer *gesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panGesture:)];
    [self.view addGestureRecognizer:gesture];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //设置地图显示区域(比如：宜达互联公司地址)
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(22.534253,114.024642);
    MACoordinateSpan span = MACoordinateSpanMake(0.01, 0.01);
    [self.mapView setRegion:MACoordinateRegionMake(coord, span) animated:YES];
    
    //添加大头针
    self.annotation = [[MAPointAnnotation alloc] init];
    self.annotation.coordinate = coord;
    self.annotation.title = @"宜达互联";
    self.annotation.subtitle = @"泰然九路14号泰安轩A座1101室";
    [self.mapView addAnnotation:self.annotation];//添加大头针(此时会回调mapView:viewForAnnotation:方法)
}

//初始化形状图层
- (void)initShapeLayer
{
    self.shapeLayer = [[CAShapeLayer alloc] init];
    self.shapeLayer.lineWidth   = 2;
    self.shapeLayer.strokeColor = [UIColor redColor].CGColor;
    self.shapeLayer.fillColor   = [[UIColor grayColor] colorWithAlphaComponent:0.3f].CGColor;
    self.shapeLayer.lineDashPattern = [NSArray arrayWithObjects:[NSNumber numberWithInt:5],[NSNumber numberWithInt:5], nil];
    [self.view.layer addSublayer:self.shapeLayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonClicked:(UIButton*)btn
{
    if ([btn.currentTitle isEqualToString:Title1])
    {
        [btn setTitle:Title2 forState:UIControlStateNormal];
        self.screen = YES;
        self.mapView.scrollEnabled = NO;//禁止地图滚动
    }
    else
    {
        [btn setTitle:Title1 forState:UIControlStateNormal];
        self.screen = NO;
        self.mapView.scrollEnabled = YES;//禁止地图滚动
        [self screenShotImage];//地图截屏
    }
}

- (void)panGesture:(UIPanGestureRecognizer *)panGesture
{
    if (self.screen == YES)
    {
        static CGPoint startPoint;
        
        if (panGesture.state == UIGestureRecognizerStateBegan)
        {
            self.shapeLayer.path = NULL;
            
            startPoint = [panGesture locationInView:self.view];
        }
        else if (panGesture.state == UIGestureRecognizerStateChanged)
        {
            CGPoint currentPoint = [panGesture locationInView:self.view];
            
            //根据rect获取形状路径
            CGPathRef path = CGPathCreateWithRect(CGRectMake(startPoint.x, startPoint.y, currentPoint.x-startPoint.x,
                                                             currentPoint.y-startPoint.y), NULL);
            self.shapeLayer.path = path;
            
            CGPathRelease(path);
        }
    }
}

//地图截屏
- (void)screenShotImage
{
    if (self.shapeLayer.path == NULL)
    {
        return;
    }
    
    //根据形状路径获取rect
    CGRect inRect = [self.view convertRect:CGPathGetPathBoundingBox(self.shapeLayer.path)
                                    toView:self.mapView];
    UIImage *screenshotImage = [self.mapView takeSnapshotInRect:inRect];//截屏
    
    //保存到相册
    UIImageWriteToSavedPhotosAlbum(screenshotImage, self, @selector(image:didFinishSavingWithError:contextInfo:),nil);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    if (!error)
    {
        NSLog(@"success!!!");
    }
    else
    {
        NSLog(@"failed!!!");
    }
}

#pragma mark - MAMapViewDelegate
//根据anntation生成对应的View
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[MAPointAnnotation class]])
    {
        static NSString *indetifier = @"myIndetifier";
        MAPinAnnotationView *annotationView = (MAPinAnnotationView*)[mapView dequeueReusableAnnotationViewWithIdentifier:indetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:indetifier];
        }
        annotationView.canShowCallout = YES;//设置气泡可以弹出，默认为NO
        annotationView.animatesDrop = YES;//设置标注动画显示，默认为NO
        return annotationView;
    }
    
    return nil;
}

@end


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

