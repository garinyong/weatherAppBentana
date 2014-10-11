//
//  RoundBtn.m
//  HelloSunny
//
//  Created by gaoyong on 14-10-11.
//  Copyright (c) 2014年 garin. All rights reserved.
//

#import "RoundBtn.h"

@implementation RoundBtn

- (id)initWithFrame:(CGRect)frame drawcolor_:(UIColor *) drawcolor_  txt:(NSString *) txt_ btnClickTarget:(id) btnClickTarget_ btnClickSel:(SEL) btnClickSel_
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        drawColor = drawcolor_;
        txt = txt_;
    }
    
    [self addTarget:btnClickTarget_ action:btnClickSel_ forControlEvents:UIControlEventTouchUpInside];
    
    return self;
}

-(void) setUI:(NSString *) newTxt newDrawColor:(UIColor *) newDrawColor
{
    if(STRINGHASVALUE(newTxt)){
        txt = newTxt;
    }
        
    if (newDrawColor) {
        drawColor = newDrawColor;
    }
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [drawColor set]; //设置线条颜色
    
    float radius = MIN(self.frame.size.width, self.frame.size.height)/2;
    
    UIBezierPath* aPath = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.frame.size.width/2, self.frame.size.height/2)
                                                         radius:radius
                                                     startAngle:0
                                                       endAngle:M_PI*2
                                                      clockwise:YES];
    
    aPath.lineWidth = 1.0;
    aPath.lineCapStyle = kCGLineCapRound; //线条拐角
    aPath.lineJoinStyle = kCGLineCapRound; //终点处理
    
    //    [aPath stroke];
    [aPath fill];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetRGBFillColor (context,  1, 0, 0, 1.0);
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:12.0f], NSFontAttributeName, nil];
    
    [txt drawAtPoint:CGPointMake(self.bounds.size.width/2 -14,self.bounds.size.height/2 -8) withAttributes:dic];
}

@end
