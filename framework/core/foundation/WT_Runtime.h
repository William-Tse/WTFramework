//
//   ▼▲       ▲▼  ▼▲▼▲▼▲▼▲▼▲▼
//    ▼▲  ▲  ▲▼       ▲▼
//     ▼▲▼ ▼▲▼        ▲▼
//      ▼   ▼         ▲▼
//
//  Copyright © 2016 WTFramework. All rights reserved.
//  Created by William.Tse on 16/7/14.
//
//  WT_Runtime.h
//  WTFramework
//

#import "WT_Precompile.h"

#import "_pragma_push.h"

#pragma clang diagnostic ignored "-Wunused-function"

NS_ASSUME_NONNULL_BEGIN

static void blockCleanUp(__strong void(^ __nullable * __nullable block)(void)) {
    (*block)();
}

#define onExit \
    __strong void(^block)(void) __attribute__((cleanup(blockCleanUp), unused)) = ^

typedef NS_ENUM(NSInteger, WTRuntimeType)
{
    WTRuntimeTypeUnknown = 0,
    WTRuntimeTypeObject,
    WTRuntimeTypeNumber,
    WTRuntimeTypeString,
    WTRuntimeTypeDate,
    WTRuntimeTypeData,
    WTRuntimeTypeUrl,
    WTRuntimeTypeDictionary,
    WTRuntimeTypeArray,
    WTRuntimeTypeList
};

@interface WTRuntime : NSObject

+ (BOOL)isReadOnly:(const char *)attr;

+ (WTRuntimeType)typeOfAttribute:(const char *)attr;
+ (WTRuntimeType)typeOfClass:(Class)typeClazz;
+ (WTRuntimeType)typeOfObject:(id)obj;

+ (NSString *)classNameOfAttribute:(const char *)attr;
+ (Class)classOfAttribute:(const char *)attr;

+ (BOOL)isAtomClass:(Class)clazz;

@end

NS_ASSUME_NONNULL_END

#import "_pragma_pop.h"
