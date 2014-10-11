//
//  WeatherDataEngine.h
//  HelloSunny
//
//  Created by garin on 14-4-30.
//  Copyright (c) 2014年 garin. All rights reserved.
//

#import "MKNetworkEngine.h"

@interface WeatherDataEngine : MKNetworkEngine

typedef void (^CurResponseBlock)(NSDictionary * dict);

-(MKNetworkOperation *) getWeatherInfo:(CurResponseBlock) completionBlock
                          errorHandler:(MKNKErrorBlock) errorBlock
                                cityid:(NSString *) cityid;

@end
