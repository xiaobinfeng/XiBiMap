//
//  XiBi_VC9.h
//  XiBiMap
//
//  Created by mac on 2016/10/26.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AMapSearchKit/AMapSearchAPI.h>

@interface XiBi_VC9 : UIViewController<AMapSearchDelegate>

@property (nonatomic, strong) AMapSearchAPI *search;//高德搜索对象


@end
