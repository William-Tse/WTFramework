//
//   ▼▲       ▲▼  ▼▲▼▲▼▲▼▲▼▲▼
//    ▼▲  ▲  ▲▼       ▲▼
//     ▼▲▼ ▼▲▼        ▲▼
//      ▼   ▼         ▲▼
//
//  Copyright © 2016 WTFramework. All rights reserved.
//  Created by William.Tse on 16/7/14.
//
//  NSArray+WT_Extension.h
//  WTFramework
//

#import "WT_Precompile.h"
#import "WT_Generic.h"

typedef id (^ BlockArrayEnumerator)(id item, NSInteger index);
typedef BOOL (^ BlockArrayPredicate)(id item, NSInteger index);
typedef NSArray * (^ BlockArrayMany)(id item, NSInteger index);

#pragma mark -

@interface NSArray (WT_Extension)

+ (instancetype)arrayWithList:(NSList *)list;
- (instancetype)initWithList:(NSList *)list;
- (NSList *)toList:(Class)itemClass;

- (id)safeObjectAtIndex:(NSUInteger)index;

+ (NSArray *)makeArray:(id (^)(NSUInteger index))block count:(NSInteger)count;

- (NSArray *)map:(BlockArrayEnumerator)block;

- (BOOL)exist:(BlockArrayPredicate)block;
- (NSUInteger)indexOf:(BlockArrayPredicate)block;

- (id)findFirst:(BlockArrayPredicate)block;
- (id)findLast:(BlockArrayPredicate)block;
- (NSArray *)findAll:(BlockArrayPredicate)block;
- (NSArray *)findMany:(BlockArrayMany)block;


@end

@interface NSMutableArray (WT_Extension)

- (void)addObjectsFromList:(NSList *)list;
- (void)removeObjectsInList:(NSList *)list;

- (id)removeFirst:(BlockArrayPredicate)block;
- (id)removeLast:(BlockArrayPredicate)block;
- (NSArray *)removeAll:(BlockArrayPredicate)block;

@end
