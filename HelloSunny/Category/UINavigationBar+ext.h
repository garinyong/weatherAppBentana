//
//  UINavigationBar+ext.h
//  HelloSunny
//
//  Created by garin on 14-4-17.
//  Copyright (c) 2014年 garin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationBar (ext)

//设置navigationBar背景色
-(void) setNBTintColor:(UIColor *) color;

//设置背景图片
-(void) setNBBackgroundImage:(NSString *) imgUrl;

//返回的箭头
-(void) setNbBackIndicatorImage:(NSString *) backIndicatorImageUrl;

//返回的按钮
-(void) setNbBackIndicatorTransitionMaskImage:(NSString *) backIndicatorTransitionMaskImageUrl;

@end
