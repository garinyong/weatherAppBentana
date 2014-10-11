//
//  GPSInfo.h
//  QuickHotel
//
//  Created by garin 14-5-11.
//  Copyright (c) 2014年 garin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface GPSInfo : NSObject

@property(nonatomic,copy) NSString *cityName;
@property(nonatomic,copy) NSString *shortCityName;
@property(nonatomic,copy) NSString *areaName;
@property(nonatomic) CLLocationCoordinate2D coordinate;
@property(nonatomic) BOOL isCompleteGPS;

@end
