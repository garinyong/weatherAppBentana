//
//  GPSManager.m
//  QuickHotel
//
//  Created by garin on 14-5-11.
//  Copyright (c) 2014年 garin. All rights reserved.
//

#import "GPSManager.h"
#import <math.h>

@interface GPSManager()
-(void)stopGPS; //停止定位
-(void)getCityByLocation:(CLLocation *)location;        //根据坐标，定位城市
-(NSString *)filterCityName:(NSString *)cityName;       //去掉“县、市”
-(CLLocationCoordinate2D)updateLocationByBaidu:(CLLocationCoordinate2D)coordinate;//纠偏算法
@end

@implementation GPSManager
@synthesize locationManager;
@synthesize gpsInfo;

static GPSManager *gps = nil;
+(id)shared{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        gps = [[GPSManager alloc] init];
    });
    return gps;
}

- (void)dealloc
{
    [locationManager release];
    [gpsInfo release];
    [super dealloc];
}

-(id)init{
    self = [super init];
    if(self){
        if(!locationManager){
            locationManager = [[CLLocationManager alloc] init];
        }
        self.locationManager.delegate = self;
        if(!gpsInfo){
            gpsInfo = [[GPSInfo alloc] init];
        }
    }
    return self;
}

/* Start Gps */
-(void)startGPS{
    self.gpsInfo.isCompleteGPS = NO;
    
    if(IOS_VERSION >= 8.0)
    {
        [locationManager requestWhenInUseAuthorization];
    }
    
    [locationManager startUpdatingLocation];        //update location
}

/* Stop GPS  */
-(void)stopGPS{
    [locationManager stopUpdatingLocation];         //stop location
}

/* Get city by location  */
-(void)getCityByLocation:(CLLocation *)location{
            //ios5上采用
        CLGeocoder *geocoder = [[[CLGeocoder alloc] init] autorelease];
        [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks,NSError *error){
            if(error){
               [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FAILGETPOSITIONCITY object:nil];
                return ;
            }
            //取最后一次定位
            CLPlacemark *placemark=[placemarks objectAtIndex:placemarks.count-1];
            if(placemark.locality){
                self.gpsInfo.cityName = [self filterCityName:placemark.locality];
            }else{
                self.gpsInfo.cityName = [self filterCityName:placemark.administrativeArea];
            }
            self.gpsInfo.shortCityName = [self filterCityName:placemark.administrativeArea];
            for(NSString *key in placemark.addressDictionary){
                NSLog(@"key--%@,name:%@",key,[placemark.addressDictionary objectForKey:key]);
            }
            self.gpsInfo.areaName = [NSString stringWithFormat:@"%@%@",placemark.subLocality,placemark.thoroughfare?placemark.thoroughfare:@""];
            self.gpsInfo.isCompleteGPS = YES;
            NSLog(@"ios5--GPS CityName:%@,AreaName:%@",self.gpsInfo.cityName,self.gpsInfo.areaName);
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_REQUESTPOSITIONCITY object:nil];
            
        }];
}


/* Get city by location  */
-(void)getCityAeraName:(CLLocation *)location{
    CLGeocoder *geocoder = [[[CLGeocoder alloc] init] autorelease];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks,NSError *error){
        GPSInfo *info=[[[GPSInfo alloc] init] autorelease];
        info.coordinate=location.coordinate;
        if(error)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GetCityArera object:info];
            return ;
        }
        //取最后一次定位
        CLPlacemark *placemark=[placemarks objectAtIndex:placemarks.count-1];
        
        if(placemark.locality){
            info.cityName = [self filterCityName:placemark.locality];
        }else{
            info.cityName = [self filterCityName:placemark.administrativeArea];
        }
        
        info.shortCityName = [self filterCityName:placemark.administrativeArea];
        
        for(NSString *key in placemark.addressDictionary){
            NSLog(@"key--%@,name:%@",key,[placemark.addressDictionary objectForKey:key]);
        }
        info.areaName = [NSString stringWithFormat:@"%@%@",placemark.subLocality,placemark.thoroughfare?placemark.thoroughfare:@""];
        NSLog(@"ios5--GPS CityName:%@,AreaName:%@",info.cityName,info.areaName);
        
        [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_GetCityArera object:info];
    }];
}

