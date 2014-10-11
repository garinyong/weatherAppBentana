//
//  RoundBtn.h
//  HelloSunny
//
//  Created by gaoyong on 14-10-11.
//  Copyright (c) 2014年 garin. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoundBtn : UIButton
{
    UIColor *drawColor;
    NSString *txt;
}

- (id)initWithFrame:(CGRect)frame drawcolor_:(UIColor *) drawcolor_  txt:(NSString *) txt_ btnClickTarget:(id) btnClickTarget_ btnClickSel:(SEL) btnClickSel_;


-(void) setUI:(NSString *) newTxt newDrawColor:(UIColor *) newDrawColor;

@end
