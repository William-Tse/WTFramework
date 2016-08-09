//
//   ▼▲       ▲▼  ▼▲▼▲▼▲▼▲▼▲▼
//    ▼▲  ▲  ▲▼       ▲▼
//     ▼▲▼ ▼▲▼        ▲▼
//      ▼   ▼         ▲▼
//
//  Copyright © 2016 WTFramework. All rights reserved.
//  Created by William.Tse on 16/7/14.
//
//  NSDictionary+WT_Extension.m
//  WTFramework
//

#import "NSDictionary+WT_Extension.h"

@implementation WTKeyValuePair

+ (instancetype)pairWithValue:(id)value forKey:(id)key
{
    return [[self alloc] initWithValue:value forKey:key];
}

- (instancetype)initWithValue:(id)value forKey:(id)key
{
    self = [super init];
    if(self)
    {
        _value = value;
        _key = key;
    }
    return self;
}

@end

@def_generic(WTKeyValuePair)

@implementation NSDictionary (WT_Extension)

- (nullable WTKeyValuePair *)findOne:(BlockDictionaryPredicate)block
{
    for(id key in self.allKeys) {
        id value = [self objectForKey:key];
        if(block(key , value))
        {
            return [WTKeyValuePair pairWithValue:value forKey:key];
        }
    }
    return nil;
}

- (NSArray<WTKeyValuePair *> *)findAll:(BlockDictionaryPredicate)block
{
    NSMutableArray<WTKeyValuePair *> *arr = [[NSMutableArray<WTKeyValuePair *> alloc] init];
    for(id key in self.allKeys) {
        id value = [self objectForKey:key];
        if(block(key , value))
        {
            [arr insertObject:[WTKeyValuePair pairWithValue:value forKey:key] atIndex:0];
        }
    }
    return arr;
}

@end

@implementation NSMutableDictionary (WT_Extension)

- (nullable WTKeyValuePair *)removeOne:(BlockDictionaryPredicate)block
{
    WTKeyValuePair *pair = [self findOne:block];
    if(pair)
    {
        [self removeObjectForKey:pair.key];
    }
    return pair;
}

- (NSArray *)removeAll:(BlockDictionaryPredicate)block
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    NSArray *arrKeys = self.allKeys;
    for(NSInteger i=arrKeys.count-1; i>=0; --i) {
        id key = arrKeys[i];
        id value = [self objectForKey:key];
        if(block(key , value))
        {
            [arr insertObject:[WTKeyValuePair pairWithValue:value forKey:key] atIndex:0];
            [self removeObjectForKey:key];
        }
    }
    return arr;
}

@end
