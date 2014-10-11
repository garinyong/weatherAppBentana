//
//  UINavigationBar+ext.m
//  HelloSunny
//
//  Created by garin on 14-4-17.
//  Copyright (c) 2014年 garin. All rights reserved.
//

#import "UINavigationBar+ext.h"

@implementation UINavigationBar (ext)

-(void) setNBTintColor:(UIColor *) color
{
    if (IOS_VERSION>7.0)
    {
        [[UINavigationBar appearance] setBarTintColor:color];
    }
    else
    {
        [[UINavigationBar appearance] setTintColor:color];
    }
}

-(void) setNBBackgroundImage:(NSString *) imgUrl
{
    if (IOS_VERSION>=5.0)
    {
        [[UINavigationBar appearance] setBackgroundImage:[UIImage noCacheImageNamed:imgUrl] forBarMetrics:UIBarMetricsDefault];
    }
    else
    {
        UIImage *image = [UIImage imageNamed:imgUrl];
        UIImageView *imgeView = [[UIImageView alloc] initWithImage:image];
        imgeView.tag = TAG_CUSTOM_NAVBAR_IMAGE;
        [imgeView setFrame:CGRectZero];
        [self addSubview:imgeView];
    }
}

- (void)drawRect:(CGRect)rect
{
    UIImageView *imageView = (UIImageView *)[self viewWithTag:TAG_CUSTOM_NAVBAR_IMAGE];
    if(imageView)
    {
        UIImage *image = imageView.image;
        [image drawInRect:CGRectMake(0.0f, 0.0f, rect.size.width, rect.size.height)];
    }
    else
    {
        [super drawRect:rect];
    }
}

-(void) setNbBackIndicatorImage:(NSString *) backIndicatorImageUrl
{
    if (IOS_VERSION>7.0)
    {
        [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:backIndicatorImageUrl]];
    }
}

-(void) setNbBackIndicatorTransitionMaskImage:(NSString *) backIndicatorTransitionMaskImageUrl
{
    if (IOS_VERSION>7.0)
    {
        [[UINavigationBar appearance] setBackIndicatorImage:[UIImage imageNamed:backIndicatorTransitionMaskImageUrl]];
    }
}

@end
