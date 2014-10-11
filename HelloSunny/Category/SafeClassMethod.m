//
//  SafeClassMethod.m
//  HelloSunny
//
//  Created by garin on 14-5-7.
//  Copyright (c) 2014年 garin. All rights reserved.
//

#import "SafeClassMethod.h"

@implementation NSDictionary (Utility)

- (id)safeObjectForKey:(id)aKey
{
    if ([self isKindOfClass:[NSDictionary class]] &&
        ([self objectForKey:aKey] != nil))
    {
		return [self objectForKey:aKey];
    }
    
    return nil;
}

@end




@implementation NSMutableDictionary (Utility)

// 设置Key/Value
- (void)safeSetObject:(id)anObject forKey:(id < NSCopying >)aKey
{
	if(anObject != nil)
	{
		[self setObject:anObject forKey:aKey];
	}
}

@end




@implementation NSArray (Utility)

-(id) safeObjectAtIndex:(NSUInteger)index
{
    if (index >= self.count) {
        return nil;
    }
    return [self objectAtIndex:index];
}

@end
