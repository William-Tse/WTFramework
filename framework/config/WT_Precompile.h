//
//   ▼▲       ▲▼  ▼▲▼▲▼▲▼▲▼▲▼
//    ▼▲  ▲  ▲▼       ▲▼
//     ▼▲▼ ▼▲▼        ▲▼
//      ▼   ▼         ▲▼
//
//  Copyright © 2016 WTFramework. All rights reserved.
//  Created by William.Tse on 16/7/14.
//
//  WT_Precompile.h
//  WTFramework
//


#import <objc/runtime.h>

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

// ----------------------------------
// Common use macros
// ----------------------------------

#ifndef	__deprecated
#define	__deprecated			__attribute__((deprecated))
#endif

#ifndef	__inline
#define	__inline				__inline__ __attribute__((always_inline))
#endif

// ----------------------------------
// Code block
// ----------------------------------

#ifndef	weakify
#define weakify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
autoreleasepool{} __weak __typeof__(x) __weak_##x##__ = x; \
_Pragma("clang diagnostic pop")
#endif

#ifndef	strongify
#define strongify( x ) \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Wshadow\"") \
try{} @finally{} __typeof__(x) x = __weak_##x##__; \
_Pragma("clang diagnostic pop")
#endif

typedef id	 BlockType;
typedef void (^ BlockAction )( void );
typedef void (^ BlockCallback )( id first );
typedef void (^ BlockCallbackN )( id first, ... );
typedef BOOL (^ BlockPredicate )( id first );
typedef BOOL (^ BlockPredicateN )( id first, ... );
typedef id   (^ BlockFunction )( id first );
typedef id   (^ BlockFunctionN )( id first, ... );

// ----------------------------------
// Meta macro（from extobjc by Justin Spahr-Summers）
// ----------------------------------

#define macro_first(...)									macro_first_( __VA_ARGS__, 0 )
#define macro_first_( A, ... )								A

#define macro_concat( A, B )								macro_concat_( A, B )
#define macro_concat_( A, B )								A##B

#define macro_count(...)									macro_at( 8, __VA_ARGS__, 8, 7, 6, 5, 4, 3, 2, 1 )
#define macro_more(...)										macro_at( 8, __VA_ARGS__, 1, 1, 1, 1, 1, 1, 1, 1 )

#define macro_at0(...)										macro_first(__VA_ARGS__)
#define macro_at1(_0, ...)									macro_first(__VA_ARGS__)
#define macro_at2(_0, _1, ...)								macro_first(__VA_ARGS__)
#define macro_at3(_0, _1, _2, ...)							macro_first(__VA_ARGS__)
#define macro_at4(_0, _1, _2, _3, ...)						macro_first(__VA_ARGS__)
#define macro_at5(_0, _1, _2, _3, _4 ...)					macro_first(__VA_ARGS__)
#define macro_at6(_0, _1, _2, _3, _4, _5 ...)				macro_first(__VA_ARGS__)
#define macro_at7(_0, _1, _2, _3, _4, _5, _6 ...)			macro_first(__VA_ARGS__)
#define macro_at8(_0, _1, _2, _3, _4, _5, _6, _7, ...)		macro_first(__VA_ARGS__)
#define macro_at(N, ...)									macro_concat(macro_at, N)( __VA_ARGS__ )

#define macro_join0( ... )
#define macro_join1( A )									A
#define macro_join2( A, B )									A##____##B
#define macro_join3( A, B, C )								A##____##B##____##C
#define macro_join4( A, B, C, D )							A##____##B##____##C##____##D
#define macro_join5( A, B, C, D, E )						A##____##B##____##C##____##D##____##E
#define macro_join6( A, B, C, D, E, F )						A##____##B##____##C##____##D##____##E##____##F
#define macro_join7( A, B, C, D, E, F, G )					A##____##B##____##C##____##D##____##E##____##F##____##G
#define macro_join8( A, B, C, D, E, F, G, H )				A##____##B##____##C##____##D##____##E##____##F##____##G##____##H
#define macro_join( ... )									macro_concat(macro_join, macro_count(__VA_ARGS__))(__VA_ARGS__)

#define macro_cstr( A )										macro_cstr_( A )
#define macro_cstr_( A )									#A

#define macro_string( A )									macro_string_( A )
#define macro_string_( A )									@(#A)

// ----------------------------------
// Singleton
// ----------------------------------

#undef	singleton
#define singleton( __class ) \
    property (nonatomic, readonly) __class * sharedInstance; \
    - (instancetype)sharedInstance; \
    + (instancetype)sharedInstance;

#undef	def_singleton
#define def_singleton( __class ) \
    dynamic sharedInstance; \
    - (instancetype)sharedInstance \
    { \
        return [__class sharedInstance]; \
    } \
    + (instancetype)sharedInstance \
    { \
        static dispatch_once_t once; \
        static __strong id __singleton__ = nil; \
        dispatch_once( &once, ^{ __singleton__ = [[__class alloc] init]; } ); \
        return __singleton__; \
    }
