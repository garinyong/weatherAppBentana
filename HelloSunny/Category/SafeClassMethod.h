//
//  SafeClassMethod.h
//  HelloSunny
//
//  Created by garin on 14-5-7.
//  Copyright (c) 2014年 garin. All rights reserved.
//

#import <Foundation/Foundation.h>

// =====================================================
// NSDictionary category
// =====================================================
@interface NSDictionary (Utility)

- (id)safeObjectForKey:(id)aKey;

@end


// =====================================================
// NSMutableDictionary category
// =====================================================
@interface NSMutableDictionary (Utility)

// 设置Key/Value
- (void)safeSetObject:(id)anObject forKey:(id < NSCopying >)aKey;

@end




// =====================================================
// NSArray category
// =====================================================
@interface NSArray (Utility)

-(id) safeObjectAtIndex:(NSUInteger)index;

@end
