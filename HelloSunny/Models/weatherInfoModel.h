//
//  weatherInfoModel.h
//  HelloSunny
//
//  Created by garin on 14-4-21.
//  Copyright (c) 2014年 garin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WeatherInfoModel : BaseModel

@property (nonatomic,strong) NSString *city;
@property (nonatomic,strong) NSString *cityid;
@property (nonatomic,strong) NSString *temp1;
@property (nonatomic,strong) NSString *temp2;
@property (nonatomic,strong) NSString *weather;
@property (nonatomic,strong) NSString *img1;
@property (nonatomic,strong) NSString *img2;
@property (nonatomic,strong) NSString *ptime;

@end
