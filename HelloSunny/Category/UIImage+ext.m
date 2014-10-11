//
//  UIImage+ext.m
//  HelloSunny
//
//  Created by garin on 14-4-17.
//  Copyright (c) 2014年 garin. All rights reserved.
//

#import "UIImage+ext.h"

@implementation UIImage (ext)

+ (UIImage *)noCacheImageNamed:(NSString *)name
{
    if (!name || [name isEqualToString:@""]) {
        return nil;
    }
	UIImage *image = [UIImage imageWithContentsOfFile:[[NSBundle mainBundle] pathForResource:name ofType:nil]];
	
	return image;
}


+ (UIImage *)stretchableImageWithPath:(NSString *)path
{
	UIImage *stretchImg = [UIImage imageNamed:path];
	return [stretchImg stretchableImageWithLeftCapWidth:stretchImg.size.width / 2
										   topCapHeight:stretchImg.size.height / 2];
}

- (UIImage *) imageWithTintColor:(UIColor *)tintColor
{
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeDestinationIn];
}

- (UIImage *) imageWithGradientTintColor:(UIColor *)tintColor
{
    return [self imageWithTintColor:tintColor blendMode:kCGBlendModeOverlay];
}

- (UIImage *) imageWithTintColor:(UIColor *)tintColor blendMode:(CGBlendMode)blendMode
{
    //We want to keep alpha, set opaque to NO; Use 0.0f for scale to use the scale factor of the device’s main screen.
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    [tintColor setFill];
    CGRect bounds = CGRectMake(0, 0, self.size.width, self.size.height);
    UIRectFill(bounds);
    
    //Draw the tinted image in context
    [self drawInRect:bounds blendMode:blendMode alpha:1.0f];
    
    if (blendMode != kCGBlendModeDestinationIn) {
        [self drawInRect:bounds blendMode:kCGBlendModeDestinationIn alpha:1.0f];
    }
    
    UIImage *tintedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return tintedImage;
}


@end
