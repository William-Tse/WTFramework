//
//   ▼▲       ▲▼  ▼▲▼▲▼▲▼▲▼▲▼
//    ▼▲  ▲  ▲▼       ▲▼
//     ▼▲▼ ▼▲▼        ▲▼
//      ▼   ▼         ▲▼
//
//  Copyright © 2016 WTFramework. All rights reserved.
//  Created by William.Tse on 16/7/14.
//
//  NSList+WT_Extension.m
//  WTFramework
//

#import "NSList+WT_Extension.h"

@implementation NSList (WT_Extension)

+ (Class)itemClass
{
    NSString *className = NSStringFromClass([self class]);
    NSString *prefix = @"__WTArrayList_";
    if([className hasPrefix:prefix])
    {
        return NSClassFromString([className substringFromIndex:prefix.length]);
    }
    return nil;
}

- (id)safeObjectAtIndex:(NSUInteger)index
{
    if(index < self.count)
    {
        return [self objectAtIndex:index];
    }
    return nil;
}

- (NSList *)map:(BlockArrayEnumerator)block
{
    NSList *result = [[[[self class] itemClass] alloc] init];
    for (NSInteger i=0; i<self.count; ++i) {
        id item = [self objectAtIndex:i];
        id obj = block(item, i);
        if(obj) {
            [result addObject:obj];
        }
    }
    return result;
}

- (BOOL)exist:(BlockArrayPredicate)block
{
    for (NSInteger i=0; i<self.count; ++i) {
        id item = [self objectAtIndex:i];
        if(block(item, i)){
            return YES;
        }
    }
    return NO;
}

- (NSUInteger)indexOf:(BlockArrayPredicate)block
{
    for (NSInteger i=0; i<self.count; ++i) {
        id item = [self objectAtIndex:i];
        if(block(item, i)) {
            return i;
        }
    }
    return NSNotFound;
}

- (id)findFirst:(BlockArrayPredicate)block
{
    for (NSInteger i=0; i<self.count; ++i) {
        id item = [self objectAtIndex:i];
        if(block(item, i)) {
            return item;
        }
    }
    return nil;
}

- (id)findLast:(BlockArrayPredicate)block
{
    for (NSInteger i=self.count-1; i>=0; --i) {
        id item = [self objectAtIndex:i];
        if(block(item, i)) {
            return item;
        }
    }
    return nil;
}

- (NSArray *)findAll:(BlockArrayPredicate)block
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (NSInteger i=0; i<self.count; ++i) {
        id item = [self objectAtIndex:i];
        if(block(item, i)) {
            [arr addObject:item];
        }
    }
    return arr;
}

- (NSArray *)findMany:(BlockArrayMany)block
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (NSInteger i=0; i<self.count; ++i) {
        id item = [self objectAtIndex:i];
        [arr addObjectsFromArray:block(item, i)];
    }
    return arr;
}

- (id)removeFirst:(BlockArrayPredicate)block
{
    for (NSInteger i=0; i<self.count; ++i) {
        id item = [self objectAtIndex:i];
        if(block(item , i))
        {
            [self removeObjectAtIndex:i];
            return item;
        }
    }
    return nil;
}

- (id)removeLast:(BlockArrayPredicate)block
{
    for (NSInteger i=self.count-1; i>=0; --i) {
        id item = [self objectAtIndex:i];
        if(block(item , i))
        {
            [self removeObjectAtIndex:i];
            return item;
        }
    }
    return nil;
}

- (NSArray *)removeAll:(BlockArrayPredicate)block
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    for (NSInteger i=self.count-1; i>=0; --i) {
        id item = [self objectAtIndex:i];
        if(block(item , i))
        {
            [arr insertObject:item atIndex:0];
            [self removeObjectAtIndex:i];
            return item;
        }
    }
    return arr;
}

@end
