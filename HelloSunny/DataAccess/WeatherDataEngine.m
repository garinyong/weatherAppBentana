//
//  WeatherDataEngine.m
//  HelloSunny
//
//  Created by garin on 14-4-30.
//  Copyright (c) 2014年 garin. All rights reserved.
//

#import "WeatherDataEngine.h"

@implementation WeatherDataEngine

-(MKNetworkOperation *) getWeatherInfo:(CurResponseBlock) completionBlock
                          errorHandler:(MKNKErrorBlock) errorBlock
                                cityid:(NSString *) cityid
{
    NSString *url = [NSString stringWithFormat:@"data/cityinfo/%@.html",cityid];
    
    MKNetworkOperation *op = [self operationWithPath:url params:nil httpMethod:@"GET"];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation)
    {
        id result = [completedOperation responseJSON];
        
        DLog(@"%@", result);
        
        completionBlock(result);
        
    }
    errorHandler:^(MKNetworkOperation *completedOperation, NSError *error)
    {
        errorBlock(error);
    }];
    
    [self enqueueOperation:op];
    
    return op;
}

@end
