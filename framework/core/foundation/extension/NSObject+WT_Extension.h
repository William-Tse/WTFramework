//
//   ▼▲       ▲▼  ▼▲▼▲▼▲▼▲▼▲▼
//    ▼▲  ▲  ▲▼       ▲▼
//     ▼▲▼ ▼▲▼        ▲▼
//      ▼   ▼         ▲▼
//
//  Copyright © 2016 WTFramework. All rights reserved.
//  Created by William.Tse on 16/7/14.
//
//  NSObject+WT_TypeConversion.h
//  WTFramework
//

#import "WT_Precompile.h"
#import "WT_Generic.h"
#import "WT_Property.h"

NS_ASSUME_NONNULL_BEGIN

#pragma mark -

@interface NSObject(WT_Extension)

- (nullable NSNumber *)toNumber;
- (nullable NSString *)toString;
- (nullable NSDate *)toDate;
- (nullable NSData *)toData;
- (nullable NSURL *)toURL;

@end

@interface NSObject(WT_Serialize)

+ (instancetype)objectFromDictionary:(NSDictionary *)dictionary;
+ (NSArray *)objectsFromArray:(NSArray *)array;

+ (instancetype)objectFromJSONString:(NSString *)json;
+ (NSArray *)objectsFromJSONString:(NSString *)json;

- (nullable id)serialize;
- (nullable id)deserialize;

- (nullable NSString *)toJSONString;
- (nullable NSString *)toXMLString;

- (nullable NSDictionary *)toDictionary;
- (nullable id)toObjectWithClass:(Class)cls;
- (nullable NSArray *)toArrayWithClass:(Class)cls;

- (nullable NSDictionary *)toQueryParameters;
- (NSString *)toQueryString;

@end

@interface NSObject(WT_Runtime)

+ (Class)baseClass;
+ (NSArray *)subClasses;

+ (NSArray *)methods;
+ (NSArray *)methodsUntilClass:(__nullable Class)baseClass;
+ (NSArray *)methodsWithPrefix:(NSString *)prefix;
+ (NSArray *)methodsWithPrefix:(NSString *)prefix untilClass:(__nullable Class)baseClass;

+ (NSArray *)properties;
+ (NSArray *)propertiesUntilClass:(__nullable Class)baseClass;

+ (NSArray *)classesWithProtocolName:(NSString *)protocolName;

+ (void *)replaceSelector:(SEL)sel1 withSelector:(SEL)sel2;

- (id)performSelectorSafetyWithName:(NSString *)selName;
- (id)performSelectorSafetyWithName:(NSString *)selName withObject:(nullable id)object;

@end

@interface NSObject(WT_Loader)

- (void)load;
- (void)unload;

- (void)performLoad;
- (void)performUnload;

@end

NS_ASSUME_NONNULL_END