//
//   ▼▲       ▲▼  ▼▲▼▲▼▲▼▲▼▲▼
//    ▼▲  ▲  ▲▼       ▲▼
//     ▼▲▼ ▼▲▼        ▲▼
//      ▼   ▼         ▲▼
//
//  Copyright © 2016 WTFramework. All rights reserved.
//  Created by William.Tse on 16/7/14.
//
//  WT_ArrayList.m
//  WTFramework
//

#import "WT_ArrayList.h"

@implementation NSList
{
    NSMutableArray *_arr;
}

-(NSUInteger)count
{
    return _arr.count;
}

-(id)firstObject
{
    return _arr.firstObject;
}

-(id)lastObject
{
    return _arr.lastObject;
}

+ (instancetype)list
{
    return [[[self class] alloc] init];
}

+ (instancetype)listWithCapacity:(NSUInteger)capacity
{
    return [[[self class] alloc] initWithCapacity:capacity];
}

+ (instancetype)listWithArray:(NSArray *)array
{
    return [[[self class] alloc] initWithArray:array];
}

+ (instancetype)listWithList:(NSList *)list
{
    return [[[self class] alloc] initWithList:list];
}

+ (instancetype)listWithObject:(id)object
{
    return [[[self class] alloc] initWithObject:object];
}

+ (instancetype)listWithObjects:(id)object, ...
{
    NSMutableArray *arr = [[NSMutableArray alloc] init];
    id eachObject;
    va_list argumentList;
    if (object)
    {
        va_start(argumentList, object);
        while (eachObject == va_arg(argumentList, id))
        {
            [arr addObject:eachObject];
        }
        va_end(argumentList);
    }
    return [self listWithArray:arr];
}

- (instancetype)init
{
    self = [super init];
    if(self)
    {
        _arr = [[NSMutableArray alloc] init];
    }
    return self;
}

- (instancetype)initWithCapacity:(NSUInteger)capacity
{
    self = [super init];
    if(self)
    {
        _arr = [[NSMutableArray alloc] initWithCapacity:capacity];
    }
    return self;
}

- (instancetype)initWithArray:(NSArray *)array
{
    self = [self init];
    if(self)
    {
        [_arr addObjectsFromArray:array];
    }
    return self;
}

- (instancetype)initWithList:(NSList *)array
{
    self = [self init];
    if(self)
    {
        [_arr addObjectsFromArray:[array toArray]];
    }
    return self;
}

- (instancetype)initWithObject:(id)object
{
    self = [self init];
    if(self)
    {
        if(object)
        {
            [_arr addObject:object];
        }
    }
    return self;
}

- (instancetype)initWithObjects:(id)object, ...
{
    self = [self init];
    if(self)
    {
        id eachObject;
        va_list argumentList;
        if (object)
        {
            va_start(argumentList, object);
            while (eachObject == va_arg(argumentList, id))
            {
                [_arr addObject:eachObject];
            }
            va_end(argumentList);
        }
    }
    return self;
}

- (void)addObject:(id)object
{
    [_arr addObject:object];
}

- (void)addObjectsFromArray:(NSArray *)array
{
    [_arr addObjectsFromArray:array];
}

- (void)addObjectsFromList:(NSList *)list
{
    [_arr addObjectsFromArray:[list toArray]];
}

- (void)setObject:(id)object atIndexedSubscript:(NSUInteger)index
{
    [_arr setObject:object atIndexedSubscript:index];
}

- (void)insertObject:(id)object atIndex:(NSUInteger)index
{
    [_arr insertObject:object atIndex:index];
}

- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)object
{
    [_arr replaceObjectAtIndex:index withObject:object];
}

- (void)exchangeObjectAtIndex:(NSUInteger)index1 withObjectAtIndex:(NSUInteger)index2;
{
    [_arr exchangeObjectAtIndex:index1 withObjectAtIndex:index2];
}

- (void)removeObject:(id)object
{
    [_arr removeObject:object];
}

- (void)removeObjectAtIndex:(NSUInteger)index
{
    [_arr removeObjectAtIndex:index];
}

- (void)removeLastObject
{
    [_arr removeLastObject];
}

- (void)removeObjectsInArray:(NSArray *)array
{
    [_arr removeObjectsInArray:array];
}

- (void)removeObjectsInList:(NSList *)list
{
    [self removeObjectsInArray:[list toArray]];
}

- (void)removeAllObjects
{
    [_arr removeAllObjects];
}

- (id)objectAtIndex:(NSUInteger)index
{
    return [_arr objectAtIndex:index];
}

-(NSUInteger)indexOfObject:(id)object
{
    return [_arr indexOfObject:object];
}

- (NSArray *)subarrayWithRange:(NSRange)range
{
    return [_arr subarrayWithRange:range];
}

- (NSList *)sublistWithRange:(NSRange)range
{
    return [[self class] listWithArray:[_arr subarrayWithRange:range]];
}

-(NSArray *)toArray
{
    return _arr;
}

- (void)sortedArrayUsingComparator:(NSComparisonResult (^)(id obj1, id obj2))comparator
{
    return [_arr sortUsingComparator:comparator];
}

- (id)copyWithZone:(nullable NSZone *)zone
{
    return [[[self class] allocWithZone:zone] initWithArray:[_arr copyWithZone:zone]];
}

- (id)mutableCopyWithZone:(nullable NSZone *)zone
{
    return [[[self class] allocWithZone:zone] initWithArray:[_arr mutableCopyWithZone:zone]];
}

- (NSUInteger)countByEnumeratingWithState:(NSFastEnumerationState *)state objects:(id __unsafe_unretained [])buffer count:(NSUInteger)len
{
    return [_arr countByEnumeratingWithState:state objects:buffer count:len];
}

@end
