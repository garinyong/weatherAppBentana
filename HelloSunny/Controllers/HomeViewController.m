//
//  HomeViewController.m
//  HelloSunny
//
//  Created by fan on 14-10-4.
//  Copyright (c) 2014年 garin. All rights reserved.
//

#import "HomeViewController.h"
#import "GPSManager.h"
#import "CityListViewController.h"
@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
//    _contentView.contentSize= CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
    
    NSString *plistPath = [[NSBundle mainBundle] pathForResource:@"citycode" ofType:@"plist"];
    cityData = [[NSDictionary alloc] initWithContentsOfFile:plistPath];
    
    _cityBtn.hidden = YES;
    
    _contentBgView.clipsToBounds = YES;
    [_cityBtn addTarget:self action:@selector(btnclick) forControlEvents:UIControlEventTouchUpInside];
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(getLocationSuccess:) name:NOTIFICATION_GetCityArera object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(getLocationFail) name:NOTIFICATION_FAILGETPOSITIONCITY object:nil];
    
    rmv = [[RoundMoveView alloc] initWithFrame:CGRectMake(0, 30, self.view.bounds.size.width, 50) expandType_:Right];
    
    __weak RoundMoveView *weakRmv = rmv;
    __weak HomeViewController *weakSelf = self;
    
    rmv.curSelectItemBlock = ^(NSString *selectCity_)
    {
        if ([selectCity_ isEqualToString:@"select city list"])
        {
            [weakSelf btnclick];
        }
        else
        {
            NSMutableArray *newCityList = [weakSelf getCityTitleList:selectCity_];
            [weakRmv setTitleList:newCityList];
        }
    };
    
    [self.view addSubview:rmv];
    
    picWidth = 1024;
    picHeight = 348;
    
    [self setGPS];
}

-(NSMutableArray *) getCityTitleList:(NSString *) selectCity
{
    NSMutableArray *arr = [NSMutableArray array];
    
    int addCount = 0;
    
    NSDictionary *findCity = nil;
    
    for (NSArray *temDict in cityData.allValues)
    {
        for (NSDictionary *di in temDict)
        {
            if (addCount < 3)
            {
                [arr addObject:di];
                addCount ++;
            }
            
            NSString *tempCityName = [di safeObjectForKey:@"sName"];
            
            if (STRINGHASVALUE(tempCityName)&&[tempCityName isEqualToString:selectCity])
            {
                findCity = di;
            }
        }
    }
    
    //更多
    [arr addObject:[NSDictionary dictionaryWithObjectsAndKeys:@"更多",@"sName", nil]];
    
    if (DICTIONARYHASVALUE(findCity))
    {
        [arr addObject:findCity];
    }

    return arr;
}

-(void) btnclick{
    CityListViewController *vc = [[CityListViewController alloc] initWithNibName:@"CityListViewController" bundle:[NSBundle mainBundle]];
    vc.citySelect = ^(NSString *sno,NSString *sname) {
        [self updateUIByNet:sno cityName:sname];
    };
    [self presentViewController:vc animated:YES completion:^{
        
    }];
}

-(void) setGPS{
    GPSManager *manager = [GPSManager shared];
    [manager startGPS];
}

-(void) getLocationSuccess:(NSNotification*) notification
{
    GPSInfo *gpsInfo = [notification object];
    if (STRINGHASVALUE(gpsInfo.shortCityName)) {
        NSLog(@"%@",gpsInfo.shortCityName);
        
        NSString *cityCode = [self getCityID:gpsInfo.shortCityName];
            
        [self updateUIByNet:cityCode cityName:gpsInfo.shortCityName];
            
    }
}

-(void) updateUIByNet:(NSString *) citycode cityName:(NSString *) cityName
{
    //        _cityBtn.text=gpsInfo.cityName;
    [_cityBtn setTitle:cityName forState:UIControlStateNormal];
    
    if (wde == nil)
    {
        wde =[[WeatherDataEngine alloc] initWithHostName:@"www.weather.com.cn"];
    }
    
    [wde cancelAllOperations];
    
    [wde getWeatherInfo:^(NSDictionary *dict) {
        dict = [dict safeObjectForKey:@"weatherinfo"];
        WeatherInfoModel *data = [[WeatherInfoModel alloc] initModel:dict];
        
        _stateDesp.text = data.weather;
        
        NSString *tem1 = [data.temp1 stringByReplacingOccurrencesOfString:@"℃" withString:@""];
        NSString *tem2 = [data.temp2 stringByReplacingOccurrencesOfString:@"℃" withString:@""];
        
        if ([tem1 localizedStandardCompare:tem2] == NSOrderedDescending)
        {
            _lowDesp.text = data.temp2;
            _highDesp.text = data.temp1;
        }
        else
        {
            _lowDesp.text = data.temp1;
            _highDesp.text = data.temp2;
        }
        
        _timeDesp.text = [NSString stringWithFormat:@"国家气象局%@发布",data.ptime];
        
        [self setbgViewByState:data.weather];
        
        NSMutableArray *newCityList = [self getCityTitleList:cityName];
        [rmv setTitleList:newCityList];
        
    } errorHandler:^(NSError *error) {
        
    } cityid:citycode];
}

