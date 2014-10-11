//
//  RoundMoveView.m
//  HelloSunny
//
//  Created by gaoyong on 14-10-11.
//  Copyright (c) 2014年 garin. All rights reserved.
//

#import "RoundMoveView.h"

static float spanValue = 10.0f;

@implementation RoundMoveView

-(id) initWithFrame:(CGRect)frame expandType_:(expandType) directionType
{
    if (self=[super initWithFrame:frame])
    {
        self.backgroundColor = [UIColor clearColor];
        
        viewList = [NSMutableArray array];
        
        titleList = @[@"上海",@"广州",@"深圳",@"更多",@"北京"];
        
        for (int i = 0; i < titleList.count; i++)
        {
            UIColor *ranColor = [UIColor colorWithRed:65/255.0f green:173/255.0f blue:57/255.0f alpha:1];
        
            if (i == titleList.count - 1)
            {
                ranColor = [UIColor colorWithRed:26/255.0f green:139/255.0f blue:43/255.0f alpha:1];
            }
            
            NSString *selectorClick = [NSString stringWithFormat:@"btnClick%d",i];
            
            RoundBtn *roundBtn = [[RoundBtn alloc] initWithFrame:CGRectMake(frame.size.width - 60, 0, 50, 50) drawcolor_:ranColor txt:[titleList objectAtIndex:i] btnClickTarget:self btnClickSel:NSSelectorFromString(selectorClick)];
            
            if (i == titleList.count - 1)
            {
                
            }
            
            [viewList addObject:roundBtn];
            
            [self addSubview:roundBtn];
        }
    }
    
    directionType = directionType;
    self.clipsToBounds = NO;
    
    return self;
}

-(void) setTitleList:(NSArray *) newTitleList
{
    if (ARRAYHASVALUE(newTitleList) == NO)
    {
        return;
    }
    
    if (newTitleList.count!=titleList.count) {
        return;
    }
    
    for (int i = 0; i < titleList.count; i++)
    {
        RoundBtn *roundBtn = [viewList safeObjectAtIndex:i];
        
        NSDictionary *di = [newTitleList safeObjectAtIndex:i];
        
        [roundBtn setUI:[di safeObjectForKey:@"sName"]  newDrawColor:nil];
    }
}

-(void) btnClick0
{
    NSString *city = [titleList safeObjectAtIndex:0];
    
    _curSelectItemBlock(city);
}


-(void) btnClick1
{
    NSString *city = [titleList safeObjectAtIndex:1];
    
    _curSelectItemBlock(city);
}

-(void) btnClick2
{
    NSString *city = [titleList safeObjectAtIndex:2];
    
    _curSelectItemBlock(city);
}

//城市列表
-(void) btnClick3
{
    _curSelectItemBlock(@"select city list");
}

//展开，收起按钮
-(void) btnClick4
{
    [self anmimateWithBlock];
}

-(void) anmimateWithBlock
{
    isOpen = !isOpen;
    
    float span = 50 + spanValue;
    
    //最上边的不动
    if (isOpen)
    {
        for (int i = 0; i< viewList.count-1; i++)
        {
            RoundBtn *tem = [viewList objectAtIndex:i];
            
            float duration = (viewList.count - 1 - i) * 0.1;
            
            NSLog(@"%f",duration);
            
            CGFloat angel = M_PI * 2;
            
            [UIView animateWithDuration:duration animations:^{
                tem.frame = CGRectMake(tem.frame.origin.x - span * (viewList.count - 1 - i), tem.frame.origin.y, tem.frame.size.width, tem.frame.size.height);
                
                tem.transform = CGAffineTransformMakeRotation(angel);
            }];
        }
    }
    else
    {
        for (int i = 0; i< viewList.count-1; i++)
        {
            RoundBtn *tem = [viewList objectAtIndex:i];
            
            float duration = (viewList.count - 1 - i) * 0.08;
            
            NSLog(@"%f",duration);
            
            [UIView animateWithDuration:duration animations:^{
                tem.frame = CGRectMake(tem.frame.origin.x + span * (viewList.count - 1 - i), tem.frame.origin.y, tem.frame.size.width, tem.frame.size.height);
            }];
            
            CGFloat angel = - M_PI * 2 * (viewList.count - 1 - i);
            
            duration = (viewList.count-1 - i)*0.5;
            
            [UIView animateWithDuration:duration animations:^{
                tem.transform = CGAffineTransformMakeRotation(angel);
            } completion:^(BOOL finished) {
                tem.transform = CGAffineTransformIdentity;
            }];
        }
    }
}
@end
