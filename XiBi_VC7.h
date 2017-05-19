//
//  XiBi_VC7.h
//  XiBiMap
//
//  Created by mac on 2016/10/26.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import <QuartzCore/QuartzCore.h>

@interface XiBi_VC7 : UIViewController<MAMapViewDelegate>

@property (nonatomic) BOOL screen;//是否开始截图
@property (nonatomic, strong) CAShapeLayer *shapeLayer;

@property (nonatomic, strong) MAMapView *mapView;//高德地图对象
@property (nonatomic, strong) MAPointAnnotation *annotation;//大头针对象


@end
