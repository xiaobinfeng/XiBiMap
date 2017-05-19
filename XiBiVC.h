//
//  XiBiVC.h
//  XiBiMap
//
//  Created by mac on 2016/10/26.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MAMapKit/MAMapKit.h>
#import "XiBi_CustomAnnotation.h"
#import "XiBi_CustomAnnotationView.h"

@interface XiBiVC : UIViewController<MAMapViewDelegate,XiBi_CustomAnnotationViewDelegate>

@property (nonatomic, strong) MAMapView *mapView;//高德地图对象
@property (nonatomic, strong) XiBi_CustomAnnotation *customAnnotation;//自定义大头针
@property (nonatomic, strong) XiBi_MapEntity *entity;//实体对象，用于自定义大头针视图内容显示



@end
