//
//   ▼▲       ▲▼  ▼▲▼▲▼▲▼▲▼▲▼
//    ▼▲  ▲  ▲▼       ▲▼
//     ▼▲▼ ▼▲▼        ▲▼
//      ▼   ▼         ▲▼
//
//  Copyright © 2016 WTFramework. All rights reserved.
//  Created by William.Tse on 16/7/14.
//
//  WT_Model+WT_Database.m
//  WTFramework
//

#import "WT_Model+WT_Database.h"

#import "NSObject+WT_Extension.h"
#import "NSArray+WT_Extension.h"

@implementation WTModel (WT_Database)

+ (NSString *)tableName
{
    return NSStringFromClass([self class]);
}

+ (WTDatabaseFieldAttribute)fieldOfProperty:(NSString *)prop
{
    WTDatabaseFieldAttribute field = {};
    SEL sel = NSSelectorFromString([NSString stringWithFormat:@"__field_%@", prop]);
    if([self respondsToSelector:sel])
    {
        NSMethodSignature *method = [self methodSignatureForSelector:sel];
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:method];
        invocation.target = self;
        invocation.selector = sel;
        [invocation invoke];
        [invocation getReturnValue:&field];
    }
    return field;
}

+ (__nullable id)primaryKey
{
    NSMutableArray *array = [NSMutableArray array];
    for(WTProperty *prop in [self properties])
    {
        if(prop.readonly)
            continue;
        
        WTDatabaseFieldAttribute field = [self fieldOfProperty:prop.name];
        if(field.primaryKey)
        {
            [array addObject:prop.name];
        }
    }
    if(array.count>1) {
        return array;
    } else if (array.count==1) {
        return [array objectAtIndex:0];
    }
    return nil;
}

+ (WTDatabase * (^)(WTDatabase *db))DB
{
    return ^ WTDatabase * (WTDatabase *db){
        db.modelClass = [self class];
        return db.CREATE();
    };
}

- (void (^)(WTDatabase *db))DELETE_FROM
{
    id primaryKey = [[self class] primaryKey];
    if(primaryKey)
    {
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        if([primaryKey isKindOfClass:[NSArray class]])
        {
            for (NSString *key in (NSArray *)primaryKey)
            {
                id value = [self valueForKey:key];
                [dict setObject:value?:[NSNull null] forKey:key];
            }
        }
        else
        {
            id value = [self valueForKey:primaryKey];
            [dict setObject:value?:[NSNull null] forKey:primaryKey];
        }
        return ^ (WTDatabase *db){
            db.modelClass = [self class];
            db.CREATE().WHERE(dict).DELETE();
        };
    }
    return ^ (WTDatabase *db){
        db.modelClass = [self class];
        NSLog(@"%@", @"Delete failed.");
    };
}

- (void (^)(WTDatabase *db))SAVE_INTO
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    NSArray *properties = [[self class] properties];
    for (WTProperty *prop in properties) {
        if(prop.readonly)
            continue;
        
        id value = [self valueForKey:prop.name];
        if(value)
        {
            if(prop.runtimeType != WTRuntimeTypeNumber && prop.runtimeType != WTRuntimeTypeString)
            {
                value = [value toJSONString];
            }
        }
        
        [dict setObject:value?:[NSNull null] forKey:prop.name];
    }
    
    return ^ (WTDatabase *db){
        db.modelClass = [self class];
        NSInteger pId = db.CREATE().SET(dict).REPLACE();
        
        if(pId>0)
        {
            id primaryKey = [[self class] primaryKey];
            if( primaryKey && [primaryKey isKindOfClass:[NSString class]])
            {
                [self setValue:@(pId) forKey:primaryKey];
            }
        }
    };
}

@end
