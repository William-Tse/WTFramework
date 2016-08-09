//
//   ▼▲       ▲▼  ▼▲▼▲▼▲▼▲▼▲▼
//    ▼▲  ▲  ▲▼       ▲▼
//     ▼▲▼ ▼▲▼        ▲▼
//      ▼   ▼         ▲▼
//
//  Copyright © 2016 WTFramework. All rights reserved.
//  Created by William.Tse on 16/7/14.
//
//  NSDictionary+WT_Extension.h
//  WTFramework
//

#import "WT_Precompile.h"
#import "WT_Generic.h"

NS_ASSUME_NONNULL_BEGIN

typedef BOOL (^ BlockDictionaryPredicate)(id key, id value);


@class WTKeyValuePair;

@compatibility_alias NSKeyValuePair WTKeyValuePair;

@interface WTKeyValuePair : NSObject

@property (nonatomic, strong, readonly) id key;
@property (nonatomic, strong, readonly) id value;

+ (instancetype)pairWithValue:(id)value forKey:(id)key;
- (instancetype)initWithValue:(id)value forKey:(id)key;

@end

@generic(WTKeyValuePair)

#pragma mark -

@interface NSDictionary (WT_Extension)

- (nullable WTKeyValuePair *)findOne:(BlockDictionaryPredicate)block;
- (NSArray<WTKeyValuePair *> *)findAll:(BlockDictionaryPredicate)block;

@end

@interface NSMutableDictionary (WT_Extension)

- (nullable WTKeyValuePair *)removeOne:(BlockDictionaryPredicate)block;
- (NSArray<WTKeyValuePair *> *)removeAll:(BlockDictionaryPredicate)block;

@end

NS_ASSUME_NONNULL_END
