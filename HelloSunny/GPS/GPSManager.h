//
//  GPSManager.h
//  QuickHotel
//
//  Created by garin on 14-5-11.
//  Copyright (c) 2014年 garin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "GPSInfo.h"

@interface GPSManager : NSObject<CLLocationManagerDelegate>

@property(nonatomic,retain) CLLocationManager *locationManager;
@property(nonatomic,retain) GPSInfo *gpsInfo;

+(id)shared;
-(void)startGPS;
-(void)getCityAeraName:(CLLocation *)location;
@end
