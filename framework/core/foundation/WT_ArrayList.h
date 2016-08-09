//
//   ▼▲       ▲▼  ▼▲▼▲▼▲▼▲▼▲▼
//    ▼▲  ▲  ▲▼       ▲▼
//     ▼▲▼ ▼▲▼        ▲▼
//      ▼   ▼         ▲▼
//
//  Copyright © 2016 WTFramework. All rights reserved.
//  Created by William.Tse on 16/7/14.
//
//  WT_ArrayList.h
//  WTFramework
//

#import "WT_Precompile.h"

@class __WTArrayList;

@compatibility_alias NSList __WTArrayList;

@interface __WTArrayList : NSObject <NSCopying, NSMutableCopying, NSFastEnumeration>

@property (nonatomic, readonly, assign) NSUInteger count;
@property (nonatomic, readonly, strong) id firstObject;
@property (nonatomic, readonly, strong) id lastObject;

+ (instancetype)list;
+ (instancetype)listWithCapacity:(NSUInteger)capacity;
+ (instancetype)listWithArray:(NSArray *)array;
+ (instancetype)listWithList:(NSList *)list;
+ (instancetype)listWithObject:(id)object;
+ (instancetype)listWithObjects:(id)object, ...;

- (instancetype)initWithCapacity:(NSUInteger)capacity;
- (instancetype)initWithArray:(NSArray *)array;
- (instancetype)initWithList:(NSList *)array;
- (instancetype)initWithObject:(id)object;
- (instancetype)initWithObjects:(id)object, ...;

- (void)addObject:(id)object;
- (void)addObjectsFromArray:(NSArray *)array;
- (void)addObjectsFromList:(NSList *)list;

- (void)setObject:(id)object atIndexedSubscript:(NSUInteger)index;
- (void)insertObject:(id)object atIndex:(NSUInteger)index;
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(id)object;
- (void)exchangeObjectAtIndex:(NSUInteger)index1 withObjectAtIndex:(NSUInteger)index2;

- (void)removeObject:(id)object;
- (void)removeObjectAtIndex:(NSUInteger)index;
- (void)removeLastObject;
- (void)removeObjectsInArray:(NSArray *)array;
- (void)removeObjectsInList:(NSList *)list;
- (void)removeAllObjects;

- (id)objectAtIndex:(NSUInteger)index;
- (NSUInteger)indexOfObject:(id)object;

- (NSArray *)subarrayWithRange:(NSRange)range;
- (NSList *)sublistWithRange:(NSRange)range;

- (NSArray *)toArray;

- (void)sortedArrayUsingComparator:(NSComparisonResult (^)(id obj1, id obj2))comparator;

@end
