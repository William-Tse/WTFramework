//
//   ▼▲       ▲▼  ▼▲▼▲▼▲▼▲▼▲▼
//    ▼▲  ▲  ▲▼       ▲▼
//     ▼▲▼ ▼▲▼        ▲▼
//      ▼   ▼         ▲▼
//
//  Copyright © 2016 WTFramework. All rights reserved.
//  Created by William.Tse on 16/7/14.
//
//  NSList+WT_Extension.h
//  WTFramework
//

#import "WT_Precompile.h"
#import "NSArray+WT_Extension.h"

@interface NSList (WT_Extension)

+ (Class)itemClass;

- (id)safeObjectAtIndex:(NSUInteger)index;

- (__kindof NSList *)map:(BlockArrayEnumerator)block;

- (BOOL)exist:(BlockArrayPredicate)block;
- (NSUInteger)indexOf:(BlockArrayPredicate)block;

- (id)findFirst:(BlockArrayPredicate)block;
- (id)findLast:(BlockArrayPredicate)block;
- (__kindof NSList *)findAll:(BlockArrayPredicate)block;
- (__kindof NSList *)findMany:(BlockArrayMany)block;

- (id)removeFirst:(BlockArrayPredicate)block;
- (id)removeLast:(BlockArrayPredicate)block;
- (__kindof NSList *)removeAll:(BlockArrayPredicate)block;

@end
