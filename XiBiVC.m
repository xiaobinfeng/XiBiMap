//
//  XiBiVC.m
//  XiBiMap
//
//  Created by mac on 2016/10/26.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "XiBiVC.h"

@interface XiBiVC ()

@end

@implementation XiBiVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //配置用户key
    [MAMapServices sharedServices].apiKey = XBKey;
    
    //创建高德地图
    self.mapView = [[MAMapView alloc] initWithFrame:self.view.bounds];
    self.mapView.delegate = self;
    [self.view addSubview:self.mapView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    //设置地图显示区域(比如：宜达互联公司地址)
    CLLocationCoordinate2D coord = CLLocationCoordinate2DMake(22.534253,114.024642);
    MACoordinateSpan span = MACoordinateSpanMake(0.01, 0.01);
    [self.mapView setRegion:MACoordinateRegionMake(coord, span) animated:YES];
    
    //添加一个实体对象，用于自定义大头针视图内容显示
    self.entity = [[XiBi_MapEntity alloc] init];
    self.entity.coordinate = coord;
    self.entity.image = [NSString stringWithFormat:@"fengji4"];
    self.entity.title = [NSString stringWithFormat:@"深圳市宝安区松岗街道修下水道污染环境，堵塞交通。"];
    
    //添加高德大头针
    MAPointAnnotation *annotation = [[MAPointAnnotation alloc] init];
    annotation.coordinate = coord;
    annotation.title = @"思拓微电子";
    annotation.subtitle = @"深圳市宝安区松岗山门第三工业区29号";
    [self.mapView addAnnotation:annotation];//添加大头针(会自动调用mapView: viewForAnnotation:回调方法)
}

#pragma mark - MAMapViewDelegate
- (MAAnnotationView *)mapView:(MAMapView *)mapView viewForAnnotation:(id <MAAnnotation>)annotation
{
    if ([annotation isKindOfClass:[XiBi_CustomAnnotation class]])
    {
        //创建自定义大头针视图
        XiBi_CustomAnnotationView *cusAnnotationView = [[XiBi_CustomAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"CustomAnnotation" frame:CGRectMake(0, 0, 240, 60) info:self.entity];
        cusAnnotationView.delegate = self;
        
        return cusAnnotationView;
    }
    
    static NSString *str=@"annotation";
    MAAnnotationView *newAnnotation=[mapView dequeueReusableAnnotationViewWithIdentifier:str];
    if (!newAnnotation)
    {
        newAnnotation=[[MAAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:str];
        newAnnotation.canShowCallout=NO;//设置为NO,用以调用自定义的calloutView
        newAnnotation.image=[UIImage imageNamed:@"大头针"];
    }
    
    return newAnnotation;
}

//选中大头针
-(void)mapView:(MAMapView *)mapView didSelectAnnotationView:(MAAnnotationView *)view
{
    if ([view.annotation isKindOfClass:[MAPointAnnotation class]])
    {
        //防止多次点击同一个大头针
        if (self.customAnnotation.coordinate.latitude == view.annotation.coordinate.latitude &&
            self.customAnnotation.coordinate.longitude == view.annotation.coordinate.longitude){
            return;
        }
        
        //创建一个自定义大头针
        self.customAnnotation = [[XiBi_CustomAnnotation alloc] init];
        self.customAnnotation.coordinate = view.annotation.coordinate;
        
        //此时会执行mapView: viewForAnnotation:回调方法
        [self.mapView addAnnotation:self.customAnnotation];
        
        //设置居中显示
        [self.mapView setCenterCoordinate:self.customAnnotation.coordinate animated:YES];
    }
}

//不选中大头针
-(void)mapView:(MAMapView *)mapView didDeselectAnnotationView:(MAAnnotationView *)view
{
    //移除自定义大头针
    [self.mapView removeAnnotation:self.customAnnotation];
    self.customAnnotation = nil;
}

#pragma mark - XiBi_CustomAnnotationViewDelegate
- (void)customAnnotationClicked:(XiBi_CustomAnnotationView*)view
{
    NSLog(@"大头针注释视图上的button点击了");
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