-(void) setbgViewByState:(NSString *) stateWeather
{
    [self removeRainEmitter];
    [self removeSnowEmitter];
    [self removeCloudyView];
    [self removeSunnyView];
    
    //看最后一个字
    NSString *lastCaracter = [stateWeather substringWithRange:NSMakeRange(stateWeather.length-1, 1)];
    
    if ([lastCaracter isEqualToString:@"晴"])
    {
        [self addSunnyView];
    }
    else if ([lastCaracter isEqualToString:@"雨"])
    {
        [self addRainEmitter];
    }
    else if ([lastCaracter isEqualToString:@"雪"])
    {
        [self addSnowEmitter];
    }
    else if ([lastCaracter isEqualToString:@"霾"])
    {
        [self addCloudView];
    }
    else
    {
        [self addCloudView];
    }
}

-(NSString *) getCityID:(NSString *) cityName
{
    for (NSArray *temDict in cityData.allValues) {
        
        for (NSDictionary *di in temDict) {
         
             NSString *tempCityName = [di safeObjectForKey:@"sName"];
            
            if (STRINGHASVALUE(tempCityName)&&[tempCityName isEqualToString:cityName])
            {
                return [di safeObjectForKey:@"sNo"];
            }
        }
    }
    
    return nil;
}

-(void) getLocationFail
{
    [CommonHelper showAlertTitle:@"" Message:@"定位失败啦"];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) removeCloudyView
{
    if(cloudyView)
    {
        [cloudyView removeFromSuperview];
        cloudyView = nil;
    }
}

-(void) removeSunnyView
{
    if(sunnyView)
    {
        [sunnyView removeFromSuperview];
        sunnyView = nil;
    }
}

-(void) removeRainEmitter
{
    if(rainEmitter)
    {
        [rainEmitter removeFromSuperlayer];
        rainEmitter = nil;
    }
}

-(void) removeSnowEmitter
{
    if(snowEmitter)
    {
        [snowEmitter removeFromSuperlayer];
        snowEmitter = nil;
    }
}

-(void) addRainEmitter
{

    [self removeRainEmitter];
    //发射层
    rainEmitter = [CAEmitterLayer layer];
    rainEmitter.emitterPosition = CGPointMake(self.view.bounds.size.width / 2.0, -30);//发射源位置
    rainEmitter.emitterSize		= CGSizeMake(self.view.bounds.size.width * 2.0, 0.0);//发射尺寸大小
    
    rainEmitter.emitterMode		= kCAEmitterLayerOutline;  //发射模式
    rainEmitter.emitterShape	= kCAEmitterLayerLine;     //发射形状
    
    //粒子
    CAEmitterCell *rainCell = [CAEmitterCell emitterCell];
    rainCell.contents		= (id) [[UIImage imageNamed:@"rain"] CGImage];
    rainCell.color			= [[UIColor colorWithRed:112/255.0 green:148/255.0 blue:176/255.0 alpha:1] CGColor];
    
    rainCell.emissionLongitude = 0.01 * M_PI; //XY平面方向的发射角
    //    rainCell.spin = 0.1 * M_PI;
    
    rainCell.birthRate		= 40;    //每s 发射的粒子个数
    rainCell.lifetime		= 8.0;   //每个粒子显示的时间
    rainCell.lifetimeRange  = 2;     //变化幅度
    rainCell.scale = 0.13;
    rainCell.velocity		= -1000; //速度
    
    rainEmitter.shadowOpacity = 1.0;
    rainEmitter.shadowRadius  = 0.0;
    rainEmitter.shadowOffset  = CGSizeMake(0.0, 1.0);
    rainEmitter.shadowColor   = [[UIColor whiteColor] CGColor];
    
    rainEmitter.emitterCells = [NSArray arrayWithObject:rainCell];
    [self.view.layer addSublayer:rainEmitter];
}

