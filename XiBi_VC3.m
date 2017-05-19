//
//  XiBi_VC3.m
//  XiBiMap
//
//  Created by mac on 2016/10/26.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "XiBi_VC3.h"

@interface XiBi_VC3 ()

@end

@implementation XiBi_VC3

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    //配置用户key
    [MAMapServices sharedServices].apiKey = XBKey;
    
    //创建高德地图
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //系统定位图层
#if 0
    /*
     定位图层有 3 种显示模式,分别为:
     MAUserTrackingModeNone:不跟随用户位置,仅在地图上显示。
     MAUserTrackingModeFollow:跟随用户位置移动,并将定位点设置成地图中心点
     MAUserTrackingModeFollowWithHeading:跟随用户的位置和角度移动
     */
    [self.mapView setUserTrackingMode:MAUserTrackingModeFollowWithHeading animated:YES];//跟随用户的位置和角度移动
#else
    //自定义定位图层
    self.mapView.customizeUserLocationAccuracyCircleRepresentation = YES;//设置自定义定位经度圈样式属性设置为YES
    self.mapView.userTrackingMode = MAUserTrackingModeFollowWithHeading;//跟随用户的位置和角度移动
#endif
    
    self.mapView.showsUserLocation = YES;//显示当前位置
}

#pragma mark - MAMapViewDelegate
//位置或者设备方向更新后，会调用此函数
- (void)mapView:(MAMapView *)mapView didUpdateUserLocation:(MAUserLocation *)userLocation updatingLocation:(BOOL)updatingLocation
{
    CLLocationCoordinate2D coord = userLocation.location.coordinate;
    MACoordinateSpan span = MACoordinateSpanMake(0.003, 0.003);
    [self.mapView setRegion:MACoordinateRegionMake(coord, span) animated:YES];
}

//定位失败后，会调用此函数
- (void)mapView:(MAMapView *)mapView didFailToLocateUserWithError:(NSError *)error
{
    NSLog(@"%@", error.description);
}

//根据overlay生成对应的View
- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id <MAOverlay>)overlay
{
    /* 自定义定位精度对应的 MACircleView. */
    if (overlay == mapView.userLocationAccuracyCircle)
    {
        MACircleView *accuracyCircleView = [[MACircleView alloc] initWithCircle:overlay];
        accuracyCircleView.lineWidth = 2.0;
        accuracyCircleView.strokeColor = [UIColor lightGrayColor];
        accuracyCircleView.fillColor = [UIColor colorWithRed:1 green:0 blue:0 alpha:.3];
        return accuracyCircleView;
    }
    
    return nil;
}

//根据anntation生成对应的View
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
#if 0
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
#else
    /* 自定义 userLocation 对应的 annotationView. */
    if ([annotation isKindOfClass:[MAUserLocation class]])
    {
        static NSString *userIndetifier = @"userIndetifier";
        MAAnnotationView *annotationView = [mapView dequeueReusableAnnotationViewWithIdentifier:userIndetifier];
        if (annotationView == nil)
        {
            annotationView = [[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:userIndetifier];
        }
        annotationView.image = [UIImage imageNamed:@"大头针"];
        return annotationView;
    }
#endif
    
    return nil;
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
