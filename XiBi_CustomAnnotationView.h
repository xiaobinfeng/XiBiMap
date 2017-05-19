//
//  XiBi_CustomAnnotationView.h
//  XiBiMap
//
//  Created by mac on 2016/10/26.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <MAMapKit/MAMapKit.h>
#import "XiBi_MapEntity.h"

@class XiBi_CustomAnnotationView;

@protocol XiBi_CustomAnnotationViewDelegate <NSObject>
@optional
- (void)customAnnotationClicked:(XiBi_CustomAnnotationView*)view;

@end

@interface XiBi_CustomAnnotationView : MAAnnotationView
@property (weak) id <XiBi_CustomAnnotationViewDelegate> delegate;
@property (nonatomic, strong)  NSDictionary *infoDic;

/**
 @功能：初始化一个地图注释图
 @参数：大头针 可重用标识 frame 信息实体(用于设置注释图信息)
 @返回值：self
 */
- (id)initWithAnnotation:(id<MAAnnotation>)annotation
         reuseIdentifier:(NSString *)reuseIdentifier
                   frame:(CGRect)rect
                    info:(XiBi_MapEntity*)aEntity;

@end
