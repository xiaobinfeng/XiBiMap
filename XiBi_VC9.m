//
//  XiBi_VC9.m
//  XiBiMap
//
//  Created by mac on 2016/10/26.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "XiBi_VC9.h"

@interface XiBi_VC9 ()

@end

@implementation XiBi_VC9

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //公交站查询
#if 1
    self.search = [[AMapSearchAPI alloc] initWithSearchKey:XBKey Delegate:self]; //初始化搜索对象
    
    //构造AMapBusStopSearchRequest对象
    AMapBusStopSearchRequest *stopRequest = [[AMapBusStopSearchRequest alloc] init];
    stopRequest.keywords = @"车公庙";//查询关键字(必选项)，多个关键字用“|”分割
    stopRequest.city = @[@"shenzhen"];//城市(可选项)
    [self.search AMapBusStopSearch:stopRequest];//发起公交站查询
#endif
    
#if 0
    //公交线路查询
    self.search = [[AMapSearchAPI alloc] initWithSearchKey:ApiKey Delegate:self];//初始化搜索对象
    
    //构造AMapBusLineSearchRequest对象
    AMapBusLineSearchRequest *lineRequest = [[AMapBusLineSearchRequest alloc] init];
    lineRequest.keywords = @"113";//查询关键字(必选项)，多个关键字用“|”分割
    lineRequest.city = @[@"shenzhen"];//城市(可选项)
    lineRequest.requireExtension = YES;
    [self.search AMapBusLineSearch:lineRequest];//发起公交线路查询
#endif
    
#if 0
    //输入提示搜索
    self.search = [[AMapSearchAPI alloc] initWithSearchKey:ApiKey Delegate:self];//初始化搜索对象
    
    //构造AMapInputTipsSearchRequest对象,keywords为必选项,city为可选项
    AMapInputTipsSearchRequest *tipsRequest= [[AMapInputTipsSearchRequest alloc] init];
    tipsRequest.searchType = AMapSearchType_InputTips;//设置为输入提示
    tipsRequest.keywords = @"车公";
    tipsRequest.city = @[@"shenzhen"];
    [self.search AMapInputTipsSearch: tipsRequest];//发起输入提示搜索
#endif
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
//实现公交站查询的回调函数
-(void)onBusStopSearchDone:(AMapBusStopSearchRequest*)request response:(AMapBusStopSearchResponse *)response
{
    if(response.busstops.count == 0)
    {
        return;
    }
    
    //处理查询结果
    NSMutableString *strStop = [NSMutableString string];
    for (AMapBusStop *p in response.busstops)
    {
        [strStop appendFormat:@"公交:%@\n", p.description];
    }
    
    NSLog(@"公交站:\n公交站数量:%ld\n%@", (long)response.count, strStop);
}

//实现公交线路查询的回调函数
-(void)onBusLineSearchDone:(AMapBusLineSearchRequest*)request response:(AMapBusLineSearchResponse *)response
{
    if(response.buslines.count == 0)
    {
        return;
    }
    
    //处理查询结果
    NSMutableString *strLine = [NSMutableString string];
    for (AMapBusLine *p in response.buslines)
    {
        [strLine appendFormat:@"公交线路：%@\n", p.description];
    }
    
    NSString *result = [NSString stringWithFormat:@"公交线路数量：%ld\n%@", (long)response.count, strLine];
    NSLog(@"%@", result);
}

//实现输入提示的回调函数
-(void)onInputTipsSearchDone:(AMapInputTipsSearchRequest*)request response:(AMapInputTipsSearchResponse *)response
{
    if(response.tips.count == 0)
    {
        return;
    }
    
    //处理搜索结果
    NSMutableString *strtips = [NSMutableString string];
    for (AMapTip *p in response.tips)
    {
        [strtips appendFormat:@"%@", p.description];
    }
    
    NSString *result = [NSString stringWithFormat:@"提示总个数：%ld\n提示信息：%@", (long)response.count, strtips];
    NSLog(@"%@", result);
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
