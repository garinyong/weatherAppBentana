//
//  HomeViewController.h
//  HelloSunny
//
//  Created by fan on 14-10-4.
//  Copyright (c) 2014年 garin. All rights reserved.
//

#import "BaseViewController.h"
#import "WeatherDataEngine.h"
#import "weatherInfoModel.h"
#import "RoundMoveView.h"

@interface HomeViewController : BaseViewController
{
    CAEmitterLayer *rainEmitter;   //下雨层
    CAEmitterLayer *snowEmitter;   //下雪层
    UIImageView *sunnyView;        //sunny
    UIImageView *cloudyView;        //cloudy
    RoundMoveView *rmv;
    NSDictionary *cityData;
    
    WeatherDataEngine *wde;
    
    float picWidth;
    float picHeight;
}

@property (weak, nonatomic) IBOutlet UILabel *stateDesp;
@property (weak, nonatomic) IBOutlet UILabel *lowDesp;
@property (weak, nonatomic) IBOutlet UILabel *highDesp;
@property (weak, nonatomic) IBOutlet UILabel *timeDesp;
@property (weak, nonatomic) IBOutlet UIScrollView *contentView;
@property (weak, nonatomic) IBOutlet UIView *contentBgView;
@property (weak, nonatomic) IBOutlet UIButton *cityBtn;


@end