-(void) addCloudView
{
    [self removeCloudyView];
    
    cloudyView = [[UIImageView alloc] initWithFrame:_contentBgView.bounds];
    cloudyView.contentMode = UIViewContentModeLeft;
    cloudyView.image = [UIImage imageNamed:@"cloud.png"];
    [_contentBgView insertSubview:cloudyView atIndex:0];
    
    CGPoint startPoint = CGPointMake(cloudyView.layer.position.x, cloudyView.layer.position.y);
    
    UIBezierPath *path = [UIBezierPath bezierPath];
    [path moveToPoint:startPoint];
    
    //方向
    BOOL isToLeft = YES;
    
    CGPoint endPoint;
    CGPoint p1;
    CGPoint p2;
    //移动的最大距离(和初始位置有关)
    int maxX = (picWidth - cloudyView.layer.frame.size.width);
    int maxY = 10;
    if (isToLeft)
    {
        endPoint = CGPointMake(startPoint.x-maxX, arc4random()%100%2==0?startPoint.y+arc4random()%maxY:startPoint.y-arc4random()%maxY);
        p1 = CGPointMake(startPoint.x - arc4random()%maxX, arc4random()%100%2==0?startPoint.y+arc4random()%maxY:startPoint.y-arc4random()%maxY);
        p2 = CGPointMake(startPoint.x - arc4random()%maxX, arc4random()%100%2==0?startPoint.y+arc4random()%maxY:startPoint.y-arc4random()%maxY);
    }
    else
    {
        endPoint = CGPointMake(startPoint.x+maxX, arc4random()%100%2==0?startPoint.y+arc4random()%maxY:startPoint.y-arc4random()%maxY);
        p1 = CGPointMake(startPoint.x + arc4random()%maxX, arc4random()%100%2==0?startPoint.y+arc4random()%maxY:startPoint.y-arc4random()%maxY);
        p2 = CGPointMake(startPoint.x + arc4random()%maxX, arc4random()%100%2==0?startPoint.y+arc4random()%maxY:startPoint.y-arc4random()%maxY);
    }
    
//    NSLog(@"startPoint x:%f startPoint y:%f",startPoint.x,startPoint.y);
//    NSLog(@"p1 x:%f p1 y:%f",p1.x,p1.y);
//    NSLog(@"p2 x:%f p2 y:%f",p2.x,p2.y);
//    NSLog(@"endPoint x:%f endPoint y:%f",endPoint.x,endPoint.y);
    
    [path addCurveToPoint:endPoint controlPoint1:p1 controlPoint2:p2];
    
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"position"];
    [animation setPath:path.CGPath];
    
    CGFloat from3DScale = 1 + arc4random() % 2 *0.1;
    CGFloat to3DScale = from3DScale * 0.8;
    CAKeyframeAnimation *scaleAnimation = [CAKeyframeAnimation animationWithKeyPath:@"transform"];
    scaleAnimation.values = @[[NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)],[NSValue valueWithCATransform3D:CATransform3DMakeScale(from3DScale, from3DScale, from3DScale)], [NSValue valueWithCATransform3D:CATransform3DMakeScale(to3DScale, to3DScale, to3DScale)],
                              [NSValue valueWithCATransform3D:CATransform3DMakeScale(1, 1, 1)]];
    //    scaleAnimation.timingFunctions = @[[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    
    CAAnimationGroup *group = [CAAnimationGroup animation];
    group.delegate = self;
    group.duration = 100;
    //    group.fillMode = kCAFillModeForwards;
    //    group.removedOnCompletion = NO;
    group.animations = @[animation,scaleAnimation];
    group.autoreverses = YES;
    group.repeatCount = HUGE_VALL;
    [cloudyView.layer addAnimation:group forKey:@"position and transform"];
}

-(void) addSunnyView
{
    [self removeSunnyView];
    
    sunnyView = [[UIImageView alloc] initWithFrame:_contentBgView.bounds];
    sunnyView.image = [UIImage imageNamed:@"sun.jpg"];
    sunnyView.contentMode = UIViewContentModeScaleAspectFill;
    [_contentBgView insertSubview:sunnyView atIndex:0];
}

-(void) addSnowEmitter
{
    //发射层
    snowEmitter = [CAEmitterLayer layer];
    snowEmitter.emitterPosition = CGPointMake(self.view.bounds.size.width / 2.0, -30);//发射源位置
    snowEmitter.emitterSize		= CGSizeMake(self.view.bounds.size.width * 2.0, 0.0);//发射尺寸大小
    
    snowEmitter.emitterMode		= kCAEmitterLayerOutline;  //发射模式
    snowEmitter.emitterShape	= kCAEmitterLayerLine;     //发射形状
    
    //粒子
    CAEmitterCell *snowCell = [CAEmitterCell emitterCell];
    snowCell.contents		= (id) [[UIImage imageNamed:@"snow"] CGImage];
    snowCell.birthRate		= 5.0;
    snowCell.lifetime		= 20;
    
    snowCell.velocity		= -100;
    snowCell.velocityRange = 0;
    snowCell.yAcceleration = 2;
    snowCell.emissionRange = 0.5 * M_PI;
    snowCell.spinRange		= 0.5 * M_PI;
    snowCell.scale = 0.2;
    snowCell.color			= [[UIColor whiteColor] CGColor];
    
    snowEmitter.emitterCells = [NSArray arrayWithObject:snowCell];
    [self.view.layer addSublayer:snowEmitter];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -- RoundView Setting


@end
