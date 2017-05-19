//
//  XiBi_VC5.m
//  XiBiMap
//
//  Created by mac on 2016/10/26.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "XiBi_VC5.h"

@interface XiBi_VC5 ()

@end

@implementation XiBi_VC5

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //初始化检索对象
    self.search = [[AMapSearchAPI alloc] initWithSearchKey:XBKey Delegate:self];
    
    //构造AMapNavigationSearchRequest对象,配置查询参数
    AMapNavigationSearchRequest *naviRequest= [[AMapNavigationSearchRequest alloc] init];
    naviRequest.searchType = AMapSearchType_NaviDrive;//设置路径搜取
    naviRequest.requireExtension = NO;//是否返回扩展信息
    naviRequest.origin = [AMapGeoPoint locationWithLatitude:39.994949 longitude:116.447265];
    naviRequest.destination = [AMapGeoPoint locationWithLatitude:39.990459 longitude:116.481476];
    [self.search AMapNavigationSearch: naviRequest];//发起路径搜索
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

#pragma mark - AMapSearchDelegate
//实现路径搜索的回调函数
- (void)onNavigationSearchDone:(AMapNavigationSearchRequest*)request response:(AMapNavigationSearchResponse *)response
{
    if(response.route != nil)
    {
        //处理搜索结果
        NSString *route = [NSString stringWithFormat:@"导航路线\n%@", response.route];
        NSLog(@"%@", route);
    }
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
