//
//  XiBi_VC4.h
//  XiBiMap
//
//  Created by mac on 2016/10/26.
//  Copyright © 2016年 mac. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AMapSearchKit/AMapSearchAPI.h>

@interface XiBi_VC4 : UIViewController<AMapSearchDelegate>

@property (nonatomic, strong) AMapSearchAPI *search;

@end
