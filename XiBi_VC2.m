//
//  XiBi_VC2.m
//  XiBiMap
//
//  Created by mac on 2016/10/26.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "XiBi_VC2.h"

@interface XiBi_VC2 ()

@end

@implementation XiBi_VC2

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //配置用户key
    [MAMapServices sharedServices].apiKey = XBKey;
    
    //创建高德地图
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
    
    //地图画折线
#if 0
    //构造折线数据对象
    CLLocationCoordinate2D commonPolylineCoords[4];
    
    commonPolylineCoords[0].latitude = 39.832136;
    commonPolylineCoords[0].longitude = 116.34095;
    
    commonPolylineCoords[1].latitude = 39.832136;
    commonPolylineCoords[1].longitude = 116.42095;
    
    commonPolylineCoords[2].latitude = 39.902136;
    commonPolylineCoords[2].longitude = 116.42095;
    
    commonPolylineCoords[3].latitude = 39.902136;
    commonPolylineCoords[3].longitude = 116.44095;
    
    //构造折线对象
    MAPolyline *commonPolyline = [MAPolyline polylineWithCoordinates:commonPolylineCoords count:4];
    [self.mapView addOverlay:commonPolyline];//在地图上添加折线对象
#endif
    
    //地图上画多边形
#if 1
    //构造多边形数据对象
    CLLocationCoordinate2D coordinates[4];
    
    coordinates[0].latitude = 39.810892;
    coordinates[0].longitude = 116.233413;
    
    coordinates[1].latitude = 39.816600;
    coordinates[1].longitude = 116.331842;
    
    coordinates[2].latitude = 39.762187;
    coordinates[2].longitude = 116.357932;
    
    coordinates[3].latitude = 39.733653;
    coordinates[3].longitude = 116.278255;
    
    MAPolygon *polygon = [MAPolygon polygonWithCoordinates:coordinates count:4];
    [self.mapView addOverlay: polygon];//在地图上添加折线对象
#endif
    
    //地图上画圆
#if 1
    //构造圆
    MACircle *circle = [MACircle circleWithCenterCoordinate:CLLocationCoordinate2DMake(39.952136, 116.50095) radius:5000];
    [self.mapView addOverlay: circle];//在地图上添加圆
#endif
    
    //地图上画大地曲线
#if 0
    CLLocationCoordinate2D geodesicCoords[2];
    
    geodesicCoords[0].latitude = 39.905151;
    geodesicCoords[0].longitude = 116.401726;
    
    geodesicCoords[1].latitude = 38.905151;
    geodesicCoords[1].longitude = 70.401726;
    
    MAGeodesicPolyline *geodesicPolyline = [MAGeodesicPolyline polylineWithCoordinates:geodesicCoords count:2];
    [self.mapView addOverlay:geodesicPolyline];//构造大地曲线对象
#endif
    
    //地图上贴图片覆盖物
#if 0
    MACoordinateBounds coordinateBounds = MACoordinateBoundsMake(CLLocationCoordinate2DMake(39.939577, 116.388331), CLLocationCoordinate2DMake(39.935029, 116.384377));
    MAGroundOverlay *groundOverlay = [MAGroundOverlay groundOverlayWithBounds:coordinateBounds icon:[UIImage imageNamed:@"GWF"]];
    [self.mapView addOverlay:groundOverlay];
    self.mapView.visibleMapRect = groundOverlay.boundingMapRect;
#endif
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
   
}



#pragma mark - MAMapViewDelegate
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
    
    //返回多边形图层
    if ([overlay isKindOfClass:[MAPolygon class]])
    {
        MAPolygonView *polygonView = [[MAPolygonView alloc] initWithPolygon:overlay];
        polygonView.lineWidth = 3.0;
        polygonView.strokeColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.8];
        polygonView.fillColor = [UIColor colorWithRed:0.77 green:0.88 blue:0.94 alpha:0.8];
        polygonView.lineJoinType = kMALineJoinMiter;//连接类型
        return polygonView;
    }
    
    //返回圆形图层
    if ([overlay isKindOfClass:[MACircle class]])
    {
        MACircleView *circleView = [[MACircleView alloc] initWithCircle:overlay];
        circleView.lineWidth = 5.0;
        circleView.strokeColor = [UIColor colorWithRed:0.6 green:0.6 blue:0.6 alpha:0.8];
        circleView.fillColor = [UIColor colorWithRed:1.0 green:0.8 blue:0.0 alpha:0.8];
        circleView.lineDash = YES;
        return circleView;
    }
    
    //返回大地曲线
    if ([overlay isKindOfClass:[MAGeodesicPolyline class]])
    {
        MAPolylineView *polylineView = [[MAPolylineView alloc] initWithPolyline:overlay];
        polylineView.lineWidth = 8.0;
        polylineView.strokeColor = [UIColor colorWithRed:0 green:0 blue:1 alpha:0.8];
        return polylineView;
    }
    
    //返回图片覆盖物对象
    if ([overlay isKindOfClass:[MAGroundOverlay class]])
    {
        MAGroundOverlayView *groundOverlayView = [[MAGroundOverlayView alloc] initWithGroundOverlay:overlay];
        return groundOverlayView;
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