/* 去掉“县、市” */
-(NSString *)filterCityName:(NSString *)cityName{
    NSString *tmpCity = cityName;
    if ([[NSPredicate predicateWithFormat:@"SELF MATCHES '[\u4e00-\u9fa5]{1,50}'"] evaluateWithObject:cityName]) {
		// 中文去掉“市”、“县”等标志
		tmpCity = [cityName substringToIndex:[cityName length]-1];
	}
    return tmpCity;
}

#pragma mark - CoreLocation Delegate
-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation{
    NSLog(@"GPS Successfully!");
    CLLocationCoordinate2D newCoordinate = [self updateLocationByBaidu:newLocation.coordinate];
    self.gpsInfo.coordinate = newCoordinate;
    CLLocation *updateLocation = [[CLLocation alloc] initWithLatitude:newCoordinate.latitude longitude:newCoordinate.longitude];
    [self stopGPS];     //stop
    [self getCityAeraName:updateLocation];
    [updateLocation release];
    
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    NSLog(@"GPS Failed!");
    [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_FAILGETPOSITIONCITY object:nil];
}

#pragma mark - 纠偏算法

double transformLat(double x, double y) {
    double ret = -100.0 + 2.0 * x + 3.0 * y + 0.2 * y * y + 0.1 * x * y + 0.2 * sqrt(abs(x));
    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(y * M_PI) + 40.0 * sin(y / 3.0 * M_PI)) * 2.0 / 3.0;
    ret += (160.0 * sin(y / 12.0 * M_PI) + 320 * sin(y * M_PI / 30.0)) * 2.0 / 3.0;
    return ret;
}

static double transformLon(double x, double y) {
    double ret = 300.0 + x + 2.0 * y + 0.1 * x * x + 0.1 * x * y + 0.1 * sqrt(abs(x));
    ret += (20.0 * sin(6.0 * x * M_PI) + 20.0 * sin(2.0 * x * M_PI)) * 2.0 / 3.0;
    ret += (20.0 * sin(x * M_PI) + 40.0 *sin(x / 3.0 * M_PI)) * 2.0 / 3.0;
    ret += (150.0 * sin(x / 12.0 * M_PI) + 300.0 * sin(x / 30.0 * M_PI)) * 2.0 / 3.0;
    return ret;
}

//gps纠偏算法
-(CLLocationCoordinate2D)updateLocationByBaidu:(CLLocationCoordinate2D)coordinate{
    CLLocationCoordinate2D mNewLocation;    //火星坐标
    double lon = coordinate.longitude;
    double lat = coordinate.latitude;
    const double a = 6378245.0;
    const double ee = 0.00669342162296594323;
    if(lon>72.004 && lon<137.8347 && lat>0.8293 && lat<55.8271){
        double dLat = transformLat(lon - 105.0, lat - 35.0);
        double dLon = transformLon(lon - 105.0, lat - 35.0);
        double radLat = lat / 180.0 * M_PI;
        double magic = sin(radLat);
        magic = 1 - ee * magic * magic;
        double sqrtMagic = sqrt(magic);
        dLat = (dLat * 180.0) / ((a * (1 - ee)) / (magic * sqrtMagic) * M_PI);
        dLon = (dLon * 180.0) / (a / sqrtMagic * cos(radLat) * M_PI);
        double mgLat = lat + dLat;
        double mgLon = lon + dLon;
        mNewLocation = CLLocationCoordinate2DMake(mgLat, mgLon);
    }else{
        mNewLocation = coordinate;
    }
    return mNewLocation;
}

@end
