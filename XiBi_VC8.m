//
//  XiBi_VC8.m
//  XiBiMap
//
//  Created by mac on 2016/10/26.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "XiBi_VC8.h"

@interface XiBi_VC8 ()

@end

@implementation XiBi_VC8

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //正向地理编码
#if 1
    self.search = [[AMapSearchAPI alloc] initWithSearchKey:XBKey Delegate:self]; //初始化搜索对象
    
    //构造AMapGeocodeSearchRequest对象, address为必选项, city为可选项
    AMapGeocodeSearchRequest *geoRequest = [[AMapGeocodeSearchRequest alloc] init];
    geoRequest.searchType = AMapSearchType_Geocode;//正向
    geoRequest.address = @"泰安轩A座";//地址(必选项)
    geoRequest.city = @[@"shenzhen"];//城市(可选项)
    [self.search AMapGeocodeSearch:geoRequest]; //发起正向地理编码
#else
    //逆地理编码
    self.search = [[AMapSearchAPI alloc] initWithSearchKey:ApiKey Delegate:self];//初始化搜索对象
    
    //构造AMapReGeocodeSearchRequest对象,location为必选项,radius为可选项
    AMapReGeocodeSearchRequest *regeoRequest = [[AMapReGeocodeSearchRequest alloc] init];
    regeoRequest.searchType = AMapSearchType_ReGeocode;//逆向
    regeoRequest.location = [AMapGeoPoint locationWithLatitude:22.534191 longitude:114.024867];//中心点坐标(必选项)
    regeoRequest.radius = 10000;// 查询半径(可选项)，单位：米
    regeoRequest.requireExtension = NO;//是否返回扩展信息(可选项)，默认为 NO
    [self.search AMapReGoecodeSearch: regeoRequest];//发起逆地理编码
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
//实现正向地理编码的回调函数
- (void)onGeocodeSearchDone:(AMapGeocodeSearchRequest*)request response:(AMapGeocodeSearchResponse *)response
{
    if(response.geocodes.count == 0)
    {
        return;
    }
    
    //处理搜索结果
    NSMutableString *strGeocodes = [NSMutableString string];
    for (AMapGeocode *p in response.geocodes)
    {
        /**
         @property (nonatomic, strong) NSString *formattedAddress; // 格式化地址
         @property (nonatomic, strong) NSString *province; // 所在省
         @property (nonatomic, strong) NSString *city; // 城市名
         @property (nonatomic, strong) NSString *district; // 区域名称
         @property (nonatomic, strong) NSString *township; // 所在乡镇
         @property (nonatomic, strong) NSString *neighborhood; // 社区
         @property (nonatomic, strong) NSString *building; // 楼
         @property (nonatomic, strong) NSString *adcode; // 区域编码
         @property (nonatomic, strong) AMapGeoPoint *location; // 坐标点
         @property (nonatomic, strong) NSArray *level; // 匹配的等级 NSString 数组
         */
        [strGeocodes appendFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@\n", p.formattedAddress, p.province,p.city,p.district,p.township,p.neighborhood,p.building,p.adcode,p.location];
    }
    
    NSString *result = [NSString stringWithFormat:@"\n地址个数:%ld\n地址信息:%@", (long)response.count, strGeocodes];
    NSLog(@"%@", result);
}

//实现逆地理编码的回调函数
- (void)onReGeocodeSearchDone:(AMapReGeocodeSearchRequest *)request response:(AMapReGeocodeSearchResponse *)response
{
    if(response.regeocode != nil)
    {
        /**
         @property (nonatomic, strong) NSString *province; // 省
         @property (nonatomic, strong) NSString *city; // 市
         @property (nonatomic, strong) NSString *district; // 区
         @property (nonatomic, strong) NSString *township; // 乡镇
         @property (nonatomic, strong) NSString *neighborhood; // 社区
         @property (nonatomic, strong) NSString *building; // 建筑
         @property (nonatomic, strong) NSString *citycode; // 城市编码
         @property (nonatomic, strong) NSString *adcode; // 区域编码
         @property (nonatomic, strong) AMapStreetNumber *streetNumber; // 门牌信息
         */
        
        //处理搜索结果
        NSMutableString *strGeocodes = [NSMutableString string];
        AMapReGeocode *p = response.regeocode;
        [strGeocodes appendFormat:@"%@,%@,%@,%@,%@,%@,%@,%@,%@\n", p.formattedAddress,p.addressComponent.province,p.addressComponent.city,p.addressComponent.district,p.addressComponent.township,p.addressComponent.neighborhood,p.addressComponent.building,p.addressComponent.citycode,p.addressComponent.adcode];
        NSString *result = [NSString stringWithFormat:@"地址信息:%@", strGeocodes];
        NSLog(@"%@", result);
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
