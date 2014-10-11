//
//  UIImage+ext.h
//  HelloSunny
//
//  Created by garin on 14-4-17.
//  Copyright (c) 2014年 garin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (ext)

+ (UIImage *)noCacheImageNamed:(NSString *)name;

+ (UIImage *)stretchableImageWithPath:(NSString *)path;

- (UIImage *) imageWithTintColor:(UIColor *)tintColor;

- (UIImage *) imageWithGradientTintColor:(UIColor *)tintColor;

- (UIImage *) imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode;

@end
