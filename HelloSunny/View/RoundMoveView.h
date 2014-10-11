//
//  RoundMoveView.h
//  HelloSunny
//
//  Created by gaoyong on 14-10-11.
//  Copyright (c) 2014年 garin. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoundBtn.h"

typedef enum
{
    Left,
    Right,
    Up,
    Down
} expandType;

typedef void (^selecItem) (NSString *selectTitle);

@interface RoundMoveView : UIView
{
    NSMutableArray *viewList;
    
    BOOL isOpen;
    
    NSArray *titleList;
}

@property (nonatomic,copy) selecItem curSelectItemBlock;

-(id) initWithFrame:(CGRect)frame expandType_:(expandType) directionType;

-(void) setTitleList:(NSArray *) newTitleList;

@end
