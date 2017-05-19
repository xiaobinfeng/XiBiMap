//
//  XiBi_VC6.m
//  XiBiMap
//
//  Created by mac on 2016/10/26.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "XiBi_VC6.h"

@interface XiBi_VC6 ()

@end

@implementation XiBi_VC6

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.search = [[AMapSearchAPI alloc] initWithSearchKey:XBKey Delegate:self];//初始化搜索对象
    
    //构造AMapNavigationSearchRequest对象,配置查询参数
    AMapNavigationSearchRequest *naviRequest= [[AMapNavigationSearchRequest alloc] init];
    naviRequest.searchType = AMapSearchType_NaviDrive;//设置路径(步行，乘车)搜取
    naviRequest.strategy = 0;//驾车导航策略,0-速度优先(时间);1-费用优先;2-距离优先等
    naviRequest.requireExtension = NO;//是否返回扩展信息
    naviRequest.origin = [AMapGeoPoint locationWithLatitude:39.814319 longitude:116.147265];
    naviRequest.destination = [AMapGeoPoint locationWithLatitude:39.990459 longitude:116.481476];
    [self.search AMapNavigationSearch:naviRequest];//发起路径搜索
    
    //创建高德地图
    [MAMapServices sharedServices].apiKey = XBKey;//配置用户key
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];//初始化地图对象
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
 #pragma mark - Navigation
 
 // In a storyboard-based application, you will often want to do a little preparation before navigation
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
 // Pass the selected object to the new view controller.
 }
 */

//在地图上画线
- (void)showLines
{
    [self addAnnotation];//添加起始点和目标点的大头针
    [self drawMapLine];//在起始点和目标点之间画折线
}

//添加起始点和目标点的大头针
- (void)addAnnotation
{
    //添加起始点大头针
    NSString *origin = [self.lines firstObject];
    NSArray *ary1 = [origin componentsSeparatedByString:@","];
    CLLocationDegrees latitude = [[ary1 lastObject] floatValue];
    CLLocationDegrees longitude = [[ary1 firstObject] floatValue];
    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    annotation.title = @"起始位置";
    annotation.subtitle = @"详细的起始位置";
    [self.mapView addAnnotation:annotation];//添加大头针
    
    //添加目标点大头针
    NSString *destination = [self.lines lastObject];
    NSArray *ary2 = [destination componentsSeparatedByString:@","];
    latitude = [[ary2 lastObject] floatValue];
    longitude = [[ary2 firstObject] floatValue];
    annotation = [[MAPointAnnotation alloc] init];
    annotation.coordinate = CLLocationCoordinate2DMake(latitude, longitude);
    annotation.title = @"目标位置";
    annotation.subtitle = @"详细的目标位置";
    [self.mapView addAnnotation:annotation];//添加大头针
}

//在起始点和目标点之间画折线
- (void)drawMapLine
{
    if (self.lines && [self.lines count])
    {
        NSUInteger count = [self.lines count];
        CLLocationCoordinate2D polylineCoords[count];
        
        for (int i = 0; i < count; i++)
        {
            NSString *line = [self.lines objectAtIndex:i];
            NSArray *ary = [line componentsSeparatedByString:@","];
            CLLocationDegrees latitude = [[ary lastObject] floatValue];
            CLLocationDegrees longitude = [[ary firstObject] floatValue];
            polylineCoords[i].latitude = latitude;
            polylineCoords[i].longitude = longitude;
        }
        
        MAPolyline *polyline = [MAPolyline polylineWithCoordinates:polylineCoords count:count];//构造折线对象
        [self.mapView addOverlay:polyline];//在地图上添加折线对象
        self.mapView.visibleMapRect = polyline.boundingMapRect;//显示画线区域
    }
}

#pragma mark - AMapSearchDelegate
//实现路径搜索的回调函数
- (void)onNavigationSearchDone:(AMapNavigationSearchRequest*)request response:(AMapNavigationSearchResponse *)response
{
    if(response.route != nil)
    {
        //获取起始点和目标点间所有子路径经纬度
        NSArray *ary = response.route.paths;
        if (ary && [ary count])
        {
            self.lines = [NSMutableArray array];
            for (AMapPath *path in ary)
            {
                for (AMapStep *step in path.steps)
                {
                    NSString *polyline = step.polyline;//此路段坐标点字符串(包括的经纬度信息)
                    NSArray *stepLines = [polyline componentsSeparatedByString:@";"];
                    
                    [self.lines addObjectsFromArray:stepLines];
                }
            }
            
            //添加起始点和目标点
            AMapGeoPoint *origin = response.route.origin;//起始点位置(包括经度，纬度)
            [self.lines insertObject:[NSString stringWithFormat:@"%f,%f", origin.longitude, origin.latitude]
                             atIndex:0];
            AMapGeoPoint *destination = response.route.destination;//目标点位置(包括经度，纬度)
            [self.lines insertObject:[NSString stringWithFormat:@"%f,%f", destination.longitude, destination.latitude]
                             atIndex:[self.lines count]];
            
            [self showLines];//在地图上画线
        }
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

//根据overlay生成对应的View
- (MAOverlayView *)mapView:(MAMapView *)mapView viewForOverlay:(id <MAOverlay>)overlay
{
    //返回折线图层
    if ([overlay isKindOfClass:[MAPolyline class]])
    {
        MAPolylineView *polylineView = [[MAPolylineView alloc] initWithPolyline:overlay];
        polylineView.lineWidth = 5.0;
        polylineView.strokeColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.6];
        polylineView.lineJoinType = kMALineJoinRound;//连接类型
        polylineView.lineCapType = kMALineCapRound;//端点类型
        return polylineView;
    }
    
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
