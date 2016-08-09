//
//   ▼▲       ▲▼  ▼▲▼▲▼▲▼▲▼▲▼
//    ▼▲  ▲  ▲▼       ▲▼
//     ▼▲▼ ▼▲▼        ▲▼
//      ▼   ▼         ▲▼
//
//  Copyright © 2016 WTFramework. All rights reserved.
//  Created by William.Tse on 16/7/14.
//
//  WT_Property.h
//  WTFramework
//

#import "WT_Precompile.h"
#import "WT_Runtime.h"

#pragma mark -

#undef	static_property
#define static_property( __name ) \
		property (nonatomic, readonly) NSString * __name; \
		- (NSString *)__name; \
		+ (NSString *)__name;

#undef	def_static_property
#define def_static_property( __name, ... ) \
		macro_concat(def_static_property, macro_count(__VA_ARGS__))(__name, __VA_ARGS__)

#undef	def_static_property0
#define def_static_property0( __name ) \
		dynamic __name; \
		- (NSString *)__name { return [NSString stringWithFormat:@"%s", #__name]; } \
		+ (NSString *)__name { return [NSString stringWithFormat:@"%s", #__name]; }

#undef	def_static_property1
#define def_static_property1( __name, A ) \
		dynamic __name; \
		- (NSString *)__name { return [NSString stringWithFormat:@"%@.%s", A, #__name]; } \
		+ (NSString *)__name { return [NSString stringWithFormat:@"%@.%s", A, #__name]; }

#undef	def_static_property2
#define def_static_property2( __name, A, B ) \
		dynamic __name; \
		- (NSString *)__name { return [NSString stringWithFormat:@"%@.%@.%s", A, B, #__name]; } \
		+ (NSString *)__name { return [NSString stringWithFormat:@"%@.%@.%s", A, B, #__name]; }

#undef	def_static_property3
#define def_static_property3( __name, A, B, C ) \
		dynamic __name; \
		- (NSString *)__name { return [NSString stringWithFormat:@"%@.%@.%@.%s", A, B, C, #__name]; } \
		+ (NSString *)__name { return [NSString stringWithFormat:@"%@.%@.%@.%s", A, B, C, #__name]; }

#define def_prop_custom( type, name, setName, attr ) \
		dynamic name; \
		- (type)name { return [self getAssociatedObjectForKey:#name]; } \
		- (void)setName:(type)obj { [self attr##AssociatedObject:obj forKey:#name]; }

#pragma mark -

@interface WTProperty : NSObject

@property (nonatomic, copy) NSString *name;
@property (nonatomic, strong) id value;
@property (nonatomic, strong) Class clazz;
@property (nonatomic, assign) BOOL readonly;
@property (nonatomic, assign, readonly) WTRuntimeType runtimeType;
@property (nonatomic, assign, readonly) BOOL isAtom;

@end

@interface NSObject(WT_Property)

+ (const char *)attributesForProperty:(NSString *)property;

- (id)getAssociatedObjectForKey:(const char *)key;
- (id)copyAssociatedObject:(id)obj forKey:(const char *)key;
- (id)retainAssociatedObject:(id)obj forKey:(const char *)key;
- (id)assignAssociatedObject:(id)obj forKey:(const char *)key;
- (void)removeAssociatedObjectForKey:(const char *)key;
- (void)removeAllAssociatedObjects;

@end
