//
//   ▼▲       ▲▼  ▼▲▼▲▼▲▼▲▼▲▼
//    ▼▲  ▲  ▲▼       ▲▼
//     ▼▲▼ ▼▲▼        ▲▼
//      ▼   ▼         ▲▼
//
//  Copyright © 2016 WTFramework. All rights reserved.
//  Created by William.Tse on 16/7/14.
//
//  WT_Generic.h
//  WTFramework
//

#import "WT_ArrayList.h"

#define List(__className) __WTArrayList_##__className

#undef generic
#define generic( __className ) \
interface __WTArrayList_##__className : __WTArrayList\
- (void)addObject:(__className *)object;\
- (void)insertObject:(__className *)object atIndex:(NSUInteger)index;\
- (void)removeObject:(__className *)object; \
- (__className *)objectAtIndex:(NSUInteger)index;\
- (void)replaceObjectAtIndex:(NSUInteger)index withObject:(__className *)object;\
- (NSArray<__className *> *)toArray;\
@end\
\
@interface __className (WT_Generic)\
+ (Class)listClass;\
@end



#undef	def_generic
#define def_generic(__className)\
implementation __WTArrayList_##__className\
- (void)addObject:(__className *)object {\
    [super addObject:object];\
}\
-(void)insertObject:(__className *)object atIndex:(NSUInteger)index {\
    [super insertObject:object atIndex:index];\
}\
-(void)removeObject:(__className *)object {\
    [super removeObject:object];\
}\
-(__className *)objectAtIndex:(NSUInteger)index {\
    return [super objectAtIndex:index];\
}\
-(void)replaceObjectAtIndex:(NSUInteger)index withObject:(__className *)object {\
    [super replaceObjectAtIndex:index withObject:object];\
}\
- (NSArray<__className *> *)toArray {\
    return (NSArray<__className *> *)[super toArray];\
}\
@end\
\
@implementation __className (WT_Generic)\
+ (Class)listClass {\
    return [__WTArrayList_##__className class];\
}\
@end

@generic(NSString);
@generic(NSNumber);
@generic(NSDate);
@generic(NSURL);

