//
//   ▼▲       ▲▼  ▼▲▼▲▼▲▼▲▼▲▼
//    ▼▲  ▲  ▲▼       ▲▼
//     ▼▲▼ ▼▲▼        ▲▼
//      ▼   ▼         ▲▼
//
//  Created by William.Tse on 16/7/14.
//  Copyright © 2016 WTFramework. All rights reserved.
//
//  WT_Signal.h
//  WTFramework
//

#import "WT_Precompile.h"
#import "WT_Property.h"

#pragma mark -

@class WTSignal;

#undef	signal
#define signal( name ) \
static_property( name )

#undef	def_signal
#define def_signal( name ) \
def_static_property2( name, @"signal", NSStringFromClass([self class]) )


#define ON_SIGNAL(signal ) \
- (void)onSignal:(WTSignal *)signal

#define ON_SIGNAL2( filter, signal ) \
- (void)onSignal_##filter:(WTSignal *)signal

#define ON_SIGNAL3( filter, event, signal ) \
- (void)onSignal_##filter##_##event:(WTSignal *)signal

@class WTSignal;

@compatibility_alias NSSignal WTSignal;

NS_ASSUME_NONNULL_BEGIN

typedef void  (^WTSignalBlock)( WTSignal *signal );

@interface WTSignal : NSObject

/*!
 * get signal name
 */
@property (nonatomic, copy, readonly) NSString *name;
/*!
 * get signal event trigger target
 */
@property (nonatomic, weak, readonly) __kindof UIResponder * target;
/*!
 * get signal send from source
 */
@property (nonatomic, weak, readonly) __kindof UIResponder * source;
/*!
 * get signal data-binding object
 */
@property (nullable, nonatomic, strong, readonly) id object;
/*!
 * get or set signal has handled or not, to stop or continue propagation upward.
 */
@property (nonatomic, assign) BOOL handled;

+ (instancetype)signalWithName:(NSString *)name target:(UIResponder *)target;
+ (instancetype)signalWithName:(NSString *)name target:(UIResponder *)target object:(nullable id)object;

- (instancetype)init NS_UNAVAILABLE;
- (instancetype)initWithName:(NSString *)name target:(UIResponder *)target;
- (instancetype)initWithName:(NSString *)name target:(UIResponder *)target object:(nullable id)object;

- (void)forward;

@end

@interface UIResponder (WT_Signal)

- (NSArray *)signals;
- (BOOL)isListenedSignal:(NSString *)signal;

- (void)addSignalListener:(NSString *)signal;
- (void)addSignalListener:(NSString *)signal callback:(nullable WTSignalBlock)callback;

- (void)removeSignalListener:(NSString *)signal;

- (void)sendSignal:(NSString *)signal withObject:(nullable id)object;
- (void)sendSignal:(WTSignal *)signal;

@end

NS_ASSUME_NONNULL_END

