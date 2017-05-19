//
//  XiBi_VC6.h
//  XiBiMap
//
//  Created by mac on 2016/10/26.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AMapSearchKit/AMapSearchAPI.h>
#import <MAMapKit/MAMapKit.h>

@interface XiBi_VC6 : UIViewController<AMapSearchDelegate, MAMapViewDelegate>

@property (nonatomic, strong) AMapSearchAPI *search;//高德搜索对象
@property (nonatomic, strong) NSMutableArray *lines;
@property (nonatomic, strong) MAMapView *mapView;//高德地图对象


@end
