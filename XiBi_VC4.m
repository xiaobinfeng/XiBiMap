//
//  XiBi_VC4.m
//  XiBiMap
//
//  Created by mac on 2016/10/26.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "XiBi_VC4.h"

@interface XiBi_VC4 ()

@end

@implementation XiBi_VC4

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.



    
    //初始化检索对象
    self.search = [[AMapSearchAPI alloc] initWithSearchKey:XBKey Delegate:self];
    //构造AMapPlaceSearchRequest对象,配置关键字搜索参数
    AMapPlaceSearchRequest *poiRequest = [[AMapPlaceSearchRequest alloc] init];
    poiRequest.searchType = AMapSearchType_PlaceKeyword;
    poiRequest.keywords = @"俏江南";
    poiRequest.city = @[@"shenzhen"];
    poiRequest.requireExtension = NO;//是否返回扩展信息
    [self.search AMapPlaceSearch: poiRequest];//发起 POI 搜索
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
//实现 POI 搜索对应的回调函数
- (void)onPlaceSearchDone:(AMapPlaceSearchRequest *)request response:(AMapPlaceSearchResponse *)response
{
    if(response.pois.count == 0)
    {
        return;
    }
    
    //处理搜索结果
    NSString *strCount = [NSString stringWithFormat:@"个数: %ld",(long)response.count];
    NSString *strSuggestion = [NSString stringWithFormat:@"建议: %@", response.suggestion];
    NSMutableString *strPoi = [NSMutableString string];
    for (AMapPOI *p in response.pois)
    {
        [strPoi appendFormat:@"%@\n",p.description];
    }
    NSString *result = [NSString stringWithFormat:@"%@ \n%@ \n%@", strCount, strSuggestion, strPoi];
    NSLog(@"搜索的兴趣点如下\n%@", result);
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
