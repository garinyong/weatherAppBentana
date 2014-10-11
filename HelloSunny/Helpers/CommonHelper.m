//
//  CommonHelper.m
//  HelloSunny
//  共用工具类
//  Created by garin on 14-4-17.
//  Copyright (c) 2014年 garin. All rights reserved.
//

#import "CommonHelper.h"

@implementation CommonHelper

+ (void)showAlertTitle:(NSString *)title Message:(NSString *)message
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:title
                                                    message:message
                                                   delegate:nil
                                          cancelButtonTitle:_string(@"确定")
                                          otherButtonTitles:nil];
    [alert show];
}


@end
