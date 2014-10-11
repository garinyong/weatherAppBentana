//
//  AppPrepareTool.m
//  HelloSunny
//
//  Created by garin on 14-4-17.
//  Copyright (c) 2014年 garin. All rights reserved.
//

#import "AppPrepareTool.h"

@implementation AppPrepareTool

+(void) setComonNarvigationBar:(UINavigationBar *) bar
{
    //背景色
    [bar setNBTintColor:[UIColor grayColor]];
    //bar的颜色：亮色或者暗色
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
}

@end
