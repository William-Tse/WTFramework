//
//   ▼▲       ▲▼  ▼▲▼▲▼▲▼▲▼▲▼
//    ▼▲  ▲  ▲▼       ▲▼
//     ▼▲▼ ▼▲▼        ▲▼
//      ▼   ▼         ▲▼
//
//  Copyright © 2016 WTFramework. All rights reserved.
//  Created by William.Tse on 16/7/14.
//
//  NSArray+WT_Extension.m
//  WTFramework
//

#import "NSArray+WT_Extension.h"

@implementation NSArray (WT_Extension)

+ (instancetype)arrayWithList:(NSList *)list
{
    return [[[self class] alloc] initWithList:list];
}

- (instancetype)initWithList:(NSList *)list
{
    return [self initWithArray:[list toArray]];
}

- (NSList *)toList:(Class)itemClass
{
    Class listClass = [itemClass listClass];
    if(listClass)
    {
        NSList *list = [[listClass alloc] init];
        for (id item in self) {
            if([item isKindOfClass:itemClass]){
                [list addObject:item];
            }
        }
        return list;
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

+ (NSArray *)makeArray:(id (^)(NSUInteger))block count:(NSInteger)count
{
    NSMutableArray *arr = [[NSMutableArray alloc] initWithCapacity:count];
    for(NSInteger i=0; i<count; ++i)
    {
        id item = block(i);
        if(item){
            [arr setObject:item atIndexedSubscript:i];
        }
    }
    return arr;
}

- (NSArray *)map:(BlockArrayEnumerator)block
{
    NSMutableArray *result = [[NSMutableArray alloc] init];
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

@end

@implementation NSMutableArray (WT_Extension)

- (void)addObjectsFromList:(NSList *)list
{
    [self addObjectsFromArray:[list toArray]];
}

- (void)removeObjectsInList:(NSList *)list
{
    [self removeObjectsInArray:[list toArray]];
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
        }
    }
    return arr;
}

@end
