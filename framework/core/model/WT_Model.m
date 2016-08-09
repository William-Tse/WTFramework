//
//   ▼▲       ▲▼  ▼▲▼▲▼▲▼▲▼▲▼
//    ▼▲  ▲  ▲▼       ▲▼
//     ▼▲▼ ▼▲▼        ▲▼
//      ▼   ▼         ▲▼
//
//  Copyright © 2016 WTFramework. All rights reserved.
//  Created by William.Tse on 16/7/14.
//
//  WT_Model.m
//  WTFramework
//

#import "WT_Model.h"

@implementation WTModel

- (instancetype)initWithDictionary:(NSDictionary *)otherDictionary
{
    return nil;
}

//- (NSDictionary *)codableProperties
//{
//    __autoreleasing NSDictionary *codableProperties = objc_getAssociatedObject([self class], _cmd);
//    if (!codableProperties)
//    {
//        codableProperties = [NSMutableDictionary dictionary];
//        Class subclass = [self class];
//        while (subclass != [NSObject class])
//        {
//            [(NSMutableDictionary *)codableProperties addEntriesFromDictionary:[subclass codableProperties]];
//            subclass = [subclass superclass];
//        }
//        codableProperties = [NSDictionary dictionaryWithDictionary:codableProperties];
//        
//        //make the association atomically so that we don't need to bother with an @synchronize
//        objc_setAssociatedObject([self class], _cmd, codableProperties, OBJC_ASSOCIATION_RETAIN);
//    }
//    return codableProperties;
//}
//
////将对象编码(即:序列化)
//-(void) encodeWithCoder:(NSCoder *)aCoder
//{
//    for (NSString *key in [self codableProperties])
//    {
//        id object = [self valueForKey:key];
//        if (object) [aCoder encodeObject:object forKey:key];
//    }
//}
//
////将对象解码(反序列化)
//-(id) initWithCoder:(NSCoder *)aDecoder
//{
//    if (self=[super init])
//    {
//        for (NSString *key in [self codableProperties])
//        {
//            [self setValue:[aDecoder decodeObjectForKey:key] forKey:key];
//        }
//    }
//    return (self);
//    
//}

@end