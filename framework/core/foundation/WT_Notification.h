//
//   ▼▲       ▲▼  ▼▲▼▲▼▲▼▲▼▲▼
//    ▼▲  ▲  ▲▼       ▲▼
//     ▼▲▼ ▼▲▼        ▲▼
//      ▼   ▼         ▲▼
//
//  Copyright © 2016 WTFramework. All rights reserved.
//  Created by William.Tse on 16/7/14.
//
//  WT_Notification.h
//  WTFramework
//

#import "WT_Precompile.h"
#import "WT_Property.h"

#undef	notification
#define notification( name ) \
static_property( name )

#undef	def_notification
#define def_notification( name ) \
def_static_property2( name, @"notification", NSStringFromClass([self class]) )

#define ON_NOTIFICATION(notification) \
- (void)onNotification:(NSNotification *)notification

#pragma mark -

typedef NSNotification WTNotification;

@interface NSNotification(WT_Extension)

- (BOOL)is:(NSString *)name;
- (BOOL)isKindOf:(NSString *)prefix;

@end

@interface NSObject(WT_Notification)

- (void)onNotification:(NSNotification *)notification;

- (void)observeNotification:(NSString *)name;
- (void)observeAllNotifications;

- (void)unobserveNotification:(NSString *)name;
- (void)unobserveAllNotifications;

+ (BOOL)postNotification:(NSString *)name;
+ (BOOL)postNotification:(NSString *)name withObject:(id)object;

- (BOOL)postNotification:(NSString *)name;
- (BOOL)postNotification:(NSString *)name withObject:(id)object;

@end
