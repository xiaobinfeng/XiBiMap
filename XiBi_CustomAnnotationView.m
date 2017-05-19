//
//  XiBi_CustomAnnotationView.m
//  XiBiMap
//
//  Created by mac on 2016/10/26.
//  Copyright © 2016年 mac. All rights reserved.
//

#import "XiBi_CustomAnnotationView.h"
#define  Arror_height 10 //箭头高度

@implementation XiBi_CustomAnnotationView
- (id)initWithAnnotation:(id<MAAnnotation>)annotation
         reuseIdentifier:(NSString *)reuseIdentifier
                   frame:(CGRect)rect
                    info:(XiBi_MapEntity*)aEntity
{
    if (self = [super initWithAnnotation:annotation reuseIdentifier:reuseIdentifier]) {
        self.frame = rect;
        [self initSubviews:aEntity];
    }
    return self;
}

/**
 @功能：初始化子视图
 @参数：无
 @返回值：无
 */
- (void)initSubviews:(XiBi_MapEntity*)aEntity
{
    self.centerOffset = CGPointMake(0, -50);//设置中心点偏移量
    self.canShowCallout = NO;//不显示标志提示
    self.backgroundColor = [UIColor clearColor];//设置背景透明
    
    //左边贴个imageview
    UIImageView *imgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60-Arror_height)];
    imgView.image = [UIImage imageNamed:aEntity.image];
    [self addSubview:imgView];
    
    //中间贴个label
    UILabel *aLab = [[UILabel alloc] initWithFrame:CGRectMake(60, 0, 120, 60-Arror_height)];
    aLab.numberOfLines = 0;
    aLab.font = [UIFont systemFontOfSize:12];
    aLab.text = aEntity.title;
    [self addSubview:aLab];
    
    //右边贴个按钮button
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeCustom];
    [btn setBackgroundImage:[UIImage imageNamed:@"navigation"] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"navigation_selected"] forState:UIControlStateHighlighted];
    btn.frame = CGRectMake(180, 0, 60, 60-Arror_height);
    [btn addTarget:self action:@selector(buttonClicked) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:btn];
}

//按钮点击事件
- (void)buttonClicked
{
    //调用委托代理方法
    if (self.delegate && [self.delegate respondsToSelector:@selector(customAnnotationClicked:)])
    {
        [self.delegate customAnnotationClicked:self];
    }
}

//绘制文本上下文
-(void)drawInContext:(CGContextRef)context
{
    CGContextSetLineWidth(context, 1.0);
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    
    [self getDrawPath:context];
    CGContextFillPath(context);
}

//设置画线路径并画线
- (void)getDrawPath:(CGContextRef)context
{
    CGRect rrect = self.bounds;
    CGFloat radius = 6.0;
    
    CGFloat minx = CGRectGetMinX(rrect), midx = CGRectGetMidX(rrect), maxx = CGRectGetMaxX(rrect);
    CGFloat miny = CGRectGetMinY(rrect), maxy = CGRectGetMaxY(rrect)-Arror_height;
    CGContextMoveToPoint(context, midx+Arror_height, maxy);
    CGContextAddLineToPoint(context,midx, maxy+Arror_height);
    CGContextAddLineToPoint(context,midx-Arror_height, maxy);
    
    CGContextAddArcToPoint(context, minx, maxy, minx, miny, radius);
    CGContextAddArcToPoint(context, minx, minx, maxx, miny, radius);
    CGContextAddArcToPoint(context, maxx, miny, maxx, maxx, radius);
    CGContextAddArcToPoint(context, maxx, maxy, midx, maxy, radius);
    CGContextClosePath(context);
}

//重载父类的方法，用于视图绘制(此方法会自动调用，绘制当前视图内容)
- (void)drawRect:(CGRect)rect
{
    [self drawInContext:UIGraphicsGetCurrentContext()];
    
    self.layer.shadowColor = [[UIColor blackColor] CGColor];
    self.layer.shadowOpacity = 1.0;
    self.layer.shadowOffset = CGSizeMake(0.0f, 0.0f);
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
