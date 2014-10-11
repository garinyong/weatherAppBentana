//
//  baseModel.h
//  HelloSunny
//
//  Created by garin on 14-4-22.
//  Copyright (c) 2014年 garin. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseModel : NSObject<NSCoding>
{
    
}


-(id)initModel:(NSDictionary*)data;
- (NSDictionary*)attributeMapDictionary;
- (void)setAttributes:(NSDictionary*)dataDic;//赋值Model
- (NSString *)customDescription;
- (NSString *)description;  //打印Model
- (NSData*)getArchivedData;
- (NSString *)cleanString:(NSString *)str;    //清除\n和\r的字符串
- (NSDictionary *)convertDictionaryFromObjet;//将model类转换为字典
- (void)convertObjectFromGievnDictionary:(NSDictionary*) dict;
-(void)convertObjectFromGievnDictionary:(NSDictionary *)dict relySelf:(BOOL)yes;
@end

